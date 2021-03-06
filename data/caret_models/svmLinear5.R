modelInfo <- list(label = "L1 Regularized L2-Loss Support Vector Machine with Linear Kernel",
                  library = "LiblineaR",
                  type = c("Regression", "Classification"),
                  parameters = data.frame(parameter = c('cost', "Loss"),
                                          class = c("numeric", "character"),
                                          label = c("Cost", "Loss Function")),
                  grid = function(x, y, len = NULL, search = "grid") {
                    if(search == "grid") {
                      out <- expand.grid(cost = 2 ^((1:len) - 3),
                                         Loss = c("L1", "L2"))
                    } else {
                      out <- data.frame(cost = 2^runif(len, min = -10, max = 10),
                                        Loss = sample(c("L1", "L2"), size = len, replace = TRUE))
                    }
                    out
                  },
                  loop = NULL,
                  fit = function(x, y, wts, param, lev, last, classProbs, ...) {
                    if(param$Loss == "L2") {
                      model_type <- if(is.factor(y)) 5 else 13
                  } else model_type <- if(is.factor(y)) 5 else 11

                    out <- LiblineaR(data = as.matrix(x), target = y,
                                     cost = param$cost,
                                     type = model_type,
                                     ...)

                    out
                  },
                  predict = function(modelFit, newdata, submodels = NULL) {
                    predict(modelFit, newdata)$predictions
                  },
                  prob = function(modelFit, newdata, submodels = NULL){
                    predict(modelFit, newdata, decisionValues = TRUE)$decisionValues
                  },
                  predictors = function(x, ...) {
                    out <- colnames(x$W)
                    out[out != "Bias"]
                    },
                  tags = c("Kernel Method", "Support Vector Machines","Linear Regression", "Linear Classifier",
                           "Robust Methods"),
                  levels = function(x) x$levels,
                  sort = function(x) {
                    x[order(x$cost),]
                  })
