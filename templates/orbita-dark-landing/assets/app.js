
/* ============================================================
   Starfield — lightweight canvas, twinkle + slow drift
   ============================================================ */
(function () {
  const canvas = document.getElementById("stars");
  const ctx = canvas.getContext("2d");
  const reduced = window.matchMedia("(prefers-reduced-motion: reduce)").matches;
  let stars = [], w, h, dpr, raf;

  function resize() {
    dpr = Math.min(window.devicePixelRatio || 1, 2);
    w = canvas.width = window.innerWidth * dpr;
    h = canvas.height = window.innerHeight * dpr;
    canvas.style.width = window.innerWidth + "px";
    canvas.style.height = window.innerHeight + "px";
    const count = Math.min(240, Math.floor((window.innerWidth * window.innerHeight) / 6500));
    stars = Array.from({ length: count }, () => ({
      x: Math.random() * w,
      y: Math.random() * h,
      r: (Math.random() * 1.1 + 0.3) * dpr,
      p: Math.random() * Math.PI * 2,          // twinkle phase
      s: Math.random() * 0.015 + 0.004,        // twinkle speed
      v: (Math.random() * 0.06 + 0.015) * dpr  // drift speed
    }));
  }

  function draw(t) {
    ctx.clearRect(0, 0, w, h);
    for (const st of stars) {
      const tw = 0.45 + 0.55 * (0.5 + 0.5 * Math.sin(st.p + t * 0.001 * st.s * 60));
      st.x -= st.v;
      if (st.x < -2) { st.x = w + 2; st.y = Math.random() * h; }
      ctx.beginPath();
      ctx.arc(st.x, st.y, st.r, 0, Math.PI * 2);
      ctx.fillStyle = "rgba(230, 238, 255, " + (tw * 0.85).toFixed(3) + ")";
      ctx.fill();
    }
    raf = requestAnimationFrame(draw);
  }

  function init() {
    resize();
    if (reduced) { draw(0); cancelAnimationFrame(raf); }
    else requestAnimationFrame(draw);
    window.addEventListener("resize", resize);
  }
  init();
})();

/* ============================================================
   Nav: scrolled state + mobile menu
   ============================================================ */
(function () {
  const nav = document.getElementById("nav");
  const onScroll = () => nav.classList.toggle("scrolled", window.scrollY > 12);
  window.addEventListener("scroll", onScroll, { passive: true });
  onScroll();

  const burger = document.getElementById("burger");
  const menu = document.getElementById("mobileMenu");
  burger.addEventListener("click", () => {
    const open = menu.classList.toggle("open");
    burger.classList.toggle("open", open);
    burger.setAttribute("aria-expanded", String(open));
  });
  menu.querySelectorAll("a").forEach(a =>
    a.addEventListener("click", () => {
      menu.classList.remove("open");
      burger.classList.remove("open");
    })
  );
})();

/* ============================================================
   Scroll reveal
   ============================================================ */
(function () {
  const els = document.querySelectorAll(".reveal");
  if (!("IntersectionObserver" in window)) {
    els.forEach(el => el.classList.add("in"));
    return;
  }
  const io = new IntersectionObserver(entries => {
    for (const e of entries) {
      if (e.isIntersecting) { e.target.classList.add("in"); io.unobserve(e.target); }
    }
  }, { threshold: 0.12, rootMargin: "0px 0px -40px 0px" });
  els.forEach(el => io.observe(el));
  // Failsafe: never leave content hidden if observation misfires
  setTimeout(() => {
    if (!document.hidden) {
      els.forEach(el => {
        const r = el.getBoundingClientRect();
        if (r.top < window.innerHeight * 1.2) el.classList.add("in");
      });
    }
  }, 2500);
})();

/* ============================================================
   Animated counters
   ============================================================ */
(function () {
  const ease = x => 1 - Math.pow(1 - x, 3);
  function animate(el) {
    const target = parseFloat(el.dataset.count);
    const decimals = parseInt(el.dataset.decimal || "0", 10);
    const dur = 1600;
    const t0 = performance.now();
    (function tick(now) {
      const p = Math.min((now - t0) / dur, 1);
      el.textContent = (target * ease(p)).toFixed(decimals);
      if (p < 1) requestAnimationFrame(tick);
    })(t0);
  }
  const io = new IntersectionObserver(entries => {
    entries.forEach(e => { if (e.isIntersecting) { animate(e.target); io.unobserve(e.target); } });
  }, { threshold: 0.6 });
  document.querySelectorAll("[data-count]").forEach(el => io.observe(el));
})();

/* ============================================================
   FAQ accordion
   ============================================================ */
document.querySelectorAll(".faq-item").forEach(item => {
  const btn = item.querySelector(".faq-q");
  const panel = item.querySelector(".faq-a");
  btn.addEventListener("click", () => {
    const isOpen = item.classList.contains("open");
    document.querySelectorAll(".faq-item.open").forEach(other => {
      if (other !== item) {
        other.classList.remove("open");
        other.querySelector(".faq-q").setAttribute("aria-expanded", "false");
        other.querySelector(".faq-a").style.maxHeight = null;
      }
    });
    item.classList.toggle("open", !isOpen);
    btn.setAttribute("aria-expanded", String(!isOpen));
    panel.style.maxHeight = !isOpen ? panel.scrollHeight + "px" : null;
  });
});

/* ============================================================
   Cursor-follow glow on cards
   ============================================================ */
document.querySelectorAll("[data-tilt]").forEach(card => {
  card.addEventListener("pointermove", e => {
    const r = card.getBoundingClientRect();
    card.style.setProperty("--mx", (e.clientX - r.left) + "px");
    card.style.setProperty("--my", (e.clientY - r.top) + "px");
  });
});
