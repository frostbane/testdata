project=testdata-compiler

dummy:
	@echo -n ""

main: stop build start exec

build:
	podman-compose build
	@podman images

no-cache:
	podman-compose build --no-cache
	@podman images

clean: .cleantags
	@podman stop $(project)
	@podman rm $(project)
	@podman rmi $(project)
	@rm -rf .stack-work

run:
	#podman-compose up
	podman start $(project)

start:
	#podman-compose up -d
	#podman pod start $(project)
	podman start $(project)

	podman ps -a

exec:
	@podman exec -it $(project) pwsh || true

stop:
	@if [[ -n "$$(podman images -q $(project))" ]]; then podman stop $(project); fi
	@podman ps -a

list:
	podman container ls -a

diff:
	hg extdiff --program diffuse --per-file

.cleantags:
	@rm -f tags
tags: .cleantags
	@fast-tags -R --fully-qualified --exclude=var .
	fast-tags -R --qualified --exclude=var .
