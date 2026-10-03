package com.ishumei.smantifraud;

import android.content.Context;
import android.content.pm.ApplicationInfo;
import android.content.pm.PackageManager;
import android.location.Location;
import android.media.MediaDrm;
import android.os.Build;
import android.os.Bundle;
import android.text.TextUtils;
import android.util.ArraySet;
import android.util.Base64;
import android.view.inputmethod.InputMethodInfo;
import android.view.inputmethod.InputMethodManager;
import com.google.firebase.analytics.FirebaseAnalytics;
import com.google.firebase.sessions.settings.RemoteSettings;
import dalvik.system.BaseDexClassLoader;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.FileReader;
import java.io.InputStreamReader;
import java.io.PrintStream;
import java.lang.reflect.Field;
import java.lang.reflect.Method;
import java.lang.reflect.Modifier;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;
import java.util.Set;
import java.util.TreeSet;
import java.util.UUID;
import org.json.JSONArray;
import org.json.JSONObject;

public class l1111l111111Il {
    public static final String l1111l111111Il = "eJy1Wt9P5DYQ/l9WPPQktBHcG1SVDriiVYFbEdpKoHtwkiHrrmOnsbPAnfq/d5xNgpM4u9k4vOyheH5883k8Htv39HO2hrfZ2QwYJMDV7HgWMvLjB36JCNvQtSffpILEu4LXJVGrGyrV0ddaNgG1EhEKK+GrjPIYv0ka44dfPt38QzbEY4TH3nbsHAdTkpFkdvb0/Xim3lKYnZ38d1xBoFwu17GBgPAoEzTySJp6X9KU0ZAoKviShGsSwy3h+JuZKGJQCy4VYQyiUkq+I1qUkHJFmacDMQGhdzWzoZIpWj2xoBLS8wtulplIIVO08GVieXfd5WI3PTM9ONeD85LXGtppC9rp5NDcwR4PxA/hFkobf5qJDY0g83xQCrXlkQ9hnkEriHbK3VT6oeAKE9S73P57D1KwDWSHR1YanJcG5y2DQwONYGPLIIWLLl0J/uY9VH/Zk/oKNjSEReSyuhCDLVUcMCz2kNe3ojiu4g0YWN6tZPDMIFTerYjoM21ioPKuUqxIeLTF3OA9yG0FBdfHVTlkmC8+YeA4yRxBQHSAp5iJgLCh2XxdSHcql3JL5cUHZG6Wc4TfV5NDnA+qehLmPucczWLhxioUgpRmLd5Vim05gzgUkWsXIA+o77wbIA4JmV4JLlD8rQlnNOiQ8ufe6Rm4ZRpyi6213q0BYbYTM028loF9e0NfNOk6niCacnBcJIby2Ciwi0G4U3UxhoJztsArhNaqi1mpaNLYXUvZQe1LubwH9i/mhKdRsanQyIAVisSrKMNIIOOEGbvUEn8BPb6+fcAeGcvkcESo5F37twWwD8CUyjwYSZOfB+UymBoUZgt16mgWaMAVgFM70wQwtpUJVEJCC4yA5aCEUCvvovrrS0RS1a29UZTh2nGhIgTGmLChGEzGJZq4EdsyY0LpGjIlhwALVxiIba9sp6oiCnQlA95EJ7jp8rIwZ6TuPoif/rI1RbXwvBG5LQgUdUr0G8rh5C5PgmJk9CSjP6d0t8IYm/U0DGnkxIpPE+yBKGHuzBRgnLjpBTP6gIMrPnXi5w7Ui8jW3/DwTpRw4qcA48RPLxgnfjhJYEqO7kgCzjxpUFNy1QQ1li9JE8d8whSfIpcKIK5rbbo8KuA455EByTWHakBTcTRN/tBEunVr2EjKMKNYHF3bRunWtdmBjOUlXYUi57Yrm8GAiublsrRS8bLYQ8OLvWnECuS90Gfq/Y0/lsb9loQTtItSNs4RQ537/uLKxW2Gfke4vd+qDWUWzY2Krizbjeze5ysYyeSFK5XooPhmd12F0nX8sFU6gEs8eo7y5Nd6w51RfVxw23ppvAqEZlB39c0LoEPvGwkeXRzxfGHMHYcMCc/6JqDOsp5iibr3IHOmHC5etQ+pD2fjMOgRv1QfXB711T8nARvjk0o98LVQ33uBb179gGLEthWw8nToGQfkxskKP6o8MgO8GuCrsHOwL8HjQ50xItWaixduvyPouOw5P6KVP7SV7jWB7XKw1/qIS8Ly9USOB780TJSgH3feoAZCMCD2C4EApNKYxsO5QAsVJMtNRm3lMqNKn0vPH/f0N9W1RqU5rzRnu155zGoXRYyOJRiVr1OpF3kujRuc3rBq4aNK+ryxOrvhdDWsUcSp1JVq/MTUfgbBt6X5++CwgPpmgydAxk/HHWoPmYlvXEveYkOJRoZOhlXpA+LI4N8cF0ol8Wca4S6yc2Yq0fut5nm/RB1rLSIkDur/K/H+Sb/XLIFHuGgWxQNRz2VizUzLP8r2ihizU8kIOd8iML4hhHkDgv2K8rVZ2vXTAAqH+k0rISlJqVe+We4r8sL2CjiwmtuQPVPWOJsXVYwK73fKGk8lv1JO1W87t5QG9f1F7XPT+ekkzg+Gs6vsfm5sbUFOWdShyHxWu9ASzalqI36ahK8KTYezA9G0N1YLFD0414MmkO//A9zgF+k=";

