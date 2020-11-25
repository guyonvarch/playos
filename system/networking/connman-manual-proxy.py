"""Ask connman for the manual proxy of the connected service.
"""

import dbus

bus = dbus.SystemBus()

client = dbus.Interface(
    bus.get_object("net.connman", "/"),
    "net.connman.Manager")

connected_services = [s for s in client.GetServices() if s[1]['State'] == 'online' or s[1]['State'] == 'ready']

if connected_services:
    service = connected_services[0][1]
    proxy = service['Proxy']

    if proxy['Method'] == 'manual':
        proxy_url = proxy['Servers'][0]
        if proxy_url.startswith("http://"):
            print(proxy_url)
        else:
            print(f"http://{proxy_url}")
