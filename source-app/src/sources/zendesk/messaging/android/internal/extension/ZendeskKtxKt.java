package zendesk.messaging.android.internal.extension;

import android.content.Context;
import kotlin.Metadata;
import kotlin.NoWhenBranchMatchedException;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.Intrinsics;
import zendesk.android.Zendesk;
import zendesk.android.ZendeskCredentials;
import zendesk.android.ZendeskResult;
import zendesk.android.internal.ZendeskError;
import zendesk.android.messaging.Messaging;
import zendesk.android.messaging.MessagingFactory;
import zendesk.messaging.android.DefaultMessagingFactory;
import zendesk.messaging.android.internal.DefaultMessaging;
import zendesk.messaging.android.internal.p023di.MessagingComponent;

@Metadata(m17d1 = {"\u00004\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0003\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\u001a\u000e\u0010\u0000\u001a\u0004\u0018\u00010\u0001*\u00020\u0002H\u0000\u001a8\u0010\u0003\u001a\u000e\u0012\u0004\u0012\u00020\u0005\u0012\u0004\u0012\u00020\u00060\u0004*\u00020\u00022\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\n2\b\b\u0002\u0010\u000b\u001a\u00020\fH\u0080@¢\u0006\u0002\u0010\r\u001a\u000e\u0010\u000e\u001a\u0004\u0018\u00010\u000f*\u00020\u0002H\u0000¨\u0006\u0010"}, m18d2 = {"defaultMessaging", "Lzendesk/messaging/android/internal/DefaultMessaging;", "Lzendesk/android/Zendesk$Companion;", "messaging", "Lzendesk/android/ZendeskResult;", "Lzendesk/android/messaging/Messaging;", "", "context", "Landroid/content/Context;", "credentials", "Lzendesk/android/ZendeskCredentials;", "messagingFactory", "Lzendesk/android/messaging/MessagingFactory;", "(Lzendesk/android/Zendesk$Companion;Landroid/content/Context;Lzendesk/android/ZendeskCredentials;Lzendesk/android/messaging/MessagingFactory;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "messagingComponent", "Lzendesk/messaging/android/internal/di/MessagingComponent;", "zendesk.messaging_messaging-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ZendeskKtxKt {

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.messaging.android.internal.extension.ZendeskKtxKt", m37f = "ZendeskKtx.kt", m38i = {}, m39l = {29}, m40m = "messaging", m41n = {}, m42s = {})
    static final class C15091 extends ContinuationImpl {
        int label;
        Object result;

        C15091(Continuation<? super C15091> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ZendeskKtxKt.messaging(null, null, null, null, this);
        }
    }

    public static final Object messaging(Zendesk.Companion companion, Context context, ZendeskCredentials zendeskCredentials, MessagingFactory messagingFactory, Continuation<? super ZendeskResult<? extends Messaging, ? extends Throwable>> continuation) throws Throwable {
        C15091 c15091;
        if (continuation instanceof C15091) {
            c15091 = (C15091) continuation;
            if ((c15091.label & Integer.MIN_VALUE) != 0) {
                c15091.label -= Integer.MIN_VALUE;
            } else {
                c15091 = new C15091(continuation);
            }
        } else {
            c15091 = new C15091(continuation);
        }
        C15091 c15092 = c15091;
        Object objInitialize = c15092.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c15092.label;
        if (i == 0) {
            ResultKt.throwOnFailure(objInitialize);
            String channelKey = zendeskCredentials.getChannelKey();
            c15092.label = 1;
            objInitialize = companion.initialize(context, channelKey, messagingFactory, true, (Continuation) c15092);
            if (objInitialize == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(objInitialize);
        }
        ZendeskResult zendeskResult = (ZendeskResult) objInitialize;
        if (zendeskResult instanceof ZendeskResult.Failure) {
            return new ZendeskResult.Failure(new ZendeskError.FailedToInitialize((Throwable) ((ZendeskResult.Failure) zendeskResult).getError()));
        }
        if (zendeskResult instanceof ZendeskResult.Success) {
            return new ZendeskResult.Success(((Zendesk) ((ZendeskResult.Success) zendeskResult).getValue()).getMessaging());
        }
        throw new NoWhenBranchMatchedException();
    }

    public static Object messaging$default(Zendesk.Companion companion, Context context, ZendeskCredentials zendeskCredentials, MessagingFactory messagingFactory, Continuation continuation, int i, Object obj) {
        if ((i & 4) != 0) {
            messagingFactory = new DefaultMessagingFactory(null, 0 == true ? 1 : 0, 3, 0 == true ? 1 : 0);
        }
        return messaging(companion, context, zendeskCredentials, messagingFactory, continuation);
    }

    public static final DefaultMessaging defaultMessaging(Zendesk.Companion companion) {
        Intrinsics.checkNotNullParameter(companion, "<this>");
        Messaging messaging = companion.getInstance().getMessaging();
        if (messaging instanceof DefaultMessaging) {
            return (DefaultMessaging) messaging;
        }
        return null;
    }

    public static final MessagingComponent messagingComponent(Zendesk.Companion companion) {
        Intrinsics.checkNotNullParameter(companion, "<this>");
        DefaultMessaging defaultMessaging = defaultMessaging(companion);
        if (defaultMessaging != null) {
            return defaultMessaging.getMessagingComponent();
        }
        return null;
    }
}