    public static class l111l11111lIl {
        public static final int l111l1111lI1l = 2;
        public static final int l111l1111lIl = 3;
        public static final int l111l1111llIl = 1;
        public String l1111l111111Il;
        public String l111l11111I1l;
        public List<String> l111l11111Il;
        public String l111l11111lIl;
        public int l111l1111l1Il;

        public l111l11111lIl() {
        }

        public String l1111l111111Il() {
            return this.l111l11111lIl;
        }

        public void l1111l111111Il(int i) {
            this.l111l1111l1Il = i;
        }

        public void l1111l111111Il(String str) {
            this.l111l11111lIl = str;
        }

        public void l1111l111111Il(List<String> list) {
            this.l111l11111Il = list;
        }

        public String l111l11111I1l() {
            return this.l111l11111I1l;
        }

        public void l111l11111I1l(String str) {
            this.l111l11111I1l = str;
        }

        public List<String> l111l11111Il() {
            return this.l111l11111Il;
        }

        public String l111l11111lIl() {
            return this.l1111l111111Il;
        }

        public void l111l11111lIl(String str) {
            this.l1111l111111Il = str;
        }

        public int l111l1111l1Il() {
            return this.l111l1111l1Il;
        }
    }

    public static int l1111l111111Il(boolean z) {
        return z ? 1 : 0;
    }

    public static String l1111l111111Il(UUID uuid) {
        MediaDrm mediaDrm;
        int i = Build.VERSION.SDK_INT;
        try {
            mediaDrm = new MediaDrm(uuid);
            try {
                String strEncodeToString = Base64.encodeToString(mediaDrm.getPropertyByteArray("deviceUniqueId"), 2);
                try {
                    mediaDrm.release();
                } catch (Throwable unused) {
                }
                return strEncodeToString;
            } catch (Throwable unused2) {
                if (mediaDrm == null) {
                    return "";
                }
                try {
                    int i2 = Build.VERSION.SDK_INT;
                    mediaDrm.release();
                    return "";
                } catch (Throwable unused3) {
                    return "";
                }
            }
        } catch (Throwable unused4) {
            mediaDrm = null;
        }
    }

