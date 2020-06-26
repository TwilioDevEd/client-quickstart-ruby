FROM ruby:2.6

WORKDIR /usr/src/app

COPY Gemfile ./

COPY Makefile ./

RUN make install

COPY . .

EXPOSE 4567

CMD ["make", "serve"]
