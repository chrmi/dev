FROM ubuntu as base

# General updates & tools
RUN apt-get update && apt-get install -y curl tar wget tmux vim tree watch git unzip \
    # Python development
    python-dev python-pip python3 python3-pip python3-venv \
    # C++ development
    software-properties-common build-essential gcc g++ make cmake ninja-build \
    # Google Test: https://github.com/google/googletest
    libgtest-dev \
    # Microsoft C++ Rest SDK and dependencies: https://github.com/microsoft/cpprestsdk
    zlib1g-dev libffi-dev libcpprest-dev \
    # C++ Boost and dependencies (OpenSSL): https://www.boost.org/
    libboost-atomic-dev libboost-thread-dev libboost-system-dev libboost-date-time-dev \
    libboost-regex-dev libboost-filesystem-dev libboost-random-dev libboost-chrono-dev \
    libboost-serialization-dev libwebsocketpp-dev openssl libssl-dev \
    # Google Cloud C++ Common (previously required removed): https://github.com/googleapis/google-cloud-cpp-common
    apt-transport-https apt-utils automake ca-certificates \
    libc-ares-dev libc-ares2 libcurl4-openssl-dev m4 pkg-config \
    # Additional for Azure CLI
    lsb-release gnupg