    public static Map<String, Object> l1111l111111Il() {
        HashMap map = new HashMap();
        try {
            Object objInvoke = Class.forName("android.content.Context").getDeclaredMethod("getSystemService", String.class).invoke(l11l11l111Il.l1111l111111Il, "accessibility");
            Method declaredMethod = objInvoke.getClass().getDeclaredMethod("isEnabled", null);
            Method declaredMethod2 = objInvoke.getClass().getDeclaredMethod("getEnabledAccessibilityServiceList", Integer.TYPE);
            Object objInvoke2 = declaredMethod.invoke(objInvoke, null);
            List list = (List) declaredMethod2.invoke(objInvoke, -1);
            ArrayList arrayList = new ArrayList();
            for (Object obj : list) {
                Object objInvoke3 = obj.getClass().getDeclaredMethod("getId", null).invoke(obj, null);
                if (objInvoke3 == null) {
                    Object objInvoke4 = obj.getClass().getDeclaredMethod("getResolveInfo", null).invoke(obj, null);
                    arrayList.add(objInvoke4 == null ? obj.toString() : objInvoke4.toString());
                } else {
                    arrayList.add((String) objInvoke3);
                }
            }
            map.put("enable", ((Boolean) objInvoke2).booleanValue() ? "1" : "0");
            map.put("service", arrayList);
            map.put("suc", "1");
        } catch (Throwable th) {
            map.put(l1l11I11l.l111l1111lIl, "" + th.getMessage());
            map.put("suc", "-1");
        }
        return map;
    }

    public static void l1111l111111Il(Class<?> cls, String str, Set<Object> set) {
        try {
            Field declaredField = cls.getDeclaredField(str);
            declaredField.setAccessible(true);
            set.addAll(((Map) declaredField.get(null)).keySet());
        } catch (Throwable unused) {
        }
    }

    public static boolean l1111l111111Il(ClassLoader classLoader, String str) {
        if (classLoader == null || !(classLoader instanceof BaseDexClassLoader)) {
            return false;
        }
        try {
            Class<?> cls = Class.forName("dalvik.system.DexPathList");
            Method method = Class.forName("dalvik.system.DexPathList$Element").getMethod("toString", null);
            Field declaredField = cls.getDeclaredField("dexElements");
            declaredField.setAccessible(true);
            Field declaredField2 = BaseDexClassLoader.class.getDeclaredField("pathList");
            declaredField2.setAccessible(true);
            Object[] objArr = (Object[]) declaredField.get(declaredField2.get(classLoader));
            for (Object obj : objArr) {
                String str2 = (String) method.invoke(obj, null);
                if (str2 != null && str2.contains(str)) {
                    return true;
                }
            }
        } catch (Throwable unused) {
        }
        return false;
    }

    public static boolean l1111l111111Il(String str) {
        try {
            ClassLoader systemClassLoader = ClassLoader.getSystemClassLoader();
            if (l1111l111111Il(systemClassLoader, str) || l1111l111111Il(systemClassLoader.getParent(), str)) {
                return true;
            }
            ClassLoader classLoader = l1111l111111Il.class.getClassLoader();
            return l1111l111111Il(classLoader, str) || l1111l111111Il(classLoader.getParent(), str);
        } catch (Throwable unused) {
            return false;
        }
    }

    public static Class[] l1111l111111Il(List<String> list) throws Exception {
        Class<?> cls;
        if (list == null || list.size() == 0) {
            return null;
        }
        ArrayList arrayList = new ArrayList();
        for (String str : list) {
            str.getClass();
            str.hashCode();
            switch (str) {
                case "double":
                    cls = Double.TYPE;
                    break;
                case "int":
                    cls = Integer.TYPE;
                    break;
                case "byte":
                    cls = Byte.TYPE;
                    break;
                case "char":
                    cls = Character.TYPE;
                    break;
                case "long":
                    cls = Long.TYPE;
                    break;
                case "boolean":
                    cls = Boolean.TYPE;
                    break;
                case "float":
                    cls = Float.TYPE;
                    break;
                case "short":
                    cls = Short.TYPE;
                    break;
                default:
                    cls = Class.forName(str);
                    break;
            }
            arrayList.add(cls);
        }
        Class[] clsArr = new Class[arrayList.size()];
        arrayList.toArray(clsArr);
        return clsArr;
    }

    public static String[] l1111l111111Il(Throwable th) {
        try {
            ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
            th.printStackTrace(new PrintStream(byteArrayOutputStream));
            return byteArrayOutputStream.toString().split("\n");
        } catch (Throwable unused) {
            return null;
        }
    }

    public static boolean l111l11111I1l() {
        try {
            return l1111l111111Il("XposedBridge.jar");
        } catch (Throwable unused) {
            return false;
        }
    }

