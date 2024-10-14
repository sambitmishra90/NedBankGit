{\rtf1\ansi\ansicpg1252\cocoartf2639
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\tx2267\tx2834\tx3401\tx3968\tx4535\tx5102\tx5669\tx6236\tx6803\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # Use an OpenJDK base image\
FROM openjdk:11-jdk\
\
# Set environment variables for Android SDK paths\
ENV ANDROID_SDK_ROOT /sdk\
ENV PATH "$PATH:$\{ANDROID_SDK_ROOT\}/cmdline-tools/latest/bin:$\{ANDROID_SDK_ROOT\}/platform-tools:$\{ANDROID_SDK_ROOT\}/tools:$\{ANDROID_SDK_ROOT\}/tools/bin"\
\
# Install required dependencies\
RUN apt-get update && apt-get install -y \\\
    unzip \\\
    wget \\\
    git \\\
    build-essential \\\
    && rm -rf /var/lib/apt/lists/*\
\
# Download and install Android SDK command line tools\
RUN mkdir -p $\{ANDROID_SDK_ROOT\}/cmdline-tools && cd $\{ANDROID_SDK_ROOT\}/cmdline-tools \\\
    && wget https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip \\\
    && unzip commandlinetools-linux-8512546_latest.zip \\\
    && rm commandlinetools-linux-8512546_latest.zip\
\
# Install Android SDK components (example for Android 30)\
RUN yes | sdkmanager --sdk_root=$\{ANDROID_SDK_ROOT\} --licenses\
RUN sdkmanager "platform-tools" "build-tools;30.0.3" "platforms;android-30"\
\
# Copy your Android project to the container\
COPY . /app\
WORKDIR /app\
\
# Build your Android app\
CMD ["./gradlew", "assembleDebug"]\
}