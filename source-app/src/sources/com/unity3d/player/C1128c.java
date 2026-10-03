package com.unity3d.player;

import android.content.Context;
import android.graphics.Rect;
import android.graphics.SurfaceTexture;
import android.hardware.camera2.CameraAccessException;
import android.hardware.camera2.CameraCaptureSession;
import android.hardware.camera2.CameraCharacteristics;
import android.hardware.camera2.CameraDevice;
import android.hardware.camera2.CameraManager;
import android.hardware.camera2.CaptureFailure;
import android.hardware.camera2.CaptureRequest;
import android.hardware.camera2.TotalCaptureResult;
import android.hardware.camera2.params.MeteringRectangle;
import android.hardware.camera2.params.StreamConfigurationMap;
import android.media.Image;
import android.media.ImageReader;
import android.os.Handler;
import android.os.HandlerThread;
import android.util.Range;
import android.util.Size;
import android.view.Surface;
import java.util.Arrays;
import java.util.concurrent.Semaphore;
import java.util.concurrent.TimeUnit;

public final class C1128c {

    private static CameraManager f402b;

    private static String[] f403c;

    private static Semaphore f404e = new Semaphore(1);

    private InterfaceC1131f f409a;

    private CameraDevice f410d;

    private HandlerThread f411f;

    private Handler f412g;

    private Rect f413h;

    private Rect f414i;

    private int f415j;

    private int f416k;

    private int f419n;

    private int f420o;

    private Range f422q;

    private Image f424s;

    private CaptureRequest.Builder f425t;

    private int f428w;

    private SurfaceTexture f429x;

    private float f417l = -1.0f;

    private float f418m = -1.0f;

    private boolean f421p = false;

    private ImageReader f423r = null;

    private CameraCaptureSession f426u = null;

    private Object f427v = new Object();

    private Surface f430y = null;

    private int f431z = a.f439c;

    private CameraCaptureSession.CaptureCallback f405A = new CameraCaptureSession.CaptureCallback() {
        @Override
        public final void onCaptureCompleted(CameraCaptureSession cameraCaptureSession, CaptureRequest captureRequest, TotalCaptureResult totalCaptureResult) {
            C1128c.this.m539a(captureRequest.getTag());
        }

        @Override
        public final void onCaptureFailed(CameraCaptureSession cameraCaptureSession, CaptureRequest captureRequest, CaptureFailure captureFailure) {
            C1134i.Log(5, "Camera2: Capture session failed " + captureRequest.getTag() + " reason " + captureFailure.getReason());
            C1128c.this.m539a(captureRequest.getTag());
        }

        @Override
        public final void onCaptureSequenceAborted(CameraCaptureSession cameraCaptureSession, int i) {
            C1134i.Log(4, "Camera2: Capture sequence aborted.");
        }

        @Override
        public final void onCaptureSequenceCompleted(CameraCaptureSession cameraCaptureSession, int i, long j) {
            C1134i.Log(4, "Camera2: Capture sequence completed.");
        }
    };

    private final CameraDevice.StateCallback f406B = new CameraDevice.StateCallback() {
        @Override
        public final void onClosed(CameraDevice cameraDevice) {
            C1134i.Log(4, "Camera2: CameraDevice closed.");
            C1128c.f404e.release();
        }

        @Override
        public final void onDisconnected(CameraDevice cameraDevice) {
            C1134i.Log(5, "Camera2: CameraDevice disconnected.");
            C1128c.this.m537a(cameraDevice);
            C1128c.f404e.release();
        }

        @Override
        public final void onError(CameraDevice cameraDevice, int i) {
            C1134i.Log(6, "Camera2: Error opeining CameraDevice " + i);
            C1128c.this.m537a(cameraDevice);
            C1128c.f404e.release();
        }

        @Override
        public final void onOpened(CameraDevice cameraDevice) {
            C1128c.this.f410d = cameraDevice;
            C1134i.Log(4, "Camera2: CameraDevice opened.");
            C1128c.f404e.release();
        }
    };

