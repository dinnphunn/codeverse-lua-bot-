FROM ubuntu:22.04
RUN apt-get update && apt-get install -y curl ca-certificates unzip git
WORKDIR /app
RUN curl -L https://github.com/luvit/lit/raw/master/get-lit.sh | sh
COPY . .
RUN if [ -f "package.lua" ]; then ./lit install; fi
CMD ["./luvit", "bot.lua"]
