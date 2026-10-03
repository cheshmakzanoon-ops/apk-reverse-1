package BMGame;

import android.app.Application;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.Signature;
import android.os.Build;
import android.os.Environment;
import android.os.Parcel;
import android.os.Parcelable;
import android.util.Base64;
import android.util.Log;
import dalvik.system.VMRuntime;
import java.io.BufferedReader;
import java.io.File;
import java.io.FileOutputStream;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStream;
import java.lang.invoke.MethodHandle;
import java.lang.invoke.MethodHandleInfo;
import java.lang.invoke.MethodHandles;
import java.lang.invoke.MethodType;
import java.lang.reflect.Field;
import java.lang.reflect.Member;
import java.lang.reflect.Method;
import java.util.Arrays;
import java.util.HashSet;
import java.util.Map;
import java.util.zip.ZipEntry;
import java.util.zip.ZipFile;
import sun.misc.Unsafe;

public class GameKillerApp extends Application {
    public static final String URL = "https://github.com/L-JINBIN/ApkSignatureKillerEx";

    public class C0000a {
        private boolean override;
    }

    public final class C0001b {
        private transient int accessFlags;
        private transient int classFlags;
        private transient ClassLoader classLoader;
        private transient int classSize;
        private transient int clinitThreadId;
        private transient Class componentType;
        private transient short copiedMethodsOffset;
        private transient Object dexCache;
        private transient int dexClassDefIndex;
        private volatile transient int dexTypeIndex;
        private transient Object extData;
        private transient long iFields;
        private transient Object[] ifTable;
        private transient long methods;
        private transient String name;
        private transient int numReferenceInstanceFields;
        private transient int numReferenceStaticFields;
        private transient int objectSize;
        private transient int objectSizeAllocFastPath;
        private transient int primitiveType;
        private transient int referenceInstanceOffsets;
        private transient long sFields;
        private transient int status;
        private transient Class superClass;
        private transient short virtualMethodsOffset;
        private transient Object vtable;
    }

    public final class C0002c extends C0000a {
        private int accessFlags;
        private long artMethod;
        private C0001b declaringClass;
        private C0001b declaringClassOfOverriddenMethod;
        private Object[] parameters;
    }

    public final class C0003d {
        private final Member member = null;
        private final C0005f handle = null;
    }

    public final class C0004e {
        private C0004e(Object... objArr) {
            throw new IllegalStateException("Failed to new a instance");
        }

        private static Object invoke(Object... objArr) {
            throw new IllegalStateException("Failed to invoke the method");
        }
    }

    public class C0005f {
        private C0005f cachedSpreadInvoker;
        private MethodType nominalType;
        private final MethodType type = null;
        protected final int handleKind = 0;
        protected final long artFieldOrMethod = 0;
    }

    public final class C0006g extends C0005f {
        private final MethodHandleInfo info = null;
    }

    public final class C0007h {

        private static int f0s;

        private static int f1t;

        private int f2i;

        private int f3j;

        private static void m2a() {
        }

        private static void m3b() {
        }
    }

    public final class C0008i {
    }

    public final class C0009j {

        public static final Unsafe f4a;

        public static final long f5b;

        public static final long f6c;

        public static final long f7d;

        public static final long f8e;

        public static final HashSet f9f = new HashSet();

