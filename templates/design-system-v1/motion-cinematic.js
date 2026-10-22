/* ============================================================
   design-system-v1 · motion-cinematic.js
   Engine for PROFILE 2 (Storm Lab vocabulary):
   curtain + kinetic text reveal, scroll-pinned scene progress,
   parallax, magnetic buttons, custom cursor, lightning trigger.
   Zero dependencies. Everything is scroll-linked where possible.
   ============================================================ */
(function () {
  "use strict";
  var rm = window.matchMedia && window.matchMedia("(prefers-reduced-motion: reduce)").matches;

  /* ---------- curtain + kinetic reveal ---------- */
  var io = new IntersectionObserver(function (es) {
    es.forEach(function (e) {
      if (e.isIntersecting) { e.target.classList.add("revealed"); io.unobserve(e.target); }
    });
  }, { threshold: 0.2 });
  function scanReveals() {
    document.querySelectorAll(".curtain:not(.revealed), [data-kinetic]:not(.revealed)").forEach(function (el) { io.observe(el); });
  }
  // kinetic: split text into chars
  document.querySelectorAll("[data-kinetic]").forEach(function (el) {
    if (el.dataset.kineticDone) return;
    var i = 0;
    el.innerHTML = el.textContent.split("").map(function (ch) {
      return ch === " " ? " " : '<span class="k-char" style="--k-i:' + (i++) + '">' + ch + "</span>";
    }).join("");
    el.dataset.kineticDone = "1";
  });
  scanReveals();

  /* ---------- scroll-pinned scene: drives --p from 0..1 ---------- */
  var scenes = document.querySelectorAll(".scene");
  var rafPending = false;
  function updateScenes() {
    rafPending = false;
    scenes.forEach(function (scene) {
      var r = scene.getBoundingClientRect();
      var total = r.height - window.innerHeight;
      var p = total > 0 ? Math.min(1, Math.max(0, -r.top / total)) : 0;
      scene.style.setProperty("--p", p.toFixed(4));
    });
  }
  function onScroll() {
    if (!rafPending) { rafPending = true; requestAnimationFrame(updateScenes); }
  }
  if (!rm && scenes.length) {
    window.addEventListener("scroll", onScroll, { passive: true });
    window.addEventListener("resize", onScroll);
    updateScenes();
  } else if (scenes.length) {
    scenes.forEach(function (s) { s.style.setProperty("--p", "1"); });
  }

  /* ---------- parallax ---------- */
  var pEls = [];
  document.querySelectorAll("[data-parallax]").forEach(function (el) {
    pEls.push({ el: el, speed: parseFloat(el.dataset.parallax) || 0.2 });
  });
  function updateParallax() {
    var vh = window.innerHeight;
    pEls.forEach(function (o) {
      var r = o.el.getBoundingClientRect();
      var center = r.top + r.height / 2 - vh / 2;
      o.el.style.setProperty("--py", (center * -o.speed).toFixed(1) + "px");
    });
  }
  if (!rm && pEls.length) {
    window.addEventListener("scroll", function () { requestAnimationFrame(updateParallax); }, { passive: true });
    updateParallax();
  }

  /* ---------- magnetic buttons ---------- */
  if (!rm && window.matchMedia("(pointer: fine)").matches) {
    document.querySelectorAll("[data-magnetic]").forEach(function (el) {
      el.addEventListener("mousemove", function (e) {
        var r = el.getBoundingClientRect();
        var x = (e.clientX - r.left - r.width / 2) / r.width;
        var y = (e.clientY - r.top - r.height / 2) / r.height;
        el.style.transform = "translate(" + x * 14 + "px," + y * 10 + "px)";
      });
      el.addEventListener("mouseleave", function () { el.style.transform = ""; });
    });
  }

  /* ---------- custom cursor ---------- */
  if (!rm && window.matchMedia("(pointer: fine)").matches) {
    var dot = document.createElement("div"); dot.className = "cursor-dot";
    var ring = document.createElement("div"); ring.className = "cursor-ring";
    document.body.appendChild(dot); document.body.appendChild(ring);
    document.body.setAttribute("data-cursor", "1");
    var rx = innerWidth / 2, ry = innerHeight / 2;
    window.addEventListener("mousemove", function (e) {
      dot.style.transform = "translate(" + e.clientX + "px," + e.clientY + "px) translate(-50%,-50%)";
      rx += (e.clientX - rx) * 0.16; ry += (e.clientY - ry) * 0.16; // lagged ring
      ring.style.transform = "translate(" + rx + "px," + ry + "px) translate(-50%,-50%)";
      var hot = e.target.closest && e.target.closest("a,button,[data-magnetic]");
      ring.classList.toggle("hot", !!hot);
    }, { passive: true });
  }

  /* ---------- lightning (call window.strike() or auto every 9-14s) ---------- */
  var bolt = document.createElement("div"); bolt.className = "lightning";
  document.body.appendChild(bolt);
  window.strike = function () {
    bolt.classList.remove("struck");
    void bolt.offsetWidth; // restart animation
    bolt.classList.add("struck");
  };
  if (!rm) {
    (function loop() {
      setTimeout(function () { window.strike(); loop(); }, 9000 + Math.random() * 5000);
    })();
  }
})();
