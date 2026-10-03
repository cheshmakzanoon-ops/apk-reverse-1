package com.appsflyer;

import android.content.Context;
import android.security.keystore.KeyGenParameterSpec;
import java.io.IOException;
import java.math.BigInteger;
import java.security.KeyPairGenerator;
import java.security.KeyStore;
import java.security.KeyStoreException;
import java.security.NoSuchAlgorithmException;
import java.security.cert.CertificateException;
import java.util.Calendar;
import java.util.Enumeration;
import javax.security.auth.x500.X500Principal;

public class AFKeystoreWrapper {
    public KeyStore AFKeystoreWrapper;
    private Context values;
    public final Object AFInAppEventType = new Object();
    public String AFInAppEventParameterName = "";
    public int valueOf = 0;

    public AFKeystoreWrapper(Context context) {
        this.values = context;
        AFLogger.afInfoLog("Initialising KeyStore..");
        try {
            KeyStore keyStore = KeyStore.getInstance("AndroidKeyStore");
            this.AFKeystoreWrapper = keyStore;
            keyStore.load(null);
        } catch (IOException | KeyStoreException | NoSuchAlgorithmException | CertificateException e) {
            AFLogger.afErrorLog("Couldn't load keystore instance of type: AndroidKeyStore", e);
        }
    }

    public final boolean values() {
        boolean z;
        synchronized (this.AFInAppEventType) {
            KeyStore keyStore = this.AFKeystoreWrapper;
            z = false;
            if (keyStore != null) {
                try {
                    Enumeration<String> enumerationAliases = keyStore.aliases();
                    while (enumerationAliases.hasMoreElements()) {
                        String strNextElement = enumerationAliases.nextElement();
                        if (strNextElement != null && valueOf(strNextElement)) {
                            String[] strArrSplit = strNextElement.split(",");
                            if (strArrSplit.length != 3) {
                                break;
                            }
                            AFLogger.afInfoLog("Found a matching AF key with alias:\n".concat(String.valueOf(strNextElement)));
                            z = true;
                            String[] strArrSplit2 = strArrSplit[1].trim().split("=");
                            String[] strArrSplit3 = strArrSplit[2].trim().split("=");
                            if (strArrSplit2.length != 2 || strArrSplit3.length != 2) {
                                break;
                                break;
                            }
                            this.AFInAppEventParameterName = strArrSplit2[1].trim();
                            this.valueOf = Integer.parseInt(strArrSplit3[1].trim());
                            break;
                        }
                    }
                } catch (Throwable th) {
                    StringBuilder sb = new StringBuilder("Couldn't list KeyStore Aliases: ");
                    sb.append(th.getClass().getName());
                    AFLogger.afErrorLog(sb.toString(), th);
                }
            }
        }
        return z;
    }

    public final void values(String str) {
        AFLogger.afInfoLog("Creating a new key with alias: ".concat(String.valueOf(str)));
        try {
            Calendar calendar = Calendar.getInstance();
            Calendar calendar2 = Calendar.getInstance();
            calendar2.add(1, 5);
            synchronized (this.AFInAppEventType) {
                if (!this.AFKeystoreWrapper.containsAlias(str)) {
                    KeyGenParameterSpec keyGenParameterSpecBuild = new KeyGenParameterSpec.Builder(str, 3).setCertificateSubject(new X500Principal("CN=AndroidSDK, O=AppsFlyer")).setCertificateSerialNumber(BigInteger.ONE).setCertificateNotBefore(calendar.getTime()).setCertificateNotAfter(calendar2.getTime()).build();
                    KeyPairGenerator keyPairGenerator = KeyPairGenerator.getInstance("RSA", "AndroidKeyStore");
                    keyPairGenerator.initialize(keyGenParameterSpecBuild);
                    keyPairGenerator.generateKeyPair();
                } else {
                    AFLogger.afInfoLog("Alias already exists: ".concat(String.valueOf(str)));
                }
            }
        } catch (Throwable th) {
            StringBuilder sb = new StringBuilder("Exception ");
            sb.append(th.getMessage());
            sb.append(" occurred");
            AFLogger.afErrorLog(sb.toString(), th);
        }
    }

    private static boolean valueOf(String str) {
        return str.startsWith("com.appsflyer");
    }

    public final String AFKeystoreWrapper() {
        StringBuilder sb = new StringBuilder("com.appsflyer,KSAppsFlyerId=");
        synchronized (this.AFInAppEventType) {
            sb.append(this.AFInAppEventParameterName);
            sb.append(",KSAppsFlyerRICounter=");
            sb.append(this.valueOf);
        }
        return sb.toString();
    }

    public final String AFInAppEventParameterName() {
        String str;
        synchronized (this.AFInAppEventType) {
            str = this.AFInAppEventParameterName;
        }
        return str;
    }

    public final int valueOf() {
        int i;
        synchronized (this.AFInAppEventType) {
            i = this.valueOf;
        }
        return i;
    }
}
