# Portfolio Updater - Quick Reference Guide

## Quick Start

Just tell me what you want to update! Examples:

### Add a Project
```
Add a new project:
- Title: AI Chat Assistant
- Description: Built a conversational AI chatbot using OpenAI's GPT-4 API
- Tech: React, Node.js, OpenAI API, MongoDB
- GitHub: https://github.com/nishchal/ai-chat
- Demo: https://ai-chat.demo.com
- Year: 2024
```

### Add a Skill
```
Add to my technical knowledge:
- Category: React Frontend Development
- Skills: React, Next.js, Redux, Tailwind CSS, Jest
```

### Update Experience
```
Add new work experience:
- Job Title: Senior Full Stack Developer
- Company: Tech Company Inc.
- Duration: Jan 2023 - Present
- Description: Leading development of customer-facing web applications
- Achievements: 
  - Improved performance by 40%
  - Mentored 3 junior developers
  - Architected microservices
- Tech: React, Node.js, Kubernetes, AWS
```

### Remove Entry
```
Remove the outdated XYZ skill from my Knowledge section
```

### Update Existing Entry
```
Update my "Full Stack Developer" skills to include: TypeScript, GraphQL, Docker
```

---

## Response Format

I'll respond with:
1. **Summary** of what I'm adding/updating
2. **Generated HTML code** (if needed)
3. **Preview** of how it will look
4. **Status** confirming the file has been updated

---

## Files in This Skill

```
.github/skills/portfolio-updater/
├── SKILL.md                      ← Main skill documentation
├── templates/
│   ├── skill-entry.html          ← Template for knowledge/skills
│   ├── project-entry.html        ← Template for projects
│   ├── experience-entry.html     ← Template for work experience
│   └── portfolio-data.json       ← Structured data for React migration
└── README.md                     ← This file
```

---

## HTML Structure You Should Know

### Skills/Knowledge Section
- **File**: `index.html`
- **Section**: `data-section="knowledge"`
- **Container**: `.timeline-centered` inside the Knowledge section
- **Entry template**: `<article class="timeline-entry">` 
- **Colors**: Use `color-1` through `color-7` (rotates through colors)

### Projects/Services
- **File**: `index.html`
- **Section**: `data-section="services"`
- **Container**: Row with `.col-md-4` columns
- **Card template**: `<div class="services color-X">`
- **Icons**: Font Awesome (fa-*)

### Experience
- Could go in Knowledge section or create new section
- Same timeline structure as Skills

---

## Color Reference

When adding multiple entries, rotate through colors for visual variety:
- `color-1` → Red/Coral
- `color-2` → Blue
- `color-3` → Green
- `color-4` → Orange
- `color-5` → Purple
- `color-6` → Pink
- `color-7` → Teal
- `color-8` → Brown
- `color-9` → Gray

---

## Icon Reference

Common Font Awesome icons for projects:
- `fa-code` - Development
-`fa-laptop` - Web/Software
- `fa-mobile` - Mobile apps
- `fa-shopping-cart` - E-commerce
- `fa-chart-bar` - Analytics/Data
- `fa-database` - Database
- `fa-cloud` - Cloud
- `fa-lock` - Security
- `fa-comments` - Chat/Communication
- `fa-music` - Media/Audio

See full Font Awesome icon list: https://fontawesome.com/icons

---

## Tips for Better Results

✅ **Do:**
- Be specific with project descriptions
- Include technologies and links
- Use natural language
- Provide context about the work

❌ **Don't:**
- Provide vague descriptions
- Mix multiple requests in one message
- Ask for design changes (I handle content)
- Request complete portfolio restructuring

---

## When to Ask for React Migration

When ready to modernize to React, just ask:
```
I'm ready to migrate my portfolio to React. Can you help?
```

I can then:
- Export your content as structured JSON
- Generate React component templates
- Set up the project structure
- Provide migration guide

---

## Examples of What I Can Do

✅ Add new projects
✅ Update skill lists
✅ Add work experience
✅ Remove outdated entries
✅ Export data for React
✅ Generate HTML code
✅ Update existing entries
✅ Create organized sections

---

## Still Need Help?

Refer to the main `SKILL.md` file for detailed instructions and examples!
