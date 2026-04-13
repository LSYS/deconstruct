.DEFAULT_GOAL := help

VENVPATH ?= venv_deconstruct

ifeq ($(OS),Windows_NT)
	ACTIVATE_PATH := ../$(VENVPATH)/Scripts/activate
else
	ACTIVATE_PATH := ../$(VENVPATH)/bin/activate
endif


########################################################################
# Make data in pipeline
########################################################################
.PHONY: data
data: ## Run all notebooks in sequence with output versions (-o)
	@echo "==> Executing notebooks with runpynb in $(VENVPATH)"
	. $(ACTIVATE_PATH) && \
	  ( cd 7-merge && runpynb merge.ipynb ) && \
	  ( cd 8-VOTER && runpynb processVOTER.ipynb ) && \
	  ( cd 9-election2016Data && runpynb get-house2016-data.ipynb )

########################################################################
# Jupytext sync to .py
########################################################################
.PHONY: sync-setup
sync-setup: ## Set up jupytext sync for all notebooks (creates .py files in logs/)
	@echo "==> Setting up jupytext sync in $(VENVPATH)"
	@mkdir -p logs
	. $(ACTIVATE_PATH) && \
	jupytext --set-formats ipynb,logs//py *.ipynb
	@echo "All notebooks now synced with Python files in logs/"

.PHONY: sync
sync: ## Manually sync w/ Jupytext all paired notebooks with their .py files
	@echo "==> Syncing notebooks with Python files"
	. $(ACTIVATE_PATH) && \
	jupytext --sync *.ipynb
	@echo "Sync complete"

########################################################################
# Other utilities
########################################################################
.PHONY: help
help: ## Show this help message and exit
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-16s\033[0m %s\n", $$1, $$2}'