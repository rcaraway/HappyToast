# HappyToast

A very simple way to show toast messages.

Part of **HappyPath**: opinionated components for building apps really fast.

# How to use
```
let viewController = UIViewController() 
viewController.showToast(message: "Hi there!")
```

**Or on Views or Windows:**
``` 
view.showToast(message: "Works on views!")
window.showToast(message: "Works on windows!")
```

**Change the style:**
``` 
view.showToast(message: "Works on views!", type: .success)

window.showToast(message: "No Internet connection", type: .warning)

viewController.showToast(message: "Server failed to connect", type: .failure)
```
