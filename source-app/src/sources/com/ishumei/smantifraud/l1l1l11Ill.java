package com.ishumei.smantifraud;

import android.app.Application;
import android.content.Context;
import android.os.Environment;
import android.text.TextUtils;
import android.util.Base64;
import android.util.Patterns;
import com.google.common.primitives.UnsignedBytes;
import com.google.firebase.sessions.settings.RemoteSettings;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.Closeable;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.reflect.Array;
import java.lang.reflect.Field;
import java.net.HttpURLConnection;
import java.net.URLEncoder;
import java.nio.ByteBuffer;
import java.nio.channels.FileChannel;
import java.nio.channels.FileLock;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import java.util.Set;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

public class l1l1l11Ill {
    public static Context l1111l111111Il() {
        try {
            return (Application) Class.forName("android.app.ActivityThread").getMethod("currentApplication", null).invoke(null, null);
        } catch (Throwable unused) {
            return null;
        }
    }

    public static Object l1111l111111Il(Field field, Object obj) {
        try {
            Class<?> type = field.getType();
            if (type != Integer.class && type != Double.class && type != Float.class && type != Long.class) {
                if (type == String.class) {
                    return obj == null ? "" : obj;
                }
                if (type == Map.class) {
                    return obj == null ? new JSONObject() : new JSONObject((Map) obj);
                }
                if (type != List.class && type != Set.class) {
                    return obj == null ? type.newInstance() : obj;
                }
                return obj == null ? new JSONArray() : new JSONArray((Collection) obj);
            }
            if (obj == null) {
                return -1;
            }
            return obj;
        } catch (Exception unused) {
            return new Object();
        }
    }

    public static String l1111l111111Il(File file) throws Throwable {
        Throwable th;
        BufferedReader bufferedReader;
        if (file == null || !file.exists()) {
            throw new IOException("not exist");
        }
        try {
            bufferedReader = new BufferedReader(new FileReader(file));
            try {
                String line = bufferedReader.readLine();
                bufferedReader.close();
                return line;
            } catch (Throwable th2) {
                th = th2;
                if (bufferedReader != null) {
                    bufferedReader.close();
                }
                throw th;
            }
        } catch (Throwable th3) {
            th = th3;
            bufferedReader = null;
        }
    }

    public static String l1111l111111Il(String str) {
        if (str != null && str.length() != 0) {
            try {
                return URLEncoder.encode(str, "UTF-8");
            } catch (Exception unused) {
            }
        }
        return "";
    }

    public static String l1111l111111Il(byte[] bArr) throws IOException {
        try {
            return Base64.encodeToString(bArr, 2);
        } catch (Exception e) {
            throw new IOException(e);
        }
    }

    public static String l1111l111111Il(String[] strArr) {
        try {
            Process processExec = Runtime.getRuntime().exec(strArr);
            InputStreamReader inputStreamReader = new InputStreamReader(processExec.getErrorStream());
            BufferedReader bufferedReader = new BufferedReader(inputStreamReader);
            String line = bufferedReader.readLine();
            bufferedReader.close();
            inputStreamReader.close();
            processExec.destroy();
            return line;
        } catch (Throwable unused) {
            return "";
        }
    }

    public static List<String> l1111l111111Il(File file, Set<String> set, int i) {
        String[] list;
        ArrayList arrayList = new ArrayList();
        if (file != null && file.isDirectory() && set != null && set.size() != 0 && (list = file.list()) != null && list.length != 0) {
            HashSet hashSet = new HashSet(set);
            for (String str : list) {
                Iterator it = hashSet.iterator();
                if (i == 0) {
                    while (it.hasNext()) {
                        String str2 = (String) it.next();
                        if (str.contains(str2)) {
                            arrayList.add(str2);
                        }
                    }
                } else if (i == 1) {
                    String lowerCase = str.toLowerCase();
                    while (it.hasNext()) {
                        String str3 = (String) it.next();
                        if (lowerCase.contains(str3.toLowerCase())) {
                            arrayList.add(str3);
                        }
                    }
                } else if (i == 2) {
                    while (it.hasNext()) {
                        if (Pattern.compile((String) it.next()).matcher(str).find()) {
                            arrayList.add(str);
                        }
                    }
                }
            }
        }
        return arrayList;
    }

    public static List<String> l1111l111111Il(String str, Set<String> set, int i) {
        return TextUtils.isEmpty(str) ? Collections.emptyList() : l1111l111111Il(new File(str), set, i);
    }

