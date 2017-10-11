
# Default USC IMAGE beamer arguments
default_beamer_uscimage <- list(
  theme       = "default",
  colortheme  = "uscimage",
  toc         = TRUE,
  highlight   = "tango",
  template    = system.file("templates/uscimage_beamer.tex", package = "uscimage"),
  slide_level = 2,
  includes    = rmarkdown::includes()
)

# Function to set the defaults of a dots argument
set_defaults <- function(x, defaults) {

  env <- parent.frame()
  x <- as.character(match.call()$x)

  for (name in names(defaults))
    if (!length(env[[x]][[name]]))
      env[[x]][[name]] <- defaults[[name]]

  invisible(NULL)
}


#' Convert to a Beamer presentation using USC IMAGE theme
#' @param background Filepath to a background image (see details).
#' @param ... Further parameters to be passed to \code{beamer_document}
#' @details
#' By default the template used is in
#' \code{system.file("templates/uscimage_beamer.tex")} and the
#' background used is in
#' \code{system.file("templates/uscimage_pptx_background.jpg")}
#'
#' @author George G. Vega Yon
#' @export
beamer_USCImage <- function(
  background = NULL,
  ...) {

  dots <- list(...)
  set_defaults(dots, default_beamer_uscimage)

  # Checking the default background
  if (!length(background))
    background <- system.file("templates/uscimage_pptx_background.jpg", package = "uscimage")

  if (identical(dots$colortheme, "uscimage")) {
    dots$colortheme <- "default"
    dots$includes$in_header <- c(
      dots$includes$in_header,
      system.file("templates/beamercolorthemeuscimage.sty", package = "uscimage")
    )
  }

  # Writing a file to include data
  toinclude <- tempfile()

  if (background != "n") {

    # Writing the file
    write(
      sprintf(
        "\\usebackgroundtemplate{\\includegraphics[width=\\paperwidth,height=\\paperheight]{%s}}",
        background),
      file=toinclude
      )

    # Adding it to the header
    dots$includes$in_header <- c(toinclude, dots$includes$in_header)
  }

  do.call(
    rmarkdown::beamer_presentation,
    dots
    )


}
