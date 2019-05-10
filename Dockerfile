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

# Create directory and set permissions
RUN mkdir /opt/ark && chown ark:ark /opt/ark

# Drop unneded permissions
USER ark

# Copy in install script
COPY --chown=1077 ark-install.txt /home/ark/

# Download ARK: Survival Evolved Dedicated Server
RUN /usr/games/steamcmd +runscript /home/ark/ark-install.txt

# Set working directory
WORKDIR /opt/ark/ShooterGame/Binaries/Linux
