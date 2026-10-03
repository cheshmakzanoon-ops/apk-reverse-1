package zendesk.conversationkit.android.internal;

import android.content.Context;
import android.content.pm.PackageManager;
import android.telephony.TelephonyManager;
import kotlin.Metadata;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b'\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\b\u0080\b\u0018\u0000 02\u00020\u0001:\u00010BO\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\b\u0010\u0005\u001a\u0004\u0018\u00010\u0003\u0012\u0006\u0010\u0006\u001a\u00020\u0003\u0012\u0006\u0010\u0007\u001a\u00020\u0003\u0012\u0006\u0010\b\u001a\u00020\u0003\u0012\u0006\u0010\t\u001a\u00020\u0003\u0012\u0006\u0010\n\u001a\u00020\u0003\u0012\u0006\u0010\u000b\u001a\u00020\u0003¢\u0006\u0002\u0010\fJ\u000e\u0010\u0017\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u0018J\u000e\u0010\u0019\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u001aJ\u0010\u0010\u001b\u001a\u0004\u0018\u00010\u0003HÀ\u0003¢\u0006\u0002\b\u001cJ\u000e\u0010\u001d\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\u001eJ\u000e\u0010\u001f\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b J\u000e\u0010!\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b\"J\u000e\u0010#\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b$J\u000e\u0010%\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b&J\u000e\u0010'\u001a\u00020\u0003HÀ\u0003¢\u0006\u0002\b(Je\u0010)\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\n\b\u0002\u0010\u0005\u001a\u0004\u0018\u00010\u00032\b\b\u0002\u0010\u0006\u001a\u00020\u00032\b\b\u0002\u0010\u0007\u001a\u00020\u00032\b\b\u0002\u0010\b\u001a\u00020\u00032\b\b\u0002\u0010\t\u001a\u00020\u00032\b\b\u0002\u0010\n\u001a\u00020\u00032\b\b\u0002\u0010\u000b\u001a\u00020\u0003HÆ\u0001J\u0013\u0010*\u001a\u00020+2\b\u0010,\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010-\u001a\u00020.HÖ\u0001J\t\u0010/\u001a\u00020\u0003HÖ\u0001R\u0014\u0010\u0004\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\r\u0010\u000eR\u0016\u0010\u0005\u001a\u0004\u0018\u00010\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u000f\u0010\u000eR\u0014\u0010\u0002\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u000eR\u0014\u0010\u0006\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u000eR\u0014\u0010\u000b\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u000eR\u0014\u0010\u0007\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u000eR\u0014\u0010\b\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u000eR\u0014\u0010\t\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u000eR\u0014\u0010\n\u001a\u00020\u0003X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u000e¨\u00061"}, m18d2 = {"Lzendesk/conversationkit/android/internal/HostAppInfo;", "", "appPackage", "", "appInstallerPackage", "appName", "appVersion", "deviceManufacturer", "deviceModel", "deviceOperatingSystem", "deviceOperatingSystemVersion", "deviceCarrierName", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getAppInstallerPackage$zendesk_conversationkit_conversationkit_android", "()Ljava/lang/String;", "getAppName$zendesk_conversationkit_conversationkit_android", "getAppPackage$zendesk_conversationkit_conversationkit_android", "getAppVersion$zendesk_conversationkit_conversationkit_android", "getDeviceCarrierName$zendesk_conversationkit_conversationkit_android", "getDeviceManufacturer$zendesk_conversationkit_conversationkit_android", "getDeviceModel$zendesk_conversationkit_conversationkit_android", "getDeviceOperatingSystem$zendesk_conversationkit_conversationkit_android", "getDeviceOperatingSystemVersion$zendesk_conversationkit_conversationkit_android", "component1", "component1$zendesk_conversationkit_conversationkit_android", "component2", "component2$zendesk_conversationkit_conversationkit_android", "component3", "component3$zendesk_conversationkit_conversationkit_android", "component4", "component4$zendesk_conversationkit_conversationkit_android", "component5", "component5$zendesk_conversationkit_conversationkit_android", "component6", "component6$zendesk_conversationkit_conversationkit_android", "component7", "component7$zendesk_conversationkit_conversationkit_android", "component8", "component8$zendesk_conversationkit_conversationkit_android", "component9", "component9$zendesk_conversationkit_conversationkit_android", "copy", "equals", "", "other", "hashCode", "", "toString", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class HostAppInfo {

    public static final Companion INSTANCE = new Companion(null);
    private final String appInstallerPackage;
    private final String appName;
    private final String appPackage;
    private final String appVersion;
    private final String deviceCarrierName;
    private final String deviceManufacturer;
    private final String deviceModel;
    private final String deviceOperatingSystem;
    private final String deviceOperatingSystemVersion;

    @JvmStatic
    public static final HostAppInfo from(Context context) {
        return INSTANCE.from(context);
    }

    public final String getAppPackage() {
        return this.appPackage;
    }

    public final String getAppInstallerPackage() {
        return this.appInstallerPackage;
    }

    public final String getAppName() {
        return this.appName;
    }

    public final String getAppVersion() {
        return this.appVersion;
    }

    public final String getDeviceManufacturer() {
        return this.deviceManufacturer;
    }

    public final String getDeviceModel() {
        return this.deviceModel;
    }

    public final String getDeviceOperatingSystem() {
        return this.deviceOperatingSystem;
    }

    public final String getDeviceOperatingSystemVersion() {
        return this.deviceOperatingSystemVersion;
    }

    public final String getDeviceCarrierName() {
        return this.deviceCarrierName;
    }

    public final HostAppInfo copy(String appPackage, String appInstallerPackage, String appName, String appVersion, String deviceManufacturer, String deviceModel, String deviceOperatingSystem, String deviceOperatingSystemVersion, String deviceCarrierName) {
        Intrinsics.checkNotNullParameter(appPackage, "appPackage");
        Intrinsics.checkNotNullParameter(appInstallerPackage, "appInstallerPackage");
        Intrinsics.checkNotNullParameter(appVersion, "appVersion");
        Intrinsics.checkNotNullParameter(deviceManufacturer, "deviceManufacturer");
        Intrinsics.checkNotNullParameter(deviceModel, "deviceModel");
        Intrinsics.checkNotNullParameter(deviceOperatingSystem, "deviceOperatingSystem");
        Intrinsics.checkNotNullParameter(deviceOperatingSystemVersion, "deviceOperatingSystemVersion");
        Intrinsics.checkNotNullParameter(deviceCarrierName, "deviceCarrierName");
        return new HostAppInfo(appPackage, appInstallerPackage, appName, appVersion, deviceManufacturer, deviceModel, deviceOperatingSystem, deviceOperatingSystemVersion, deviceCarrierName);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof HostAppInfo)) {
            return false;
        }
        HostAppInfo hostAppInfo = (HostAppInfo) other;
        return Intrinsics.areEqual(this.appPackage, hostAppInfo.appPackage) && Intrinsics.areEqual(this.appInstallerPackage, hostAppInfo.appInstallerPackage) && Intrinsics.areEqual(this.appName, hostAppInfo.appName) && Intrinsics.areEqual(this.appVersion, hostAppInfo.appVersion) && Intrinsics.areEqual(this.deviceManufacturer, hostAppInfo.deviceManufacturer) && Intrinsics.areEqual(this.deviceModel, hostAppInfo.deviceModel) && Intrinsics.areEqual(this.deviceOperatingSystem, hostAppInfo.deviceOperatingSystem) && Intrinsics.areEqual(this.deviceOperatingSystemVersion, hostAppInfo.deviceOperatingSystemVersion) && Intrinsics.areEqual(this.deviceCarrierName, hostAppInfo.deviceCarrierName);
    }

    public int hashCode() {
        int iHashCode = ((this.appPackage.hashCode() * 31) + this.appInstallerPackage.hashCode()) * 31;
        String str = this.appName;
        return ((((((((((((iHashCode + (str == null ? 0 : str.hashCode())) * 31) + this.appVersion.hashCode()) * 31) + this.deviceManufacturer.hashCode()) * 31) + this.deviceModel.hashCode()) * 31) + this.deviceOperatingSystem.hashCode()) * 31) + this.deviceOperatingSystemVersion.hashCode()) * 31) + this.deviceCarrierName.hashCode();
    }

    public String toString() {
        return "HostAppInfo(appPackage=" + this.appPackage + ", appInstallerPackage=" + this.appInstallerPackage + ", appName=" + this.appName + ", appVersion=" + this.appVersion + ", deviceManufacturer=" + this.deviceManufacturer + ", deviceModel=" + this.deviceModel + ", deviceOperatingSystem=" + this.deviceOperatingSystem + ", deviceOperatingSystemVersion=" + this.deviceOperatingSystemVersion + ", deviceCarrierName=" + this.deviceCarrierName + ')';
    }

    public HostAppInfo(String appPackage, String appInstallerPackage, String str, String appVersion, String deviceManufacturer, String deviceModel, String deviceOperatingSystem, String deviceOperatingSystemVersion, String deviceCarrierName) {
        Intrinsics.checkNotNullParameter(appPackage, "appPackage");
        Intrinsics.checkNotNullParameter(appInstallerPackage, "appInstallerPackage");
        Intrinsics.checkNotNullParameter(appVersion, "appVersion");
        Intrinsics.checkNotNullParameter(deviceManufacturer, "deviceManufacturer");
        Intrinsics.checkNotNullParameter(deviceModel, "deviceModel");
        Intrinsics.checkNotNullParameter(deviceOperatingSystem, "deviceOperatingSystem");
        Intrinsics.checkNotNullParameter(deviceOperatingSystemVersion, "deviceOperatingSystemVersion");
        Intrinsics.checkNotNullParameter(deviceCarrierName, "deviceCarrierName");
        this.appPackage = appPackage;
        this.appInstallerPackage = appInstallerPackage;
        this.appName = str;
        this.appVersion = appVersion;
        this.deviceManufacturer = deviceManufacturer;
        this.deviceModel = deviceModel;
        this.deviceOperatingSystem = deviceOperatingSystem;
        this.deviceOperatingSystemVersion = deviceOperatingSystemVersion;
        this.deviceCarrierName = deviceCarrierName;
    }

    public final String getAppPackage$zendesk_conversationkit_conversationkit_android() {
        return this.appPackage;
    }

    public final String m205xeb92e959() {
        return this.appInstallerPackage;
    }

    public final String getAppName$zendesk_conversationkit_conversationkit_android() {
        return this.appName;
    }

    public final String getAppVersion$zendesk_conversationkit_conversationkit_android() {
        return this.appVersion;
    }

    public final String m207x1b9e53ed() {
        return this.deviceManufacturer;
    }

    public final String getDeviceModel$zendesk_conversationkit_conversationkit_android() {
        return this.deviceModel;
    }

    public final String m208x83735694() {
        return this.deviceOperatingSystem;
    }

    public final String m209xb0259b04() {
        return this.deviceOperatingSystemVersion;
    }

    public final String m206xce3d0167() {
        return this.deviceCarrierName;
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007¨\u0006\u0007"}, m18d2 = {"Lzendesk/conversationkit/android/internal/HostAppInfo$Companion;", "", "()V", "from", "Lzendesk/conversationkit/android/internal/HostAppInfo;", "context", "Landroid/content/Context;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        @JvmStatic
        public final HostAppInfo from(Context context) {
            String str;
            Intrinsics.checkNotNullParameter(context, "context");
            AndroidBuild androidBuildCreate$zendesk_conversationkit_conversationkit_android = AndroidBuild.INSTANCE.create$zendesk_conversationkit_conversationkit_android();
            PackageManager packageManager = context.getPackageManager();
            Intrinsics.checkNotNullExpressionValue(packageManager, "getPackageManager(...)");
            String packageName = context.getPackageName();
            String str2 = packageName == null ? "" : packageName;
            try {
                String str3 = packageManager.getPackageInfo(str2, 0).versionName;
                if (str3 == null) {
                    str3 = "";
                }
                str = str3;
            } catch (PackageManager.NameNotFoundException unused) {
                str = "";
            }
            String installerPackageName = packageManager.getInstallerPackageName(str2);
            String str4 = installerPackageName == null ? "" : installerPackageName;
            String string = packageManager.getApplicationLabel(context.getApplicationInfo()).toString();
            String deviceManufacturer = androidBuildCreate$zendesk_conversationkit_conversationkit_android.getDeviceManufacturer();
            String deviceModel = androidBuildCreate$zendesk_conversationkit_conversationkit_android.getDeviceModel();
            String deviceOperatingSystemVersion = androidBuildCreate$zendesk_conversationkit_conversationkit_android.getDeviceOperatingSystemVersion();
            Object systemService = context.getSystemService("phone");
            TelephonyManager telephonyManager = systemService instanceof TelephonyManager ? (TelephonyManager) systemService : null;
            String networkOperatorName = telephonyManager != null ? telephonyManager.getNetworkOperatorName() : null;
            return new HostAppInfo(str2, str4, string, str, deviceManufacturer, deviceModel, "Android", deviceOperatingSystemVersion, networkOperatorName == null ? "" : networkOperatorName);
        }
    }
}
