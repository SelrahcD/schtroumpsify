FROM bitwalker/alpine-elixir-phoenix:1.11.4 AS phx-builder

ENV PORT=5000
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=SECRET_KEY_BASE
ENV TWITTER_CONSUMER_KEY=TWITTER_CONSUMER_KEY
ENV TWITTER_CONSUMER_SECRET=TWITTER_CONSUMER_SECRET
ENV TWITTER_ACCESS_TOKEN=TWITTER_ACCESS_TOKEN
ENV TWITTER_ACCESS_TOKEN_SECRET=TWITTER_ACCESS_TOKEN_SECRET
ENV FRMG_PARSER_URL=FRMG_PARSER_URL

RUN \
    apk update && \
    apk --no-cache --update add \
      automake \
      autoconf \
   	  libtool \
   	  nasm \
   	  build-base \
   	  pkgconfig \
   	  zlib-dev && \
    rm -rf /var/cache/apk/*

# Cache elixir deps
ADD mix.exs mix.lock .formatter.exs ./
ADD lib lib
ADD config config
ADD assets assets

RUN mix deps.get && mix deps.compile

# Same with npm deps
RUN cd assets && \
    npm install

# Run frontend build, compile, and digest assets
RUN cd assets/ && \
    npm run deploy && \
    cd - && \
    mix deps.get && mix compile && mix phx.digest

FROM bitwalker/alpine-elixir:1.9.4 AS prod

EXPOSE 5000
ENV PORT=5000
ENV MIX_ENV=prod
ENV SECRET_KEY_BASE=SECRET_KEY_BASE
ENV TWITTER_CONSUMER_KEY=TWITTER_CONSUMER_KEY
ENV TWITTER_CONSUMER_SECRET=TWITTER_CONSUMER_SECRET
ENV TWITTER_ACCESS_TOKEN=TWITTER_ACCESS_TOKEN
ENV TWITTER_ACCESS_TOKEN_SECRET=TWITTER_ACCESS_TOKEN_SECRET
ENV FRMG_PARSER_URL=FRMG_PARSER_URL

COPY --from=phx-builder /opt/app/_build /opt/app/_build
COPY --from=phx-builder /opt/app/priv /opt/app/priv
COPY --from=phx-builder /opt/app/config /opt/app/config
COPY --from=phx-builder /opt/app/lib /opt/app/lib
COPY --from=phx-builder /opt/app/deps /opt/app/deps
COPY --from=phx-builder /opt/app/mix.* /opt/app/


# alternatively you can just copy the whole dir over with:
# COPY --from=phx-builder /opt/app /opt/app
# be warned, this will however copy over non-build files

USER default

CMD ["mix", "phx.server", "--no-compile"]
