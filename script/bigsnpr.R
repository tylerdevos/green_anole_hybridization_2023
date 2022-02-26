library(bigsnpr)
rds <- snp_readBed("imputed.bed")

masked_all <- snp_attach(rds)
G <- masked_all$genotypes
CHR <- masked_all$map$chromosome
POS <- masked_all$map$physical.pos

svd <- snp_autoSVD(G, as.integer(factor(CHR)), POS, roll.size=0)

write(paste(CHR[attr(svd, "subset")], POS[attr(svd, "subset")], sep='\t'), "bigsnpr_filtered_loci")