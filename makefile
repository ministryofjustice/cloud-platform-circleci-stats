start_db:
	docker run \
		--name db \
		-e POSTGRES_DB=circle_stats \
		-e POSTGRES_USER=stats \
		-e POSTGRES_PASSWORD=password123 \
		-p 5432:5432 \
		-d postgres

stop_db:
	docker stop db
	docker rm db
