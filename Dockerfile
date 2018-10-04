FROM i386/ubuntu:18.04 as builder

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

# Agree to Steam licence
RUN echo "steam steam/question select I AGREE" | debconf-set-selections

# Install steamcmd
RUN apt-get update && apt-get install -y \
    ca-certificates \
    locales locales-all \
    steamcmd --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

RUN /usr/games/steamcmd +login anonymous +app_update 376030 +quit

####################
FROM ubuntu:18.04
LABEL maintainer "Christoph Blecker <admin@toph.ca>"

# Copy Ark from builder
COPY --from=builder ["/root/.steam/SteamApps/common/ARK Survival Evolved Dedicated Server","/opt/ark"]
