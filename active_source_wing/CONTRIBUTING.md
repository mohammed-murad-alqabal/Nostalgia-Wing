# Contributing to Wing of Nostalgia

First off, thanks for taking the time to contribute! 🎉

## Code Quality Standards

We maintain strict code quality standards to ensure the project remains robust and maintainable.

### Linting

- All code **must** pass `flutter analyze` with **0 issues**.
- We strictly enforce the **80-character line limit** to ensure readability across all devices and editors.
- Do not use `print` in production code; use `WingLogger`.

### Testing

- **New Features**: Must include Unit Tests and Widget Tests where applicable.
- **Bug Fixes**: Must include a regression test.
- **Performance**: Critical paths must maintain performance benchmarks (e.g., DB writes < 50ms).

Run tests before submitting:

```bash
flutter test
```

## Pull Request Process

1.  Ensure any install or build dependencies are removed before the end of the layer when doing a build.
2.  Update the `README.md` with details of changes to the interface, this includes new environment variables, exposed ports, useful file locations and container parameters.
3.  Increase the version numbers in any examples files and the README.md to the new version that this Pull Request would represent.
4.  You may merge the Pull Request in once you have the sign-off of two other developers, or if you do not have permission to do that, you may request the second reviewer to merge it for you.

## Style Guide

- **File Naming**: `snake_case` (e.g., `emotional_state.dart`).
- **Class Naming**: `PascalCase` (e.g., `EmotionalState`).
- **Comments**: Use `///` for documentation comments on all public members.
