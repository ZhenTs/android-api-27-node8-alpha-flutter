FROM circleci/android:api-27-node8-alpha

# Flutter


ENV FLUTTER_ROOT="/home/circleci/flutter"
ENV FLUTTER_SDK_ARCHIVE="/home/circleci/flutter.tar.xz"
ENV FLUTTER_SDK_URL="https://storage.flutter-io.cn/flutter_infra/releases/stable/linux/flutter_linux_1.20.0-stable.tar.xz"
#ENV FLUTTER_SDK_URL="https://storage.googleapis.com/flutter_infra/releases/stable/linux/flutter_linux_1.20.0-stable.tar.xz"
#RUN sudo curl --output "${FLUTTER_SDK_ARCHIVE}" --url "${FLUTTER_SDK_URL}" \
#  && tar --extract --file="${FLUTTER_SDK_ARCHIVE}" --directory=$(dirname ${FLUTTER_ROOT}) \
#  && rm "${FLUTTER_SDK_ARCHIVE}"


COPY ./flutter_linux_1.20.0-stable.tar.xz "${FLUTTER_SDK_ARCHIVE}"

RUN tar --extract --file="${FLUTTER_SDK_ARCHIVE}" --directory=/home/circleci/ \
  && rm "${FLUTTER_SDK_ARCHIVE}"

#RUN sudo chmod -R 777 "${FLUTTER_ROOT}/*"
# Dependencies
ENV LANG en_US.UTF-8
#RUN sudo apt-get update -y \
## Install basics
#  && sudo apt-get install -y --no-install-recommends \
#  # zip \
#  locales \
#  libstdc++6 \
#  lib32stdc++6 \
#  libglu1-mesa \
#  build-essential \
## Clean up image
#  && sudo locale-gen en_US ${LANG} \
#  && sudo dpkg-reconfigure locales \
#  && sudo apt-get autoremove -y \
#  && sudo rm -rf /var/lib/apt/lists/*

RUN yes "y" | ${FLUTTER_ROOT}/bin/flutter doctor --android-licenses \
  && ${FLUTTER_ROOT}/bin/flutter doctor

# Edit path and create access to executables
# Add android executables to path (example: adb avdmanager)
ENV PATH="${PATH}:${ANDROID_SDK_ROOT}/tools/bin:${ANDROID_SDK_ROOT}/platform-tools:${ANDROID_SDK_ROOT}/build-toos/${ANDROID_SDK_VERSION}"
# Add flutter executable to path
ENV PATH="${PATH}:${FLUTTER_ROOT}/bin"
# Make it easy to use other Dart and Pub packages
ENV DART_SDK="${FLUTTER_ROOT}/bin/cache/dart-sdk"
ENV PUB_CACHE=${FLUTTER_ROOT}/.pub-cache
ENV PATH="${PATH}:${DART_SDK}/bin:${PUB_CACHE}/bin"