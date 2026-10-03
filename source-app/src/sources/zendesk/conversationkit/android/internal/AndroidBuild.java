package zendesk.conversationkit.android.internal;

import android.os.Build;
import kotlin.Metadata;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\f\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0010\b\n\u0002\b\u0003\b\u0080\b\u0018\u0000 \u00152\u00020\u0001:\u0001\u0015B\u001d\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0003\u0012\u0006\u0010\u0005\u001a\u00020\u0003¢\u0006\u0002\u0010\u0006J\t\u0010\u000b\u001a\u00020\u0003HÆ\u0003J\t\u0010\f\u001a\u00020\u0003HÆ\u0003J\t\u0010\r\u001a\u00020\u0003HÆ\u0003J'\u0010\u000e\u001a\u00020\u00002\b\b\u0002\u0010\u0002\u001a\u00020\u00032\b\b\u0002\u0010\u0004\u001a\u00020\u00032\b\b\u0002\u0010\u0005\u001a\u00020\u0003HÆ\u0001J\u0013\u0010\u000f\u001a\u00020\u00102\b\u0010\u0011\u001a\u0004\u0018\u00010\u0001HÖ\u0003J\t\u0010\u0012\u001a\u00020\u0013HÖ\u0001J\t\u0010\u0014\u001a\u00020\u0003HÖ\u0001R\u0011\u0010\u0002\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\u0007\u0010\bR\u0011\u0010\u0004\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\t\u0010\bR\u0011\u0010\u0005\u001a\u00020\u0003¢\u0006\b\n\u0000\u001a\u0004\b\n\u0010\b¨\u0006\u0016"}, m18d2 = {"Lzendesk/conversationkit/android/internal/AndroidBuild;", "", "deviceManufacturer", "", "deviceModel", "deviceOperatingSystemVersion", "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getDeviceManufacturer", "()Ljava/lang/String;", "getDeviceModel", "getDeviceOperatingSystemVersion", "component1", "component2", "component3", "copy", "equals", "", "other", "hashCode", "", "toString", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class AndroidBuild {

    public static final Companion INSTANCE = new Companion(null);
    private final String deviceManufacturer;
    private final String deviceModel;
    private final String deviceOperatingSystemVersion;

    public static AndroidBuild copy$default(AndroidBuild androidBuild, String str, String str2, String str3, int i, Object obj) {
        if ((i & 1) != 0) {
            str = androidBuild.deviceManufacturer;
        }
        if ((i & 2) != 0) {
            str2 = androidBuild.deviceModel;
        }
        if ((i & 4) != 0) {
            str3 = androidBuild.deviceOperatingSystemVersion;
        }
        return androidBuild.copy(str, str2, str3);
    }

    public final String getDeviceManufacturer() {
        return this.deviceManufacturer;
    }

    public final String getDeviceModel() {
        return this.deviceModel;
    }

    public final String getDeviceOperatingSystemVersion() {
        return this.deviceOperatingSystemVersion;
    }

    public final AndroidBuild copy(String deviceManufacturer, String deviceModel, String deviceOperatingSystemVersion) {
        Intrinsics.checkNotNullParameter(deviceManufacturer, "deviceManufacturer");
        Intrinsics.checkNotNullParameter(deviceModel, "deviceModel");
        Intrinsics.checkNotNullParameter(deviceOperatingSystemVersion, "deviceOperatingSystemVersion");
        return new AndroidBuild(deviceManufacturer, deviceModel, deviceOperatingSystemVersion);
    }

    public boolean equals(Object other) {
        if (this == other) {
            return true;
        }
        if (!(other instanceof AndroidBuild)) {
            return false;
        }
        AndroidBuild androidBuild = (AndroidBuild) other;
        return Intrinsics.areEqual(this.deviceManufacturer, androidBuild.deviceManufacturer) && Intrinsics.areEqual(this.deviceModel, androidBuild.deviceModel) && Intrinsics.areEqual(this.deviceOperatingSystemVersion, androidBuild.deviceOperatingSystemVersion);
    }

    public int hashCode() {
        return (((this.deviceManufacturer.hashCode() * 31) + this.deviceModel.hashCode()) * 31) + this.deviceOperatingSystemVersion.hashCode();
    }

    public String toString() {
        return "AndroidBuild(deviceManufacturer=" + this.deviceManufacturer + ", deviceModel=" + this.deviceModel + ", deviceOperatingSystemVersion=" + this.deviceOperatingSystemVersion + ')';
    }

    public AndroidBuild(String deviceManufacturer, String deviceModel, String deviceOperatingSystemVersion) {
        Intrinsics.checkNotNullParameter(deviceManufacturer, "deviceManufacturer");
        Intrinsics.checkNotNullParameter(deviceModel, "deviceModel");
        Intrinsics.checkNotNullParameter(deviceOperatingSystemVersion, "deviceOperatingSystemVersion");
        this.deviceManufacturer = deviceManufacturer;
        this.deviceModel = deviceModel;
        this.deviceOperatingSystemVersion = deviceOperatingSystemVersion;
    }

    public final String getDeviceManufacturer() {
        return this.deviceManufacturer;
    }

    public final String getDeviceModel() {
        return this.deviceModel;
    }

    public final String getDeviceOperatingSystemVersion() {
        return this.deviceOperatingSystemVersion;
    }

    @Metadata(m17d1 = {"\u0000\u0014\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\r\u0010\u0003\u001a\u00020\u0004H\u0000¢\u0006\u0002\b\u0005¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/AndroidBuild$Companion;", "", "()V", "create", "Lzendesk/conversationkit/android/internal/AndroidBuild;", "create$zendesk_conversationkit_conversationkit_android", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        public final AndroidBuild create$zendesk_conversationkit_conversationkit_android() {
            String str = Build.MANUFACTURER;
            if (str == null) {
                str = "";
            }
            String str2 = Build.MODEL;
            if (str2 == null) {
                str2 = "";
            }
            String str3 = Build.VERSION.RELEASE;
            return new AndroidBuild(str, str2, str3 != null ? str3 : "");
        }
    }
}
