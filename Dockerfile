FROM ubuntu:22.04

# ติดตั้ง dependencies
RUN apt-get update && apt-get install -y \
    curl \
    git \
    unzip \
    xz-utils \
    zip \
    libglu1-mesa \
    openssh-client \
    bash \
    wget \
    ca-certificates \
    lsb-release \
    software-properties-common

# ติดตั้ง Flutter SDK
RUN git clone https://github.com/flutter/flutter.git /usr/local/flutter
ENV PATH="$PATH:/usr/local/flutter/bin:/usr/local/flutter/bin/cache/dart-sdk/bin"

# ตั้งค่า Git safe directory
RUN git config --global --add safe.directory /usr/local/flutter

# เปลี่ยน channel และอัปเกรด Flutter
RUN flutter channel stable && flutter upgrade -f

# ยอมรับ Android licenses (หากจำเป็น)
RUN yes | flutter doctor --android-licenses

# ตรวจสอบสภาพแวดล้อม
RUN flutter doctor -v

# คัดลอกไฟล์โปรเจค
COPY . /app
WORKDIR /app

# ติดตั้ง dependencies และ build เว็บ
RUN flutter pub get && flutter build web

# ตั้งค่า working directory สำหรับ deploy
WORKDIR /app/build/web