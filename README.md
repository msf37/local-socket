# Local Socket Benchmark  

This repository demonstrates the performance differences between **TCP sockets** and **Local Sockets** for local communication. It includes a simple server that supports both communication methods and a benchmarking script using `curl`.  

## Features  
- Supports **HTTP over TCP** and **HTTP over Local Sockets**  
- Simple benchmarking script to measure latency  
- Demonstrates the **performance benefits** of Unix sockets for local communication  

## 🚀 Getting Started  

### Clone the Repository  
```bash
git clone https://github.com/msf37/local-socket.git
cd local-socket
```

### Run the Server  

Start the server:  
```bash
go run main.go
```

### Run Benchmark  
```bash
bash benchmark.sh
```

## Benchmark Results  

```
TCP Benchmark Results:
---------------------
Latency Statistics (seconds):
Minimum: 0.002243s
Maximum: 0.002243s
Average: 0.002243s

Unix Domain Socket Benchmark Results:
-----------------------------------
Latency Statistics (seconds):
Minimum: 0.000176s
Maximum: 0.000176s
Average: 0.000176s
```

### Key Takeaways  
- **Local Sockets** offer significantly **lower latency** than TCP for local communication (~92.2% faster).  
- Ideal for **communication between services running on the same machine or container**.  
- Helps reduce **network stack overhead** and improve performance.  
