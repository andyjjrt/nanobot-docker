FROM python:3.13-slim
COPY --from=ghcr.io/astral-sh/uv:latest /uv /uvx /bin/

COPY .python-version uv.lock pyproject.toml /app/

WORKDIR /app
RUN uv sync --frozen  --no-dev
ENV PATH="/app/.venv/bin:${PATH}"

# Create non-root user and config directory
RUN useradd -m -u 1000 -s /bin/bash nanobot && \
    mkdir -p /home/nanobot/.nanobot && \
    chown -R nanobot:nanobot /home/nanobot

USER nanobot
ENV HOME=/home/nanobot
WORKDIR /home/nanobot

# Gateway default port
EXPOSE 18790

ENTRYPOINT ["nanobot"]
CMD ["status"]