    public static Map<String, Object> l111l11111Il() {
        boolean z;
        Field field;
        Class<?> clsLoadClass;
        Method declaredMethod;
        HashMap map = new HashMap();
        try {
            Field[] declaredFields = ClassLoader.getSystemClassLoader().loadClass("de.robv.android.xposed.XposedBridge").getDeclaredFields();
            int length = declaredFields.length;
            int i = 0;
            while (true) {
                if (i >= length) {
                    z = false;
                    field = null;
                    break;
                }
                field = declaredFields[i];
                if ("sHookedMethodCallbacks".equals(field.getName())) {
                    z = false;
                    break;
                }
                if ("hookedMethodCallbacks".equals(field.getName())) {
                    z = true;
                    break;
                }
                i++;
            }
            if (field == null) {
                return map;
            }
            field.setAccessible(true);
            Map map2 = (Map) field.get(null);
            if (z) {
                clsLoadClass = null;
                declaredMethod = null;
            } else {
                clsLoadClass = ClassLoader.getSystemClassLoader().loadClass("de.robv.android.xposed.XposedBridge$CopyOnWriteSortedSet");
                declaredMethod = clsLoadClass.getDeclaredMethod("getSnapshot", null);
                declaredMethod.setAccessible(true);
            }
            for (Object obj : map2.entrySet()) {
                String string = ((Map.Entry) obj).getKey().toString();
                Set hashSet = (Set) map.get(string);
                if (hashSet == null) {
                    hashSet = new HashSet();
                    map.put(string, hashSet);
                }
                Object value = ((Map.Entry) obj).getValue();
                Object[] array = (clsLoadClass == null || !clsLoadClass.isInstance(value)) ? TreeSet.class.isInstance(value) ? ((TreeSet) value).toArray() : null : (Object[]) declaredMethod.invoke(value, null);
                if (array != null) {
                    for (Object obj2 : array) {
                        hashSet.add(obj2.getClass().getName());
                    }
                }
            }
        } catch (Throwable unused) {
        }
        return map;
    }

    public static Map<String, Object> l111l11111lIl() {
        HashMap map = new HashMap();
        try {
            ArrayList<l111l11111lIl> arrayList = new ArrayList();
            JSONArray jSONArray = new JSONArray(l11l1111I1l());
            for (int i = 0; i < jSONArray.length(); i++) {
                try {
                    JSONObject jSONObject = jSONArray.getJSONObject(i);
                    String string = jSONObject.getString("key");
                    String string2 = jSONObject.getString("clazz");
                    String string3 = jSONObject.getString(FirebaseAnalytics.Param.METHOD);
                    JSONArray jSONArray2 = jSONObject.getJSONArray("param");
                    int i2 = jSONObject.getInt(l11l11I1111l.l111l1111l1Il);
                    l111l11111lIl l111l11111lil = new l111l11111lIl();
                    l111l11111lil.l1111l111111Il = string;
                    l111l11111lil.l111l11111lIl = string2;
                    l111l11111lil.l111l11111I1l = string3;
                    l111l11111lil.l111l1111l1Il = i2;
                    ArrayList arrayList2 = new ArrayList();
                    for (int i3 = 0; i3 < jSONArray2.length(); i3++) {
                        arrayList2.add(jSONArray2.getString(i3));
                    }
                    l111l11111lil.l111l11111Il = arrayList2;
                    arrayList.add(l111l11111lil);
                } catch (Throwable unused) {
                }
            }
            for (l111l11111lIl l111l11111lil2 : arrayList) {
                try {
                    Class<?> cls = Class.forName(l111l11111lil2.l1111l111111Il().replace(RemoteSettings.FORWARD_SLASH_STRING, "."));
                    int iL111l1111l1Il = l111l11111lil2.l111l1111l1Il();
                    List<String> listL111l11111Il = l111l11111lil2.l111l11111Il();
                    if (iL111l1111l1Il != 3) {
                        if (Modifier.isNative(((listL111l11111Il == null || listL111l11111Il.size() == 0) ? cls.getDeclaredMethod(l111l11111lil2.l111l11111I1l(), null) : cls.getDeclaredMethod(l111l11111lil2.l111l11111I1l(), l1111l111111Il(listL111l11111Il))).getModifiers())) {
                            map.put(l111l11111lil2.l1111l111111Il(), 1);
                        }
                    } else if (Modifier.isNative(((listL111l11111Il == null || listL111l11111Il.size() == 0) ? cls.getConstructor(null) : cls.getConstructor(l1111l111111Il(listL111l11111Il))).getModifiers())) {
                        map.put(l111l11111lil2.l1111l111111Il(), 1);
                    }
                } catch (Throwable unused2) {
                }
            }
        } catch (Throwable unused3) {
        }
        return map;
    }

