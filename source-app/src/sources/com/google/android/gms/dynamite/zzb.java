package com.google.android.gms.dynamite;

import android.os.Looper;
import android.util.Log;

public final class zzb {
    private static ClassLoader zza;
    private static Thread zzb;

    public static synchronized ClassLoader zza() {
        SecurityException e;
        Thread thread;
        ThreadGroup threadGroup;
        if (zza == null) {
            Thread thread2 = zzb;
            ClassLoader contextClassLoader = null;
            if (thread2 != null) {
                synchronized (thread2) {
                    try {
                        contextClassLoader = zzb.getContextClassLoader();
                    } catch (SecurityException e2) {
                        String message = e2.getMessage();
                        StringBuilder sb = new StringBuilder(String.valueOf(message).length() + 41);
                        sb.append("Failed to get thread context classloader ");
                        sb.append(message);
                        Log.w("DynamiteLoaderV2CL", sb.toString());
                    }
                }
                zza = contextClassLoader;
            } else {
                ThreadGroup threadGroup2 = Looper.getMainLooper().getThread().getThreadGroup();
                if (threadGroup2 == null) {
                    thread2 = null;
                } else {
                    synchronized (Void.class) {
                        try {
                            int iActiveGroupCount = threadGroup2.activeGroupCount();
                            ThreadGroup[] threadGroupArr = new ThreadGroup[iActiveGroupCount];
                            threadGroup2.enumerate(threadGroupArr);
                            int i = 0;
                            int i2 = 0;
                            while (true) {
                                if (i2 >= iActiveGroupCount) {
                                    threadGroup = null;
                                    break;
                                }
                                threadGroup = threadGroupArr[i2];
                                if ("dynamiteLoader".equals(threadGroup.getName())) {
                                    break;
                                }
                                i2++;
                            }
                            if (threadGroup == null) {
                                threadGroup = new ThreadGroup(threadGroup2, "dynamiteLoader");
                            }
                            int iActiveCount = threadGroup.activeCount();
                            Thread[] threadArr = new Thread[iActiveCount];
                            threadGroup.enumerate(threadArr);
                            while (true) {
                                if (i >= iActiveCount) {
                                    thread = null;
                                    break;
                                }
                                thread = threadArr[i];
                                if ("GmsDynamite".equals(thread.getName())) {
                                    break;
                                }
                                i++;
                            }
                            if (thread == null) {
                                try {
                                    zza zzaVar = new zza(threadGroup, "GmsDynamite");
                                    try {
                                        zzaVar.setContextClassLoader(null);
                                        zzaVar.start();
                                        thread = zzaVar;
                                    } catch (SecurityException e3) {
                                        e = e3;
                                        thread = zzaVar;
                                        String message2 = e.getMessage();
                                        StringBuilder sb2 = new StringBuilder(String.valueOf(message2).length() + 39);
                                        sb2.append("Failed to enumerate thread/threadgroup ");
                                        sb2.append(message2);
                                        Log.w("DynamiteLoaderV2CL", sb2.toString());
                                    }
                                } catch (SecurityException e4) {
                                    e = e4;
                                }
                            }
                        } catch (SecurityException e5) {
                            e = e5;
                            thread = null;
                        }
                    }
                    thread2 = thread;
                }
                zzb = thread2;
                if (thread2 != null) {
                    synchronized (thread2) {
                        contextClassLoader = zzb.getContextClassLoader();
                    }
                }
                zza = contextClassLoader;
            }
        }
        return zza;
    }
}