        static {
            try {
                Unsafe unsafe = (Unsafe) Unsafe.class.getDeclaredMethod("getUnsafe", null).invoke(null, null);
                f4a = unsafe;
                f5b = unsafe.objectFieldOffset(C0002c.class.getDeclaredField("artMethod"));
                unsafe.objectFieldOffset(C0002c.class.getDeclaredField("declaringClass"));
                long jObjectFieldOffset = unsafe.objectFieldOffset(C0005f.class.getDeclaredField("artFieldOrMethod"));
                unsafe.objectFieldOffset(C0006g.class.getDeclaredField("info"));
                long jObjectFieldOffset2 = unsafe.objectFieldOffset(C0001b.class.getDeclaredField("methods"));
                f6c = jObjectFieldOffset2;
                long jObjectFieldOffset3 = unsafe.objectFieldOffset(C0001b.class.getDeclaredField("iFields"));
                unsafe.objectFieldOffset(C0001b.class.getDeclaredField("sFields"));
                unsafe.objectFieldOffset(C0003d.class.getDeclaredField("member"));
                Method declaredMethod = C0007h.class.getDeclaredMethod("a", null);
                Method declaredMethod2 = C0007h.class.getDeclaredMethod("b", null);
                declaredMethod.setAccessible(true);
                declaredMethod2.setAccessible(true);
                MethodHandle methodHandleUnreflect = MethodHandles.lookup().unreflect(declaredMethod);
                MethodHandle methodHandleUnreflect2 = MethodHandles.lookup().unreflect(declaredMethod2);
                long j = unsafe.getLong(methodHandleUnreflect, jObjectFieldOffset);
                long j2 = unsafe.getLong(methodHandleUnreflect2, jObjectFieldOffset);
                long j3 = unsafe.getLong(C0007h.class, jObjectFieldOffset2);
                long j4 = j2 - j;
                f7d = j4;
                f8e = (j - j3) - j4;
                Field declaredField = C0007h.class.getDeclaredField("i");
                Field declaredField2 = C0007h.class.getDeclaredField("j");
                declaredField.setAccessible(true);
                declaredField2.setAccessible(true);
                MethodHandle methodHandleUnreflectGetter = MethodHandles.lookup().unreflectGetter(declaredField);
                MethodHandle methodHandleUnreflectGetter2 = MethodHandles.lookup().unreflectGetter(declaredField2);
                unsafe.getLong(methodHandleUnreflectGetter, jObjectFieldOffset);
                unsafe.getLong(methodHandleUnreflectGetter2, jObjectFieldOffset);
                unsafe.getLong(C0007h.class, jObjectFieldOffset3);
            } catch (ReflectiveOperationException e) {
                Log.e("HiddenApiBypass", "Initialize error", e);
                throw new ExceptionInInitializerError(e);
            }
        }

        public static Object m7a(Class cls, Object obj, String str, Object... objArr) throws NoSuchMethodException {
            if (obj != null && !cls.isInstance(obj)) {
                throw new IllegalArgumentException("this object is not an instance of the given class");
            }
            Method declaredMethod = C0004e.class.getDeclaredMethod("invoke", Object[].class);
            declaredMethod.setAccessible(true);
            Unsafe unsafe = f4a;
            long j = unsafe.getLong(cls, f6c);
            if (j == 0) {
                throw new NoSuchMethodException("Cannot find matching method");
            }
            int i = unsafe.getInt(j);
            for (int i2 = 0; i2 < i; i2++) {
                f4a.putLong(declaredMethod, f5b, (((long) i2) * f7d) + j + f8e);
                if (str.equals(declaredMethod.getName())) {
                    Class<?>[] parameterTypes = declaredMethod.getParameterTypes();
                    if (parameterTypes.length == objArr.length) {
                        for (int i3 = 0; i3 < parameterTypes.length; i3++) {
                            if (parameterTypes[i3].isPrimitive()) {
                                Class<?> cls2 = parameterTypes[i3];
                                if ((cls2 != Integer.TYPE || (objArr[i3] instanceof Integer)) && ((cls2 != Byte.TYPE || (objArr[i3] instanceof Byte)) && ((cls2 != Character.TYPE || (objArr[i3] instanceof Character)) && ((cls2 != Boolean.TYPE || (objArr[i3] instanceof Boolean)) && ((cls2 != Double.TYPE || (objArr[i3] instanceof Double)) && ((cls2 != Float.TYPE || (objArr[i3] instanceof Float)) && ((cls2 != Long.TYPE || (objArr[i3] instanceof Long)) && (cls2 != Short.TYPE || (objArr[i3] instanceof Short))))))))) {
                                }
                            } else {
                                Object obj2 = objArr[i3];
                                if (obj2 == null || parameterTypes[i3].isInstance(obj2)) {
                                }
                            }
                        }
                        return declaredMethod.invoke(obj, objArr);
                    }
                    continue;
                }
            }
            throw new NoSuchMethodException("Cannot find matching method");
        }

        public static boolean m8b(String... strArr) {
            try {
                m7a(VMRuntime.class, m7a(VMRuntime.class, null, "getRuntime", new Object[0]), "setHiddenApiExemptions", strArr);
                return true;
            } catch (Throwable th) {
                Log.w("HiddenApiBypass", "setHiddenApiExemptions", th);
                return false;
            }
        }
    }

    public final class C0010k {
    }

    public final class C0011l implements Parcelable.Creator {

        public final Parcelable.Creator f10a;

        public final String f11b;

        public final Signature f12c;

        public C0011l(Parcelable.Creator creator, String str, Signature signature) {
            this.f10a = creator;
            this.f11b = str;
            this.f12c = signature;
        }

