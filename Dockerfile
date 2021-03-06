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

# Create unprivileged user and working directory
RUN adduser --disabled-password --gecos "" --gid 0 ark && \
    mkdir /opt/ark && \
    chown ark:0 /opt/ark

# Drop unneded permissions
USER ark

# Copy in install script
COPY ark-install.txt /home/ark/

# Download ARK: Survival Evolved Dedicated Server, ensuring permissions are
# uniform after installation.
RUN /usr/games/steamcmd +runscript /home/ark/ark-install.txt && \
    chmod -R g=u /opt/ark

# Set working directory
WORKDIR /opt/ark

# Use ShooterGameServer as the default entrypoint
ENTRYPOINT /opt/ark/ShooterGame/Binaries/Linux/ShooterGameServer
