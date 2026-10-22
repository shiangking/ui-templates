/* ============================================================
   design-system-v1 · motion.js
   Tiny scroll-reveal engine (Framer-style appear behavior).
   Zero dependencies. ~1KB. Pairs with motion.css.
   ============================================================ */
(function () {
  "use strict";

  var reduceMotion = window.matchMedia &&
    window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  function revealAll() {
    document.querySelectorAll("[data-reveal]").forEach(function (el) {
      el.classList.add("revealed");
    });
  }

  if (reduceMotion || !("IntersectionObserver" in window)) {
    revealAll();
    return;
  }

  var observer = new IntersectionObserver(function (entries) {
    entries.forEach(function (entry) {
      if (entry.isIntersecting) {
        entry.target.classList.add("revealed");
        observer.unobserve(entry.target); // reveal once, like Framer appear
      }
    });
  }, { threshold: 0.15, rootMargin: "0px 0px -40px 0px" });

  function scan() {
    document.querySelectorAll("[data-reveal]:not(.revealed)").forEach(function (el) {
      observer.observe(el);
    });
  }

  document.addEventListener("DOMContentLoaded", scan);
  scan();
  if ("MutationObserver" in window) {
    new MutationObserver(scan).observe(document.documentElement, { childList: true, subtree: true });
  }

  // demo helper: window.replayMotion() resets everything so you can watch again
  window.replayMotion = function () {
    document.querySelectorAll("[data-reveal].revealed").forEach(function (el) {
      el.classList.remove("revealed");
    });
    scan();
    window.scrollTo({ top: 0, behavior: "smooth" });
  };
})();
