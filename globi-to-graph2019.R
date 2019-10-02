# Katja Seltmann, 2019
# TPT biotic interactions demo, iDigBio Summit, Gainesville, FL

#download data from globi using r API
#https://www.globalbioticinteractions.org
#create simple network with the data

#clear R brain
#remember to also set your working directory
rm(list=ls())

#remove old plots
plot.new()

#install packages if you dont have them
#install.packages("rglobi")


#load packages
library(rglobi)
library(ggplot2)
library("dplyr")
library("tidyr")
require(igraph)


#look at the different interaction types found in GloBI
interactions_types <- get_interaction_types()
View(interactions_types)

#find all functions in rglobi package
lsp <- function(package, all.names = FALSE, pattern) 
{
  package <- deparse(substitute(package))
  ls(
    pos = paste("package", package, sep = ":"), 
    all.names = all.names, 
    pattern = pattern
  )
}

lsp(rglobi)


###########################
#get data from GloBI
###########################

#get interactions of one taxon. This has a limit to number of records returned. Change the genus to return other taxa.
totalInteractions <- get_interactions_by_taxa(sourcetaxon = "Physaloptera")

#if more records you can use pagenation
otherkeys = list("limit"=10000, "skip"=0)
first_page_of_ten <- get_interactions_by_taxa(sourcetaxon = "Physaloptera", otherkeys = otherkeys)
otherkeys = list("limit"=10000, "skip"=10000)
second_page_of_ten <- get_interactions_by_taxa(sourcetaxon = "Physaloptera", otherkeys = otherkeys)
totalInteractions <- rbind(first_page_of_ten,second_page_of_ten)

#look at the data returned
head(totalInteractions)

#how many rows in this dataset
nrow(totalInteractions)

#how many unique taxa
unique(totalInteractions$source_taxon_name)

#export dataset
write.table(totalInteractions, file='totalInteractions.tsv', quote=FALSE, sep='\t', row.names = FALSE)


#edit totalInteractions dataset to include only source taxon, target taxon and interaction type
totalInteractionsSinplified <- data.frame(totalInteractions$source_taxon_name,totalInteractions$target_taxon_name,totalInteractions$interaction_type)

#check the output
head(totalInteractionsSinplified)


#################################
#graph the example
#################################


#filter by one species
totalInteractionsSinplified <- filter(totalInteractions, totalInteractions$source_taxon_name=="Physaloptera squamatae")

#create a new dataframe for a network graph (vertex, edges)
interactionsForGraph <- data.frame(totalInteractionsSinplified$source_taxon_name,totalInteractionsSinplified$target_taxon_name)

#find only unique interactions
interactionsForGraph<- unique(interactionsForGraph)

#describe network
interactionsForGraph.network<-graph.data.frame(interactionsForGraph, directed=F)

#list the vertices
V(interactionsForGraph.network)


#list the edges
E(interactionsForGraph.network)

#plot the graphs
plot(interactionsForGraph.network,vertex.size=5, vertex.label.dist=0.5, layout=layout_in_circle)





