package net.aihelp.core.net.check;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStreamReader;
import java.net.Inet4Address;
import java.net.Inet6Address;
import java.net.InetAddress;
import java.net.UnknownHostException;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

public final class TraceRoute implements Task {
    private static final String Error = "network error";
    private static final String MATCH_PING_IP = "(?<=from ).*(?=: icmp_seq=1 ttl=)";
    private static final String MATCH_PING_TIME = "(?<=time=).*?ms";
    private static final String MATCH_TRACE_IP = "(?<=From )(?:[0-9]{1,3}\\.){3}[0-9]{1,3}";
    private static final String MATCH_TRACE_IP_V6 = "(?<=From )\\s*((([0-9A-Fa-f]{1,4}:){7}([0-9A-Fa-f]{1,4}|:))|(([0-9A-Fa-f]{1,4}:){6}(:[0-9A-Fa-f]{1,4}|((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3})|:))|(([0-9A-Fa-f]{1,4}:){5}(((:[0-9A-Fa-f]{1,4}){1,2})|:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3})|:))|(([0-9A-Fa-f]{1,4}:){4}(((:[0-9A-Fa-f]{1,4}){1,3})|((:[0-9A-Fa-f]{1,4})?:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){3}(((:[0-9A-Fa-f]{1,4}){1,4})|((:[0-9A-Fa-f]{1,4}){0,2}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){2}(((:[0-9A-Fa-f]{1,4}){1,5})|((:[0-9A-Fa-f]{1,4}){0,3}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(([0-9A-Fa-f]{1,4}:){1}(((:[0-9A-Fa-f]{1,4}){1,6})|((:[0-9A-Fa-f]{1,4}){0,4}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:))|(:(((:[0-9A-Fa-f]{1,4}){1,7})|((:[0-9A-Fa-f]{1,4}){0,5}:((25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])(\\.(25[0-5]|2[0-4][0-9]|1[0-9][0-9]|[1-9]?[0-9])){3}))|:)))(%.+)?\\s*";
    private static final int MaxHop = 21;
    private final String address;
    private final Callback complete;
    private volatile boolean stopped = false;
    private Result result = null;

    public interface Callback {
        void complete(Result result);
    }

    private TraceRoute(String str, Callback callback) {
        this.address = str;
        this.complete = callback;
    }

    static Matcher traceMatcher(String str, boolean z) {
        if (z) {
            return Pattern.compile(MATCH_TRACE_IP_V6).matcher(str);
        }
        return Pattern.compile(MATCH_TRACE_IP).matcher(str);
    }

    static Matcher timeMatcher(String str) {
        return Pattern.compile(MATCH_PING_TIME).matcher(str);
    }

    static Matcher ipMatcher(String str) {
        return Pattern.compile(MATCH_PING_IP).matcher(str);
    }

    static String getIpFromTraceMatcher(Matcher matcher) {
        String strGroup = matcher.group();
        int iIndexOf = strGroup.indexOf(40);
        return iIndexOf >= 0 ? strGroup.substring(iIndexOf + 1) : strGroup;
    }

    public static Task start(String str, Callback callback) {
        TraceRoute traceRoute = new TraceRoute(str, callback);
        new Thread(new Runnable() {
            @Override
            public void run() {
                TraceRoute.this.run();
            }
        }).start();
        return traceRoute;
    }

    private static String getIp(String str) throws UnknownHostException {
        return InetAddress.getByName(str).getHostAddress();
    }

    @Override
    public void stop() {
        this.stopped = true;
    }

    private Process executePingCmd(String str, int i, boolean z) throws IOException {
        String str2 = "ping -n -c 1 -t " + i + " " + str;
        if (z) {
            str2 = "ping6 -n -c 1 -t " + i + " " + str;
        }
        return Runtime.getRuntime().exec(str2);
    }

