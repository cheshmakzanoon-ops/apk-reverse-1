package androidx.webkit.internal;

import android.content.ComponentName;
import android.content.pm.PackageManager;
import android.content.pm.ServiceInfo;

public class ApiHelperForTiramisu {
    private ApiHelperForTiramisu() {
    }

    static PackageManager.ComponentInfoFlags m430of(long j) {
        return PackageManager.ComponentInfoFlags.of(j);
    }

    static ServiceInfo getServiceInfo(PackageManager packageManager, ComponentName componentName, PackageManager.ComponentInfoFlags componentInfoFlags) throws PackageManager.NameNotFoundException {
        return packageManager.getServiceInfo(componentName, componentInfoFlags);
    }
}
