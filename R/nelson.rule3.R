#' Nelson Rule Three (6+ points increasing or decreasing)
#' 
#' Checks for six or more consecutive increasing or decreasing points.
#' 
#' @param x vector of control chart values
#' @param mean vector of control chart mean values
#' @param ucl vector of upper control limit values
#' @param lcl vector of lower control limit values
#' 
#' @return A list containing the following components:
#' \item{violated}{boolean indicating if the rule was violated}
#' \item{matches}{vector of indices which violate the rule}
#' \item{first}{index of first violation}
#' @export
nelson.rule3 <- function(x, mean, ucl, lcl) {
  
  retval <- list(violated=FALSE, which=NULL, first=NULL)
  
  # Get a vector of differences
  tmp <- ifelse(diff(x) >= 0, 1, 0)
  
  # Collapse into string
  tmp <- paste0(tmp, collapse='')
  
  result <- gregexpr('0{6,}|1{6,}', tmp)[[1]]
  
  # Aggregate the results into the return value
  if (result[1] >= 0) {
    for (i in 1:length(result)) {
      m <- result[i] + attr(result, 'match.length')[i]
      retval$which <- c(retval$which, seq(result[i]+1,m))
    }
    
    # Find the time that we first recognize the violation
    first.result <- gregexpr('0{6,}?|1{6,}?', tmp)[[1]]
    retval$first <- first.result[1] + attr(first.result, 'match.length')[1]
    
  }
  

  
  retval$violated <- any(retval$which)

  retval$rule <- 3
  retval$descr <- "6+ points increasing or decreasing"
  
  retval$x <- x
  retval$mean <- mean
  retval$ucl <- ucl
  retval$lcl <- lcl
  class(retval) <- 'nelson_rule'
  return(retval)  
  
}
