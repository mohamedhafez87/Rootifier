FROM alpine

LABEL maintainer "Roman Dodin <dodin.roman@gmail.com>"
LABEL description "Nginx + uWSGI + Flask based on Alpine Linux and managed by Supervisord"

# Copy python requirements file
COPY requirements.txt /tmp/requirements.txt

RUN apk add --no-cache \
	python3 \
	bash \
	nginx \
	uwsgi \
	uwsgi-python3 \
	supervisor && \	
	python3 -m ensurepip && \
	rm -r /usr/lib/python*/ensurepip && \
	pip3 install --upgrade pip setuptools && \
	pip3 install -r /tmp/requirements.txt && \
	rm -r /root/.cache

# Copy the Nginx global conf
COPY nginx.conf /etc/nginx/

# Copy the Flask Nginx site conf
COPY flask-site-nginx.conf /etc/nginx/conf.d/

# Copy the base uWSGI ini file to enable default dynamic uwsgi process number
COPY uwsgi.ini /etc/uwsgi/

# Custom Supervisord config
COPY supervisord.conf /etc/supervisord.conf

# Add demo app
COPY ./app /app
WORKDIR /app

EXPOSE 80

CMD ["/usr/bin/supervisord"]
