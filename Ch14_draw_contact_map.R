#####################################################################################
# Draw Hi-C contact using the normalized contact matrices generated by hicpipe
#####################################################################################

options(width=130)
library(data.table)
library(ggplot2)
library(gridExtra)

# input filenames
infile1 = "output/test_no_cluster/test_no_cluster_500000.n_contact"
infile2 = "output/test_no_cluster/test_no_cluster_1000000.n_contact"
infile3 = "output/test_no_cluster/test_no_cluster_2000000.n_contact"

# output filename
outfile = "hic_contact_map1.pdf"

bin1 = fread(infile1, header=TRUE)
bin2 = fread(infile2, header=TRUE)
bin3 = fread(infile3, header=TRUE)

# log2 ratio between the observed_count and expected_count
bin1$ratio = log2((bin1$observed_count+1) / (bin1$expected_count+1))
bin2$ratio = log2((bin2$observed_count+1) / (bin2$expected_count+1))
bin3$ratio = log2((bin3$observed_count+1) / (bin3$expected_count+1))

# draw using ggplot2
p1 = ggplot(bin1[bin1$cbin1 < 100,], aes(x = cbin1, y = cbin2, group = cbin2)) + geom_tile(aes(fill = ratio)) + theme_bw() + 
scale_fill_gradientn("log2(OER)", colours = rev(rainbow(7))) + labs(title = "500-kb BINSIZE")

p2 = ggplot(bin2[bin2$cbin1 < 100,], aes(x = cbin1, y = cbin2, fill = ratio)) + geom_tile() + theme_bw() + 
scale_fill_gradientn("log2(OER)", colours = rev(rainbow(7))) + labs(title = "1-Mb BINSIZE")

p3 = ggplot(bin3, aes(x = cbin1, y = cbin2, fill = ratio)) + geom_tile() + theme_bw() + 
scale_fill_gradientn("log2(OER)", colours = rev(rainbow(7))) + labs(title = "2-Mb BINSIZE")

# output image as pdf
pdf(outfile, width=18, height=5, pointsize=12)
grid.arrange(p1, p2, p3, nrow = 1)
dev.off()
