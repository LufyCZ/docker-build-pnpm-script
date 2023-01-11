FROM node:16-alpine

ARG SCRIPT_PATH="./"
ENV SCRIPT_PATH ${SCRIPT_PATH}

# Install git and pnpm
# RUN apk add --no-cache git libc6-compat
RUN npm install -g pnpm

#WORKDIR /workdir

RUN HUSKY=0 pnpm install
RUN pnpm exec turbo run build --filter="./$SCRIPT_PATH"

EXPOSE 8080/tcp
CMD pnpm exec turbo run server --only --filter="./$SCRIPT_PATH"
