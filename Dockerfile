FROM ubuntu:22.04
RUN apt-get update && apt-get install -y curl ca-certificates unzip
WORKDIR /app
RUN curl -L https://github.com/luvit/lit/raw/master/get-lit.sh | sh
COPY . .
CMD ["./luvit", "bot.lua"]
