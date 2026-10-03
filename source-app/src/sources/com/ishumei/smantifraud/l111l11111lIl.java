package com.ishumei.smantifraud;

import android.content.Context;
import android.content.Intent;
import android.content.pm.PackageInfo;
import android.content.pm.PackageManager;
import android.content.pm.ResolveInfo;
import android.os.Build;
import android.os.Bundle;
import android.security.keystore.KeyGenParameterSpec;
import android.text.TextUtils;
import android.util.Pair;
import com.google.firebase.messaging.Constants;
import com.sdkmanager.utils.Udid$$ExternalSyntheticApiModelOutline0;
import j$.util.Objects;
import java.io.ByteArrayInputStream;
import java.io.File;
import java.lang.reflect.Method;
import java.lang.reflect.Proxy;
import java.security.InvalidAlgorithmParameterException;
import java.security.KeyPairGenerator;
import java.security.KeyStore;
import java.security.NoSuchAlgorithmException;
import java.security.NoSuchProviderException;
import java.security.Principal;
import java.security.Signature;
import java.security.cert.Certificate;
import java.security.cert.CertificateException;
import java.security.cert.CertificateFactory;
import java.security.cert.X509Certificate;
import java.security.spec.ECGenParameterSpec;
import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Iterator;
import java.util.List;
import java.util.Map;
import javax.security.auth.x500.X500Principal;

public class l111l11111lIl {
    public static int l1111l111111Il;

    public static int l1111l111111Il() {
        return (l11l11l111Il.l1111l111111Il.getApplicationInfo().flags & 2) > 0 ? 1 : 0;
    }

    public static Pair<String, Integer> l1111l111111Il(Context context, List<byte[]> list) {
        String str;
        String str2;
        String string;
        String str3 = "";
        int i = Build.VERSION.SDK_INT;
        KeyStore keyStore = null;
        try {
            list.clear();
            ArrayList arrayList = new ArrayList();
            Object[] objArr = i >= 31 && context.getPackageManager().hasSystemFeature("android.hardware.keystore.app_attest_key");
            KeyStore keyStore2 = KeyStore.getInstance("AndroidKeyStore");
            try {
                keyStore2.load(null);
                str2 = "KeyAttestation";
                String str4 = objArr == true ? "KeyAttestation_persistent" : null;
                if (objArr != false) {
                    try {
                        if (!keyStore2.containsAlias(str4)) {
                            l1111l111111Il(str4, str4);
                        }
                    } catch (Throwable th) {
                        th = th;
                        str = str4;
                        keyStore = keyStore2;
                        try {
                            Throwable cause = th.getCause();
                            if (cause != null) {
                                if (Build.VERSION.SDK_INT >= 33 && Udid$$ExternalSyntheticApiModelOutline0.m436m((Object) cause)) {
                                    str3 = ("nEc:" + Udid$$ExternalSyntheticApiModelOutline0.m410m((Object) cause).getNumericErrorCode() + ",") + "iTF:" + Udid$$ExternalSyntheticApiModelOutline0.m410m((Object) cause).isTransientFailure() + ",";
                                }
                                string = str3 + cause.toString();
                            } else {
                                string = th.toString();
                            }
                            return new Pair<>(string.substring(0, Math.min(string.length(), 500)), 1);
                        } finally {
                            if (keyStore != null) {
                                try {
                                    if (keyStore.containsAlias(str)) {
                                        keyStore.deleteEntry(str);
                                    }
                                } catch (Throwable unused) {
                                }
                                try {
                                    if (keyStore.containsAlias(str2)) {
                                        keyStore.deleteEntry(str2);
                                    }
                                } catch (Throwable unused2) {
                                }
                            }
                        }
                    }
                }
                l1111l111111Il("KeyAttestation", str4);
                Certificate[] certificateChain = keyStore2.getCertificateChain("KeyAttestation");
                if (certificateChain == null) {
                    throw new CertificateException("Unable to get certificate chain");
                }
                Collections.addAll(arrayList, certificateChain);
                if (objArr != false) {
                    Certificate[] certificateChain2 = keyStore2.getCertificateChain(str4);
                    if (certificateChain2 == null) {
                        throw new CertificateException("Unable to get certificate chain");
                    }
                    Collections.addAll(arrayList, certificateChain2);
                }
                Iterator it = arrayList.iterator();
                while (it.hasNext()) {
                    list.add(((Certificate) it.next()).getEncoded());
                }
                Pair<String, Integer> pair = new Pair<>("", Integer.valueOf(l111l11111lIl(context, arrayList)));
                try {
                    if (keyStore2.containsAlias(str4)) {
                        keyStore2.deleteEntry(str4);
                    }
                } catch (Throwable unused3) {
                }
                try {
                    if (keyStore2.containsAlias("KeyAttestation")) {
                        keyStore2.deleteEntry("KeyAttestation");
                    }
                } catch (Throwable unused4) {
                }
                return pair;
            } catch (Throwable th2) {
                th = th2;
                str = null;
                str2 = null;
            }
        } catch (Throwable th3) {
            th = th3;
            str = null;
            str2 = null;
        }
    }

