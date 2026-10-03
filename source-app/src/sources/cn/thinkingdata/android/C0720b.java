package cn.thinkingdata.android;

import android.content.Context;
import android.os.Handler;
import android.os.HandlerThread;
import android.os.Looper;
import android.os.Message;
import android.text.TextUtils;
import android.widget.Toast;
import cn.thinkingdata.android.encrypt.C0726c;
import cn.thinkingdata.android.utils.C0752c;
import cn.thinkingdata.android.utils.C0766q;
import cn.thinkingdata.android.utils.InterfaceC0757h;
import cn.thinkingdata.android.utils.TDLog;
import com.facebook.appevents.AppEventsConstants;
import j$.util.concurrent.ConcurrentHashMap;
import java.io.IOException;
import java.net.URLEncoder;
import java.nio.charset.MalformedInputException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.UUID;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class C0720b {

    private static final Map<Context, C0720b> f153g = new HashMap();

    private final b f154a;

    private final a f155b;

    private final C0733j f156c;

    private final C0721c f157d;

    private final Context f158e;

    private final Map<String, Boolean> f159f = new ConcurrentHashMap();

    private class a {

        private final Handler f160a;

        private class HandlerC1127a extends Handler {

            private final List<String> f162a;

            HandlerC1127a(Looper looper) {
                super(looper);
                this.f162a = new ArrayList();
            }

            @Override
            public void handleMessage(Message message) {
                int iM490a;
                int i = message.what;
                if (i != 0) {
                    if (i != 1) {
                        if (i == 2) {
                            C0720b.this.f154a.m483c((String) message.obj);
                            return;
                        } else {
                            if (i == 3) {
                                this.f162a.remove((String) message.obj);
                                return;
                            }
                            return;
                        }
                    }
                    String str = (String) message.obj;
                    if (str == null) {
                        return;
                    }
                    C0720b.this.f154a.m479a(str);
                    synchronized (a.this.f160a) {
                        a.this.f160a.removeMessages(2, str);
                        this.f162a.add(str);
                    }
                    synchronized (C0720b.this.f157d) {
                        C0720b.this.f157d.m492a(C0721c.c.EVENTS, (String) message.obj);
                    }
                    return;
                }
                try {
                    C0718a c0718a = (C0718a) message.obj;
                    if (c0718a == null) {
                        return;
                    }
                    String str2 = c0718a.f152i;
                    if (this.f162a.contains(str2)) {
                        return;
                    }
                    JSONObject jSONObjectM438a = c0718a.m438a();
                    try {
                        jSONObjectM438a.put("#uuid", UUID.randomUUID().toString());
                    } catch (JSONException unused) {
                    }
                    synchronized (C0720b.this.f157d) {
                        iM490a = C0720b.this.f157d.m490a(jSONObjectM438a, C0721c.c.EVENTS, str2);
                    }
                    if (iM490a < 0) {
                        TDLog.m687w("ThinkingAnalytics.DataHandle", "Saving data to database failed.");
                    } else {
                        TDLog.m682i("ThinkingAnalytics.DataHandle", "Data enqueued(" + C0766q.m736a(str2, 4) + "):\n" + jSONObjectM438a.toString(4));
                    }
                    a.this.m461a(str2, iM490a);
                } catch (Exception e) {
                    TDLog.m687w("ThinkingAnalytics.DataHandle", "Exception occurred while saving data to database: " + e.getMessage());
                    e.printStackTrace();
                }
            }
        }

        a() {
            HandlerThread handlerThread = new HandlerThread("thinkingData.sdk.saveMessageWorker", 1);
            handlerThread.start();
            this.f160a = new HandlerC1127a(handlerThread.getLooper());
        }

        public void m461a(String str, int i) {
            if (i >= C0720b.this.m457e(str)) {
                C0720b.this.f154a.m483c(str);
            } else {
                C0720b.this.f154a.m480a(str, C0720b.this.m458f(str));
            }
        }

        void m462a(C0718a c0718a) {
            Message messageObtain = Message.obtain();
            messageObtain.what = 0;
            messageObtain.obj = c0718a;
            Handler handler = this.f160a;
            if (handler != null) {
                handler.sendMessage(messageObtain);
            }
        }

        void m463a(String str) {
            Message messageObtain = Message.obtain();
            messageObtain.what = 1;
            messageObtain.obj = str;
            Handler handler = this.f160a;
            if (handler != null) {
                handler.sendMessageAtFrontOfQueue(messageObtain);
            }
            Message messageObtain2 = Message.obtain();
            messageObtain2.what = 3;
            messageObtain2.obj = str;
            Handler handler2 = this.f160a;
            if (handler2 != null) {
                handler2.sendMessage(messageObtain2);
            }
        }

        void m464b(String str) {
            Message messageObtain = Message.obtain();
            messageObtain.what = 2;
            messageObtain.obj = str;
            this.f160a.sendMessage(messageObtain);
        }
    }

    private class b {

        private final Handler f165b;

        private final InterfaceC0757h f166c;

        private final Object f164a = new Object();

        private final Map<String, Boolean> f167d = new HashMap();

        private class a extends Handler {
            a(Looper looper) {
                super(looper);
            }

            @Override
            public void handleMessage(Message message) throws Throwable {
                b bVar;
                int i = message.what;
                if (i == 0) {
                    String str = (String) message.obj;
                    TDConfig tDConfigM456d = C0720b.this.m456d(str);
                    if (tDConfigM456d != null) {
                        synchronized (b.this.f164a) {
                            Message messageObtain = Message.obtain();
                            messageObtain.what = 1;
                            messageObtain.obj = str;
                            b.this.f165b.sendMessage(messageObtain);
                            removeMessages(0, str);
                        }
                        try {
                            b.this.m467a(tDConfigM456d);
                        } catch (RuntimeException e) {
                            TDLog.m687w("ThinkingAnalytics.DataHandle", "Sending data to server failed due to unexpected exception: " + e.getMessage());
                            e.printStackTrace();
                        }
                        synchronized (b.this.f164a) {
                            removeMessages(1, str);
                            b bVar2 = b.this;
                            bVar2.m480a(str, C0720b.this.m458f(str));
                        }
                        return;
                    }
                } else {
                    if (i != 2) {
                        if (i == 3) {
                            if (((String) message.obj) == null) {
                                return;
                            }
                            synchronized (b.this.f164a) {
                                removeMessages(0, message.obj);
                            }
                            return;
                        }
                        if (i == 4) {
                            try {
                                C0718a c0718a = (C0718a) message.obj;
                                if (c0718a == null) {
                                    return;
                                }
                                JSONObject jSONObjectM438a = c0718a.m438a();
                                b bVar3 = b.this;
                                bVar3.m468a(C0720b.this.m456d(c0718a.f152i), jSONObjectM438a);
                                return;
                            } catch (Exception e2) {
                                TDLog.m680e("ThinkingAnalytics.DataHandle", "Exception occurred while sending message to Server: " + e2.getMessage());
                                return;
                            }
                        }
                        if (i != 5) {
                            if (i != 6) {
                                return;
                            }
                            C0735l c0735lM656a = C0735l.m656a(C0720b.this.f158e);
                            synchronized (C0720b.this.f157d) {
                                C0720b.this.f157d.m491a(System.currentTimeMillis() - c0735lM656a.m657a(), C0721c.c.EVENTS);
                            }
                            return;
                        }
                        try {
                            C0718a c0718a2 = (C0718a) message.obj;
                            if (c0718a2 == null) {
                                return;
                            }
                            TDConfig tDConfigM456d2 = C0720b.this.m456d(c0718a2.f152i);
                            if (tDConfigM456d2.isNormal()) {
                                bVar = b.this;
                            } else {
                                try {
                                    b.this.m474b(tDConfigM456d2, c0718a2.m438a());
                                    return;
                                } catch (Exception e3) {
                                    TDLog.m680e("ThinkingAnalytics.DataHandle", "Exception occurred while sending message to Server: " + e3.getMessage());
                                    if (tDConfigM456d2.shouldThrowException()) {
                                        throw new C0736m(e3);
                                    }
                                    if (tDConfigM456d2.isDebugOnly()) {
                                        return;
                                    } else {
                                        bVar = b.this;
                                    }
                                }
                            }
                            C0720b.this.m454c(c0718a2);
                            return;
                        } catch (Exception e4) {
                            e4.printStackTrace();
                            return;
                        }
                    }
                    TDConfig tDConfigM456d3 = C0720b.this.m456d((String) message.obj);
                    if (tDConfigM456d3 != null) {
                        try {
                            b.this.m472a("", tDConfigM456d3);
                            return;
                        } catch (RuntimeException e5) {
                            TDLog.m687w("ThinkingAnalytics.DataHandle", "Sending old data failed due to unexpected exception: " + e5.getMessage());
                            e5.printStackTrace();
                            return;
                        }
                    }
                }
                TDLog.m687w("ThinkingAnalytics.DataHandle", "Could found config object for token. Canceling...");
            }
        }

        b() {
            HandlerThread handlerThread = new HandlerThread("thinkingData.sdk.sendMessageWorker", 1);
            handlerThread.start();
            this.f165b = new a(handlerThread.getLooper());
            this.f166c = C0720b.this.m448a();
        }

        private Map<String, String> m466a(JSONArray jSONArray) {
            HashMap map = new HashMap();
            map.put("TA-Integration-Type", C0733j.m542g());
            map.put("TA-Integration-Version", C0733j.m543h());
            map.put("TA-Integration-Count", String.valueOf(jSONArray.length()));
            map.put("TA-Integration-Extra", "Android");
            map.put("TA-Datas-Type", C0726c.m516a(jSONArray) ? "1" : AppEventsConstants.EVENT_PARAM_VALUE_NO);
            return map;
        }

        public void m467a(TDConfig tDConfig) throws Throwable {
            m472a(tDConfig.getName(), tDConfig);
        }

        public void m468a(TDConfig tDConfig, JSONObject jSONObject) throws JSONException {
            if (TextUtils.isEmpty(tDConfig.mToken)) {
                return;
            }
            JSONArray jSONArray = new JSONArray();
            jSONArray.put(jSONObject);
            JSONObject jSONObject2 = new JSONObject();
            jSONObject2.put("data", jSONArray);
            jSONObject2.put("#app_id", tDConfig.mToken);
            jSONObject2.put("#flush_time", System.currentTimeMillis());
            TDLog.m682i("ThinkingAnalytics.DataHandle", "ret code: " + new JSONObject(this.f166c.mo696a(tDConfig.getServerUrl(), jSONObject2.toString(), false, tDConfig.getSSLSocketFactory(), m476d("1"))).getString("code") + ", upload message:\n" + jSONObject2.toString(4));
        }

        public void m472a(String str, TDConfig tDConfig) throws Throwable {
            String[] strArrM493a;
            int i;
            String str2;
            boolean z;
            boolean z2;
            int iM489a;
            String str3;
            if (tDConfig == null) {
                TDLog.m687w("ThinkingAnalytics.DataHandle", "Could found config object for sendToken. Canceling...");
                return;
            }
            if (TextUtils.isEmpty(tDConfig.mToken)) {
                return;
            }
            Boolean bool = (Boolean) C0720b.this.f159f.get(str);
            if (bool == null || !bool.booleanValue()) {
                try {
                    if (!C0720b.this.f156c.m553f() || !tDConfig.isShouldFlush(C0720b.this.f156c.m551d())) {
                        return;
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                }
                do {
                    synchronized (C0720b.this.f157d) {
                        strArrM493a = C0720b.this.f157d.m493a(C0721c.c.EVENTS, str, 50);
                    }
                    if (strArrM493a == null) {
                        return;
                    }
                    i = 0;
                    String str4 = strArrM493a[0];
                    String str5 = strArrM493a[1];
                    try {
                        try {
                            try {
                                try {
                                    JSONArray jSONArray = new JSONArray(str5);
                                    try {
                                        JSONObject jSONObject = new JSONObject();
                                        try {
                                            jSONObject.put("data", jSONArray);
                                            jSONObject.put("#app_id", tDConfig.mToken);
                                            jSONObject.put("#flush_time", System.currentTimeMillis());
                                            try {
                                                TDLog.m682i("ThinkingAnalytics.DataHandle", "ret code: " + new JSONObject(this.f166c.mo696a(tDConfig.getServerUrl(), jSONObject.toString(), false, tDConfig.getSSLSocketFactory(), m466a(jSONArray))).getString("code") + ", upload message:\n" + jSONObject.toString(4));
                                                if (!TextUtils.isEmpty(null)) {
                                                    TDLog.m679d("ThinkingAnalytics.DataHandle", null);
                                                }
                                                synchronized (C0720b.this.f157d) {
                                                    iM489a = C0720b.this.f157d.m489a(str4, C0721c.c.EVENTS, str);
                                                }
                                                str3 = String.format(Locale.CHINA, "Events flushed. [left = %d]", Integer.valueOf(iM489a));
                                            } catch (MalformedInputException unused) {
                                                z = true;
                                                try {
                                                    String str6 = "Cannot interpret " + tDConfig.getServerUrl() + " as a URL. The data will be deleted.";
                                                    if (!TextUtils.isEmpty(str6)) {
                                                        TDLog.m679d("ThinkingAnalytics.DataHandle", str6);
                                                    }
                                                    if (z) {
                                                        synchronized (C0720b.this.f157d) {
                                                            iM489a = C0720b.this.f157d.m489a(str4, C0721c.c.EVENTS, str);
                                                        }
                                                        str3 = String.format(Locale.CHINA, "Events flushed. [left = %d]", Integer.valueOf(iM489a));
                                                    }
                                                } catch (Throwable th) {
                                                    th = th;
                                                    z2 = z;
                                                    if (!TextUtils.isEmpty(null)) {
                                                        TDLog.m679d("ThinkingAnalytics.DataHandle", null);
                                                    }
                                                    if (z2) {
                                                        synchronized (C0720b.this.f157d) {
                                                            int iM489a2 = C0720b.this.f157d.m489a(str4, C0721c.c.EVENTS, str);
                                                        }
                                                        TDLog.m682i("ThinkingAnalytics.DataHandle", String.format(Locale.CHINA, "Events flushed. [left = %d]", Integer.valueOf(iM489a2)));
                                                    }
                                                    throw th;
                                                }
                                            } catch (Throwable th2) {
                                                th = th2;
                                                z2 = true;
                                                if (!TextUtils.isEmpty(null)) {
                                                    TDLog.m679d("ThinkingAnalytics.DataHandle", null);
                                                }
                                                if (z2) {
                                                    synchronized (C0720b.this.f157d) {
                                                        int iM489a3 = C0720b.this.f157d.m489a(str4, C0721c.c.EVENTS, str);
                                                        TDLog.m682i("ThinkingAnalytics.DataHandle", String.format(Locale.CHINA, "Events flushed. [left = %d]", Integer.valueOf(iM489a3)));
                                                    }
                                                }
                                                throw th;
                                            }
                                            TDLog.m682i("ThinkingAnalytics.DataHandle", str3);
                                            i = iM489a;
                                        } catch (JSONException e2) {
                                            TDLog.m687w("ThinkingAnalytics.DataHandle", "Invalid data: " + jSONObject.toString());
                                            throw e2;
                                        }
                                    } catch (JSONException unused2) {
                                        if (!TextUtils.isEmpty("Cannot post message due to JSONException, the data will be deleted")) {
                                            TDLog.m679d("ThinkingAnalytics.DataHandle", "Cannot post message due to JSONException, the data will be deleted");
                                        }
                                        synchronized (C0720b.this.f157d) {
                                            iM489a = C0720b.this.f157d.m489a(str4, C0721c.c.EVENTS, str);
                                            str3 = String.format(Locale.CHINA, "Events flushed. [left = %d]", Integer.valueOf(iM489a));
                                        }
                                    }
                                } catch (Throwable th3) {
                                    th = th3;
                                    z2 = false;
                                }
                            } catch (MalformedInputException unused3) {
                                z = false;
                            }
                        } catch (JSONException e3) {
                            TDLog.m687w("ThinkingAnalytics.DataHandle", "The data is invalid: " + str5);
                            throw e3;
                        }
                    } catch (InterfaceC0757h.a e4) {
                        str2 = "Cannot post message to [" + tDConfig.getServerUrl() + "] due to " + e4.getMessage();
                        if (!TextUtils.isEmpty(str2)) {
                            TDLog.m679d("ThinkingAnalytics.DataHandle", str2);
                        }
                    } catch (IOException e5) {
                        str2 = "Cannot post message to [" + tDConfig.getServerUrl() + "] due to " + e5.getMessage();
                        if (!TextUtils.isEmpty(str2)) {
                            TDLog.m679d("ThinkingAnalytics.DataHandle", str2);
                        }
                    }
                } while (i > 0);
            }
        }

        public void m474b(TDConfig tDConfig, JSONObject jSONObject) throws JSONException {
            StringBuilder sb = new StringBuilder("appid=");
            sb.append(tDConfig.mToken);
            if (jSONObject.optJSONObject("properties") != null) {
                TDPresetProperties presetProperties = ThinkingAnalyticsSDK.sharedInstance(tDConfig).getPresetProperties();
                String strM545a = (presetProperties == null || TDPresetProperties.disableList.contains("#device_id")) ? "" : presetProperties.deviceId;
                if (TextUtils.isEmpty(strM545a) && !TDPresetProperties.disableList.contains("#device_id")) {
                    strM545a = C0733j.m540e(tDConfig.mContext).m545a(tDConfig.mContext);
                }
                if (!TextUtils.isEmpty(strM545a)) {
                    sb.append("&deviceId=");
                    sb.append(strM545a);
                }
            }
            sb.append("&source=client&data=");
            sb.append(URLEncoder.encode(jSONObject.toString()));
            if (tDConfig.isDebugOnly()) {
                sb.append("&dryRun=1");
            }
            String strM736a = C0766q.m736a(tDConfig.getName(), 4);
            TDLog.m679d("ThinkingAnalytics.DataHandle", "uploading message(" + strM736a + "):\n" + jSONObject.toString(4));
            JSONObject jSONObject2 = new JSONObject(this.f166c.mo696a(tDConfig.getDebugUrl(), sb.toString(), true, tDConfig.getSSLSocketFactory(), m476d("1")));
            int i = jSONObject2.getInt("errorLevel");
            if (i == -1) {
                if (tDConfig.isDebugOnly()) {
                    TDLog.m687w("ThinkingAnalytics.DataHandle", "The data will be discarded due to this device is not allowed to debug for: " + strM736a);
                    return;
                } else {
                    tDConfig.setMode(TDConfig.ModeEnum.NORMAL);
                    throw new C0736m("Fallback to normal mode due to the device is not allowed to debug for: " + strM736a);
                }
            }
            Boolean bool = this.f167d.get(tDConfig.getName());
            if (bool == null || !bool.booleanValue()) {
                Toast.makeText(C0720b.this.f158e, "Debug Mode enabled for: " + strM736a, 1).show();
                this.f167d.put(tDConfig.getName(), true);
                tDConfig.setAllowDebug();
            }
            if (i == 0) {
                TDLog.m679d("ThinkingAnalytics.DataHandle", "Upload debug data successfully for " + strM736a);
                return;
            }
            if (jSONObject2.has("errorProperties")) {
                TDLog.m679d("ThinkingAnalytics.DataHandle", " Error Properties: \n" + jSONObject2.getJSONArray("errorProperties").toString(4));
            }
            if (jSONObject2.has("errorReasons")) {
                TDLog.m679d("ThinkingAnalytics.DataHandle", "Error Reasons: \n" + jSONObject2.getJSONArray("errorReasons").toString(4));
            }
            if (tDConfig.shouldThrowException()) {
                if (1 == i) {
                    throw new C0736m("Invalid properties. Please refer to the logcat log for detail info.");
                }
                if (2 == i) {
                    throw new C0736m("Invalid data format. Please refer to the logcat log for detail info.");
                }
                throw new C0736m("Unknown error level: " + i);
            }
        }

        private Map<String, String> m476d(String str) {
            HashMap map = new HashMap();
            map.put("TA-Integration-Type", C0733j.m542g());
            map.put("TA-Integration-Version", C0733j.m543h());
            map.put("TA-Integration-Count", str);
            map.put("TA-Integration-Extra", "Android");
            return map;
        }

        void m477a() {
            Message messageObtain = Message.obtain();
            messageObtain.what = 6;
            this.f165b.sendMessage(messageObtain);
        }

        void m478a(C0718a c0718a) {
            if (c0718a == null) {
                return;
            }
            Message messageObtain = Message.obtain();
            messageObtain.what = 5;
            messageObtain.obj = c0718a;
            this.f165b.sendMessage(messageObtain);
        }

        void m479a(String str) {
            if (TextUtils.isEmpty(str)) {
                return;
            }
            Message messageObtain = Message.obtain();
            messageObtain.what = 3;
            messageObtain.obj = str;
            this.f165b.sendMessageAtFrontOfQueue(messageObtain);
        }

        void m480a(String str, long j) {
            synchronized (this.f164a) {
                Handler handler = this.f165b;
                if (handler != null && !handler.hasMessages(0, str) && !this.f165b.hasMessages(1, str)) {
                    Message messageObtain = Message.obtain();
                    messageObtain.what = 0;
                    messageObtain.obj = str;
                    try {
                        this.f165b.sendMessageDelayed(messageObtain, j);
                    } catch (IllegalStateException e) {
                        TDLog.m687w("ThinkingAnalytics.DataHandle", "The app might be quiting: " + e.getMessage());
                    }
                }
            }
        }

        void m481b(C0718a c0718a) {
            if (c0718a == null) {
                return;
            }
            Message messageObtain = Message.obtain();
            messageObtain.what = 4;
            messageObtain.obj = c0718a;
            this.f165b.sendMessage(messageObtain);
        }

        void m482b(String str) {
            if (TextUtils.isEmpty(str)) {
                return;
            }
            Message messageObtain = Message.obtain();
            messageObtain.what = 2;
            messageObtain.obj = str;
            this.f165b.sendMessage(messageObtain);
        }

        void m483c(String str) {
            synchronized (this.f164a) {
                Handler handler = this.f165b;
                if (handler != null && !handler.hasMessages(1, str)) {
                    Message messageObtain = Message.obtain();
                    messageObtain.what = 0;
                    messageObtain.obj = str;
                    this.f165b.sendMessage(messageObtain);
                }
            }
        }
    }

    C0720b(Context context) {
        Context applicationContext = context.getApplicationContext();
        this.f158e = applicationContext;
        this.f156c = C0733j.m540e(applicationContext);
        this.f157d = m447a(applicationContext);
        b bVar = new b();
        this.f154a = bVar;
        this.f155b = new a();
        bVar.m477a();
    }

    static C0720b m442b(Context context) {
        C0720b c0720b;
        Map<Context, C0720b> map = f153g;
        synchronized (map) {
            Context applicationContext = context.getApplicationContext();
            if (map.containsKey(applicationContext)) {
                c0720b = map.get(applicationContext);
            } else {
                c0720b = new C0720b(applicationContext);
                map.put(applicationContext, c0720b);
            }
        }
        return c0720b;
    }

    protected C0721c m447a(Context context) {
        return C0721c.m486b(context);
    }

    protected InterfaceC0757h m448a() {
        return new C0752c();
    }

    void m449a(C0718a c0718a) {
        this.f154a.m481b(c0718a);
    }

    void m450a(String str) {
        this.f155b.m463a(str);
    }

    public void m451a(String str, boolean z) {
        if (z) {
            this.f159f.put(str, true);
        } else {
            this.f159f.remove(str);
        }
    }

    void m452b(C0718a c0718a) {
        this.f154a.m478a(c0718a);
    }

    void m453b(String str) {
        this.f155b.m464b(str);
    }

    void m454c(C0718a c0718a) {
        this.f155b.m462a(c0718a);
    }

    void m455c(String str) {
        this.f154a.m482b(str);
    }

    protected TDConfig m456d(String str) {
        return TDConfig.getInstance(this.f158e, str);
    }

    protected int m457e(String str) {
        TDConfig tDConfigM456d = m456d(str);
        if (tDConfigM456d == null) {
            return 20;
        }
        return tDConfigM456d.getFlushBulkSize();
    }

    protected int m458f(String str) {
        TDConfig tDConfigM456d = m456d(str);
        if (tDConfigM456d == null) {
            return 15000;
        }
        return tDConfigM456d.getFlushInterval();
    }
}
