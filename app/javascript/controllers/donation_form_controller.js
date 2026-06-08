import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="donation-form"
// Toggles the "other amount" field and the optional dedication-message textarea.
export default class extends Controller {
  static targets = ["customAmountWrapper", "customAmountInput", "dedicationWrapper"]

  selectPreset() {
    this.customAmountWrapperTarget.hidden = true
    this.customAmountInputTarget.value = ""
  }

  selectCustom() {
    this.customAmountWrapperTarget.hidden = false
    this.customAmountInputTarget.focus()
  }

  toggleDedication(event) {
    this.dedicationWrapperTarget.hidden = !event.target.checked
  }

  // The form posts inside the "donation_modal" turbo frame, but a successful
  // submission redirects to the campaign page, which has no matching frame —
  // left alone, Turbo would render that page's content into the (now empty)
  // frame instead of replacing the whole page. Driving a full Turbo visit to
  // the redirected URL breaks out of the frame, closes the modal, and shows
  // the campaign page with its updated totals.
  handleSubmitEnd(event) {
    const { success, fetchResponse } = event.detail

    if (success && fetchResponse?.response?.redirected) {
      window.Turbo.visit(fetchResponse.response.url, { action: "replace" })
    }
  }
}