    public static String l1111l111111Il(Object obj) {
        if (obj == null) {
            return "";
        }
        try {
            return ((X509Certificate) CertificateFactory.getInstance("X.509").generateCertificate(new ByteArrayInputStream((byte[]) l1l11lI1lIl.l111l11111lIl(obj, "toByteArray")))).getSubjectDN().toString();
        } catch (Exception unused) {
            return "";
        }
    }

    public static List<X509Certificate> l1111l111111Il(List<Certificate> list) throws l1l11I11l1l {
        HashMap map = new HashMap();
        HashSet hashSet = new HashSet();
        HashSet hashSet2 = new HashSet();
        ArrayList<X509Certificate> arrayList = new ArrayList();
        for (Certificate certificate : list) {
            if (!(certificate instanceof X509Certificate)) {
                throw new l1l11I11l1l(2);
            }
            arrayList.add((X509Certificate) certificate);
        }
        for (X509Certificate x509Certificate : arrayList) {
            X500Principal subjectX500Principal = x509Certificate.getSubjectX500Principal();
            X500Principal issuerX500Principal = x509Certificate.getIssuerX500Principal();
            map.put(subjectX500Principal, x509Certificate);
            hashSet.add(subjectX500Principal);
            hashSet2.add(issuerX500Principal);
        }
        HashSet hashSet3 = new HashSet(hashSet);
        hashSet3.removeAll(hashSet2);
        if (hashSet3.size() > 1) {
            throw new l1l11I11l1l(4);
        }
        if (hashSet3.isEmpty()) {
            throw new l1l11I11l1l(3);
        }
        X509Certificate x509Certificate2 = (X509Certificate) map.get((Principal) hashSet3.iterator().next());
        ArrayList arrayList2 = new ArrayList();
        for (X509Certificate x509Certificate3 : arrayList) {
            if (x509Certificate3.getSubjectX500Principal().equals(x509Certificate3.getIssuerX500Principal())) {
                arrayList2.add(x509Certificate3);
            }
        }
        if (arrayList2.isEmpty()) {
            throw new l1l11I11l1l(5);
        }
        if (arrayList2.size() > 1) {
            throw new l1l11I11l1l(6);
        }
        ArrayList arrayList3 = new ArrayList();
        do {
            arrayList3.add(x509Certificate2);
            X500Principal issuerX500Principal2 = x509Certificate2.getIssuerX500Principal();
            if (issuerX500Principal2.equals(x509Certificate2.getSubjectX500Principal())) {
                return arrayList3;
            }
            x509Certificate2 = (X509Certificate) map.get(issuerX500Principal2);
            if (x509Certificate2 == null) {
                throw new l1l11I11l1l(7);
            }
        } while (!arrayList3.contains(x509Certificate2));
        throw new l1l11I11l1l(8);
    }

    public static Map<String, String> l1111l111111Il(Context context) {
        HashMap map = new HashMap();
        try {
            PackageManager packageManager = context.getPackageManager();
            String strL111l11111lIl = l111l11111lIl(context);
            map.put("pkg", strL111l11111lIl);
            if (strL111l11111lIl != null) {
                map.put(Constants.ScionAnalytics.PARAM_LABEL, "" + ((Object) packageManager.getApplicationLabel(packageManager.getApplicationInfo(strL111l11111lIl, 0))));
                map.put(l11l111l11Il.l11l111llI1l, packageManager.getPackageInfo(strL111l11111lIl, 0).versionName);
            }
        } catch (Throwable unused) {
        }
        if (map.isEmpty()) {
            return null;
        }
        return map;
    }

