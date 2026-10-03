package net.aihelp.p007ui.preview.util;

import android.app.Activity;
import android.graphics.Color;
import android.view.View;
import android.widget.ImageView;
import android.widget.RelativeLayout;
import net.aihelp.p007ui.preview.data.PreviewInfo;
import net.aihelp.p007ui.widget.AIHelpButton;
import net.aihelp.p007ui.widget.CircleProgressView;
import net.aihelp.utils.AppInfoUtil;
import net.aihelp.utils.DownloadHelper;
import net.aihelp.utils.RegexDefinition;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class PreviewHelper {
    public static boolean prepare(Activity activity, PreviewInfo previewInfo) {
        if (activity == null) {
            return false;
        }
        if (previewInfo == null) {
            activity.setResult(0, activity.getIntent());
            activity.finish();
            return false;
        }
        prepareThemeApply(activity, previewInfo);
        prepareButtonUI(activity, previewInfo);
        prepareDownloadUI(activity, previewInfo);
        prepareOpenInBrowserUI(activity, previewInfo);
        return true;
    }

    private static void prepareThemeApply(Activity activity, PreviewInfo previewInfo) {
        boolean z = previewInfo.isMediaFile() || Styles.isNightMode(activity);
        activity.getWindow().clearFlags(67108864);
        activity.getWindow().addFlags(Integer.MIN_VALUE);
        activity.getWindow().setStatusBarColor(z ? -16777216 : -1);
        activity.getWindow().getDecorView().setSystemUiVisibility(z ? 0 : 8192);
        ((RelativeLayout) activity.findViewById(ResResolver.getViewId("aihelp_rl_preview_title"))).setBackgroundColor(z ? -16777216 : -1);
        ((RelativeLayout) activity.findViewById(ResResolver.getViewId("aihelp_rl_preview_content"))).setBackgroundColor(z ? -16777216 : -1);
    }

    private static void prepareButtonUI(final Activity activity, PreviewInfo previewInfo) {
        ImageView imageView = (ImageView) activity.findViewById(ResResolver.getViewId("aihelp_iv_back"));
        Styles.reRenderImageView(imageView, "aihelp_svg_ic_back", true);
        imageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Activity activity2 = activity;
                activity2.setResult(0, activity2.getIntent());
                activity.finish();
            }
        });
        AIHelpButton aIHelpButton = (AIHelpButton) activity.findViewById(ResResolver.getViewId("aihelp_btn_confirm"));
        aIHelpButton.setVisibility(previewInfo.isPicking() ? 0 : 8);
        aIHelpButton.setText(ResResolver.getString("aihelp_yes"));
        aIHelpButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                Activity activity2 = activity;
                activity2.setResult(-1, activity2.getIntent());
                activity.finish();
            }
        });
    }

    private static void prepareDownloadUI(final Activity activity, final PreviewInfo previewInfo) {
        final CircleProgressView circleProgressView = (CircleProgressView) activity.findViewById(ResResolver.getViewId("aihelp_progress_view"));
        final ImageView imageView = (ImageView) activity.findViewById(ResResolver.getViewId("aihelp_iv_download"));
        imageView.setVisibility((RegexDefinition.isLocalMediaFile(previewInfo.getFilePath()) || previewInfo.isPicking() || !previewInfo.isMediaFile()) ? 8 : 0);
        imageView.setBackground(Styles.getDrawable(Color.parseColor("#3F3F3F"), 999));
        Styles.reRenderImageView(imageView, "aihelp_svg_ic_download", -1, true);
        imageView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (AppInfoUtil.validateNetwork(activity)) {
                    imageView.setEnabled(false);
                    DownloadHelper.save(activity, previewInfo.getFilePath(), new DownloadHelper.OnDownloadProgressChangedListener() {
                        @Override
                        public void onProgressChanged(int i) {
                            imageView.setEnabled(i == 100);
                            if (previewInfo.isVideoFile()) {
                                if (i < 100) {
                                    circleProgressView.setVisibility(0);
                                    circleProgressView.setCurrentStep(i);
                                } else {
                                    circleProgressView.setVisibility(8);
                                }
                            }
                        }
                    });
                }
            }
        });
    }

    private static void prepareOpenInBrowserUI(final Activity activity, final PreviewInfo previewInfo) {
        AIHelpButton aIHelpButton = (AIHelpButton) activity.findViewById(ResResolver.getViewId("aihelp_btn_open"));
        aIHelpButton.setText(ResResolver.getString("aihelp_open_browser"));
        aIHelpButton.setVisibility((RegexDefinition.isLocalFile(previewInfo.getFilePath()) || previewInfo.isPicking()) ? 8 : 0);
        aIHelpButton.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                AppInfoUtil.openWithBrowser(activity, previewInfo.getFilePath());
            }
        });
    }
}
