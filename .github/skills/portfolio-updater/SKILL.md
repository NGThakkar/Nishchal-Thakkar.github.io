---
name: portfolio-updater
description: >
  Helps you quickly update your portfolio by adding/editing projects, experience, and skills.
  Works with your current HTML structure and supports natural language requests like
  "Add a new project called X with this description..." or "Update my skills to include React."
  Automatically generates the HTML code needed and modifies files in your workspace.
version: 1.0.0
author: "Nishchal"
license: "MIT"
when-use: "Use this skill whenever you want to add, update, or remove portfolio content (projects, experience, skills). Works best for natural language requests or explicit examples."
---

# Portfolio Updater

This skill automates updates to your portfolio website. Instead of manually editing HTML, describe what you want to add or change in plain language, and the skill will generate and insert the code for you.

## What This Skill Does

- **Add new projects** to your portfolio with descriptions, tech stack, and links
- **Add experience/skills** to your technical knowledge section
- **Update existing entries** in projects, skills, or experience
- **Remove outdated entries** cleanly without breaking HTML
- **Generates templates** you can use for future React migrations

## How to Use This Skill

### 1. Adding a New Project

Provide your request in one of these formats:

**Format A (Structured):**
```
Add a new project called "E-Commerce Platform" with:
- Description: Built a full-stack e-commerce platform with real-time inventory management
- Technologies: React, Node.js, MongoDB, Redux
- Link: https://github.com/yourname/ecommerce
- Timeframe: 2024
```

**Format B (Natural language):**
```
I completed a machine learning project where I used Python and TensorFlow to build 
a predictive model for customer churn. It achieved 92% accuracy. Link: https://github.com/...
```

### 2. Adding Skills/Experience

```
Add to my technical knowledge: I'm now proficient in Kubernetes and Docker Swarm for 
container orchestration.
```

Or:

```
Add a new skill entry:
- Title: Cloud Architecture
- Skills: AWS, GCP, Terraform, Infrastructure as Code
- Icon: fa-cloud
```

### 3. Updating Existing Entries

```
Update my Full Stack Developer skills to also include: Python, Next.js, GraphQL
```

## Portfolio Structure

Your portfolio is organized in the HTML as follows:

```
index.html
├── Navigation menu (with sections)
├── About section (data-section="about")
├── Services/Expertise (data-section="services")
├── Education (data-section="education")
├── Knowledge/Technical Skills (data-section="knowledge")
│   └── Timeline entries with skill categories
├── Contact section (data-section="contact")
└── CSS/JS files for styling
```

### Key HTML Components

**Skill/Knowledge Entry (Timeline):**
```html
<article class="timeline-entry animate-box" data-animate-effect="fadeInLeft">
    <div class="timeline-entry-inner">
        <div class="timeline-icon color-1">
            <i class="fa fa-check"></i>
        </div>
        <div class="timeline-label">
            <h2>Skill Category</h2>
            <p>Skill1, Skill2, Skill3</p>
        </div>
    </div>
</article>
```

**Service/Expertise Card:**
```html
<div class="col-md-4 text-center animate-box">
    <div class="services color-1">
        <span class="icon">
            <i class="fa fa-icon-name" style="font-size: xx-large;"></i>
        </span>
        <div class="desc">
            <h3>Service Name</h3>
        </div>
    </div>
</div>
```

## Workflow

1. **You describe what you want to add/update** in natural language or using the structured format
2. **I analyze your request** and identify the portfolio section to update
3. **I generate the appropriate HTML code** based on your portfolio's structure
4. **I insert or modify the code** in your `index.html` file
5. **I confirm the changes** and show you a preview

## Examples

### Example 1: Add a New Project
**Your request:**
```
Add a new project:
- Title: AI Chat Assistant
- Description: Built a conversational AI chatbot using OpenAI's GPT-4 API and React
- Tech: React, Node.js, OpenAI API, MongoDB
- GitHub: https://github.com/nishchal/ai-chat
- Year: 2024
```

**What I'll do:**
- Identify that projects should be added to the "Services" section or create a new "Projects" section
- Generate proper HTML with icon, title, and description
- Insert into `index.html` with correct styling classes
- Show you the result

### Example 2: Update Skills
**Your request:**
```
Update my Full Stack Developer skills to include: TypeScript, React, Next.js, Node.js, MongoDB, PostgreSQL
```

**What I'll do:**
- Find the "Full Stack Developer" entry in the Knowledge section
- Update the skill list in the HTML
- Maintain proper formatting and styling
- Show you the updated entry

## Future: React Migration Support

When you're ready to migrate to React, this skill can also:
- Generate a JSON data structure of all your portfolio content
- Create React components for projects, skills, and experience
- Set up a component-based portfolio structure
- Provide migration guidelines

To request a React migration, simply ask:
```
Prepare my portfolio for React migration with structured data
```

## Tips for Best Results

1. **Be specific** - Include title, description, technologies, and links when adding projects
2. **Use consistent formatting** - Categories like "Frontend", "Backend", "DevOps" make organization easier
3. **Include dates** - Help visitors understand your timeline and recent work
4. **Add links** - GitHub, demo URLs, or project pages make your portfolio interactive
5. **Group related skills** - "Full Stack", "DevOps", "Data Science" are clearer than scattered skills

## What NOT to Do

- ❌ Don't ask me to completely redesign your portfolio layout (that's for designer agent)
- ❌ Don't request major stylistic changes (use CSS directly or ask design-focused agent)
- ❌ Don't provide vague descriptions - be specific about what you want

## Quick Command Reference

| Request | Result |
|---------|--------|
| "Add project X" | Creates new project entry in HTML |
| "Update skills to include Y" | Adds Y to relevant skill section |
| "Add experience: worked as Z" | Creates experience entry |
| "Remove outdated project" | Deletes entry cleanly |
| "Export portfolio as JSON" | Generates structured data for React |

---

**Ready to update your portfolio?** Just tell me what you'd like to add, change, or remove!
