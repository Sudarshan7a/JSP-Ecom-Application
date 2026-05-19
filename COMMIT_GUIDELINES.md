# Commit Message Guidelines

Follow these guidelines to keep the project history clean and easy to navigate.

- Use the Conventional Commits style: `type(scope?): subject`
- Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `chore`
- Keep the subject line under 72 characters and use imperative mood.
- Add a longer body if necessary, separated by a blank line.
- Reference issues with `#123` when applicable.

Examples:

```
feat(cart): persist coupon code in order history

This change ensures the discounted unit prices are saved with orders.

Closes #45
```

```
fix(product): disable add-to-cart when stock is zero

Prevent checkout errors when out-of-stock items are requested.
```
