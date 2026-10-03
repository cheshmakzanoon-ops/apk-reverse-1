package com.unity3d.player;

import android.app.Activity;
import android.content.Context;
import android.content.res.AssetFileDescriptor;
import android.media.MediaPlayer;
import android.net.Uri;
import android.util.DisplayMetrics;
import android.util.Log;
import android.view.Display;
import android.view.KeyEvent;
import android.view.MotionEvent;
import android.view.SurfaceHolder;
import android.view.SurfaceView;
import android.view.WindowManager;
import android.widget.FrameLayout;
import android.widget.MediaController;
import java.io.FileInputStream;
import java.io.IOException;

public final class SurfaceHolderCallbackC1144s extends FrameLayout implements MediaPlayer.OnBufferingUpdateListener, MediaPlayer.OnCompletionListener, MediaPlayer.OnPreparedListener, MediaPlayer.OnVideoSizeChangedListener, SurfaceHolder.Callback, MediaController.MediaPlayerControl {

    private static boolean f491a;

    private final Context f492b;

    private final SurfaceView f493c;

    private final SurfaceHolder f494d;

    private final String f495e;

    private final int f496f;

    private final int f497g;

    private final boolean f498h;

    private final long f499i;

    private final long f500j;

    private final FrameLayout f501k;

    private final Display f502l;

    private int f503m;

    private int f504n;

    private int f505o;

    private int f506p;

    private MediaPlayer f507q;

    private MediaController f508r;

    private boolean f509s;

    private boolean f510t;

    private int f511u;

    private boolean f512v;

    private boolean f513w;

    private a f514x;

    private b f515y;

    private volatile int f516z;

    public interface a {
        void mo699a(int i);
    }

    public class b implements Runnable {

        private SurfaceHolderCallbackC1144s f518b;

        private boolean f519c = false;

        public b(SurfaceHolderCallbackC1144s surfaceHolderCallbackC1144s) {
            this.f518b = surfaceHolderCallbackC1144s;
        }

        public final void m700a() {
            this.f519c = true;
        }

        @Override
        public final void run() {
            try {
                Thread.sleep(5000L);
            } catch (InterruptedException unused) {
                Thread.currentThread().interrupt();
            }
            if (this.f519c) {
                return;
            }
            if (SurfaceHolderCallbackC1144s.f491a) {
                SurfaceHolderCallbackC1144s.m694b("Stopping the video player due to timeout.");
            }
            this.f518b.CancelOnPrepare();
        }
    }

    protected SurfaceHolderCallbackC1144s(Context context, String str, int i, int i2, int i3, boolean z, long j, long j2, a aVar) {
        super(context);
        this.f509s = false;
        this.f510t = false;
        this.f511u = 0;
        this.f512v = false;
        this.f513w = false;
        this.f516z = 0;
        this.f514x = aVar;
        this.f492b = context;
        this.f501k = this;
        SurfaceView surfaceView = new SurfaceView(context);
        this.f493c = surfaceView;
        SurfaceHolder holder = surfaceView.getHolder();
        this.f494d = holder;
        holder.addCallback(this);
        setBackgroundColor(i);
        addView(surfaceView);
        this.f502l = ((WindowManager) context.getSystemService("window")).getDefaultDisplay();
        this.f495e = str;
        this.f496f = i2;
        this.f497g = i3;
        this.f498h = z;
        this.f499i = j;
        this.f500j = j2;
        if (f491a) {
            m694b("fileName: " + str);
        }
        if (f491a) {
            m694b("backgroundColor: " + i);
        }
        if (f491a) {
            m694b("controlMode: " + i2);
        }
        if (f491a) {
            m694b("scalingMode: " + i3);
        }
        if (f491a) {
            m694b("isURL: " + z);
        }
        if (f491a) {
            m694b("videoOffset: " + j);
        }
        if (f491a) {
            m694b("videoLength: " + j2);
        }
        setFocusable(true);
        setFocusableInTouchMode(true);
    }

    private void m692a(int i) {
        this.f516z = i;
        a aVar = this.f514x;
        if (aVar != null) {
            aVar.mo699a(this.f516z);
        }
    }

    public static void m694b(String str) {
        Log.i("Video", "VideoPlayer: " + str);
    }