    public static Set<Object> l111l1111l1Il() {
        HashSet hashSet = new HashSet();
        try {
            Class<?> clsLoadClass = ClassLoader.getSystemClassLoader().loadClass("de.robv.android.xposed.XposedHelpers");
            l1111l111111Il(clsLoadClass, "fieldCache", hashSet);
            l1111l111111Il(clsLoadClass, "methodCache", hashSet);
            l1111l111111Il(clsLoadClass, "constructorCache", hashSet);
        } catch (Throwable unused) {
        }
        return hashSet;
    }

    public static String l111l1111lI1l() {
        StringBuilder sb = new StringBuilder();
        try {
            Method method = Class.forName("android.os.ServiceManager").getMethod("getService", String.class);
            method.setAccessible(true);
            Object objInvoke = method.invoke(null, FirebaseAnalytics.Param.LOCATION);
            Object objInvoke2 = method.invoke(null, "phone");
            sb.append("locateServiceName:");
            sb.append(objInvoke.getClass().getName());
            sb.append("|");
            sb.append("phoneServiceName:");
            sb.append(objInvoke2.getClass().getName());
        } catch (Throwable unused) {
        }
        return sb.toString();
    }

    public static String l111l1111lIl() {
        try {
            return l1111l111111Il(new UUID(-1301668207276963122L, -6645017420763422227L)) + "_" + l1111l111111Il(new UUID(1186680826959645954L, -5988876978535335093L)) + "_" + l1111l111111Il(new UUID(-2129748144642739255L, 8654423357094679310L)) + "_" + l1111l111111Il(new UUID(-7348484286925749626L, -6083546864340672619L));
        } catch (Throwable unused) {
            return null;
        }
    }

    public static List<String> l111l1111llIl() {
        BufferedReader bufferedReader;
        PackageManager packageManager;
        ApplicationInfo applicationInfo;
        Bundle bundle;
        Object obj;
        Object obj2;
        Object obj3;
        String string;
        ArrayList arrayList = new ArrayList();
        HashSet<String> hashSet = new HashSet();
        Context context = l11l11l111Il.l1111l111111Il;
        if (context == null) {
            return arrayList;
        }
        try {
            bufferedReader = new BufferedReader(new FileReader("/proc/self/maps"));
            while (true) {
                try {
                    String line = bufferedReader.readLine();
                    if (line == null) {
                        break;
                    }
                    try {
                        int iIndexOf = line.indexOf("/data/app/");
                        if (iIndexOf != -1) {
                            int iIndexOf2 = line.indexOf("-", iIndexOf);
                            if (iIndexOf2 == -1) {
                                iIndexOf2 = line.indexOf(RemoteSettings.FORWARD_SLASH_STRING, iIndexOf + 10);
                            }
                            String strSubstring = line.substring(iIndexOf + 10, iIndexOf2);
                            if (!strSubstring.equals(context.getPackageName())) {
                                hashSet.add(strSubstring);
                            }
                        }
                    } catch (Throwable unused) {
                    }
                } catch (Throwable unused2) {
                    if (bufferedReader != null) {
                        try {
                            bufferedReader.close();
                        } catch (Throwable unused3) {
                        }
                    }
                    packageManager = context.getPackageManager();
                    for (String str : hashSet) {
                        try {
                            applicationInfo = packageManager.getApplicationInfo(str, 128);
                            bundle = applicationInfo.metaData;
                            if (bundle == null) {
                                obj = bundle.get("xposedmodule");
                                obj2 = bundle.get("xposedminversion");
                                obj3 = bundle.get("xposeddescription");
                                if (obj == null) {
                                    if (Build.VERSION.SDK_INT >= 29) {
                                        string = "";
                                    } else {
                                        string = applicationInfo.loadLabel(packageManager).toString();
                                    }
                                    arrayList.add(TextUtils.join(",", new Object[]{str, string, obj, obj2, obj3}));
                                }
                            }
                        } catch (Throwable unused4) {
                        }
                    }
                    return arrayList;
                }
            }
        } catch (Throwable unused5) {
            bufferedReader = null;
        }
        bufferedReader.close();
        try {
            packageManager = context.getPackageManager();
            while (r1.hasNext()) {
                applicationInfo = packageManager.getApplicationInfo(str, 128);
                bundle = applicationInfo.metaData;
                if (bundle == null) {
                    obj = bundle.get("xposedmodule");
                    obj2 = bundle.get("xposedminversion");
                    obj3 = bundle.get("xposeddescription");
                    if (obj == null) {
                        if (Build.VERSION.SDK_INT >= 29) {
                            string = "";
                        } else {
                            string = applicationInfo.loadLabel(packageManager).toString();
                        }
                        arrayList.add(TextUtils.join(",", new Object[]{str, string, obj, obj2, obj3}));
                    }
                }
            }
        } catch (Throwable unused6) {
        }
        return arrayList;
    }

