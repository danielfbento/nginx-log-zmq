import zmq

context = zmq.Context()
socket = context.socket(zmq.SUB)
socket.bind("tcp://*:5556")

socket.subscribe("/topic")

i = 0

while True:
    message = socket.recv()
    print i, message
    i = i + 1
