import sys
from pathlib import Path


VALIDATIONS = [
    {
        "file": "docs/diagrams/components.puml",
        "options": {
            "users_app":  ["component"],
            "posts_app":  ["component"],
            "offers_app": ["component"],
            "routes_app": ["component"],
        },
    },
    {
        "file": "docs/diagrams/entities.puml",
        "options": {
            "users":  ["entity", "class"],
            "posts":  ["entity", "class"],
            "offers": ["entity", "class"],
            "routes": ["entity", "class"],
        }
    },
    {
        "file": "docs/diagrams/deployment.puml",
        "options": {
            "users_app":  ["component", "hexagon"],
            "posts_app":  ["component", "hexagon"],
            "offers_app": ["component", "hexagon"],
            "routes_app": ["component", "hexagon"],
            "users-app":  ["frame", "component"],
            "posts-app":  ["frame", "component"],
            "offers-app": ["frame", "component"],
            "routes-app": ["frame", "component"],
            "users_db":   ["database"],
            "posts_db":   ["database"],
            "offers_db":  ["database"],
            "routes_db":  ["database"],
            "users-db":   ["frame", "component"],
            "posts-db":   ["frame", "component"],
            "offers-db":  ["frame", "component"],
            "routes-db":  ["frame", "component"],
            "users-db-service":  ["component"],
            "posts-db-service":  ["component"],
            "offers-db-service": ["component"],
            "routes-db-service": ["component"],
            "users-app-service":  ["component"],
            "posts-app-service":  ["component"],
            "offers-app-service": ["component"],
            "routes-app-service": ["component"],
            "users-db-volumen":   ["artifact"],
            "posts-db-volumen":   ["artifact"],
            "offers-db-volumen":  ["artifact"],
            "routes-db-volumen":  ["artifact"],
        }
    },
    {
        "file": "docs/diagrams/networks.puml",
        "options": {
            "users_app":  ["component", "frame"],
            "posts_app":  ["component", "frame"],
            "offers_app": ["component", "frame"],
            "routes_app": ["component", "frame"],
            "users-app":  ["frame", "component"],
            "posts-app":  ["frame", "component"],
            "offers-app": ["frame", "component"],
            "routes-app": ["frame", "component"],
            "users-app-service":  ["component"],
            "posts-app-service":  ["component"],
            "offers-app-service": ["component"],
            "routes-app-service": ["component"],
            "users_db":   ["frame", "component"],
            "posts_db":   ["frame", "component"],
            "offers_db":  ["frame", "component"],
            "routes_db":  ["frame", "component"],
            "users-db":   ["frame", "component"],
            "posts-db":   ["frame", "component"],
            "offers-db":  ["frame", "component"],
            "routes-db":  ["frame", "component"],
            "users-db-service":  ["component"],
            "posts-db-service":  ["component"],
            "offers-db-service": ["component"],
            "routes-db-service": ["component"]
        }
    },
]


def validate_puml(puml_file, options_list):
    path = Path(puml_file)
    if not path.exists():
        print(f"❌ ERROR: file {puml_file} does not exist")
        return False

    content = path.read_text()

    for key, value in options_list.items():
        found = False
        print(f"🚀 Searching for: {key} in {puml_file}")
        for option in value:
            if f"{option} \"{key}\"" in content:
                print(f"✅ Found: {option} \"{key}\"")
                found = True
                break
        if not found:
            print(f"❌ {key} not found in {puml_file}. Expected element types: {value}")
            return False
    return True


def main():
    all_ok = True
    for validation in VALIDATIONS:
        ok = validate_puml(validation["file"], validation["options"])
        if not ok:
            all_ok = False

    if all_ok:
        print("✅ All files validated successfully.")
        sys.exit(0)
    else:
        print("❌ Validation failed.")
        sys.exit(1)


if __name__ == "__main__":
    main()
