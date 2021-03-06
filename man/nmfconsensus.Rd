\name{nmfconsensus}
\alias{nmfconsensus}
%- Also NEED an '\alias' for EACH other topic documented here.
\title{
Non matrix factorization (NMF)
}
\description{
This is a function to perform NMF.
}
\usage{
nmfconsensus(input.ds, k.init, k.final, num.clusterings, maxniter, error.function, rseed = 123456789, stopconvergence = 40, stopfrequency = 10, non.interactive.run = F, doc.string = "", data = FALSE, ...)
}
%- maybe also 'usage' for other objects documented here.
\arguments{
  \item{input.ds}{
%%     ~~Describe \code{input.ds} here~~
}
  \item{k.init}{
%%     ~~Describe \code{k.init} here~~
}
  \item{k.final}{
%%     ~~Describe \code{k.final} here~~
}
  \item{num.clusterings}{
%%     ~~Describe \code{num.clusterings} here~~
}
  \item{maxniter}{
%%     ~~Describe \code{maxniter} here~~
}
  \item{error.function}{
%%     ~~Describe \code{error.function} here~~
}
  \item{rseed}{
%%     ~~Describe \code{rseed} here~~
}
  \item{stopconvergence}{
%%     ~~Describe \code{stopconvergence} here~~
}
  \item{stopfrequency}{
%%     ~~Describe \code{stopfrequency} here~~
}
  \item{non.interactive.run}{
%%     ~~Describe \code{non.interactive.run} here~~
}
  \item{doc.string}{
%%     ~~Describe \code{doc.string} here~~
}
  \item{data}{
%%     ~~Describe \code{data} here~~
}
  \item{\dots}{
%%     ~~Describe \code{\dots} here~~
}
}
\details{
%%  ~~ If necessary, more details than the description above ~~
}
\value{
%%  ~Describe the value returned
%%  If it is a LIST, use
%%  \item{comp1 }{Description of 'comp1'}
%%  \item{comp2 }{Description of 'comp2'}
%% ...
}
\references{
%% ~put references to the literature/web site here ~
}
\author{
%%  ~~who you are~~
}
\note{
%%  ~~further notes~~
}

%% ~Make other sections like Warning with \section{Warning }{....} ~

