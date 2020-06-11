FROM ruby:2.6

WORKDIR /usr/src/app

COPY Gemfile ./

COPY Makefile ./

RUN make install

COPY . .

# Install a Javascript environment in the container to avoid ExecJS::RuntimeUnavailable
RUN curl -sL https://deb.nodesource.com/setup_10.x | bash - \
    && apt install -y nodejs

EXPOSE 4567

CMD ["make", "serve"]
