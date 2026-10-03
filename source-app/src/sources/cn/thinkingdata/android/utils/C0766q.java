package cn.thinkingdata.android.utils;

import android.app.ActionBar;
import android.app.Activity;
import android.app.ActivityManager;
import android.content.Context;
import android.content.pm.ActivityInfo;
import android.content.pm.PackageManager;
import android.os.Handler;
import android.text.TextUtils;
import android.view.Choreographer;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.widget.Button;
import android.widget.CheckBox;
import android.widget.CheckedTextView;
import android.widget.CompoundButton;
import android.widget.ImageView;
import android.widget.RadioButton;
import android.widget.TextView;
import android.widget.ToggleButton;
import cn.thinkingdata.android.C0702R;
import cn.thinkingdata.android.C0730g;
import cn.thinkingdata.android.C0735l;
import cn.thinkingdata.android.ScreenAutoTracker;
import cn.thinkingdata.android.TDPresetProperties;
import cn.thinkingdata.android.ThinkingDataFragmentTitle;
import com.facebook.internal.security.CertificateUtil;
import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.TimeZone;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class C0766q {

    static long f280a;

    static long f281b;

    static volatile int f282c;

    class a implements Choreographer.FrameCallback {
        a() {
        }

        @Override
        public void doFrame(long j) {
            int i;
            C0766q.f281b = j;
            if (j <= C0766q.f280a) {
                i = 60;
            } else {
                long j2 = 1000000000 / (C0766q.f281b - C0766q.f280a);
                if (j2 > 70) {
                    i = 60;
                } else {
                    i = (int) j2;
                }
            }
            C0766q.f282c = i;
        }
    }

    class b implements Choreographer.FrameCallback {

        final Choreographer.FrameCallback f283a;

        b(Choreographer.FrameCallback frameCallback) {
            this.f283a = frameCallback;
        }

        @Override
        public void doFrame(long j) {
            C0766q.f280a = j;
            Choreographer.getInstance().postFrameCallback(this.f283a);
        }
    }

    class c implements Runnable {

        final Handler f284a;

        final Choreographer.FrameCallback f285b;

        c(Handler handler, Choreographer.FrameCallback frameCallback) {
            this.f284a = handler;
            this.f285b = frameCallback;
        }

        @Override
        public void run() {
            this.f284a.postDelayed(this, 500L);
            Choreographer.getInstance().postFrameCallback(this.f285b);
        }
    }

    public static double m724a(double d) {
        return Math.round(d * 10.0d) / 10.0d;
    }

    public static double m725a(long j, TimeZone timeZone) {
        if (timeZone == null) {
            timeZone = TimeZone.getDefault();
        }
        return ((double) timeZone.getOffset(j)) / 3600000.0d;
    }

    public static int m726a() {
        if (f282c == 0) {
            f282c = 60;
        }
        return f282c;
    }

    private static int m727a(ViewParent viewParent, View view) {
        try {
            if (!(viewParent instanceof ViewGroup)) {
                return -1;
            }
            ViewGroup viewGroup = (ViewGroup) viewParent;
            String strM733a = m733a(view);
            String canonicalName = view.getClass().getCanonicalName();
            int i = 0;
            for (int i2 = 0; i2 < viewGroup.getChildCount(); i2++) {
                View childAt = viewGroup.getChildAt(i2);
                if (C0730g.m526a(childAt, canonicalName)) {
                    String strM733a2 = m733a(childAt);
                    if ((strM733a == null || strM733a.equals(strM733a2)) && childAt == view) {
                        return i;
                    }
                    i++;
                }
            }
            return -1;
        } catch (Exception e) {
            e.printStackTrace();
            return -1;
        }
    }

    public static int m728a(String str) {
        if ("NULL".equals(str)) {
            return 255;
        }
        if ("WIFI".equals(str)) {
            return 8;
        }
        if ("2G".equals(str)) {
            return 1;
        }
        if ("3G".equals(str)) {
            return 2;
        }
        if ("4G".equals(str)) {
            return 4;
        }
        return "5G".equals(str) ? 16 : 255;
    }

    public static android.app.Activity m729a(android.content.Context r1) {
        throw new UnsupportedOperationException("Method not decompiled: cn.thinkingdata.android.utils.C0766q.m729a(android.content.Context):android.app.Activity");
    }

    public static synchronized Object m730a(String str, View view, int i) {
        HashMap map = (HashMap) view.getTag(i);
        if (map == null) {
            return null;
        }
        return map.get(str);
    }

    public static String m731a(int i) {
        double dRandom;
        double d;
        char c2;
        StringBuilder sb = new StringBuilder();
        for (int i2 = 0; i2 < i; i2++) {
            int iRandom = (int) (Math.random() * 2.0d);
            if (iRandom != 0) {
                if (iRandom != 1) {
                    c2 = 0;
                } else {
                    dRandom = Math.random() * 6.0d;
                    d = 97.0d;
                }
                sb.append(c2);
            } else {
                dRandom = Math.random() * 10.0d;
                d = 48.0d;
            }
            c2 = (char) (dRandom + d);
            sb.append(c2);
        }
        return sb.toString();
    }

    public static String m732a(Activity activity) {
        PackageManager packageManager;
        if (activity != null) {
            try {
                String string = !TextUtils.isEmpty(activity.getTitle()) ? activity.getTitle().toString() : null;
                String strM749b = m749b(activity);
                if (!TextUtils.isEmpty(strM749b)) {
                    string = strM749b;
                }
                if (!TextUtils.isEmpty(string) || (packageManager = activity.getPackageManager()) == null) {
                    return string;
                }
                ActivityInfo activityInfo = packageManager.getActivityInfo(activity.getComponentName(), 0);
                return !TextUtils.isEmpty(activityInfo.loadLabel(packageManager)) ? activityInfo.loadLabel(packageManager).toString() : string;
            } catch (Exception unused) {
            }
        }
        return null;
    }

    public static String m733a(View view) {
        return m734a(view, (String) null);
    }

    public static String m734a(View view, String str) {
        try {
            String str2 = (String) m730a(str, view, C0702R.id.thinking_analytics_tag_view_id);
            try {
                return (!TextUtils.isEmpty(str2) || view.getId() == -1) ? str2 : view.getContext().getResources().getResourceEntryName(view.getId());
            } catch (Exception unused) {
                return str2;
            }
        } catch (Exception unused2) {
            return null;
        }
    }

    public static String m735a(Object obj, String str) {
        ThinkingDataFragmentTitle thinkingDataFragmentTitle;
        JSONObject trackProperties;
        String strOptString = null;
        try {
            if ((obj instanceof ScreenAutoTracker) && (trackProperties = ((ScreenAutoTracker) obj).getTrackProperties()) != null && trackProperties.has("#title")) {
                strOptString = trackProperties.optString("#title");
            }
            if (TextUtils.isEmpty(strOptString) && obj.getClass().isAnnotationPresent(ThinkingDataFragmentTitle.class) && (thinkingDataFragmentTitle = (ThinkingDataFragmentTitle) obj.getClass().getAnnotation(ThinkingDataFragmentTitle.class)) != null) {
                return (TextUtils.isEmpty(thinkingDataFragmentTitle.appId()) || str.equals(thinkingDataFragmentTitle.appId())) ? thinkingDataFragmentTitle.title() : strOptString;
            }
            return strOptString;
        } catch (Exception e) {
            e.printStackTrace();
            return null;
        }
    }

    public static String m736a(String str, int i) {
        return (!TextUtils.isEmpty(str) && str.length() > i) ? str.substring(str.length() - 4) : str;
    }

    private static String m737a(String str, String str2) {
        try {
            Class<?> cls = Class.forName("android.os.SystemProperties");
            String str3 = (String) cls.getDeclaredMethod("get", String.class).invoke(cls, str);
            return TextUtils.isEmpty(str3) ? str2 : str3;
        } catch (Throwable th) {
            TDLog.m682i("TA.SystemProperties", th.getMessage());
            return str2;
        }
    }

    public static String m738a(StringBuilder sb, ViewGroup viewGroup) {
        Class<?> cls;
        CharSequence string;
        CharSequence text;
        Class<?> cls2;
        String str;
        try {
            if (viewGroup == null) {
                return sb.toString();
            }
            int childCount = viewGroup.getChildCount();
            for (int i = 0; i < childCount; i++) {
                View childAt = viewGroup.getChildAt(i);
                if (childAt.getVisibility() == 0) {
                    if (childAt instanceof ViewGroup) {
                        m738a(sb, (ViewGroup) childAt);
                    } else {
                        CharSequence charSequence = null;
                        try {
                            cls = Class.forName("androidx.appcompat.widget.SwitchCompat");
                        } catch (Exception unused) {
                            cls = null;
                        }
                        if (cls == null) {
                            try {
                                cls = Class.forName("androidx.appcompat.widget.SwitchCompat");
                            } catch (Exception unused2) {
                            }
                        }
                        if (childAt instanceof CheckBox) {
                            text = ((CheckBox) childAt).getText();
                        } else {
                            if (cls == null || !cls.isInstance(childAt)) {
                                if (childAt instanceof RadioButton) {
                                    text = ((RadioButton) childAt).getText();
                                } else if (childAt instanceof ToggleButton) {
                                    ToggleButton toggleButton = (ToggleButton) childAt;
                                    string = toggleButton.isChecked() ? toggleButton.getTextOn() : toggleButton.getTextOff();
                                } else if (childAt instanceof Button) {
                                    string = ((Button) childAt).getText();
                                } else if (childAt instanceof CheckedTextView) {
                                    string = ((CheckedTextView) childAt).getText();
                                } else if (childAt instanceof TextView) {
                                    string = ((TextView) childAt).getText();
                                } else if (childAt instanceof ImageView) {
                                    ImageView imageView = (ImageView) childAt;
                                    if (!TextUtils.isEmpty(imageView.getContentDescription())) {
                                        string = imageView.getContentDescription().toString();
                                    }
                                }
                                if (!TextUtils.isEmpty(string)) {
                                    sb.append(string.toString());
                                    sb.append("-");
                                }
                            } else {
                                if (((CompoundButton) childAt).isChecked()) {
                                    cls2 = childAt.getClass();
                                    str = "getTextOn";
                                } else {
                                    cls2 = childAt.getClass();
                                    str = "getTextOff";
                                }
                                charSequence = (String) cls2.getMethod(str, null).invoke(childAt, null);
                            }
                            string = charSequence;
                            if (!TextUtils.isEmpty(string)) {
                                sb.append(string.toString());
                                sb.append("-");
                            }
                        }
                        charSequence = text;
                        string = charSequence;
                        if (!TextUtils.isEmpty(string)) {
                            sb.append(string.toString());
                            sb.append("-");
                        }
                    }
                }
            }
            return sb.toString();
        } catch (Exception e) {
            e.printStackTrace();
            return sb.toString();
        }
    }

    private static List<Object> m739a(JSONArray jSONArray) throws JSONException {
        ArrayList arrayList = new ArrayList();
        for (int i = 0; i < jSONArray.length(); i++) {
            Object objOpt = jSONArray.opt(i);
            if (objOpt != null) {
                if (objOpt instanceof JSONArray) {
                    objOpt = m739a((JSONArray) objOpt);
                } else if (objOpt instanceof JSONObject) {
                    objOpt = m740a((JSONObject) objOpt);
                }
                arrayList.add(objOpt);
            }
        }
        return arrayList;
    }

    public static Map<String, Object> m740a(JSONObject jSONObject) throws JSONException {
        HashMap map = new HashMap();
        Iterator<String> itKeys = jSONObject.keys();
        while (itKeys.hasNext()) {
            String next = itKeys.next();
            Object objM739a = jSONObject.get(next);
            if (objM739a instanceof JSONObject) {
                objM739a = m740a((JSONObject) objM739a);
            } else if (objM739a instanceof JSONArray) {
                objM739a = m739a((JSONArray) objM739a);
            }
            map.put(next, objM739a);
        }
        return map;
    }

    public static JSONArray m741a(JSONArray jSONArray, TimeZone timeZone) {
        JSONArray jSONArray2 = new JSONArray();
        for (int i = 0; i < jSONArray.length(); i++) {
            Object objOpt = jSONArray.opt(i);
            if (objOpt != null) {
                if (objOpt instanceof Date) {
                    SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.CHINA);
                    if (timeZone != null) {
                        simpleDateFormat.setTimeZone(timeZone);
                    }
                    objOpt = simpleDateFormat.format((Date) objOpt);
                } else if (objOpt instanceof JSONArray) {
                    objOpt = m741a((JSONArray) objOpt, timeZone);
                } else if (objOpt instanceof JSONObject) {
                    objOpt = m742a((JSONObject) objOpt, timeZone);
                }
                jSONArray2.put(objOpt);
            }
        }
        return jSONArray2;
    }

    public static JSONObject m742a(JSONObject jSONObject, TimeZone timeZone) {
        JSONObject jSONObject2 = new JSONObject();
        Iterator<String> itKeys = jSONObject.keys();
        while (itKeys.hasNext()) {
            String next = itKeys.next();
            try {
                Object objM742a = jSONObject.get(next);
                if (objM742a instanceof Date) {
                    SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.CHINA);
                    if (timeZone != null) {
                        simpleDateFormat.setTimeZone(timeZone);
                    }
                    objM742a = simpleDateFormat.format((Date) objM742a);
                } else if (objM742a instanceof JSONArray) {
                    objM742a = m741a((JSONArray) objM742a, timeZone);
                } else if (objM742a instanceof JSONObject) {
                    objM742a = m742a((JSONObject) objM742a, timeZone);
                }
                jSONObject2.put(next, objM742a);
            } catch (JSONException e) {
                e.printStackTrace();
            }
        }
        return jSONObject2;
    }

    public static void m743a(Activity activity, View view, JSONObject jSONObject) {
        ViewParent parent;
        if (view == null) {
            return;
        }
        if (jSONObject == null) {
            try {
                jSONObject = new JSONObject();
            } catch (Exception e) {
                e.printStackTrace();
                return;
            }
        }
        ArrayList arrayList = new ArrayList();
        do {
            parent = view.getParent();
            arrayList.add(view.getClass().getCanonicalName() + "[" + m727a(parent, view) + "]");
            if (parent instanceof ViewGroup) {
                view = (ViewGroup) parent;
            }
        } while (parent instanceof ViewGroup);
        Collections.reverse(arrayList);
        StringBuilder sb = new StringBuilder();
        for (int i = 1; i < arrayList.size(); i++) {
            sb.append((String) arrayList.get(i));
            if (i != arrayList.size() - 1) {
                sb.append("/");
            }
        }
        if (TDPresetProperties.disableList.contains("#element_selector")) {
            return;
        }
        jSONObject.put("#element_selector", sb.toString());
    }

    public static void m744a(View view, JSONObject jSONObject) {
        if (view != null) {
            try {
                String str = (String) view.getTag(C0702R.id.thinking_analytics_tag_view_fragment_name);
                if (TextUtils.isEmpty(str) && view.getParent() != null && (view.getParent() instanceof View)) {
                    str = (String) ((View) view.getParent()).getTag(C0702R.id.thinking_analytics_tag_view_fragment_name);
                }
                if (TextUtils.isEmpty(str)) {
                    return;
                }
                String strOptString = jSONObject.optString("#screen_name");
                if (TextUtils.isEmpty(str)) {
                    if (TDPresetProperties.disableList.contains("#screen_name")) {
                        return;
                    }
                    jSONObject.put("#screen_name", str);
                } else {
                    if (TDPresetProperties.disableList.contains("#screen_name")) {
                        return;
                    }
                    jSONObject.put("#screen_name", String.format(Locale.CHINA, "%s|%s", strOptString, str));
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    public static synchronized void m745a(String str, View view, int i, Object obj) {
        if (str == null) {
            return;
        }
        HashMap map = (HashMap) view.getTag(i);
        if (map == null) {
            map = new HashMap();
        }
        map.put(str, obj);
        view.setTag(i, map);
    }

    public static void m746a(JSONObject jSONObject, Activity activity) {
        PackageManager packageManager;
        if (activity == null || jSONObject == null) {
            return;
        }
        try {
            if (!TDPresetProperties.disableList.contains("#screen_name")) {
                jSONObject.put("#screen_name", activity.getClass().getCanonicalName());
            }
            String string = activity.getTitle().toString();
            String strM749b = m749b(activity);
            if (!TextUtils.isEmpty(strM749b)) {
                string = strM749b;
            }
            if (TextUtils.isEmpty(string) && (packageManager = activity.getPackageManager()) != null) {
                string = packageManager.getActivityInfo(activity.getComponentName(), 0).loadLabel(packageManager).toString();
            }
            if (TextUtils.isEmpty(string) || TDPresetProperties.disableList.contains("#title")) {
                return;
            }
            jSONObject.put("#title", string);
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    public static void m747a(JSONObject jSONObject, JSONObject jSONObject2, TimeZone timeZone) throws JSONException {
        Iterator<String> itKeys = jSONObject.keys();
        while (itKeys.hasNext()) {
            String next = itKeys.next();
            Object objM742a = jSONObject.get(next);
            if (objM742a instanceof Date) {
                SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss.SSS", Locale.CHINA);
                if (timeZone != null) {
                    simpleDateFormat.setTimeZone(timeZone);
                }
                objM742a = simpleDateFormat.format((Date) objM742a);
            } else if (objM742a instanceof JSONArray) {
                objM742a = m741a((JSONArray) objM742a, timeZone);
            } else if (objM742a instanceof JSONObject) {
                objM742a = m742a((JSONObject) objM742a, timeZone);
            }
            jSONObject2.put(next, objM742a);
        }
    }

    public static String m748b() {
        if (!m754c()) {
            return null;
        }
        String strM737a = m737a("hw_sc.build.platform.version", "");
        return TextUtils.isEmpty(strM737a) ? m751b("getprop hw_sc.build.platform.version") : strM737a;
    }

    public static String m749b(Activity activity) {
        Class<?> cls;
        Object objInvoke;
        CharSequence charSequence;
        ActionBar actionBar = activity.getActionBar();
        if (actionBar == null) {
            try {
                cls = Class.forName("androidx.appcompat.app.AppCompatActivity");
            } catch (Throwable unused) {
                cls = null;
            }
            if (cls == null) {
                try {
                    cls = Class.forName("androidx.appcompat.app.AppCompatActivity");
                } catch (Throwable unused2) {
                }
            }
            if (cls != null) {
                try {
                    if (cls.isInstance(activity) && (objInvoke = activity.getClass().getMethod("getSupportActionBar", null).invoke(activity, null)) != null && (charSequence = (CharSequence) objInvoke.getClass().getMethod("getTitle", null).invoke(objInvoke, null)) != null) {
                        return charSequence.toString();
                    }
                } catch (Throwable unused3) {
                }
            }
        } else if (!TextUtils.isEmpty(actionBar.getTitle())) {
            return actionBar.getTitle().toString();
        }
        return null;
    }

    public static String m750b(Context context) {
        try {
            return C0755f.m701a(context);
        } catch (Exception e) {
            e.printStackTrace();
            return "";
        }
    }

    public static String m751b(String str) {
        Throwable th;
        BufferedReader bufferedReader;
        InputStreamReader inputStreamReader;
        try {
            inputStreamReader = new InputStreamReader(Runtime.getRuntime().exec(str).getInputStream());
            try {
                bufferedReader = new BufferedReader(inputStreamReader);
                try {
                    StringBuilder sb = new StringBuilder();
                    while (true) {
                        String line = bufferedReader.readLine();
                        if (line == null) {
                            break;
                        }
                        sb.append(line);
                    }
                    String string = sb.toString();
                    try {
                        bufferedReader.close();
                    } catch (Throwable th2) {
                        TDLog.m682i("TDExec", th2.getMessage());
                    }
                    try {
                        inputStreamReader.close();
                    } catch (IOException e) {
                        TDLog.m682i("TDExec", e.getMessage());
                    }
                    return string;
                } catch (Throwable th3) {
                    th = th3;
                    try {
                        TDLog.m682i("TDExec", th.getMessage());
                        return null;
                    } finally {
                        if (bufferedReader != null) {
                            try {
                                bufferedReader.close();
                            } catch (Throwable th4) {
                                TDLog.m682i("TDExec", th4.getMessage());
                            }
                        }
                        if (inputStreamReader != null) {
                            try {
                                inputStreamReader.close();
                            } catch (IOException e2) {
                                TDLog.m682i("TDExec", e2.getMessage());
                            }
                        }
                    }
                }
            } catch (Throwable th5) {
                th = th5;
                bufferedReader = null;
            }
        } catch (Throwable th6) {
            th = th6;
            bufferedReader = null;
            inputStreamReader = null;
        }
    }

    public static void m752b(JSONObject jSONObject, JSONObject jSONObject2, TimeZone timeZone) throws JSONException {
        Iterator<String> itKeys = jSONObject.keys();
        while (itKeys.hasNext()) {
            String next = itKeys.next();
            JSONObject jSONObjectOptJSONObject = jSONObject.optJSONObject(next);
            JSONObject jSONObjectOptJSONObject2 = jSONObject2.optJSONObject(next);
            if (jSONObjectOptJSONObject != null) {
                if (jSONObjectOptJSONObject2 == null) {
                    JSONObject jSONObject3 = new JSONObject();
                    m747a(jSONObjectOptJSONObject, jSONObject3, timeZone);
                    jSONObject2.put(next, jSONObject3);
                } else {
                    m747a(jSONObjectOptJSONObject, jSONObjectOptJSONObject2, timeZone);
                }
            }
        }
    }

    public static String m753c(Context context) {
        return (context.getResources().getConfiguration().screenLayout & 15) < 3 ? "Phone" : "Tablet";
    }

    public static boolean m754c() {
        try {
            Class<?> cls = Class.forName("com.huawei.system.BuildEx");
            Object objInvoke = cls.getMethod("getOsBrand", null).invoke(cls, null);
            if (objInvoke == null) {
                return false;
            }
            return "harmony".equalsIgnoreCase(objInvoke.toString());
        } catch (Throwable th) {
            TDLog.m682i("HasHarmonyOS", th.getMessage());
            return false;
        }
    }

    public static String m755d(Context context) {
        String str = "";
        if (context == null) {
            return "";
        }
        try {
            str = context.getApplicationInfo().processName;
        } catch (Exception unused) {
        }
        return str.length() == 0 ? C0735l.m656a(context).m658b() : str;
    }

    public static void m756d() {
        b bVar = new b(new a());
        Handler handler = new Handler();
        handler.postDelayed(new c(handler, bVar), 500L);
    }

    public static boolean m757e(Context context) {
        ActivityManager activityManager = (ActivityManager) context.getSystemService("activity");
        if (C0755f.f245b == null) {
            C0755f.f245b = activityManager.getRunningAppProcesses();
        }
        for (ActivityManager.RunningAppProcessInfo runningAppProcessInfo : C0755f.f245b) {
            String strSubstring = runningAppProcessInfo.processName;
            int iIndexOf = strSubstring.indexOf(CertificateUtil.DELIMITER);
            if (iIndexOf != -1) {
                strSubstring = strSubstring.substring(0, iIndexOf);
            }
            if (strSubstring.equals(context.getPackageName())) {
                int i = runningAppProcessInfo.importance;
                return i == 100 || i == 200;
            }
        }
        return false;
    }

    public static boolean m758f(Context context) {
        if (context == null) {
            return true;
        }
        String strM750b = m750b(context.getApplicationContext());
        return !TextUtils.isEmpty(strM750b) && m755d(context).equals(strM750b);
    }
}
