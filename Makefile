README_FILES := $(shell find . -type f -not -path './.git/*' -name 'README.md' -o -name 'WINDOWS.md' -o -name 'MAC_LINUX_DOCKER.md')
DIRECTORIES := $(shell find $(PWD) -type f -name 'README.md' -exec dirname {} \;)
WORKFLOWS := $(shell find . -type f -name "*.yml" ! -name "*-cloudformation-template.yml")

hello:
	@echo "This makefile has the following tasks:"
	@echo "\tlint        - lint README files"
	@echo "\tspellcheck  - spell check README files"
	@echo "\tfooter      - generate footer links for README files"
	@echo "\tpdf         - generate PDFs for README files"
	@echo "\tupdate-titles - update titles in README files"
	@echo "\tclean       - remove backup files"
	@echo "\tall         - run all tasks (except clean)"

#all: footer lint spellcheck
all: clean chapterlist-touch update-titles footer spellcheck lint
	@echo "Done."

lint:
	-@docker run --rm -v $(PWD):/workdir davidanson/markdownlint-cli2:v0.20.0 $(README_FILES) 2>&1 | \
		docker run --rm --interactive ghcr.io/managedkaos/summarize-markdown-lint:main

rawlint:
	-@docker run -v $(PWD):/workdir davidanson/markdownlint-cli2:v0.20.0 $(README_FILES) 2>&1

spellcheck:
	@echo "Spell checking README files..."
	@for file in $(README_FILES); do \
		echo "\t$$file"; \
		aspell check --mode=markdown --lang=en $$file; \
	done

toc:
	@echo "Generating table of contents for README files..."
	-@docker pull ghcr.io/managedkaos/readme-toc-generator:main
	@docker run --rm --volume $(PWD):/data ghcr.io/managedkaos/readme-toc-generator:main

footer:
	@echo "Generating footer links for README files..."
	-@docker pull ghcr.io/managedkaos/readme-footer-generator:main
	@docker run --rm --volume $(PWD):/data ghcr.io/managedkaos/readme-footer-generator:main

pdf: $(DIRECTORIES)

$(DIRECTORIES):
	@echo "Processing directory: $@"
	@cd $@ && pandoc README.md -o $(notdir $@)-README.pdf
	@cd $(PROJECT_HOME)

update-workflows: $(WORKFLOWS)

$(WORKFLOWS):
	@if [ -z "$$GITHUB_TOKEN" ]; then \
		echo "Error: GITHUB_TOKEN is not set."; \
		exit 1; \
	fi
	docker run --env GITHUB_TOKEN=$(GITHUB_TOKEN) \
		--volume $(PWD):/work \
		ghcr.io/managedkaos/get-action-version-number:main --update-in-place --workflow $@

# Step 1: Generate the individual actions.txt files
get-action-versions:
	@if [ -z "$$GITHUB_TOKEN" ]; then \
		echo "Error: GITHUB_TOKEN is not set."; \
		exit 1; \
	fi
	@find . -type f -name "*.yml" ! -name "*-cloudformation-template.yml" ! -path "./.github*" | \
	while read -r yml_path; do \
		dir_name=$$(dirname "$$yml_path"); \
		echo "Processing $$yml_path..."; \
		docker run --rm --env GITHUB_TOKEN="$$GITHUB_TOKEN" \
			--volume "$$PWD:/work" \
			ghcr.io/managedkaos/get-action-version-number:main \
			--workflow "$$yml_path" | awk '{print $$1}' | sort | uniq > "$$dir_name/actions.txt"; \
	done

# Step 2: Collect data into the Markdown summary and cleanup
summarize-action-versions:
	@echo "# Action Version Summary" > ACTION_VERSION_SUMMARY.md
	@echo "" >> ACTION_VERSION_SUMMARY.md
	@echo "## Action Versions" >> ACTION_VERSION_SUMMARY.md
	@echo "" >> ACTION_VERSION_SUMMARY.md
	@find . -type f -name actions.txt -exec cat {} \; \
		| sort | uniq | sed -e 's/^/- /' >> ACTION_VERSION_SUMMARY.md
	@echo "Summary created: ACTION_VERSION_SUMMARY.md"
	@cat ACTION_VERSION_SUMMARY.md

wordcount:
	@find . -type f -name README.md -exec wc -l {} \; | sort -nr

chapterlist:
	@find . -type f -name README.md | sed 's/\/README.md//' | sed 's/\.\///' | sed '/\./d' | sort

chapterlist-touch:
	@if [ -f CHAPTER_LIST.txt ]; then \
		if fgrep "/0_0" CHAPTER_LIST.txt; then \
			echo "CHAPTER_LIST.txt contains /0_0"; \
			exit 1; \
		fi; \
	fi
	@cat ./CHAPTER_LIST.txt | while read line; do \
		echo "$$line"; \
		mkdir -p $$line; \
		touch $$line/README.md; \
	done

overlay:
	@find . -type f -name README.md | sort | sed 's/^\.\///' | sed 's/\// > /g' | sed 's/ > README.md//'

overlay-chapter-list:
	@sed 's/\// > /g' CHAPTER_LIST.txt

clean:
	find . -type f -name \*.bak -delete
	find . -type f -name \*.new -delete
	find . -type f -name actions.txt -delete
	find . -type d -name .pytest_cache -exec trash {} \;
	find . -type f -name \*.pdf -not \( -path '*/github-actions-cheat-sheet.pdf' \) -delete
	$(MAKE) clean -C ./ch1_integration/01_02_ci_for_javascript/
	$(MAKE) clean -C./ch1_integration/01_03_ci_for_python/
	$(MAKE) clean -C./ch1_integration/01_04_ci_for_go/

nuke: clean
	find /tmp/ -type f -name \*.pdf -delete

update-titles:
	@if [ ! -f CHAPTER_LIST.txt ] || [ ! -f CHAPTER_TITLES.txt ]; then \
		echo "Error: CHAPTER_LIST.txt and CHAPTER_TITLES.txt must exist"; \
		exit 1; \
	fi
	@paste -d '|' CHAPTER_LIST.txt CHAPTER_TITLES.txt | while IFS='|' read -r dir title; do \
		if [ -f "$$dir/README.md" ]; then \
			echo "$$dir/README.md: $$title"; \
			# Create a temporary file with the new title \
			echo "# $$title" > "$$dir/README.md.tmp"; \
			# Append the rest of the file (skip the first line if it's a title) \
			if [ -s "$$dir/README.md" ]; then \
				tail -n +2 "$$dir/README.md" >> "$$dir/README.md.tmp" 2>/dev/null || \
				cat "$$dir/README.md" >> "$$dir/README.md.tmp"; \
			fi; \
			# Replace the original file \
			mv "$$dir/README.md.tmp" "$$dir/README.md"; \
		else \
			echo "Warning: $$dir/README.md not found"; \
		fi; \
	done

.PHONY: hello lint spellcheck toc footer pdf countlines chapterlist overlay clean nuke update-titles check-work $(DIRECTORIES) $(WORKFLOWS) get-action-versions summarize-action-versions
