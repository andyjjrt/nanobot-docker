# ===============
# Builder
# ===============

FROM python:3.13-slim AS builder

ARG UV_SYNC_ARGS="--no-dev"

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    UV_LINK_MODE=copy \
    UV_COMPILE_BYTECODE=1 \
    UV_PYTHON_DOWNLOADS=never \
    UV_PROJECT_ENVIRONMENT=/opt/venv \
    PATH=/opt/venv/bin:/root/.local/bin:$PATH

COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /usr/local/bin/

WORKDIR /tmp/build
COPY pyproject.toml uv.lock ./

RUN --mount=type=cache,target=/root/.cache/uv \
    uv sync --frozen $UV_SYNC_ARGS

# ===============
# Runtime
# ===============

FROM python:3.13-slim AS runtime

ENV PYTHONDONTWRITEBYTECODE=1 \
    PYTHONUNBUFFERED=1 \
    HOME=/home/nanobot \
    PATH=/opt/venv/bin:$PATH

RUN useradd -m -u 10001 -s /bin/sh nanobot

WORKDIR /home/nanobot
COPY --from=builder --chown=nanobot:nanobot /opt/venv /opt/venv

USER nanobot
CMD ["nanobot"]