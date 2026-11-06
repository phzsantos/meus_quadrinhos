import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  scroll() {
    const goToTop = () => window.scrollTo(0, 0)

    document.addEventListener("turbo:load", goToTop, { once: true })
    document.addEventListener("turbo:frame-load", goToTop, { once: true })
  }
}
