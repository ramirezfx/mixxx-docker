FROM ubuntu:rolling

RUN DEBIAN_FRONTEND=noninteractive \
    apt-get update && \
    apt-get install -y locales locales-all && \
    apt-get install -y tzdata && \
    apt-get install -y keyboard-configuration

    

# --- Custom Code here:

# Add additional apt-packages and dependencies here:
# Uncomment next line if you wanna use audio in your app
RUN apt-get install -y wget pulseaudio alsa dbus-x11 procps psmisc

# Custom Script(s) here:
RUN apt-get install -y mixxx


#  --- End Custom Code

RUN rm -rf /var/lib/apt/lists/*

# Set Timezone
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Set System Language
RUN echo $LANG > /etc/locale.gen && \
    env DEBIAN_FRONTEND=noninteractive apt-get install -y \
     locales && \
     locale-gen $LANG || update-locale --reset LANG=$LANG

ENV LANG de_AT.UTF-8
ENV TZ=Europe/Vienna

ENV QT_GRAPHICSSYSTEM="native"
COPY entrypoint.sh /
RUN chmod +x entrypoint.sh

CMD ["/bin/sh", "/entrypoint.sh"]
