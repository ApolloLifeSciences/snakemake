
from snakemake.io import external

N_IMAGES = 1000

rule all:
    input:
        "results/final.txt"


rule preprocess:
    input:
        external("raw/image_{i}.tif")
    output:
        "processed/image_{i}.txt"
    shell:
        "python -c \"from pathlib import Path; "
        "Path(r'{output}').write_text(Path(r'{input}').read_text())\""


rule aggregate:
    input:
        expand("processed/image_{i}.txt", i=range(N_IMAGES))
    output:
        "results/final.txt"
    run:
        from pathlib import Path

        Path(output[0]).parent.mkdir(parents=True, exist_ok=True)
        Path(output[0]).write_text(
            "\n".join(Path(f).read_text() for f in input)
        )
