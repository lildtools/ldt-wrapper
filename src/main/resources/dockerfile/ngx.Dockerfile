#############
### build ###
#############

# base image

FROM node:14.20.1-alpine3.16 as build


WORKDIR /app

# add `/app/node_modules/.bin` to $PATH
#ENV PATH /app/node_modules/.bin:$PATH

# install and cache app dependencies
COPY package*.json /app/

RUN apk add --update alpine-sdk && \
apk --no-cache --update add g++ make python3 py3-pip build-base && \
npm install --quiet node-gyp -g

RUN npm install --legacy-peer-deps

COPY . /app/

ENV NODE_ENV=production
RUN npm run build -- --configuration production --aot  --verbose

############
### prod ###
############

# base image
FROM nginx:1.22-alpine as live

# copy artifact build from the 'build environment'
COPY --from=build /app/dist/ /usr/share/nginx/html/
COPY nginx.conf /etc/nginx/conf.d/default.conf

RUN echo "daemon off;" >> /etc/nginx/nginx.conf

# expose port 80
EXPOSE 80

# run nginx
CMD ["nginx"]
