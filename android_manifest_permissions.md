# Android manifest additions (add after `flutter create` generates android/)

Add to `android/app/src/main/AndroidManifest.xml` inside `<manifest>` (before `<application>`):

```xml
<!-- Reliable, timezone-aware medication reminders -->
<uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.USE_EXACT_ALARM"/>
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED"/>
<uses-permission android:name="android.permission.VIBRATE"/>
```

And inside `<application>`, for flutter_local_notifications boot rescheduling:

```xml
<receiver android:exact="false" android:name="com.dexterous.flutterlocalnotifications.ScheduledNotificationBootReceiver">
    <intent-filter>
        <action android:name="android.intent.action.BOOT_COMPLETED"/>
        <action android:name="android.intent.action.MY_PACKAGE_REPLACED"/>
    </intent-filter>
</receiver>
```

## Notes
- `SCHEDULE_EXACT_ALARM` triggers Play Store review for exact-alarm justification.
  A medication reminder app is an accepted use case, but declare it.
- On Android 14+, `USE_EXACT_ALARM` is the recommended permission for
  alarm-clock-like apps and does not require the special-access user grant.
- Never assume the OS guarantees exact delivery under Doze/battery saver;
  the scheduling engine (later phase) must reconcile missed windows on app open.

# iOS (ios/Runner/Info.plist) additions

```xml
<key>NSFaceIDUsageDescription</key>
<string>MedTok koristi Face ID za zaštitu vaših zdravstvenih podataka.</string>
```

- iOS caps pending local notifications at 64; the scheduling engine must
  schedule a rolling window, not every future dose.
