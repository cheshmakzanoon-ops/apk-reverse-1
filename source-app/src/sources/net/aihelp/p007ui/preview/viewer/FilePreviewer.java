package net.aihelp.p007ui.preview.viewer;

import android.app.Activity;
import android.graphics.Color;
import android.widget.TextView;
import net.aihelp.p007ui.preview.data.PreviewInfo;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class FilePreviewer extends BasePreviewer {
    public static void previewFile(Activity activity, PreviewInfo previewInfo) {
        if (activity == null || previewInfo == null || isFileSizeExceeded(activity, previewInfo)) {
            return;
        }
        activity.findViewById(ResResolver.getViewId("aihelp_rl_file_layout")).setVisibility(0);
        TextView textView = (TextView) activity.findViewById(ResResolver.getViewId("aihelp_tv_file_name"));
        Styles.reRenderTextView(textView, previewInfo.getFileName());
        textView.setTextColor(Color.parseColor(Styles.isNightMode(activity) ? "#FFFFFF" : "#333333"));
    }
}
