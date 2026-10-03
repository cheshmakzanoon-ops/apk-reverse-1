package net.aihelp.core.util.viewer;

import android.content.Context;
import android.graphics.Color;
import android.media.MediaPlayer;
import android.text.TextUtils;
import android.util.AttributeSet;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.RelativeLayout;
import android.widget.VideoView;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.load.resource.drawable.GlideDrawable;
import net.aihelp.core.p004ui.glide.request.RequestListener;
import net.aihelp.core.p004ui.glide.request.target.Target;
import net.aihelp.p007ui.widget.AIHelpButton;
import net.aihelp.utils.DomainSupportHelper;
import net.aihelp.utils.ResResolver;

public class ViewerLayout extends RelativeLayout {
    private String imagePath;
    private PhotoView imageView;
    private IOnUserActionResultListener listener;
    private ProgressBar progressBar;
    private View rootView;
    private String videoPath;
    private VideoView videoView;

    public ViewerLayout(Context context) {
        super(context);
        init(context);
    }

    public ViewerLayout(Context context, AttributeSet attributeSet) {
        super(context, attributeSet);
        init(context);
    }

    public ViewerLayout(Context context, AttributeSet attributeSet, int i) {
        super(context, attributeSet, i);
        init(context);
    }

    private void init(Context context) {
        this.rootView = LayoutInflater.from(context).inflate(ResResolver.getLayoutId("aihelp_dialog_media_viewer"), this);
        setGravity(17);
        setBackgroundColor(getBackgroundColorByAlpha(255.0f));
        ((AIHelpButton) this.rootView.findViewById(ResResolver.getViewId("aihelp_tv_cancel"))).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (ViewerLayout.this.listener != null) {
                    ViewerLayout.this.listener.onCancel();
                }
            }
        });
        ((AIHelpButton) this.rootView.findViewById(ResResolver.getViewId("aihelp_tv_confirm"))).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                if (ViewerLayout.this.listener != null) {
                    ViewerLayout.this.listener.onConfirm(ViewerLayout.this.imagePath);
                }
            }
        });
        this.imageView = (PhotoView) this.rootView.findViewById(ResResolver.getViewId("aihelp_image_view"));
        VideoView videoView = (VideoView) this.rootView.findViewById(ResResolver.getViewId("aihelp_video_view"));
        this.videoView = videoView;
        videoView.setBackgroundColor(-16777216);
        this.progressBar = (ProgressBar) this.rootView.findViewById(ResResolver.getViewId("aihelp_progress_bar"));
        this.videoView.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
            @Override
            public void onPrepared(MediaPlayer mediaPlayer) {
                ViewerLayout.this.videoView.start();
                mediaPlayer.setLooping(true);
            }

            class AnonymousClass1 implements Runnable {
                AnonymousClass1() {
                }

                @Override
                public void run() {
                    ViewerLayout.this.finishVideoBuffer();
                }
            }
        });
        this.videoView.setOnInfoListener(new MediaPlayer.OnInfoListener() {
            @Override
            public boolean onInfo(MediaPlayer mediaPlayer, int i, int i2) {
                if (i != 3) {
                    return false;
                }
                ViewerLayout.this.finishVideoBuffer();
                return true;
            }
        });
    }

    public void finishVideoBuffer() {
        this.videoView.seekTo(0);
        this.progressBar.setVisibility(8);
        this.imageView.setVisibility(8);
        this.videoView.setBackgroundColor(0);
    }

    public void show() {
        if (TextUtils.isEmpty(this.imagePath)) {
            return;
        }
        if (!TextUtils.isEmpty(this.videoPath)) {
            this.imageView.enableGesture(false);
            this.videoView.setVisibility(0);
            this.videoView.setVideoPath(this.videoPath);
        } else {
            this.videoView.setVisibility(8);
        }
        Glide.with(getContext()).load(this.imagePath).listener((RequestListener<? super String, GlideDrawable>) new RequestListener<String, GlideDrawable>() {
            @Override
            public boolean onException(Exception exc, String str, Target<GlideDrawable> target, boolean z) {
                if (!TextUtils.isEmpty(ViewerLayout.this.videoPath)) {
                    return false;
                }
                ViewerLayout.this.progressBar.setVisibility(8);
                return false;
            }

            @Override
            public boolean onResourceReady(GlideDrawable glideDrawable, String str, Target<GlideDrawable> target, boolean z, boolean z2) {
                if (!TextUtils.isEmpty(ViewerLayout.this.videoPath)) {
                    return false;
                }
                ViewerLayout.this.progressBar.setVisibility(8);
                return false;
            }
        }).into((ImageView) this.imageView);
    }

    int getBackgroundColorByAlpha(float f) {
        return Color.argb(Math.round(f), Color.red(-16777216), Color.green(-16777216), Color.blue(-16777216));
    }

    public void updateImageResource(String str) {
        this.imagePath = DomainSupportHelper.getAdjustedUrl(str);
    }

    public void updateVideoResource(String str) {
        this.videoPath = DomainSupportHelper.getAdjustedUrl(str);
    }

    public void setOnChildViewClickedListener(View.OnClickListener onClickListener) {
        View view = this.rootView;
        if (view != null) {
            view.setOnClickListener(onClickListener);
        }
        PhotoView photoView = this.imageView;
        if (photoView != null) {
            photoView.setOnClickListener(onClickListener);
        }
    }

    public void setOnUserActionResultListener(IOnUserActionResultListener iOnUserActionResultListener) {
        this.listener = iOnUserActionResultListener;
    }
}
