FROM gcr.io/google-appengine/python

# venv
RUN virtualenv /env -p python3.5
ENV VIRTUAL_ENV /env
ENV PATH /env/bin:$PATH

RUN apt-get update && \
    apt-get install -y --no-install-recommends apt-utils && \
    apt-get install -y --no-install-recommends gcc zlib1g zlib1g-dev && \
    apt-get install -y --no-install-recommends gettext

ADD requirements.txt /app/requirements.txt
ADD constraints.txt /app/constraints.txt
ADD . app/

WORKDIR app/

# same as ENV=production make setup
RUN pip install -r requirements.txt
RUN make catalog-compile

ENV ENV production
ENV WSGI_URL_SCHEME http

EXPOSE 8080
ENV PORT 8080

CMD ./bin/serve -e production -c config/production.ini
