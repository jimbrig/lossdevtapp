#' Triangles Module
#'
#' @description
#' Shiny module containing `mod_triangles_ui` and `mod_triangles_server`, respectively.
#'
#' This module renders a user interface for displaying and analyzing actuarial
#' loss data in the form of loss development triangles.
#'
#' @name triangles_module
NULL

#' triangles UI Function
#'
#' @description A shiny Module.
#'
#' @param id,input,output,session Internal parameters for {shiny}.
#' @param loss_data non-reactive loss data.frame
#'
#' @rdname triangles_module
#'
#' @export
#'
#' @importFrom DT DTOutput
#' @importFrom shiny NS tagList fluidRow column icon helpText htmlOutput
#' @importFrom shinycssloaders withSpinner
#' @importFrom shinydashboard box
#' @importFrom shinyWidgets radioGroupButtons numericInputIcon
mod_triangles_ui <- function(id, loss_data = loss_data_all){

  ns <- shiny::NS(id)

  min_eval <- min(loss_data$eval_date, na.rm = TRUE)
  max_eval <- max(loss_data$eval_date, na.rm = TRUE)

  shiny::tagList(
    shiny::fluidRow(
      shinydashboard::box(
        width = 12,
        title = "Metrics",
        class = "text-center",
        collapsible = TRUE,
        shiny::fluidRow(
          shiny::column(
            width = 8,
            shinyWidgets::radioGroupButtons(
              inputId = ns("type"),
              label = "Loss Type", #icon_text("calculator", "Loss Type"),
              choices = c(
                "Paid Loss" = "paid",
                "Reported Loss" = "reported",
                "Case Reserves" = "case",
                "Reported Claim Counts" = "n_claims"
              ),
              selected = "paid"
            )
          ),
          shiny::column(
            width = 3,
            shinyWidgets::numericInputIcon(
              inputId = ns("lmt"),
              label = "Per Claim Limit (000s)",
              value = NA_real_,
              min = 0,
              step = 1,
              icon = shiny::icon("dollar-sign")
            ),
            shiny::helpText("Leave blank for Unlimited.")
          )
        )
      ),
      box(
        title = "Loss Development Triangle",
        width = 12,
        collapsible = TRUE,
        shiny::htmlOutput(ns("tri_title")),
        DT::DTOutput(ns("triangle")) |>
          shinycssloaders::withSpinner() #image = 'images/pwc_spinner_01.gif')
      ),
      div(
        id = ns("devt"),
        box(
          title = "Age to Age Triangle",
          collapsible = TRUE,
          width = 12,
          DT::DTOutput(ns("devt_factors")) |>
            shinycssloaders::withSpinner() #image = 'images/pwc_spinner_01.gif')
        )
      )
    )
  )
}


