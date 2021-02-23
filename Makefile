project=compile-testdata

main: stop build start exec

build:
	podman-compose build
	@podman images

no-cache:
	podman-compose build --no-cache
	@podman images

clean:
	@podman pod stop $(project)
	@podman rm $(project)
	@podman rmi $(project)
	@rm -rf .stack-work

run:
	#podman-compose up
	podman pod start $(project)

start:
	#podman-compose up -d
	#podman pod start $(project)
	podman start $(project)

	podman ps -a

exec:
	@podman exec -it $(project) bash || true

stop:
	@if [[ -n "$$(podman images -q $(project))" ]]; then podman pod stop $(project); fi
	@podman ps -a

list:
	podman container ls -a

