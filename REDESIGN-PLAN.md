# Portfolio Redesign Plan - Modern 2026

## Current State
- **Template:** Classic sidebar portfolio (2018-era design)
- **Colors:** Dark sidebar (#1a1a1a), teal accent (#2fa499)
- **Layout:** Fixed sidebar + scrollable content
- **Fonts:** Quicksand, Playfair Display

## Modern Redesign Goals

### 1. **Visual Style**
- ✅ **Minimalist & Clean** - More whitespace, less clutter
- ✅ **Bold Typography** - Large, impactful headings
- ✅ **Gradient Accents** - Modern color transitions
- ✅ **Glassmorphism** - Subtle frosted glass effects
- ✅ **Smooth Animations** - Framer Motion-style transitions
- ✅ **Dark Mode Support** - Auto-switch based on preference

### 2. **Color Palette**

**Option A: Modern Professional**
```
Primary: #6366f1 (Indigo)
Secondary: #8b5cf6 (Violet)
Accent: #06b6d4 (Cyan)
Dark: #0f172a (Slate 900)
Light: #f8fafc (Slate 50)
```

**Option B: Creative Bold**
```
Primary: #f43f5e (Rose)
Secondary: #ec4899 (Pink)
Accent: #8b5cf6 (Violet)
Dark: #18181b (Zinc 900)
Light: #fafafa (Zinc 50)
```

**Option C: Tech Minimal**
```
Primary: #0ea5e9 (Sky Blue)
Secondary: #6366f1 (Indigo)
Accent: #10b981 (Emerald)
Dark: #09090b (Zinc 950)
Light: #ffffff (White)
```

### 3. **Layout Changes**

**Current:** Fixed sidebar + content
**New:** Full-width hero + grid sections

```
┌─────────────────────────────────────┐
│           HERO SECTION              │
│  [Large photo]  [Bold intro text]  │
│         [CTA buttons]               │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│          ABOUT SECTION              │
│     [Bio + Skills grid]             │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│        SERVICES SECTION             │
│   [Card 1] [Card 2] [Card 3]        │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│       EDUCATION SECTION             │
│     [Timeline layout]               │
└─────────────────────────────────────┘

┌─────────────────────────────────────┐
│         CONTACT SECTION             │
│   [Contact cards + Form]            │
└─────────────────────────────────────┘
```

### 4. **Component Updates**

#### Hero Section
- Full viewport height
- Split layout (image left, text right)
- Animated gradient background
- Large bold name + tagline
- CTA buttons with hover effects

#### Navigation
- Sticky header (not sidebar)
- Smooth scroll to sections
- Mobile hamburger menu
- Active section highlighting

#### About Section
- Two-column layout
- Skills as progress bars or tags
- Download resume button

#### Services Section
- Card grid (3 columns)
- Icon + title + description
- Hover lift effect
- Gradient borders

#### Education Section
- Vertical timeline
- Cards with dates
- Institution logos (if available)

#### Contact Section
- Contact cards (email, phone, social)
- Simple contact form
- Map (optional)
- Social links with icons

### 5. **Technical Stack**

**Keep it simple (static site):**
- HTML5 semantic structure
- CSS3 with custom properties (variables)
- Vanilla JavaScript (no framework needed)
- Optional: Tailwind CSS via CDN for rapid styling

**Animations:**
- AOS (Animate On Scroll) library
- CSS transitions for hover effects
- Smooth scroll behavior

**Icons:**
- Font Awesome 6 (CDN)
- Or Heroicons (SVG)

### 6. **Responsive Breakpoints**
```
Mobile: < 640px
Tablet: 640px - 1024px
Desktop: > 1024px
```

### 7. **Performance Goals**
- Lighthouse score: 90+
- Load time: < 2s
- Optimized images (WebP format)
- Minified CSS/JS

---

## Implementation Steps

### Phase 1: Foundation
1. Create new `index-modern.html` (keep old as backup)
2. Set up CSS variables for theming
3. Build header/navigation
4. Create hero section

### Phase 2: Content Sections
5. About section with skills
6. Services cards
7. Education timeline
8. Contact section

### Phase 3: Polish
9. Animations (AOS)
10. Responsive adjustments
11. Dark mode toggle
12. Performance optimization

### Phase 4: Deploy
13. Test on multiple devices
14. Push to GitHub
15. Verify GitHub Pages deployment

---

## Design Inspiration

- https://brittanychiang.com
- https://www.joshwcomeau.com
- https://leebyron.com
- https://github.com/themes (modern portfolio themes)

---

## Questions for You

1. **Color preference?** (Option A, B, or C above)
2. **Keep existing content?** (bio, services, education)
3. **Add new sections?** (Projects, Blog, Testimonials)
4. **Photo update?** (use existing or new one)
5. **Dark mode by default or light?**

Let me know and I'll start building! 🎨