        @Override
        public final Object createFromParcel(Parcel parcel) {
            Signature[] apkContentsSigners;
            PackageInfo packageInfo = (PackageInfo) this.f10a.createFromParcel(parcel);
            if (packageInfo.packageName.equals(this.f11b)) {
                Signature[] signatureArr = packageInfo.signatures;
                Signature signature = this.f12c;
                if (signatureArr != null && signatureArr.length > 0) {
                    signatureArr[0] = signature;
                }
                if (Build.VERSION.SDK_INT >= 28 && packageInfo.signingInfo != null && (apkContentsSigners = packageInfo.signingInfo.getApkContentsSigners()) != null && apkContentsSigners.length > 0) {
                    apkContentsSigners[0] = signature;
                }
            }
            return packageInfo;
        }

        @Override
        public final Object[] newArray(int i) {
            return (PackageInfo[]) this.f10a.newArray(i);
        }
    }

    static {
        killPM("com.fun.lastwar.gp", "MIICnDCCAYSgAwIBAgIEb9+0xDANBgkqhkiG9w0BAQUFADAPMQ0wCwYDVQQKDARMQ1lEMCAXDTIz\nMDExNjEzMjExM1oYDzIwNzMwMTAzMTMyMTEzWjAPMQ0wCwYDVQQKDARMQ1lEMIIBIjANBgkqhkiG\n9w0BAQEFAAOCAQ8AMIIBCgKCAQEAie86pUz1p1yD0Yw3aUSCVSInYg3pfbzjdH0NgguUQAoyKmWt\nYbg2DerwNql1WkBYpusBOI9vyzsGG+o3MLxAECJHFznry+MzfDpn4hHF96kJOXGYpoJKD3Gp2McV\nV1tlKQVdki/n4AfOcbFgmMSRvepvR2esLi5+bLql+7EcVf+2VhqJXD50N8tBaX2wGQBUc9n3f0Qw\nsWOEgjHsSQMlmUm0idXrQ2+cv0IG/L8EDYxtpjAOMO3+7LVhmr+3nbqyg3tK3dulFYKlyF5QVorj\nI1Xrofl09VZ9u0rIr92c5HT2VV6fXxCFuCByBSoIp3LbHulDYVs4gz3R6V8Mgn/+7QIDAQABMA0G\nCSqGSIb3DQEBBQUAA4IBAQBIhpXu6GW8OZLp3PqGoZcZ63U7erzXpdfd/ZRxIpE2s3vwi86FIKmC\ngMCRUgLqWmUw8S+B/GuFdpaF2ASec/lNdYStXmK6vB+cjDRhfyhW1A91ktrSE6Cynty1xu+ReeLS\nIP1Ng+1CvWtPDkMLvLlw24mzUqrJpB+QsV3LH3bz79jm0QT8I8ccd9UESNm3ZmyhgiEKM9lbd4ai\nQA8g/2ubszpGS9ETTxTrak1sFp1SbCh1pboNyi8fi4kg0es9q/p5d/Nf00jroqcu57BS3YYY1aUL\nhMJaXnr966Jxxe/zENSbk0vYuAck3XeE81VQz+csbgoAFAv1D0Wsvhp+r8L/\n");
        killOpen("com.fun.lastwar.gp", "", "", "");
    }

    public static Field m0a(Class cls, String str) throws NoSuchFieldException {
        try {
            Field declaredField = cls.getDeclaredField(str);
            declaredField.setAccessible(true);
            return declaredField;
        } catch (NoSuchFieldException e) {
            while (true) {
                cls = cls.getSuperclass();
                if (cls == null || cls.equals(Object.class)) {
                    break;
                }
                try {
                    Field declaredField2 = cls.getDeclaredField(str);
                    declaredField2.setAccessible(true);
                    return declaredField2;
                } catch (NoSuchFieldException unused) {
                }
            }
            throw e;
        }
    }

    public static boolean m1b(String str, String str2) {
        if (str2.startsWith("/") && str2.endsWith(".apk")) {
            String[] strArrSplit = str2.substring(1).split("/", 6);
            int length = strArrSplit.length;
            if (length == 4 || length == 5) {
                if (strArrSplit[0].equals("data") && strArrSplit[1].equals("app") && strArrSplit[length - 1].equals("base.apk")) {
                    return strArrSplit[length - 2].startsWith(str);
                }
                if (strArrSplit[0].equals("mnt") && strArrSplit[1].equals("asec") && strArrSplit[length - 1].equals("pkg.apk")) {
                    return strArrSplit[length - 2].startsWith(str);
                }
            } else if (length == 3) {
                if (strArrSplit[0].equals("data") && strArrSplit[1].equals("app")) {
                    return strArrSplit[2].startsWith(str);
                }
            } else if (length == 6 && strArrSplit[0].equals("mnt") && strArrSplit[1].equals("expand") && strArrSplit[3].equals("app") && strArrSplit[5].equals("base.apk")) {
                return strArrSplit[4].endsWith(str);
            }
        }
        return false;
    }