    private final ImageReader.OnImageAvailableListener f407C = new ImageReader.OnImageAvailableListener() {
        @Override
        public final void onImageAvailable(ImageReader imageReader) {
            if (C1128c.f404e.tryAcquire()) {
                Image imageAcquireNextImage = imageReader.acquireNextImage();
                if (imageAcquireNextImage != null) {
                    Image.Plane[] planes = imageAcquireNextImage.getPlanes();
                    if (imageAcquireNextImage.getFormat() == 35 && planes != null && planes.length == 3) {
                        C1128c.this.f409a.mo445a(planes[0].getBuffer(), planes[1].getBuffer(), planes[2].getBuffer(), planes[0].getRowStride(), planes[1].getRowStride(), planes[1].getPixelStride());
                    } else {
                        C1134i.Log(6, "Camera2: Wrong image format.");
                    }
                    if (C1128c.this.f424s != null) {
                        C1128c.this.f424s.close();
                    }
                    C1128c.this.f424s = imageAcquireNextImage;
                }
                C1128c.f404e.release();
            }
        }
    };

    private final SurfaceTexture.OnFrameAvailableListener f408D = new SurfaceTexture.OnFrameAvailableListener() {
        @Override
        public final void onFrameAvailable(SurfaceTexture surfaceTexture) {
            C1128c.this.f409a.mo444a(surfaceTexture);
        }
    };

    private static final class a {

        public static final int f437a = 1;

        public static final int f438b = 2;

        public static final int f439c = 3;

        private static final int[] f440d = {1, 2, 3};
    }

    protected C1128c(InterfaceC1131f interfaceC1131f) {
        this.f409a = null;
        this.f409a = interfaceC1131f;
        m554g();
    }

    public static int m528a(Context context) {
        return m548c(context).length;
    }

    public static int m529a(Context context, int i) {
        try {
            return ((Integer) m541b(context).getCameraCharacteristics(m548c(context)[i]).get(CameraCharacteristics.SENSOR_ORIENTATION)).intValue();
        } catch (CameraAccessException e) {
            C1134i.Log(6, "Camera2: CameraAccessException " + e);
            return 0;
        }
    }

    private static int m530a(Range[] rangeArr, int i) {
        int i2 = -1;
        double d = Double.MAX_VALUE;
        for (int i3 = 0; i3 < rangeArr.length; i3++) {
            int iIntValue = ((Integer) rangeArr[i3].getLower()).intValue();
            int iIntValue2 = ((Integer) rangeArr[i3].getUpper()).intValue();
            float f = i;
            if (f + 0.1f > iIntValue && f - 0.1f < iIntValue2) {
                return i;
            }
            double dMin = Math.min(Math.abs(i - iIntValue), Math.abs(i - iIntValue2));
            if (dMin < d) {
                i2 = i3;
                d = dMin;
            }
        }
        return ((Integer) (i > ((Integer) rangeArr[i2].getUpper()).intValue() ? rangeArr[i2].getUpper() : rangeArr[i2].getLower())).intValue();
    }

    private static Rect m531a(Size[] sizeArr, double d, double d2) {
        double d3 = Double.MAX_VALUE;
        int i = 0;
        int i2 = 0;
        for (int i3 = 0; i3 < sizeArr.length; i3++) {
            int width = sizeArr[i3].getWidth();
            int height = sizeArr[i3].getHeight();
            double dAbs = Math.abs(Math.log(d / ((double) width))) + Math.abs(Math.log(d2 / ((double) height)));
            if (dAbs < d3) {
                i = width;
                i2 = height;
                d3 = dAbs;
            }
            C1134i.Log(4, "Camera2: FrameSize " + width + " x " + height + " [" + dAbs + "]");
        }
        return new Rect(0, 0, i, i2);
    }

    public void m537a(CameraDevice cameraDevice) {
        synchronized (this.f427v) {
            this.f426u = null;
        }
        cameraDevice.close();
        this.f410d = null;
    }

