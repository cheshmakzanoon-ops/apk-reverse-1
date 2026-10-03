package zendesk.faye;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import okhttp3.OkHttpClient;
import zendesk.faye.internal.DefaultFayeClient;
import zendesk.faye.internal.OkHttpWebSocket;

@Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0006\u0010\t\u001a\u00020\nJ\u000e\u0010\u000b\u001a\u00020\u00002\u0006\u0010\u0005\u001a\u00020\u0006J\u000e\u0010\f\u001a\u00020\u00002\u0006\u0010\u0007\u001a\u00020\bR\u0010\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\u0007\u001a\u0004\u0018\u00010\bX\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\r"}, m18d2 = {"Lzendesk/faye/FayeClientBuilder;", "", "serverUrl", "", "(Ljava/lang/String;)V", "fayeClientListener", "Lzendesk/faye/FayeClientListener;", "okHttpClient", "Lokhttp3/OkHttpClient;", "build", "Lzendesk/faye/FayeClient;", "withListener", "withOkHttpClient", "zendesk.faye_faye"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class FayeClientBuilder {
    private FayeClientListener fayeClientListener;
    private OkHttpClient okHttpClient;
    private final String serverUrl;

    public FayeClientBuilder(String serverUrl) {
        Intrinsics.checkNotNullParameter(serverUrl, "serverUrl");
        this.serverUrl = serverUrl;
    }

    public final FayeClientBuilder withOkHttpClient(OkHttpClient okHttpClient) {
        Intrinsics.checkNotNullParameter(okHttpClient, "okHttpClient");
        this.okHttpClient = okHttpClient;
        return this;
    }

    public final FayeClientBuilder withListener(FayeClientListener fayeClientListener) {
        Intrinsics.checkNotNullParameter(fayeClientListener, "fayeClientListener");
        this.fayeClientListener = fayeClientListener;
        return this;
    }

    public final FayeClient build() {
        OkHttpClient okHttpClient = this.okHttpClient;
        if (okHttpClient == null) {
            okHttpClient = new OkHttpClient();
        }
        DefaultFayeClient defaultFayeClient = new DefaultFayeClient(this.serverUrl, new OkHttpWebSocket(okHttpClient));
        FayeClientListener fayeClientListener = this.fayeClientListener;
        if (fayeClientListener != null) {
            defaultFayeClient.addListener(fayeClientListener);
        }
        return defaultFayeClient;
    }
}
