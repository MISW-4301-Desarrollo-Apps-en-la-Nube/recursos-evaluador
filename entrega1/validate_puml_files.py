import sys
from pathlib import Path


VALIDATIONS = [
    {
        "file": "docs/diagrams/components.puml",
        "options": [
            ["component users_app"],
            ["component posts_app"],
            ["component offers_app"],
            ["component routes_app"],
        ],
    },
    {
        "file": "docs/diagrams/entities.puml",
        "options": [
            ["entity users", "class user"],
            ["entity posts", "class post"],
            ["entity offers", "class offer"],
            ["entity routes", "class route"],
        ],
    },
    {
        "file": "docs/diagrams/deployment.puml",
        "options": [
            ["component users_app", "hexagon users_app"],
            ["component posts_app", "hexagon posts_app"],
            ["component offers_app", "hexagon offers_app"],
            ["component routes_app", "hexagon routes_app"],
            ["frame users-app", "component users-app"],
            ["frame posts-app", "component posts-app"],
            ["frame offers-app", "component offers-app"],
            ["frame routes-app", "component routes-app"],
            ["component users-app-service"],
            ["component posts-app-service"],
            ["component offers-app-service"],
            ["component routes-app-service"],
            ["database users_db"],
            ["database posts_db"],
            ["database offers_db"],
            ["database routes_db"],
            ["frame users-db", "component users-db"],
            ["frame posts-db",  "component posts-db"],
            ["frame offers-db", "component offers-db"],
            ["frame routes-db", "component routes-db"],
            ["component users-db-service"],
            ["component posts-db-service"],
            ["component offers-db-service"],
            ["component routes-db-service"],
            ["artifact users-db-volumen"],
            ["artifact posts-db-volumen"],
            ["artifact offers-db-volumen"],
            ["artifact routes-db-volumen"],
        ],
    },
    {
        "file": "docs/diagrams/networks.puml",
        "options": [
            ["component users_app", "frame users_app"],
            ["component posts_app", "frame posts_app"],
            ["component offers_app", "frame offers_app"],
            ["component routes_app", "frame routes_app"],
            ["frame users-app", "component users-app"],
            ["frame posts-app", "component posts-app"],
            ["frame offers-app", "component offers-app"],
            ["frame routes-app", "component routes-app"],
            ["component users-app-service"],
            ["component posts-app-service"],
            ["component offers-app-service"],
            ["component routes-app-service"],
            ["component users_db", "frame users_db"],
            ["component posts_db", "frame posts_db"],
            ["component offers_db", "frame offers_db"],
            ["component routes_db", "frame routes_db"],
            ["frame users-db", "component users-db"],
            ["frame posts-db",  "component posts-db"],
            ["frame offers-db", "component offers-db"],
            ["frame routes-db", "component routes-db"],
            ["component users-db-service"],
            ["component posts-db-service"],
            ["component offers-db-service"],
            ["component routes-db-service"]
        ],
    },
]


def validate_puml(puml_file, options_list):
    path = Path(puml_file)
    if not path.exists():
        print(f"ERROR: file {puml_file} does not exist")
        return False

    content = path.read_text()

    for options in options_list:
        found = False
        print(f"Validating: {options} in {puml_file}")
        for option in options:
            print(f"Searching for: '{option}'")
            if option in content:
                print(f"Found: '{option}'")
                found = True
                break
        if not found:
            print(f"None of the options found in {puml_file}: {options}")
            return False
    return True


def main():
    all_ok = True
    for validation in VALIDATIONS:
        ok = validate_puml(validation["file"], validation["options"])
        if not ok:
            all_ok = False

    if all_ok:
        print("All files validated successfully.")
        sys.exit(0)
    else:
        print("Validation failed.")
        sys.exit(1)


if __name__ == "__main__":
    main()
