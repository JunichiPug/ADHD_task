// Entry point for the build script in your package.json
import "@hotwired/turbo-rails"
import "./controllers"

// Register the PWA service worker (offline support + installability).
if ("serviceWorker" in navigator) {
  window.addEventListener("load", () => {
    navigator.serviceWorker
      .register("/service-worker")
      .catch((error) => console.error("Service worker registration failed:", error))
  })
}
