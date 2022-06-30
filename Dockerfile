FROM gplane/pnpm:node16-alpine
WORKDIR /workdir

COPY . .
RUN pnpm install

WORKDIR /workdir/repo
ARG SCRIPT_PATH="./"
ENV SCRIPT_PATH ${SCRIPT_PATH}
RUN pnpm install

WORKDIR /workdir/repo/$SCRIPT_PATH
RUN pnpm generate && pnpm build

WORKDIR /workdir

EXPOSE 8080/tcp
CMD ["node", "index.js"]
