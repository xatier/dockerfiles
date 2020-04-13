# reference:
# https://tools.ietf.org/html/rfc1928
# https://github.com/rushter/socks5

import enum
import logging
import select
import socket
import socketserver
import struct
import time
from typing import List, Optional, Tuple

logging.basicConfig(level=logging.DEBUG)

# constants
SOCKS_VERSION = 5
PORT = 1081
CHUNK_SIZE = 32768

# Greetings header
"""
The client connects to the server, and sends a version
identifier/method selection message:

                +----+----------+----------+
                |VER | NMETHODS | METHODS  |
                +----+----------+----------+
                | 1  |    1     | 1 to 255 |
                +----+----------+----------+

The VER field is set to X'05' for this version of the protocol.  The
NMETHODS field contains the number of method identifier octets that
appear in the METHODS field.


Methods

The server selects from one of the methods given in METHODS, and
sends a METHOD selection message:

                      +----+--------+
                      |VER | METHOD |
                      +----+--------+
                      | 1  |   1    |
                      +----+--------+

If the selected METHOD is X'FF', none of the methods listed by the
client are acceptable, and the client MUST close the connection.

The values currently defined for METHOD are:

       o  X'00' NO AUTHENTICATION REQUIRED
       o  X'01' GSSAPI
       o  X'02' USERNAME/PASSWORD
       o  X'03' to X'7F' IANA ASSIGNED
       o  X'80' to X'FE' RESERVED FOR PRIVATE METHODS
       o  X'FF' NO ACCEPTABLE METHODS
"""


class SocksMethod(enum.IntEnum):
    """
    Authentication method to be used.

    We use only do NO_AUTH currently.
    """

    NO_AUTH = 0x00
    GSSAPI = 0x01
    USERNAME_PASSWORD = 0x02


# Request header
"""
The SOCKS request is formed as follows:

    +----+-----+-------+------+----------+----------+
    |VER | CMD |  RSV  | ATYP | DST.ADDR | DST.PORT |
    +----+-----+-------+------+----------+----------+
    | 1  |  1  | X'00' |  1   | Variable |    2     |
    +----+-----+-------+------+----------+----------+

 Where:

      o  VER    protocol version: X'05'
      o  CMD
         o  CONNECT X'01'
         o  BIND X'02'
         o  UDP ASSOCIATE X'03'
      o  RSV    RESERVED
      o  ATYP   address type of following address
         o  IP V4 address: X'01'
         o  DOMAINNAME: X'03'
         o  IP V6 address: X'04'
      o  DST.ADDR       desired destination address
      o  DST.PORT desired destination port in network octet
         order
"""


class SocksCommand(enum.IntEnum):
    """
    Socks command.

    We only support CONNECT currently.
    """

    CONNECT = 0x01
    BIND = 0x02
    UDP_ASSOCIATE = 0x03


class SocksAddressType(enum.IntEnum):
    """Socks address type."""

    IPV4 = 0x01
    DOMAINNAME = 0x03
    IPV6 = 0x04


# Reply header
"""
The server evaluates the request, and
returns a reply formed as follows:

     +----+-----+-------+------+----------+----------+
     |VER | REP |  RSV  | ATYP | BND.ADDR | BND.PORT |
     +----+-----+-------+------+----------+----------+
     | 1  |  1  | X'00' |  1   | Variable |    2     |
     +----+-----+-------+------+----------+----------+

  Where:

       o  VER    protocol version: X'05'
       o  REP    Reply field:
          o  X'00' succeeded
          o  X'01' general SOCKS server failure
          o  X'02' connection not allowed by ruleset
          o  X'03' Network unreachable
          o  X'04' Host unreachable
          o  X'05' Connection refused
          o  X'06' TTL expired
          o  X'07' Command not supported
          o  X'08' Address type not supported
          o  X'09' to X'FF' unassigned
       o  RSV    RESERVED
       o  ATYP   address type of following address
          o  IP V4 address: X'01'
          o  DOMAINNAME: X'03'
          o  IP V6 address: X'04'
          o  BND.ADDR       server bound address
          o  BND.PORT       server bound port in network octet order
"""


