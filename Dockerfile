FROM node:lts-alpine
ENV NODE_ENV=production
WORKDIR /usr/src/app
COPY ["package.json", "package-lock.json*", "npm-shrinkwrap.json*", "./"]
RUN nvm use 10.16.0
RUN install -g ganache-cli
RUN npm install --production --silent && mv node_modules ../
COPY . .
EXPOSE 9545
RUN ganache-cli --port 9545 --deterministic
RUN npx zos session --network local --from 0x1df62f291b2e969fb0849d99d9ce41e2f137006e --expires 3600
RUN zos push
RUN zos create XPoap --init initialize --args '"Poap","POAP","https://poap.xyz",[]'
RUN npx truffle console --network local
RUN chown -R node /usr/src/app
USER node
CMD ["node", "index.js"]
