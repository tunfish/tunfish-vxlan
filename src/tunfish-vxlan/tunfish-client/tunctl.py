#!/usr/bin/env python3
import websocket


def send_and_receive():
    ws = websocket.WebSocket()
    ws.connect("ws://localhost/s")
    #ws.connect("ws://echo.websocket.org")
    ws.send("Hello, World")
    print("Sent")
    print("Receiving...")
    result =  ws.recv()
    print("Received '%s'" % result)
    ws.close()


if __name__ == '__main__':
    send_and_receive()
