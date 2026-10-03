package com.soundcloud.android.crop;

import android.content.Intent;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.BitmapRegionDecoder;
import android.graphics.Matrix;
import android.graphics.Rect;
import android.graphics.RectF;
import android.net.Uri;
import android.opengl.GLES10;
import android.os.Bundle;
import android.os.Handler;
import android.view.View;
import com.unity3d.player.C1087R;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.concurrent.CountDownLatch;

public class CropImageActivity extends MonitoredActivity {
    private static final int SIZE_DEFAULT = 2048;
    private static final int SIZE_LIMIT = 4096;
    private int aspectX;
    private int aspectY;
    private HighlightView cropView;
    private int exifRotation;
    private final Handler handler = new Handler();
    private CropImageView imageView;
    private boolean isSaving;
    private int maxX;
    private int maxY;
    private RotateBitmap rotateBitmap;
    private int sampleSize;
    private Uri saveUri;
    private Uri sourceUri;

    @Override
    public boolean onSearchRequested() {
        return false;
    }

    @Override
    public void addLifeCycleListener(MonitoredActivity.LifeCycleListener lifeCycleListener) {
        super.addLifeCycleListener(lifeCycleListener);
    }

    @Override
    public void removeLifeCycleListener(MonitoredActivity.LifeCycleListener lifeCycleListener) {
        super.removeLifeCycleListener(lifeCycleListener);
    }

    @Override
    public void onCreate(Bundle bundle) throws Throwable {
        super.onCreate(bundle);
        setupWindowFlags();
        setupViews();
        loadInput();
        if (this.rotateBitmap == null) {
            finish();
        } else {
            startCrop();
        }
    }

    private void setupWindowFlags() {
        requestWindowFeature(1);
        getWindow().clearFlags(67108864);
    }

