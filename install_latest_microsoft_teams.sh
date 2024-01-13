#!/bin/bash

# Download PKG file from Microsoft
curl -o /tmp/MicrosoftTeams.pkg https://statics.teams.cdn.office.net/production-osx/enterprise/webview2/lkg/MicrosoftTeams.pkg

# Install the package
installer -target / -pkg /tmp/MicrosoftTeams.pkg

# Remove the PKG file
rm /tmp/MicrosoftTeams.pkg

exit 0