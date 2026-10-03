package net.aihelp.core.net.check;

import android.os.AsyncTask;
import java.io.BufferedReader;
import java.io.InputStreamReader;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.Locale;

public final class Ping implements Task {
    private final String address;
    private final Callback complete;
    private final int count;
    private int interval;
    private final int size;
    private volatile boolean stopped;

    public interface Callback {
        void complete(Result result);
    }

    private Ping(String str, int i, Callback callback) {
        this(str, i, 56, 200, callback);
    }

    private Ping(String str, int i, int i2, int i3, Callback callback) {
        this.address = str;
        this.count = i;
        this.size = i2;
        this.interval = i3;
        this.complete = callback;
        this.stopped = false;
    }

    public static Result startSync(String str) {
        return startSync(str, 1);
    }

    public static Result startSync(String str, int i) {
        return new Ping(str, i, null).pingCmd();
    }

    public static Task start(String str, Callback callback) {
        return start(str, 5, callback);
    }

    public static Task start(String str, int i, Callback callback) {
        Ping ping = new Ping(str, i, callback);
        AsyncTask.execute(new Runnable() {
            @Override
            public void run() throws Throwable {
                Ping.this.run();
            }
        });
        return ping;
    }

    private static String getIp(String str) throws UnknownHostException {
        return InetAddress.getByName(str).getHostAddress();
    }

    public void run() throws Throwable {
        Result resultPingCmd = pingCmd();
        Callback callback = this.complete;
        if (callback != null) {
            callback.complete(resultPingCmd);
        }
    }

    private Result pingCmd() throws Throwable {
        ?? r4;
        String str;
        try {
            String ip = getIp(this.address);
            try {
                InetAddress byName = InetAddress.getByName(ip);
                if (byName instanceof Inet6Address) {
                    r4 = true;
                } else {
                    boolean z = byName instanceof Inet4Address;
                    r4 = false;
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            if (r4 == false) {
                str = "ping -n -i %f -s %d -c %d %s";
            } else {
                str = "ping6 -n -i %f -s %d -c %d %s";
            }
            ?? string = String.format(Locale.getDefault(), str, Double.valueOf(((double) this.interval) / 1000.0d), Integer.valueOf(this.size), Integer.valueOf(this.count), ip);
            StringBuilder sb = new StringBuilder();
            ?? r5 = 0;
            bufferedReader = null;
            BufferedReader bufferedReader = null;
            r5 = 0;
            try {
                try {
                    try {
                        string = Runtime.getRuntime().exec(string);
                        try {
                            BufferedReader bufferedReader2 = new BufferedReader(new InputStreamReader(string.getInputStream()));
                            try {
                                BufferedReader bufferedReader3 = new BufferedReader(new InputStreamReader(string.getErrorStream()));
                                if ("".equals(sb.toString())) {
                                    sb.append("Ping host address is ");
                                    sb.append(this.address);
                                    sb.append(".");
                                    sb.append("\n");
                                }
                                while (true) {
                                    String line = bufferedReader2.readLine();
                                    if (line == null) {
                                        break;
                                    }
                                    sb.append(line);
                                    sb.append("\n");
                                }
                                while (true) {
                                    String line2 = bufferedReader3.readLine();
                                    if (line2 == null) {
                                        break;
                                    }
                                    sb.append(line2);
                                }
                                bufferedReader2.close();
                                bufferedReader3.close();
                                string.waitFor();
                                bufferedReader2.close();
                                if (string != 0) {
                                    string.destroy();
                                }
                            } catch (Exception e2) {
                                e = e2;
                                bufferedReader = bufferedReader2;
                                e.printStackTrace();
                                if (bufferedReader != null) {
                                    bufferedReader.close();
                                }
                                if (string != 0) {
                                    string.destroy();
                                }
                            } catch (Throwable th) {
                                th = th;
                                r5 = bufferedReader2;
                                if (r5 != 0) {
                                    try {
                                        r5.close();
                                        if (string != 0) {
                                            string.destroy();
                                        }
                                    } catch (Exception e3) {
                                        e3.printStackTrace();
                                        throw th;
                                    }
                                } else if (string != 0) {
                                    string.destroy();
                                }
                                throw th;
                            }
                        } catch (Exception e4) {
                            e = e4;
                        }
                    } catch (Throwable th2) {
                        th = th2;
                    }
                } catch (Exception e5) {
                    e = e5;
                    string = 0;
                } catch (Throwable th3) {
                    th = th3;
                    string = 0;
                }
            } catch (Exception e6) {
                e6.printStackTrace();
            }
            string = sb.toString();
            int i = this.size;
            r5 = this.interval;
            return new Result(string, ip, i, r5);
        } catch (UnknownHostException e7) {
            return new Result(e7.toString(), "", 0, 0);
        }
    }

    @Override
    public void stop() {
        this.stopped = true;
    }

    public static class Result {
        public float avg;
        public int count;
        public int dropped;
        public final int interval;

        public final String f65ip;
        public boolean isSuccess;
        public float max;
        public float min;
        public final String result;
        public int sent;
        public final int size;
        public float stddev;
        private final String lastLinePrefix = "rtt min/avg/max/mdev = ";
        private final String packetWords = " packets transmitted";
        private final String receivedWords = " received";

        Result(String str, String str2, int i, int i2) {
            this.result = str;
            this.f65ip = str2;
            this.size = i;
            this.interval = i2;
            parseResult();
        }

        static String trimNoneDigital(String str) {
            if (str == null || str.length() == 0) {
                return "";
            }
            char[] charArray = str.toCharArray();
            char[] cArr = new char[charArray.length];
            int i = 0;
            for (char c : charArray) {
                if ((c >= '0' && c <= '9') || c == '.') {
                    cArr[i] = c;
                    i++;
                }
            }
            return new String(cArr, 0, i);
        }

        private void parseRttLine(String str) {
            String[] strArrSplit = str.substring(23, str.length() - 3).split("/");
            if (strArrSplit.length != 4) {
                return;
            }
            this.min = Float.parseFloat(trimNoneDigital(strArrSplit[0]));
            this.avg = Float.parseFloat(trimNoneDigital(strArrSplit[1]));
            this.max = Float.parseFloat(trimNoneDigital(strArrSplit[2]));
            this.stddev = Float.parseFloat(trimNoneDigital(strArrSplit[3]));
        }

        private void parsePacketLine(String str) {
            String[] strArrSplit = str.split(",");
            if (strArrSplit.length != 4) {
                return;
            }
            if (strArrSplit[0].length() > 20) {
                String str2 = strArrSplit[0];
                this.count = Integer.parseInt(str2.substring(0, str2.length() - 20));
            }
            if (strArrSplit[1].length() > 9) {
                String str3 = strArrSplit[1];
                this.sent = Integer.parseInt(str3.substring(0, str3.length() - 9).trim());
            }
            this.dropped = this.count - this.sent;
        }

        private void parseResult() {
            boolean z = false;
            try {
                for (String str : this.result.split("\n")) {
                    if (str.contains(" packets transmitted")) {
                        parsePacketLine(str);
                    } else if (str.contains("rtt min/avg/max/mdev = ")) {
                        parseRttLine(str);
                    }
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
            String str2 = this.f65ip;
            if (str2 != null && str2.length() > 0 && this.sent > 0 && this.avg > 0.0f) {
                z = true;
            }
            this.isSuccess = z;
        }
    }
}
