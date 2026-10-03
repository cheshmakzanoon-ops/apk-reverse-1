package com.joke.plugin.bmJiasu.xhook.call;

import android.content.Context;
import android.os.Handler;
import android.os.HandlerThread;
import com.cheatfirst.cheatspeed.CheatPlusPlus;
import com.joke.plugin.bmJiasu.JiaSuModeConfig;
import com.joke.plugin.bmJiasu.xhook.JiaSuNewUtils;
import com.joke.speedfloatingball.utils.MLog;
import java.io.File;
import java.io.IOException;
import java.util.ArrayList;

public final class Call {
    private static final Call INSTANCE = new Call();
    private boolean callLibraryLoaded;
    private int currentMode = 1;
    private final Handler handler;
    private JiaSuNewUtils jiaSuNewUtils;

    public static Call getInstance() {
        return INSTANCE;
    }

    private Call() {
        HandlerThread thread = new HandlerThread("MetaZygoteChrono");
        thread.start();
        this.handler = new Handler(thread.getLooper());
    }

    public synchronized void init(Context context, int speedMode) {
        this.currentMode = JiaSuModeConfig.normalizeMode(speedMode);
        switch (this.currentMode) {
            case 2:
                initCoreTwo(context);
                break;
            case 3:
                initCoreThree(context);
                break;
            default:
                initCoreOne();
                break;
        }
    }

    private void initCoreOne() {
        if (this.callLibraryLoaded) {
            return;
        }
        try {
            System.loadLibrary("call");
            this.callLibraryLoaded = true;
        } catch (Throwable e) {
            this.callLibraryLoaded = false;
            MLog.m2e(e);
        }
    }

    private void initCoreTwo(Context context) {
        File[] nativeFiles;
        try {
            File nativeDir = new File(context.getApplicationInfo().nativeLibraryDir);
            CheatPlusPlus.ioctl(1003, null);
            if (nativeDir.exists() && (nativeFiles = nativeDir.listFiles()) != null) {
                ArrayList<String> loaders = getStringArrayList(nativeFiles);
                CheatPlusPlus.ioctl(1004, loaders.toArray(new String[0]));
            }
            CheatPlusPlus.ioctl(1001, context.getPackageName());
        } catch (Throwable e) {
            MLog.m2e(e);
        }
    }

    private void initCoreThree(Context context) {
        try {
            CheatPlusPlus.ioctl(1003, context);
            this.jiaSuNewUtils = new JiaSuNewUtils(context);
        } catch (Throwable e) {
            this.jiaSuNewUtils = null;
            MLog.m2e(e);
        }
    }

    public synchronized void start() {
        if (this.currentMode == 1) {
            if (!this.callLibraryLoaded) {
                return;
            }
            try {
                NativeHandler.getInstance().start();
            } catch (Throwable e) {
                MLog.m2e(e);
            }
        } else if (this.currentMode == 3) {
            this.handler.post(new Runnable() {
                @Override
                public final void run() {
                    this.f$0.lambda$start$0();
                }
            });
        }
    }

    public void lambda$start$0() {
        lambda$setSpeed$0(0.0d);
    }

    public synchronized void setSpeed(final double value) {
        try {
            switch (this.currentMode) {
                case 2:
                    try {
                        CheatPlusPlus.ioctl(1002, String.valueOf((long) value));
                        break;
                    } catch (Throwable e) {
                        MLog.m2e(e);
                    }
                    return;
                case 3:
                    this.handler.post(new Runnable() {
                        @Override
                        public final void run() {
                            this.f$0.lambda$setSpeed$0(value);
                        }
                    });
                    return;
                default:
                    if (this.callLibraryLoaded) {
                        try {
                            NativeHandler.getInstance().setSpeed((float) Math.ceil(value));
                            break;
                        } catch (Throwable e2) {
                            MLog.m2e(e2);
                        }
                        return;
                    }
                    return;
            }
        } catch (Throwable th) {
            throw th;
        }
    }

    public synchronized void stop() {
        try {
            switch (this.currentMode) {
                case 2:
                    try {
                        CheatPlusPlus.ioctl(1002, "0");
                        break;
                    } catch (Throwable e) {
                        MLog.m2e(e);
                    }
                    return;
                case 3:
                    this.handler.post(new Runnable() {
                        @Override
                        public final void run() {
                            this.f$0.lambda$stop$0();
                        }
                    });
                    return;
                default:
                    if (this.callLibraryLoaded) {
                        try {
                            NativeHandler.getInstance().stop();
                            break;
                        } catch (Throwable e2) {
                            MLog.m2e(e2);
                        }
                        return;
                    }
                    return;
            }
        } catch (Throwable th) {
            throw th;
        }
    }

    public void lambda$stop$0() {
        lambda$setSpeed$0(0.0d);
    }

    public void lambda$setSpeed$0(double ratio) {
        if (this.jiaSuNewUtils == null) {
            return;
        }
        try {
            this.jiaSuNewUtils.modifySpeed((long) ratio);
        } catch (Throwable e) {
            MLog.m2e(e);
        }
    }

    private static ArrayList<String> getStringArrayList(File[] nativeFiles) throws IOException {
        ArrayList<String> loaders = new ArrayList<>();
        for (File item : nativeFiles) {
            if (!"libc1stplusplus.so".equals(item.getName())) {
                if ("libunity.so".equals(item.getName())) {
                    loaders.clear();
                }
                String canonicalPath = item.getCanonicalPath();
                String absolutePath = item.getAbsolutePath();
                loaders.add(canonicalPath);
                if (!canonicalPath.equals(absolutePath)) {
                    loaders.add(absolutePath);
                }
                if ("libunity.so".equals(item.getName())) {
                    break;
                }
            }
        }
        return loaders;
    }
}
