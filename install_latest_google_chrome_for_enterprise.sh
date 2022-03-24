#!/bin/bash

curl -o /tmp/GoogleChrome.pkg https://dl.google.com/dl/chrome/mac/universal/stable/gcem/GoogleChrome.pkg

installer -target / -pkg /tmp/GoogleChrome.pkg

rm /tmp/GoogleChrome.pkg

exit 0