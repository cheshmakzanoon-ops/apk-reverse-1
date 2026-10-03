package net.aihelp.p007ui.widget;

import android.animation.LayoutTransition;
import android.app.Activity;
import android.content.Context;
import android.content.res.TypedArray;
import android.util.AttributeSet;
import android.view.View;
import android.view.ViewGroup;
import android.widget.FrameLayout;
import android.widget.ImageView;
import androidx.appcompat.content.res.AppCompatResources;
import androidx.appcompat.widget.AppCompatImageView;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.loading.indicator.LoadingIndicatorView;
import net.aihelp.data.model.rpa.msg.FileMessage;
import net.aihelp.utils.DomainSupportHelper;
import net.aihelp.utils.MediaUtils;
import net.aihelp.utils.ResResolver;
import net.aihelp.utils.Styles;

public class AIHelpLoadingImageView extends FrameLayout {
    private AppCompatImageView imageView;
    private boolean isLoading;
    private boolean isVideo;
    private AppCompatImageView ivPlay;
    private LoadingIndicatorView loadingView;
    private View maskView;

    public boolean isLoading() {
        return this.isLoading;
    }

    public void setLoading(boolean z) {
        this.isLoading = z;
    }

    public boolean isVideo() {
        return this.isVideo;
    }

    public void setVideo(boolean z) {
        this.isVideo = z;
    }

    public AppCompatImageView getRealImageView() {
        return this.imageView;
    }

    public AIHelpLoadingImageView(Context context) {
        super(context);
    }

    public AIHelpLoadingImageView(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        getAttributes(context, attributeSet);
        init(context);
    }

    public AIHelpLoadingImageView(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        getAttributes(context, attributeSet);
        init(context);
    }

    private void getAttributes(Context context, AttributeSet attributeSet) {
        int[] styleable = ResResolver.getStyleable("aihelp_widget");
        if (styleable != null) {
            TypedArray typedArrayObtainStyledAttributes = context.getTheme().obtainStyledAttributes(attributeSet, styleable, 0, 0);
            this.isVideo = typedArrayObtainStyledAttributes.getBoolean(ResResolver.getStyleableFieldIndex("aihelp_widget", "aihelp_widget_is_video"), false);
            typedArrayObtainStyledAttributes.recycle();
        }
    }

    private void init(Context context) {
        setLayoutTransition(new LayoutTransition());
        setBackground(AppCompatResources.getDrawable(context, ResResolver.getDrawableId("aihelp_bg_uploading_mask")));
        setForegroundGravity(17);
        View viewInflate = inflate(context, ResResolver.getLayoutId("aihelp_loading_image_view"), this);
        this.imageView = viewInflate.findViewById(ResResolver.getViewId("aihelp_image_view"));
        this.ivPlay = viewInflate.findViewById(ResResolver.getViewId("aihelp_iv_play"));
        this.maskView = viewInflate.findViewById(ResResolver.getViewId("aihelp_v_mask"));
        this.loadingView = (LoadingIndicatorView) viewInflate.findViewById(ResResolver.getViewId("aihelp_loading_view"));
        updateLoadingStatus(true);
    }

    public void resetStatus() {
        ViewGroup.LayoutParams layoutParams = getLayoutParams();
        layoutParams.width = Styles.dpToPx(getContext(), 100.0f);
        layoutParams.height = Styles.dpToPx(getContext(), 150.0f);
        setLayoutParams(layoutParams);
        updateLoadingStatus(true);
    }

    public void updateLoadingStatus(boolean z) {
        this.maskView.setVisibility(z ? 0 : 8);
        this.loadingView.setVisibility(z ? 0 : 8);
        if (this.isVideo) {
            this.ivPlay.setVisibility(z ? 8 : 0);
        }
        setLoading(z);
    }

    public void loadIntoImageView(Context context, final FileMessage fileMessage) {
        if (!(context instanceof Activity) || ((Activity) context).isFinishing()) {
            return;
        }
        String adjustedUrl = DomainSupportHelper.getAdjustedUrl(this.isVideo ? fileMessage.getVideoThumbnail() : fileMessage.getContent());
        if (fileMessage.getImageSize() != null) {
            Glide.with(getContext()).load(adjustedUrl).into((ImageView) this.imageView);
            ViewGroup.LayoutParams layoutParams = getLayoutParams();
            ViewGroup.LayoutParams layoutParams2 = this.imageView.getLayoutParams();
            int i = fileMessage.getImageSize()[0];
            layoutParams2.width = i;
            layoutParams.width = i;
            int i2 = fileMessage.getImageSize()[1];
            layoutParams2.height = i2;
            layoutParams.height = i2;
            setLayoutParams(layoutParams);
            this.imageView.setLayoutParams(layoutParams2);
            updateLoadingStatus(false);
            return;
        }
        resetStatus();
        MediaUtils.scaleImageView(adjustedUrl, this.imageView, this, new MediaUtils.OnImageScaledListener() {
            @Override
            public void onImageScaled() {
                if (fileMessage.getImageSize() == null) {
                    ViewGroup.LayoutParams layoutParams3 = AIHelpLoadingImageView.this.getLayoutParams();
                    fileMessage.setImageSize(new int[]{layoutParams3.width, layoutParams3.height});
                }
                AIHelpLoadingImageView.this.updateLoadingStatus(false);
            }
        });
    }

    public int dip2px(Context context, double d) {
        return (int) ((d * ((double) context.getResources().getDisplayMetrics().density)) + 0.5d);
    }

    public void showPlayButton(boolean z) {
        this.ivPlay.setVisibility(z ? 0 : 8);
    }
}
