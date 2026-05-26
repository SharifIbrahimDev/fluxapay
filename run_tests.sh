#!/bin/bash

echo "Starting FluxaPay Test Suite..."

# Run Backend Tests
echo "--- Running Backend (Laravel) Tests ---"
cd backend
php artisan test
BACKEND_STATUS=$?
cd ..

# Run Frontend Tests
echo "--- Running Frontend (Flutter) Tests ---"
flutter test
FRONTEND_STATUS=$?

if [ $BACKEND_STATUS -eq 0 ] && [ $FRONTEND_STATUS -eq 0 ]; then
    echo "SUCCESS: All tests passed!"
    exit 0
else
    echo "FAILURE: Some tests failed."
    exit 1
fi
