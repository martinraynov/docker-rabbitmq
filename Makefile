M = $(shell printf "\033[34;1m▶\033[0m")
APP_NAME = rmq

.PHONY: help
help: ## Prints this help message
	@grep -E '^[a-zA-Z_-]+:.?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

######################
### MAIN FUNCTIONS ###
######################

.PHONY: add_localhost
add_localhost: ## Add local host into /etc/hosts file (need root permission)
	@ echo "# >>> ${APP_NAME} for workspace" >> /etc/hosts
	@ echo "127.0.0.1\trmq.local.io rmq-ui.local.io" >> /etc/hosts
	@ echo "# <<< ${APP_NAME} for workspace" >> /etc/hosts
	$(info $(M) Local host added for ${APP_NAME} application in your hosts file)

.PHONY: remove_localhost
remove_localhost: ## Remove local host from /etc/hosts file (need root permission)
	@ sed -e '$(shell grep --line-number "# >>> ${APP_NAME} for workspace" /etc/hosts | cut -d ':' -f 1),$(shell grep --line-number "# <<< ${APP_NAME} for workspace" /etc/hosts | cut -d ':' -f 1)d' /etc/hosts  > /etc/hosts.tmp
	@ cp /etc/hosts.tmp /etc/hosts && rm -f /etc/hosts.tmp
	$(info $(M) Local host removed for ${APP_NAME} application in your hosts file)

.PHONY: start
start: ## Start the RMQ docker container
	$(info $(M) Starting an instance of ${APP_NAME} at : http://rmq.local.io/)
	@docker-compose -f ./docker/docker-compose.yml up -d

.PHONY: stop
stop: ## Stopping running RMQ instances
	$(info $(M) Stopping ${APP_NAME} instance)
	@docker-compose -f ./docker/docker-compose.yml down

.DEFAULT_GOAL := help
