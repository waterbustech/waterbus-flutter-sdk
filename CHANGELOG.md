## 2.0.1

* [Chore] Updated `VideoQualityEnum` value
* [Fix] Removed `unloadHandler`

## 2.0.0

* [BREAKING] Upgrade Waterbus SFU to v3 [Written in Rust](https://github.com/waterbustech/waterbus-rs)
  * [Feat] Support HTTP3
  * [Feat] Support Simulcast, SVC
* [Feat] Add custom WebRTC e2ee key
* [Fix] Frame Encryption
* [Chore] Improvement stats
* [Enhance] Reduce connection time
* [Deprecated] Temporarily removed: `Subtitle` and `Recording`

## 1.6.0

* [Fix] Build wasm
* [Chore] Enhance WebRTC configuration with improved ICE and audio settings

## 1.5.3

* [Fix] fix rear camera rotation on android
* [Sdk] refactor return type with exception

## 1.5.2

* [Feat] add white board
* [Feat] add record
* [Feat] add raise hand
* [Fix] PlatformView iOS

## 1.5.1

* [Fix]: Isolate on web

## 1.5.0

* [Feat]: encrypted chats

## 1.4.16

* [Chore]: upgrade web: ^1.0.0

## 1.4.15

* [Feat]: set speaker phone enabled but prefer bluetooth
* [Docs]: add guide to setup beauty filters for Android

## 1.4.14

* [Android]: Upgrade WebRTC SDK M128.6613.02

## 1.4.13

* [Feat]: Using dio_compatibility_layer

## 1.4.12

* [Feat]: Using rhttp + dio

## 1.4.11

* [Feat]: Add reconnect func

## 1.4.10

* [Linux]: Fix crash app when joinRoom
* [Linux]: Fix can not get display media

## 1.4.9

* Chore: remove dependency_overrides

## 1.4.8

* Feat: support flutter wasm

## 1.4.7

* Feat: subtitle

## 1.4.6

* Feat: expose callback sender stats

## 1.4.5

* [Android] Improve performance when convert Bitmap to VideoFrame

## 1.4.4

* Chore: upgrade webrtc sdk

## 1.4.3

* Fix: join room not success

## 1.4.2

* Style: change api_key to api-key

## 1.4.1

* Fix: memory leaks on Android and iOS

## 1.4.0

* Vendor: Upgrade WebRTC SDK to M125.6422
* Fix: transceiver setCodecPreferences

## 1.3.19

* Refactor: use PlatformView for iOS

## 1.3.18

* Fix(Hive): Open box before create getIt

## 1.3.17

* Upgrade flutter_webrtc to support GPUPixel on Android
* Fix socket connection

## 1.3.16

* Refactor: websocket connection

## 1.3.15

* Update `repository`, `issue_tracker`
* Fix banner image

## 1.3.14

* Fix websocket connect fail because token expired
* Replace `wakelock` with `wakelock_plus`
* Update readme.md

## 1.3.13

* Move api to sdk
* Improvement join room
* Add github workflows

## 1.3.10

* fix(e2ee): too late to create encoded streams

## 1.3.9

* Prevent initialize getIt & listen callkit if it already registered

## 1.3.8

* Support Virtual Background for web - Chromium Only
