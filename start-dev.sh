#!/bin/bash

set -e

export POSTGRES_DATABASE=school
export POSTGRES_USER=root
export POSTGRES_PASSWORD=root
export APP_URL=http://localhost:8080
export DEBUG=true

PID_FILE=".dev-servers.pid"

# Function to cleanup on exit
cleanup() {
    echo "Stopping servers..."
    if [ -f "$PID_FILE" ]; then
        while read pid; do
            if kill -0 "$pid" 2>/dev/null; then
                kill "$pid" 2>/dev/null || true
            fi
        done < "$PID_FILE"
        rm -f "$PID_FILE"
    fi
    exit 0
}

# Trap signals to cleanup
trap cleanup SIGINT SIGTERM EXIT

# Start frontend server
echo "Starting frontend server on http://localhost:8080..."
cd frontend
npm run dev -- --port 8080 > ../.frontend.log 2>&1 &
FRONTEND_PID=$!
cd ..
echo $FRONTEND_PID > "$PID_FILE"

# Start backend server
echo "Starting backend server on http://localhost:8000..."
cd backend/core
uv run python manage.py runserver localhost:8000 > ../../.backend.log 2>&1 &
BACKEND_PID=$!
cd ../..
echo $BACKEND_PID >> "$PID_FILE"

echo ""
echo "✓ Servers started!"
echo "  Frontend: http://localhost:8080 (PID: $FRONTEND_PID)"
echo "  Backend:  http://localhost:8000 (PID: $BACKEND_PID)"
echo ""
echo "Logs:"
echo "  Frontend: .frontend.log"
echo "  Backend:  .backend.log"
echo ""
echo "Press Ctrl+C to stop all servers..."

# Wait for servers
wait