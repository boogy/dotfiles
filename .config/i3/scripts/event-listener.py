#!/usr/bin/env python3

import os
import asyncio
import i3ipc

socket = '{XDG_RUNTIME_DIR}/i3/event-listener.sock'.format_map(os.environ)
events = asyncio.Queue()
window_stack = []

def enqueue(*args):
    events.put_nowait(args)

async def i3_event_listener():
    while True:
        conn, event = await events.get()
        if event.change == 'focus':
            window_stack.insert(0, event.container.props.id)
            if len(window_stack) > 2:
                del window_stack[2:]

async def on_unix_connect(reader, writer):
    while True:
        cmd = await reader.readline()
        cmd = cmd.strip()
        if not cmd:
            break

        if cmd == b'swap_focus' and window_stack:
            cmd = '[con_id=%s] focus' % window_stack.pop()
            i3.command(cmd)

async def main():
    if os.path.exists(socket):
        os.unlink(socket)

    server = await asyncio.start_unix_server(on_unix_connect, socket)
    asyncio.ensure_future(i3_event_listener())
    await server.wait_closed()

i3 = i3ipc.Connection()
i3.on('window::focus', enqueue)
i3.event_socket_setup()

loop = asyncio.get_event_loop()
loop.add_reader(i3.sub_socket, i3.event_socket_poll)
loop.run_until_complete(main())
