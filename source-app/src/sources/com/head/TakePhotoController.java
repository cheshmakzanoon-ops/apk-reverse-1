package com.head;

import android.app.Activity;
import android.content.ContentValues;
import android.content.Context;
import android.content.Intent;
import android.content.pm.ResolveInfo;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Matrix;
import android.net.Uri;
import android.os.Build;
import android.os.Environment;
import android.os.StrictMode;
import android.provider.MediaStore;
import android.text.TextUtils;
import android.util.Log;
import androidx.core.app.ActivityCompat;
import androidx.core.content.FileProvider;
import com.example.updateandinstall.SpUtils;
import com.sdkmanager.AppUtilManager;
import com.sdkmanager.SdkManager;
import com.sdkmanager.utils.Udid$$ExternalSyntheticApiModelOutline0;
import com.soundcloud.android.crop.Crop;
import com.yalantis.ucrop.UCrop;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Iterator;
import java.util.List;
import org.json.JSONObject;

public class TakePhotoController {
    public static final int CHOOSE_PICTURE = 7201;
    public static final int CLIP_CHOOSED_PICTURE = 7203;
    public static final int CLIP_TAKEN_PICTURE = 7202;
    private static String CacheKey_Albumn = "deny_albumn";
    private static String CacheKey_Camera = "deny_camera";
    public static final String IMAGE_UNSPECIFIED = "image/*";
    private static volatile TakePhotoController Instance = null;
    public static final int PERMISSION_CAMERA = 2;
    public static final int TAKE_PICTURE = 7200;
    public static final int WRITE_EXTERNAL_STORAGE_REQUEST_CODE = 1;
    private static String gameUid = "";
    private static int index = -1;
    public static int photoFileSizeLimit = -1;
    public static int photoMultiPickNum = 0;
    public static int photoResolutionLimit = -1;
    private static final int showPicturePicker1Button = 1;
    private static final int showPicturePicker2Button = 2;
    public static float suitableResolutionSizeBig = -1.0f;
    public static float suitableResolutionSizeSmall = -1.0f;
    private static int temp_idx = 0;
    private static String temp_uid = "";
    private static int whichButtonRequestPermission;
    private Activity mActivity;
    private Uri uritempFile;

    public static TakePhotoController getInstance() {
        if (Instance == null) {
            synchronized (TakePhotoController.class) {
                if (Instance == null) {
                    Instance = new TakePhotoController();
                }
            }
        }
        return Instance;
    }

    public void init(Activity activity) {
        this.mActivity = activity;
    }

    public Activity getCurActivity() {
        return this.mActivity;
    }

    private boolean checkCameraHardware() {
        return this.mActivity.getPackageManager().hasSystemFeature("android.hardware.camera");
    }

    public String GetCurPermission(int i) {
        boolean zBooleanValue;
        if (i != 0 ? ActivityCompat.checkSelfPermission(this.mActivity, "android.permission.WRITE_EXTERNAL_STORAGE") == 0 : ActivityCompat.checkSelfPermission(this.mActivity, "android.permission.CAMERA") == 0) {
            SpUtils.getInstance(this.mActivity).putBoolean(CacheKey_Camera, false);
            SpUtils.getInstance(this.mActivity).putBoolean(CacheKey_Albumn, false);
            return "1";
        }
        if (i == 0) {
            zBooleanValue = SpUtils.getInstance(this.mActivity).getBoolean(CacheKey_Camera, false).booleanValue();
        } else {
            zBooleanValue = SpUtils.getInstance(this.mActivity).getBoolean(CacheKey_Albumn, false).booleanValue();
        }
        if (zBooleanValue) {
            return "3";
        }
        return "2";
    }

