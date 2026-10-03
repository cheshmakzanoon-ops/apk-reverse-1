package com.ishumei.smantifraud;

import android.text.TextUtils;
import java.io.BufferedReader;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import org.json.JSONObject;

public class l11l11l1l1Il implements Runnable {
    public static final String l111l1111l1Il = "POST";
    public static final int[] l111l1111lI1l = {2000, 5000, 15000, 30000};
    public static final int l111l1111llIl = 3;
    public final String l1111l111111Il;
    public final l11l111l11Il l111l11111I1l;
    public int l111l11111Il;
    public final String l111l11111lIl;

    public l11l11l1l1Il(String str, String str2, l11l111l11Il l11l111l11il) {
        this.l111l11111lIl = str;
        this.l1111l111111Il = str2;
        this.l111l11111I1l = l11l111l11il;
    }

    public static void l1111l111111Il(String str, String str2, l11l111l11Il l11l111l11il) {
        if (TextUtils.isEmpty(str) || TextUtils.isEmpty(str2) || l11l111l11il == null || !l11l111l11il.l11l111l1Il()) {
            return;
        }
        l1l11I1l1l.l1111l111111Il.execute(new l11l11l1l1Il(str, str2, l11l111l11il));
    }

    @Override
    public void run() {
        InputStream inputStream;
        OutputStream outputStream;
        InputStream inputStream2;
        try {
            JSONObject jSONObject = new JSONObject(this.l1111l111111Il);
            jSONObject.put("retry", 1);
            String string = jSONObject.toString();
            while (!l11l11l111Il.l111l1111l1Il) {
                HttpURLConnection httpURLConnection = null;
                inputStream = null;
                InputStream inputStream3 = null;
                HttpURLConnection httpURLConnection2 = null;
                try {
                    int i = this.l111l11111Il;
                    Thread.sleep(i >= 3 ? l111l1111lI1l[3] : l111l1111lI1l[i % 3]);
                    if (this.l111l11111I1l.l11l1111I11l() >= 0 && this.l111l11111Il > this.l111l11111I1l.l11l1111I11l()) {
                        this.l111l11111Il++;
                        return;
                    }
                    HttpURLConnection httpURLConnection3 = (HttpURLConnection) new URL(this.l111l11111lIl).openConnection();
                    try {
                        httpURLConnection3.setDoInput(true);
                        httpURLConnection3.setDoOutput(true);
                        httpURLConnection3.setUseCaches(false);
                        httpURLConnection3.setInstanceFollowRedirects(true);
                        httpURLConnection3.setRequestMethod(l111l1111l1Il);
                        httpURLConnection3.setRequestProperty("Content-Type", "application/octet-stream");
                        httpURLConnection3.setRequestProperty("Connection", l1l11I11lll.l11l111lI1l);
                        httpURLConnection3.setConnectTimeout(30000);
                        httpURLConnection3.setReadTimeout(30000);
                        httpURLConnection3.setFixedLengthStreamingMode(string.getBytes().length);
                        httpURLConnection3.connect();
                        outputStream = httpURLConnection3.getOutputStream();
                        try {
                            outputStream.write(string.getBytes());
                            outputStream.flush();
                            if (httpURLConnection3.getResponseCode() == 200) {
                                inputStream3 = httpURLConnection3.getInputStream();
                                BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream3));
                                StringBuilder sb = new StringBuilder();
                                while (true) {
                                    String line = bufferedReader.readLine();
                                    if (line == null) {
                                        break;
                                    } else {
                                        sb.append(line);
                                    }
                                }
                                JSONObject jSONObject2 = new JSONObject(sb.toString());
                                if (jSONObject2.optInt("code") == 1902) {
                                    this.l111l11111Il++;
                                    httpURLConnection3.disconnect();
                                    outputStream.close();
                                    if (inputStream3 == null) {
                                        return;
                                    }
                                } else if (jSONObject2.has(l1l11I1l.l11l1111I11l)) {
                                    JSONObject jSONObjectOptJSONObject = jSONObject2.optJSONObject(l1l11I1l.l11l1111I11l);
                                    if (jSONObjectOptJSONObject == null || TextUtils.isEmpty(jSONObjectOptJSONObject.optString("deviceId"))) {
                                        this.l111l11111Il++;
                                        httpURLConnection3.disconnect();
                                        outputStream.close();
                                        if (inputStream3 != null) {
                                            inputStream3.close();
                                        }
                                    } else {
                                        l111l11I1IIIl.l111l1111l1Il().l1111l111111Il(jSONObjectOptJSONObject.optString("deviceId"), true);
                                        this.l111l11111Il++;
                                        httpURLConnection3.disconnect();
                                        outputStream.close();
                                        if (inputStream3 == null) {
                                            return;
                                        }
                                    }
                                } else {
                                    this.l111l11111Il++;
                                    httpURLConnection3.disconnect();
                                    outputStream.close();
                                    if (inputStream3 != null) {
                                        inputStream3.close();
                                    }
                                }
                                inputStream3.close();
                                return;
                            }
                            this.l111l11111Il++;
                            try {
                                httpURLConnection3.disconnect();
                                outputStream.close();
                            } catch (Throwable unused) {
                            }
                        } catch (InterruptedException unused2) {
                            inputStream2 = inputStream3;
                            httpURLConnection2 = httpURLConnection3;
                            this.l111l11111Il++;
                            if (httpURLConnection2 != null) {
                                httpURLConnection2.disconnect();
                            }
                            if (outputStream != null) {
                                outputStream.close();
                            }
                            if (inputStream2 == null) {
                                return;
                            } else {
                                inputStream3 = inputStream2;
                            }
                        } catch (Throwable unused3) {
                            inputStream = inputStream3;
                            httpURLConnection = httpURLConnection3;
                            this.l111l11111Il++;
                            if (httpURLConnection != null) {
                                httpURLConnection.disconnect();
                            }
                            if (outputStream != null) {
                                outputStream.close();
                            }
                            if (inputStream != null) {
                                inputStream3 = inputStream;
                            }
                        }
                    } catch (InterruptedException unused4) {
                        inputStream2 = null;
                        outputStream = null;
                    } catch (Throwable unused5) {
                        outputStream = null;
                        httpURLConnection = httpURLConnection3;
                        inputStream = null;
                    }
                } catch (InterruptedException unused6) {
                    inputStream2 = null;
                    outputStream = null;
                } catch (Throwable unused7) {
                    inputStream = null;
                    outputStream = null;
                }
            }
        } catch (Throwable unused8) {
        }
    }
}
