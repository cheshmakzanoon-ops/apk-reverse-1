package com.common;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.io.PrintWriter;
import java.io.StringReader;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketTimeoutException;
import java.nio.charset.StandardCharsets;
import java.util.regex.Matcher;
import java.util.regex.Pattern;
import javax.net.ssl.SSLSocket;
import javax.net.ssl.SSLSocketFactory;

public class HttpsSocketClient {

    public interface ILoggerImpl {
        void mo826d(String str, String str2);
    }

    public static class DefaultLoggerImpl implements ILoggerImpl {
        @Override
        public void mo826d(String str, String str2) {
            System.out.println(str + ": " + str2);
        }
    }

    public static class Logger {
        public static ILoggerImpl impl;

        public static void m827d(String str, String str2) {
            impl.mo826d(str, str2);
        }
    }

    public static String sendHttpsGetRequest(String str, String str2, int i, int i2) {
        SSLSocketFactory sSLSocketFactory = (SSLSocketFactory) SSLSocketFactory.getDefault();
        String response = null;
        try {
            Socket socket = new Socket();
            try {
                socket.connect(new InetSocketAddress(str, 443), i);
                SSLSocket sSLSocket = (SSLSocket) sSLSocketFactory.createSocket(socket, str, 443, true);
                try {
                    sSLSocket.startHandshake();
                    sSLSocket.setSoTimeout(i2);
                    PrintWriter printWriter = new PrintWriter(sSLSocket.getOutputStream());
                    try {
                        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(sSLSocket.getInputStream()));
                        try {
                            printWriter.println("GET " + str2 + " HTTP/1.1");
                            StringBuilder sb = new StringBuilder("Host: ");
                            sb.append(str);
                            printWriter.println(sb.toString());
                            printWriter.println("User-Agent: okhttp/3.12.1");
                            printWriter.println("Content-Type: text/plain; charset=utf-8");
                            printWriter.println("Connection: close");
                            printWriter.println();
                            printWriter.flush();
                            StringBuilder sb2 = new StringBuilder();
                            long jCurrentTimeMillis = System.currentTimeMillis() + ((long) i2);
                            while (true) {
                                try {
                                    String line = bufferedReader.readLine();
                                    if (line == null || System.currentTimeMillis() >= jCurrentTimeMillis) {
                                        break;
                                    }
                                    sb2.append(line);
                                    sb2.append("\n");
                                } catch (SocketTimeoutException unused) {
                                }
                            }
                            response = parseResponse(sb2.toString());
                            bufferedReader.close();
                            printWriter.close();
                            if (sSLSocket != null) {
                                sSLSocket.close();
                            }
                            socket.close();
                        } catch (Throwable th) {
                            try {
                                throw th;
                            } catch (Throwable th2) {
                                try {
                                    bufferedReader.close();
                                } catch (Throwable th3) {
                                    th.addSuppressed(th3);
                                }
                                throw th2;
                            }
                        }
                    } catch (Throwable th4) {
                        try {
                            throw th4;
                        } catch (Throwable th5) {
                            try {
                                printWriter.close();
                            } catch (Throwable th6) {
                                th4.addSuppressed(th6);
                            }
                            throw th5;
                        }
                    }
                } catch (Throwable th7) {
                    try {
                        throw th7;
                    } catch (Throwable th8) {
                        if (sSLSocket != null) {
                            try {
                                sSLSocket.close();
                            } catch (Throwable th9) {
                                th7.addSuppressed(th9);
                            }
                        }
                        throw th8;
                    }
                }
            } catch (Throwable th10) {
                try {
                    throw th10;
                } catch (Throwable th11) {
                    try {
                        socket.close();
                    } catch (Throwable th12) {
                        th10.addSuppressed(th12);
                    }
                    throw th11;
                }
            }
        } catch (Exception unused2) {
        }
        return response;
    }

    private static String readToEnd(BufferedReader bufferedReader) throws IOException {
        StringBuilder sb = new StringBuilder();
        char[] cArr = new char[1024];
        while (true) {
            int i = bufferedReader.read(cArr);
            if (i != -1) {
                sb.append(cArr, 0, i);
            } else {
                return sb.toString();
            }
        }
    }

    private static String parseResponse(String str) throws IOException {
        int i;
        String line;
        Matcher matcher = Pattern.compile("^HTTP/\\d\\.\\d (\\d{3}) .*", 8).matcher(str);
        if (matcher.find()) {
            int i2 = Integer.parseInt(matcher.group(1));
            int iEnd = matcher.end();
            while (true) {
                i = -1;
                if (iEnd >= str.length()) {
                    iEnd = -1;
                    break;
                }
                char cCharAt = str.charAt(iEnd);
                if (cCharAt != '\r' && cCharAt != '\n') {
                    break;
                }
                iEnd++;
            }
            String strSubstring = iEnd >= 0 ? str.substring(iEnd) : null;
            if (strSubstring != null && i2 >= 200 && i2 < 300 && i2 != 204) {
                Pattern patternCompile = Pattern.compile("^(.*): (.*)$");
                try {
                    BufferedReader bufferedReader = new BufferedReader(new StringReader(strSubstring));
                    while (true) {
                        try {
                            line = bufferedReader.readLine();
                            if (line == null || line.isEmpty()) {
                                break;
                                break;
                            }
                            Matcher matcher2 = patternCompile.matcher(line);
                            if (matcher2.find() && matcher2.group(1).trim().equalsIgnoreCase("content-length")) {
                                try {
                                    i = Integer.parseInt(matcher2.group(2).trim());
                                } catch (NumberFormatException unused) {
                                }
                            }
                        } catch (Throwable th) {
                            try {
                                throw th;
                            } catch (Throwable th2) {
                                try {
                                    bufferedReader.close();
                                } catch (Throwable th3) {
                                    th.addSuppressed(th3);
                                }
                                throw th2;
                            }
                        }
                    }
                    String toEnd = line == null ? null : readToEnd(bufferedReader);
                    if (toEnd != null) {
                        if (i > 0) {
                            toEnd = new String(toEnd.getBytes(StandardCharsets.UTF_8), 0, i, StandardCharsets.UTF_8);
                        }
                        bufferedReader.close();
                        return toEnd;
                    }
                    bufferedReader.close();
                } catch (Exception unused2) {
                }
            }
        }
        return null;
    }
}
