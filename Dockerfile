FROM ubuntu:latest

# Set User Home Enviroment.
ENV HOME /usr/local
ENV WORKDIR $HOME/TeamSpeak5

# Set Display Enviroment for Docker (0.0/0).
# Windows: -e DISPLAY=host.docker.internal:0.0
# Linux: --net=host -e DISPLAY=:0.0
# MacOS: -e DISPLAY=docker.for.mac.host.internal:0.0
ENV DISPLAY "null"

# Expose Port for X11 Server.
EXPOSE 5900/tcp

# Set Non Interactive Shell Mode.
ENV DEBIAN_FRONTEND noninteractive

# Print Debug Message.
RUN echo ">> Updating Repositories of OS."

# Update Reposetory Entrys.
RUN apt-get update -y

# Print Debug Message.
RUN echo ">> Upgrading Packages of OS."

# Upgrade Package Entrys.
RUN apt-get upgrade -y

# Set Shell Instruction.
SHELL ["/bin/sh", "-c"]

# Set new Workdir.
WORKDIR $WORKDIR

# Create Workdir Directory.
RUN /bin/mkdir -p $WORKDIR

# Create new Volume for TeamSpeak Directory.
#VOLUME $WORKDIR

# Print Debug Message.
RUN echo ">> Installing WGET Application."

# Install WGET.
RUN apt-get install -y wget

# Print Debug Message.
RUN echo ">> Downloading TeamSpeak5 Client."

# Change Directory.
RUN cd "$WORKDIR"

# Download TeamSpeak5 Client (Skip Existing Files).
RUN wget -nc https://files.teamspeak-services.com/pre_releases/client/5.0.0-beta70/teamspeak-client.tar.gz

# List Files (Debugging)
RUN ls

# Print Debug Message.
RUN echo ">> Extracting TeamSpeak5 Archive Download."

# Extract Tar GZIP Archive.
RUN tar -xvzf "$WORKDIR/teamspeak-client.tar.gz"

# Print Debug Message.
RUN echo ">> Cleaning Up."

# Remove old Archive File.
# RUN rm teamspeak-client.tar.gz

# Print Debug Message.
RUN echo ">> Installing Dependencies for Client."

# Install missing Dependencies.
RUN apt-get install libgtk-3-dev -y
RUN apt-get install libxss1 -y
RUN apt-get install libnss3 -y
RUN apt-get install libnotify4 --fix-missing -y
RUN apt-get install libasound2 -y

# Print Debug Message.
RUN echo ">> Installing VNC Server for Client X11 Redirection."

# Set Timezone before Installing X11.
ENV TZ=Europe/Berlin

# Overriding / Linking Config Files.
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install VNC Server.
RUN apt-get install x11vnc xvfb -y

# Create Root VNC Directory.
RUN /bin/mkdir ~/.vnc

# Setup a VNC password
RUN x11vnc -storepasswd 12345678 ~/.vnc/passwd

# List Files (Debugging)
RUN ls

# Set Display Env.
RUN echo "DISPLAY=$DISPLAY"

# Print Debug Message.
RUN echo ">> Starting TeamSpeak5 Client."

# Run TeamSpeak5 if Display is not null (Building Process).
RUN if [ "$DISPLAY" = "null" ] ; then echo ">> Eventually running Build, don't forget Display ENV on start!" ; else ./TeamSpeak ; fi