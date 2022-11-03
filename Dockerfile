FROM alpine:3.15 AS build
COPY /project /project
WORKDIR /project/flask-app
RUN apk add --update npm \
  && npm install \
  && npm run build

FROM alpine:3.15
RUN mkdir project
COPY --from=build /project/flask-app/app.py /project/app.py
COPY --from=build /project/flask-app/requirements.txt /project/requirements.txt
WORKDIR /project
RUN apk add python2 \
  && python -m ensurepip --upgrade \
  && pip install -r requirements.txt
ENTRYPOINT python app.py