    public void m539a(Object obj) {
        if (obj != "Focus") {
            if (obj == "Cancel focus") {
                C1134i.Log(4, "Camera2: Focus canceled.");
                synchronized (this.f427v) {
                    if (this.f426u != null) {
                        m560j();
                    }
                }
                return;
            }
            return;
        }
        C1134i.Log(4, "Camera2: Focus completed.");
        this.f421p = false;
        synchronized (this.f427v) {
            if (this.f426u != null) {
                try {
                    this.f425t.set(CaptureRequest.CONTROL_AF_TRIGGER, 0);
                    this.f425t.setTag("Regular");
                    this.f426u.setRepeatingRequest(this.f425t.build(), this.f405A, this.f412g);
                } catch (CameraAccessException e) {
                    C1134i.Log(6, "Camera2: CameraAccessException " + e);
                }
            }
        }
    }

    private static Size[] m540a(CameraCharacteristics cameraCharacteristics) {
        String str;
        StreamConfigurationMap streamConfigurationMap = (StreamConfigurationMap) cameraCharacteristics.get(CameraCharacteristics.SCALER_STREAM_CONFIGURATION_MAP);
        if (streamConfigurationMap == null) {
            str = "Camera2: configuration map is not available.";
        } else {
            Size[] outputSizes = streamConfigurationMap.getOutputSizes(35);
            if (outputSizes != null && outputSizes.length != 0) {
                return outputSizes;
            }
            str = "Camera2: output sizes for YUV_420_888 format are not avialable.";
        }
        C1134i.Log(6, str);
        return null;
    }

    private static CameraManager m541b(Context context) {
        if (f402b == null) {
            f402b = (CameraManager) context.getSystemService("camera");
        }
        return f402b;
    }

    private void m543b(CameraCharacteristics cameraCharacteristics) {
        int iIntValue = ((Integer) cameraCharacteristics.get(CameraCharacteristics.CONTROL_MAX_REGIONS_AF)).intValue();
        this.f416k = iIntValue;
        if (iIntValue > 0) {
            Rect rect = (Rect) cameraCharacteristics.get(CameraCharacteristics.SENSOR_INFO_ACTIVE_ARRAY_SIZE);
            this.f414i = rect;
            float fWidth = rect.width() / this.f414i.height();
            float fWidth2 = this.f413h.width() / this.f413h.height();
            if (fWidth2 > fWidth) {
                this.f419n = 0;
                this.f420o = (int) ((this.f414i.height() - (this.f414i.width() / fWidth2)) / 2.0f);
            } else {
                this.f420o = 0;
                this.f419n = (int) ((this.f414i.width() - (this.f414i.height() * fWidth2)) / 2.0f);
            }
            this.f415j = Math.min(this.f414i.width(), this.f414i.height()) / 20;
        }
    }

    public static boolean m545b(Context context, int i) {
        try {
            return ((Integer) m541b(context).getCameraCharacteristics(m548c(context)[i]).get(CameraCharacteristics.LENS_FACING)).intValue() == 0;
        } catch (CameraAccessException e) {
            C1134i.Log(6, "Camera2: CameraAccessException " + e);
            return false;
        }
    }

    public static boolean m547c(Context context, int i) {
        try {
            return ((Integer) m541b(context).getCameraCharacteristics(m548c(context)[i]).get(CameraCharacteristics.CONTROL_MAX_REGIONS_AF)).intValue() > 0;
        } catch (CameraAccessException e) {
            C1134i.Log(6, "Camera2: CameraAccessException " + e);
            return false;
        }
    }

    private static String[] m548c(Context context) {
        if (f403c == null) {
            try {
                f403c = m541b(context).getCameraIdList();
            } catch (CameraAccessException e) {
                C1134i.Log(6, "Camera2: CameraAccessException " + e);
                f403c = new String[0];
            }
        }
        return f403c;
    }

