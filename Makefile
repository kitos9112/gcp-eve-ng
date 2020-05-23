# Copyright 2016 Philip G. Porada
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

.ONESHELL:
.SHELL := /usr/bin/bash
.PHONY: apply destroy-backend destroy destroy-target plan-destroy plan plan-target prep
VARS="../vars/secrets.tfvars"
CURRENT_FOLDER=$(shell basename "$$(pwd)")
S3_BUCKET="$(ENV)-$(REGION)-yourCompany-terraform"
DYNAMODB_TABLE="$(ENV)-$(REGION)-yourCompany-terraform"
WORKSPACE="$(ENV)-$(REGION)"
BOLD=$(shell tput bold)
RED=$(shell tput setaf 1)
GREEN=$(shell tput setaf 2)
YELLOW=$(shell tput setaf 3)
RESET=$(shell tput sgr0)

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

# TERRAFORM INFRASTRUCTURE FORMAT || LINT || DOCUMENTATION
format-all: prep ## Rewrites all Terraform configuration files to a canonical format.
	@cd infrastructure/base; terraform fmt \
		-write=true \
    -recursive && \
	 cd ../overlay; terraform fmt \
	 	-write=true \
    -recursive

# https://github.com/terraform-linters/tflint
lint: prep ## Check for possible errors, best practices, etc in current directory!
	@tflint

documentation: prep ## Generate README.md for a module
	@cd infrastructure; terraform-docs \
		markdown table \
		--sort-by-required  . > README.md

# TERRAFORM INFRASTRUCTURE DESTROY
destroy-all: prep ## Rewrites all Terraform configuration files to a canonical format.
	@cd infrastructure/overlay; terraform destroy \
		-input=false \
		-refresh=true \
		--auto-approve \
		-var-file="$(VARS)"&& \
	 cd ../base; terraform destroy \
		-input=false \
		-refresh=true \
		--auto-approve \
		-var-file="$(VARS)"

plan-destroy-base: prep ## Creates a destruction plan.
	@cd infrastructure/base; terraform destroy \
		-input=false \
		-refresh=true \
		-destroy \
		-var-file="$(VARS)"

destroy-overlay: prep ## Automatically destroy the things under infrastructure/overlay
	@cd infrastructure/overlay; terraform destroy \
		-lock=true \
		-input=false \
		-refresh=true \
		--auto-approve \
		-var-file="$(VARS)"

destroy-base: prep ## Automatically destroy the things under infrastructure/base
	@cd infrastructure/base; terraform destroy \
		-lock=true \
		-input=false \
		-refresh=true \
		--auto-approve \
		-var-file="$(VARS)"

destroy-base-target: prep ## Destroy a specific infrastructure/base resource. Caution though, this destroys chained resources.
	@echo "$(YELLOW)$(BOLD)[INFO] Specifically destroy a piece of Terraform data.$(RESET)"; echo "Example to type for the following question: module.rds.aws_route53_record.rds-master"
	@read -p "Destroy target: " DATA && \
		cd infrastructure/base; terraform destroy \
		-lock=true \
		-input=false \
		-refresh=true \
		-var-file=$(VARS) \
		-target=$$DATA

# TERRAFORM INFRASTRUCTURE INIT
init-overlay: prep ## Show what terraform thinks it will do
	@cd infrastructure/overlay; terraform init \
		-lock=true \
		-input=false

init-base: prep ## Show what terraform thinks it will do
	@cd infrastructure/base; terraform init \
		-lock=true \
		-input=false

# TERRAFORM INFRASTRUCTURE PLAN
plan-base: prep ## Show what terraform thinks it will do
	@cd infrastructure/base; terraform plan \
		-lock=true \
		-input=false \
		-refresh=true \
		-var-file="$(VARS)"

plan-overlay: prep ## Show what terraform thinks it will do
	@cd infrastructure/overlay; terraform plan \
		-lock=true \
		-input=false \
		-refresh=true \
		-var-file="$(VARS)"


# TERRAFORM INFRASTRUCTURE APPLY
apply-overlay-auto: prep ## AUTOMATICALLY Have terraform do the things. This will cost money.
	@cd infrastructure/overlay; terraform apply \
		-lock=true \
		-input=false \
		-refresh=true \
		--auto-approve \
		-var-file="$(VARS)"

apply-base-auto: prep ## AUTOMATICALLY Have terraform do the things. This will cost money.
	@cd infrastructure/base; terraform apply \
		-lock=true \
		-input=false \
		-refresh=true \
		--auto-approve \
		-var-file="$(VARS)"