    private void setupViews() {
        Log.m439e("CropImageActivity setupViews");
        setContentView(C1087R.layout.crop__activity_crop);
        CropImageView cropImageView = (CropImageView) findViewById(C1087R.id.crop_image);
        this.imageView = cropImageView;
        cropImageView.context = this;
        this.imageView.setRecycler(new ImageViewTouchBase.Recycler() {
            @Override
            public void recycle(Bitmap bitmap) {
                bitmap.recycle();
                System.gc();
            }
        });
        findViewById(C1087R.id.btn_cancel).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) {
                CropImageActivity.this.setResult(0);
                CropImageActivity.this.finish();
            }
        });
        findViewById(C1087R.id.btn_done).setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View view) throws Throwable {
                CropImageActivity.this.onSaveClicked();
            }
        });
    }

    private void loadInput() throws Throwable {
        Intent intent = getIntent();
        Bundle extras = intent.getExtras();
        if (extras != null) {
            this.aspectX = extras.getInt(Crop.Extra.ASPECT_X);
            this.aspectY = extras.getInt(Crop.Extra.ASPECT_Y);
            this.maxX = extras.getInt(Crop.Extra.MAX_X);
            this.maxY = extras.getInt(Crop.Extra.MAX_Y);
            this.saveUri = (Uri) extras.getParcelable("output");
        }
        Uri data = intent.getData();
        this.sourceUri = data;
        if (data == null) {
            return;
        }
        this.exifRotation = CropUtil.getExifRotation(CropUtil.getFromMediaUri(this, getContentResolver(), this.sourceUri));
        InputStream inputStream = null;
        try {
            try {
                this.sampleSize = calculateBitmapSampleSize(this.sourceUri);
                InputStream inputStreamOpenInputStream = getContentResolver().openInputStream(this.sourceUri);
                try {
                    BitmapFactory.Options options = new BitmapFactory.Options();
                    options.inSampleSize = this.sampleSize;
                    this.rotateBitmap = new RotateBitmap(BitmapFactory.decodeStream(inputStreamOpenInputStream, null, options), this.exifRotation);
                    CropUtil.closeSilently(inputStreamOpenInputStream);
                } catch (IOException e) {
                    e = e;
                    inputStream = inputStreamOpenInputStream;
                    Log.m440e("Error reading image: " + e.getMessage(), e);
                    setResultException(e);
                    CropUtil.closeSilently(inputStream);
                } catch (OutOfMemoryError e2) {
                    e = e2;
                    inputStream = inputStreamOpenInputStream;
                    Log.m440e("OOM reading image: " + e.getMessage(), e);
                    setResultException(e);
                    CropUtil.closeSilently(inputStream);
                } catch (SecurityException unused) {
                    inputStream = inputStreamOpenInputStream;
                    setResult(0);
                    finish();
                    Log.m439e("CropImageActivity::Need Permission");
                    CropUtil.closeSilently(inputStream);
                } catch (Throwable th) {
                    th = th;
                    inputStream = inputStreamOpenInputStream;
                    CropUtil.closeSilently(inputStream);
                    throw th;
                }
            } catch (Throwable th2) {
                th = th2;
            }
        } catch (IOException e3) {
            e = e3;
        } catch (OutOfMemoryError e4) {
            e = e4;
        } catch (SecurityException unused2) {
        }
    }

    private int calculateBitmapSampleSize(Uri uri) throws Throwable {
        BitmapFactory.Options options = new BitmapFactory.Options();
        int i = 1;
        options.inJustDecodeBounds = true;
        InputStream inputStream = null;
        try {
            InputStream inputStreamOpenInputStream = getContentResolver().openInputStream(uri);
            try {
                BitmapFactory.decodeStream(inputStreamOpenInputStream, null, options);
                CropUtil.closeSilently(inputStreamOpenInputStream);
                int maxImageSize = getMaxImageSize();
                while (true) {
                    if (options.outHeight / i <= maxImageSize && options.outWidth / i <= maxImageSize) {
                        return i;
                    }
                    i <<= 1;
                }
            } catch (Throwable th) {
                th = th;
                inputStream = inputStreamOpenInputStream;
                CropUtil.closeSilently(inputStream);
                throw th;
            }
        } catch (Throwable th2) {
            th = th2;
        }
    }

    private int getMaxImageSize() {
        int maxTextureSize = getMaxTextureSize();
        return maxTextureSize == 0 ? SIZE_DEFAULT : Math.min(maxTextureSize, 4096);
    }

    private int getMaxTextureSize() {
        int[] iArr = new int[1];
        GLES10.glGetIntegerv(3379, iArr, 0);
        return iArr[0];
    }

    private void startCrop() {
        if (isFinishing()) {
            return;
        }
        this.imageView.setImageRotateBitmapResetBase(this.rotateBitmap, true);
        CropUtil.startBackgroundJob(this, null, "Please wait…", new Runnable() {
            @Override
            public void run() {
                final CountDownLatch countDownLatch = new CountDownLatch(1);
                CropImageActivity.this.handler.post(new Runnable() {
                    @Override
                    public void run() {
                        if (CropImageActivity.this.imageView.getScale() == 1.0f) {
                            CropImageActivity.this.imageView.center();
                        }
                        countDownLatch.countDown();
                    }
                });
                try {
                    countDownLatch.await();
                    new Cropper().crop();
                } catch (InterruptedException e) {
                    throw new RuntimeException(e);
                }
            }
        }, this.handler);
    }

    private class Cropper {
        private Cropper() {
        }

        public void makeDefault() {
            int i;
            if (CropImageActivity.this.rotateBitmap == null) {
                return;
            }
            HighlightView highlightView = new HighlightView(CropImageActivity.this.imageView);
            int width = CropImageActivity.this.rotateBitmap.getWidth();
            int height = CropImageActivity.this.rotateBitmap.getHeight();
            boolean z = false;
            Rect rect = new Rect(0, 0, width, height);
            int iMin = (Math.min(width, height) * 4) / 5;
            if (CropImageActivity.this.aspectX == 0 || CropImageActivity.this.aspectY == 0) {
                i = iMin;
            } else if (CropImageActivity.this.aspectX > CropImageActivity.this.aspectY) {
                i = (CropImageActivity.this.aspectY * iMin) / CropImageActivity.this.aspectX;
            } else {
                i = iMin;
                iMin = (CropImageActivity.this.aspectX * iMin) / CropImageActivity.this.aspectY;
            }
            int i2 = (width - iMin) / 2;
            int i3 = (height - i) / 2;
            RectF rectF = new RectF(i2, i3, i2 + iMin, i3 + i);
            Matrix unrotatedMatrix = CropImageActivity.this.imageView.getUnrotatedMatrix();
            if (CropImageActivity.this.aspectX != 0 && CropImageActivity.this.aspectY != 0) {
                z = true;
            }
            highlightView.setup(unrotatedMatrix, rect, rectF, z);
            CropImageActivity.this.imageView.add(highlightView);
        }

        public void crop() {
            CropImageActivity.this.handler.post(new Runnable() {
                @Override
                public void run() {
                    Cropper.this.makeDefault();
                    CropImageActivity.this.imageView.invalidate();
                    if (CropImageActivity.this.imageView.highlightViews.size() == 1) {
                        CropImageActivity.this.cropView = CropImageActivity.this.imageView.highlightViews.get(0);
                        CropImageActivity.this.cropView.setFocus(true);
                    }
                }
            });
        }
    }

    public void onSaveClicked() throws Throwable {
        int i;
        HighlightView highlightView = this.cropView;
        if (highlightView == null || this.isSaving) {
            return;
        }
        this.isSaving = true;
        Rect scaledCropRect = highlightView.getScaledCropRect(this.sampleSize);
        int iWidth = scaledCropRect.width();
        int iHeight = scaledCropRect.height();
        int i2 = this.maxX;
        if (i2 > 0 && (i = this.maxY) > 0 && (iWidth > i2 || iHeight > i)) {
            float f = iWidth / iHeight;
            if (i2 / i > f) {
                iWidth = (int) ((i * f) + 0.5f);
                iHeight = i;
            } else {
                iHeight = (int) ((i2 / f) + 0.5f);
                iWidth = i2;
            }
        }
        try {
            Bitmap bitmapDecodeRegionCrop = decodeRegionCrop(scaledCropRect, iWidth, iHeight);
            if (bitmapDecodeRegionCrop != null) {
                this.imageView.setImageRotateBitmapResetBase(new RotateBitmap(bitmapDecodeRegionCrop, this.exifRotation), true);
                this.imageView.center();
                this.imageView.highlightViews.clear();
            }
            saveImage(bitmapDecodeRegionCrop);
        } catch (IllegalArgumentException e) {
            setResultException(e);
            finish();
        }
    }

    private void saveImage(final Bitmap bitmap) {
        if (bitmap != null) {
            CropUtil.startBackgroundJob(this, null, "Saving picture…", new Runnable() {
                @Override
                public void run() {
                    CropImageActivity.this.saveOutput(bitmap);
                }
            }, this.handler);
        } else {
            finish();
        }
    }

    private Bitmap decodeRegionCrop(Rect rect, int i, int i2) throws Throwable {
        ?? r7;
        InputStream inputStream;
        ?? r16;
        ?? r17;
        ?? r18;
        Rect rect2;
        Bitmap bitmapDecodeRegion;
        ?? r8;
        clearImageView();
        try {
            try {
                InputStream inputStreamOpenInputStream = getContentResolver().openInputStream(this.sourceUri);
                try {
                    try {
                        BitmapRegionDecoder bitmapRegionDecoderNewInstance = BitmapRegionDecoder.newInstance(inputStreamOpenInputStream, false);
                        int width = bitmapRegionDecoderNewInstance.getWidth();
                        int height = bitmapRegionDecoderNewInstance.getHeight();
                        if (this.exifRotation != 0) {
                            Matrix matrix = new Matrix();
                            matrix.setRotate(-this.exifRotation);
                            RectF rectF = new RectF();
                            matrix.mapRect(rectF, new RectF(rect));
                            rectF.offset(rectF.left < 0.0f ? width : 0.0f, rectF.top < 0.0f ? height : 0.0f);
                            int i3 = (int) rectF.left;
                            int i4 = (int) rectF.top;
                            r8 = (int) rectF.right;
                            rect2 = new Rect(i3, i4, r8, (int) rectF.bottom);
                        } else {
                            rect2 = rect;
                        }
                        try {
                            try {
                                bitmapDecodeRegion = bitmapRegionDecoderNewInstance.decodeRegion(rect2, new BitmapFactory.Options());
                                if (bitmapDecodeRegion != null) {
                                    try {
                                        if (rect2.width() > i || rect2.height() > i2) {
                                            Matrix matrix2 = new Matrix();
                                            matrix2.postScale(i / rect2.width(), i2 / rect2.height());
                                            bitmapDecodeRegion = Bitmap.createBitmap(bitmapDecodeRegion, 0, 0, bitmapDecodeRegion.getWidth(), bitmapDecodeRegion.getHeight(), matrix2, true);
                                        }
                                    } catch (IllegalArgumentException e) {
                                        e = e;
                                        throw new IllegalArgumentException("Rectangle " + rect2 + " is outside of the image (" + width + "," + height + "," + this.exifRotation + ")", e);
                                    } catch (Exception e2) {
                                        e = e2;
                                        e.printStackTrace();
                                    }
                                }
                            } catch (IOException e3) {
                                e = e3;
                                r17 = r8;
                                inputStream = inputStreamOpenInputStream;
                                Log.m440e("Error cropping image: " + e.getMessage(), e);
                                setResultException(e);
                                r18 = r17;
                                CropUtil.closeSilently(inputStream);
                                r7 = r18;
                                return r7;
                            } catch (OutOfMemoryError e4) {
                                e = e4;
                                r16 = r8;
                                inputStream = inputStreamOpenInputStream;
                                Log.m440e("OOM cropping image: " + e.getMessage(), e);
                                setResultException(e);
                                r18 = r16;
                                CropUtil.closeSilently(inputStream);
                                r7 = r18;
                                return r7;
                            }
                        } catch (IllegalArgumentException e5) {
                            e = e5;
                        } catch (Exception e6) {
                            e = e6;
                            bitmapDecodeRegion = null;
                        }
                        CropUtil.closeSilently(inputStreamOpenInputStream);
                        return bitmapDecodeRegion;
                    } catch (Throwable th) {
                        th = th;
                        r7 = inputStreamOpenInputStream;
                        CropUtil.closeSilently(r7);
                        throw th;
                    }
                } catch (IOException e7) {
                    e = e7;
                    inputStream = inputStreamOpenInputStream;
                    r17 = 0;
                    Log.m440e("Error cropping image: " + e.getMessage(), e);
                    setResultException(e);
                    r18 = r17;
                    CropUtil.closeSilently(inputStream);
                    r7 = r18;
                    return r7;
                } catch (OutOfMemoryError e8) {
                    e = e8;
                    inputStream = inputStreamOpenInputStream;
                    r16 = 0;
                    Log.m440e("OOM cropping image: " + e.getMessage(), e);
                    setResultException(e);
                    r18 = r16;
                    CropUtil.closeSilently(inputStream);
                    r7 = r18;
                    return r7;
                }
            } catch (Throwable th2) {
                th = th2;
            }
        } catch (IOException e9) {
            e = e9;
            inputStream = null;
        } catch (OutOfMemoryError e10) {
            e = e10;
            inputStream = null;
        } catch (Throwable th3) {
            th = th3;
            r7 = 0;
        }
    }

    private void clearImageView() {
        this.imageView.clear();
        RotateBitmap rotateBitmap = this.rotateBitmap;
        if (rotateBitmap != null) {
            rotateBitmap.recycle();
        }
        System.gc();
    }

    public void saveOutput(final Bitmap bitmap) {
        if (this.saveUri != null) {
            OutputStream outputStreamOpenOutputStream = null;
            try {
                try {
                    outputStreamOpenOutputStream = getContentResolver().openOutputStream(this.saveUri);
                    if (outputStreamOpenOutputStream != null) {
                        bitmap.compress(Bitmap.CompressFormat.JPEG, 90, outputStreamOpenOutputStream);
                    }
                } catch (IOException e) {
                    setResultException(e);
                    Log.m440e("Cannot open file: " + this.saveUri, e);
                }
                CropUtil.closeSilently(outputStreamOpenOutputStream);
                CropUtil.copyExifRotation(CropUtil.getFromMediaUri(this, getContentResolver(), this.sourceUri), CropUtil.getFromMediaUri(this, getContentResolver(), this.saveUri));
                setResultUri(this.saveUri);
            } catch (Throwable th) {
                CropUtil.closeSilently(outputStreamOpenOutputStream);
                throw th;
            }
        }
        this.handler.post(new Runnable() {
            @Override
            public void run() {
                CropImageActivity.this.imageView.clear();
                bitmap.recycle();
            }
        });
        finish();
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        RotateBitmap rotateBitmap = this.rotateBitmap;
        if (rotateBitmap != null) {
            rotateBitmap.recycle();
        }
    }

    public boolean isSaving() {
        return this.isSaving;
    }

    private void setResultUri(Uri uri) {
        setResult(-1, new Intent().putExtra("output", uri));
    }

    private void setResultException(Throwable th) {
        setResult(Crop.RESULT_ERROR, new Intent().putExtra("error", th));
    }
}
