package zendesk.faye.internal;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.WebSocket;
import okhttp3.WebSocketListener;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0004\b\u0000\u0018\u0000 \u00122\u00020\u0001:\u0001\u0012B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0016\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\u0006\u0010\u000b\u001a\u00020\fJ\u0006\u0010\r\u001a\u00020\bJ\u0006\u0010\u000e\u001a\u00020\u000fJ\u000e\u0010\u0010\u001a\u00020\b2\u0006\u0010\u0011\u001a\u00020\nR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u0010\u0010\u0005\u001a\u0004\u0018\u00010\u0006X\u0082\u000e¢\u0006\u0002\n\u0000¨\u0006\u0013"}, m18d2 = {"Lzendesk/faye/internal/OkHttpWebSocket;", "", "client", "Lokhttp3/OkHttpClient;", "(Lokhttp3/OkHttpClient;)V", "socket", "Lokhttp3/WebSocket;", "connectTo", "", "url", "", "listener", "Lokhttp3/WebSocketListener;", "disconnect", "resetSocket", "", "send", "message", "Companion", "zendesk.faye_faye"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class OkHttpWebSocket {
    private static final int CLOSE_CODE_NORMAL = 1000;
    private static final String LOG_TAG = "OkHttpWebSocket";
    private final OkHttpClient client;
    private WebSocket socket;

    public OkHttpWebSocket(OkHttpClient client) {
        Intrinsics.checkNotNullParameter(client, "client");
        this.client = client;
    }

    public final boolean connectTo(String url, WebSocketListener listener) {
        Intrinsics.checkNotNullParameter(url, "url");
        Intrinsics.checkNotNullParameter(listener, "listener");
        if (this.socket != null) {
            Logger.m225w(LOG_TAG, "connectTo was called but socket was not null", new Object[0]);
            return false;
        }
        this.socket = this.client.newWebSocket(new Request.Builder().url(url).build(), listener);
        return true;
    }

    public final boolean disconnect() {
        boolean zClose;
        WebSocket webSocket = this.socket;
        if (webSocket != null) {
            zClose = webSocket.close(1000, null);
        } else {
            Logger.m225w(LOG_TAG, "disconnect was called but socket was null", new Object[0]);
            zClose = false;
        }
        if (zClose) {
            resetSocket();
        }
        return zClose;
    }

    public final boolean send(String message) {
        Intrinsics.checkNotNullParameter(message, "message");
        WebSocket webSocket = this.socket;
        if (webSocket != null) {
            return webSocket.send(message);
        }
        Logger.m225w(LOG_TAG, "send was called but socket was null", new Object[0]);
        return false;
    }

    public final void resetSocket() {
        this.socket = null;
    }
}
