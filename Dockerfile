FROM node16

WORKDIR /reactapp

COPY package*.json .

RUN npm install

COPY . .

CMD npm run dev

