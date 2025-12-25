#!/bin/bash

# brutal_stress.sh - Extreme Stress Test for cohsh
# Designed to be run under ASan and Valgrind.

COHSH="./cohsh"

echo "=== BRUTAL STRESS TEST STARTING ==="

# 1. Deep Nesting Test (Recursion/Blocks)
echo "Testing deep subshell nesting (50 levels)..."
NESTED_CMD="echo bottom"
for i in {1..50}; do
    NESTED_CMD="( $NESTED_CMD )"
done
$COHSH -c "$NESTED_CMD" > /dev/null || { echo "FAILED: Deep nesting"; exit 1; }

# 2. Pipeline Marathon
echo "Testing long pipeline (30 stages)..."
PIPE_CMD="echo Start"
for i in {1..30}; do
    PIPE_CMD="$PIPE_CMD | cat"
done
$COHSH -c "$PIPE_CMD" > /dev/null || { echo "FAILED: Long pipeline"; exit 1; }

# 3. Variable Expansion Stress
echo "Testing heavy variable expansion and manipulation..."
$COHSH <<'EOF'
VAR="initial"
COUNT=0
while [ $COUNT -lt 500 ]; do
    VAR="v$COUNT-$VAR"
    COUNT=`expr $COUNT + 1`
done
if [ ${#VAR} -lt 1000 ]; then
    echo "FAILED: Variable growth"
    exit 1
fi
EOF
[ $? -ne 0 ] && exit 1

# 4. Large Heredoc Stress
echo "Testing multi-kilobyte heredoc..."
LONG_STR=$(printf 'line %0.s' {1..2000})
$COHSH <<EOF > /dev/null
cat <<HEREDOC
$LONG_STR
HEREDOC
EOF
[ $? -ne 0 ] && { echo "FAILED: Large heredoc"; exit 1; }

# 5. Rapid Signal Traps
echo "Testing rapid trap resetting..."
$COHSH <<'EOF'
COUNT=0
while [ $COUNT -lt 100 ]; do
    trap "echo caught" HUP
    trap - HUP
    COUNT=`expr $COUNT + 1`
done
EOF
[ $? -ne 0 ] && { echo "FAILED: Trap stress"; exit 1; }

# 6. Command Substitution in Loops (Memory pressure)
echo "Testing command substitution in a large loop..."
$COHSH <<'EOF'
COUNT=0
while [ $COUNT -lt 200 ]; do
    X=`echo "test$COUNT"`
    Y=`ls . | grep cohsh`
    COUNT=`expr $COUNT + 1`
done
EOF
[ $? -ne 0 ] && { echo "FAILED: Cmdsubst loop"; exit 1; }

echo "=== ALL BRUTAL TESTS PASSED ==="
