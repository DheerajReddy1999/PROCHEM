// Set current year in footer
const yearEl = document.getElementById('year');
if (yearEl) yearEl.textContent = new Date().getFullYear();

// Smooth scroll for on-page anchors
document.addEventListener('click', (e) => {
  const a = e.target.closest('a[href^="#"]');
  if (!a) return;
  const id = a.getAttribute('href').slice(1);
  const target = document.getElementById(id);
  if (target) {
    e.preventDefault();
    target.scrollIntoView({ behavior: 'smooth', block: 'start' });
  }
});

// Customer logo fallback: try PNG if WEBP fails, otherwise show label
window.addEventListener('DOMContentLoaded', () => {
  document.querySelectorAll('.logo-card picture').forEach((pic) => {
    const img = pic.querySelector('img');
    if (!img) return;
    img.addEventListener('error', () => {
      const pngSrc = img.getAttribute('src') || '';
      // Step 1: remove <source> (WEBP) so <img src> is used
      const sources = pic.querySelectorAll('source');
      if (sources.length) sources.forEach((s) => s.remove());

      // Step 2: try reloading PNG (cache bust)
      if (img.dataset.fallbackTried !== '1' && pngSrc) {
        img.dataset.fallbackTried = '1';
        const bust = (pngSrc.indexOf('?') === -1 ? '?' : '&') + 'fb=1';
        img.src = pngSrc + bust;
        return;
      }

      // Step 3: try alternate folder (photos/ instead of photos/logos/)
      if (img.dataset.altTried !== '1' && pngSrc.includes('photos/logos/')) {
        img.dataset.altTried = '1';
        const alt = pngSrc.replace('photos/logos/', 'photos/');
        const bust2 = (alt.indexOf('?') === -1 ? '?' : '&') + 'fb=2';
        img.src = alt + bust2;
        return;
      }

      // Final: hide the image; label remains visible
      img.style.display = 'none';
    });
  });
});
