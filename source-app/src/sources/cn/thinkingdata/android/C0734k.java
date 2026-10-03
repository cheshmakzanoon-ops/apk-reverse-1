package cn.thinkingdata.android;

import android.content.Context;
import android.content.res.Resources;
import android.os.Process;
import cn.thinkingdata.android.crash.CrashLogListener;
import cn.thinkingdata.android.utils.C0756g;
import cn.thinkingdata.android.utils.TDLog;
import com.facebook.internal.AnalyticsEvents;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.io.StringWriter;
import java.io.UnsupportedEncodingException;
import java.util.ArrayList;
import java.util.Arrays;
import org.json.JSONException;
import org.json.JSONObject;

public class C0734k {

    private static C0734k f214c;

    private final Context f215a;

    private boolean f216b;

    class a implements CrashLogListener {

        class C1128a implements ThinkingAnalyticsSDK.InterfaceC0708b {

            final String f217a;

            final File f218b;

            C1128a(a aVar, String str, File file) {
                this.f217a = str;
                this.f218b = file;
            }

            @Override
            public void mo435a(ThinkingAnalyticsSDK thinkingAnalyticsSDK) {
                if (thinkingAnalyticsSDK.shouldTrackCrash()) {
                    try {
                        JSONObject jSONObject = new JSONObject();
                        try {
                            if (this.f217a.getBytes("UTF-8").length > 16384) {
                                if (!TDPresetProperties.disableList.contains("#app_crashed_reason")) {
                                    jSONObject.put("#app_crashed_reason", new String(C0756g.m706a(this.f217a, 16384), "UTF-8"));
                                }
                            } else if (!TDPresetProperties.disableList.contains("#app_crashed_reason")) {
                                jSONObject.put("#app_crashed_reason", this.f217a);
                            }
                        } catch (UnsupportedEncodingException unused) {
                            if (this.f217a.length() > 8192 && !TDPresetProperties.disableList.contains("#app_crashed_reason")) {
                                jSONObject.put("#app_crashed_reason", this.f217a.substring(0, 8192));
                            }
                        }
                        thinkingAnalyticsSDK.trackAppCrashAndEndEvent(jSONObject);
                        this.f218b.delete();
                    } catch (JSONException unused2) {
                    }
                }
            }
        }

        a(C0734k c0734k) {
        }

        @Override
        public void onFile(File file) {
            ThinkingAnalyticsSDK.allInstances(new C1128a(this, C0734k.m649a(file).replaceAll("(\r\n|\n\r|\n|\r)", "<br>"), file));
        }
    }

    class b implements Runnable {
        b() {
        }

        @Override
        public void run() {
            C0734k c0734k = C0734k.this;
            c0734k.m650a(c0734k.f215a);
        }
    }

    class c implements CrashLogListener {

        class a implements ThinkingAnalyticsSDK.InterfaceC0708b {

            final String f220a;

            final File f221b;

            a(c cVar, String str, File file) {
                this.f220a = str;
                this.f221b = file;
            }

            @Override
            public void mo435a(ThinkingAnalyticsSDK thinkingAnalyticsSDK) {
                if (thinkingAnalyticsSDK.shouldTrackCrash()) {
                    try {
                        JSONObject jSONObject = new JSONObject();
                        try {
                            if (this.f220a.getBytes("UTF-8").length > 16384) {
                                if (!TDPresetProperties.disableList.contains("#app_crashed_reason")) {
                                    jSONObject.put("#app_crashed_reason", new String(C0756g.m706a(this.f220a, 16384), "UTF-8"));
                                }
                            } else if (!TDPresetProperties.disableList.contains("#app_crashed_reason")) {
                                jSONObject.put("#app_crashed_reason", this.f220a);
                            }
                        } catch (UnsupportedEncodingException unused) {
                            if (this.f220a.length() > 8192 && !TDPresetProperties.disableList.contains("#app_crashed_reason")) {
                                jSONObject.put("#app_crashed_reason", this.f220a.substring(0, 8192));
                            }
                        }
                        thinkingAnalyticsSDK.autoTrack("ta_app_crash", jSONObject);
                        this.f221b.delete();
                    } catch (JSONException unused2) {
                    }
                }
            }
        }

        c(C0734k c0734k) {
        }

        @Override
        public void onFile(File file) {
            ThinkingAnalyticsSDK.allInstances(new a(this, C0734k.m649a(file).replaceAll("(\r\n|\n\r|\n|\r)", "<br>"), file));
        }
    }

    private static class d implements Thread.UncaughtExceptionHandler {

        private final Thread.UncaughtExceptionHandler f222a = Thread.getDefaultUncaughtExceptionHandler();

        class a implements ThinkingAnalyticsSDK.InterfaceC0708b {

            final String f223a;

            a(d dVar, String str) {
                this.f223a = str;
            }

            @Override
            public void mo435a(ThinkingAnalyticsSDK thinkingAnalyticsSDK) {
                if (thinkingAnalyticsSDK.shouldTrackCrash()) {
                    try {
                        JSONObject jSONObject = new JSONObject();
                        try {
                            if (this.f223a.getBytes("UTF-8").length > 16384) {
                                if (!TDPresetProperties.disableList.contains("#app_crashed_reason")) {
                                    jSONObject.put("#app_crashed_reason", new String(C0756g.m706a(this.f223a, 16384), "UTF-8"));
                                }
                            } else if (!TDPresetProperties.disableList.contains("#app_crashed_reason")) {
                                jSONObject.put("#app_crashed_reason", this.f223a);
                            }
                        } catch (UnsupportedEncodingException unused) {
                            TDLog.m679d("ThinkingAnalytics.ExceptionHandler", "Exception occurred in getBytes. ");
                            if (this.f223a.length() > 8192 && !TDPresetProperties.disableList.contains("#app_crashed_reason")) {
                                jSONObject.put("#app_crashed_reason", this.f223a.substring(0, 8192));
                            }
                        }
                        thinkingAnalyticsSDK.trackAppCrashAndEndEvent(jSONObject);
                    } catch (JSONException unused2) {
                    }
                }
            }
        }

