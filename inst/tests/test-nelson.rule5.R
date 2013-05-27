# Test Nelson Rule Five
# ----------------------

# Set up data
x <- c(0.0912, 0.0942, 0.1032, 0.1043, 0.1068,
      0.1068, 0.0876, 0.1108, 0.1050, 0.0887,
      0.0881, 0.0990, 0.1184, 0.1121, 0.0986, 
      0.0966, 0.0876, 0.0933, 0.0954, 0.1155)

mean <- rep(mean(x), length(x))

n <- 500
sd <- sqrt(mean(x) * (1 - mean(x)) / n)
ucl <- mean + 3 * sd
lcl <- mean - 3 * sd

#-----------------------------------------------------------

test_that("no two out of three points are outside 2 SD", {
  r <- nelson.rule5(x, mean, ucl, lcl)
  expect_that(r$violated, equals(FALSE))
  expect_that(length(r$matches), equals(0))
})

test_that("two out of three points are above", {
  
  # Set up data for test
  x[c(10,12)] <- ucl[c(11,12)] - 0.01
  
  # Do test
  r <- nelson.rule5(x, mean, ucl, lcl)
  expect_that(r$violated, equals(TRUE))
  expect_that(length(r$which), equals(3))
  expect_that(r$which, equals(10:12))
})

test_that("two out of three points are below", {
  
  # Set up data for test
  x[c(10,12)] <- lcl[c(11,12)] + 0.01
  
  # Do test
  r <- nelson.rule5(x, mean, ucl, lcl)
  expect_that(r$violated, equals(TRUE))
  expect_that(length(r$which), equals(3))
  expect_that(r$which, equals(10:12))
})