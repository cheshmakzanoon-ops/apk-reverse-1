package zendesk.faye.internal;

import java.util.Iterator;
import java.util.concurrent.ConcurrentLinkedQueue;
import java.util.concurrent.atomic.AtomicBoolean;
import kotlin.Metadata;
import kotlin.collections.CollectionsKt;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import okhttp3.Response;
import okhttp3.WebSocket;
import okhttp3.WebSocketListener;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import zendesk.faye.BayeuxMessage;
import zendesk.faye.ConnectMessage;
import zendesk.faye.DisconnectMessage;
import zendesk.faye.FayeClient;
import zendesk.faye.FayeClientError;
import zendesk.faye.FayeClientListener;
import zendesk.faye.PublishMessage;
import zendesk.faye.SubscribeMessage;
import zendesk.faye.UnsubscribeMessage;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000z\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000b\n\u0002\b\u0005\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0003\b\u0000\u0018\u0000 :2\u00020\u0001:\u0002:;B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u0010\u0010\u001b\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u0014H\u0016J\u0010\u0010\u001e\u001a\u00020\u001c2\u0006\u0010\u001f\u001a\u00020 H\u0002J\u0018\u0010!\u001a\u00020\u001c2\u0006\u0010\"\u001a\u00020\u00032\u0006\u0010#\u001a\u00020$H\u0002J\u0010\u0010%\u001a\u00020\u001c2\u0006\u0010&\u001a\u00020\rH\u0002J\u0010\u0010'\u001a\u00020\u001c2\u0006\u0010&\u001a\u00020\rH\u0002J\u0018\u0010(\u001a\u00020\u001c2\u0006\u0010#\u001a\u00020$2\u0006\u0010&\u001a\u00020\rH\u0002J\u0018\u0010)\u001a\u00020\u001c2\u0006\u0010#\u001a\u00020$2\u0006\u0010&\u001a\u00020\rH\u0002J\u0018\u0010*\u001a\u00020\u001c2\u0006\u0010#\u001a\u00020$2\u0006\u0010&\u001a\u00020\rH\u0002J\b\u0010\n\u001a\u00020\rH\u0016J\u0010\u0010+\u001a\u00020\u001c2\u0006\u0010,\u001a\u00020\u0003H\u0002J\u0010\u0010-\u001a\u00020\u001c2\u0006\u0010.\u001a\u00020/H\u0002J\u0010\u00100\u001a\u00020\u001c2\u0006\u0010\u001d\u001a\u00020\u0014H\u0016J\u0010\u00101\u001a\u00020\u001c2\u0006\u00102\u001a\u000203H\u0016J\u0010\u00104\u001a\u00020\u001c2\u0006\u00105\u001a\u000206H\u0002J\u0010\u00107\u001a\u00020\u001c2\u0006\u00108\u001a\u000209H\u0002R\u0010\u0010\u0007\u001a\u0004\u0018\u00010\bX\u0082\u000e¢\u0006\u0002\n\u0000R\u0010\u0010\t\u001a\u0004\u0018\u00010\u0003X\u0082\u000e¢\u0006\u0002\n\u0000R\u000e\u0010\n\u001a\u00020\u000bX\u0082\u000e¢\u0006\u0002\n\u0000R\u001a\u0010\f\u001a\u00020\rX\u0096\u000e¢\u0006\u000e\n\u0000\u001a\u0004\b\u000e\u0010\u000f\"\u0004\b\u0010\u0010\u0011R\u001a\u0010\u0012\u001a\b\u0012\u0004\u0012\u00020\u00140\u0013X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0016R\u0018\u0010\u0017\u001a\u00060\u0018R\u00020\u0000X\u0080\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u001aR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006<"}, m18d2 = {"Lzendesk/faye/internal/DefaultFayeClient;", "Lzendesk/faye/FayeClient;", "serverUrl", "", "webSocket", "Lzendesk/faye/internal/OkHttpWebSocket;", "(Ljava/lang/String;Lzendesk/faye/internal/OkHttpWebSocket;)V", "connectMessage", "Lzendesk/faye/ConnectMessage;", "fayeClientId", "isConnected", "Ljava/util/concurrent/atomic/AtomicBoolean;", "keepConnectionAlive", "", "getKeepConnectionAlive", "()Z", "setKeepConnectionAlive", "(Z)V", "listeners", "Ljava/util/concurrent/ConcurrentLinkedQueue;", "Lzendesk/faye/FayeClientListener;", "getListeners$zendesk_faye_faye", "()Ljava/util/concurrent/ConcurrentLinkedQueue;", "okHttpWebSocketListener", "Lzendesk/faye/internal/DefaultFayeClient$OkHttpWebSocketListener;", "getOkHttpWebSocketListener$zendesk_faye_faye", "()Lzendesk/faye/internal/DefaultFayeClient$OkHttpWebSocketListener;", "addListener", "", "listener", "disconnect", "disconnectMessage", "Lzendesk/faye/DisconnectMessage;", "handleChannelMessage", Bayeux.KEY_CHANNEL, "fayeMessage", "Lorg/json/JSONObject;", "handleConnectMessage", "success", "handleDisconnectMessage", "handleHandshakeMessage", "handleSubscribeMessage", "handleUnsubscribeMessage", "parseFayeMessage", "message", "publish", "publishMessage", "Lzendesk/faye/PublishMessage;", "removeListener", "send", "bayeuxMessage", "Lzendesk/faye/BayeuxMessage;", "subscribeTo", "subscribeMessage", "Lzendesk/faye/SubscribeMessage;", "unsubscribeFrom", "unsubscribeMessage", "Lzendesk/faye/UnsubscribeMessage;", "Companion", "OkHttpWebSocketListener", "zendesk.faye_faye"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class DefaultFayeClient implements FayeClient {
    private static final String LOG_TAG = "DefaultFayeClient";
    private ConnectMessage connectMessage;
    private String fayeClientId;
    private AtomicBoolean isConnected;
    private boolean keepConnectionAlive;
    private final ConcurrentLinkedQueue<FayeClientListener> listeners;
    private final OkHttpWebSocketListener okHttpWebSocketListener;
    private final String serverUrl;
    private final OkHttpWebSocket webSocket;

    public DefaultFayeClient(String serverUrl, OkHttpWebSocket webSocket) {
        Intrinsics.checkNotNullParameter(serverUrl, "serverUrl");
        Intrinsics.checkNotNullParameter(webSocket, "webSocket");
        this.serverUrl = serverUrl;
        this.webSocket = webSocket;
        this.okHttpWebSocketListener = new OkHttpWebSocketListener();
        this.listeners = new ConcurrentLinkedQueue<>();
        this.isConnected = new AtomicBoolean(false);
        this.keepConnectionAlive = true;
    }

    public final OkHttpWebSocketListener getOkHttpWebSocketListener() {
        return this.okHttpWebSocketListener;
    }

    public final ConcurrentLinkedQueue<FayeClientListener> getListeners$zendesk_faye_faye() {
        return this.listeners;
    }

    @Override
    public boolean getKeepConnectionAlive() {
        return this.keepConnectionAlive;
    }

    @Override
    public void setKeepConnectionAlive(boolean z) {
        this.keepConnectionAlive = z;
    }

    @Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010\u0003\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0080\u0004\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J \u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0016J\"\u0010\u000b\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\f\u001a\u00020\r2\b\u0010\u000e\u001a\u0004\u0018\u00010\u000fH\u0016J\u0018\u0010\u0010\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0011\u001a\u00020\nH\u0016J\u0018\u0010\u0012\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u000e\u001a\u00020\u000fH\u0016¨\u0006\u0013"}, m18d2 = {"Lzendesk/faye/internal/DefaultFayeClient$OkHttpWebSocketListener;", "Lokhttp3/WebSocketListener;", "(Lzendesk/faye/internal/DefaultFayeClient;)V", "onClosed", "", "webSocket", "Lokhttp3/WebSocket;", "code", "", "reason", "", "onFailure", "t", "", "response", "Lokhttp3/Response;", "onMessage", "text", "onOpen", "zendesk.faye_faye"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public final class OkHttpWebSocketListener extends WebSocketListener {
        public OkHttpWebSocketListener() {
        }

        @Override
        public void onOpen(WebSocket webSocket, Response response) {
            Intrinsics.checkNotNullParameter(webSocket, "webSocket");
            Intrinsics.checkNotNullParameter(response, "response");
            ConnectMessage connectMessage = DefaultFayeClient.this.connectMessage;
            if (connectMessage != null) {
                DefaultFayeClient.this.webSocket.send(Bayeux.INSTANCE.handshake(connectMessage.getSupportedConnectionTypes(), connectMessage.getHandshakeOptionalFields()));
            } else {
                Logger.m225w(DefaultFayeClient.LOG_TAG, "onOpen called but connectMessage was null, closing the socket", new Object[0]);
                DefaultFayeClient.this.webSocket.disconnect();
            }
        }

        @Override
        public void onMessage(WebSocket webSocket, String text) {
            Intrinsics.checkNotNullParameter(webSocket, "webSocket");
            Intrinsics.checkNotNullParameter(text, "text");
            Logger.m217d(DefaultFayeClient.LOG_TAG, "Message received: " + text, new Object[0]);
            DefaultFayeClient.this.parseFayeMessage(text);
        }

        @Override
        public void onClosed(WebSocket webSocket, int code, String reason) {
            Intrinsics.checkNotNullParameter(webSocket, "webSocket");
            Intrinsics.checkNotNullParameter(reason, "reason");
            DefaultFayeClient.this.isConnected.set(false);
            DefaultFayeClient.this.webSocket.resetSocket();
            Iterator<FayeClientListener> it = DefaultFayeClient.this.getListeners$zendesk_faye_faye().iterator();
            while (it.hasNext()) {
                it.next().onDisconnectedFromServer();
            }
        }

        @Override
        public void onFailure(WebSocket webSocket, Throwable t, Response response) {
            Intrinsics.checkNotNullParameter(webSocket, "webSocket");
            Intrinsics.checkNotNullParameter(t, "t");
            DefaultFayeClient.this.isConnected.set(false);
            DefaultFayeClient.this.webSocket.resetSocket();
            for (FayeClientListener fayeClientListener : DefaultFayeClient.this.getListeners$zendesk_faye_faye()) {
                fayeClientListener.onDisconnectedFromServer();
                fayeClientListener.onClientError(FayeClientError.CLIENT_TRANSPORT_ERROR, t);
            }
        }
    }

    @Override
    public synchronized void addListener(FayeClientListener listener) {
        Intrinsics.checkNotNullParameter(listener, "listener");
        if (!this.listeners.contains(listener)) {
            this.listeners.add(listener);
        }
    }

    @Override
    public synchronized void removeListener(final FayeClientListener listener) {
        Intrinsics.checkNotNullParameter(listener, "listener");
        CollectionsKt.removeAll(this.listeners, new Function1<FayeClientListener, Boolean>() {
            {
                super(1);
            }

            @Override
            public final Boolean invoke(FayeClientListener fayeClientListener) {
                return Boolean.valueOf(Intrinsics.areEqual(fayeClientListener, listener));
            }
        });
    }

    @Override
    public boolean isConnected() {
        return this.isConnected.get();
    }

    @Override
    public void send(BayeuxMessage bayeuxMessage) {
        Intrinsics.checkNotNullParameter(bayeuxMessage, "bayeuxMessage");
        if (bayeuxMessage instanceof ConnectMessage) {
            if (this.webSocket.connectTo(this.serverUrl, this.okHttpWebSocketListener)) {
                this.connectMessage = (ConnectMessage) bayeuxMessage;
            }
        } else {
            if (bayeuxMessage instanceof DisconnectMessage) {
                disconnect((DisconnectMessage) bayeuxMessage);
                return;
            }
            if (bayeuxMessage instanceof SubscribeMessage) {
                subscribeTo((SubscribeMessage) bayeuxMessage);
            } else if (bayeuxMessage instanceof UnsubscribeMessage) {
                unsubscribeFrom((UnsubscribeMessage) bayeuxMessage);
            } else if (bayeuxMessage instanceof PublishMessage) {
                publish((PublishMessage) bayeuxMessage);
            }
        }
    }

    private final void disconnect(DisconnectMessage disconnectMessage) {
        String str = this.fayeClientId;
        if (str != null) {
            this.webSocket.send(Bayeux.INSTANCE.disconnect(str, disconnectMessage.getOptionalFields()));
        }
        this.webSocket.disconnect();
        this.isConnected.set(false);
    }

    private final void subscribeTo(SubscribeMessage subscribeMessage) {
        String str = this.fayeClientId;
        if (!this.isConnected.get() || str == null) {
            Iterator<FayeClientListener> it = this.listeners.iterator();
            while (it.hasNext()) {
                it.next().onClientError(FayeClientError.CLIENT_NOT_CONNECTED_ERROR, null);
            }
        } else {
            this.webSocket.send(Bayeux.INSTANCE.subscribe(str, subscribeMessage.getChannel(), subscribeMessage.getOptionalFields()));
        }
    }

    private final void unsubscribeFrom(UnsubscribeMessage unsubscribeMessage) {
        String str = this.fayeClientId;
        if (!this.isConnected.get() || str == null) {
            Iterator<FayeClientListener> it = this.listeners.iterator();
            while (it.hasNext()) {
                it.next().onClientError(FayeClientError.CLIENT_NOT_CONNECTED_ERROR, null);
            }
        } else {
            this.webSocket.send(Bayeux.INSTANCE.unsubscribe(str, unsubscribeMessage.getChannel(), unsubscribeMessage.getOptionalFields()));
        }
    }

    private final void publish(PublishMessage publishMessage) {
        if (!this.isConnected.get()) {
            Iterator<FayeClientListener> it = this.listeners.iterator();
            while (it.hasNext()) {
                it.next().onClientError(FayeClientError.CLIENT_NOT_CONNECTED_ERROR, null);
            }
            return;
        }
        String strPublish = Bayeux.INSTANCE.publish(publishMessage.getChannel(), publishMessage.getMessage(), this.fayeClientId, publishMessage.getOptionalFields());
        Logger.m217d(LOG_TAG, "Publishing to channel " + publishMessage.getChannel() + ", message: " + publishMessage.getMessage(), new Object[0]);
        this.webSocket.send(strPublish);
        Iterator<FayeClientListener> it2 = this.listeners.iterator();
        while (it2.hasNext()) {
            it2.next().onMessagePublished(publishMessage.getChannel(), publishMessage.getMessage());
        }
    }

    public final void parseFayeMessage(String message) {
        try {
            JSONArray jSONArray = new JSONArray(message);
            int length = jSONArray.length();
            for (int i = 0; i < length; i++) {
                JSONObject jSONObjectOptJSONObject = jSONArray.optJSONObject(i);
                if (jSONObjectOptJSONObject != null) {
                    String strOptString = jSONObjectOptJSONObject.optString(Bayeux.KEY_CHANNEL);
                    boolean zOptBoolean = jSONObjectOptJSONObject.optBoolean(Bayeux.KEY_SUCCESS);
                    if (strOptString != null) {
                        switch (strOptString) {
                            case "/meta/handshake":
                                handleHandshakeMessage(jSONObjectOptJSONObject, zOptBoolean);
                                break;
                            case "/meta/unsubscribe":
                                handleUnsubscribeMessage(jSONObjectOptJSONObject, zOptBoolean);
                                break;
                            case "/meta/subscribe":
                                handleSubscribeMessage(jSONObjectOptJSONObject, zOptBoolean);
                                break;
                            case "/meta/connect":
                                handleConnectMessage(zOptBoolean);
                                break;
                            case "/meta/disconnect":
                                handleDisconnectMessage(zOptBoolean);
                                break;
                            default:
                                Intrinsics.checkNotNull(strOptString);
                                handleChannelMessage(strOptString, jSONObjectOptJSONObject);
                                break;
                        }
                    } else {
                        Intrinsics.checkNotNull(strOptString);
                        handleChannelMessage(strOptString, jSONObjectOptJSONObject);
                    }
                }
            }
        } catch (JSONException unused) {
            Logger.m225w(LOG_TAG, "parseFayeMessage failed to parse message: " + message, new Object[0]);
        }
    }

    private final void handleHandshakeMessage(JSONObject fayeMessage, boolean success) {
        String strOptString = fayeMessage.optString(Bayeux.KEY_CLIENT_ID);
        ConnectMessage connectMessage = this.connectMessage;
        if (success && strOptString != null && connectMessage != null) {
            this.isConnected.set(true);
            this.fayeClientId = strOptString;
            this.webSocket.send(Bayeux.INSTANCE.connect(strOptString, connectMessage.getConnectOptionalFields()));
            Iterator<FayeClientListener> it = this.listeners.iterator();
            while (it.hasNext()) {
                it.next().onConnectedToServer();
            }
            return;
        }
        this.webSocket.disconnect();
    }

    private final void handleConnectMessage(boolean success) {
        String str = this.fayeClientId;
        ConnectMessage connectMessage = this.connectMessage;
        if (success && connectMessage != null && str != null) {
            if (getKeepConnectionAlive()) {
                this.webSocket.send(Bayeux.INSTANCE.connect(str, connectMessage.getConnectOptionalFields()));
            }
        } else {
            this.webSocket.disconnect();
            Iterator<FayeClientListener> it = this.listeners.iterator();
            while (it.hasNext()) {
                it.next().onDisconnectedFromServer();
            }
        }
    }

    private final void handleDisconnectMessage(boolean success) {
        if (success) {
            this.isConnected.set(false);
            this.webSocket.disconnect();
            Iterator<FayeClientListener> it = this.listeners.iterator();
            while (it.hasNext()) {
                it.next().onDisconnectedFromServer();
            }
            return;
        }
        Logger.m225w(LOG_TAG, "handleDisconnectMessage called, but success was false", new Object[0]);
    }

    private final void handleSubscribeMessage(JSONObject fayeMessage, boolean success) {
        if (success) {
            for (FayeClientListener fayeClientListener : this.listeners) {
                String strOptString = fayeMessage.optString(Bayeux.KEY_SUBSCRIPTION);
                Intrinsics.checkNotNullExpressionValue(strOptString, "optString(...)");
                fayeClientListener.onSubscribedToChannel(strOptString);
            }
            return;
        }
        Logger.m225w(LOG_TAG, "handleSubscribeMessage called, but success was false", new Object[0]);
    }

    private final void handleUnsubscribeMessage(JSONObject fayeMessage, boolean success) {
        if (success) {
            for (FayeClientListener fayeClientListener : this.listeners) {
                String strOptString = fayeMessage.optString(Bayeux.KEY_SUBSCRIPTION);
                Intrinsics.checkNotNullExpressionValue(strOptString, "optString(...)");
                fayeClientListener.onUnsubscribedFromChannel(strOptString);
            }
            return;
        }
        Logger.m225w(LOG_TAG, "handleUnsubscribeMessage called, but success was false", new Object[0]);
    }

    private final void handleChannelMessage(String channel, JSONObject fayeMessage) {
        JSONObject jSONObjectOptJSONObject = fayeMessage.optJSONObject(Bayeux.KEY_DATA);
        if (jSONObjectOptJSONObject != null) {
            for (FayeClientListener fayeClientListener : this.listeners) {
                String string = jSONObjectOptJSONObject.toString();
                Intrinsics.checkNotNullExpressionValue(string, "toString(...)");
                fayeClientListener.onMessageReceived(channel, string);
            }
        }
    }
}
