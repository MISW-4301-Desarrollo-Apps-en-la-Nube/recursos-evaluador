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
            ["component users_app"],
            ["component posts_app"],
            ["component offers_app"],
            ["component routes_app"],
            ["database users_db"],
            ["database posts_db"],
            ["database offers_db"],
            ["database routes_db"],
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
