FROM node:alpine

WORKDIR /usr/simpleServer

COPY ./package.json ./

RUN npm i

COPY ./ ./

CMD ["npm", "start"]


