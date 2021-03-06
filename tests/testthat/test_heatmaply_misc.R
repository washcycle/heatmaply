


context("heatmaply misc")


test_that("non-numerics moved to row_side_colors", {
  mtcars[, ncol(mtcars) + 1] <- "a"
  h <- heatmaply(mtcars, row_side_colors = mtcars[, 1:2])
  expect_is(h, "plotly")
  h <- heatmaply(mtcars)
  expect_is(h, "plotly")
})


test_that("heatmaply on matrix, and cexRow/Col", {
  mtcars <- as.matrix(mtcars)
  rownames(mtcars) <- NULL
  h <- heatmaply(mtcars, cexRow = 5, cexCol = 5)
  expect_warning(heatmaply(mtcars, cexRow = "b", cexCol = "a"))

  expect_is(h, "plotly")
})


test_that("grid_color and hide_colorbar", {
  h <- heatmaply(mtcars[1:5, 1:5], grid_color = "black", hide_colorbar = TRUE)
  expect_is(h, "plotly")
})

test_that("return plots", {
  h <- heatmaply(mtcars, return_ppxpy = TRUE)
  sapply(h, function(el) expect_true(is.null(el) | inherits(el, "gg")))
})

test_that("SideColors", {
  rs <- mtcars[, 1]
  rscolors <- colorRampPalette(c("red", "blue"))(length(unique(rs)))
  rs <- rscolors[as.character(rs)]
  h <- heatmaply(mtcars, RowSideColors = rs)
  expect_is(h, "plotly")
  expect_warning(h <- heatmaply(t(mtcars), ColSideColors = rs))
  expect_is(h, "plotly")
})

test_that("limits", {
  h <- heatmaply(t(mtcars), limits = range(as.matrix(mtcars)))
  expect_is(h, "plotly")
  expect_warning(h <- heatmaply(t(mtcars), limits = c(0, 0)))
  expect_is(h, "plotly")
  expect_error(heatmaply(t(mtcars), limits = c("a", "b")))
  expect_error(heatmaply(t(mtcars), limits = 1))
})

test_that("cellnote", {
  h <- heatmaply(mtcars, draw_cellnote = TRUE)
  expect_is(h, "plotly")
})

test_that("showticklabels", {
  h <- heatmaply(mtcars, showticklabels = TRUE)
  expect_is(h, "plotly")
  h <- heatmaply(mtcars, showticklabels = c(FALSE, FALSE))
  expect_is(h, "plotly")
  expect_warning(expect_error(heatmaply(mtcars, showticklabels = "a")))
})

## This relies on PhantomJS... it's failing a lot so comment it
# test_that("file argument works", {
#   lapply(c("png", "jpeg", "pdf", "html"), function(type) {
#     file <- paste0("tmp.", type)
#     if (type=="pdf") {
#         expect_warning(heatmaply(mtcars, file=file))
#     } else {
#         heatmaply(mtcars, file=file)
#     }
#     expect_true(file.exists(file))
#   })
# })

test_that("correlation arguments work", {
  lapply(c("pearson", "spearman", "kendall"), function(method) {
    expect_is(heatmaply(mtcars, distfun = method), "plotly")
  })
})

test_that("long_data works", {
  mdf <- reshape2::melt(as.matrix(mtcars))
  colnames(mdf) <- c("name", "variable", "value")
  expect_is(heatmaply(long_data = mdf), "plotly")
  expect_error(heatmaply(x, mtcars, long_data = mdf))
})

test_that("heatmaply_na works", {
  m <- as.matrix(mtcars)
  m[1:5] <- NA
  expect_is(heatmaply_na(m), "plotly")
})

test_that("heatmaply_cor works", {
  m <- cor(as.matrix(mtcars))
  expect_is(heatmaply_cor(m), "plotly")
})


test_that("dengrogram=TRUE works", {
  expect_is(heatmaply(mtcars, dendrogram = TRUE), "plotly")
})

test_that("limits warning", {
  expect_warning(
    heatmaply(mtcars, limits = c(4, 5)),
    "Lower limit is not*"
  )
})

test_that("grid_gap works", {
  expect_is(heatmaply(mtcars, grid_gap = 1), "plotly")
})


test_that("subplot_* needs to be correct", {
  expect_error(heatmaply(mtcars, subplot_heights = rep(1, 10)))
  expect_error(heatmaply(mtcars, subplot_widths = rep(1, 10)))
})