\seealso{
%% ~~objects to See Also as \code{\link{help}}, ~~~
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (input.ds, k.init, k.final, num.clusterings, maxniter, 
    error.function, rseed = 123456789, stopconvergence = 40, 
    stopfrequency = 10, non.interactive.run = F, doc.string = "", 
    data = FALSE, ...) 
{
    directory = ""
    time.string <- as.character(as.POSIXlt(Sys.time(), "GMT"))
    if (non.interactive.run == "F") {
        filename <- paste(directory, doc.string, ".params.txt", 
            sep = "", collapse = "")
        write(paste("Run of NMF on ", time.string), file = filename)
        write(paste("input.ds =", input.ds, sep = " "), file = filename, 
            append = T)
        write(paste("k.init = ", k.init, sep = " "), file = filename, 
            append = T)
        write(paste("k.final =", k.final, sep = " "), file = filename, 
            append = T)
        write(paste("num.clusterings =", num.clusterings, sep = " "), 
            file = filename, append = T)
        write(paste("maxniter =", maxniter, sep = " "), file = filename, 
            append = T)
        write(paste("error.function =", error.function, sep = " "), 
            file = filename, append = T)
        write(paste("rseed =", rseed, sep = " "), file = filename, 
            append = T)
        write(paste("directory =", directory, sep = " "), file = filename, 
            append = T)
        write(paste("stopconv =", stopconvergence, sep = " "), 
            file = filename, append = T)
        write(paste("stopfreq =", stopfrequency, sep = " "), 
            file = filename, append = T)
        write(paste("non.interctive.run =", non.interactive.run, 
            sep = " "), file = filename, append = T)
        write(paste("doc.string =", doc.string, sep = " "), file = filename, 
            append = T)
    }
    k.init <- as.integer(k.init)
    k.final <- as.integer(k.final)
    num.clusterings <- as.integer(num.clusterings)
    n.iter <- as.integer(maxniter)
    if (!is.na(rseed)) {
        seed <- as.integer(rseed)
    }
    stopfreq <- as.integer(stopfrequency)
    stopconv <- as.integer(stopconvergence)
    D <- data
    A <- data.matrix(D)
    eps <- .Machine$double.eps
    A[A < 0] <- eps
    cols <- length(A[1, ])
    rows <- length(A[, 1])
    col.names <- colnames(D)
    num.k <- k.final - k.init + 1
    rho <- vector(mode = "numeric", length = num.k)
    k.vector <- vector(mode = "numeric", length = num.k)
    k.index <- 1
    connect.matrix.ordered <- array(0, c(num.k, cols, cols))
    for (k in k.init:k.final) {
        if (non.interactive.run == F) {
            if (.Platform$OS.type == "windows") {
                filename <- paste(directory, doc.string, "graphs.k", 
                  k, sep = "", collapse = "")
                windows(width = 9, height = 11)
            }
            else if (.Platform$OS.type == "unix") {
                filename <- paste(directory, doc.string, "graphs.k", 
                  k, ".pdf", sep = "", collapse = "")
                pdf(file = filename, width = 9, height = 11)
            }
        }
        else {
            if (.Platform$OS.type == "unix") {
                filename <- paste(directory, doc.string, "graphs.k", 
                  k, ".pdf", sep = "", collapse = "")
                pdf(file = filename, width = 9, height = 11)
            }
            else if (.Platform$OS.type == "windows") {
                filename <- paste(directory, doc.string, "graphs.k", 
                  k, ".pdf", sep = "", collapse = "")
                pdf(file = filename, width = 9, height = 11)
            }
        }
        nf <- layout(matrix(c(1, 2, 3, 4, 5, 6, 7, 8), 4, 2, 
            byrow = T), c(1, 1, 1, 1), c(1, 1), TRUE)
        assign <- matrix(0, nrow = num.clusterings, ncol = cols)
        for (i in 1:num.clusterings) {
            if (non.interactive.run == "F") {
                print(paste("Computing clustering number=", i, 
                  " for k=", k, sep = "", collapse = " "))
            }
            if (error.function == "divergence") {
                NMF.out <- NMF.div(V = A, k = k, maxniter = n.iter, 
                  seed = seed + i, stopconv = stopconv, stopfreq = stopfreq)
            }
            else if (error.function == "euclidean") {
                NMF.out <- NMF(V = A, k = k, maxniter = n.iter, 
                  seed = seed + i, stopconv = stopconv, stopfreq = stopfreq)
            }
            else {
                stop(paste("Un-supported error function=", error.function, 
                  sep = ""))
            }
            if (non.interactive.run == "F") {
                print(paste(NMF.out$t, " NMF iterations performed", 
                  sep = "", collapse = " "))
            }
            for (j in 1:cols) {
                class <- order(NMF.out$H[, j], decreasing = T)
                assign[i, j] <- class[1]
            }
            if (i == 3) {
                H.saved <- NMF.out$H
                sub.string <- paste(doc.string, " k=", k, sep = "")
                plot(1:NMF.out$t, NMF.out$error.v[1:NMF.out$t], 
                  pch = 20, cex = 1.5, col = 1, xlab = "time", 
                  ylab = "NMF error", sub = sub.string, main = paste("Example of NMF convergence plot k=", 
                    k, sep = ""))
                if (rows < 1000) {
                  W <- NMF.out$W
                }
                else {
                  W <- NMF.out$W[sample(x = 1:rows, size = 1000), 
                    ]
                }
                sub.string <- paste(doc.string, " k=", k, sep = "")
                matrix.abs.plot(W, sub = sub.string, log = F, 
                  main = "Example W matrix (orig. ordering)", 
                  ylab = "genes", xlab = "metasamples")
                matrix.abs.plot(H.saved, sub = sub.string, log = F, 
                  main = "Example H matrix (orig. ordering)", 
                  ylab = "metagenes", xlab = "samples")
                metagene.plot(H = H.saved, main = "Example metagenes (orig. ordering)", 
                  sub = sub.string, xlab = "samples", ylab = "metagenes")
            }
            filename <- paste(directory, doc.string, "metagenes.k.", 
                k, ".", i, ".txt", sep = "", collapse = "")
            write.table(NMF.out$W, filename, sep = "\t")
            filename1 <- paste(directory, doc.string, "metasamples.k.", 
                k, ".", i, ".txt", sep = "", collapse = "")
            write.table(NMF.out$H, filename1, sep = "\t")
            rm(NMF.out)
        }
        connect.matrix <- matrix(0, nrow = cols, ncol = cols)
        for (i in 1:num.clusterings) {
            for (j in 1:cols) {
                for (p in 1:cols) {
                  if (j != p) {
                    if (assign[i, j] == assign[i, p]) {
                      connect.matrix[j, p] <- connect.matrix[j, 
                        p] + 1
                    }
                  }
                  else {
                    connect.matrix[j, p] <- connect.matrix[j, 
                      p] + 1
                  }
                }
            }
        }
        connect.matrix <- connect.matrix/num.clusterings
        dist.matrix <- 1 - connect.matrix
        dist.matrix <- as.dist(dist.matrix)
        HC <- hclust(dist.matrix, method = "average")
        dist.coph <- cophenetic(HC)
        k.vector[k.index] <- k
        rho[k.index] <- cor(dist.matrix, dist.coph)
        rho[k.index] <- signif(rho[k.index], digits = 4)
        for (i in 1:cols) {
            for (j in 1:cols) {
                connect.matrix.ordered[k.index, i, j] <- connect.matrix[HC$order[i], 
                  HC$order[j]]
            }
        }
        membership <- cutree(HC, k = k)
        max.k <- max(membership)
        items.names.ordered <- col.names[HC$order]
        membership.ordered <- membership[HC$order]
        results <- data.frame(cbind(membership.ordered, items.names.ordered))
        if (k > k.init) {
            all.membership <- cbind(all.membership, membership)
        }
        else {
            all.membership <- cbind(membership)
        }
        sub.string <- paste(doc.string, " k=", k, sep = "")
        matrix.abs.plot(connect.matrix.ordered[k.index, , ], 
            sub = sub.string, log = F, main = "Ordered Consensus Matrix", 
            ylab = "samples", xlab = "samples")
        plot(HC, xlab = "samples", cex = 0.75, labels = col.names, 
            sub = sub.string, col = "blue", main = paste("Ordered Linkage Tree. Coph=", 
                rho[k.index]))
        resultsGct <- data.frame(membership.ordered)
        row.names(resultsGct) <- items.names.ordered
        filename <- paste(directory, doc.string, "consensus.k.", 
            k, ".gct", sep = "", collapse = "")
        write.gct(resultsGct, filename)
        H.sorted <- H.saved[, HC$order]
        sub.string <- paste(doc.string, " k=", k, sep = "")
        matrix.abs.plot(H.sorted, sub = sub.string, log = F, 
            main = "Example H matrix (ordered)", ylab = "metagenes", 
            xlab = "samples")
        metagene.plot(H = H.sorted, sub = sub.string, main = "Example metagenes (ordered)", 
            xlab = "samples", ylab = "metagenes")
        if (non.interactive.run == F) {
            if (.Platform$OS.type == "windows") {
                savePlot(filename = filename, type = "jpeg", 
                  device = dev.cur())
            }
            else if (.Platform$OS.type == "unix") {
                dev.off()
            }
        }
        else {
            dev.off()
        }
        if (non.interactive.run == F) {
            if (.Platform$OS.type == "windows") {
                filename <- paste(directory, doc.string, "consensus.plot.k", 
                  k, sep = "", collapse = "")
                windows(width = 8.5, height = 11)
            }
            else if (.Platform$OS.type == "unix") {
                filename <- paste(directory, doc.string, "consensus.plot.k", 
                  k, ".pdf", sep = "", collapse = "")
                pdf(file = filename, width = 8.5, height = 11)
            }
        }
        else {
            if (.Platform$OS.type == "unix") {
                filename <- paste(directory, doc.string, "consensus.plot.k", 
                  k, ".pdf", sep = "", collapse = "")
                pdf(file = filename, width = 8.5, height = 11)
            }
            else if (.Platform$OS.type == "windows") {
                filename <- paste(directory, doc.string, "consensus.plot.k", 
                  k, ".pdf", sep = "", collapse = "")
                pdf(file = filename, width = 8.5, height = 11)
            }
        }
        nf <- layout(matrix(c(1), 1, 1, byrow = T), c(1, 1), 
            c(1, 1), TRUE)
        conlabel <- paste("Consensus k =", k, sep = " ", collapse = "")
        sub.string <- paste("Consensus matrix k=", k, "; dataset= ", 
            input.ds, sep = "")
        ConsPlot(connect.matrix.ordered[k.index, , ], col.labels = membership.ordered, 
            col.names = items.names.ordered, main = " ", sub = sub.string, 
            xlab = " ", ylab = " ")
        if (non.interactive.run == F) {
            if (.Platform$OS.type == "windows") {
                savePlot(filename = filename, type = "jpeg", 
                  device = dev.cur())
            }
            else if (.Platform$OS.type == "unix") {
                dev.off()
            }
        }
        else {
            dev.off()
        }
        k.index <- k.index + 1
    }
    if (non.interactive.run == F) {
        if (.Platform$OS.type == "windows") {
            filename <- paste(directory, doc.string, "consensus.all.k.plot", 
                sep = "")
            windows(width = 8.5, height = 11)
        }
        else if (.Platform$OS.type == "unix") {
            filename <- paste(directory, doc.string, "consensus.all.k.plot.pdf", 
                sep = "")
            pdf(file = filename, width = 8.5, height = 11)
        }
    }
    else {
        if (.Platform$OS.type == "unix") {
            filename <- paste(directory, doc.string, "consensus.all.k.plot.pdf", 
                sep = "")
            pdf(file = filename, width = 8.5, height = 11)
        }
        else if (.Platform$OS.type == "windows") {
            filename <- paste(directory, doc.string, "consensus.all.k.plot.pdf", 
                sep = "")
            pdf(file = filename, width = 8.5, height = 11)
        }
    }
    nf <- layout(matrix(c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 
        12, 13, 14, 15, 16), 4, 4, byrow = T), c(1, 1, 1, 1), 
        c(1, 1, 1, 1), TRUE)
    for (k in 1:num.k) {
        matrix.abs.plot(connect.matrix.ordered[k, , ], log = F, 
            main = paste("k=", k.vector[k]), sub = paste("Cophenetic coef.=", 
                rho[k]), ylab = "samples", xlab = "samples")
    }
    y.range <- c(1 - 2 * (1 - min(rho)), 1)
    plot(k.vector, rho, main = "Cophenetic Coefficient", xlim = c(k.init, 
        k.final), ylim = y.range, xlab = "k", ylab = "Cophenetic correlation", 
        type = "n")
    lines(k.vector, rho, type = "l", col = "black")
    points(k.vector, rho, pch = 22, type = "p", cex = 1.25, bg = "black", 
        col = "black")
    if (non.interactive.run == F) {
        if (.Platform$OS.type == "windows") {
            savePlot(filename = filename, type = "jpeg", device = dev.cur())
        }
        else if (.Platform$OS.type == "unix") {
            dev.off()
        }
    }
    else {
        dev.off()
    }
    if (non.interactive.run == F) {
        if (.Platform$OS.type == "windows") {
            filename <- paste(directory, doc.string, "cophenetic.plot", 
                sep = "")
            windows(width = 8.5, height = 11)
        }
        else if (.Platform$OS.type == "unix") {
            filename <- paste(directory, doc.string, "cophenetic.plot.pdf", 
                sep = "")
            pdf(file = filename, width = 8.5, height = 11)
        }
    }
    else {
        if (.Platform$OS.type == "unix") {
            filename <- paste(directory, doc.string, "cophenetic.plot.pdf", 
                sep = "")
            pdf(file = filename, width = 8.5, height = 11)
        }
        else if (.Platform$OS.type == "windows") {
            filename <- paste(directory, doc.string, "cophenetic.plot.pdf", 
                sep = "")
            pdf(file = filename, width = 8.5, height = 11)
        }
    }
    resultsmembership <- data.frame(all.membership)
    row.names(resultsmembership) <- col.names
    filename <- paste(directory, doc.string, "membership", ".gct", 
        sep = "", collapse = "")
    write.gct(resultsmembership, filename)
    y.range <- c(1 - 2 * (1 - min(rho)), 1)
    plot(k.vector, rho, main = "Cophenetic Coefficient", xlim = c(k.init, 
        k.final), ylim = y.range, xlab = "k", ylab = "Cophenetic correlation", 
        type = "n")
    lines(k.vector, rho, type = "l", col = "black")
    points(k.vector, rho, pch = 22, type = "p", cex = 1.25, bg = "black", 
        col = "black")
    if (non.interactive.run == F) {
        if (.Platform$OS.type == "windows") {
            savePlot(filename = filename, type = "jpeg", device = dev.cur())
        }
        else if (.Platform$OS.type == "unix") {
            dev.off()
        }
    }
    else {
        dev.off()
    }
    xx <- cbind(k.vector, rho)
    write(xx, file = paste(directory, doc.string, ".", "cophenetic.txt", 
        sep = ""))
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory.
\keyword{ ~kwd1 }
\keyword{ ~kwd2 }% __ONLY ONE__ keyword per line
