package net.aihelp.p007ui.preview.viewer;

import android.app.Activity;
import android.view.View;
import android.widget.ImageView;
import net.aihelp.common.CustomConfig;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.util.viewer.PhotoView;
import net.aihelp.p007ui.preview.data.PreviewInfo;
import net.aihelp.utils.ResResolver;

public class ImagePreviewer extends BasePreviewer {
    public static void previewImage(final Activity activity, PreviewInfo previewInfo) {
        if (activity == null || previewInfo == null || isFileSizeExceeded(activity, previewInfo)) {
            return;
        }
        ?? r0 = (PhotoView) activity.findViewById(ResResolver.getViewId("aihelp_image_view"));
        r0.setVisibility(0);
        if (CustomConfig.CommonSetting.isLandscape) {
            r0.setScaleType(ImageView.ScaleType.CENTER_INSIDE);
        } else {
            r0.setScaleType(ImageView.ScaleType.FIT_CENTER);
        }
        if (!previewInfo.isPicking()) {
            r0.setOnClickListener(new View.OnClickListener() {
                @Override
                public void onClick(View view) {
                    Activity activity2 = activity;
                    activity2.setResult(0, activity2.getIntent());
                    activity.finish();
                }
            });
        }
        Glide.with(activity).load(previewInfo.getFilePath()).into((ImageView) r0);
    }
}
