# .SUFFIXES: .pdf .tex
.DEFAULT_GOAL := help

#==============================================================================
# Inspecting
#==============================================================================
WORDCOUNT_SCR := ./inspecting/wordcount.sh
.PHONY: wordcount
wordcount: ## Wordcount via texcount
	@echo "==> $@"
	@echo "Check word count using texcount"
	dos2unix $(WORDCOUNT_SCR)
	chmod +x $(WORDCOUNT_SCR)
	$(WORDCOUNT_SCR)

ACRONYMS_SRC = ./inspecting/acronyms.sh
.PHONY: acronyms
acronyms: ## Find and tally acronyms
	@echo "==> $@"
	@echo "Check for acronyms"
	dos2unix $(ACRONYMS_SRC)
	chmod +x $(ACRONYMS_SRC)
	$(ACRONYMS_SRC)

.PHONY: dueto
dueto: ## Find "due to"s; Did you mean "because of", "owing to", or "from"?
	@echo "==> $@"
	@echo "Find all the 'due to's in writing"
	-grep -n "due to" $(SRC_TEX) > inspecting/logs/duetos.log

.PHONY: duplicated_labels
duplicated_labels: ## Check for duplicated labels
	@echo "==> $@"
	@echo "Check for duplicated labels"
	grep -o '\\label{[^}]*}' $(SRC_TEX) | sort | uniq -cd | tee ./inspecting/logs/duplicated-labels.log

HARDCODEDNUMBERS_SRC = ./inspecting/hardcoded-numbers.sh
.PHONY: hardcodednumbers
hardcodednumbers: ## Find hardcoded numbers
	@echo "==> $@"
	@echo "Check for hardcoded numbers"
	dos2unix $(HARDCODEDNUMBERS_SRC)
	chmod +x $(HARDCODEDNUMBERS_SRC)
	$(HARDCODEDNUMBERS_SRC)

LINKCHECKER_SRC = ./inspecting/linkchecker.sh
.PHONY: linkchecker
linkchecker: ## Check URLs
	@echo "==> $@"
	@echo "Check that URLs work"
	dos2unix $(LINKCHECKER_SRC)
	chmod +x $(LINKCHECKER_SRC)
	$(LINKCHECKER_SRC)

REPEATED_STRINGS_SRC = ./inspecting/repeated-strings.sh
.PHONY: repeated_strings
repeated_strings: ## Check for repeated words
	@echo "==> $@"
	@echo "Check for repeated words (e.g. 'the the table shows...')"
	dos2unix $(REPEATED_STRINGS_SRC)
	chmod +x $(REPEATED_STRINGS_SRC)
	-$(REPEATED_STRINGS_SRC)

.PHONY: textidote
textidote: ## Check with textidote
textidote: ./inspecting/textidote_dict.txt
	@echo "==> $@"
	@echo "Check doc with textidote"
	-textidote --check en --dict $< --output html $(SRC_TEX) > inspecting/logs/textidote.html

UNREFERENCED_LABELS_SRC = ./inspecting/unreferenced-labels.sh
.PHONY: unreferenced_labels
unreferenced_labels: ## Check for label referencing
	@echo "==> $@"
	@echo "Check for unreferenced labels"
	dos2unix $(UNREFERENCED_LABELS_SRC)
	chmod +x $(UNREFERENCED_LABELS_SRC)
	-$(UNREFERENCED_LABELS_SRC)

.PHONY: inspect
inspect: ## Do all inspections of manuscript
inspect: duplicated_labels \
         repeated_strings \
         unreferenced_labels \
         hardcodednumbers \
         acronyms \
         linkchecker \
         textidote \
         dueto \
         wordcount


#==============================================================================
# Additional utilities
#==============================================================================
AY2NUMERIC_SRC = ./inspecting/ay2numeric.sh
.PHONY: aynumeric
aynumeric: ## Change author-year to numeric citation
	@echo "==> $@"
	@echo "Change author-year to numeric citations"
	dos2unix $(AY2NUMERIC_SRC)
	chmod +x $(AY2NUMERIC_SRC)
	$(AY2NUMERIC_SRC)


NUMERICAY_SRC = ./inspecting/numeric2ay.sh
.PHONY: numericay
numericay: ## Change author-year to numeric citation
	@echo "==> $@"
	@echo "Change numeric to author-year citations"
	dos2unix $(NUMERICAY_SRC)
	chmod +x $(NUMERICAY_SRC)
	$(NUMERICAY_SRC)


#==============================================================================
# Define tex sources
#==============================================================================
# Define sources and outut
SRC_TEX := paper.tex
SRC_EXHIB := $(wildcard figures/* tables/*.tex)
OUT := $(SRC_TEX:%.tex=%.pdf)

.PHONY: list
list: ## List manifest
	@echo "=> Src TeX files:"
	@echo "   $(SRC_TEX)"
	@echo "=> Output (to make):"
	@echo "   $(OUT)"
	@echo "=> Exhibits in ms:"
	@echo "   $(SRC_EXHIB)"

#==============================================================================
# Clean/purge aux files
#==============================================================================
TEXAUX := *.aux *.bbl *.fdb_latexmk *.fls *.log *.nav *.out *.snm *.synctex.gz *.toc
.PHONY: cleantex
cleantex: ## Clean aux output files in LaTex compilation
	@echo "+ $@"
	rm -f $(TEXAUX)

#==============================================================================
# Build the paper
#==============================================================================

paper.pdf: $(SRC_TEX) $(SRC_EXHIB)
	@echo "+ $@"
	rm -f $@ && latexmk -pdf $(<F) && latexmk -c

.PHONY: paperc
paperc: ## Make paper and purge aux
paperc: $(SRC_TEX) $(SRC_EXHIB)
	@echo "+ $@"
	rm -f $(OUT) 
	latexmk -pdf $(<F)
	ps2pdf -dPDFSETTINGS=/screen $(OUT) _build/main-compressed.pdf
	latexmk -c
	rm -f $(OUT)
	chmod +x $(WORDCOUNT_SCR)
	dos2unix $(WORDCOUNT_SCR)
	$(WORDCOUNT_SCR)
# 	gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen -dNOPAUSE -dQUIET -dBATCH -sOutputFile=_build/main-compressed-optimized.pdf _build/main-compressed.pdf
# 	rm _build/main-compressed.pdf
# 	mv _build/main-compressed-opti
#https://web.mit.edu/ghostscript/www/Ps2pdf.htm
# /screen selects low-resolution output similar to the Acrobat Distiller "Screen Optimized" setting.
# /printer selects output similar to the Acrobat Distiller "Print Optimized" setting.
# /prepress selects output similar to Acrobat Distiller "Prepress Optimized" setting.
# /default selects output intended to be useful across a wide variety of uses, possibly at the expense of a larger output file.

.PHONY: paper
paper: ## Make paper (useful if still working w/ TexStudio)
paper: $(SRC_TEX) $(SRC_EXHIB)
	@echo "+ $@"
	rm -f $(OUT)gs ,
	latexmk -pdf $(<F)
	ps2pdf -dPDFSETTINGS=/screen $(OUT) _build/main-compressed.pdf
# 	chmod +x $(WORDCOUNT_SCR)
# 	dos2unix $(WORDCOUNT_SCR)
# 	$(WORDCOUNT_SCR)
	
#==============================================================================
# Help
#==============================================================================
.PHONY: help
help: ## Show this help message and exit 	
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'