    public static List<Object> l1111l111111Il(JSONArray jSONArray) {
        ArrayList arrayList = new ArrayList();
        if (jSONArray == null) {
            return arrayList;
        }
        int length = jSONArray.length();
        for (int i = 0; i < length; i++) {
            Object objOpt = jSONArray.opt(i);
            if (objOpt != null) {
                arrayList.add(l111l11111I1l(objOpt));
            }
        }
        return arrayList;
    }

    public static Map<String, Object> l1111l111111Il(JSONObject jSONObject) {
        HashMap map = new HashMap();
        if (jSONObject == null) {
            return map;
        }
        Iterator<String> itKeys = jSONObject.keys();
        while (itKeys.hasNext()) {
            String next = itKeys.next();
            Object objOpt = jSONObject.opt(next);
            if (objOpt != null) {
                map.put(next, l111l11111I1l(objOpt));
            }
        }
        return map;
    }

    public static JSONArray l1111l111111Il(Object obj) throws JSONException {
        if (!obj.getClass().isArray()) {
            throw new JSONException("Not a primitive data: " + obj.getClass());
        }
        int length = Array.getLength(obj);
        JSONArray jSONArray = new JSONArray();
        for (int i = 0; i < length; i++) {
            jSONArray.put(l111l11111Il(Array.get(obj, i)));
        }
        return jSONArray;
    }

    public static JSONArray l1111l111111Il(Collection collection) {
        JSONArray jSONArray = new JSONArray();
        if (collection != null) {
            Iterator it = collection.iterator();
            while (it.hasNext()) {
                jSONArray.put(l111l11111Il(it.next()));
            }
        }
        return jSONArray;
    }

    public static JSONObject l1111l111111Il(Object obj, Set<String> set) {
        JSONObject jSONObject = new JSONObject();
        if (obj == null) {
            return jSONObject;
        }
        for (Field field : obj.getClass().getDeclaredFields()) {
            try {
                if (!field.getName().equals("serialVersionUID")) {
                    field.setAccessible(true);
                    Object obj2 = field.get(obj);
                    l111l111Il1l l111l111il1l = (l111l111Il1l) field.getAnnotation(l111l111Il1l.class);
                    if (l111l111il1l != null) {
                        String strValue = l111l111il1l.value();
                        if (!l111l11111lIl((Object) strValue) && !l111l11111lIl(obj2) && (set == null || set.contains(strValue))) {
                            jSONObject.put(strValue, l1111l111111Il(field, obj2));
                        }
                    } else if (set == null || set.contains(field.getName())) {
                        jSONObject.put(field.getName(), obj2);
                    }
                }
            } catch (Exception unused) {
            }
        }
        return jSONObject;
    }

    public static JSONObject l1111l111111Il(Map<?, ?> map) {
        JSONObject jSONObject = new JSONObject();
        try {
            for (Map.Entry<?, ?> entry : map.entrySet()) {
                String str = (String) entry.getKey();
                if (str == null) {
                    throw new NullPointerException("key == null");
                }
                try {
                    jSONObject.put(str, l111l11111Il(entry.getValue()));
                } catch (JSONException unused) {
                }
            }
        } catch (Exception unused2) {
        }
        return jSONObject;
    }

    public static void l1111l111111Il(Closeable closeable) {
        if (closeable != null) {
            try {
                closeable.close();
            } catch (Throwable unused) {
            }
        }
    }

    public static void l1111l111111Il(File file, String str) throws Exception {
        FileWriter fileWriter;
        if (file == null || l11l11Il11l.l1111l111111Il(str)) {
            throw new IOException("file or bytes empty");
        }
        try {
            fileWriter = new FileWriter(file);
            try {
                fileWriter.write(str);
                fileWriter.close();
            } catch (Throwable th) {
                th = th;
                if (fileWriter != null) {
                    fileWriter.close();
                }
                throw th;
            }
        } catch (Throwable th2) {
            th = th2;
            fileWriter = null;
        }
    }