    public static int[] m550d(Context context, int i) {
        try {
            Size[] sizeArrM540a = m540a(m541b(context).getCameraCharacteristics(m548c(context)[i]));
            if (sizeArrM540a == null) {
                return null;
            }
            int[] iArr = new int[sizeArrM540a.length * 2];
            for (int i2 = 0; i2 < sizeArrM540a.length; i2++) {
                int i3 = i2 * 2;
                iArr[i3] = sizeArrM540a[i2].getWidth();
                iArr[i3 + 1] = sizeArrM540a[i2].getHeight();
            }
            return iArr;
        } catch (CameraAccessException e) {
            C1134i.Log(6, "Camera2: CameraAccessException " + e);
            return null;
        }
    }

    private void m554g() {
        HandlerThread handlerThread = new HandlerThread("CameraBackground");
        this.f411f = handlerThread;
        handlerThread.start();
        this.f412g = new Handler(this.f411f.getLooper());
    }

    private void m557h() {
        this.f411f.quit();
        try {
            this.f411f.join(4000L);
            this.f411f = null;
            this.f412g = null;
        } catch (InterruptedException e) {
            this.f411f.interrupt();
            C1134i.Log(6, "Camera2: Interrupted while waiting for the background thread to finish " + e);
        }
    }

    private void m559i() {
        try {
            if (!f404e.tryAcquire(4L, TimeUnit.SECONDS)) {
                C1134i.Log(5, "Camera2: Timeout waiting to lock camera for closing.");
                return;
            }
            this.f410d.close();
            try {
                if (!f404e.tryAcquire(4L, TimeUnit.SECONDS)) {
                    C1134i.Log(5, "Camera2: Timeout waiting to close camera.");
                }
            } catch (InterruptedException e) {
                C1134i.Log(6, "Camera2: Interrupted while waiting to close camera " + e);
            }
            this.f410d = null;
            f404e.release();
        } catch (InterruptedException e2) {
            C1134i.Log(6, "Camera2: Interrupted while trying to lock camera for closing " + e2);
        }
    }

    public void m560j() {
        try {
            if (this.f416k != 0) {
                float f = this.f417l;
                if (f >= 0.0f && f <= 1.0f) {
                    float f2 = this.f418m;
                    if (f2 >= 0.0f && f2 <= 1.0f) {
                        this.f421p = true;
                        int iWidth = this.f414i.width();
                        int i = this.f419n;
                        int i2 = (int) (((iWidth - (i * 2)) * this.f417l) + i);
                        int iHeight = this.f414i.height();
                        int i3 = this.f420o;
                        int i4 = (int) ((((double) (iHeight - (i3 * 2))) * (1.0d - ((double) this.f418m))) + ((double) i3));
                        int iMax = Math.max(this.f415j + 1, Math.min(i2, (this.f414i.width() - this.f415j) - 1));
                        int iMax2 = Math.max(this.f415j + 1, Math.min(i4, (this.f414i.height() - this.f415j) - 1));
                        CaptureRequest.Builder builder = this.f425t;
                        CaptureRequest.Key key = CaptureRequest.CONTROL_AF_REGIONS;
                        int i5 = this.f415j;
                        builder.set(key, new MeteringRectangle[]{new MeteringRectangle(iMax - i5, iMax2 - i5, i5 * 2, i5 * 2, 999)});
                        this.f425t.set(CaptureRequest.CONTROL_AF_MODE, 1);
                        this.f425t.set(CaptureRequest.CONTROL_AF_TRIGGER, 1);
                        this.f425t.setTag("Focus");
                        this.f426u.capture(this.f425t.build(), this.f405A, this.f412g);
                        return;
                    }
                }
            }
            this.f425t.set(CaptureRequest.CONTROL_AF_MODE, 4);
            this.f425t.setTag("Regular");
            CameraCaptureSession cameraCaptureSession = this.f426u;
            if (cameraCaptureSession != null) {
                cameraCaptureSession.setRepeatingRequest(this.f425t.build(), this.f405A, this.f412g);
            }
        } catch (CameraAccessException e) {
            C1134i.Log(6, "Camera2: CameraAccessException " + e);
        }
    }

