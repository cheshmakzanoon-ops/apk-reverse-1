package net.aihelp.p007ui.preview.viewer;

import android.app.Activity;
import android.content.res.ColorStateList;
import android.media.MediaPlayer;
import android.widget.ImageView;
import android.widget.ProgressBar;
import android.widget.VideoView;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.load.resource.drawable.GlideDrawable;
import net.aihelp.core.p004ui.glide.request.RequestListener;
import net.aihelp.core.p004ui.glide.request.target.Target;
import net.aihelp.core.util.viewer.PhotoView;
import net.aihelp.p007ui.preview.data.PreviewInfo;
import net.aihelp.utils.MediaUtils;
import net.aihelp.utils.ResResolver;

public class VideoPreviewer extends BasePreviewer {
    public static void previewVideo(Activity activity, PreviewInfo previewInfo) {
        if (activity == null || previewInfo == null || isFileSizeExceeded(activity, previewInfo)) {
            return;
        }
        final ?? r0 = (PhotoView) activity.findViewById(ResResolver.getViewId("aihelp_image_view"));
        final ProgressBar progressBar = (ProgressBar) activity.findViewById(ResResolver.getViewId("aihelp_progress_bar"));
        final VideoView videoView = (VideoView) activity.findViewById(ResResolver.getViewId("aihelp_video_view"));
        r0.enableGesture(false);
        r0.setVisibility(0);
        progressBar.setVisibility(0);
        progressBar.setIndeterminateTintList(ColorStateList.valueOf(-1));
        videoView.setBackgroundColor(0);
        videoView.setOnPreparedListener(new MediaPlayer.OnPreparedListener() {
            @Override
            public void onPrepared(MediaPlayer mediaPlayer) {
                videoView.start();
                mediaPlayer.setLooping(true);
            }

            class AnonymousClass1 implements Runnable {
                AnonymousClass1() {
                }

                @Override
                public void run() {
                    videoView.seekTo(0);
                    progressBar.setVisibility(8);
                    r0.setVisibility(8);
                    videoView.setVisibility(0);
                }
            }
        });
        videoView.setOnInfoListener(new MediaPlayer.OnInfoListener() {
            @Override
            public boolean onInfo(MediaPlayer mediaPlayer, int i, int i2) {
                if (i != 3) {
                    return false;
                }
                videoView.seekTo(0);
                progressBar.setVisibility(8);
                r0.setVisibility(8);
                videoView.setVisibility(0);
                return true;
            }
        });
        String imageForVideoSync = MediaUtils.getImageForVideoSync(previewInfo.getFilePath());
        videoView.setVideoPath(previewInfo.getFilePath());
        Glide.with(activity).load(imageForVideoSync).listener((RequestListener<? super String, GlideDrawable>) new RequestListener<String, GlideDrawable>() {
            @Override
            public boolean onException(Exception exc, String str, Target<GlideDrawable> target, boolean z) {
                progressBar.setVisibility(0);
                return false;
            }

            @Override
            public boolean onResourceReady(GlideDrawable glideDrawable, String str, Target<GlideDrawable> target, boolean z, boolean z2) {
                progressBar.post(new Runnable() {
                    @Override
                    public void run() {
                        videoView.setVisibility(0);
                    }
                });
                return false;
            }
        }).into((ImageView) r0);
    }
}
