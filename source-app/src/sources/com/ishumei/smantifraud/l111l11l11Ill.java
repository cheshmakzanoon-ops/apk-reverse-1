package com.ishumei.smantifraud;

import android.text.TextUtils;
import com.loopj.android.http.HttpGet;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.HashMap;
import java.util.Map;

public class l111l11l11Ill extends l111l1111lIl {
    public static final int l111l11111lIl = 4096;
    public final l11l11IlIIll l1111l111111Il = new l11l11IlIIll(l111l11111lIl);

    @Override
    public l11l11l11I1l l1111l111111Il(l1l11lI1I1l<?> l1l11li1i1l, Map<String, String> map) throws Throwable {
        OutputStream outputStream;
        byte[] bArrL111l11111lIl = l1l11li1i1l.l111l11111lIl();
        if ((l1l11li1i1l.l111l1111lI1l() == 1 && bArrL111l11111lIl == null) || l11l11l111Il.l111l1111l1Il) {
            throw new IllegalArgumentException(l1l11I11ll.l111l1111lI1l);
        }
        String strL11l111l1Il = l1l11li1i1l.l11l111l1Il();
        if (l1l11li1i1l.l11l111lll() && !TextUtils.isEmpty(l1l11li1i1l.l11l11IlIIll())) {
            strL11l111l1Il = l1l11li1i1l.l11l11IlIIll();
        }
        HashMap map2 = new HashMap();
        map2.putAll(map);
        map2.putAll(l1l11li1i1l.l111l1111llIl());
        HttpURLConnection httpURLConnection = null;
        outputStream = null;
        OutputStream outputStream2 = null;
        try {
            HttpURLConnection httpURLConnection2 = (HttpURLConnection) new URL(strL11l111l1Il).openConnection();
            try {
                for (String str : map2.keySet()) {
                    httpURLConnection2.setRequestProperty(str, (String) map2.get(str));
                }
                int iL111l11IlIlIl = l1l11li1i1l.l111l11IlIlIl();
                httpURLConnection2.setConnectTimeout(iL111l11IlIlIl);
                httpURLConnection2.setReadTimeout(iL111l11IlIlIl);
                httpURLConnection2.setDoInput(true);
                httpURLConnection2.setDoOutput(true);
                httpURLConnection2.setUseCaches(false);
                httpURLConnection2.setRequestMethod(l1111l111111Il(l1l11li1i1l.l111l1111lI1l()));
                if (bArrL111l11111lIl != null) {
                    httpURLConnection2.setFixedLengthStreamingMode(bArrL111l11111lIl.length);
                }
                httpURLConnection2.connect();
                if (bArrL111l11111lIl != null) {
                    outputStream2 = httpURLConnection2.getOutputStream();
                    outputStream2.write(bArrL111l11111lIl);
                    outputStream2.flush();
                }
                l11l11l11I1l l11l11l11i1l = new l11l11l11I1l(httpURLConnection2.getResponseCode(), l1l11lllIl.l1111l111111Il(httpURLConnection2.getInputStream(), httpURLConnection2.getContentLength(), this.l1111l111111Il));
                try {
                    httpURLConnection2.disconnect();
                    if (outputStream2 != null) {
                        outputStream2.close();
                    }
                } catch (Exception unused) {
                }
                return l11l11l11i1l;
            } catch (Throwable th) {
                th = th;
                outputStream = outputStream2;
                httpURLConnection = httpURLConnection2;
                if (httpURLConnection != null) {
                    try {
                        httpURLConnection.disconnect();
                        if (outputStream != null) {
                            outputStream.close();
                        }
                    } catch (Exception unused2) {
                        throw th;
                    }
                } else if (outputStream != null) {
                    outputStream.close();
                }
                throw th;
            }
        } catch (Throwable th2) {
            th = th2;
            outputStream = null;
        }
    }

    public String l1111l111111Il(int i) {
        if (i == 0) {
            return HttpGet.METHOD_NAME;
        }
        if (i == 1) {
            return l11l11l1l1Il.l111l1111l1Il;
        }
        throw new IllegalStateException("Unknown method type.");
    }
}
