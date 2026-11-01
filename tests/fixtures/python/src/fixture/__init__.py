"""Formats a build version for display."""


def describe(version: str | None) -> str:
    """Return the version prefixed with ``v``, or ``unversioned`` when blank."""
    return f"v{version}" if version else "unversioned"