#' triangles server function
#'
#' @rdname triangles_module
#'
#' @param id ID associated with UI counterpart
#' @param loss_data loss data
#' @param selected_eval selected evaluation date
#'
#' @export
#'
#' @importFrom dplyr rename filter mutate bind_rows
#' @importFrom DT renderDT datatable JS formatCurrency
#' @importFrom purrr map2_dfr
#' @importFrom rlang set_names
#' @importFrom shiny moduleServer observeEvent renderUI reactive
#' @importFrom shinyjs show hide
#' @importFrom tibble add_row
#' @importFrom tidyr pivot_wider
mod_triangles_server <- function(id, loss_data, selected_eval){
  shiny::moduleServer( id, function(input, output, session){
    ns <- session$ns

    shiny::observeEvent(input$type, {
      if (input$type != "case") shinyjs::show("devt") else shinyjs::hide("devt")
    })

    output$tri_title <- shiny::renderUI({
      txt <- switch(input$type,
                    "paid" = "Paid Loss Development",
                    "reported" = "Reported Loss Development",
                    "case" = "Case Reserve Development",
                    "n_claims" = "Reported Claim Count Development")

      if (!is.na(input$lmt) && input$lmt != 0) {
        txt <- paste0(txt, " - Claims Limited to $", prettyNum(input$lmt * 1000, big.mark = ","))
      } else {
        txt <- paste0(txt, " - Unlimited Claims")
      }

      eval_txt <- paste0("Latest Evaluation Date of ", format(selected_eval(), "%B %d, %Y"))

      tagList(
        tags$h3(
          class = "text-center",
          txt
        ),
        tags$h4(
          class = "text-center",
          eval_txt
        )
      )

    })

    triangle_data <- reactive({

      # browser()

      lmt <- if (is.na(input$lmt)) NA else input$lmt * 1000
      type <- input$type

      agg_dat <- loss_data() |>
        aggregate_loss_data(limit = lmt)

      tri_dat <- dev_tri(
        origin = agg_dat$accident_year,
        age = agg_dat$devt,
        value = agg_dat[[type]]
      )

      tri <- tri_dat |>
        spread_tri() |>
        dplyr::rename(AYE = origin)

      if (type == "case") {
        return(
          list(
            "aggregate_data" = agg_dat,
            "triangle_data" = tri_dat,
            "triangle" = tri
          )
        )
      }

      ata_dat <- tri_dat |>
        ata_tri(loss_dat) |>
        dplyr::filter(!is.na(value))

      ata_tri <- ata_dat |>
        spread_tri() |>
        dplyr::rename(AYE = origin) |>
        dplyr::mutate(AYE = as.character(AYE))

      # ata_tri <- triangle_data[[input$type]]$age_to_age_triangle |>
      #   mutate(AYE = as.character(AYE))

      ldf_avg <- idf(ldf_avg(tri_dat)$idfs)

      ldf_avg_wtd <- idf(ldf_avg_wtd(tri_dat)$idfs)

      sel <- ldf_avg_wtd

      cdf <- idf2cdf(sel)

      params <- list("Straight Average:" = ldf_avg,
                     "Weighted Average:" = ldf_avg_wtd,
                     "Selected:" = sel,
                     "CDF:" = cdf)

      hold <- purrr::map2_dfr(params, names(params), function(dat, type_ ) {
        dat |>
          tidyr::pivot_wider(names_from = age, values_from = names(dat)[2]) |>
          rlang::set_names(names(ata_tri)) |>
          dplyr::mutate(AYE = type_)
      })

      list(
        "aggregate_data" = agg_dat,
        "triangle_data" = tri_dat,
        "triangle" = tri,
        "age_to_age_data" = ata_dat,
        "age_to_age_triangle" = ata_tri,
        "averages" = hold
      )
    })

    output$triangle <- DT::renderDT({
      out <- triangle_data()$triangle

      n_row <- nrow(out)
      col_width <- paste0(round(1/ncol(out),0) * 100, "%")

      hold <- DT::datatable(
        out,
        rownames = FALSE,
        caption = "Development Age in Months of Maturity",
        colnames = c("Accident Year", names(out)[-1]),
        extensions = c("Buttons"),
        selection = "none",
        class = "display",
        callback = DT::JS('return table'),
        options = list(
          dom = "Bt",
          paging = FALSE,
          scrollX = TRUE,
          buttons = list(
            list(
              extend = "excel",
              text = "Download",
              title = "dev-triangle"
            )
          ),
          ordering = FALSE,
          pageLength = n_row,
          columnDefs = list(
            list(targets = "_all", className = "dt-center", width = col_width)
          )
        )
      ) |>
        DT::formatCurrency(
          column = 2:length(out),
          currency = "",
          digits = 0
        )
    })

    devt_prep <- shiny::reactive({
      req(input$type != "case")

      out <- triangle_data()$age_to_age_triangle |>
        tibble::add_row()

      out <- dplyr::bind_rows(
        out,
        triangle_data()$averages
      )

      tail_df <- tibble(
        "tail" = rep(NA, times = nrow(out))
      )

      cbind(
        out,
        tail_df
      )

    })

  })
}

## To be copied in the UI
# mod_triangles_ui("triangles_1")

## To be copied in the server
# mod_triangles_server("triangles_1")
