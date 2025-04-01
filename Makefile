build:
	docker build . -t 'vidjil-pipeline:1.0.3'

run:
	docker run --volume ./data/indir:/data/indir --volume ./data/outdir:/data/outdir vidjil-pipeline:1.0.3 


run-bash:
	docker run -it --volume ./data/indir:/data/indir --volume ./data/outdir:/data/outdir  --entrypoint /bin/bash vidjil-pipeline:1.0.3 




PHONY: build run run-bash