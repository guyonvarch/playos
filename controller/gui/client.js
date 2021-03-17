const pathname = window.location.pathname

if (pathname.startsWith('/network/')) {
  const passphrase = document.getElementById('d-Passphrase')
  const checkbox = document.getElementById('d-Checkbox')
  checkbox.onclick = function() {
    passphrase.type = checkbox.checked ? 'text' : 'password'
  }
}