    public static String l111l11IlIlIl() {
        ArrayList arrayList = new ArrayList();
        try {
            Field declaredField = Class.forName("de.robv.android.xposed.XposedInit").getDeclaredField("loadedPackagesInProcess");
            declaredField.setAccessible(true);
            arrayList.addAll((Set) declaredField.get(null));
        } catch (Throwable unused) {
        }
        return TextUtils.join("|", arrayList);
    }

    public static boolean l11l1111I11l() {
        try {
            Class.forName("de.robv.android.xposed.XposedHelpers");
        } catch (Throwable th) {
            String[] strArrL1111l111111Il = l1111l111111Il(th);
            if (strArrL1111l111111Il != null) {
                for (String str : strArrL1111l111111Il) {
                    if (str.contains("de.robvf.android.xposed.XposedHelpers")) {
                        return true;
                    }
                }
            }
        }
        return false;
    }

    public static String l11l1111I1l() {
        try {
            return new String(l11l1l1I1l.l1111l111111Il(Base64.decode(l1111l111111Il, 0)));
        } catch (Throwable unused) {
            return "";
        }
    }

    public static List<String> l11l1111I1ll() {
        InputMethodManager inputMethodManager;
        List<InputMethodInfo> inputMethodList;
        ArrayList arrayList = new ArrayList();
        try {
            Context context = l11l11l111Il.l1111l111111Il;
            if (context == null || (inputMethodManager = (InputMethodManager) context.getSystemService("input_method")) == null || (inputMethodList = inputMethodManager.getInputMethodList()) == null) {
                return arrayList;
            }
            Iterator<InputMethodInfo> it = inputMethodList.iterator();
            while (it.hasNext()) {
                arrayList.add(it.next().toString());
            }
        } catch (Throwable unused) {
        }
        return arrayList;
    }

    public static Map<String, Object> l11l1111Il() {
        if (!l1l1l11Ill.l111l1111l1Il("android.permission.ACCESS_FINE_LOCATION")) {
            return null;
        }
        Location location = new Location("gps");
        if (location.getLongitude() < 1.0E-4d || location.getLatitude() < 1.0E-4d) {
            return null;
        }
        HashMap map = new HashMap();
        map.put(FirebaseAnalytics.Param.LOCATION, location.toString());
        map.put("lo", Double.valueOf(location.getLongitude()));
        map.put("la", Double.valueOf(location.getLatitude()));
        return map;
    }

