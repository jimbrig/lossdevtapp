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
#' @param id Internal parameters for {shiny}.
#' @param loss_data non-reactive loss data.frame
#'
#' @rdname triangles_module
#'
#' @export
#'
#' @importFrom DT DTOutput
#' @importFrom shiny NS tagList fluidRow column icon helpText htmlOutput div
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
      shinydashboard::box(
        title = "Loss Development Triangle",
        width = 12,
        collapsible = TRUE,
        shiny::htmlOutput(ns("tri_title")),
        DT::DTOutput(ns("triangle")) |>
          shinycssloaders::withSpinner() #image = 'images/pwc_spinner_01.gif')
      ),
      shiny::div(
        id = ns("devt"),
        shinydashboard::box(
          title = "Age to Age Development Factors",
          width = 12,
          collapsible = TRUE,
          DT::DTOutput(ns("devt_factors")) |>
            shinycssloaders::withSpinner()
        ),

        shinydashboard::box(
          title = "Averages",
          width = 12,
          collapsible = TRUE,
          DT::DTOutput(ns("avgs")) |>
            shinycssloaders::withSpinner()
        ),

        shinydashboard::box(
          title = "Prior & Industry",
          width = 12,
          collapsible = TRUE,
          DT::DTOutput(ns("prior_and_industry")) |>
            shinycssloaders::withSpinner()
        ),

        shinydashboard::box(
          title = "Selections",
          width = 12,
          collapsible = TRUE,
          DT::DTOutput(ns("selections")) |>
            shinycssloaders::withSpinner()
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
#' @importFrom DT renderDT formatCurrency datatable JS
#' @importFrom purrr map2_dfr
#' @importFrom rlang set_names
#' @importFrom shiny moduleServer observeEvent renderUI tagList tags reactive req
#' @importFrom shinyjs show hide
#' @importFrom tibble add_row tibble
#' @importFrom tidyr pivot_wider
mod_triangles_server <- function(id, loss_data, selected_eval){
  shiny::moduleServer(id, function(input, output, session){

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

      shiny::tagList(
        shiny::tags$h3(
          class = "text-center",
          txt
        ),
        shiny::tags$h4(
          class = "text-center",
          eval_txt
        )
      )

    })

    triangle_data <- shiny::reactive({

      # browser()

      lmt <- if (is.na(input$lmt)) NA_real_ else input$lmt * 1000
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

      ldf_avg <- idf(ldf_avg(tri_dat)$idfs)

      ldf_avg_wtd <- idf(ldf_avg_wtd(tri_dat)$idfs)

      prior <- ldf_avg_wtd

      industry <- ldf_avg_wtd

      sel <- ldf_avg_wtd

      cdf <- idf2cdf(sel)

      params <- list("Straight Average:" = ldf_avg,
                     "Weighted Average:" = ldf_avg_wtd)

      hold <- purrr::map2_dfr(params, names(params), function(dat, type_ ) {
        dat |>
          tidyr::pivot_wider(names_from = age, values_from = names(dat)[2]) |>
          rlang::set_names(names(ata_tri)) |>
          dplyr::mutate(AYE = type_)
      })

      params <- list(
        "Industry:" = industry,
        "Prior Selected:" = prior
      )

      industry_prior_hold <- purrr::map2_dfr(
        params, names(params), function(dat, type_) {
          dat |>
            tidyr::pivot_wider(names_from = age, values_from = names(dat)[2]) |>
            rlang::set_names(names(ata_tri)) |>
            dplyr::mutate(AYE = type_)
        }
      )

      selected <- sel |>
        tidyr::pivot_wider(names_from = age, values_from = idfs) |>
        rlang::set_names(names(ata_tri)) |>
        dplyr::mutate(AYE = "Selected Factors:")

      cdfs <- cdf |>
        tidyr::pivot_wider(names_from = age, values_from = cdfs) |>
        rlang::set_names(names(ata_tri)) |>
        dplyr::mutate(AYE = "Cumulative Factors:")

      list(
        "aggregate_data" = agg_dat,
        "triangle_data" = tri_dat,
        "triangle" = tri,
        "age_to_age_data" = ata_dat,
        "age_to_age_triangle" = ata_tri,
        "averages" = hold,
        "industry_priors" = industry_prior_hold,
        "selected" = selected,
        "cdfs" = cdfs
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
      shiny::req(input$type != "case")

      # browser()

      out <- triangle_data()$age_to_age_triangle |>
        tibble::add_row()

      max_age <- as.numeric(names(out)[ncol(out)]) + 12

      age_to_age_names <- c(
        "AYE",
        paste0(
          names(out)[-1],
          "-",
          c(names(out)[-c(1:2)], as.character(max_age))
        )
      )

      names(out) <- age_to_age_names

      tail_col <- paste0(max_age, "-ULT")

      tail_df <- tibble::tibble(
        " " = rep(NA, times = nrow(out))
      ) |> setNames(tail_col)

      cbind(
        out,
        tail_df
      )
    })

    output$devt_factors <- DT::renderDT({

      out <- devt_prep()

      n_row <- nrow(out)
      col_width <- paste0(round(1/ncol(out),0) * 100, "%")

      hold <- DT::datatable(
        out,
        rownames = FALSE,
        caption = "Age-to-Age Development Factors",
        colnames = c("Accident Year Ending", names(out)[-1]),
        extensions = c("Buttons"),
        selection = "none",
        class = "display",
        callback = DT::JS('return table'),
        options = list(
          dom = "Bt",
          paging = FALSE,
          scrollX = TRUE,
          editable = list(
            target = "cell"
          ),
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
        DT::formatRound(
          column = 2:length(out),
          digits = 4
        )
    })

    output$avgs <- DT::renderDT({

      out <- triangle_data()$averages

      n_row <- nrow(out)
      col_width <- paste0(round(1/ncol(out),0) * 100, "%")

      hold <- DT::datatable(
        out,
        rownames = FALSE,
        caption = "Averages",
        colnames = c("Accident Year Ending", names(out)[-1]),
        extensions = c("Buttons"),
        selection = "none",
        class = "display",
        callback = DT::JS('return table'),
        options = list(
          dom = "Bt",
          paging = FALSE,
          scrollX = TRUE,
          editable = list(
            target = "cell"
          ),
          buttons = list(
            list(
              extend = "excel",
              text = "Download",
              title = "industry-and-priors-ldfs"
            )
          ),
          ordering = FALSE,
          pageLength = n_row,
          columnDefs = list(
            list(targets = "_all", className = "dt-center", width = col_width)
          )
        )
      ) |>
        DT::formatRound(
          column = 2:length(out),
          digits = 4
        )

    })

    output$prior_and_industry <- DT::renderDT({

      out <- triangle_data()$industry_priors
      n_row <- nrow(out)
      col_width <- paste0(round(1/ncol(out),0) * 100, "%")

      hold <- DT::datatable(
        out,
        rownames = FALSE,
        caption = "Industry and Prior Selected LDFs",
        colnames = c("Accident Year Ending", names(out)[-1]),
        extensions = c("Buttons"),
        selection = "none",
        class = "display",
        callback = DT::JS('return table'),
        options = list(
          dom = "Bt",
          paging = FALSE,
          scrollX = TRUE,
          editable = list(
            target = "cell"
          ),
          buttons = list(
            list(
              extend = "excel",
              text = "Download",
              title = "industry-and-priors-ldfs"
            )
          ),
          ordering = FALSE,
          pageLength = n_row,
          columnDefs = list(
            list(targets = "_all", className = "dt-center", width = col_width)
          )
        )
      ) |>
        DT::formatRound(
          column = 2:length(out),
          digits = 4
        )

    })

    output$selections <- DT::renderDT({

      out <- triangle_data()$selected |> dplyr::bind_rows(triangle_data()$cdfs)

      n_row <- nrow(out)
      col_width <- paste0(round(1/ncol(out),0) * 100, "%")

      hold <- DT::datatable(
        out,
        rownames = FALSE,
        caption = "Industry and Prior Selected LDFs",
        colnames = c("Accident Year Ending", names(out)[-1]),
        extensions = c("Buttons"),
        selection = "none",
        class = "display",
        callback = DT::JS('return table'),
        options = list(
          dom = "Bt",
          paging = FALSE,
          scrollX = TRUE,
          editable = list(
            target = "cell"
          ),
          buttons = list(
            list(
              extend = "excel",
              text = "Download",
              title = "selected-ldfs-cdfs"
            )
          ),
          ordering = FALSE,
          pageLength = n_row,
          columnDefs = list(
            list(targets = "_all", className = "dt-center", width = col_width)
          )
        )
      ) |>
        DT::formatRound(
          column = 2:length(out),
          digits = 4
        )

    })
    
  })
  
}

## To be copied in the UI
# mod_triangles_ui("triangles_1")

## To be copied in the server
# mod_triangles_server("triangles_1")
