FROM gplane/pnpm:node16-alpine
ARG SCRIPT_PATH="./"
ENV SCRIPT_PATH ${SCRIPT_PATH}
WORKDIR /workdir

COPY . .
RUN pnpm install
RUN pnpm exec turbo run build --filter=./$SCRIPT_PATH

WORKDIR /workdir/repo
RUN pnpm install

WORKDIR /workdir/repo/$SCRIPT_PATH
RUN pnpm generate && pnpm build

WORKDIR /workdir

EXPOSE 8080/tcp
CMD ["node", "index.js"]
