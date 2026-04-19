# nanobot-docker

Docker image definitions for running `nanobot-ai` in a minimal, production-friendly container.

## What this repository provides

- A multi-stage Docker build based on `python:3.13-slim`
- Fast, reproducible dependency installation using `uv`
- A non-root runtime user (`nanobot`, uid `10001`)
- Small runtime image containing only the virtual environment and app entrypoint

The default container command is:

```bash
nanobot
```

## Image variants

Dependency variants are controlled through the Docker build arg `UV_SYNC_ARGS`.

- Default: core package only
- API variant: includes `nanobot-ai[api]`
- Discord variant: includes `nanobot-ai[discord]`

Examples:

```bash
# Core image
docker build -t nanobot:core .

# API extras
docker build \
	--build-arg UV_SYNC_ARGS="--no-dev --extra api" \
	-t nanobot:api .

# Discord extras
docker build \
	--build-arg UV_SYNC_ARGS="--no-dev --extra discord" \
	-t nanobot:discord .
```

## Run the container

```bash
docker run --rm -it nanobot:core
```

If your bot needs environment variables, pass them with `-e` or `--env-file`:

```bash
docker run --rm -it \
	--env-file .env \
	nanobot:core
```

## Pulling a published image

If you publish to a registry such as GHCR, consumers can run:

```bash
docker pull ghcr.io/<org>/nanobot:<tag>
docker run --rm -it ghcr.io/<org>/nanobot:<tag>
```

Replace `<org>` and `<tag>` with your published values.

## Project files

- `Dockerfile`: multi-stage build (builder + runtime)
- `pyproject.toml`: package metadata and optional dependency groups
- `uv.lock`: locked dependency graph for reproducible builds

## Notes

- Base Python version is `3.13`
- Runtime uses a prebuilt venv at `/opt/venv`
- Container runs as non-root user `nanobot`