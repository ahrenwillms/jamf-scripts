#!/bin/bash

# Download PKG file from Google
curl -o /tmp/GoogleChrome.pkg https://dl.google.com/dl/chrome/mac/universal/stable/gcem/GoogleChrome.pkg

# Install the package
installer -target / -pkg /tmp/GoogleChrome.pkg

# Remove the PKG file
rm /tmp/GoogleChrome.pkg

exit 0