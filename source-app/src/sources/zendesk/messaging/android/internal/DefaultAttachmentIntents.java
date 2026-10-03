package zendesk.messaging.android.internal;

import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.os.Build;
import java.util.List;
import kotlin.Metadata;
import kotlin.collections.ArraysKt;
import kotlin.jvm.internal.Intrinsics;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0000\u0018\u0000 \f2\u00020\u0001:\u0001\fB\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\b\u0010\u0005\u001a\u00020\u0006H\u0016J\b\u0010\u0007\u001a\u00020\u0006H\u0016J\b\u0010\b\u001a\u00020\tH\u0016J\b\u0010\n\u001a\u00020\tH\u0016J\b\u0010\u000b\u001a\u00020\u0006H\u0016R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\r"}, m18d2 = {"Lzendesk/messaging/android/internal/DefaultAttachmentIntents;", "Lzendesk/messaging/android/internal/AttachmentIntents;", "activity", "Landroid/app/Activity;", "(Landroid/app/Activity;)V", "canOpenAttachmentIntent", "", "canOpenCameraIntent", "getAttachmentIntent", "Landroid/content/Intent;", "getCameraIntent", "shouldAskForCameraPermission", "Companion", "zendesk.messaging_messaging-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class DefaultAttachmentIntents implements AttachmentIntents {
    private static final String LOG_TAG = "DefaultAttachmentIntents";
    private final Activity activity;

    public DefaultAttachmentIntents(Activity activity) {
        Intrinsics.checkNotNullParameter(activity, "activity");
        this.activity = activity;
    }

    @Override
    public Intent getCameraIntent() {
        return new Intent("android.media.action.IMAGE_CAPTURE");
    }

    @Override
    public Intent getAttachmentIntent() {
        Intent intent = new Intent("android.intent.action.OPEN_DOCUMENT");
        intent.setType("*/*");
        intent.addCategory("android.intent.category.OPENABLE");
        intent.setFlags(65);
        intent.putExtra("android.intent.extra.ALLOW_MULTIPLE", true);
        return intent;
    }

    @Override
    public boolean canOpenCameraIntent() {
        return this.activity.getPackageManager().hasSystemFeature("android.hardware.camera.any");
    }

    @Override
    public boolean canOpenAttachmentIntent() {
        boolean zIsEmpty;
        if (Build.VERSION.SDK_INT >= 33) {
            PackageManager.ResolveInfoFlags resolveInfoFlagsOf = PackageManager.ResolveInfoFlags.of(131072L);
            Intrinsics.checkNotNullExpressionValue(resolveInfoFlagsOf, "of(...)");
            List listQueryIntentActivities = this.activity.getPackageManager().queryIntentActivities(getAttachmentIntent(), resolveInfoFlagsOf);
            Intrinsics.checkNotNull(listQueryIntentActivities);
            zIsEmpty = listQueryIntentActivities.isEmpty();
        } else {
            List<ResolveInfo> listQueryIntentActivities2 = this.activity.getPackageManager().queryIntentActivities(getAttachmentIntent(), 0);
            Intrinsics.checkNotNull(listQueryIntentActivities2);
            zIsEmpty = listQueryIntentActivities2.isEmpty();
        }
        return !zIsEmpty;
    }

    @Override
    public boolean shouldAskForCameraPermission() throws PackageManager.NameNotFoundException {
        PackageInfo packageInfo;
        if (Build.VERSION.SDK_INT >= 33) {
            packageInfo = this.activity.getPackageManager().getPackageInfo(this.activity.getPackageName(), PackageManager.PackageInfoFlags.of(4096L));
        } else {
            packageInfo = this.activity.getPackageManager().getPackageInfo(this.activity.getPackageName(), 4096);
        }
        String[] strArr = packageInfo.requestedPermissions;
        if (strArr != null) {
            return ArraysKt.contains(strArr, "android.permission.CAMERA");
        }
        Logger.m219e(LOG_TAG, "RequestedPermissions is " + packageInfo.requestedPermissions, new Object[0]);
        return false;
    }
}
