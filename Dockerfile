FROM gplane/pnpm:node16-alpine
WORKDIR /workdir/repo
COPY ./../repo .
ARG SCRIPT_PATH="./"
ENV SCRIPT_PATH ${SCRIPT_PATH}
RUN pnpm install

WORKDIR /workdir/repo/$SCRIPT_PATH
RUN pnpm generate && pnpm build

WORKDIR /workdir
COPY . .
RUN pnpm install

EXPOSE 8080/tcp
CMD ["node", "index.js"]
