
set -e

if ! which swiftgen > /dev/null; then
  echo "warning: Swiftgen is not installed. Download from 'https://github.com/SwiftGen/SwiftGen' system-wide version or add via pods. In a case with cocoapods don't forget to change runscript"
  exit 1
fi

#Generate Resources
echo "Generating Resources"

swiftgen config lint --config "swiftgen-assets.yml"
swiftgen config run --config "swiftgen-assets.yml"

swiftgen config lint --config "swiftgen-assets.yml"
swiftgen config run --config "swiftgen-assets.yml"
