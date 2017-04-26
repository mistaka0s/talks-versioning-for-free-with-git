# Useful for debugging
# SHELL = /bin/bash -xv

# VERSIONING
GIT_SHA := $(shell git rev-list --no-merges -n 1 HEAD)
GIT_VERSION := $(shell git describe --tags $(GIT_SHA))
APP_VERSION := $(shell perl -ne '/$(VERSION_REGEX)/ && print $$1' $(VERSION_FILE))

# BRANCHES
BRANCH := $(shell git rev-parse --abbrev-ref HEAD )
CHANGES := $(shell git status --porcelain)

# TAG CHECKS
# STABLE_BRANCH_REGEX: A PCRE based regex for all branches which we consider as stable and want to create git tags against. 
STABLE_BRANCH_REGEX := master|release.*

# ALLOW_TAG: Checks whether the branch is a branch we would like to tag on (defined in $STABLE_BRANCH_REGEX)
#            Returns 1 if we allow tagging on the current branch, otherwise returns 0
ALLOW_TAG := $(shell echo $(BRANCH) | perl -ne '/$(STABLE_BRANCH_REGEX)/ ? print 1 : print 0' )

# ALLOW_TAG_PUSH: Checks whether or not the current commit is has a tag, and if so allow the tags to be pushed.
#                 Returns 1 if we allow the tag to be pushed, otherwise returns 0
ALLOW_TAG_PUSH := $(shell git describe --tags | perl -ne '/(.*)-g(.*)/ ? print 0: print 1' )

# LOGIC TO CALCULATE NEXT VERSION
# If there is no tag starting with $(APP_VERSION), then a tag a patch version of 0
# will be created. (eg $(APP_VERSION).0 )
#
# If there is an existing tag starting with $(APP_VERSION), it will derive the next patch version
# and increment it by one.
#
# The derived tag will be $(GIT_NEXT_VERSION)
GIT_CURRENT_TAG_VERSION := $(shell git describe --tags --match "$(APP_VERSION).*" --always | perl -ne '/(\d+\.){2}\d+/ && print' )
NEXT_PATCH_VERSION := $(shell echo $(GIT_CURRENT_TAG_VERSION) | perl -ne '/(\d+\.){2}(\d+).*/ ? print $$2+1 : print 0; last')
GIT_NEXT_VERSION := $(APP_VERSION).$(NEXT_PATCH_VERSION)

.PHONY: tag
tag:
	$(info Tagging local repo with $(GIT_NEXT_VERSION))
ifeq ("$(GIT_VERSION)","$(GIT_CURRENT_TAG_VERSION)")
	$(error Not tagging as there is already a tag here)
	@exit 1
endif
ifneq ("$(CHANGES)","")
	$(error Working directory should be clean. Please check using git status)
	@exit 1
endif

ifeq ("$(ALLOW_TAG)","0")
	$(error Tags should only be applied in master or release branches)
	@exit 1
endif
	git tag -f $(GIT_NEXT_VERSION)
	$(eval GIT_VERSION=$(GIT_NEXT_VERSION))

.PHONY: tag-push
tag-push:
	$(info Pushing Tag: $(GIT_VERSION))
ifneq ("$(ALLOW_TAG_PUSH)","0")
	$(error A valid git tag is not present at this HEAD. Please run 'make tag')
	@exit 1
endif
	git push origin $(GIT_VERSION)

.PHONY: print-%
print-%:
	@echo $* = $($*)