    private void m561k() {
        try {
            CameraCaptureSession cameraCaptureSession = this.f426u;
            if (cameraCaptureSession != null) {
                cameraCaptureSession.stopRepeating();
                this.f425t.set(CaptureRequest.CONTROL_AF_TRIGGER, 2);
                this.f425t.set(CaptureRequest.CONTROL_AF_MODE, 0);
                this.f425t.setTag("Cancel focus");
                this.f426u.capture(this.f425t.build(), this.f405A, this.f412g);
            }
        } catch (CameraAccessException e) {
            C1134i.Log(6, "Camera2: CameraAccessException " + e);
        }
    }

    public final Rect m562a() {
        return this.f413h;
    }

    public final boolean m563a(float f, float f2) {
        if (this.f416k <= 0) {
            return false;
        }
        if (this.f421p) {
            C1134i.Log(5, "Camera2: Setting manual focus point already started.");
            return false;
        }
        this.f417l = f;
        this.f418m = f2;
        synchronized (this.f427v) {
            if (this.f426u != null && this.f431z != a.f438b) {
                m561k();
            }
        }
        return true;
    }

    public final boolean m564a(Context context, int i, int i2, int i3, int i4, int i5) {
        try {
            CameraCharacteristics cameraCharacteristics = f402b.getCameraCharacteristics(m548c(context)[i]);
            C1134i.Log(4, "Camera2: Hardware level: " + cameraCharacteristics.get(CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL));
            if (((Integer) cameraCharacteristics.get(CameraCharacteristics.INFO_SUPPORTED_HARDWARE_LEVEL)).intValue() == 2) {
                C1134i.Log(5, "Camera2: only LEGACY hardware level is supported.");
                return false;
            }
            Size[] sizeArrM540a = m540a(cameraCharacteristics);
            if (sizeArrM540a != null && sizeArrM540a.length != 0) {
                this.f413h = m531a(sizeArrM540a, i2, i3);
                Range[] rangeArr = (Range[]) cameraCharacteristics.get(CameraCharacteristics.CONTROL_AE_AVAILABLE_TARGET_FPS_RANGES);
                if (rangeArr == null || rangeArr.length == 0) {
                    C1134i.Log(6, "Camera2: target FPS ranges are not avialable.");
                } else {
                    int iM530a = m530a(rangeArr, i4);
                    C1134i.Log(4, "Camera2: FPS requested: " + i4 + " set: " + iM530a);
                    this.f422q = new Range(Integer.valueOf(iM530a), Integer.valueOf(iM530a));
                    try {
                        if (!f404e.tryAcquire(4L, TimeUnit.SECONDS)) {
                            C1134i.Log(5, "Camera2: Timeout waiting to lock camera for opening.");
                            return false;
                        }
                        try {
                            f402b.openCamera(m548c(context)[i], this.f406B, this.f412g);
                            try {
                                if (!f404e.tryAcquire(4L, TimeUnit.SECONDS)) {
                                    C1134i.Log(5, "Camera2: Timeout waiting to open camera.");
                                    return false;
                                }
                                f404e.release();
                                this.f428w = i5;
                                m543b(cameraCharacteristics);
                                return this.f410d != null;
                            } catch (InterruptedException e) {
                                C1134i.Log(6, "Camera2: Interrupted while waiting to open camera " + e);
                            }
                        } catch (CameraAccessException e2) {
                            C1134i.Log(6, "Camera2: CameraAccessException " + e2);
                            f404e.release();
                            return false;
                        }
                    } catch (InterruptedException e3) {
                        C1134i.Log(6, "Camera2: Interrupted while trying to lock camera for opening " + e3);
                        return false;
                    }
                }
            }
            return false;
        } catch (CameraAccessException e4) {
            C1134i.Log(6, "Camera2: CameraAccessException " + e4);
            return false;
        }
    }

