#!/bin/bash

# 🔍 Pre-commit validation script
# Ce script lance les mêmes vérifications que la CI/CD en local

set -e

echo "🚀 Running pre-commit checks..."

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    if [ $1 -eq 0 ]; then
        echo -e "${GREEN}✅ $2${NC}"
    else
        echo -e "${RED}❌ $2${NC}"
        exit 1
    fi
}

print_info() {
    echo -e "${YELLOW}📋 $1${NC}"
}

# Check if we're in the right directory
if [ ! -f "package.json" ]; then
    echo -e "${RED}❌ Please run this script from the front/ directory${NC}"
    exit 1
fi

print_info "Step 1/4: Biome Check (Lint + Format)"
npm run check
print_status $? "Biome check passed"

print_info "Step 2/4: TypeScript Check"
npx tsc --noEmit --skipLibCheck
print_status $? "TypeScript check passed"

print_info "Step 3/4: Running tests with coverage"
npm run test:ci
print_status $? "Tests and coverage passed"

print_info "Step 4/4: Build check"
npm run build:prod > /dev/null 2>&1
print_status $? "Production build successful"

echo -e "${GREEN}🎉 All pre-commit checks passed! Ready to commit.${NC}" 