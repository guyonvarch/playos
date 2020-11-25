import re
import urllib
import logging
from PyQt5.QtCore import QTimer
from PyQt5.QtWidgets import QShortcut
from PyQt5.QtWebEngineWidgets import QWebEngineView
from PyQt5.QtWidgets import QSizePolicy

from kiosk_browser import system

class BrowserWidget(QWebEngineView):

    def __init__(self, url, proxy, *args, **kwargs):
        QWebEngineView.__init__(self, *args, **kwargs)

        # Authenticate proxies
        proxy_url = urllib.parse.urlparse(proxy)
        if proxy_url.username != None and proxy_url.password != None:
            self.page().proxyAuthenticationRequired.connect(
                lambda url, auth, proxyHost: self._proxy_auth(
                    proxy_url.username, proxy_url.password, url, auth, proxyHost))

        # Override user agent
        self.page().profile().setHttpUserAgent(user_agent_with_system(
            user_agent = self.page().profile().httpUserAgent(),
            system_name = system.NAME,
            system_version = system.VERSION
        ))

        # Load url
        self.page().setUrl(url)

        # Shortcut to manually reload
        self.reload_shortcut = QShortcut('CTRL+R', self)
        self.reload_shortcut.activated.connect(self.reload)

        # Check if pages is correctly loaded
        self.loadFinished.connect(self._load_finished)

        # Shortcut to close
        self.quit_shortcut = QShortcut('CTRL+ALT+DELETE', self)
        self.quit_shortcut.activated.connect(lambda: self.close())

        # Stretch the browser
        policy = QSizePolicy()
        policy.setVerticalStretch(1)
        policy.setHorizontalStretch(1)
        policy.setVerticalPolicy(QSizePolicy.Preferred)
        policy.setHorizontalPolicy(QSizePolicy.Preferred)
        self.setSizePolicy(policy)

    def load(self, url):
        self.page().setUrl(url)

    def _load_finished(self, success):
        if not success:
            QTimer.singleShot(5000, self.reload)

    def _proxy_auth(self, username, password, url, auth, proxyHost):
        logging.info(f"Authenticating proxy")
        auth.setUser(username)
        auth.setPassword(password)

def user_agent_with_system(user_agent, system_name, system_version):
    """Inject a specific system into a user agent string"""
    pattern = re.compile('(Mozilla/5.0) \(([^\)]*)\)(.*)')
    m = pattern.match(user_agent)

    if m == None:
        return f"{system_name}/{system_version} {user_agent}"
    else:
        if not m.group(2):
            system_detail = f"{system_name} {system_version}"
        else:
            system_detail = f"{m.group(2)}; {system_name} {system_version}"

        return f"{m.group(1)} ({system_detail}){m.group(3)}"
