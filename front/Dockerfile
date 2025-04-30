# Node compatible avec Angular 17
FROM node:18.19.1 AS build

# Les fichiers sensibles et inutiles sont ignorés via .dockerignore
WORKDIR /usr/local/app
COPY ./ /usr/local/app/

# Installer les dépendances et une version compatible de TypeScript
RUN yarn install && \
    yarn add typescript@4.8.4 -D && \
    npm run build

FROM nginx:latest AS production

COPY nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /usr/local/app/dist/bobapp /usr/share/nginx/html

EXPOSE 80
