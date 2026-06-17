from pathlib import Path

DIAGRAMS_DIR = Path("docs/diagrams")
TITLES = {
    "01-system-context": "C4 System Context - Payment Processing Platform",
    "02-container": "C4 Container - Payment Processing Platform",
    "03-payment-service-component": "C4 Component - Payment Service",
    "04-payment-authorization-flow": "Dynamic View - Payment Authorization Flow",
    "05-production-deployment": "C4 Deployment - Production",
}

for mmd_file in sorted(DIAGRAMS_DIR.glob("*.mmd")):
    key = mmd_file.stem
    title = TITLES.get(key, key.replace("-", " ").title())
    content = mmd_file.read_text(encoding="utf-8").strip()
    md = f"# {title}\n\n[Back to README](../../README.md)\n\n```mermaid\n{content}\n```\n"
    (DIAGRAMS_DIR / f"{key}.md").write_text(md, encoding="utf-8")
