#!/bin/bash

# Configuration
URL="http://localhost:3737"
SOCKET="/tmp/http-local-server.sock"
NUM_REQUESTS=1000
CONCURRENCY=1

# Calculate statistics
calculate_stats() {
    times=("$@")
    if [ ${#times[@]} -eq 0 ]; then
        echo "No valid timing data available"
        return
    fi

    # Clean the data by removing any empty or invalid values
    valid_times=()
    for t in "${times[@]}"; do
        if [[ $t =~ ^[0-9]+\.?[0-9]*$ ]]; then
            valid_times+=($t)
        fi
    done

    if [ ${#valid_times[@]} -eq 0 ]; then
        echo "No valid timing data available"
        return
    fi

    min=$(printf "%s\n" "${valid_times[@]}" | sort -g | head -n1)
    max=$(printf "%s\n" "${valid_times[@]}" | sort -g | tail -n1)
    avg=$(printf "%s\n" "${valid_times[@]}" | awk '{sum+=$1} END {print sum/NR}')

    echo "Latency Statistics (seconds):"
    echo "Minimum: ${min}s"
    echo "Maximum: ${max}s"
    echo "Average: ${avg}s"
}

echo "Starting benchmark tests..."
echo ""

# TCP Benchmark using curl
echo "TCP Benchmark Results:"
echo "---------------------"
TCP_TIMES=($(xargs -P $CONCURRENCY -I {} curl -w "%{time_total}" -o /dev/null -s $URL <<< $(seq 1 $NUM_REQUESTS)))
calculate_stats "${TCP_TIMES[@]}"

echo ""
echo "Unix Domain Socket Benchmark Results:"
echo "-----------------------------------"
SOCKET_TIMES=($(xargs -P $CONCURRENCY -I {} curl --unix-socket $SOCKET -w "%{time_total}" -o /dev/null -s http://localhost/ <<< $(seq 1 $NUM_REQUESTS)))
calculate_stats "${SOCKET_TIMES[@]}"

echo ""
echo "Summary Statistics:"
echo "------------------"
echo "Number of requests: $NUM_REQUESTS"
echo "Concurrency level: $CONCURRENCY"
