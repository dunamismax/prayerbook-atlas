import { Controller } from "@hotwired/stimulus"

// Keeps the screen awake while a prayer page is open, when the person has
// asked for it in Settings (BUILD.md P2.10) and the browser has the Screen
// Wake Lock API. Elsewhere it does nothing; the page is the same either way.
export default class extends Controller {
  connect() {
    if (!("wakeLock" in navigator) || !document.querySelector(".liturgy")) return

    this.reacquire = () => { if (document.visibilityState === "visible") this.request() }
    document.addEventListener("visibilitychange", this.reacquire)
    this.request()
  }

  disconnect() {
    if (this.reacquire) document.removeEventListener("visibilitychange", this.reacquire)
    this.sentinel?.release()
    this.sentinel = null
  }

  async request() {
    try {
      this.sentinel = await navigator.wakeLock.request("screen")
    } catch {
      // Refused (low battery, a hidden page): the screen sleeps as usual.
    }
  }
}
