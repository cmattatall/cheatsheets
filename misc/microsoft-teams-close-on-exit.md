In the mean time, you can kill the Teams application
open ~/.config/Microsoft/Microsoft Teams/desktop-config.json and you should see there this config
 {
   .....
   "appPreferenceSettings": {
     "disableGpu": false,
     "openAtLogin": true,               <- change this to false to disable "Auto-start application"
     "openAsHidden": false,
     "runningOnClose": true,            <- change this to false to disable "On close keep application running"
     "registerAsIMProvider": false
   },
   ....
 }
