#!/bin/bash
set -e

echo "Running database migrations..."
MIX_ENV=prod mix ecto.migrate

echo "Starting Phoenix server..."
exec mix phx.server