    public static void l1111l111111Il(File file, byte[] bArr) throws Throwable {
        Throwable th;
        FileChannel fileChannel;
        FileLock fileLock;
        Exception e;
        FileLock fileLock2;
        FileOutputStream fileOutputStream;
        FileLock fileLock3;
        if (file == null || bArr == null) {
            throw new IOException("file or bytes empty");
        }
        FileOutputStream fileOutputStream2 = null;
        fileLockLock = null;
        FileLock fileLockLock = null;
        FileChannel fileChannel2 = null;
        FileChannel fileChannel3 = null;
        fileOutputStream2 = null;
        try {
            fileOutputStream = new FileOutputStream(file);
            try {
                FileChannel channel = fileOutputStream.getChannel();
                try {
                    fileLockLock = channel.lock();
                    ByteBuffer byteBufferWrap = ByteBuffer.wrap(bArr);
                    while (byteBufferWrap.hasRemaining()) {
                        channel.write(byteBufferWrap);
                    }
                    fileOutputStream.flush();
                    if (fileLockLock != null) {
                        fileLockLock.release();
                    }
                    channel.close();
                    l1111l111111Il((Closeable) fileOutputStream);
                } catch (Exception e2) {
                    e = e2;
                    FileLock fileLock4 = fileLockLock;
                    fileChannel2 = channel;
                    fileLock3 = fileLock4;
                    fileLock = fileLock3;
                    fileChannel = fileChannel2;
                    fileOutputStream2 = fileOutputStream;
                    try {
                        throw new IOException(e);
                    } catch (Throwable th2) {
                        th = th2;
                        FileOutputStream fileOutputStream3 = fileOutputStream2;
                        fileChannel3 = fileChannel;
                        fileLock2 = fileLock;
                        fileOutputStream = fileOutputStream3;
                        if (fileLock2 != null) {
                            fileLock2.release();
                        }
                        if (fileChannel3 != null) {
                            fileChannel3.close();
                        }
                        l1111l111111Il((Closeable) fileOutputStream);
                        throw th;
                    }
                } catch (Throwable th3) {
                    th = th3;
                    FileLock fileLock5 = fileLockLock;
                    fileChannel3 = channel;
                    fileLock2 = fileLock5;
                    if (fileLock2 != null) {
                        fileLock2.release();
                    }
                    if (fileChannel3 != null) {
                        fileChannel3.close();
                    }
                    l1111l111111Il((Closeable) fileOutputStream);
                    throw th;
                }
            } catch (Exception e3) {
                e = e3;
                fileLock3 = null;
            } catch (Throwable th4) {
                th = th4;
                fileLock2 = null;
            }
        } catch (Exception e4) {
            e = e4;
            fileChannel = null;
            fileLock = null;
        } catch (Throwable th5) {
            th = th5;
            fileChannel = null;
            fileLock = null;
            FileOutputStream fileOutputStream4 = fileOutputStream2;
            fileChannel3 = fileChannel;
            fileLock2 = fileLock;
            fileOutputStream = fileOutputStream4;
            if (fileLock2 != null) {
                fileLock2.release();
            }
            if (fileChannel3 != null) {
                fileChannel3.close();
            }
            l1111l111111Il((Closeable) fileOutputStream);
            throw th;
        }
    }

    public static void l1111l111111Il(String str, String str2) throws Exception {
        if (l11l11Il11l.l1111l111111Il(str) || l11l11Il11l.l1111l111111Il(str2)) {
            throw new IOException("file or bytes empty");
        }
        l1111l111111Il(str, str2.getBytes(l11l11l1lI1l.l11l111ll1Il));
    }

    public static void l1111l111111Il(String str, byte[] bArr) throws Throwable {
        if (l11l11Il11l.l1111l111111Il(str) || bArr == null) {
            throw new IOException("filename or byes empty");
        }
        try {
            l1111l111111Il(new File(str), bArr);
        } catch (Exception e) {
            throw new IOException(e);
        }
    }

    public static void l1111l111111Il(HttpURLConnection httpURLConnection) {
        if (httpURLConnection != null) {
            try {
                httpURLConnection.disconnect();
            } catch (Throwable unused) {
            }
        }
    }

