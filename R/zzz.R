# global reference to scipy (will be initialized in .onLoad)
mailbox <- NULL

.onLoad <- function(libname, pkgname) {
  # use superassignment to update global reference to scipy
  mailbox <<- reticulate::import("mailbox", delay_load = TRUE)
}
