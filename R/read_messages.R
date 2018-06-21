#' Read e-mail messages from an on-disk mailbox
#'
#' @param path The path to the mailbox
#' @param type The format in which the mailbox is stored
#'
#' @return a data.frame with the headers and body of the messages
#' @export
read_messages <- function(path,
                          type=c('mbox', 'MailDir', 'MH', 'Babyl', 'MMDF')){
  my_mailbox <- get_mailbox(path, type)

  return(get_messages(my_mailbox))
}


#' Retrieve the mailbox object
#'
#' @param path The path to the mailbox
#' @param type The format in which the mailbox is stored
#'
#' @return A mailbox object
get_mailbox <- function(path, type){
  switch(type,
         mbox = mailbox$mbox(path),
         MailDir = mailbox$MailDir(path),
         MH = mailbox$MH(path),
         Babyl = mailbox$Babyl(path),
         MMDF = mailbox$MMDF(path),
         stop("Unknown mailbox type"))
}
