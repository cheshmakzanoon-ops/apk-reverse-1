package com.loopj.android.http;

import android.content.Context;
import android.content.SharedPreferences;
import android.text.TextUtils;
import com.google.common.primitives.UnsignedBytes;
import cz.msebera.android.httpclient.client.CookieStore;
import cz.msebera.android.httpclient.cookie.Cookie;
import j$.util.concurrent.ConcurrentHashMap;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.Locale;
import java.util.Map;

public class PersistentCookieStore implements CookieStore {
    private static final String COOKIE_NAME_PREFIX = "cookie_";
    private static final String COOKIE_NAME_STORE = "names";
    private static final String COOKIE_PREFS = "CookiePrefsFile";
    private static final String LOG_TAG = "PersistentCookieStore";
    private final SharedPreferences cookiePrefs;
    private final ConcurrentHashMap<String, Cookie> cookies;
    private boolean omitNonPersistentCookies = false;

    public PersistentCookieStore(Context context) {
        Cookie cookieDecodeCookie;
        SharedPreferences sharedPreferences = context.getSharedPreferences(COOKIE_PREFS, 0);
        this.cookiePrefs = sharedPreferences;
        this.cookies = new ConcurrentHashMap<>();
        String string = sharedPreferences.getString(COOKIE_NAME_STORE, null);
        if (string != null) {
            for (String str : TextUtils.split(string, ",")) {
                String string2 = this.cookiePrefs.getString(COOKIE_NAME_PREFIX + str, null);
                if (string2 != null && (cookieDecodeCookie = decodeCookie(string2)) != null) {
                    this.cookies.put(str, cookieDecodeCookie);
                }
            }
            clearExpired(new Date());
        }
    }

    public void addCookie(Cookie cookie) {
        if (!this.omitNonPersistentCookies || cookie.isPersistent()) {
            String str = cookie.getName() + cookie.getDomain();
            if (!cookie.isExpired(new Date())) {
                this.cookies.put(str, cookie);
            } else {
                this.cookies.remove(str);
            }
            SharedPreferences.Editor editorEdit = this.cookiePrefs.edit();
            editorEdit.putString(COOKIE_NAME_STORE, TextUtils.join(",", this.cookies.keySet()));
            editorEdit.putString(COOKIE_NAME_PREFIX + str, encodeCookie(new SerializableCookie(cookie)));
            editorEdit.commit();
        }
    }

    public void clear() {
        SharedPreferences.Editor editorEdit = this.cookiePrefs.edit();
        Iterator it = this.cookies.keySet().iterator();
        while (it.hasNext()) {
            editorEdit.remove(COOKIE_NAME_PREFIX + ((String) it.next()));
        }
        editorEdit.remove(COOKIE_NAME_STORE);
        editorEdit.commit();
        this.cookies.clear();
    }

    public boolean clearExpired(Date date) {
        SharedPreferences.Editor editorEdit = this.cookiePrefs.edit();
        boolean z = false;
        for (Map.Entry entry : this.cookies.entrySet()) {
            String str = (String) entry.getKey();
            if (((Cookie) entry.getValue()).isExpired(date)) {
                this.cookies.remove(str);
                editorEdit.remove(COOKIE_NAME_PREFIX + str);
                z = true;
            }
        }
        if (z) {
            editorEdit.putString(COOKIE_NAME_STORE, TextUtils.join(",", this.cookies.keySet()));
        }
        editorEdit.commit();
        return z;
    }

    public List<Cookie> getCookies() {
        return new ArrayList(this.cookies.values());
    }

    public void setOmitNonPersistentCookies(boolean z) {
        this.omitNonPersistentCookies = z;
    }

    public void deleteCookie(Cookie cookie) {
        String str = cookie.getName() + cookie.getDomain();
        this.cookies.remove(str);
        SharedPreferences.Editor editorEdit = this.cookiePrefs.edit();
        editorEdit.remove(COOKIE_NAME_PREFIX + str);
        editorEdit.commit();
    }

    protected String encodeCookie(SerializableCookie serializableCookie) {
        if (serializableCookie == null) {
            return null;
        }
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        try {
            new ObjectOutputStream(byteArrayOutputStream).writeObject(serializableCookie);
            return byteArrayToHexString(byteArrayOutputStream.toByteArray());
        } catch (IOException e) {
            AsyncHttpClient.log.mo383d(LOG_TAG, "IOException in encodeCookie", e);
            return null;
        }
    }

    protected Cookie decodeCookie(String str) {
        try {
            return ((SerializableCookie) new ObjectInputStream(new ByteArrayInputStream(hexStringToByteArray(str))).readObject()).getCookie();
        } catch (IOException e) {
            AsyncHttpClient.log.mo383d(LOG_TAG, "IOException in decodeCookie", e);
            return null;
        } catch (ClassNotFoundException e2) {
            AsyncHttpClient.log.mo383d(LOG_TAG, "ClassNotFoundException in decodeCookie", e2);
            return null;
        }
    }

    protected String byteArrayToHexString(byte[] bArr) {
        StringBuilder sb = new StringBuilder(bArr.length * 2);
        for (byte b : bArr) {
            int i = b & UnsignedBytes.MAX_VALUE;
            if (i < 16) {
                sb.append('0');
            }
            sb.append(Integer.toHexString(i));
        }
        return sb.toString().toUpperCase(Locale.US);
    }

    protected byte[] hexStringToByteArray(String str) {
        int length = str.length();
        byte[] bArr = new byte[length / 2];
        for (int i = 0; i < length; i += 2) {
            bArr[i / 2] = (byte) ((Character.digit(str.charAt(i), 16) << 4) + Character.digit(str.charAt(i + 1), 16));
        }
        return bArr;
    }
}