    public void showPicturePicker1(String str, int i) {
        if (Build.VERSION.SDK_INT >= 24) {
            try {
                StrictMode.class.getMethod("disableDeathOnFileUriExposure", null).invoke(null, null);
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
        if (Build.VERSION.SDK_INT >= 30 && ActivityCompat.checkSelfPermission(this.mActivity, "android.permission.CAMERA") != 0) {
            temp_uid = str;
            temp_idx = i;
            whichButtonRequestPermission = 1;
            ActivityCompat.requestPermissions(this.mActivity, new String[]{"android.permission.CAMERA"}, 2);
            return;
        }
        if (Build.VERSION.SDK_INT < 30 && (ActivityCompat.checkSelfPermission(this.mActivity, "android.permission.WRITE_EXTERNAL_STORAGE") != 0 || ActivityCompat.checkSelfPermission(this.mActivity, "android.permission.CAMERA") != 0)) {
            temp_uid = str;
            temp_idx = i;
            whichButtonRequestPermission = 1;
            ActivityCompat.requestPermissions(this.mActivity, new String[]{"android.permission.WRITE_EXTERNAL_STORAGE", "android.permission.CAMERA"}, 1);
            return;
        }
        if (checkCameraHardware()) {
            gameUid = str;
            index = i;
            Intent intent = new Intent("android.media.action.IMAGE_CAPTURE");
            if (Build.VERSION.SDK_INT >= 29) {
                ContentValues contentValues = new ContentValues();
                contentValues.put("relative_path", Environment.DIRECTORY_PICTURES);
                contentValues.put("_display_name", GetCaptureImageName());
                contentValues.put("mime_type", "image/jpeg");
                this.uritempFile = getCurActivity().getContentResolver().insert(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, contentValues);
            } else if (Build.VERSION.SDK_INT >= 24) {
                this.uritempFile = FileProvider.getUriForFile(getCurActivity(), getCurActivity().getPackageName().concat(".provider"), new File(getCurActivity().getFilesDir(), GetCaptureImageName()));
                intent.addFlags(3);
            } else {
                this.uritempFile = Uri.fromFile(new File(getCurActivity().getExternalCacheDir().getAbsolutePath(), GetCaptureImageName()));
            }
            intent.putExtra("output", this.uritempFile);
            getCurActivity().startActivityForResult(intent, TAKE_PICTURE);
            return;
        }
        showPicturePicker2(str, i);
    }

    public String GetCaptureImageName() {
        return "lf_photoimage";
    }

    public String GetPhotoCache() {
        return AppUtilManager.getInstance().getExternalDir() + "/lf_photoimage.jpg";
    }

    public void showPicturePicker2(String str, int i) {
        if (Build.VERSION.SDK_INT >= 30 && ActivityCompat.checkSelfPermission(this.mActivity, "android.permission.WRITE_EXTERNAL_STORAGE") != 0) {
            temp_uid = str;
            temp_idx = i;
            whichButtonRequestPermission = 2;
            ActivityCompat.requestPermissions(this.mActivity, new String[]{"android.permission.WRITE_EXTERNAL_STORAGE"}, 1);
            return;
        }
        if (ActivityCompat.checkSelfPermission(this.mActivity, "android.permission.WRITE_EXTERNAL_STORAGE") != 0) {
            temp_uid = str;
            temp_idx = i;
            whichButtonRequestPermission = 2;
            ActivityCompat.requestPermissions(this.mActivity, new String[]{"android.permission.WRITE_EXTERNAL_STORAGE"}, 1);
            return;
        }
        gameUid = str;
        index = i;
        Intent intent = new Intent("android.intent.action.PICK", MediaStore.Images.Media.EXTERNAL_CONTENT_URI);
        intent.setDataAndType(MediaStore.Images.Media.EXTERNAL_CONTENT_URI, IMAGE_UNSPECIFIED);
        this.mActivity.startActivityForResult(intent, CHOOSE_PICTURE);
    }

    public void showPicturePickerByCrop(String str, int i) {
        temp_uid = str;
        temp_idx = i;
        gameUid = str;
        index = i;
        Crop.pickImage(this.mActivity);
    }

    public void ShowSinglePicturePicker(int i, int i2, int i3, int i4) {
        photoResolutionLimit = i;
        photoFileSizeLimit = i2;
        suitableResolutionSizeBig = i3;
        suitableResolutionSizeSmall = i4;
        Crop.pickSingleImage(this.mActivity);
    }

    public void showPicturePickerSelectNum(int i, int i2, int i3, int i4, int i5) {
        photoResolutionLimit = i;
        photoFileSizeLimit = i2;
        suitableResolutionSizeBig = i3;
        suitableResolutionSizeSmall = i4;
        Crop.pickleImages(this.mActivity, i5);
    }

    private void startCrop(Uri uri) {
        if (this.mActivity == null) {
            return;
        }
        UCrop.m716of(uri, Uri.fromFile(new File(this.mActivity.getCacheDir(), "uCrop.tmp"))).withAspectRatio(1.0f, 1.0f).withMaxResultSize(512, 512).start(this.mActivity);
    }

    public void startPhotoZoom(Uri uri, int i) {
        try {
            if (Build.VERSION.SDK_INT >= 24) {
                Log.d("ABTEST", uri.toString());
                String path = CommonUtil.getPath(getCurActivity(), uri);
                if (!CommonUtil.isEmpty(path)) {
                    uri = FileProvider.getUriForFile(getCurActivity(), getCurActivity().getPackageName().concat(".provider"), new File(path));
                }
            }
            Intent intent = new Intent("com.android.camera.action.CROP");
            intent.setDataAndType(uri, IMAGE_UNSPECIFIED);
            intent.putExtra("crop", "true");
            intent.putExtra("aspectX", 1);
            intent.putExtra("aspectY", 1);
            intent.putExtra("outputX", 512);
            intent.putExtra("outputY", 512);
            File file = new File(getCurActivity().getFilesDir(), "/screenshot.jpg");
            if (Build.VERSION.SDK_INT >= 24) {
                this.uritempFile = FileProvider.getUriForFile(getCurActivity(), getCurActivity().getPackageName().concat(".provider"), file);
                Iterator<ResolveInfo> it = getCurActivity().getPackageManager().queryIntentActivities(intent, 65536).iterator();
                while (it.hasNext()) {
                    getCurActivity().grantUriPermission(it.next().activityInfo.packageName, this.uritempFile, 3);
                }
                intent.addFlags(1);
                intent.addFlags(2);
            } else {
                this.uritempFile = Uri.fromFile(file);
            }
            intent.putExtra("return-data", false);
            intent.putExtra("output", this.uritempFile);
            intent.putExtra("outputFormat", Bitmap.CompressFormat.JPEG.toString());
            getCurActivity().startActivityForResult(intent, i);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void saveImg(Intent intent) throws Throwable {
        try {
            if (this.uritempFile != null) {
                try {
                    InputStream inputStreamOpenInputStream = getCurActivity().getContentResolver().openInputStream(this.uritempFile);
                    Bitmap bitmapDecodeStream = BitmapFactory.decodeStream(inputStreamOpenInputStream);
                    bitmapDecodeStream.compress(Bitmap.CompressFormat.JPEG, 75, new ByteArrayOutputStream());
                    inputStreamOpenInputStream.close();
                    final String strSavePhotoToSDCard = savePhotoToSDCard(bitmapDecodeStream, getCurActivity().getExternalCacheDir().getAbsolutePath(), String.valueOf(gameUid + "_" + index));
                    if (new File(strSavePhotoToSDCard).exists()) {
                        this.mActivity.runOnUiThread(new Runnable() {
                            @Override
                            public void run() {
                                TakePhotoController.this.SendHeadImgUrl(strSavePhotoToSDCard);
                            }
                        });
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
            }
        } catch (Exception e2) {
            e2.printStackTrace();
        }
    }

    private void saveImg(Uri uri) throws Throwable {
        String absolutePath;
        if (uri != null) {
            boolean z = false;
            try {
                InputStream inputStreamOpenInputStream = getCurActivity().getContentResolver().openInputStream(uri);
                Bitmap bitmapDecodeStream = BitmapFactory.decodeStream(inputStreamOpenInputStream);
                bitmapDecodeStream.compress(Bitmap.CompressFormat.JPEG, 75, new ByteArrayOutputStream());
                inputStreamOpenInputStream.close();
                if (Environment.isExternalStorageEmulated() && getCurActivity().getExternalCacheDir() != null) {
                    z = true;
                    absolutePath = getCurActivity().getExternalCacheDir().getAbsolutePath();
                } else {
                    absolutePath = getCurActivity().getCacheDir().getAbsolutePath();
                }
                final String strSavePhotoToSDCard = savePhotoToSDCard(bitmapDecodeStream, absolutePath, String.valueOf(gameUid + "_" + index));
                if (new File(strSavePhotoToSDCard).exists()) {
                    this.mActivity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            TakePhotoController.this.SendHeadImgUrl(strSavePhotoToSDCard);
                        }
                    });
                }
            } catch (Exception e) {
                try {
                    SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::saveImg useExternal: " + z + ", e:" + e.getMessage());
                } catch (Exception e2) {
                    e2.printStackTrace();
                }
            }
        }
    }

    private void SaveSingleImg(Uri uri) throws IOException {
        if (uri != null) {
            try {
                InputStream inputStreamOpenInputStream = getCurActivity().getContentResolver().openInputStream(uri);
                if (inputStreamOpenInputStream == null) {
                    SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::saveSingleImg: 根据 originalUri 读取的的 InputStream 流为空");
                    return;
                }
                Bitmap bitmapDecodeStream = BitmapFactory.decodeStream(inputStreamOpenInputStream);
                if (bitmapDecodeStream == null) {
                    SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::saveSingleImg: originalBitmap 为空，玩家选的可能不是图片。");
                    return;
                }
                Bitmap bitmapGetScaledBitmapBig = GetScaledBitmapBig(bitmapDecodeStream, uri);
                final int width = bitmapGetScaledBitmapBig.getWidth();
                final int height = bitmapGetScaledBitmapBig.getHeight();
                int i = photoResolutionLimit;
                if (width > i || height > i) {
                    SdkManager.getInstance().SendDataToGame("ExceedResolutionLimit", "");
                    return;
                }
                ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
                bitmapGetScaledBitmapBig.compress(Bitmap.CompressFormat.JPEG, 80, byteArrayOutputStream);
                inputStreamOpenInputStream.close();
                if (byteArrayOutputStream.toByteArray().length / 1024.0f > photoFileSizeLimit) {
                    SdkManager.getInstance().SendDataToGame("ExceedFileSizeLimit", "");
                    return;
                }
                String absolutePath = getCurActivity().getExternalFilesDir(null).getAbsolutePath();
                if (absolutePath == "") {
                    SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::saveSingleImg: 本地存储根路径 storePath 为空");
                }
                String strReplace = new SimpleDateFormat("yyyy-MM-ddHH:mm:ss").format(Calendar.getInstance().getTime()).replace("-", "_").replace(":", "_");
                String strSavePhotoToSDCard_Normal = SavePhotoToSDCard_Normal(bitmapGetScaledBitmapBig, byteArrayOutputStream, absolutePath, String.valueOf(strReplace + "_big"));
                byteArrayOutputStream.reset();
                Bitmap bitmapGetScaledBitmapSmall = GetScaledBitmapSmall(bitmapGetScaledBitmapBig);
                bitmapGetScaledBitmapSmall.compress(Bitmap.CompressFormat.JPEG, 80, byteArrayOutputStream);
                final String strSavePhotoToSDCard_Normal2 = SavePhotoToSDCard_Normal(bitmapGetScaledBitmapSmall, byteArrayOutputStream, absolutePath, String.valueOf(strReplace));
                File file = new File(strSavePhotoToSDCard_Normal);
                File file2 = new File(strSavePhotoToSDCard_Normal2);
                if (file.exists() && file2.exists()) {
                    this.mActivity.runOnUiThread(new Runnable() {
                        @Override
                        public void run() {
                            TakePhotoController.this.SendChatPhotoUrl(strSavePhotoToSDCard_Normal2, width, height);
                        }
                    });
                } else {
                    SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::saveSingleImg: 本地压缩的图片文件不存在");
                }
            } catch (Exception e) {
                e.printStackTrace();
                SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::saveSingleImg: " + e.getMessage());
            }
        }
    }

    private void SaveImgs(final List<Uri> list) throws IOException {
        if (list == null || list.size() <= 0) {
            return;
        }
        new Thread(new Runnable() {
            @Override
            public void run() throws Throwable {
                Bitmap bitmap;
                Bitmap bitmapDecodeStream;
                Bitmap bitmapGetScaledBitmapBig;
                Bitmap bitmap2;
                char c;
                Throwable th;
                final ArrayList arrayList = new ArrayList();
                final ArrayList arrayList2 = new ArrayList();
                final ArrayList arrayList3 = new ArrayList();
                Bitmap bitmap3 = null;
                String absolutePath = TakePhotoController.this.getCurActivity().getExternalFilesDir(null).getAbsolutePath();
                String str = new SimpleDateFormat("yyyyMMddHHmmss").format(Calendar.getInstance().getTime());
                char c2 = 0;
                int i = 0;
                while (i < list.size()) {
                    Uri uri = (Uri) list.get(i);
                    try {
                        InputStream inputStreamOpenInputStream = TakePhotoController.this.getCurActivity().getContentResolver().openInputStream(uri);
                        if (inputStreamOpenInputStream != null) {
                            try {
                                bitmapDecodeStream = BitmapFactory.decodeStream(inputStreamOpenInputStream);
                                if (bitmapDecodeStream != null) {
                                    try {
                                        bitmapGetScaledBitmapBig = TakePhotoController.this.GetScaledBitmapBig(bitmapDecodeStream, uri);
                                        try {
                                            try {
                                                if (bitmapGetScaledBitmapBig.getWidth() <= TakePhotoController.photoResolutionLimit) {
                                                    try {
                                                        if (bitmapGetScaledBitmapBig.getHeight() > TakePhotoController.photoResolutionLimit) {
                                                            SdkManager.getInstance().SendDataToGame("ExceedResolutionLimit", "");
                                                            TakePhotoController takePhotoController = TakePhotoController.this;
                                                            Bitmap[] bitmapArr = new Bitmap[3];
                                                            bitmapArr[0] = bitmapDecodeStream;
                                                            bitmapArr[1] = bitmapGetScaledBitmapBig;
                                                            bitmap = null;
                                                            try {
                                                                bitmapArr[2] = null;
                                                                takePhotoController.safeRecycle(bitmapArr);
                                                                if (inputStreamOpenInputStream != null) {
                                                                    try {
                                                                        inputStreamOpenInputStream.close();
                                                                    } catch (Exception e) {
                                                                        e = e;
                                                                        bitmap2 = null;
                                                                        c = 0;
                                                                        TakePhotoController.this.safeRecycle(bitmap2, bitmapGetScaledBitmapBig, bitmapDecodeStream);
                                                                        SdkManager.getInstance().SendDataToGame("Log_Info", "Save Error: " + e.getMessage());
                                                                    }
                                                                }
                                                                c = 0;
                                                            } catch (Throwable th2) {
                                                                th = th2;
                                                                th = th;
                                                                bitmap2 = bitmap;
                                                                try {
                                                                    if (inputStreamOpenInputStream != null) {
                                                                        try {
                                                                            inputStreamOpenInputStream.close();
                                                                        } catch (Throwable th3) {
                                                                            th.addSuppressed(th3);
                                                                        }
                                                                    }
                                                                    throw th;
                                                                } catch (Exception e2) {
                                                                    e = e2;
                                                                    c = 0;
                                                                    TakePhotoController.this.safeRecycle(bitmap2, bitmapGetScaledBitmapBig, bitmapDecodeStream);
                                                                    SdkManager.getInstance().SendDataToGame("Log_Info", "Save Error: " + e.getMessage());
                                                                    i++;
                                                                    c2 = c;
                                                                    bitmap3 = bitmap;
                                                                }
                                                            }
                                                        } else {
                                                            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
                                                            bitmapGetScaledBitmapBig.compress(Bitmap.CompressFormat.JPEG, 80, byteArrayOutputStream);
                                                            if (byteArrayOutputStream.toByteArray().length / 1024.0f > TakePhotoController.photoFileSizeLimit) {
                                                                SdkManager.getInstance().SendDataToGame("ExceedFileSizeLimit", "");
                                                                TakePhotoController takePhotoController2 = TakePhotoController.this;
                                                                Bitmap[] bitmapArr2 = new Bitmap[3];
                                                                bitmapArr2[c2] = bitmapDecodeStream;
                                                                bitmapArr2[1] = bitmapGetScaledBitmapBig;
                                                                bitmapArr2[2] = null;
                                                                takePhotoController2.safeRecycle(bitmapArr2);
                                                                if (inputStreamOpenInputStream != null) {
                                                                    try {
                                                                        inputStreamOpenInputStream.close();
                                                                    } catch (Exception e3) {
                                                                        e = e3;
                                                                        bitmap = null;
                                                                        bitmap2 = null;
                                                                        c = 0;
                                                                        TakePhotoController.this.safeRecycle(bitmap2, bitmapGetScaledBitmapBig, bitmapDecodeStream);
                                                                        SdkManager.getInstance().SendDataToGame("Log_Info", "Save Error: " + e.getMessage());
                                                                    }
                                                                }
                                                                c = c2;
                                                                bitmap = null;
                                                            } else {
                                                                String str2 = str + "_" + i;
                                                                String strSavePhotoToSDCard_Normal = TakePhotoController.this.SavePhotoToSDCard_Normal(bitmapGetScaledBitmapBig, byteArrayOutputStream, absolutePath, str2 + "_big");
                                                                byteArrayOutputStream.reset();
                                                                Bitmap bitmapGetScaledBitmapSmall = TakePhotoController.this.GetScaledBitmapSmall(bitmapGetScaledBitmapBig);
                                                                try {
                                                                    bitmapGetScaledBitmapSmall.compress(Bitmap.CompressFormat.JPEG, 80, byteArrayOutputStream);
                                                                    String strSavePhotoToSDCard_Normal2 = TakePhotoController.this.SavePhotoToSDCard_Normal(bitmapGetScaledBitmapSmall, byteArrayOutputStream, absolutePath, str2);
                                                                    if (new File(strSavePhotoToSDCard_Normal2).exists() && new File(strSavePhotoToSDCard_Normal).exists()) {
                                                                        int width = bitmapGetScaledBitmapBig.getWidth();
                                                                        int height = bitmapGetScaledBitmapBig.getHeight();
                                                                        arrayList.add(strSavePhotoToSDCard_Normal2);
                                                                        arrayList2.add(String.valueOf(width));
                                                                        arrayList3.add(String.valueOf(height));
                                                                    }
                                                                    TakePhotoController.this.safeRecycle(bitmapGetScaledBitmapSmall, bitmapGetScaledBitmapBig, bitmapDecodeStream);
                                                                    if (inputStreamOpenInputStream != null) {
                                                                        try {
                                                                            inputStreamOpenInputStream.close();
                                                                        } catch (Exception e4) {
                                                                            e = e4;
                                                                            bitmap2 = bitmapGetScaledBitmapSmall;
                                                                            bitmap = null;
                                                                            c = 0;
                                                                            TakePhotoController.this.safeRecycle(bitmap2, bitmapGetScaledBitmapBig, bitmapDecodeStream);
                                                                            SdkManager.getInstance().SendDataToGame("Log_Info", "Save Error: " + e.getMessage());
                                                                        }
                                                                    }
                                                                    c = 0;
                                                                    bitmap = null;
                                                                } catch (Throwable th4) {
                                                                    th = th4;
                                                                    bitmap2 = bitmapGetScaledBitmapSmall;
                                                                    bitmap = null;
                                                                    if (inputStreamOpenInputStream != null) {
                                                                        inputStreamOpenInputStream.close();
                                                                    }
                                                                    throw th;
                                                                }
                                                            }
                                                        }
                                                    } catch (Throwable th5) {
                                                        th = th5;
                                                        bitmap = null;
                                                        bitmap2 = null;
                                                    }
                                                } else {
                                                    SdkManager.getInstance().SendDataToGame("ExceedResolutionLimit", "");
                                                    TakePhotoController takePhotoController3 = TakePhotoController.this;
                                                    Bitmap[] bitmapArr3 = new Bitmap[3];
                                                    bitmapArr3[0] = bitmapDecodeStream;
                                                    bitmapArr3[1] = bitmapGetScaledBitmapBig;
                                                    bitmap = null;
                                                    bitmapArr3[2] = null;
                                                    takePhotoController3.safeRecycle(bitmapArr3);
                                                    if (inputStreamOpenInputStream != null) {
                                                        inputStreamOpenInputStream.close();
                                                    }
                                                    c = 0;
                                                }
                                            } catch (Throwable th6) {
                                                th = th6;
                                                bitmap = null;
                                            }
                                        } catch (Throwable th7) {
                                            th = th7;
                                            bitmap = bitmap3;
                                        }
                                    } catch (Throwable th8) {
                                        bitmap = bitmap3;
                                        th = th8;
                                        bitmapGetScaledBitmapBig = bitmap;
                                        bitmap2 = bitmapGetScaledBitmapBig;
                                        if (inputStreamOpenInputStream != null) {
                                            inputStreamOpenInputStream.close();
                                        }
                                        throw th;
                                    }
                                } else if (inputStreamOpenInputStream != null) {
                                    try {
                                        inputStreamOpenInputStream.close();
                                    } catch (Exception e5) {
                                        e = e5;
                                        bitmap = bitmap3;
                                        bitmapGetScaledBitmapBig = bitmap;
                                        bitmap2 = bitmapGetScaledBitmapBig;
                                        c = 0;
                                        TakePhotoController.this.safeRecycle(bitmap2, bitmapGetScaledBitmapBig, bitmapDecodeStream);
                                        SdkManager.getInstance().SendDataToGame("Log_Info", "Save Error: " + e.getMessage());
                                    }
                                }
                                i++;
                                c2 = c;
                                bitmap3 = bitmap;
                            } catch (Throwable th9) {
                                bitmap = bitmap3;
                                th = th9;
                                bitmapDecodeStream = bitmap;
                                bitmapGetScaledBitmapBig = bitmapDecodeStream;
                            }
                        } else if (inputStreamOpenInputStream != null) {
                            inputStreamOpenInputStream.close();
                        }
                        bitmap = bitmap3;
                        c = c2;
                    } catch (Exception e6) {
                        e = e6;
                        bitmap = bitmap3;
                        bitmapDecodeStream = bitmap;
                        bitmapGetScaledBitmapBig = bitmapDecodeStream;
                    }
                    i++;
                    c2 = c;
                    bitmap3 = bitmap;
                }
                if (arrayList.isEmpty()) {
                    return;
                }
                TakePhotoController.this.getCurActivity().runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        TakePhotoController.this.SendPhotosUrl(TextUtils.join("|", arrayList), TextUtils.join("|", arrayList2), TextUtils.join("|", arrayList3));
                    }
                });
            }
        }).start();
    }

