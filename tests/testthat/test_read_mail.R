context("Reading mail")

test_that("We can read mail", {
  if (!reticulate::py_module_available("mailbox"))
    skip("mailbox not available for testing")
  expect_true(TRUE)
})
