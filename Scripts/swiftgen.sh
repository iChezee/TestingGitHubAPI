
set -e

if ! which swiftgen > /dev/null; then
  echo "warning: Swiftgen not installed, download from https://github.com/SwiftGen/SwiftGen"
  exit 1
fi

#Generate Resources
echo "Generating Resources"

swiftgen config lint --config "swiftgen-assets.yml"
swiftgen config run --config "swiftgen-assets.yml"

swiftgen config lint --config "swiftgen-assets.yml"
swiftgen config run --config "swiftgen-assets.yml"
