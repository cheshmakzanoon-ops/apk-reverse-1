package com.appsflyer.internal;

import android.content.Context;
import android.content.pm.InstallSourceInfo;
import android.content.pm.PackageManager;
import android.os.Build;
import com.appsflyer.AFLogger;
import java.util.LinkedHashMap;
import java.util.Map;
import kotlin.jvm.internal.Intrinsics;

public final class AFg1sSDK {
    private final String AFInAppEventParameterName;
    private final Map<String, Object> AFInAppEventType;
    private final PackageManager AFKeystoreWrapper;

    public AFg1sSDK(AFd1lSDK aFd1lSDK, AFd1rSDK aFd1rSDK) {
        Intrinsics.checkNotNullParameter(aFd1lSDK, "");
        Intrinsics.checkNotNullParameter(aFd1rSDK, "");
        this.AFInAppEventType = new LinkedHashMap();
        Context context = aFd1lSDK.AFInAppEventParameterName;
        this.AFKeystoreWrapper = context != null ? context.getPackageManager() : null;
        String packageName = aFd1rSDK.AFKeystoreWrapper.AFInAppEventParameterName.getPackageName();
        Intrinsics.checkNotNullExpressionValue(packageName, "");
        this.AFInAppEventParameterName = packageName;
    }

    public final Map<String, Object> AFInAppEventParameterName() {
        InstallSourceInfo installSourceInfo;
        String installerPackageName;
        if (this.AFInAppEventType.isEmpty()) {
            try {
                PackageManager packageManager = this.AFKeystoreWrapper;
                if (packageManager != null && (installerPackageName = packageManager.getInstallerPackageName(this.AFInAppEventParameterName)) != null) {
                    this.AFInAppEventType.put("installer_package", installerPackageName);
                }
            } catch (Exception e) {
                AFLogger.afErrorLog("Exception while getting the app's installer package. ", e);
            }
            if (Build.VERSION.SDK_INT >= 30) {
                Map<String, Object> map = this.AFInAppEventType;
                LinkedHashMap linkedHashMap = new LinkedHashMap();
                String str = this.AFInAppEventParameterName;
                PackageManager packageManager2 = this.AFKeystoreWrapper;
                if (packageManager2 != null && (installSourceInfo = packageManager2.getInstallSourceInfo(str)) != null) {
                    Intrinsics.checkNotNullExpressionValue(installSourceInfo, "");
                    linkedHashMap = new LinkedHashMap();
                    String initiatingPackageName = installSourceInfo.getInitiatingPackageName();
                    if (initiatingPackageName != null) {
                        linkedHashMap.put("initiating_package", initiatingPackageName);
                    }
                    String installingPackageName = installSourceInfo.getInstallingPackageName();
                    if (installingPackageName != null) {
                        linkedHashMap.put("installing_package", installingPackageName);
                    }
                    String originatingPackageName = installSourceInfo.getOriginatingPackageName();
                    if (originatingPackageName != null) {
                        linkedHashMap.put("originating_package", originatingPackageName);
                    }
                }
                map.put("install_source_info", linkedHashMap);
            }
        }
        return this.AFInAppEventType;
    }
}
