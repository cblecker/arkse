FROM ubuntu:18.04
LABEL maintainer "Christoph Blecker <admin@toph.ca>"

# Tell debconf to run in non-interactive mode
ENV DEBIAN_FRONTEND noninteractive

# Agree to Steam licence
RUN echo "steam steam/question select I AGREE" | debconf-set-selections

# Install steamcmd
RUN dpkg --add-architecture i386 && \
    apt-get update && apt-get install -y \
    ca-certificates \
    locales locales-all \
    steamcmd --no-install-recommends \
    && rm -rf /var/lib/apt/lists/*

# Create and use unprivileged user
RUN adduser --disabled-password --gecos "" --uid 1077 ark
USER ark

# Download ARK: Survival Evolved Dedicated Server
RUN mkdir -p /opt/ark
RUN /usr/games/steamcmd +login anonymous \
    +force_install_dir /opt/ark \
    +app_update 376030 +quit

# Set working directory
WORKDIR /opt/ark/ShooterGame/Binaries/Linux
