FROM debian:bookworm-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends \
      bash coreutils grep gawk sed findutils less procps \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /challenge
COPY . /challenge/

RUN chmod +x /challenge/start.sh /challenge/run.sh /challenge/lib/*.sh \
    && if [ -f /challenge/door_game.sh ]; then chmod +x /challenge/door_game.sh; fi

