package net.aihelp.p007ui.preview.viewer;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.IntentValues;
import net.aihelp.p007ui.preview.data.PreviewInfo;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.ToastUtil;

public abstract class BasePreviewer {
    private static final int BYTES_FOR_1MB = 1048576;

    protected static boolean isFileSizeExceeded(Activity activity, PreviewInfo previewInfo) {
        if (activity == null || previewInfo == null || previewInfo.getFileSize() <= getMaxFileSize(previewInfo)) {
            return false;
        }
        fileSizeExceeded(activity, previewInfo);
        closePreviewScreen(activity);
        return true;
    }

    private static void fileSizeExceeded(Context context, PreviewInfo previewInfo) {
        long maxFileSize = getMaxFileSize(previewInfo);
        String string = ResResolver.getString("aihelp_media_upload_err_size");
        try {
            ToastUtil.INSTANCE.makeRawToast(context, String.format(string, Long.valueOf(maxFileSize / 1048576)));
        } catch (Exception unused) {
            ToastUtil.INSTANCE.makeRawToast(context, string + ", < " + (maxFileSize / 1048576) + "M");
        }
    }

    private static void closePreviewScreen(Activity activity) {
        Intent intent = activity.getIntent();
        intent.removeExtra(IntentValues.PREVIEW_INFO);
        activity.setResult(-1, intent);
        activity.finish();
    }

    private static long getMaxFileSize(PreviewInfo previewInfo) {
        int i;
        if (previewInfo == null) {
            i = BYTES_FOR_1MB;
        } else {
            int type = previewInfo.getType();
            if (type == 1) {
                i = CustomConfig.UploadLimit.imageMaxSize;
            } else if (type == 2) {
                i = CustomConfig.UploadLimit.videoMaxSize;
            } else if (type != 3) {
                i = BYTES_FOR_1MB;
            } else {
                i = CustomConfig.UploadLimit.fileMaxSize;
            }
        }
        return i;
    }
}
