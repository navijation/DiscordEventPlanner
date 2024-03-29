FROM node:14.17-alpine3.11 AS build-image
WORKDIR /usr/src/app

RUN ["apk", "add", "ffmpeg"]

COPY package.json yarn.lock ./ 
RUN ["yarn", "install"]

COPY . ./ 
RUN ["yarn", "build"]
RUN ["yarn", "install", "--production"]

FROM node:14.17-alpine3.11
RUN ["npm", "install", "-g", "--unsafe-perm", "pm2"]
WORKDIR /usr/src/app
COPY --from=build-image /usr/src/app/node_modules ./node_modules
COPY --from=build-image /usr/src/app/build ./build
CMD ["pm2-runtime", "./build/main.js"]
