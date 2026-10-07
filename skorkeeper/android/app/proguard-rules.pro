# Project-specific ProGuard/R8 rules.
# Most Flutter plugins ship their own consumer-rules.pro (merged automatically),
# so this file only needs to cover anything specific to this app.

# Keep RevenueCat purchases_flutter models (uses reflection for JSON (de)serialization).
-keep class com.revenuecat.purchases.** { *; }
-dontwarn com.revenuecat.purchases.**

# Keep Google Mobile Ads / Play Services Ads classes referenced via reflection.
-keep class com.google.android.gms.ads.** { *; }
-dontwarn com.google.android.gms.ads.**
