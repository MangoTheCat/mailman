#' Parse all messages from the given mail_object and return a data.frame
#'
#' @param mail_object A mail_object as read in by read_mail
#'
#' @return A data.frame containing all the fields from the message including the body
#' @importFrom tibble as_tibble
#' @export
get_messages <- function(mail_object){
  keys <- mail_object$keys()
  number_of_messages <- length(keys)

  if(number_of_messages==0){
    warning("No messages in mailbox")
    return(NULL)
  }

  pb <- utils::txtProgressBar(max=number_of_messages)

  first_message <- mail_object$get_message(keys[1])
  message_fields <- first_message$keys()
  # add one for the body of the message
  number_of_columns <- length(message_fields) + 1

  # initialise result matrix
  result <- matrix(nrow=number_of_messages, ncol=number_of_columns)

  # loop over each key, retrieve message and fill matrix
  for(i in seq_along(keys)){
    message <- mail_object$get_message(keys[i])
    # initialise result vector
    fields <- character(number_of_columns)
    # loop over each field and retrieve its value from the message
    for(j in seq_along(message_fields)){
      value <-  message$get(message_fields[j])
      if(is.null(value)){
        value <- NA
      }
      fields[j] <- value
    }

    # now retrieve the body
    if(message$is_multipart()){
      # sometimes a message is split into sub-messages
      # through inspection we see the body is stored in the second sub-message
      payload_with_body <- message$get_payload(1L)
      # we convert the sub-message to string
      fields[number_of_columns] <- payload_with_body$get_payload()
    }else{
      # the documentation for email.message.is_multipart states that when a
      # False value is returned the payload should be a string
      # but just to be on the safe side we'll check for this
      body <- message$get_payload()
      if(any(class(body)=="email.message.Message")){
        fields[number_of_columns] <- body$as_string()
      }else{
        fields[number_of_columns] <- body
      }

    }

    result[i,] <- fields
    utils::setTxtProgressBar(pb, i)
  }

  result <- as_tibble(result)
  colnames(result) <- c(message_fields, "Body")
  return(result)
}
