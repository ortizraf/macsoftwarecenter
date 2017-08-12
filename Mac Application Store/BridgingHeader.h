// 1. Create this file in your Xcode project
// 2. Go to "Build Settings" and find "Objective-C Bridging Header." Use the search bar to find it quickly.
// 3. Double-click and type "BridgingHeader.c"
//    If you get "Could not import Objective-C Header," try "my-project-name/BridgingHeader.h"
// 4. Go to "Build Phases," "Link Binary With Libraries," and add libsqlite3.0.dylib

#include <sqlite3.h>
#import "SQLiteObjc.h"
