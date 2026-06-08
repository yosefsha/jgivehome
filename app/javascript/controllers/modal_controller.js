import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
// Opens a <dialog> and points its Turbo Frame at the given src so the
// donation form loads lazily, the first time the donor opens it.
export default class extends Controller {
  static targets = ["dialog", "frame"]

  open(event) {
    const src = event.params.src

    if (src && this.hasFrameTarget && !this.frameTarget.src) {
      this.frameTarget.src = src
    }

    this.dialogTarget.showModal()
  }

  close() {
    this.dialogTarget.close()
  }

  closeBackground(event) {
    if (event.target === this.dialogTarget) this.close()
  }
}
