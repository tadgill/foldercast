#!/bin/sh

set -e

# Start background update loop (default 600s / 10 min)
INTERVAL=${UPDATE_INTERVAL:-600}
(
  while true; do
    sleep $INTERVAL
    curl -s http://localhost:8000/ > /dev/null
  done
) &

echo "Running database migrations..."
python manage.py migrate --noinput --settings=config.settings.prod

echo "Collecting static files..."
python manage.py collectstatic --noinput --settings=config.settings.prod

echo "Starting gunicorn..."
exec gunicorn config.wsgi:application --bind 0.0.0.0:8000