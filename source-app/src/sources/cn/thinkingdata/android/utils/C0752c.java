package cn.thinkingdata.android.utils;

import androidx.webkit.internal.AssetHelper;
import java.io.BufferedOutputStream;
import java.io.BufferedReader;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.security.InvalidParameterException;
import java.util.Map;
import java.util.zip.GZIPOutputStream;
import javax.net.ssl.HttpsURLConnection;
import javax.net.ssl.SSLSocketFactory;

public class C0752c implements InterfaceC0757h {
    private String m695a(String str) throws IOException {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream(str.getBytes().length);
        GZIPOutputStream gZIPOutputStream = new GZIPOutputStream(byteArrayOutputStream);
        gZIPOutputStream.write(str.getBytes());
        gZIPOutputStream.close();
        byte[] byteArray = byteArrayOutputStream.toByteArray();
        byteArrayOutputStream.close();
        return new String(C0750a.m689a(byteArray));
    }

    @Override
    public String mo696a(String str, String str2, boolean z, SSLSocketFactory sSLSocketFactory, Map<String, String> map) throws Throwable {
        Throwable th;
        HttpURLConnection httpURLConnection;
        OutputStream outputStream;
        InputStream inputStream;
        ?? r10;
        BufferedOutputStream bufferedOutputStream;
        OutputStream outputStream2;
        InputStream inputStream2;
        BufferedOutputStream bufferedOutputStream2 = null;
        try {
            httpURLConnection = (HttpURLConnection) new URL(str).openConnection();
            if (sSLSocketFactory != null) {
                try {
                    if (httpURLConnection instanceof HttpsURLConnection) {
                        ((HttpsURLConnection) httpURLConnection).setSSLSocketFactory(sSLSocketFactory);
                    }
                } catch (Throwable th2) {
                    th = th2;
                    outputStream = null;
                    inputStream = null;
                    r10 = inputStream;
                }
            }
            try {
                if (str2 == null) {
                    throw new InvalidParameterException("Content is null");
                }
                httpURLConnection.setDoOutput(true);
                httpURLConnection.setRequestMethod("POST");
                if (z) {
                    httpURLConnection.setRequestProperty("Content-Type", "application/x-www-form-urlencoded");
                    httpURLConnection.setUseCaches(false);
                    httpURLConnection.setRequestProperty("charset", "utf-8");
                } else {
                    httpURLConnection.setRequestProperty("Content-Type", AssetHelper.DEFAULT_MIME_TYPE);
                    try {
                        str2 = m695a(str2);
                    } catch (IOException e) {
                        throw new InvalidParameterException(e.getMessage());
                    }
                }
                if (map != null) {
                    for (Map.Entry<String, String> entry : map.entrySet()) {
                        httpURLConnection.setRequestProperty(entry.getKey(), entry.getValue());
                    }
                }
                httpURLConnection.setFixedLengthStreamingMode(str2.getBytes("UTF-8").length);
                outputStream = httpURLConnection.getOutputStream();
                try {
                    BufferedOutputStream bufferedOutputStream3 = new BufferedOutputStream(outputStream);
                    try {
                        bufferedOutputStream3.write(str2.getBytes("UTF-8"));
                        bufferedOutputStream3.flush();
                        bufferedOutputStream3.close();
                        try {
                            outputStream.close();
                            try {
                                int responseCode = httpURLConnection.getResponseCode();
                                TDLog.m679d("ThinkingAnalytics.HttpService", "ret_code:" + responseCode);
                                if (responseCode != 200) {
                                    throw new InterfaceC0757h.a("Service unavailable with response code: " + responseCode);
                                }
                                InputStream inputStream3 = httpURLConnection.getInputStream();
                                try {
                                    BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(inputStream3));
                                    try {
                                        StringBuilder sb = new StringBuilder();
                                        while (true) {
                                            String line = bufferedReader.readLine();
                                            if (line == null) {
                                                break;
                                            }
                                            sb.append(line);
                                        }
                                        inputStream3.close();
                                        bufferedReader.close();
                                        String string = sb.toString();
                                        if (inputStream3 != null) {
                                            try {
                                                inputStream3.close();
                                            } catch (IOException unused) {
                                            }
                                        }
                                        try {
                                            bufferedReader.close();
                                        } catch (IOException unused2) {
                                        }
                                        if (httpURLConnection != null) {
                                            httpURLConnection.disconnect();
                                        }
                                        return string;
                                    } catch (Throwable th3) {
                                        r10 = bufferedReader;
                                        outputStream = null;
                                        inputStream = inputStream3;
                                        th = th3;
                                    }
                                } catch (Throwable th4) {
                                    outputStream2 = null;
                                    bufferedOutputStream = null;
                                    inputStream2 = inputStream3;
                                    th = th4;
                                    OutputStream outputStream3 = outputStream2;
                                    inputStream = inputStream2;
                                    outputStream = outputStream3;
                                    bufferedOutputStream2 = bufferedOutputStream;
                                    r10 = 0;
                                }
                            } catch (Throwable th5) {
                                th = th5;
                                inputStream2 = null;
                                outputStream2 = null;
                                bufferedOutputStream = null;
                            }
                        } catch (Throwable th6) {
                            th = th6;
                            outputStream2 = outputStream;
                            inputStream2 = null;
                            bufferedOutputStream = null;
                        }
                    } catch (Throwable th7) {
                        th = th7;
                        bufferedOutputStream = bufferedOutputStream3;
                        outputStream2 = outputStream;
                        inputStream2 = null;
                    }
                } catch (Throwable th8) {
                    th = th8;
                    inputStream = null;
                    r10 = inputStream;
                }
            } catch (Throwable th9) {
                th = th9;
                outputStream = null;
            }
        } catch (Throwable th10) {
            th = th10;
            httpURLConnection = null;
            outputStream = null;
        }
        inputStream = null;
        r10 = inputStream;
        if (bufferedOutputStream2 != null) {
            try {
                bufferedOutputStream2.close();
            } catch (IOException unused3) {
            }
        }
        if (outputStream != null) {
            try {
                outputStream.close();
            } catch (IOException unused4) {
            }
        }
        if (inputStream != null) {
            try {
                inputStream.close();
            } catch (IOException unused5) {
            }
        }
        if (r10 != 0) {
            try {
                r10.close();
            } catch (IOException unused6) {
            }
        }
        if (httpURLConnection == null) {
            throw th;
        }
        httpURLConnection.disconnect();
        throw th;
    }
}
