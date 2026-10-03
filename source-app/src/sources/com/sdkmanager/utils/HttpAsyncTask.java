package com.sdkmanager.utils;

import android.os.AsyncTask;
import android.util.Log;
import com.google.common.net.HttpHeaders;
import com.ishumei.smantifraud.l11l11l1l1Il;
import com.loopj.android.http.RequestParams;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.OutputStreamWriter;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Map;

public class HttpAsyncTask extends AsyncTask<String, Void, String> {
    private int connectTimeout;
    private String encoding;
    private Map<String, String> headers;
    private String method;
    private StringBuilder paramsStr;
    private String pathUrl;
    private int readTimeout;

    public HttpAsyncTask(String str, String str2, int i, int i2, String str3, StringBuilder sb, Map<String, String> map) {
        this.pathUrl = str;
        this.method = str2;
        this.connectTimeout = i;
        this.readTimeout = i2;
        this.encoding = str3;
        this.paramsStr = sb;
        this.headers = map;
    }

    @Override
    public String doInBackground(String... strArr) throws Throwable {
        ?? r2;
        ?? r5;
        BufferedWriter bufferedWriter;
        ?? bufferedReader;
        byte[] bArr;
        InputStream errorStream;
        ?? r3 = "pathUrl: ";
        BufferedWriter bufferedWriter2 = null;
        try {
            try {
                Log.i("invokeUrl", "pathUrl: " + this.pathUrl);
                r3 = (HttpURLConnection) new URL(this.pathUrl).openConnection();
                try {
                    r3.setUseCaches(false);
                    r3.setInstanceFollowRedirects(true);
                    r3.setRequestProperty(HttpHeaders.ACCEPT, RequestParams.APPLICATION_JSON);
                    r3.setRequestProperty("content-type", "application/x-www-form-urlencoded");
                    r3.setRequestMethod(this.method);
                    r3.setDoOutput(true);
                    r3.setDoInput(true);
                    r3.setConnectTimeout(this.connectTimeout);
                    r3.setReadTimeout(this.readTimeout);
                    r3.connect();
                    Map<String, String> map = this.headers;
                    if (map != null && map.size() > 0) {
                        for (String str : this.headers.keySet()) {
                            r3.setRequestProperty(str, this.headers.get(str));
                        }
                    }
                    if (this.paramsStr == null || !this.method.equals(l11l11l1l1Il.l111l1111l1Il)) {
                        bufferedWriter = null;
                    } else {
                        bufferedWriter = new BufferedWriter(new OutputStreamWriter(r3.getOutputStream(), this.encoding));
                        try {
                            bufferedWriter.write(this.paramsStr.toString());
                            bufferedWriter.flush();
                        } catch (IOException e) {
                            e = e;
                            bufferedReader = 0;
                            Log.i("调用接口[" + this.pathUrl + "]失败！请求URL：" + this.pathUrl + "，参数：" + ((Object) this.paramsStr), "invokeUrl: " + e.getMessage());
                            try {
                                bArr = new byte[100];
                                errorStream = r3.getErrorStream();
                                if (errorStream != null) {
                                    while (errorStream.read(bArr) > 0) {
                                    }
                                    errorStream.close();
                                }
                            } catch (Exception e2) {
                                e2.printStackTrace();
                            }
                            if (bufferedWriter != null) {
                                try {
                                    bufferedWriter.close();
                                } catch (Exception e3) {
                                    e3.printStackTrace();
                                }
                            }
                            if (bufferedReader != 0) {
                                try {
                                    bufferedReader.close();
                                } catch (Exception e4) {
                                    e4.printStackTrace();
                                }
                            }
                            if (r3 != 0) {
                                r3.disconnect();
                            }
                            return null;
                        } catch (Throwable th) {
                            th = th;
                            bufferedReader = 0;
                            bufferedWriter2 = bufferedWriter;
                            r2 = r3;
                            r5 = bufferedReader;
                            if (bufferedWriter2 != null) {
                                try {
                                    bufferedWriter2.close();
                                } catch (Exception e5) {
                                    e5.printStackTrace();
                                }
                            }
                            if (r5 != 0) {
                                try {
                                    r5.close();
                                } catch (Exception e6) {
                                    e6.printStackTrace();
                                }
                            }
                            if (r2 != 0) {
                                throw th;
                            }
                            r2.disconnect();
                            throw th;
                        }
                    }
                    int responseCode = r3.getResponseCode();
                    InputStream inputStream = responseCode == 200 ? r3.getInputStream() : r3.getErrorStream();
                    Log.i("invokeUrl", "code: " + responseCode);
                    if (inputStream == null) {
                        if (bufferedWriter != null) {
                            try {
                                bufferedWriter.close();
                            } catch (Exception e7) {
                                e7.printStackTrace();
                            }
                        }
                        if (r3 != 0) {
                            r3.disconnect();
                        }
                        return "";
                    }
                    StringBuilder sb = new StringBuilder();
                    bufferedReader = new BufferedReader(new InputStreamReader(inputStream, this.encoding));
                    while (true) {
                        try {
                            String line = bufferedReader.readLine();
                            if (line == null) {
                                break;
                            }
                            sb.append(line);
                            sb.append("\r\n");
                        } catch (IOException e8) {
                            e = e8;
                            Log.i("调用接口[" + this.pathUrl + "]失败！请求URL：" + this.pathUrl + "，参数：" + ((Object) this.paramsStr), "invokeUrl: " + e.getMessage());
                            bArr = new byte[100];
                            errorStream = r3.getErrorStream();
                            if (errorStream != null) {
                                while (errorStream.read(bArr) > 0) {
                                }
                                errorStream.close();
                            }
                            if (bufferedWriter != null) {
                                bufferedWriter.close();
                            }
                            if (bufferedReader != 0) {
                                bufferedReader.close();
                            }
                            if (r3 != 0) {
                                r3.disconnect();
                            }
                            return null;
                        }
                    }
                    Log.i("调用接口[" + this.pathUrl + "]成功！请求URL：" + this.pathUrl + "，参数：" + ((Object) this.paramsStr), "结果：" + sb.toString());
                    String string = sb.toString();
                    if (bufferedWriter != null) {
                        try {
                            bufferedWriter.close();
                        } catch (Exception e9) {
                            e9.printStackTrace();
                        }
                    }
                    try {
                        bufferedReader.close();
                    } catch (Exception e10) {
                        e10.printStackTrace();
                    }
                    if (r3 != 0) {
                        r3.disconnect();
                    }
                    return string;
                } catch (IOException e11) {
                    e = e11;
                    bufferedWriter = null;
                    r3 = r3;
                    bufferedReader = bufferedWriter;
                    Log.i("调用接口[" + this.pathUrl + "]失败！请求URL：" + this.pathUrl + "，参数：" + ((Object) this.paramsStr), "invokeUrl: " + e.getMessage());
                    bArr = new byte[100];
                    errorStream = r3.getErrorStream();
                    if (errorStream != null) {
                        while (errorStream.read(bArr) > 0) {
                        }
                        errorStream.close();
                    }
                    if (bufferedWriter != null) {
                        bufferedWriter.close();
                    }
                    if (bufferedReader != 0) {
                        bufferedReader.close();
                    }
                    if (r3 != 0) {
                        r3.disconnect();
                    }
                    return null;
                } catch (Throwable th2) {
                    th = th2;
                    r5 = 0;
                    r2 = r3;
                    if (bufferedWriter2 != null) {
                        bufferedWriter2.close();
                    }
                    if (r5 != 0) {
                        r5.close();
                    }
                    if (r2 != 0) {
                        throw th;
                    }
                    r2.disconnect();
                    throw th;
                }
            } catch (Throwable th3) {
                th = th3;
            }
        } catch (IOException e12) {
            e = e12;
            r3 = 0;
            bufferedWriter = null;
        } catch (Throwable th4) {
            th = th4;
            r2 = 0;
            r5 = 0;
        }
    }

    @Override
    public void onPostExecute(String str) {
        super.onPostExecute(str);
    }
}
