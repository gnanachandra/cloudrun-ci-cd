FROM node18-alpine as build

WORKDIR /reactapp

COPY package*.json .

RUN npm install

COPY . .

CMD npm run dev