    public void safeRecycle(Bitmap... bitmapArr) {
        for (Bitmap bitmap : bitmapArr) {
            if (bitmap != null && !bitmap.isRecycled()) {
                bitmap.recycle();
            }
        }
    }

    public String savePhotoToSDCard(Bitmap bitmap, String str, String str2) throws Throwable {
        if (!AppUtilManager.getInstance().checkSDCardAvailable()) {
            return "";
        }
        File file = new File(str);
        if (!file.exists()) {
            file.mkdirs();
        }
        File file2 = new File(str, str2 + ".jpg");
        String absolutePath = file2.getAbsolutePath();
        FileOutputStream fileOutputStream = null;
        try {
            try {
                try {
                    FileOutputStream fileOutputStream2 = new FileOutputStream(file2);
                    if (bitmap != null) {
                        try {
                            if (bitmap.compress(Bitmap.CompressFormat.JPEG, 100, fileOutputStream2)) {
                                fileOutputStream2.flush();
                            }
                        } catch (FileNotFoundException e) {
                            e = e;
                            fileOutputStream = fileOutputStream2;
                            file2.delete();
                            e.printStackTrace();
                            fileOutputStream.close();
                        } catch (IOException e2) {
                            e = e2;
                            fileOutputStream = fileOutputStream2;
                            file2.delete();
                            e.printStackTrace();
                            fileOutputStream.close();
                        } catch (Throwable th) {
                            th = th;
                            fileOutputStream = fileOutputStream2;
                            try {
                                fileOutputStream.close();
                            } catch (Throwable unused) {
                            }
                            throw th;
                        }
                    }
                    fileOutputStream2.close();
                } catch (Throwable unused2) {
                    return absolutePath;
                }
            } catch (FileNotFoundException e3) {
                e = e3;
            } catch (IOException e4) {
                e = e4;
            }
            return absolutePath;
        } catch (Throwable th2) {
            th = th2;
        }
    }

