---
title: Rule Structure Format
description: Guidelines for creating well-structured rules
version: 1.0.0
updated: 2025-03-01
---

# Rule Structure Format

This module provides guidelines for creating well-structured rules for AI development.

## 1. Core Structure

```
---
description: ACTION when TRIGGER to OUTCOME
globs: *.mdc
---

# Rule Title

## Context
- When to apply this rule
- Prerequisites or conditions

## Requirements
- Concise, actionable items
- Each requirement must be testable

## Examples
<example>
Good concise example with explanation
</example>

<example type="invalid">
Invalid concise example with explanation
</example>
```

## 2. Context Section

The Context section should explain:
- When to apply the rule
- Prerequisites or conditions
- Scope of applicability
- Related rules or dependencies

Example:

```markdown
## Context
- Apply when implementing API endpoints that handle user data
- Prerequisites: Authentication system is in place
- Applies to all controller methods that modify user information
- Related to authentication and input validation rules
```

## 3. Requirements Section

The Requirements section should:
- List concise, actionable items
- Ensure each requirement is testable
- Provide clear acceptance criteria
- Use imperative language

Example:

```markdown
## Requirements
- Validate user input against XSS attacks
- Sanitize all user-provided fields before storing
- Return appropriate HTTP status codes for errors
- Log all failed validation attempts
- Implement rate limiting for API endpoints
```

## 4. Examples Section

The Examples section should include:
- Valid examples showing correct implementation
- Invalid examples showing what to avoid
- Brief explanations for each example
- Minimal code that demonstrates the principle

Example:

```markdown
## Examples
<example>
// Good: Properly validates and sanitizes user input
const sanitizedInput = sanitizeHtml(req.body.comment);
if (validator.isValid(sanitizedInput)) {
  saveComment(sanitizedInput);
} else {
  return res.status(400).json({ error: 'Invalid input' });
}
</example>

<example type="invalid">
// Bad: Directly uses user input without validation
saveComment(req.body.comment);
</example>
```

## 5. Formatting Guidelines

- Use Concise Markdown primarily
- XML tags limited to specific semantic purposes
- Always indent content within XML tags by 2 spaces
- Keep rules as short as possible
- Use Mermaid syntax for complex relationships
- Use emojis where appropriate to convey meaning
- Keep examples as short as possible