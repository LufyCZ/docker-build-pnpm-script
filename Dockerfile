FROM bitnami/git:latest AS cloner
WORKDIR /workdir/repo
ARG REPO
RUN git clone ${REPO} .

FROM gplane/pnpm:node16-alpine
WORKDIR /workdir/repo
ARG SCRIPT_PATH="./"
ENV SCRIPT_PATH ${SCRIPT_PATH}
COPY --from=cloner /workdir/repo .
RUN pnpm install

WORKDIR /workdir/repo/$SCRIPT_PATH
RUN pnpm generate && pnpm build

WORKDIR /workdir
COPY . .
RUN pnpm install

EXPOSE 8080/tcp
CMD ["node", "index.js"]