    public final void m565b() {
        C1134i.Log(4, "Camera2: Close.");
        if (this.f410d != null) {
            m568e();
            m559i();
            this.f405A = null;
            this.f430y = null;
            this.f429x = null;
            Image image = this.f424s;
            if (image != null) {
                image.close();
                this.f424s = null;
            }
            ImageReader imageReader = this.f423r;
            if (imageReader != null) {
                imageReader.close();
                this.f423r = null;
            }
        }
        m557h();
    }

    public final void m566c() {
        C1134i.Log(4, "Camera2: Start preview.");
        if (this.f423r == null) {
            ImageReader imageReaderNewInstance = ImageReader.newInstance(this.f413h.width(), this.f413h.height(), 35, 2);
            this.f423r = imageReaderNewInstance;
            imageReaderNewInstance.setOnImageAvailableListener(this.f407C, this.f412g);
            this.f424s = null;
            if (this.f428w != 0) {
                SurfaceTexture surfaceTexture = new SurfaceTexture(this.f428w);
                this.f429x = surfaceTexture;
                surfaceTexture.setDefaultBufferSize(this.f413h.width(), this.f413h.height());
                this.f429x.setOnFrameAvailableListener(this.f408D, this.f412g);
                this.f430y = new Surface(this.f429x);
            }
        }
        try {
            if (this.f426u == null) {
                CameraDevice cameraDevice = this.f410d;
                Surface surface = this.f430y;
                cameraDevice.createCaptureSession(surface != null ? Arrays.asList(surface, this.f423r.getSurface()) : Arrays.asList(this.f423r.getSurface()), new CameraCaptureSession.StateCallback() {
                    @Override
                    public final void onConfigureFailed(CameraCaptureSession cameraCaptureSession) {
                        C1134i.Log(6, "Camera2: CaptureSession configuration failed.");
                    }

                    @Override
                    public final void onConfigured(CameraCaptureSession cameraCaptureSession) {
                        C1134i.Log(4, "Camera2: CaptureSession is configured.");
                        if (C1128c.this.f410d == null) {
                            return;
                        }
                        synchronized (C1128c.this.f427v) {
                            C1128c.this.f426u = cameraCaptureSession;
                            try {
                                C1128c c1128c = C1128c.this;
                                c1128c.f425t = c1128c.f410d.createCaptureRequest(1);
                                if (C1128c.this.f430y != null) {
                                    C1128c.this.f425t.addTarget(C1128c.this.f430y);
                                }
                                C1128c.this.f425t.addTarget(C1128c.this.f423r.getSurface());
                                C1128c.this.f425t.set(CaptureRequest.CONTROL_AE_TARGET_FPS_RANGE, C1128c.this.f422q);
                                C1128c.this.m560j();
                            } catch (CameraAccessException e) {
                                C1134i.Log(6, "Camera2: CameraAccessException " + e);
                            }
                        }
                    }
                }, this.f412g);
            } else if (this.f431z == a.f438b) {
                this.f426u.setRepeatingRequest(this.f425t.build(), this.f405A, this.f412g);
            }
            this.f431z = a.f437a;
        } catch (CameraAccessException e) {
            C1134i.Log(6, "Camera2: CameraAccessException " + e);
        }
    }

    public final void m567d() {
        C1134i.Log(4, "Camera2: Pause preview.");
        synchronized (this.f427v) {
            CameraCaptureSession cameraCaptureSession = this.f426u;
            if (cameraCaptureSession != null) {
                try {
                    cameraCaptureSession.stopRepeating();
                    this.f431z = a.f438b;
                } catch (CameraAccessException e) {
                    C1134i.Log(6, "Camera2: CameraAccessException " + e);
                }
            }
        }
    }

    public final void m568e() {
        C1134i.Log(4, "Camera2: Stop preview.");
        synchronized (this.f427v) {
            CameraCaptureSession cameraCaptureSession = this.f426u;
            if (cameraCaptureSession != null) {
                try {
                    cameraCaptureSession.abortCaptures();
                } catch (CameraAccessException e) {
                    C1134i.Log(6, "Camera2: CameraAccessException " + e);
                }
                this.f426u.close();
                this.f426u = null;
                this.f431z = a.f439c;
            }
        }
    }
}
