import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="video-embed"
// Click-to-load facade: clicking the play button switches the wrapping
// element into "playing" mode (toggling `video-embed--playing`, see
// app/assets/tailwind/application.css), which pops the video up at its
// natural size over a backdrop that dims the rest of the page — the embed
// itself only loads once the visitor opts in.
export default class extends Controller {
  static targets = ["overlay", "frame"]
  static values = { embedUrl: String, playing: { type: Boolean, default: false } }

  play() {
    this.playingValue = true
  }

  close() {
    this.playingValue = false
  }

  playingValueChanged(playing) {
    this.element.classList.toggle("video-embed--playing", playing)

    if (playing) {
      if (this.frameTarget.childElementCount === 0) {
        const iframe = document.createElement("iframe")
        iframe.src = this.embedUrlValue
        iframe.title = "סרטון הקמפיין"
        iframe.allow = "autoplay; encrypted-media; picture-in-picture"
        iframe.allowFullscreen = true

        this.frameTarget.appendChild(iframe)
      }
    } else {
      // Tear the iframe down on close so playback (and audio) actually stops —
      // it gets recreated fresh the next time the visitor presses play.
      this.frameTarget.replaceChildren()
    }
  }
}
