package net.aihelp.p007ui.preview;

import android.content.Context;
import android.content.Intent;
import android.content.res.Configuration;
import android.os.Bundle;
import androidx.fragment.app.Fragment;
import net.aihelp.common.CustomConfig;
import net.aihelp.common.IntentValues;
import net.aihelp.core.p004ui.BaseActivity;
import net.aihelp.p007ui.preview.data.PreviewInfo;
import net.aihelp.p007ui.preview.util.PreviewHelper;
import net.aihelp.p007ui.preview.viewer.FilePreviewer;
import net.aihelp.p007ui.preview.viewer.ImagePreviewer;
import net.aihelp.p007ui.preview.viewer.VideoPreviewer;
import net.aihelp.utils.ResResolver;

public class PreviewActivity extends BaseActivity {
    public static void startAct(Context context, PreviewInfo previewInfo) {
        if (context != null) {
            Intent intent = new Intent(context, (Class<?>) PreviewActivity.class);
            intent.putExtra(IntentValues.PREVIEW_INFO, previewInfo);
            context.startActivity(intent);
        }
    }

    public static void startAct(Fragment fragment, PreviewInfo previewInfo) {
        if (fragment != null) {
            Intent intent = new Intent(fragment.getContext(), (Class<?>) PreviewActivity.class);
            intent.putExtra(IntentValues.PREVIEW_INFO, previewInfo);
            if (previewInfo.isPicking()) {
                fragment.startActivityForResult(intent, 1002);
            } else {
                fragment.startActivity(intent);
            }
        }
    }

    @Override
    protected void onCreate(Bundle bundle) {
        int i = CustomConfig.CommonSetting.screenOrientation;
        if (i == 1) {
            setRequestedOrientation(6);
        } else if (i == 2) {
            setRequestedOrientation(1);
        } else if (i == 3) {
            setRequestedOrientation(-1);
        }
        super.onCreate(bundle);
    }

    @Override
    public void initView() {
        PreviewInfo previewInfo = (PreviewInfo) getIntent().getSerializableExtra(IntentValues.PREVIEW_INFO);
        if (PreviewHelper.prepare(this, previewInfo)) {
            if (previewInfo.isImageFile()) {
                ImagePreviewer.previewImage(this, previewInfo);
            } else if (previewInfo.isVideoFile()) {
                VideoPreviewer.previewVideo(this, previewInfo);
            } else {
                FilePreviewer.previewFile(this, previewInfo);
            }
        }
    }

    @Override
    public void onConfigurationChanged(Configuration configuration) {
        super.onConfigurationChanged(configuration);
        if (CustomConfig.CommonSetting.screenOrientation == 3) {
            CustomConfig.CommonSetting.isLandscape = configuration.orientation == 2;
            setContentView(ResResolver.getLayoutId("aihelp_act_preview"));
            initView();
        }
    }

    @Override
    public int getLayoutId() {
        return ResResolver.getLayoutId("aihelp_act_preview");
    }
}
