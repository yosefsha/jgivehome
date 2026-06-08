import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="tabs"
export default class extends Controller {
  static targets = ["tab", "panel"]

  select(event) {
    const name = event.currentTarget.dataset.tabsNameParam
    this.show(name)
  }

  show(name) {
    this.tabTargets.forEach((tab) => {
      tab.classList.toggle("tabs-active", tab.dataset.tabsNameParam === name)
    })

    this.panelTargets.forEach((panel) => {
      panel.hidden = panel.dataset.tabsNameParam !== name
    })
  }
}
