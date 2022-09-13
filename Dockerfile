# сборка и назвал её build-state
FROM node:alpine as build-stage

WORKDIR /usr/src/app

COPY package*.json ./
RUN npm ci

COPY tsconfig.json ./
COPY src ./src

RUN npm run build

# запуск и назвал её run-state
FROM node:alpine as run-stage

WORKDIR /usr/src/app

RUN chown node:node ./
COPY --chown=node:node --from=build-stage /usr/src/app .

USER node

CMD [ "node", "./build/index.js" ]
