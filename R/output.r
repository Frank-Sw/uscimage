
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
#'
#' Essentially, a wrapper of \code{\link[rmarkdown:beamer_presentation]{beamer_presentation}}
#' in the \CRANpkg{rmarkdown} package.
#'
#' @param background Filepath to a background image (see details).
#' @param ... Further parameters to be passed to \code{beamer_document}
#' @details
#'
#' The current defaul list of arguments passed via \code{...} is:
#'
#' \tabular{ll}{
#' \code{theme}      \tab \code{"default"} \cr
#' \code{colortheme} \tab \code{"uscimage"} \cr
#' \code{toc}        \tab \code{TRUE} \cr
#' \code{highlight}  \tab \code{"tango"} \cr
#' \code{template}   \tab \Sexpr[results=text]{system.file("templates/uscimage_beamer.tex", package = "uscimage")} \cr
#' \code{slide_level}\tab \code{2} \cr
#' \code{includes}   \tab \code{rmarkdown::includes()}
#' }
#'
#' If \code{colortheme = "uscimage"}, the argument is set to \code{"default"} and then the
#' file \Sexpr{system.file("templates/beamercolorthemeuscimage.sty", package = "uscimage")} is
#' passed to \code{includes$in_header} so that the USCImage color theme overwrites the default
#' theme.
#'
#' The default \code{background} image passed is located in
#' \Sexpr{system.file("templates/uscimage_pptx_background.jpg", package = "uscimage")}.
#'
#' @return Whatever \code{beamer_presentation} returns.
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

  # Calling beamer_presentation
  do.call(
    rmarkdown::beamer_presentation,
    dots
    )


}