    public static String l11l1111Il1l() {
        Context context = l11l11l111Il.l1111l111111Il;
        if (context == null) {
            return "";
        }
        return String.format(Locale.US, "%d%d%d%d%d%d%d", Integer.valueOf(context.checkSelfPermission("android.permission.READ_PHONE_STATE") == 0 ? 1 : 0), Integer.valueOf(context.checkSelfPermission("android.permission.WRITE_EXTERNAL_STORAGE") == 0 ? 1 : 0), Integer.valueOf(context.checkSelfPermission("android.permission.WRITE_SETTINGS") == 0 ? 1 : 0), Integer.valueOf(context.checkSelfPermission("android.permission.ACCESS_WIFI_STATE") == 0 ? 1 : 0), Integer.valueOf(context.checkSelfPermission("android.permission.ACCESS_NETWORK_STATE") == 0 ? 1 : 0), Integer.valueOf(context.checkSelfPermission("android.permission.ACCESS_FINE_LOCATION") == 0 ? 1 : 0), Integer.valueOf(context.checkSelfPermission("android.permission.ACCESS_COARSE_LOCATION") == 0 ? 1 : 0));
    }

    public static List<String> l11l1111Ill() {
        String line;
        try {
            ArrayList arrayList = new ArrayList();
            Process processExec = Runtime.getRuntime().exec(new String[]{"sh", "-c", "set"});
            BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(processExec.getInputStream()));
            while (true) {
                line = bufferedReader.readLine();
                if (TextUtils.isEmpty(line)) {
                    break;
                }
                if (line.contains("V_SO_PATH") || line.contains("V_SO_PATH") || line.contains("V_REPLACE") || line.contains("VMOS_ROOT_DIR")) {
                    arrayList.add(line);
                }
            }
            for (String line2 = new BufferedReader(new InputStreamReader(processExec.getErrorStream())).readLine(); !TextUtils.isEmpty(line2); line2 = bufferedReader.readLine()) {
                if (line2.contains("libva.so")) {
                    arrayList.add(line);
                }
            }
            return arrayList;
        } catch (Throwable unused) {
            return null;
        }
    }

    public static List<String> l11l1111lIIl() {
        String[] strArr = {"java.lang.Throwable", "at com.ishumei", "at android.view.View", "at android.os.Handler", "at android.os.Looper", "at android.app.ActivityThread", "at java.lang.reflect.Method", "at com.android.internal.os"};
        String[] strArrL1111l111111Il = l1111l111111Il(new Throwable());
        ArrayList arrayList = new ArrayList();
        if (strArrL1111l111111Il == null) {
            return arrayList;
        }
        for (String str : strArrL1111l111111Il) {
            int i = 0;
            while (true) {
                if (i >= 8) {
                    arrayList.add(str.trim());
                    break;
                }
                if (str.trim().startsWith(strArr[i])) {
                    break;
                }
                i++;
            }
        }
        return arrayList;
    }

    public static String l11l111l11Il() {
        if (Build.VERSION.SDK_INT >= 28) {
            return "";
        }
        ArrayList arrayList = new ArrayList();
        try {
            Class<?> cls = Class.forName("android.app.ApplicationLoaders");
            Field declaredField = cls.getDeclaredField("gApplicationLoaders");
            declaredField.setAccessible(true);
            Object obj = declaredField.get(null);
            Field declaredField2 = cls.getDeclaredField("mLoaders");
            declaredField2.setAccessible(true);
            for (Map.Entry entry : ((Map) declaredField2.get(obj)).entrySet()) {
                String str = (String) entry.getKey();
                try {
                    Class.forName("com.elderdrivers.riru.edxp.config.EdXpConfigGlobal", false, (ClassLoader) entry.getValue());
                    arrayList.add(str);
                } catch (Throwable unused) {
                }
            }
        } catch (Throwable unused2) {
        }
        return TextUtils.join("|", arrayList);
    }

    public static String l11l111l1lll() {
        ArrayList arrayList = new ArrayList();
        try {
            Field declaredField = Class.forName("de.robv.android.xposed.XposedInit").getDeclaredField("loadedModules");
            declaredField.setAccessible(true);
            Iterator it = ((ArraySet) declaredField.get(null)).iterator();
            while (it.hasNext()) {
                arrayList.add(it.next().toString());
            }
        } catch (Throwable unused) {
        }
        return TextUtils.join("|", arrayList);
    }

    public static int l11l11IlIIll() {
        Context context = l11l11l111Il.l1111l111111Il;
        if (context == null) {
            return 0;
        }
        StringBuilder sb = new StringBuilder();
        sb.append(context.getFilesDir());
        sb.append(File.separator);
        sb.append("exp_base.apk");
        return new File(sb.toString()).exists() ? 1 : 0;
    }
}
