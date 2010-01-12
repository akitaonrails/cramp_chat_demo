#!/usr/bin/env python
#
# flashpolicyd.py
# Simple socket policy file server for Flash
#
# Usage: flashpolicyd.py [--port=N] --file=FILE
#
# Logs to stderr
# Requires Python 2.5 or later

from __future__ import with_statement

import sys
import optparse
import socket
import thread
import exceptions
import contextlib

VERSION = 0.1

class policy_server(object):
    def __init__(self, port, path):
        self.port = port
        self.path = path
        self.policy = self.read_policy(path)
        self.log('Listening on port %d\n' % port)
        try:
            self.sock = socket.socket(socket.AF_INET6, socket.SOCK_STREAM)
        except AttributeError:
            # AttributeError catches Python built without IPv6
            self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        except socket.error:
            # socket.error catches OS with IPv6 disabled
            self.sock = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
        self.sock.setsockopt(socket.SOL_SOCKET, socket.SO_REUSEADDR, 1)
        self.sock.bind(('', port))
        self.sock.listen(5)
    def read_policy(self, path):
        with file(path, 'rb') as f:
            policy = f.read(10001)
            if len(policy) > 10000:
                raise exceptions.RuntimeError('File probably too large to be a policy file',
                                              path)
            if 'cross-domain-policy' not in policy:
                raise exceptions.RuntimeError('Not a valid policy file',
                                              path)
            return policy
    def run(self):
        try:
            while True:
                thread.start_new_thread(self.handle, self.sock.accept())
        except socket.error, e:
            self.log('Error accepting connection: %s' % (e[1],))
    def handle(self, conn, addr):
        addrstr = '%s:%s' % (addr[0],addr[1])
        try:
            self.log('Connection from %s' % (addrstr,))
            with contextlib.closing(conn):
                # It's possible that we won't get the entire request in
                # a single recv, but very unlikely.
                request = conn.recv(1024).strip()
                if request != '<policy-file-request/>\0':
                    self.log('Unrecognized request from %s: %s' % (addrstr, request))
                    return
                self.log('Valid request received from %s' % (addrstr,))
                conn.sendall(self.policy)
                self.log('Sent policy file to %s' % (addrstr,))
        except socket.error, e:
            self.log('Error handling connection from %s: %s' % (addrstr, e[1]))
        except Exception, e:
            self.log('Error handling connection from %s: %s' % (addrstr, e[1]))
    def log(self, str):
        print >>sys.stderr, str

def main():
    parser = optparse.OptionParser(usage = '%prog [--port=PORT] --file=FILE',
                                   version='%prog ' + str(VERSION))
    parser.add_option('-p', '--port', dest='port', type=int, default=843,
                      help='listen on port PORT', metavar='PORT')
    parser.add_option('-f', '--file', dest='path',
                      help='server policy file FILE', metavar='FILE')
    opts, args = parser.parse_args()
    if args:
        parser.error('No arguments are needed. See help.')
    if not opts.path:
        parser.error('File must be specified. See help.')

    try:
        policy_server(opts.port, opts.path).run()
    except Exception, e:
        print >> sys.stderr, e
        sys.exit(1)
    except KeyboardInterrupt:
        pass

if __name__ == '__main__':
    main()