class SocksReply(enum.IntEnum):
    """Socks reply."""

    SUCCEEDED = 0x00
    GENERAL_FAILURE = 0x01
    CONNECTION_NOT_ALLOWED = 0x02
    NETWORK_UNREACHABLE = 0x03
    HOST_UNREACHABLE = 0x04
    CONNECTION_REFUSED = 0x05
    TTL_EXPIRED = 0x06
    COMMAND_NOT_SUPPORTED = 0x07
    ADDRESS_TYPE_NOT_SUPPORTED = 0x08


class SocksProxy(socketserver.StreamRequestHandler):
    def _close(self) -> None:
        """Close the connection."""
        logging.info(f'Closing connection from {self.client_address}')
        self.request.close()

    def _close_with_error(self, error: SocksReply) -> None:
        """Close the connection with an error reply."""
        logging.debug(f'Closing connection with error={repr(error)}')
        self.reply = error
        reply_payload = self.generate_failed_reply(error, self.address_type)
        self.request.sendall(reply_payload)
        self._close()

    def _ensure_version(self, version: int) -> None:
        """Ensure it is sock5."""
        if version != SOCKS_VERSION:
            self._close_with_error(SocksReply.GENERAL_FAILURE)

    def _ensure_nmethods(self, nmethods: int) -> None:
        """Ensure nmethods in the greetings header is between 1 to 255."""
        if not (1 <= nmethods <= 255):
            self._close_with_error(SocksReply.GENERAL_FAILURE)

    def _get_available_methods(self, n: int) -> List[int]:
        """Get available methods."""
        methods = []
        # get the next n bytes
        for _ in range(n):
            methods.append(ord(self.request.recv(1)))
        return methods

    def _parse_address(self) -> str:
        """Parse address from the request header."""
        address: str = ''

        if self.address_type == SocksAddressType.IPV4:
            # the address is a version-4 IP address, with a length of 4 octets
            address = socket.inet_ntop(socket.AF_INET, self.request.recv(4))

        elif self.address_type == SocksAddressType.DOMAINNAME:
            # the address field contains a fully-qualified domain name.
            # the first octet of the address field contains the number of
            # octets of name that follow, there is no terminating NUL octet.
            domain_length = ord(self.request.recv(1))
            address = self.request.recv(domain_length)

        elif self.address_type == SocksAddressType.IPV6:
            # the address is a version-6 IP address, with a length of 16 octets
            address = socket.inet_ntop(socket.AF_INET6, self.request.recv(16))

        else:
            logging.info(f'Unknown address type')
            self._close_with_error(SocksReply.ADDRESS_TYPE_NOT_SUPPORTED)

        return address

    def _parse_port(self) -> int:
        """Parse port from the request header."""
        return struct.unpack('!H', self.request.recv(2))[0]

    def _handle_greetings(self) -> None:
        """
        Handle greetings header.

        This method replies with NO_AUTH for authentication.
        """
        # greeting header
        header = self.request.recv(2)
        version, nmethods = struct.unpack("!BB", header)
        self._ensure_version(version)
        self._ensure_nmethods(nmethods)

        # get available methods
        methods = self._get_available_methods(nmethods)
        logging.debug(f'Available methods => {methods}')

        # send back greetings header, we pick 'no auth'
        self.request.sendall(
            struct.pack("!BB", SOCKS_VERSION, SocksMethod.NO_AUTH)
        )

    def _handle_request_header(self) -> None:
        """
        Handle request header.

        This method sets the following attributes:

        self.command
        self.address_type
        self.address
        self.port
        """
        # request header
        version, cmd, _, address_type = struct.unpack(
            "!BBBB", self.request.recv(4)
        )
        self._ensure_version(version)

        self.command = SocksCommand(cmd)
        self.address_type = SocksAddressType(address_type)

        self.address = self._parse_address()
        self.port = self._parse_port()

    @staticmethod
    def _unpack_bind_address(bind_address: Tuple[str, int]) -> Tuple[int, int]:
        """Unpack bind address tuple to tuple of 2 integers."""
        # XXX: IPv4 only
        return (
            struct.unpack(
                "!I", socket.inet_pton(socket.AF_INET, bind_address[0])
            )[0], bind_address[1]
        )

    def _handle_command_connect(self) -> Optional[bytes]:
        """
        Handle the CONNECT command.

        This method creates the remote socket and attempts to connect to it.
        """
        # In the reply to a CONNECT, BND.PORT contains the port number that the
        # server assigned to connect to the target host, while BND.ADDR
        # contains the associated IP address.
        try:
            self.remote = socket.socket(socket.AF_INET, socket.SOCK_STREAM)
            self.remote.connect((self.address, self.port))
            logging.info(f'Connected to {self.address}:{self.port}')

            bind_address = self.remote.getsockname()
            logging.info(f'Binding to {bind_address}')

            addr, port = self._unpack_bind_address(bind_address)

            self.reply = SocksReply.SUCCEEDED
            return self.generate_succeeded_reply(self.address_type, addr, port)

        except Exception as err:
            logging.error(f'{err} on CONNECT command')
            self._close_with_error(SocksReply.CONNECTION_REFUSED)

        return None

    def _handle_command(self) -> Optional[bytes]:
        """
        Dispatcher for all commands.

        Only CONNECT is supported currently.
        """
        try:
            # XXX: implement other commands maybe?
            if self.command == SocksCommand.CONNECT:
                return self._handle_command_connect()

            elif self.command == SocksCommand.BIND:
                logging.info('Bind command is not supproted')
                self._close_with_error(SocksReply.COMMAND_NOT_SUPPORTED)

            elif self.command == SocksCommand.UDP_ASSOCIATE:
                logging.info('UDP assigned command is not supproted')
                self._close_with_error(SocksReply.COMMAND_NOT_SUPPORTED)

            else:
                logging.info(f'Unknown command')
                self._close_with_error(SocksReply.COMMAND_NOT_SUPPORTED)

        except Exception as err:
            logging.error(f'{err} on command {repr(self.command)}')
            self._close_with_error(SocksReply.GENERAL_FAILURE)

        return None

    def _exchange_loop(
        self, client: socket.socket, remote: socket.socket
    ) -> None:
        """Exchange data between client and remote."""
        logging.debug(f'exchange loop')

        start = time.process_time()
        while True:

            # wait until client or remote is available for read
            r, w, e = select.select([client, remote], [], [])

            if client in r:
                data = client.recv(CHUNK_SIZE)
                if remote.send(data) <= 0:
                    break

            if remote in r:
                data = remote.recv(CHUNK_SIZE)
                if client.send(data) <= 0:
                    break

        logging.debug(
            f'exchange loop done {time.process_time() - start}s taken'
        )

    def _do_reply_action(self) -> None:
        """Act accordinly with COMMAND."""
        logging.debug(f'reply={repr(self.reply)} cmd={repr(self.command)}')

        # establish data exchange, otherwise, no-op
        if self.command == SocksCommand.CONNECT:
            if self.reply == SocksReply.SUCCEEDED:
                self._exchange_loop(self.request, self.remote)
            else:
                logging.info(f'Error on CONNECT command')
                self._close_with_error(SocksReply.GENERAL_FAILURE)

    @staticmethod
    def generate_reply(
        reply: SocksReply, address_type: SocksAddressType, addr: int, port: int
    ) -> bytes:
        """Generate reply header."""
        return struct.pack(
            "!BBBBIH", SOCKS_VERSION, reply, 0, address_type, addr, port
        )

    @staticmethod
    def generate_succeeded_reply(
        address_type: SocksAddressType, addr: int, port: int
    ) -> bytes:
        """Generate reply header with SUCCEEDED."""
        # XXX: addr is IPv4
        return SocksProxy.generate_reply(
            SocksReply.SUCCEEDED, address_type, addr, port
        )

    @staticmethod
    def generate_failed_reply(
        error: SocksReply, address_type: SocksAddressType
    ) -> bytes:
        """Generate reply header with error."""
        return SocksProxy.generate_reply(error, address_type, 0, 0)

    def handle(self) -> None:
        """Get available methods."""
        logging.info(f'Accepting connection from {self.client_address}')

        # greetings header
        self._handle_greetings()

        # request header
        self._handle_request_header()

        # reply header
        reply_payload = self._handle_command()
        if reply_payload:
            self.request.sendall(reply_payload)

        # act
        self._do_reply_action()

        # close the connection
        self._close()


def main() -> None:
    with socketserver.ThreadingTCPServer(
        ('127.0.0.1', PORT), SocksProxy
    ) as server:
        server.serve_forever()


if __name__ == '__main__':
    main()
