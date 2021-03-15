const path = window.location.pathname

if (path == '/info') {

  const remoteManagementButton =
    document.getElementById('d-Info__RemoteManagementButton')

  remoteManagementButton.addEventListener('click', function() {
    const buttonParent = remoteManagementButton.parentNode
    const loader = document.createElement('div')
    loader.classList.add('d-Loader')
    remoteManagementButton.style.display = 'none'
    buttonParent.appendChild(loader)
  })

}
