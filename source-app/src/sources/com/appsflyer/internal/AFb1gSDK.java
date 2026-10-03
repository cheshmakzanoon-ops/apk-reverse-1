package com.appsflyer.internal;

import com.appsflyer.AFLogger;

@Deprecated
public final class AFb1gSDK {
    private final AFa1uSDK values = new AFa1uSDK() {
        @Override
        public final Class<?> values(String str) throws ClassNotFoundException {
            return Class.forName(str);
        }
    };

    interface AFa1uSDK {
        Class<?> values(String str) throws ClassNotFoundException;
    }

    public final String AFInAppEventType() {
        for (AFa1ySDK aFa1ySDK : AFa1ySDK.values()) {
            if (values(aFa1ySDK.afWarnLog)) {
                return aFa1ySDK.f302i;
            }
        }
        return AFa1ySDK.DEFAULT.f302i;
    }

    private boolean values(String str) {
        try {
            this.values.values(str);
            StringBuilder sb = new StringBuilder("Class: ");
            sb.append(str);
            sb.append(" is found.");
            AFLogger.afRDLog(sb.toString());
            return true;
        } catch (ClassNotFoundException e) {
            StringBuilder sb2 = new StringBuilder("Class: ");
            sb2.append(str);
            sb2.append(" is  not found. (Platform extension)");
            AFLogger.afErrorLogForExcManagerOnly(sb2.toString(), e, true);
            return false;
        } catch (Throwable th) {
            AFLogger.afErrorLog(th.getMessage(), th);
            return false;
        }
    }

    enum AFa1ySDK {
        ADOBE_AIR("android_adobe_air", "com.appsflyer.adobeair.AppsFlyerExtension"),
        ADOBE_MOBILE_SDK("android_adobe_mobile", "com.appsflyer.adobeextension.AppsFlyerAdobeExtension"),
        COCOS2DX("android_cocos2dx", "org.cocos2dx.lib.Cocos2dxActivity"),
        CORDOVA("android_cordova", "com.appsflyer.cordova.plugin.AppsFlyerPlugin"),
        DEFAULT("android_native", "android_native"),
        FLUTTER("android_flutter", "com.appsflyer.appsflyersdk.AppsflyerSdkPlugin"),
        M_PARTICLE("android_mparticle", "com.mparticle.kits.AppsFlyerKit"),
        NATIVE_SCRIPT("android_native_script", "com.tns.NativeScriptActivity"),
        EXPO("android_expo", "expo.modules.devmenu.react.DevMenuAwareReactActivity"),
        REACT_NATIVE("android_reactNative", "com.appsflyer.reactnative.RNAppsFlyerModule"),
        UNITY("android_unity", "com.appsflyer.unity.AppsFlyerAndroidWrapper"),
        UNREAL_ENGINE("android_unreal", "com.epicgames.ue4.GameActivity"),
        XAMARIN("android_xamarin", "mono.android.Runtime"),
        CAPACITOR("android_capacitor", "capacitor.plugin.appsflyer.sdk.AppsFlyerPlugin");

        private final String afWarnLog;

        private final String f302i;

        AFa1ySDK(String str, String str2) {
            this.f302i = str;
            this.afWarnLog = str2;
        }
    }
}
