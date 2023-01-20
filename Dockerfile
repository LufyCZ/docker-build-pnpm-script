FROM node:16-alpine

ARG SCRIPT_PATH="./"
ENV SCRIPT_PATH ${SCRIPT_PATH}

# Install git and pnpm
RUN apk add --no-cache git libc6-compat grep
RUN npm install -g pnpm@7.18.2 turbo

RUN echo $TURBO_TOKEN

WORKDIR /workdir/repo
COPY . .

# Prune unneeded packages
# Need to pull the package name from the path
RUN turbo prune --out-dir=../pruned --scope=$(pnpm list --depth -1 --parseable --long --filter "./$SCRIPT_PATH" | grep -oP '(?<=\:)(.*(?=@))') 

WORKDIR /workdir/pruned
# Can delete the previous workdir, won't be needed anymore
RUN rm -rf /workdir/repo

RUN HUSKY=0 pnpm install
RUN pnpm exec turbo run build --filter="./$SCRIPT_PATH"

# Delete store path since it's now unneeded
RUN rm -rf $(pnpm store path)

EXPOSE 8080/tcp
CMD pnpm exec turbo run server --only --filter="./$SCRIPT_PATH"