    private String getPingtOutput(Process process) {
        BufferedReader bufferedReader = new BufferedReader(new InputStreamReader(process.getInputStream()));
        StringBuilder sb = new StringBuilder();
        while (true) {
            try {
                try {
                    try {
                        String line = bufferedReader.readLine();
                        if (line == null) {
                            break;
                        }
                        sb.append(line);
                    } catch (IOException e) {
                        e.printStackTrace();
                        bufferedReader.close();
                    }
                } catch (Throwable th) {
                    try {
                        bufferedReader.close();
                    } catch (IOException e2) {
                        e2.printStackTrace();
                    }
                    throw th;
                }
            } catch (IOException e3) {
                e3.printStackTrace();
            }
        }
        bufferedReader.close();
        try {
            process.waitFor();
        } catch (InterruptedException e4) {
            e4.printStackTrace();
        }
        process.destroy();
        return sb.toString();
    }

    private void printNormal(Matcher matcher, long j, StringBuilder sb) {
        String ipFromTraceMatcher = getIpFromTraceMatcher(matcher);
        sb.append("\t");
        sb.append(ipFromTraceMatcher);
        sb.append("\t\t");
        sb.append(j);
        sb.append("ms\t");
        this.result.append(sb.toString());
    }

    private void printEnd(Matcher matcher, String str, StringBuilder sb) {
        String strGroup = matcher.group();
        Matcher matcherTimeMatcher = timeMatcher(str);
        if (matcherTimeMatcher.find()) {
            String strGroup2 = matcherTimeMatcher.group();
            sb.append("\t\t");
            sb.append(strGroup);
            sb.append("\t\t");
            sb.append(strGroup2);
            sb.append("\t");
            updateOut(sb.toString());
        }
    }

    private void updateOut(String str) {
        Result result = this.result;
        if (result == null || str == null) {
            return;
        }
        result.append(str);
    }

    public void run() {
        boolean z;
        try {
            String ip = getIp(this.address);
            try {
                InetAddress byName = InetAddress.getByName(ip);
                if (byName instanceof Inet6Address) {
                    z = true;
                } else {
                    boolean z2 = byName instanceof Inet4Address;
                    z = false;
                }
            } catch (Exception unused) {
            }
            Result result = new Result(ip);
            this.result = result;
            result.append(String.format("TraceRoute host address is %s. \n", this.address));
            for (int i = 1; i < 21 && !this.stopped; i++) {
                long jCurrentTimeMillis = System.currentTimeMillis();
                try {
                    Process processExecutePingCmd = executePingCmd(ip, i, z);
                    long jCurrentTimeMillis2 = System.currentTimeMillis();
                    String pingtOutput = getPingtOutput(processExecutePingCmd);
                    if (pingtOutput.length() == 0) {
                        updateOut(Error);
                        break;
                    }
                    Matcher matcherTraceMatcher = traceMatcher(pingtOutput, z);
                    StringBuilder sb = new StringBuilder(256);
                    sb.append(i);
                    sb.append(".");
                    if (matcherTraceMatcher.find()) {
                        printNormal(matcherTraceMatcher, (jCurrentTimeMillis2 - jCurrentTimeMillis) / 2, sb);
                    } else {
                        Matcher matcherIpMatcher = ipMatcher(pingtOutput);
                        if (matcherIpMatcher.find()) {
                            printEnd(matcherIpMatcher, pingtOutput, sb);
                            break;
                        } else {
                            sb.append("\t\t * \t");
                            updateOut(sb.toString());
                        }
                    }
                } catch (IOException e) {
                    e.printStackTrace();
                    updateOut("ping cmd error " + e.getMessage());
                }
            }
            this.complete.complete(this.result);
        } catch (UnknownHostException e2) {
            e2.printStackTrace();
            updateOut("unknown host " + this.address);
            Result result2 = new Result("");
            this.result = result2;
            this.complete.complete(result2);
        }
    }

    public static class Result {
        private String allData;
        private final StringBuilder builder = new StringBuilder();

        public final String f66ip;

        public Result(String str) {
            this.f66ip = str;
        }

        public String content() {
            String str = this.allData;
            if (str != null) {
                return str;
            }
            String string = this.builder.toString();
            this.allData = string;
            return string;
        }

        public void append(String str) {
            this.builder.append(str);
        }
    }
}
