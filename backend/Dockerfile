FROM elixir:1.14-alpine AS build

# Install build dependencies
RUN apk add --no-cache build-base git postgresql-client

# Set working directory
WORKDIR /app

# Install hex and rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# Copy mix files
COPY mix.exs mix.lock ./
RUN mix deps.get --only prod

# Copy application code
COPY . .

# Compile application
RUN mix compile

# Build release
RUN MIX_ENV=prod mix release

# Final stage
FROM alpine:3.17

# Install runtime dependencies
RUN apk add --no-cache openssl ncurses-libs postgresql-client

WORKDIR /app

# Copy release from build stage
COPY --from=build /app/_build/prod/rel/inventory_house ./

# Expose port
EXPOSE 4000

# Set environment
ENV MIX_ENV=prod
ENV PORT=4000

# Run migrations and start server
CMD ["bin/inventory_house", "start"]