    public static void l1111l111111Il(String str, String str2) throws NoSuchAlgorithmException, NoSuchProviderException, InvalidAlgorithmParameterException {
        int i = Build.VERSION.SDK_INT;
        Date date = new Date();
        boolean zEquals = Objects.equals(str, str2);
        int i2 = (i < 31 || !zEquals) ? 4 : 128;
        KeyGenParameterSpec.Builder attestationChallenge = i >= 24 ? new KeyGenParameterSpec.Builder(str, i2).setAlgorithmParameterSpec(new ECGenParameterSpec("secp256r1")).setDigests("SHA-256").setCertificateNotBefore(date).setAttestationChallenge(date.toString().getBytes()) : new KeyGenParameterSpec.Builder(str, i2).setAlgorithmParameterSpec(new ECGenParameterSpec("secp256r1")).setDigests("SHA-256").setCertificateNotBefore(date);
        if (i >= 31) {
            attestationChallenge.setDevicePropertiesAttestationIncluded(true);
            if (zEquals) {
                attestationChallenge.setCertificateSubject(new X500Principal("CN=App Attest Key"));
            } else {
                attestationChallenge.setAttestKeyAlias(str2);
            }
        }
        KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("EC", "AndroidKeyStore");
        keyPairGenerator.initialize(attestationChallenge.build());
        keyPairGenerator.generateKeyPair();
    }

    public static void l1111l111111Il(X509Certificate x509Certificate, X509Certificate x509Certificate2) throws Exception {
        Signature signature = Signature.getInstance(x509Certificate.getSigAlgName());
        signature.initVerify(x509Certificate2.getPublicKey());
        signature.update(x509Certificate.getTBSCertificate());
        try {
            if (signature.verify(x509Certificate.getSignature())) {
            } else {
                throw new l1l11I11l1l(11);
            }
        } catch (Exception unused) {
            throw new l1l11I11l1l(11);
        }
    }

    public static Object[] l1111l111111Il(String str) {
        Object[] objArr;
        Context context = l11l11l111Il.l1111l111111Il;
        if (context == null) {
            return null;
        }
        try {
            Object objL1111l111111Il = l1l11lI1lIl.l1111l111111Il(context.getPackageManager(), "getPackageInfo", new Class[]{String.class, Integer.TYPE}, new Object[]{str, 64});
            if (objL1111l111111Il == null || (objArr = (Object[]) l1l11lI1lIl.l1111l111111Il(objL1111l111111Il, "signatures")) == null || objArr.length <= 0) {
                return null;
            }
            return objArr;
        } catch (Throwable unused) {
        }
    }

    public static int l111l11111I1l(Context context) {
        try {
            StringBuilder sb = new StringBuilder();
            sb.append(context.getCacheDir());
            sb.append("/lspatch/origin");
            return new File(sb.toString()).exists() ? 1 : 0;
        } catch (Throwable unused) {
            return 0;
        }
    }

    public static Map<String, Long> l111l11111I1l() {
        try {
            PackageInfo packageInfo = l11l11l111Il.l1111l111111Il.getPackageManager().getPackageInfo(l111l11111lIl(), 0);
            HashMap map = new HashMap();
            map.put("fit", Long.valueOf(packageInfo.firstInstallTime));
            map.put("lut", Long.valueOf(packageInfo.lastUpdateTime));
            return map;
        } catch (PackageManager.NameNotFoundException e) {
            e.printStackTrace();
            return null;
        }
    }

    public static int l111l11111Il(Context context) {
        try {
            Bundle bundle = context.getPackageManager().getApplicationInfo(context.getPackageName(), 128).metaData;
            if (bundle != null) {
                return !TextUtils.isEmpty(bundle.getString("lspatch")) ? 1 : 0;
            }
            return 0;
        } catch (Throwable unused) {
            return 0;
        }
    }

