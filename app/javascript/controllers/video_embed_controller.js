import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="video-embed"
// Click-to-load facade: replaces the play-button overlay with a playing
// YouTube iframe on click, so the embed (and YouTube's tracking scripts)
// only loads when the visitor opts in to watch — not on every page view.
export default class extends Controller {
  static targets = ["overlay"]
  static values = { embedUrl: String }

  play() {
    const iframe = document.createElement("iframe")
    iframe.src = this.embedUrlValue
    iframe.title = "סרטון הקמפיין"
    iframe.allow = "autoplay; encrypted-media; picture-in-picture"
    iframe.allowFullscreen = true
    iframe.className = "absolute inset-0 h-full w-full"

    this.overlayTarget.replaceWith(iframe)
  }
}
