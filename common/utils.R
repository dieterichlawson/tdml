normalize <- function(data){
  data <- sweep(data, MARGIN=2, apply(data, 2, mean), FUN="-")
  data <- sweep(data, MARGIN=2, apply(data, 2, sd), FUN="/")
  return(data)
}
