customElements.define(
  'show-password',
  class extends HTMLInputElement {
    constructor() {
      super()

      const parentNode = this.parentNode
      const input = this

      const paddingRight = parseFloat(
        window.getComputedStyle(input).getPropertyValue('padding-right')
      )

      const marginRight = parseFloat(
        window.getComputedStyle(input).getPropertyValue('margin-right')
      )

      const button = document.createElement('span')
      let isShowed = false
      button.textContent = 'SHOW'
      button.style = `
        border: none;
        background-color: transparent;
        color: #555555;
        position: absolute;
        top: 50%;
        right: ${paddingRight + marginRight}px;
        font-size: 50%;
        transform: translateY(-50%);
        cursor: pointer;
      `
      button.onclick = function() {
        if (isShowed) {
          isShowed = false
          button.textContent = 'SHOW'
          input.type = 'password'
        } else {
          isShowed = true
          button.textContent = 'HIDE'
          input.type = 'text'
        }
      }

      const span = document.createElement('span')
      span.style = `
        position: relative;
      `
      span.appendChild(button)

      parentNode.replaceChild(span, input)
      span.appendChild(input)
    }
  },
  { extends: 'input' }
)
