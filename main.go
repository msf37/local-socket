package main

import (
	"fmt"
	"log"
	"net"
	"net/http"
	"os"
)

func startTCPServer() {
	// Create TCP listener
	tcpLn, err := net.Listen("tcp", ":3737")
	if err != nil {
		log.Fatalf("Error starting TCP server: %v", err)
	}

	fmt.Println("TCP server running on port 3737")

	go func() {
		// Create an HTTP handler
		mux := http.NewServeMux()
		mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
			w.Write([]byte("Hello from TCP!\n"))
		})

		if err := http.Serve(tcpLn, mux); err != nil {
			log.Printf("TCP server error: %v", err)
		}
	}()
}

func startUnixSocketServer() {
	localSocket := "/tmp/http-local-server.sock"
	// Remove existing Unix socket file
	os.Remove(localSocket)

	// Create Unix domain socket
	unixLn, err := net.Listen("unix", localSocket)
	if err != nil {
		log.Fatalf("Error starting Unix domain socket server: %v", err)
	}

	fmt.Println("Unix domain socket server running on /tmp/http-local-server.sock")

	go func() {
		// Create an HTTP handler
		mux := http.NewServeMux()
		mux.HandleFunc("/", func(w http.ResponseWriter, r *http.Request) {
			w.Write([]byte("Hello from Unix Domain Socket!\n"))
		})

		if err := http.Serve(unixLn, mux); nil != err {
			log.Printf("Unix domain socket server error: %v", err)
		}
	}()
}

func main() {
	startTCPServer()
	startUnixSocketServer()

	select {} // Block main goroutine
}