    private void m696c() {
        FileInputStream fileInputStream;
        MediaPlayer mediaPlayer = this.f507q;
        if (mediaPlayer != null) {
            mediaPlayer.setDisplay(this.f494d);
            if (this.f512v) {
                return;
            }
            if (f491a) {
                m694b("Resuming playback");
            }
            this.f507q.start();
            return;
        }
        m692a(0);
        doCleanUp();
        try {
            MediaPlayer mediaPlayer2 = new MediaPlayer();
            this.f507q = mediaPlayer2;
            if (this.f498h) {
                mediaPlayer2.setDataSource(this.f492b, Uri.parse(this.f495e));
            } else {
                if (this.f500j != 0) {
                    fileInputStream = new FileInputStream(this.f495e);
                    this.f507q.setDataSource(fileInputStream.getFD(), this.f499i, this.f500j);
                } else {
                    try {
                        AssetFileDescriptor assetFileDescriptorOpenFd = getResources().getAssets().openFd(this.f495e);
                        this.f507q.setDataSource(assetFileDescriptorOpenFd.getFileDescriptor(), assetFileDescriptorOpenFd.getStartOffset(), assetFileDescriptorOpenFd.getLength());
                        assetFileDescriptorOpenFd.close();
                    } catch (IOException unused) {
                        fileInputStream = new FileInputStream(this.f495e);
                        this.f507q.setDataSource(fileInputStream.getFD());
                        fileInputStream.close();
                    }
                }
                fileInputStream.close();
            }
            this.f507q.setDisplay(this.f494d);
            this.f507q.setScreenOnWhilePlaying(true);
            this.f507q.setOnBufferingUpdateListener(this);
            this.f507q.setOnCompletionListener(this);
            this.f507q.setOnPreparedListener(this);
            this.f507q.setOnVideoSizeChangedListener(this);
            this.f507q.setAudioStreamType(3);
            this.f507q.prepareAsync();
            this.f515y = new b(this);
            new Thread(this.f515y).start();
        } catch (Exception e) {
            if (f491a) {
                m694b("error: " + e.getMessage() + e);
            }
            m692a(2);
        }
    }

    private void m697d() {
        if (isPlaying()) {
            return;
        }
        m692a(1);
        if (f491a) {
            m694b("startVideoPlayback");
        }
        updateVideoLayout();
        if (this.f512v) {
            return;
        }
        start();
    }

    public final void CancelOnPrepare() {
        m692a(2);
    }

    final boolean m698a() {
        return this.f512v;
    }

    @Override
    public final boolean canPause() {
        return true;
    }

    @Override
    public final boolean canSeekBackward() {
        return true;
    }

    @Override
    public final boolean canSeekForward() {
        return true;
    }

    protected final void destroyPlayer() {
        if (f491a) {
            m694b("destroyPlayer");
        }
        if (!this.f512v) {
            pause();
        }
        doCleanUp();
    }

    protected final void doCleanUp() {
        b bVar = this.f515y;
        if (bVar != null) {
            bVar.m700a();
            this.f515y = null;
        }
        MediaPlayer mediaPlayer = this.f507q;
        if (mediaPlayer != null) {
            mediaPlayer.release();
            this.f507q = null;
        }
        this.f505o = 0;
        this.f506p = 0;
        this.f510t = false;
        this.f509s = false;
    }

    @Override
    public final int getAudioSessionId() {
        MediaPlayer mediaPlayer = this.f507q;
        if (mediaPlayer == null) {
            return 0;
        }
        return mediaPlayer.getAudioSessionId();
    }

    @Override
    public final int getBufferPercentage() {
        if (this.f498h) {
            return this.f511u;
        }
        return 100;
    }

    @Override
    public final int getCurrentPosition() {
        MediaPlayer mediaPlayer = this.f507q;
        if (mediaPlayer == null) {
            return 0;
        }
        return mediaPlayer.getCurrentPosition();
    }

    @Override
    public final int getDuration() {
        MediaPlayer mediaPlayer = this.f507q;
        if (mediaPlayer == null) {
            return 0;
        }
        return mediaPlayer.getDuration();
    }

    @Override
    public final boolean isPlaying() {
        boolean z = this.f510t && this.f509s;
        MediaPlayer mediaPlayer = this.f507q;
        if (mediaPlayer == null) {
            return !z;
        }
        return mediaPlayer.isPlaying() || !z;
    }

    @Override
    public final void onBufferingUpdate(MediaPlayer mediaPlayer, int i) {
        if (f491a) {
            m694b("onBufferingUpdate percent:" + i);
        }
        this.f511u = i;
    }

    @Override
    public final void onCompletion(MediaPlayer mediaPlayer) {
        if (f491a) {
            m694b("onCompletion called");
        }
        destroyPlayer();
        m692a(3);
    }

    @Override
    public final boolean onKeyDown(int i, KeyEvent keyEvent) {
        if (i != 4 && (this.f496f != 2 || i == 0 || keyEvent.isSystem())) {
            MediaController mediaController = this.f508r;
            return mediaController != null ? mediaController.onKeyDown(i, keyEvent) : super.onKeyDown(i, keyEvent);
        }
        destroyPlayer();
        m692a(3);
        return true;
    }

