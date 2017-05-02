# Detecting Home Button vs Lock Button in Swift 3

### Motivation

Recently, I tried to make a task management app that wants to identify whether my app goes into background due to user switching to another app or pressing the lock button. If he/she locks the screen, the clock goes on. Otherwise, the clock will be interrupted. However, I found out that current solutions to this problem are only applicable to iOS 7 in Objective-C. So I decided to modify it to make it up to date with the new Swift 3 syntax.

### Method

It utilizes Darwin Notifications with CFNotificationCallback method to detect lockstatus right after app goes into background.
It can be achieved by adding the following code to **AppDelegate.swift** in four simple steps:

#### Step 1:

Add the following code right under AppDelegate class declaration

```swift
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    let displayStatusChanged: CFNotificationCallback = { center, observer, name, object, info in
        let str = name!.rawValue as CFString
        if (str == "com.apple.springboard.lockcomplete" as CFString) {
            let isDisplayStatusLocked = UserDefaults.standard
            isDisplayStatusLocked.set(true, forKey: "isDisplayStatusLocked")
            isDisplayStatusLocked.synchronize()
        }
    }
    
    //other functions
}
```

#### Step 2:

Inside `didFinishLaunchingWithOptions`, add the following code:

```swift
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions:
    [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        let isDisplayStatusLocked = UserDefaults.standard
        isDisplayStatusLocked.set(false, forKey: "isDisplayStatusLocked")
        isDisplayStatusLocked.synchronize()
        
        // Darwin Notification
        let cfstr = "com.apple.springboard.lockcomplete" as CFString
        let notificationCenter = CFNotificationCenterGetDarwinNotifyCenter()
        let function = displayStatusChanged
        CFNotificationCenterAddObserver(notificationCenter,
                                        nil,
                                        function,
                                        cfstr,
                                        nil,
                                        .deliverImmediately)
        
        return true
    }
```

#### Step 3:

Inside `applicationDidEnterBackground`, add the following code:

```swift
func applicationDidEnterBackground(_ application: UIApplication) {      
        let isDisplayStatusLocked = UserDefaults.standard
        if let lock = isDisplayStatusLocked.value(forKey: "isDisplayStatusLocked"){
            // user locked screen
            if(lock as! Bool){            
                // do anything you want here
                print("Lock button pressed.")
            }
            // user pressed home button
            else{            
                // do anything you want here
                print("Home button pressed.")
            }
        }
    }
```

#### Step 4:

Inside `applicationWillEnterForeground`, add the following code:

```swift
    func applicationWillEnterForeground(_ application: UIApplication) {
        print("Back to foreground.")
        //restore lock screen setting
        let isDisplayStatusLocked = UserDefaults.standard
        isDisplayStatusLocked.set(false, forKey: "isDisplayStatusLocked")
        isDisplayStatusLocked.synchronize()  
    }
```

Please download/clone the project for a brief demonstration.

### Credit

[Detecting Home button vs Lock button - iOS 7](https://github.com/binarydev/ios-home-vs-lock-button) by [Jose Santiago](https://github.com/binarydev)
