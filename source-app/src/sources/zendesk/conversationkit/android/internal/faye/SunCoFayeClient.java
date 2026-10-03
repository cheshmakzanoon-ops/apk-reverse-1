package zendesk.conversationkit.android.internal.faye;

import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import zendesk.conversationkit.android.ConnectionStatus;
import zendesk.conversationkit.android.model.Message;

@Metadata(m17d1 = {"\u0000(\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0003\n\u0002\u0018\u0002\n\u0002\b\u0002\b`\u0018\u00002\u00020\u0001J\u000e\u0010\u0002\u001a\u00020\u0003H¦@¢\u0006\u0002\u0010\u0004J\u0016\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\bH¦@¢\u0006\u0002\u0010\tJ\b\u0010\n\u001a\u00020\u0003H&J\b\u0010\u000b\u001a\u00020\fH&J\b\u0010\r\u001a\u00020\u0003H&¨\u0006\u000e"}, m18d2 = {"Lzendesk/conversationkit/android/internal/faye/SunCoFayeClient;", "", "awaitClientConnected", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "awaitFileUploadResult", "Lzendesk/conversationkit/android/model/Message;", "messageId", "", "(Ljava/lang/String;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "connect", "connectionStatus", "Lzendesk/conversationkit/android/ConnectionStatus;", "disconnect", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public interface SunCoFayeClient {
    Object awaitClientConnected(Continuation<? super Unit> continuation);

    Object awaitFileUploadResult(String str, Continuation<? super Message> continuation);

    void connect();

    ConnectionStatus connectionStatus();

    void disconnect();
}
