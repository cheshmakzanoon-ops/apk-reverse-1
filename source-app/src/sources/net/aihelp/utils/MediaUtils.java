package net.aihelp.utils;

import android.content.Context;
import android.graphics.Bitmap;
import android.media.MediaMetadataRetriever;
import android.os.AsyncTask;
import android.text.TextUtils;
import android.view.View;
import android.view.ViewGroup;
import android.widget.ImageView;
import java.io.File;
import java.io.FileOutputStream;
import java.util.HashMap;
import net.aihelp.config.AIHelpContext;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.request.animation.GlideAnimation;
import net.aihelp.core.p004ui.glide.request.target.SimpleTarget;
import net.aihelp.p007ui.helper.BitmapHelper;
import zendesk.messaging.android.internal.AttachmentFileResolver;

public class MediaUtils {
    public static final int MEDIA_TYPE_IMAGE = 1;
    public static final int MEDIA_TYPE_VIDEO = 2;

    public interface OnImageScaledListener {
        void onImageScaled();
    }

    public interface OnLoadVideoImageListener {
        void onLoadImage(File file);
    }

    public static void scaleImageView(String str, final ImageView imageView, final View view, final OnImageScaledListener onImageScaledListener) {
        if (imageView == null || view == null || TextUtils.isEmpty(str)) {
            return;
        }
        final String adjustedUrl = DomainSupportHelper.getAdjustedUrl(str);
        final Context context = imageView.getContext();
        Glide.with(context).load(adjustedUrl).asBitmap().into(new SimpleTarget<Bitmap>() {
            @Override
            public void onResourceReady(Object obj, GlideAnimation glideAnimation) {
                onResourceReady((Bitmap) obj, (GlideAnimation<? super Bitmap>) glideAnimation);
            }

            public void onResourceReady(Bitmap bitmap, GlideAnimation<? super Bitmap> glideAnimation) {
                Glide.with(context).load(adjustedUrl).into(imageView);
                ViewGroup.LayoutParams layoutParams = view.getLayoutParams();
                int[] iArrComputeSize = BitmapHelper.computeSize(bitmap.getWidth(), bitmap.getHeight());
                layoutParams.width = Math.max(iArrComputeSize[0], Styles.dpToPx(context, 50.0f));
                layoutParams.height = Math.max(iArrComputeSize[1], Styles.dpToPx(context, 50.0f));
                view.setLayoutParams(layoutParams);
                OnImageScaledListener onImageScaledListener2 = onImageScaledListener;
                if (onImageScaledListener2 != null) {
                    onImageScaledListener2.onImageScaled();
                }
            }
        });
    }

    public static File getOutputMediaFile(String str) {
        Context context = AIHelpContext.getInstance().getContext();
        if (context == null) {
            return null;
        }
        File file = new File(context.getExternalCacheDir() + "/aihelp/image");
        if (!file.exists() && !file.mkdirs()) {
            return null;
        }
        String str2 = "IMG_" + System.currentTimeMillis() + AttachmentFileResolver.TEMP_FILE_SUFFIX;
        if (!TextUtils.isEmpty(str)) {
            int iLastIndexOf = str.lastIndexOf("/");
            int iLastIndexOf2 = str.lastIndexOf(".");
            if (iLastIndexOf != -1 && iLastIndexOf2 != -1 && iLastIndexOf < iLastIndexOf2) {
                str2 = str.substring(iLastIndexOf + 1, iLastIndexOf2) + AttachmentFileResolver.TEMP_FILE_SUFFIX;
            }
        }
        return new File(file.getPath() + File.separator + str2);
    }

    public static void getImageForVideo(String str, OnLoadVideoImageListener onLoadVideoImageListener) {
        new LoadVideoImageTask(onLoadVideoImageListener).execute(str);
    }

    public static String getImageForVideoSync(String str) {
        File videoThumbnail = getVideoThumbnail(str);
        return videoThumbnail != null ? videoThumbnail.getAbsolutePath() : "";
    }

    public static class LoadVideoImageTask extends AsyncTask<String, Integer, File> {
        private OnLoadVideoImageListener listener;

        public LoadVideoImageTask(OnLoadVideoImageListener onLoadVideoImageListener) {
            this.listener = onLoadVideoImageListener;
        }

        @Override
        public File doInBackground(String... strArr) {
            return MediaUtils.getVideoThumbnail(strArr[0]);
        }

        @Override
        public void onPostExecute(File file) {
            super.onPostExecute(file);
            OnLoadVideoImageListener onLoadVideoImageListener = this.listener;
            if (onLoadVideoImageListener != null) {
                onLoadVideoImageListener.onLoadImage(file);
            }
        }
    }

    public static File getVideoThumbnail(String str) {
        try {
            File outputMediaFile = getOutputMediaFile(str);
            if (outputMediaFile != null && outputMediaFile.exists()) {
                return outputMediaFile;
            }
            MediaMetadataRetriever mediaMetadataRetriever = new MediaMetadataRetriever();
            if (RegexDefinition.isLocalMediaFile(str)) {
                mediaMetadataRetriever.setDataSource(str);
            } else {
                mediaMetadataRetriever.setDataSource(str, new HashMap());
            }
            Bitmap frameAtTime = mediaMetadataRetriever.getFrameAtTime();
            if (outputMediaFile != null) {
                try {
                    FileOutputStream fileOutputStream = new FileOutputStream(outputMediaFile);
                    frameAtTime.compress(Bitmap.CompressFormat.JPEG, 90, fileOutputStream);
                    fileOutputStream.flush();
                    fileOutputStream.close();
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
            mediaMetadataRetriever.release();
            return outputMediaFile;
        } catch (Exception unused) {
            return new File(str);
        }
    }
}
