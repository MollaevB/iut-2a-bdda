COMPOSE=docker-compose
UP=$(COMPOSE) up -d
DOWN=$(UP) --scale 
CONNECT=$(COMPOSE) run
LABEL_FILTER=--filter label=net.maxime-baumann.iut
ALL_CONTAINERS=docker container ls -aq --filter label=net.maxime-baumann.iut
COUNT_CONTAINERS=$(ALL_CONTAINERS) | wc -l

start: ## Starts all containers
	$(UP)

stop: ## Stops all containers
	$(COMPOSE) down

purge: ## Destroy all docker envs, don't do this
	docker container stop `$(ALL_CONTAINERS)`
	docker container prune --filter label=net.maxime-baumann.iut -f
	docker system prune -a --volumes --filter label=net.maxime-baumann.iut -f

start-sql: ## Starts SQL Server Container
	$(UP) mssql

connect-sql: ## Connects to SQL Server
	$(CONNECT) sqlcmd

stop-sql: ## Stops SQL Server Container
	$(DOWN) mssql=0 mssql

start-redis: ## Starts Redis Containers
	$(UP) redis readis phpredisadmin

connect-redis: ## Connects to redis Server
	$(CONNECT) rcli

stop-redis: ## Stops Redis Containers
	$(DOWN) readis=0 readis
	$(DOWN) phpredisadmin=0 phpredisadmin
	$(DOWN) redis=0 redis

start-mongo: ## Starts MongoDB Containers
	$(UP) mongo mongo-express

connect-mongo: ## Connects to mongodb Server
	$(CONNECT) mgcli

stop-mongo: ## Stops MongoDB Containers
	$(DOWN) mongo-express=0 mongo-express
	$(DOWN) mongo=0 mongo

start-cassandra: ## Starts Cassandra Container
	$(UP) cassandra

connect-cassandra: ## Connects to redis Server
	$(CONNECT) cqlsh

stop-cassandra: ## Stops Cassandra Container
	$(DOWN) cassandra=0 cassandra

start-neo4j: ## Starts Neo4j Container
	$(UP) neo4j

stop-neo4j: ## Stops Neo4j Container
	$(DOWN) neo4j=0 neo4j

.PHONY: help start stop start-sql connect-sql stop-sql start-redis connect-redis stop-redis start-mongo connect-mongo stop-mongo start-cassandra connect-cassandra stop-cassandra start-neo4j stop-neo4j

.DEFAULT_GOAL := help

help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'
