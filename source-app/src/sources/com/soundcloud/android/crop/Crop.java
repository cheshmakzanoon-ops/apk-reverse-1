package com.soundcloud.android.crop;

import android.app.Activity;
import android.app.Fragment;
import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.os.Build;
import android.widget.Toast;
import com.head.TakePhotoController;
import com.sdkmanager.SdkManager;

public class Crop {
    public static final int REQUEST_CROP = 6709;
    public static final int REQUEST_MULTI_PICK = 9300;
    public static final int REQUEST_PICK = 9162;
    public static final int REQUEST_SINGLE_PICK = 9200;
    public static final int RESULT_ERROR = 404;
    private Intent cropIntent;

    interface Extra {
        public static final String ASPECT_X = "aspect_x";
        public static final String ASPECT_Y = "aspect_y";
        public static final String ERROR = "error";
        public static final String MAX_X = "max_x";
        public static final String MAX_Y = "max_y";
    }

    public static Crop m438of(Uri uri, Uri uri2) {
        return new Crop(uri, uri2);
    }

    private Crop(Uri uri, Uri uri2) {
        Intent intent = new Intent();
        this.cropIntent = intent;
        intent.setData(uri);
        this.cropIntent.putExtra("output", uri2);
    }

    public Crop withAspect(int i, int i2) {
        this.cropIntent.putExtra(Extra.ASPECT_X, i);
        this.cropIntent.putExtra(Extra.ASPECT_Y, i2);
        return this;
    }

    public Crop asSquare() {
        this.cropIntent.putExtra(Extra.ASPECT_X, 1);
        this.cropIntent.putExtra(Extra.ASPECT_Y, 1);
        return this;
    }

    public Crop withMaxSize(int i, int i2) {
        this.cropIntent.putExtra(Extra.MAX_X, i);
        this.cropIntent.putExtra(Extra.MAX_Y, i2);
        return this;
    }

    public void start(Activity activity) {
        start(activity, REQUEST_CROP);
    }

    public void start(Activity activity, int i) {
        activity.startActivityForResult(getIntent(activity), i);
    }

    public void start(Context context, Fragment fragment) {
        start(context, fragment, REQUEST_CROP);
    }

    public void start(Context context, androidx.fragment.app.Fragment fragment) {
        start(context, fragment, REQUEST_CROP);
    }

    public void start(Context context, Fragment fragment, int i) {
        fragment.startActivityForResult(getIntent(context), i);
    }

    public void start(Context context, androidx.fragment.app.Fragment fragment, int i) {
        fragment.startActivityForResult(getIntent(context), i);
    }

    public Intent getIntent(Context context) {
        this.cropIntent.setClass(context, CropImageActivity.class);
        return this.cropIntent;
    }

    public static Uri getOutput(Intent intent) {
        return (Uri) intent.getParcelableExtra("output");
    }

    public static Throwable getError(Intent intent) {
        return (Throwable) intent.getSerializableExtra("error");
    }

    public static void pickImage(Activity activity) {
        pickImage(activity, REQUEST_PICK);
    }

    public static void pickSingleImage(Activity activity) {
        pickSingleImage(activity, REQUEST_SINGLE_PICK);
    }

    public static void pickleImages(Activity activity, int i) {
        pickleImages(activity, REQUEST_MULTI_PICK, i);
    }

    public static void pickImage(Context context, Fragment fragment) {
        pickImage(context, fragment, REQUEST_PICK);
    }

    public static void pickImage(Context context, androidx.fragment.app.Fragment fragment) {
        pickImage(context, fragment, REQUEST_PICK);
    }

    public static void pickImage(Activity activity, int i) {
        try {
            activity.startActivityForResult(getImagePicker(), i);
        } catch (ActivityNotFoundException e) {
            showImagePickerError(activity);
            SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::showPicturePickerByCrop 打开最近使用文件失败: , e:" + e.getMessage());
        }
    }

    public static void pickSingleImage(Activity activity, int i) {
        try {
            activity.startActivityForResult(getImagePicker(), i);
        } catch (ActivityNotFoundException e) {
            showImagePickerError(activity);
            SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::ShowSinglePicturePicker 打开最近使用文件失败: , e:" + e.getMessage());
        }
    }

    public static void pickleImages(Activity activity, int i, int i2) {
        try {
            if (Build.VERSION.SDK_INT >= 33) {
                Intent intent = new Intent("android.provider.action.PICK_IMAGES");
                intent.putExtra("android.provider.extra.PICK_IMAGES_MAX", i2);
                activity.startActivityForResult(intent, i);
            } else {
                Intent intent2 = new Intent("android.intent.action.GET_CONTENT");
                intent2.setType(TakePhotoController.IMAGE_UNSPECIFIED);
                intent2.putExtra("android.intent.extra.ALLOW_MULTIPLE", true);
                intent2.putExtra("max_select_count", i2);
                intent2.putExtra("android.intent.extra.LIMIT", i2);
                activity.startActivityForResult(intent2, i);
            }
        } catch (ActivityNotFoundException unused) {
            showImagePickerError(activity);
        }
    }

    public static void pickImage(Context context, Fragment fragment, int i) {
        try {
            fragment.startActivityForResult(getImagePicker(), i);
        } catch (ActivityNotFoundException unused) {
            showImagePickerError(context);
        }
    }

    public static void pickImage(Context context, androidx.fragment.app.Fragment fragment, int i) {
        try {
            fragment.startActivityForResult(getImagePicker(), i);
        } catch (ActivityNotFoundException unused) {
            showImagePickerError(context);
        }
    }

    private static Intent getImagePicker() {
        return new Intent("android.intent.action.GET_CONTENT").setType(TakePhotoController.IMAGE_UNSPECIFIED);
    }

    private static void showImagePickerError(Context context) {
        Toast.makeText(context, "No image sources available", 0).show();
    }
}