    public static byte[] l1111l111111Il(FileChannel fileChannel) throws Throwable {
        ByteArrayOutputStream byteArrayOutputStream;
        try {
            try {
                byteArrayOutputStream = new ByteArrayOutputStream();
                try {
                    ByteBuffer byteBufferAllocate = ByteBuffer.allocate(100);
                    int i = 0;
                    int i2 = 0;
                    while (true) {
                        int i3 = fileChannel.read(byteBufferAllocate, i);
                        if (i3 <= 0) {
                            break;
                        }
                        i += i3;
                        i2 += i3;
                    }
                    byte[] bArrArray = byteBufferAllocate.array();
                    if (i2 >= 4 && (bArrArray[0] & UnsignedBytes.MAX_VALUE) == 0 && (bArrArray[1] & UnsignedBytes.MAX_VALUE) == 0 && (bArrArray[2] & UnsignedBytes.MAX_VALUE) == 0 && (bArrArray[3] & UnsignedBytes.MAX_VALUE) == 0) {
                        throw new IOException("read bytes not utf-8");
                    }
                    byteArrayOutputStream.write(bArrArray, 0, i2);
                    byte[] byteArray = byteArrayOutputStream.toByteArray();
                    l1111l111111Il((Closeable) byteArrayOutputStream);
                    return byteArray;
                } catch (Exception e) {
                    e = e;
                    throw new IOException(e);
                } catch (Throwable th) {
                    th = th;
                    l1111l111111Il((Closeable) byteArrayOutputStream);
                    throw th;
                }
            } catch (Throwable th2) {
                th = th2;
                byteArrayOutputStream = null;
            }
        } catch (Exception e2) {
            e = e2;
        }
    }

    public static Object l111l11111I1l(Object obj) {
        if (obj == null) {
            return null;
        }
        if (obj instanceof JSONObject) {
            return l1111l111111Il((JSONObject) obj);
        }
        return obj instanceof JSONArray ? l1111l111111Il((JSONArray) obj) : obj;
    }

    public static String l111l11111I1l(String str) {
        return (str == null || str.isEmpty()) ? "" : str.replaceAll(":", "").toLowerCase();
    }

    public static String l111l11111I1l(byte[] bArr) throws IOException {
        if (bArr == null || bArr.length == 0) {
            return "";
        }
        try {
            byte[] bArrDigest = MessageDigest.getInstance("MD5").digest(bArr);
            StringBuilder sb = new StringBuilder(bArrDigest.length * 2);
            for (byte b : bArrDigest) {
                int i = b & UnsignedBytes.MAX_VALUE;
                if (i < 16) {
                    sb.append("0");
                }
                sb.append(Integer.toHexString(i));
            }
            return sb.toString();
        } catch (NoSuchAlgorithmException unused) {
            throw new IOException("fail to md5 data");
        }
    }

    public static Object l111l11111Il(Object obj) {
        if (obj == null) {
            return null;
        }
        if ((obj instanceof JSONArray) || (obj instanceof JSONObject)) {
            return obj;
        }
        try {
            if (obj instanceof Collection) {
                return l1111l111111Il((Collection) obj);
            }
            if (obj.getClass().isArray()) {
                return l1111l111111Il(obj);
            }
            if (obj instanceof Map) {
                return l1111l111111Il((Map<?, ?>) obj);
            }
            if (!(obj instanceof Boolean) && !(obj instanceof Byte) && !(obj instanceof Character) && !(obj instanceof Double) && !(obj instanceof Float) && !(obj instanceof Integer) && !(obj instanceof Long) && !(obj instanceof Short) && !(obj instanceof String)) {
                if (obj.getClass().getPackage().getName().startsWith("java.")) {
                    return obj.toString();
                }
                return null;
            }
            return obj;
        } catch (Exception unused) {
        }
    }

    public static String l111l11111Il(String str) {
        if (TextUtils.isEmpty(str)) {
            return null;
        }
        Matcher matcher = Patterns.DOMAIN_NAME.matcher(str);
        if (matcher.find()) {
            return matcher.group(0);
        }
        return null;
    }

    public static String l111l11111lIl(byte[] bArr) {
        StringBuffer stringBuffer = new StringBuffer();
        for (byte b : bArr) {
            if (stringBuffer.length() > 0) {
                stringBuffer.append(":");
            }
            String hexString = Integer.toHexString(b & UnsignedBytes.MAX_VALUE);
            if (hexString.length() == 1) {
                hexString = "0".concat(hexString);
            }
            stringBuffer.append(hexString);
        }
        return stringBuffer.toString();
    }

