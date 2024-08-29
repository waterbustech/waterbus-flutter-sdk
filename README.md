# Flutter [Waterbus](https://docs.waterbus.tech) SDK

Flutter plugin of [Waterbus](https://docs.waterbus.tech). Build video call or online meeting application with SFU model. Supports iOS, Android. [ExampleApp](https://github.com/waterbustech/waterbus)

<img src="https://github.com/waterbustech/waterbus-flutter-sdk/blob/migration/v2/.github/waterbus-sdk-banner.png?raw=true" width="100%"/>

<a href="https://opensource.org/licenses/Apache-2.0"><img src="https://img.shields.io/badge/License-Apache%202.0-green.svg"/></a>
<img src="https://img.shields.io/github/issues/waterbustech/waterbus-flutter-sdk" alt="GitHub issues"><a href="https://chromium.googlesource.com/external/webrtc/+/branch-heads/6099"><img src="https://img.shields.io/badge/libwebrtc-125.6422.02-yellow.svg" alt="libwebrtc"></a><img src="https://img.shields.io/cocoapods/v/KaiRTC" alt="Cocoapods Version"><a href="https://github.com/lambiengcode"><img src="https://img.shields.io/badge/PRs-welcome-brightgreen.svg?style=flat&amp;logo=github" alt="PRs Welcome"></a>

## ⚡ Current supported features

| Feature            | Subscribe/Publish | Screen Sharing | Picture in Picture | Virtual Background | Beauty Filters | End to End Encryption |
| ------------------ | ----------------- | -------------- | ------------------ | ------------------ | -------------- | --------------------- |
| Android            |         🟢         |        🟢      |          🟢         |          🟢         |       🟢        |           🟢          | 
| iOS                |         🟢         |        🟢      |          🟢         |          🟢         |       🟢       |           🟢          |        
| Web                |         🟢         |        🟢      |          🟢         |          🟢         |       🟡       |           🟢          |
| MacOS              |         🟢         |        🟢      |          🔴         |          🟢         |       🟢       |           🟢          |
| Linux                |         🟢         |        🟢      |          🔴         |          🟡         |       🟡       |           🟢          |    


🟢 = Available

🟡 = Coming soon (Work in progress)

🔴 = Not currently available (Possibly in the future)

## Installation

### Install Rust via [rustup](https://rustup.rs/).

### Add dependency

Add the dependency from command-line

```bash
$ flutter pub add waterbus_sdk
```

The command above will add this to the `pubspec.yaml` file in your project (you can do this manually):
```yaml
dependencies:
    waterbus_sdk: ^1.3.15
```

## Usage

### Initialize

Firstly, call `WaterbusSdk.instance.initial` to set your server url and sdk connect WebSocket.

```dart
await WaterbusSdk.instance.initial(
  apiUrl: 'https://service.waterbus.tech/busapi/v1/',
  wsUrl: 'wss://sfu.waterbus.tech',
);
```

### Create room

```dart
final Meeting? meeting = await WaterbusSdk.instance.createRoom(
  meeting: Meeting(title: 'Meeting with Kai Dao'),
  password: 'password',
  userId: 1, // <- modify to your user id
);
```

### Update room

```dart
final Meeting? meeting = await WaterbusSdk.instance.updateRoom(
  meeting:  Meeting(title: 'Meeting with Kai Dao - 2'),
  password: 'new-password',
  userId: 1, // <- modify to your user id
);
```

### Join room

```dart
final Meeting? meeting = await WaterbusSdk.instance.joinRoom(
  meeting: _currentMeeting,
  password: 'room-password-here',
  userId: 1, // <- modify to your user id
);
```

### Set callback room events

```dart
void _onEventChanged(CallbackPayload event) {
  switch (event.event) {
    case CallbackEvents.shouldBeUpdateState:
      break;
    case CallbackEvents.newParticipant:
      break;
    case CallbackEvents.participantHasLeft:
      break;
    case CallbackEvents.meetingEnded:
      break;
    default:
      break;
  }
}
```

```dart
WaterbusSdk.instance.onEventChangedRegister = _onEventChanged;
```

### Leave room

```dart
await WaterbusSdk.instance.leaveRoom();
```

#### Prepare Media (will prepare the camera and microphone for you to turn on and off before entering the meeting)
  
```dart
await WaterbusSdk.instance.prepareMedia();
```

## Configuration

### Android

Ensure the following permission is present in your Android Manifest file, located in `<project root>/android/app/src/main/AndroidManifest.xml`:

```xml
<uses-feature android:name="android.hardware.camera" />
<uses-feature android:name="android.hardware.camera.autofocus" />
<uses-permission android:name="android.permission.CAMERA" />
<uses-permission android:name="android.permission.RECORD_AUDIO" />
<uses-permission android:name="android.permission.ACCESS_NETWORK_STATE" />
<uses-permission android:name="android.permission.CHANGE_NETWORK_STATE" />
<uses-permission android:name="android.permission.MODIFY_AUDIO_SETTINGS" />
```

If you need to use a Bluetooth device, please add:

```xml
<uses-permission android:name="android.permission.BLUETOOTH" android:maxSdkVersion="30" />
<uses-permission android:name="android.permission.BLUETOOTH_ADMIN" android:maxSdkVersion="30" />
```

The Flutter project template adds it, so it may already be there.

Also you will need to set your build settings to Java 8, because official WebRTC jar now uses static methods in `EglBase` interface. Just add this to your app level `build.gradle`:

```groovy
android {
    //...
    compileOptions {
        sourceCompatibility JavaVersion.VERSION_1_8
        targetCompatibility JavaVersion.VERSION_1_8
    }
}
```

Setup for Beauty Filters:

- Add gpupixel in dependencies:

```gradle
implementation 'tech.waterbus:gpupixel:1.0.2'
```


<details>
  <summary>Create FlutterViewEngine.kt</summary>

```kotlin
package com.example.waterbus

import android.app.Activity
import android.content.Intent
import androidx.activity.ComponentActivity
import androidx.lifecycle.Lifecycle
import androidx.lifecycle.LifecycleObserver
import androidx.lifecycle.OnLifecycleEvent
import cl.puntito.simple_pip_mode.PipCallbackHelper
import io.flutter.embedding.android.ExclusiveAppComponent
import io.flutter.embedding.android.FlutterView
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.platform.PlatformPlugin

/**
 *  This is an application-specific wrapper class that exists to expose the intersection of an
 *  application's active activity and an application's visible view to a [FlutterEngine] for
 *  rendering.
 *
 *  Omitted features from the [io.flutter.embedding.android.FlutterActivity] include:
 *   * **State restoration**. If you're integrating at the view level, you should handle activity
 *      state restoration yourself.
 *   * **Engine creations**. At this level of granularity, you must make an engine and attach.
 *      and all engine features like initial route etc must be configured on the engine yourself.
 *   * **Splash screens**. You must implement it yourself. Read from
 *     `addOnFirstFrameRenderedListener` as needed.
 *   * **Transparency, surface/texture**. These are just [FlutterView] level APIs. Set them on the
 *      [FlutterView] directly.
 *   * **Intents**. This doesn't do any translation of intents into actions in the [FlutterEngine].
 *      you must do them yourself.
 *   * **Back buttons**. You must decide whether to send it to Flutter via
 *      [FlutterEngine.getNavigationChannel.popRoute()], or consume it natively. Though that
 *      decision may be difficult due to https://github.com/flutter/flutter/issues/67011.
 *   * **Low memory signals**. You're strongly encouraged to pass the low memory signals (such
 *      as from the host `Activity`'s `onTrimMemory` callbacks) to the [FlutterEngine] to let
 *      Flutter and the Dart VM cull its own memory usage.
 *
 * Your own [FlutterView] integrating application may need a similar wrapper but you must decide on
 * what the appropriate intersection between the [FlutterView], the [FlutterEngine] and your
 * `Activity` should be for your own application.
 */
class FlutterViewEngine(val engine: FlutterEngine) : LifecycleObserver, ExclusiveAppComponent<Activity>{
    private var callbackHelper = PipCallbackHelper()
    private var flutterView: FlutterView? = null
    private var activity: ComponentActivity? = null
    private var platformPlugin: PlatformPlugin? = null

    init {
        callbackHelper.configureFlutterEngine(engine)
    }

    /**
     * This is the intersection of an available activity and of a visible [FlutterView]. This is
     * where Flutter would start rendering.
     */
    private fun hookActivityAndView() {
        // Assert state.
        activity!!.let { activity ->
            flutterView!!.let { flutterView ->
                platformPlugin = PlatformPlugin(activity, engine.platformChannel)

                engine.activityControlSurface.attachToActivity(this, activity.lifecycle)
                flutterView.attachToFlutterEngine(engine)
                activity.lifecycle.addObserver(this)

                activity.addOnPictureInPictureModeChangedListener {
                    callbackHelper.onPictureInPictureModeChanged(it.isInPictureInPictureMode)
                }
            }
        }
    }

    /**
     * Lost the intersection of either an available activity or a visible
     * [FlutterView].
     */
    private fun unhookActivityAndView() {
        // Stop reacting to activity events.
        activity!!.lifecycle.removeObserver(this)

        // Plugins are no longer attached to an activity.
        engine.activityControlSurface.detachFromActivity()

        // Release Flutter's control of UI such as system chrome.
        platformPlugin!!.destroy()
        platformPlugin = null

        // Set Flutter's application state to detached.
        engine.lifecycleChannel.appIsDetached();

        // Detach rendering pipeline.
        flutterView!!.detachFromFlutterEngine()
    }

    /**
     * Signal that a host `Activity` is now ready. If there is no [FlutterView] instance currently
     * attached to the view hierarchy and visible, Flutter is not yet rendering.
     *
     * You can also choose at this point whether to notify the plugins that an `Activity` is
     * attached or not. You can also choose at this point whether to connect a Flutter
     * [PlatformPlugin] at this point which allows your Dart program to trigger things like
     * haptic feedback and read the clipboard. This sample arbitrarily chooses no for both.
     */
    fun attachToActivity(activity: ComponentActivity) {
        this.activity = activity
        if (flutterView != null) {
            hookActivityAndView()
        }
    }

    /**
     * Signal that a host `Activity` now no longer connected. If there were a [FlutterView] in
     * the view hierarchy and visible at this moment, that [FlutterView] will stop rendering.
     *
     * You can also choose at this point whether to notify the plugins that an `Activity` is
     * no longer attached or not. You can also choose at this point whether to disconnect Flutter's
     * [PlatformPlugin] at this point which stops your Dart program being able to trigger things
     * like haptic feedback and read the clipboard. This sample arbitrarily chooses yes for both.
     */
    fun detachActivity() {
        if (flutterView != null) {
            unhookActivityAndView()
        }
        activity = null
    }

    /**
     * Signal that a [FlutterView] instance is created and attached to a visible Android view
     * hierarchy.
     *
     * If an `Activity` was also previously provided, this puts Flutter into the rendering state
     * for this [FlutterView]. This also connects this wrapper class to listen to the `Activity`'s
     * lifecycle to pause rendering when the activity is put into the background while the
     * view is still attached to the view hierarchy.
     */
    fun attachFlutterView(flutterView: FlutterView) {
        this.flutterView = flutterView
        if (activity != null) {
            hookActivityAndView()
        }
    }

    /**
     * Signal that the attached [FlutterView] instance destroyed or no longer attached to a visible
     * Android view hierarchy.
     *
     * If an `Activity` was attached, this stops Flutter from rendering. It also makes this wrapper
     * class stop listening to the `Activity`'s lifecycle since it's no longer rendering.
     */
    fun detachFlutterView() {
        unhookActivityAndView()
        flutterView = null
    }

    /**
     * Callback to let Flutter respond to the `Activity`'s resumed lifecycle event while both an
     * `Activity` and a [FlutterView] are attached.
     */
    @OnLifecycleEvent(Lifecycle.Event.ON_RESUME)
    private fun resumeActivity() {
        if (activity != null) {
            engine.lifecycleChannel.appIsResumed()
        }

        platformPlugin?.updateSystemUiOverlays()
    }

    /**
     * Callback to let Flutter respond to the `Activity`'s paused lifecycle event while both an
     * `Activity` and a [FlutterView] are attached.
     */
    @OnLifecycleEvent(Lifecycle.Event.ON_PAUSE)
    private fun pauseActivity() {
        if (activity != null) {
            engine.lifecycleChannel.appIsInactive()
        }
    }

    /**
     * Callback to let Flutter respond to the `Activity`'s stopped lifecycle event while both an
     * `Activity` and a [FlutterView] are attached.
     */
    @OnLifecycleEvent(Lifecycle.Event.ON_STOP)
    private fun stopActivity() {
        if (activity != null) {
            engine.lifecycleChannel.appIsPaused()
        }
    }

    // These events aren't used but would be needed for Flutter plugins consuming
    // these events to function.

    /**
     * Pass through the `Activity`'s `onRequestPermissionsResult` signal to plugins that may be
     * listening to it while the `Activity` and the [FlutterView] are connected.
     */
    fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        if (activity != null && flutterView != null) {
            engine
                .activityControlSurface
                .onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }

    /**
     * Pass through the `Activity`'s `onActivityResult` signal to plugins that may be
     * listening to it while the `Activity` and the [FlutterView] are connected.
     */
    fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        if (activity != null && flutterView != null) {
            engine.activityControlSurface.onActivityResult(requestCode, resultCode, data);
        }
    }

    /**
     * Pass through the `Activity`'s `onUserLeaveHint` signal to plugins that may be
     * listening to it while the `Activity` and the [FlutterView] are connected.
     */
    fun onUserLeaveHint() {
        if (activity != null && flutterView != null) {
            engine.activityControlSurface.onUserLeaveHint();
        }
    }

    /**
     * Called when another App Component is about to become attached to the [ ] this App Component
     * is currently attached to.
     *
     *
     * This App Component's connections to the [io.flutter.embedding.engine.FlutterEngine]
     * are still valid at the moment of this call.
     */
    override fun detachFromFlutterEngine() {
        // Do nothing here
    }

    /**
     * Retrieve the App Component behind this exclusive App Component.
     *
     * @return The app component.
     */
    override fun getAppComponent(): Activity {
        return activity!!;
    }
}
```
</details>

<details>
  <summary>Create activity_main.xml</summary>

```xml
<?xml version="1.0" encoding="utf-8"?>
<RelativeLayout xmlns:android="http://schemas.android.com/apk/res/android"
    xmlns:tools="http://schemas.android.com/tools"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    tools:context=".MainActivity">

    <io.flutter.embedding.android.FlutterView
        android:id="@+id/flutterView"
        android:layout_width="match_parent"
        android:layout_height="match_parent"
        android:focusable="true"
        android:focusableInTouchMode="true"/>

    <!-- GPUPixelView -->
    <com.pixpark.gpupixel.GPUPixelView
        android:id="@+id/surfaceView"
        android:layout_width="match_parent"
        android:layout_height="40dp"
        tools:layout_editor_absoluteX="-183dp"
        tools:layout_editor_absoluteY="0dp" />

</RelativeLayout>
```
</details>

<details>
  <summary>Update MainActivity.kt</summary>

```kotlin
package com.waterbus.wanted

import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import com.example.waterbus.FlutterViewEngine
import com.pixpark.gpupixel.GPUPixel
import com.waterbus.wanted.databinding.ActivityMainBinding
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.embedding.engine.dart.DartExecutor

class MainActivity: AppCompatActivity()  {
    private lateinit var binding: ActivityMainBinding
    private lateinit var flutterViewEngine: FlutterViewEngine

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        binding = ActivityMainBinding.inflate(layoutInflater)
        setContentView(binding.root)

        // TODO: create a multi-engine version after
        // https://github.com/flutter/flutter/issues/72009 is built.
        val engine = FlutterEngine(applicationContext)
        engine.dartExecutor.executeDartEntrypoint(
            DartExecutor.DartEntrypoint.createDefault()
        );

        flutterViewEngine = FlutterViewEngine(engine)
        // The activity and FlutterView have different lifecycles.
        // Attach the activity right away but only start rendering when the
        // view is also scrolled into the screen.
        flutterViewEngine.attachToActivity(this)

        val flutterView = binding.flutterView

        // Attach FlutterEngine to FlutterView
        flutterView.attachToFlutterEngine(engine)
        flutterViewEngine.attachFlutterView(flutterView)

        GPUPixel.setContext(applicationContext)
    }

    override fun onDestroy() {
        super.onDestroy()
        flutterViewEngine.detachActivity()
    }

    override fun onRequestPermissionsResult(
        requestCode: Int,
        permissions: Array<out String>,
        grantResults: IntArray
    ) {
        flutterViewEngine.onRequestPermissionsResult(requestCode, permissions, grantResults)
        super.onRequestPermissionsResult(requestCode, permissions, grantResults)
    }

    override fun onActivityResult(requestCode: Int, resultCode: Int, data: Intent?) {
        flutterViewEngine.onActivityResult(requestCode, resultCode, data)
        super.onActivityResult(requestCode, resultCode, data)
    }

    override fun onUserLeaveHint() {
        flutterViewEngine.onUserLeaveHint()
        super.onUserLeaveHint()
    }
}
```
</details>

### iOS

Add the following entry to your _Info.plist_ file, located in `<project root>/ios/Runner/Info.plist`:

```xml
<key>NSCameraUsageDescription</key>
<string>$(PRODUCT_NAME) Camera Usage!</string>
<key>NSMicrophoneUsageDescription</key>
<string>$(PRODUCT_NAME) Microphone Usage!</string>
```

This entry allows your app to access camera and microphone.

### Note for iOS.
The WebRTC.xframework compiled after the m104 release no longer supports iOS arm devices, so need to add the `config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES'` to your ios/Podfile in your project

ios/Podfile

```ruby
post_install do |installer|
  installer.pods_project.targets.each do |target|
    flutter_additional_ios_build_settings(target)
     target.build_configurations.each do |config|
      # Workaround for https://github.com/flutter/flutter/issues/64502
      config.build_settings['ONLY_ACTIVE_ARCH'] = 'YES' # <= this line
     end
  end
end
```

## Contributing
Contributions are welcome! Please feel free to submit a pull request or open an issue if you encounter any problems or have suggestions for improvements.

## Contact Information

If you have any questions or suggestions related to this application, please contact me via email: lambiengcode@gmail.com.

## Reference

[flutter_webrtc](https://github.com/flutter-webrtc/flutter-webrtc)

## License

Apache License 2.0