    private static void killOpen(String str, String str2, String str3, String str4) {
        String str5;
        File file;
        if (str2.isEmpty() || str3.isEmpty() || str4.isEmpty()) {
            return;
        }
        try {
            BufferedReader bufferedReader = new BufferedReader(new FileReader("/proc/self/maps"));
            while (true) {
                try {
                    String line = bufferedReader.readLine();
                    if (line == null) {
                        bufferedReader.close();
                        str5 = null;
                        break;
                    } else {
                        String[] strArrSplit = line.split("\\s+");
                        str5 = strArrSplit[strArrSplit.length - 1];
                        if (m1b(str, str5)) {
                            bufferedReader.close();
                            break;
                        }
                    }
                } catch (Throwable th) {
                    try {
                        bufferedReader.close();
                    } catch (Throwable th2) {
                        th.addSuppressed(th2);
                    }
                    throw th;
                }
            }
            if (str5 == null) {
                System.err.println("Get apk path failed");
                return;
            }
            File file2 = new File(str5);
            String name = Environment.getExternalStorageDirectory().getName();
            if (name.matches("\\d+")) {
                file = new File("/data/user/" + name + "/" + str);
                if (!file.canWrite()) {
                    file = new File("/data/data/" + str);
                }
            } else {
                file = new File("/data/data/" + str);
            }
            File file3 = new File(file, str4);
            file3.getParentFile().mkdirs();
            try {
                ZipFile zipFile = new ZipFile(file2);
                try {
                    ZipEntry entry = zipFile.getEntry(str3);
                    if (entry == null) {
                        throw new RuntimeException("Entry not found: " + str3);
                    }
                    if (!file3.exists() || file3.length() != entry.getSize()) {
                        InputStream inputStream = zipFile.getInputStream(entry);
                        try {
                            FileOutputStream fileOutputStream = new FileOutputStream(file3);
                            try {
                                byte[] bArr = new byte[102400];
                                while (true) {
                                    int i = inputStream.read(bArr);
                                    if (i == -1) {
                                        break;
                                    } else {
                                        fileOutputStream.write(bArr, 0, i);
                                    }
                                    if (inputStream != null) {
                                        try {
                                            inputStream.close();
                                        } catch (Throwable th3) {
                                            th.addSuppressed(th3);
                                        }
                                    }
                                    throw th;
                                }
                                fileOutputStream.close();
                                inputStream.close();
                            } catch (Throwable th4) {
                                try {
                                    fileOutputStream.close();
                                } catch (Throwable th5) {
                                    th4.addSuppressed(th5);
                                }
                                throw th4;
                            }
                        } catch (Throwable th6) {
                            if (inputStream != null) {
                                inputStream.close();
                            }
                            throw th6;
                        }
                    }
                    zipFile.close();
                    try {
                        System.setProperty("mt.signature.killer.path1", file2.getAbsolutePath());
                        System.setProperty("mt.signature.killer.path2", file3.getAbsolutePath());
                        System.loadLibrary(str2);
                        return;
                    } finally {
                        System.clearProperty("mt.signature.killer.path1");
                        System.clearProperty("mt.signature.killer.path2");
                    }
                } catch (Throwable th7) {
                    try {
                        zipFile.close();
                    } catch (Throwable th8) {
                        th7.addSuppressed(th8);
                    }
                    throw th7;
                }
            } catch (IOException e) {
                throw new RuntimeException(e);
            }
            throw new RuntimeException(e);
        } catch (Exception e2) {
            throw new RuntimeException(e2);
        }
    }

    private static void killPM(String str, String str2) {
        try {
            m0a(PackageInfo.class, "CREATOR").set(null, new C0011l(PackageInfo.CREATOR, str, new Signature(Base64.decode(str2, 0))));
            if (Build.VERSION.SDK_INT >= 28) {
                HashSet hashSet = C0009j.f9f;
                hashSet.addAll(Arrays.asList("Landroid/os/Parcel;", "Landroid/content/pm", "Landroid/app"));
                String[] strArr = new String[hashSet.size()];
                hashSet.toArray(strArr);
                C0009j.m8b(strArr);
            }
            try {
                Object obj = m0a(PackageManager.class, "sPackageInfoCache").get(null);
                obj.getClass().getMethod("clear", null).invoke(obj, null);
            } catch (Throwable unused) {
            }
            try {
                ((Map) m0a(Parcel.class, "mCreators").get(null)).clear();
            } catch (Throwable unused2) {
            }
            try {
                ((Map) m0a(Parcel.class, "sPairedCreators").get(null)).clear();
            } catch (Throwable unused3) {
            }
        } catch (Exception e) {
            throw new RuntimeException(e);
        }
    }
}
