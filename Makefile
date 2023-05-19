SOMEVAR='bar'

## Docker

dc.up:
	docker-compose up -d

dc.build:
	docker-compose up -d --build

dc.recreate:
	docker-compose up -d --no-deps --build $(filter-out $@,$(MAKECMDGOALS))


## PHP

php.connect:
	docker-compose exec php bash

hp.connect.root:
	docker-compose exec --user=root php bash

## Composer

composer:
	docker-compose exec php composer $(filter-out $@,$(MAKECMDGOALS))


## Linters

lint.php.check.compatibility:
	docker-compose exec php sh -c 'composer run phpcs-check-compatibility'

# config adaptation is important dev/.phan/config.php
# the finish message like: "make: *** [phan] Error 1" - it is normal behavior
phan:
	docker-compose exec php sh -c './vendor/bin/phan -k dev/.phan/config.php'
