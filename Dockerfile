FROM ubuntu:22.04

#########################
# Install prerequisites #
#########################

RUN \
  apt-get update && \
  DEBIAN_FRONTEND=noninteractive apt-get install -y ca-certificates curl git libxml2

#########################
# Install WASI SDK 16.0 #
#########################

RUN curl -L https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-16/wasi-sdk-16.0-linux.tar.gz | tar xzk --strip-components=1 -C /

#####################
# Build actual code #
#####################

WORKDIR /code

RUN curl -L https://www.openwall.com/crypt/crypt_blowfish-1.3.tar.gz | tar xzk

# Relase build
RUN clang --sysroot=/share/wasi-sysroot --target=wasm32-unknown-wasi -flto -O3     -o bcrypt.wasm -D__SKIP_GNU -mexec-model=reactor -fvisibility=hidden -Wl,--export=malloc,--export=free,--export=crypt,--export=crypt_gensalt,--strip-all -- crypt_blowfish-1.3/crypt_blowfish.c crypt_blowfish-1.3/crypt_gensalt.c crypt_blowfish-1.3/wrapper.c

# Debug build
# RUN clang --sysroot=/share/wasi-sysroot --target=wasm32-unknown-wasi -flto -O0 -g3 -o bcrypt.wasm -D__SKIP_GNU -mexec-model=reactor -fvisibility=hidden -Wl,--export=malloc,--export=free,--export=crypt,--export=crypt_gensalt             -- crypt_blowfish-1.3/crypt_blowfish.c crypt_blowfish-1.3/crypt_gensalt.c crypt_blowfish-1.3/wrapper.c

CMD base64 --wrap=0 bcrypt.wasm
