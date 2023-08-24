# bvn_selfie

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter
[plug-in package](https://flutter.dev/developing-packages/),
a specialized package that includes platform-specific implementation code for
Android and/or iOS.

For help getting started with Flutter development, view the
[online documentation](https://flutter.dev/docs), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Add this to make the app download mlkit while installing app on playstore

<application ...>
      ...
      <meta-data
          android:name="com.google.mlkit.vision.DEPENDENCIES"
          android:value="face" >
</application>