    public static List<String> l111l11111lIl(File file, Set<String> set, int i) throws Throwable {
        BufferedReader bufferedReader;
        ArrayList arrayList = new ArrayList();
        if (file == null || !file.exists() || !file.canRead() || !file.isFile() || set == null || set.size() == 0) {
            return arrayList;
        }
        HashSet hashSet = new HashSet(set);
        try {
            try {
                bufferedReader = new BufferedReader(new FileReader(file));
                while (true) {
                    try {
                        String line = bufferedReader.readLine();
                        if (line == null) {
                            l1111l111111Il((Closeable) bufferedReader);
                            return arrayList;
                        }
                        if (!l11l11Il11l.l1111l111111Il(line)) {
                            Iterator it = hashSet.iterator();
                            if (i == 0) {
                                while (it.hasNext()) {
                                    String str = (String) it.next();
                                    if (line.contains(str)) {
                                        arrayList.add(str);
                                        it.remove();
                                    }
                                }
                            } else if (i == 1) {
                                String lowerCase = line.toLowerCase();
                                while (it.hasNext()) {
                                    String str2 = (String) it.next();
                                    if (lowerCase.contains(str2.toLowerCase())) {
                                        arrayList.add(str2);
                                        it.remove();
                                    }
                                }
                            } else if (i == 2) {
                                while (it.hasNext()) {
                                    Matcher matcher = Pattern.compile((String) it.next()).matcher(line);
                                    while (matcher.find()) {
                                        arrayList.add(matcher.group(0));
                                    }
                                }
                            }
                        }
                    } catch (Exception e) {
                        e = e;
                        throw new IOException(e);
                    } catch (Throwable th) {
                        th = th;
                        l1111l111111Il((Closeable) bufferedReader);
                        throw th;
                    }
                }
            } catch (Throwable th2) {
                th = th2;
                bufferedReader = null;
            }
        } catch (Exception e2) {
            e = e2;
        }
    }

    public static List<String> l111l11111lIl(String str, Set<String> set, int i) throws IOException {
        return l111l11111lIl(new File(str), set, i);
    }

    public static boolean l111l11111lIl(Object obj) {
        if (obj == null) {
            return true;
        }
        if (obj instanceof String) {
            return TextUtils.isEmpty((String) obj);
        }
        if (obj instanceof Collection) {
            return ((Collection) obj).isEmpty();
        }
        if (obj instanceof Map) {
            return ((Map) obj).isEmpty();
        }
        return false;
    }

    public static byte[] l111l11111lIl(String str) throws IOException {
        try {
            return Base64.decode(str.getBytes(l11l11l1lI1l.l11l111ll1Il), 0);
        } catch (Exception e) {
            throw new IOException(e);
        }
    }

    public static boolean l111l1111l1Il(String str) {
        Context context = l11l11l111Il.l1111l111111Il;
        return context != null && context.checkSelfPermission(str) == 0;
    }

    public static boolean l111l1111lI1l(String str) {
        if (str == null) {
            return false;
        }
        return Patterns.IP_ADDRESS.matcher(str).matches();
    }

    public static boolean l111l1111lIl(String str) {
        try {
            return new File(Environment.getExternalStorageDirectory() + RemoteSettings.FORWARD_SLASH_STRING + str).exists();
        } catch (Throwable unused) {
            return false;
        }
    }

    public static boolean l111l1111llIl(String str) {
        try {
            return new File(str).exists();
        } catch (Throwable unused) {
            return false;
        }
    }

    public static String l11l1111I11l(String str) throws IOException {
        try {
            return l1111l111111Il(new File(str));
        } catch (Exception e) {
            throw new IOException(e);
        }
    }

    public static List<String> l11l1111I1l(String str) throws Throwable {
        BufferedReader bufferedReader;
        Exception e;
        ArrayList arrayList = new ArrayList();
        File file = new File(str);
        BufferedReader bufferedReader2 = null;
        try {
            bufferedReader = new BufferedReader(new FileReader(file));
            while (true) {
                try {
                    try {
                        String line = bufferedReader.readLine();
                        if (line == null) {
                            l1111l111111Il((Closeable) bufferedReader);
                            return arrayList;
                        }
                        if (!l11l11Il11l.l1111l111111Il(line)) {
                            arrayList.add(line);
                        }
                    } catch (Exception e2) {
                        e = e2;
                        throw new IOException(e);
                    }
                } catch (Throwable th) {
                    th = th;
                    bufferedReader2 = bufferedReader;
                }
                th = th;
                bufferedReader2 = bufferedReader;
                l1111l111111Il((Closeable) bufferedReader2);
                throw th;
            }
        } catch (Exception e3) {
            bufferedReader = null;
            e = e3;
        } catch (Throwable th2) {
            th = th2;
        }
    }

    public static String l11l1111lIIl(String str) {
        if (TextUtils.isEmpty(str)) {
            return "";
        }
        try {
            return l111l11111I1l(str.getBytes(l11l11l1lI1l.l11l111ll1Il));
        } catch (Exception unused) {
            return "";
        }
    }
}