    public String SavePhotoToSDCard_Normal(Bitmap bitmap, ByteArrayOutputStream byteArrayOutputStream, String str, String str2) {
        if (!AppUtilManager.getInstance().checkSDCardAvailable()) {
            return "";
        }
        File file = new File(str + "/ChatUploadPhoto");
        if (!file.exists()) {
            file.mkdirs();
        }
        File file2 = new File(file, str2 + ".jpg");
        String absolutePath = file2.getAbsolutePath();
        if (CommonUtil.isEmpty(absolutePath)) {
            SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::saveSingleImg: 照片写入路径 saveFilePath 为空：" + str2);
        }
        try {
            FileOutputStream fileOutputStream = new FileOutputStream(file2);
            if (bitmap == null || byteArrayOutputStream == null) {
                return absolutePath;
            }
            fileOutputStream.write(byteArrayOutputStream.toByteArray());
            fileOutputStream.flush();
            fileOutputStream.close();
            return absolutePath;
        } catch (FileNotFoundException e) {
            file2.delete();
            e.printStackTrace();
            SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::saveSingleImg: 照片写入路径 FileNotFoundException 异常:" + e.getMessage());
            return absolutePath;
        } catch (IOException e2) {
            file2.delete();
            e2.printStackTrace();
            SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::saveSingleImg: 照片写入路径 IOException 异常:" + e2.getMessage());
            return absolutePath;
        }
    }

