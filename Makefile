start: frmg schtroumpsify

frmg:
	docker-compose -f ./infrastructure/docker-compose.yaml -f ./infrastructure/docker-compose.dev.yaml up frmg

schtroumpsify:
	iex -S mix phx.server
