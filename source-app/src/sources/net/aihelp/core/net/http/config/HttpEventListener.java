package net.aihelp.core.net.http.config;

import java.io.IOException;
import java.net.InetAddress;
import java.net.InetSocketAddress;
import java.net.Proxy;
import java.util.Arrays;
import java.util.List;
import java.util.Locale;
import java.util.concurrent.atomic.AtomicLong;
import net.aihelp.utils.TLog;
import okhttp3.Call;
import okhttp3.EventListener;
import okhttp3.HttpUrl;
import okhttp3.Protocol;

public class HttpEventListener extends EventListener {
    public static final EventListener.Factory FACTORY = new EventListener.Factory() {
        final AtomicLong nextCallId = new AtomicLong(1);

        @Override
        public EventListener create(Call call) {
            return new HttpEventListener(this.nextCallId.getAndIncrement(), call.request().url(), System.nanoTime());
        }
    };
    private final long callId;
    private final long callStartNanos;
    private StringBuilder sbLog;

    public HttpEventListener(long j, HttpUrl httpUrl, long j2) {
        this.callId = j;
        this.callStartNanos = j2;
        StringBuilder sb = new StringBuilder(httpUrl.getUrl());
        sb.append(" ");
        sb.append(j);
        sb.append(":");
        this.sbLog = sb;
    }

    private void recordEventLog(String str) {
        long jNanoTime = System.nanoTime() - this.callStartNanos;
        StringBuilder sb = this.sbLog;
        sb.append(String.format(Locale.CHINA, "%.3f-%s", Double.valueOf(jNanoTime / 1.0E9d), str));
        sb.append(";");
        if (str.equalsIgnoreCase("callEnd") || str.equalsIgnoreCase("callFailed")) {
            TLog.m139d("okhttp", this.sbLog.toString());
        }
    }

    @Override
    public void callStart(Call call) {
        super.callStart(call);
        recordEventLog("callStart");
    }

    @Override
    public void callFailed(Call call, IOException iOException) {
        super.callFailed(call, iOException);
        recordEventLog("callFailed " + iOException.getMessage());
    }

    @Override
    public void dnsStart(Call call, String str) {
        super.dnsStart(call, str);
        recordEventLog("dnsStart");
    }

    @Override
    public void dnsEnd(Call call, String str, List<InetAddress> list) {
        super.dnsEnd(call, str, list);
        recordEventLog("dnsEnd");
        TLog.m139d("okhttp", Arrays.toString(list.toArray()));
    }

    @Override
    public void connectStart(Call call, InetSocketAddress inetSocketAddress, Proxy proxy) {
        super.connectStart(call, inetSocketAddress, proxy);
        recordEventLog("connectStart");
    }

    @Override
    public void connectEnd(Call call, InetSocketAddress inetSocketAddress, Proxy proxy, Protocol protocol) {
        super.connectEnd(call, inetSocketAddress, proxy, protocol);
        recordEventLog("connectEnd");
    }

    @Override
    public void connectFailed(Call call, InetSocketAddress inetSocketAddress, Proxy proxy, Protocol protocol, IOException iOException) {
        super.connectFailed(call, inetSocketAddress, proxy, protocol, iOException);
        recordEventLog("connectFailed");
    }
}