    private String getPhotoPath() {
        if (Build.VERSION.SDK_INT >= 30) {
            return AppUtilManager.getInstance().getInternalDir() + "/files/";
        }
        return (Environment.getExternalStorageDirectory().getAbsolutePath() + "/Android/data/") + this.mActivity.getPackageName() + "/files/";
    }

    protected void SendHeadImgUrl(String str) {
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("1", str);
            SdkManager.getInstance().SendDataToGame("getHeadImgUrl", jSONObject.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void SendChatPhotoUrl(String str, int i, int i2) {
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("photoUrl", str);
            jSONObject.put("compressedWidth", Integer.toString(i));
            jSONObject.put("compressedHeight", Integer.toString(i2));
            SdkManager.getInstance().SendDataToGame("GetChatPhotoUrl", jSONObject.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    protected void SendPhotosUrl(String str, String str2, String str3) {
        try {
            JSONObject jSONObject = new JSONObject();
            jSONObject.put("urlListStr", str);
            jSONObject.put("widthListStr", str2);
            jSONObject.put("heightListStr", str3);
            SdkManager.getInstance().SendDataToGame("GetPhotosUrl", jSONObject.toString());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public void OnUploadPhoto(String str, int i, int i2, int i3, int i4, int i5, int i6) {
        if (i == -1) {
            Log.e(AppUtilManager.TAG, "和相册相关功能的参数错误，Code种类值为：" + i);
        } else if (i == 0) {
            showPicturePicker1(str, i2);
        } else if (i == 1) {
            showPicturePickerByCrop(str, i2);
        } else if (i == 2) {
            ShowSinglePicturePicker(i3, i4, i5, i6);
        }
    }

    public void OnUploadPhotos(String str, int i, int i2, int i3, int i4, int i5, int i6, int i7) {
        photoMultiPickNum = i7;
        showPicturePickerSelectNum(i3, i4, i5, i6, i7);
    }

    public void onActivityResult(int i, int i2, Intent intent) throws Throwable {
        Uri data;
        Uri data2;
        if (i2 != -1) {
            if (i == 69 && i2 == 96) {
                this.mActivity.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        TakePhotoController.this.SendHeadImgUrl("-1");
                    }
                });
                return;
            }
            return;
        }
        if (i == 69) {
            try {
                saveImg(UCrop.getOutput(intent));
                return;
            } catch (Exception e) {
                SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::UCrop.REQUEST_CROP " + e.getMessage());
                return;
            }
        }
        if (i == 6709) {
            if (intent == null) {
                return;
            }
            Uri output = Crop.getOutput(intent);
            Log.e("TakePhotoController", "onActivityResult::Crop.REQUEST_CROP：" + output);
            if (output == null) {
                return;
            }
            try {
                saveImg(output);
                return;
            } catch (IOException e2) {
                e2.printStackTrace();
                return;
            }
        }
        if (i == 9162) {
            if (this.mActivity != null) {
                Uri.fromFile(new File(this.mActivity.getCacheDir(), "cropped"));
                Uri data3 = intent.getData();
                Log.i("TakePhotoController", "onActivityResult::Crop.REQUEST_PICK: " + data3);
                if (data3 != null) {
                    startCrop(data3);
                    return;
                }
                return;
            }
            return;
        }
        if (i == 9200) {
            if (this.mActivity == null || intent == null || (data = intent.getData()) == null) {
                return;
            }
            try {
                SaveSingleImg(data);
                return;
            } catch (IOException e3) {
                e3.printStackTrace();
                return;
            }
        }
        if (i != 9300) {
            switch (i) {
                case TAKE_PICTURE:
                    startCrop(this.uritempFile);
                    break;
                case CHOOSE_PICTURE:
                    if (intent != null && (data2 = intent.getData()) != null) {
                        startCrop(data2);
                        break;
                    }
                    break;
                case CLIP_TAKEN_PICTURE:
                case CLIP_CHOOSED_PICTURE:
                    if (intent != null) {
                        saveImg(intent);
                    }
                    break;
            }
            return;
        }
        if (this.mActivity == null || intent == null) {
            return;
        }
        ArrayList arrayList = new ArrayList();
        if (intent.getClipData() != null) {
            int itemCount = intent.getClipData().getItemCount();
            int i3 = photoMultiPickNum;
            if (itemCount > i3) {
                itemCount = i3;
            }
            for (int i4 = 0; i4 < itemCount; i4++) {
                arrayList.add(intent.getClipData().getItemAt(i4).getUri());
            }
        } else if (intent.getData() != null) {
            arrayList.add(intent.getData());
        }
        if (arrayList.size() == 0) {
            return;
        }
        try {
            SaveImgs(arrayList);
        } catch (IOException e4) {
            e4.printStackTrace();
        }
    }

    public void onRequestPermissionsResult(int i, String[] strArr, int[] iArr) {
        if (i != 1) {
            if (i == 2) {
                if (iArr != null && iArr.length > 0 && iArr[0] == 0) {
                    SpUtils.getInstance(this.mActivity).putBoolean(CacheKey_Camera, false);
                    showPicturePicker1(temp_uid, temp_idx);
                    return;
                } else {
                    if (ActivityCompat.shouldShowRequestPermissionRationale(this.mActivity, "android.permission.CAMERA")) {
                        return;
                    }
                    SpUtils.getInstance(this.mActivity).putBoolean(CacheKey_Camera, true);
                    return;
                }
            }
            return;
        }
        if (iArr != null && iArr.length > 0 && iArr[0] == 0) {
            int i2 = whichButtonRequestPermission;
            if (i2 != 1) {
                if (i2 == 2) {
                    showPicturePicker2(temp_uid, temp_idx);
                }
            } else if (iArr.length > 1 && iArr[1] == 0) {
                showPicturePicker1(temp_uid, temp_idx);
            }
            SpUtils.getInstance(this.mActivity).putBoolean(CacheKey_Albumn, false);
            return;
        }
        if (ActivityCompat.shouldShowRequestPermissionRationale(this.mActivity, "android.permission.WRITE_EXTERNAL_STORAGE")) {
            return;
        }
        SpUtils.getInstance(this.mActivity).putBoolean(CacheKey_Albumn, true);
    }

    public Bitmap GetScaledBitmapBig(Bitmap bitmap, Uri uri) {
        float f;
        float fMax;
        float fMax2;
        try {
            float width = bitmap.getWidth();
            float height = bitmap.getHeight();
            float f2 = width / height;
            float f3 = suitableResolutionSizeBig;
            if (width >= f3 || height >= f3) {
                if (width <= f3 || height <= f3) {
                    if (f2 <= 2.0f && f2 >= 0.5d) {
                        if (f2 > 1.0f) {
                            f = f3 / f2;
                        } else {
                            f3 = f2 * f3;
                            f = f3;
                        }
                    }
                } else if (f2 > 1.0f) {
                    f3 = f2 * f3;
                    f = f3;
                } else {
                    f = f3 / f2;
                }
                fMax = Math.max(f3, f);
                fMax2 = Math.max(width, height);
                while (fMax2 > fMax) {
                    fMax2 /= 1.2f;
                    if (fMax2 < fMax) {
                        fMax2 = fMax;
                    }
                    Bitmap bitmapScaledBitmapToTargetScale = ScaledBitmapToTargetScale(bitmap, fMax2);
                    bitmap.recycle();
                    bitmap = bitmapScaledBitmapToTargetScale;
                }
                return RotateBitmap(bitmap, GetPictureDegree(getCurActivity(), uri));
            }
            f3 = width;
            f = height;
            fMax = Math.max(f3, f);
            fMax2 = Math.max(width, height);
            while (fMax2 > fMax) {
                fMax2 /= 1.2f;
                if (fMax2 < fMax) {
                    fMax2 = fMax;
                }
                Bitmap bitmapScaledBitmapToTargetScale2 = ScaledBitmapToTargetScale(bitmap, fMax2);
                bitmap.recycle();
                bitmap = bitmapScaledBitmapToTargetScale2;
            }
            return RotateBitmap(bitmap, GetPictureDegree(getCurActivity(), uri));
        } catch (Exception e) {
            e.printStackTrace();
            SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::GetScaledBitmapBig()： " + e.getMessage());
            return bitmap;
        }
    }

    public Bitmap GetScaledBitmapSmall(Bitmap bitmap) {
        try {
            float fMax = Math.max(bitmap.getWidth(), bitmap.getHeight());
            while (true) {
                float f = suitableResolutionSizeSmall;
                if (fMax <= f) {
                    return bitmap;
                }
                fMax /= 2.0f;
                if (fMax < f) {
                    fMax = f;
                }
                Bitmap bitmapScaledBitmapToTargetScale = ScaledBitmapToTargetScale(bitmap, fMax);
                bitmap.recycle();
                bitmap = bitmapScaledBitmapToTargetScale;
            }
        } catch (Exception e) {
            e.printStackTrace();
            SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::GetScaledBitmapSmall()： " + e.getMessage());
            return bitmap;
        }
    }

    public Bitmap ScaledBitmapToTargetScale(Bitmap bitmap, float f) {
        float f2;
        try {
            float width = bitmap.getWidth();
            float height = bitmap.getHeight();
            if (width >= height) {
                f2 = height * (f / width);
            } else {
                float f3 = width * (f / height);
                f2 = f;
                f = f3;
            }
            return Bitmap.createScaledBitmap(bitmap, (int) f, (int) f2, true);
        } catch (Exception e) {
            e.printStackTrace();
            SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::ScaledBitmapToTargetScale()： " + e.getMessage());
            return bitmap;
        }
    }

    private static int GetPictureDegree(Context context, Uri uri) {
        try {
            InputStream inputStreamOpenInputStream = context.getContentResolver().openInputStream(uri);
            if (inputStreamOpenInputStream == null || Build.VERSION.SDK_INT < 24) {
                return 0;
            }
            Udid$$ExternalSyntheticApiModelOutline0.m422m();
            int attributeInt = Udid$$ExternalSyntheticApiModelOutline0.m409m(inputStreamOpenInputStream).getAttributeInt("Orientation", 1);
            if (attributeInt == 3) {
                return 180;
            }
            if (attributeInt != 6) {
                return attributeInt != 8 ? 0 : 270;
            }
            return 90;
        } catch (Exception e) {
            e.printStackTrace();
            SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::GetPictureDegree()： " + e.getMessage());
            return 0;
        }
    }

    private static Bitmap RotateBitmap(Bitmap bitmap, int i) {
        if (bitmap == null) {
            return null;
        }
        if (i == 0) {
            return bitmap;
        }
        try {
            int width = bitmap.getWidth();
            int height = bitmap.getHeight();
            Matrix matrix = new Matrix();
            matrix.postRotate(i);
            return Bitmap.createBitmap(bitmap, 0, 0, width, height, matrix, true);
        } catch (Exception e) {
            e.printStackTrace();
            SdkManager.getInstance().SendDataToGame("Log_Info", "TakePhotoController::RotateBitmap()： " + e.getMessage());
            return bitmap;
        }
    }
}
