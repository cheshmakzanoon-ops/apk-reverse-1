package androidx.appcompat.app;

import android.app.Service;
import android.content.ComponentName;
import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.content.pm.ServiceInfo;
import android.os.Build;
import android.os.IBinder;
import androidx.compose.p002ui.graphics.Fields;

public final class AppLocalesMetadataHolderService extends Service {
    @Override
    public IBinder onBind(Intent intent) {
        throw new UnsupportedOperationException();
    }

    public static ServiceInfo getServiceInfo(Context context) throws PackageManager.NameNotFoundException {
        return context.getPackageManager().getServiceInfo(new ComponentName(context, (Class<?>) AppLocalesMetadataHolderService.class), Build.VERSION.SDK_INT >= 24 ? Api24Impl.getDisabledComponentFlag() | Fields.SpotShadowColor : 640);
    }

    private static class Api24Impl {
        static int getDisabledComponentFlag() {
            return Fields.RotationY;
        }

        private Api24Impl() {
        }
    }
}
