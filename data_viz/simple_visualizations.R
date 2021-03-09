library(tidyverse)
theme_set(theme_bw())

dt <- read_csv("../data/plos_compbio.csv")

# gender of first/last author
pl_gender <- ggplot(dt %>% 
                    filter(document_type == "Article") %>% 
                    group_by(year) %>% 
                    summarise(first_au_F = mean(first_au_F, na.rm = TRUE),
                              last_au_F = mean(last_au_F, na.rm = TRUE)) %>% 
                    ungroup() %>% 
                      rename(`first author` = first_au_F, `last author` = last_au_F) %>% 
                      gather("author", "proportion", -year)) + 
  aes(x = year, y = proportion, colour = author) + geom_point() + geom_smooth() +
  xlab("year") + ylab("proportion F author [Article]") + 
  theme(legend.position = "bottom")


# distribution of citations
pl_cit1 <- ggplot(dt %>% filter(year < 2020)) + aes(x = num_citations) + geom_histogram() + 
  facet_wrap(~year, scales = "free") + xlab("number of citations")

pl_cit2 <- ggplot(dt %>% filter(year < 2020)) + aes(x = log(num_citations + 1)) + geom_histogram() + 
  facet_wrap(~year, scales = "free") + xlab("log(number of citations + 1)")

pl_cit3 <- ggplot(dt %>% filter(year < 2020, document_type == "Article")) + aes(x = log(num_citations + 1)) + geom_histogram() + 
  facet_wrap(~year, scales = "free") + xlab("log(number of citations + 1) [Articles]")

# distribution of views
pl_view1 <- ggplot(dt %>% filter(year < 2020)) + aes(x = num_views) + geom_histogram() + 
  facet_wrap(~year, scales = "free") + xlab("number of views")

pl_view2 <- ggplot(dt %>% filter(year < 2020)) + aes(x = log(num_views + 1)) + geom_histogram() + 
  facet_wrap(~year, scales = "free") + xlab("log(number of views + 1)")

pl_view3 <- ggplot(dt %>% filter(year < 2020, document_type == "Article")) + aes(x = log(num_citations + 1)) + geom_histogram() + 
  facet_wrap(~year, scales = "free") + xlab("log(number of citations + 1) [Articles]")

# changes in number of authors
pl_au <- ggplot(
  dt %>% filter(document_type == "Article")
) + aes(x = year, y = num_authors, group = year) + geom_violin(fill = "azure2") + 
  geom_boxplot(width = 0.2) + 
  scale_y_log10() + 
  ylab("number of authors")

# changes in number of countries
pl_countries <- ggplot(
  dt %>% filter(document_type == "Article", num_countries > 0) %>% 
    mutate(num_countries = ifelse(num_countries == 1, "1", 
                                  ifelse(num_countries == 2, "2",
                                         ifelse(num_countries == 3, "3", "4+"))))
  ) + aes(x=year, fill = num_countries) + 
  geom_bar(position = "fill" ) + scale_fill_discrete("number of countries in affiliation list") + 
  theme(legend.position = "bottom")

# abstract length
pl_abs_len <- ggplot(dt %>% filter(document_type == "Article", num_words_abstract > 0)) + 
  aes(x = year, y = num_words_abstract, group = year) + geom_violin(fill = "azure2") + 
  geom_boxplot(width = 0.2) + ylab("num words in abstract")

# simple words in abstract
pl_simple_words <- ggplot(dt %>% filter(document_type == "Article", num_words_abstract > 0)) + 
  aes(x = year, y = prop_simple_words_abs, group = year) + geom_violin(fill = "azure2") + 
  geom_boxplot(width = 0.2) + ylab("% simple words in abstract")

# number of figures
pl_num_figs <- ggplot(dt %>% filter(document_type == "Article", num_words_abstract > 0)) + 
  aes(x = year, y = num_figures, group = year) + 
  geom_violin(fill = "azure2") + 
  geom_boxplot(width = 0.2) + 
  scale_y_sqrt() + 
  ylab("number of figures")

# number of references
pl_num_refs <- ggplot(dt %>% filter(document_type == "Article")) + 
  aes(x = year, y = num_references, group = year) + 
  geom_violin(fill = "azure2") + 
  geom_boxplot(width = 0.2) + 
  scale_y_log10() + 
  ylab("number of references")

# number of equations
pl_num_eqn <- ggplot(
  dt %>% filter(document_type == "Article") %>% 
    mutate(num_equations = ifelse(num_equations == 0, "0", 
                                  ifelse(num_equations < 5, "4 or less",
                                         "5  or more"))
)
) + 
  aes(x = year, fill = num_equations) + 
  geom_bar(position = "fill") + 
  scale_fill_discrete("number of equations") + 
  theme(legend.position = "bottom")


