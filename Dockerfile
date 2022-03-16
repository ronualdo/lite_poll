FROM ruby:3.0.2-alpine3.14

ARG UID
ARG GID
ARG BUNDLE_PATH="vendor/bundle"
ARG BUNDLE_DEPLOYMENT=true
ARG BUNDLE_WITHOUT="test development"
ENV BUNDLE_PATH $BUNDLE_PATH
ENV BUNDLE_DEPLOYMENT $BUNDLE_DEPLOYMENT
ENV BUNDLE_WITHOUT $BUNDLE_WITHOUT
ENV HOME "/tmp"

RUN apk add --no-cache make g++ git nodejs-current \
    gcc musl-dev tzdata postgresql-dev yarn

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh

RUN adduser -u ${UID} -D appuser

WORKDIR /bitforma
RUN chown ${UID}:${GID} /bitforma

USER ${UID}:${GID}

COPY --chown=${UID}:${GID} Gemfile* /bitforma/

RUN mkdir /bitforma/vendor && \
    bundle install --jobs=8

COPY --chown=${UID}:${GID} . /bitforma

EXPOSE 3000
ENTRYPOINT ["entrypoint.sh"]
# Configure the main process to run when running the image
CMD ["bin/rails", "server", "-b", "0.0.0.0"]
