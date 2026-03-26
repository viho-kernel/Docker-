from http.server import SimpleHTTPRequestHandler, HTTPServer

PORT = 8080

class HelloHandler(SimpleHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("Content-type", "text/html")
        self.end_headers()
        self.wfile.write(b"Hello World from Docker!")

if __name__ == "__main__":
    server = HTTPServer(("", PORT), HelloHandler)
    print(f"Serving on port {PORT}...")
    server.serve_forever()
