FROM node:alpine

WORKDIR /usr/visits-server

COPY ./package.json .

RUN npm i

COPY . .

CMD ["npm", "start"]