package zendesk.faye;

import kotlin.Metadata;
import zendesk.faye.internal.Bayeux;

@Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0003\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0002\b\u0005\bf\u0018\u00002\u00020\u0001J\u001a\u0010\u0002\u001a\u00020\u00032\u0006\u0010\u0004\u001a\u00020\u00052\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007H&J\b\u0010\b\u001a\u00020\u0003H&J\b\u0010\t\u001a\u00020\u0003H&J\u0018\u0010\n\u001a\u00020\u00032\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\fH&J\u0018\u0010\u000e\u001a\u00020\u00032\u0006\u0010\u000b\u001a\u00020\f2\u0006\u0010\r\u001a\u00020\fH&J\u0010\u0010\u000f\u001a\u00020\u00032\u0006\u0010\u000b\u001a\u00020\fH&J\u0010\u0010\u0010\u001a\u00020\u00032\u0006\u0010\u000b\u001a\u00020\fH&¨\u0006\u0011"}, m18d2 = {"Lzendesk/faye/FayeClientListener;", "", "onClientError", "", "fayeClientError", "Lzendesk/faye/FayeClientError;", "throwable", "", "onConnectedToServer", "onDisconnectedFromServer", "onMessagePublished", Bayeux.KEY_CHANNEL, "", "message", "onMessageReceived", "onSubscribedToChannel", "onUnsubscribedFromChannel", "zendesk.faye_faye"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface FayeClientListener {
    void onClientError(FayeClientError fayeClientError, Throwable throwable);

    void onConnectedToServer();

    void onDisconnectedFromServer();

    void onMessagePublished(String channel, String message);

    void onMessageReceived(String channel, String message);

    void onSubscribedToChannel(String channel);

    void onUnsubscribedFromChannel(String channel);
}
