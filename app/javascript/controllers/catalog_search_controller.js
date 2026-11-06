import { Controller } from "@hotwired/stimulus"

const focusKey = "catalog-search-focus"

export default class extends Controller {
  static targets = ["query"]

  connect() {
    if (!this.hasQueryTarget) return
    if (sessionStorage.getItem(focusKey) !== this.queryTarget.id) return

    sessionStorage.removeItem(focusKey)
    const end = this.queryTarget.value.length
    this.queryTarget.focus()
    this.queryTarget.setSelectionRange(end, end)
  }

  queue(event) {
    if (event.isComposing) return

    this.clear()
    this.timeout = setTimeout(() => {
      this.element.requestSubmit()
    }, 250)
  }

  remember() {
    this.clear()
    if (!this.hasQueryTarget) return

    sessionStorage.setItem(focusKey, this.queryTarget.id)
  }

  clear() {
    clearTimeout(this.timeout)
  }

  disconnect() {
    this.clear()
  }
}