    @Override
    public final void onPrepared(MediaPlayer mediaPlayer) {
        if (f491a) {
            m694b("onPrepared called");
        }
        b bVar = this.f515y;
        if (bVar != null) {
            bVar.m700a();
            this.f515y = null;
        }
        int i = this.f496f;
        if (i == 0 || i == 1) {
            MediaController mediaController = new MediaController(this.f492b);
            this.f508r = mediaController;
            mediaController.setMediaPlayer(this);
            this.f508r.setAnchorView(this);
            this.f508r.setEnabled(true);
            Context context = this.f492b;
            if (context instanceof Activity) {
                this.f508r.setSystemUiVisibility(((Activity) context).getWindow().getDecorView().getSystemUiVisibility());
            }
            this.f508r.show();
        }
        this.f510t = true;
        if (this.f509s) {
            m697d();
        }
    }

    @Override
    public final boolean onTouchEvent(MotionEvent motionEvent) {
        int action = motionEvent.getAction() & 255;
        if (this.f496f != 2 || action != 0) {
            MediaController mediaController = this.f508r;
            return mediaController != null ? mediaController.onTouchEvent(motionEvent) : super.onTouchEvent(motionEvent);
        }
        destroyPlayer();
        m692a(3);
        return true;
    }

    @Override
    public final void onVideoSizeChanged(MediaPlayer mediaPlayer, int i, int i2) {
        if (f491a) {
            m694b("onVideoSizeChanged called " + i + "x" + i2);
        }
        if (i != 0 && i2 != 0) {
            this.f509s = true;
            this.f505o = i;
            this.f506p = i2;
            if (this.f510t) {
                m697d();
                return;
            }
            return;
        }
        if (f491a) {
            m694b("invalid video width(" + i + ") or height(" + i2 + ")");
        }
    }

    @Override
    public final void pause() {
        MediaPlayer mediaPlayer = this.f507q;
        if (mediaPlayer == null) {
            return;
        }
        if (this.f513w) {
            mediaPlayer.pause();
        }
        this.f512v = true;
    }

    @Override
    public final void seekTo(int i) {
        MediaPlayer mediaPlayer = this.f507q;
        if (mediaPlayer == null) {
            return;
        }
        mediaPlayer.seekTo(i);
    }

    @Override
    public final void start() {
        if (f491a) {
            m694b("Start");
        }
        MediaPlayer mediaPlayer = this.f507q;
        if (mediaPlayer == null) {
            return;
        }
        if (this.f513w) {
            mediaPlayer.start();
        }
        this.f512v = false;
    }

    @Override
    public final void surfaceChanged(SurfaceHolder surfaceHolder, int i, int i2, int i3) {
        if (f491a) {
            m694b("surfaceChanged called " + i + " " + i2 + "x" + i3);
        }
        if (this.f503m == i2 && this.f504n == i3) {
            return;
        }
        this.f503m = i2;
        this.f504n = i3;
        if (this.f513w) {
            updateVideoLayout();
        }
    }

    @Override
    public final void surfaceCreated(SurfaceHolder surfaceHolder) {
        if (f491a) {
            m694b("surfaceCreated called");
        }
        this.f513w = true;
        m696c();
    }

    @Override
    public final void surfaceDestroyed(SurfaceHolder surfaceHolder) {
        if (f491a) {
            m694b("surfaceDestroyed called");
        }
        this.f513w = false;
    }

    protected final void updateVideoLayout() {
        if (f491a) {
            m694b("updateVideoLayout");
        }
        if (this.f507q == null) {
            return;
        }
        if (this.f503m == 0 || this.f504n == 0) {
            WindowManager windowManager = (WindowManager) this.f492b.getSystemService("window");
            DisplayMetrics displayMetrics = new DisplayMetrics();
            windowManager.getDefaultDisplay().getMetrics(displayMetrics);
            this.f503m = displayMetrics.widthPixels;
            this.f504n = displayMetrics.heightPixels;
        }
        int i = this.f503m;
        int i2 = this.f504n;
        if (this.f509s) {
            int i3 = this.f505o;
            int i4 = this.f506p;
            float f = i3 / i4;
            float f2 = i / i2;
            int i5 = this.f497g;
            if (i5 == 1) {
                if (f2 <= f) {
                    i2 = (int) (i / f);
                } else {
                    i = (int) (i2 * f);
                }
            } else if (i5 == 2) {
                if (f2 >= f) {
                    i2 = (int) (i / f);
                } else {
                    i = (int) (i2 * f);
                }
            } else if (i5 == 0) {
                i = i3;
                i2 = i4;
            }
        } else if (f491a) {
            m694b("updateVideoLayout: Video size is not known yet");
        }
        if (this.f503m == i && this.f504n == i2) {
            return;
        }
        if (f491a) {
            m694b("frameWidth = " + i + "; frameHeight = " + i2);
        }
        this.f501k.updateViewLayout(this.f493c, new FrameLayout.LayoutParams(i, i2, 17));
    }
}