    public static String l111l11111Il() {
        Context contextL1111l111111Il = l11l11l111Il.l1111l111111Il;
        if (contextL1111l111111Il == null && (contextL1111l111111Il = l1l1l11Ill.l1111l111111Il()) == null) {
            return null;
        }
        try {
            PackageInfo packageInfo = contextL1111l111111Il.getPackageManager().getPackageInfo(l111l11111lIl(), 0);
            String str = packageInfo.versionName;
            try {
                l1111l111111Il = packageInfo.applicationInfo.targetSdkVersion;
                if (str == null) {
                    return "";
                }
            } catch (Throwable unused) {
            }
            return str;
        } catch (Throwable unused2) {
            return "";
        }
    }

    public static int l111l11111lIl(Context context, List<Certificate> list) {
        try {
            l1l11lIll1l l1l11lill1l = new l1l11lIll1l();
            l1l11lill1l.l1111l111111Il(context);
            List<X509Certificate> listL1111l111111Il = l1111l111111Il(list);
            l111l11111lIl(listL1111l111111Il);
            return l1l11lill1l.l1111l111111Il(listL1111l111111Il.get(listL1111l111111Il.size() + (-1)).getPublicKey().getEncoded()) == l1l11lIll1l.l1111l111111Il.AOSP ? 10 : 0;
        } catch (l1l11I11l1l e) {
            return e.l1111l111111Il;
        } catch (Throwable unused) {
            return -1;
        }
    }

    public static String l111l11111lIl() {
        Context contextL1111l111111Il = l11l11l111Il.l1111l111111Il;
        if (contextL1111l111111Il == null && (contextL1111l111111Il = l1l1l11Ill.l1111l111111Il()) == null) {
            return null;
        }
        try {
            return (String) l1l11lI1lIl.l111l11111lIl(contextL1111l111111Il, "getPackageName");
        } catch (Exception unused) {
            return "";
        }
    }

    public static String l111l11111lIl(Context context) {
        Intent intent = new Intent("android.intent.action.MAIN");
        intent.addCategory("android.intent.category.HOME");
        ResolveInfo resolveInfoResolveActivity = context.getPackageManager().resolveActivity(intent, 65536);
        if (resolveInfoResolveActivity != null) {
            return resolveInfoResolveActivity.activityInfo.packageName;
        }
        return null;
    }

    public static void l111l11111lIl(List<X509Certificate> list) throws Exception {
        if (list.size() < 2) {
            throw new l1l11I11l1l(9);
        }
        int i = 0;
        while (i < list.size() - 1) {
            X509Certificate x509Certificate = list.get(i);
            i++;
            l1111l111111Il(x509Certificate, list.get(i));
        }
    }

    public static Map<String, String> l111l1111l1Il() {
        try {
            HashMap map = new HashMap();
            Class<?> cls = Class.forName("android.app.ActivityThread");
            Method declaredMethod = cls.getDeclaredMethod("getPackageManager", null);
            declaredMethod.setAccessible(true);
            Object objInvoke = declaredMethod.invoke(cls, null);
            Class<?> cls2 = objInvoke instanceof Proxy ? Proxy.getInvocationHandler(objInvoke).getClass() : null;
            if (objInvoke != null && !objInvoke.getClass().getName().equals("android.content.pm.IPackageManager$Stub$Proxy")) {
                map.put("pm", objInvoke.getClass().getName());
            }
            if (cls2 != null) {
                map.put("proxy", cls2.getName());
            }
            if (map.isEmpty()) {
                return null;
            }
            return map;
        } catch (Throwable unused) {
            return null;
        }
    }

    public static int l111l1111lI1l() {
        Context context = l11l11l111Il.l1111l111111Il;
        if (context == null) {
            return 0;
        }
        return context.getApplicationInfo().targetSdkVersion;
    }

    public static Object l111l1111llIl() {
        Object[] objArrL1111l111111Il;
        Context context = l11l11l111Il.l1111l111111Il;
        if (context == null || (objArrL1111l111111Il = l1111l111111Il(context.getPackageName())) == null || objArrL1111l111111Il.length < 1) {
            return null;
        }
        return objArrL1111l111111Il[0];
    }
}
