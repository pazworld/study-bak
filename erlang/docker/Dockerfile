FROM erlang:alpine

RUN apk --update add git tig tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
RUN echo "Asia/Tokyo" > /etc/timezone
RUN addgroup -g 1000 erl && adduser -u 1000 erl -G erl -D && chown -R erl /home
