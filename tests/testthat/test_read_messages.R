context("Reading messages")

test_that("read_messages read and parses messages from a mailbox", {
  if (!reticulate::py_module_available("mailbox"))
    skip("mailbox not available for testing")

  messages <- read_messages("data/test_mailbox.mbox", type="mbox")
  result <- tibble::tibble(From=c("foo@bar.com", NA, "foo@bar.com"),
                   To=c("spam@eggs.co.uk", "spam@eggs.co.uk",
                        "spam@eggs.co.uk"),
                   Date=c("2018-01-01 12:00", "2018-01-01 12:00",
                          "2018-01-01 12:00"),
                   Body=c("This is a test\n", "This is a second test\n",
                          "This is a fourth test"))
  expect_equal(result, messages)
})