        d() {
            Thread.setDefaultUncaughtExceptionHandler(this);
        }

        private void m654a() {
            Process.killProcess(Process.myPid());
            System.exit(10);
        }

        private void m655a(Throwable th) {
            StringWriter stringWriter = new StringWriter();
            PrintWriter printWriter = new PrintWriter(stringWriter);
            do {
                th.printStackTrace(printWriter);
                th = th.getCause();
            } while (th != null);
            printWriter.close();
            ThinkingAnalyticsSDK.allInstances(new a(this, stringWriter.toString().replaceAll("(\r\n|\n\r|\n|\r)", "<br>")));
        }

        @Override
        public void uncaughtException(Thread thread, Throwable th) {
            Throwable cause = th;
            while (true) {
                if (cause == null) {
                    m655a(th);
                    try {
                        Thread.sleep(1000L);
                        break;
                    } catch (InterruptedException e) {
                        e.printStackTrace();
                        break;
                    }
                }
                if (cause instanceof C0736m) {
                    break;
                } else {
                    cause = cause.getCause();
                }
            }
            Thread.UncaughtExceptionHandler uncaughtExceptionHandler = this.f222a;
            if (uncaughtExceptionHandler != null) {
                uncaughtExceptionHandler.uncaughtException(thread, th);
            } else {
                m654a();
            }
        }
    }

    private C0734k(Context context) {
        this.f215a = context.getApplicationContext();
    }

    static String m649a(File file) throws Throwable {
        StringBuffer stringBuffer = new StringBuffer();
        BufferedReader bufferedReader = null;
        try {
            try {
                BufferedReader bufferedReader2 = new BufferedReader(new FileReader(file));
                while (true) {
                    try {
                        String line = bufferedReader2.readLine();
                        if (line == null) {
                            break;
                        }
                        stringBuffer.append(line);
                        stringBuffer.append("\n");
                    } catch (IOException e) {
                        e = e;
                        bufferedReader = bufferedReader2;
                        e.printStackTrace();
                        if (bufferedReader != null) {
                            try {
                                bufferedReader.close();
                            } catch (IOException e2) {
                                e2.printStackTrace();
                            }
                        }
                        return stringBuffer.toString();
                    } catch (Throwable th) {
                        th = th;
                        bufferedReader = bufferedReader2;
                        if (bufferedReader != null) {
                            try {
                                bufferedReader.close();
                            } catch (IOException e3) {
                                e3.printStackTrace();
                            }
                        }
                        throw th;
                    }
                }
                bufferedReader2.close();
                String string = stringBuffer.toString();
                try {
                    bufferedReader2.close();
                } catch (IOException e4) {
                    e4.printStackTrace();
                }
                return string;
            } catch (IOException e5) {
                e = e5;
            }
        } catch (Throwable th2) {
            th = th2;
        }
    }

    public void m650a(Context context) {
        File[] fileArrListFiles;
        String str = context.getCacheDir().getAbsolutePath() + File.separator + "tacrash";
        c cVar = new c(this);
        File file = new File(str);
        if (!file.exists() || (fileArrListFiles = file.listFiles()) == null) {
            return;
        }
        for (File file2 : fileArrListFiles) {
            cVar.onFile(file2);
        }
    }

    static C0734k m652b(Context context) {
        if (f214c == null) {
            if (context == null) {
                return null;
            }
            synchronized (d.class) {
                if (f214c == null) {
                    f214c = new C0734k(context);
                }
            }
        }
        return f214c;
    }

    synchronized void m653a() {
        if (!this.f216b) {
            ArrayList arrayList = new ArrayList();
            try {
                Resources resources = this.f215a.getResources();
                arrayList.addAll(Arrays.asList(resources.getStringArray(resources.getIdentifier("TACrashConfig", "array", this.f215a.getPackageName()))));
            } catch (Exception unused) {
            }
            if (arrayList.isEmpty()) {
                new d();
            } else {
                a aVar = new a(this);
                new Thread(new b()).start();
                try {
                    Class<?> cls = Class.forName("cn.thinkingdata.android.crash.TACrash");
                    Object objInvoke = cls.getMethod("getInstance", null).invoke(null, null);
                    cls.getMethod("init", Context.class).invoke(objInvoke, this.f215a);
                    cls.getMethod("enableLog", null).invoke(objInvoke, null);
                    if (arrayList.contains("java")) {
                        cls.getMethod("initJavaCrashHandler", Boolean.TYPE).invoke(objInvoke, true);
                    }
                    if (arrayList.contains("anr") || arrayList.contains(AnalyticsEvents.PARAMETER_SHARE_DIALOG_SHOW_NATIVE)) {
                        Class<?> cls2 = Boolean.TYPE;
                        cls.getMethod("initNativeCrashHandler", cls2, cls2, cls2, cls2).invoke(objInvoke, true, true, true, true);
                        if (arrayList.contains("anr")) {
                            cls.getMethod("initANRHandler", null).invoke(objInvoke, null);
                        }
                    }
                    cls.getMethod("initCrashLogListener", CrashLogListener.class).invoke(objInvoke, aVar);
                } catch (Exception unused2) {
                }
            }
            this.f216b = true;
        }
    }
}
