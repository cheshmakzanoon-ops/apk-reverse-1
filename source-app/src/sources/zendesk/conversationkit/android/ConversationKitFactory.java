package zendesk.conversationkit.android;

import android.content.Context;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import net.aihelp.data.track.data.TrackType;
import zendesk.conversationkit.android.internal.Action;
import zendesk.conversationkit.android.internal.ConversationKitStore;
import zendesk.conversationkit.android.internal.Environment;
import zendesk.conversationkit.android.internal.metadata.DefaultConversationMetadataService;
import zendesk.conversationkit.android.model.Config;

@Metadata(m17d1 = {"\u0000&\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u0018\u0000 \f2\u00020\u0001:\u0001\fB\u000f\b\u0002\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u001e\u0010\u0005\u001a\u00020\u00062\u0006\u0010\u0007\u001a\u00020\b2\u0006\u0010\t\u001a\u00020\nH\u0086@¢\u0006\u0002\u0010\u000bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\r"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitFactory;", "", "context", "Landroid/content/Context;", "(Landroid/content/Context;)V", "create", "Lzendesk/conversationkit/android/ConversationKit;", "settings", "Lzendesk/conversationkit/android/ConversationKitSettings;", "config", "Lzendesk/conversationkit/android/model/Config;", "(Lzendesk/conversationkit/android/ConversationKitSettings;Lzendesk/conversationkit/android/model/Config;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ConversationKitFactory {

    public static final Companion INSTANCE = new Companion(null);
    private final Context context;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.ConversationKitFactory", m37f = "ConversationKitFactory.kt", m38i = {0, 0, 1}, m39l = {TrackType.TRACK_DURATION_USER_WAITING, 55}, m40m = "create", m41n = {"settings", "conversationKitStore", "conversationKitStore"}, m42s = {"L$0", "L$1", "L$0"})
    static final class C09911 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C09911(Continuation<? super C09911> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return ConversationKitFactory.this.create(null, null, this);
        }
    }

    public ConversationKitFactory(Context context, DefaultConstructorMarker defaultConstructorMarker) {
        this(context);
    }

    @JvmStatic
    public static final ConversationKitFactory from(Context context) {
        return INSTANCE.from(context);
    }

    private ConversationKitFactory(Context context) {
        this.context = context;
    }

    public final Object create(ConversationKitSettings conversationKitSettings, Config config, Continuation<? super ConversationKit> continuation) throws Throwable {
        C09911 c09911;
        ConversationKitSettings conversationKitSettings2;
        ConversationKitStore conversationKitStore;
        if (continuation instanceof C09911) {
            c09911 = (C09911) continuation;
            if ((c09911.label & Integer.MIN_VALUE) != 0) {
                c09911.label -= Integer.MIN_VALUE;
            } else {
                c09911 = new C09911(continuation);
            }
        } else {
            c09911 = new C09911(continuation);
        }
        Object obj = c09911.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c09911.label;
        if (i == 0) {
            ResultKt.throwOnFailure(obj);
            ConversationKitStore conversationKitStoreCreateConversationKitStore = Environment.INSTANCE.main(this.context, config, conversationKitSettings).createConversationKitStore();
            Action.CheckForPersistedUser checkForPersistedUser = Action.CheckForPersistedUser.INSTANCE;
            c09911.L$0 = conversationKitSettings;
            c09911.L$1 = conversationKitStoreCreateConversationKitStore;
            c09911.label = 1;
            if (conversationKitStoreCreateConversationKitStore.dispatch(checkForPersistedUser, c09911) == coroutine_suspended) {
                return coroutine_suspended;
            }
            conversationKitSettings2 = conversationKitSettings;
            conversationKitStore = conversationKitStoreCreateConversationKitStore;
        } else {
            if (i == 1) {
                conversationKitStore = (ConversationKitStore) c09911.L$1;
                conversationKitSettings2 = (ConversationKitSettings) c09911.L$0;
                ResultKt.throwOnFailure(obj);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                conversationKitStore = (ConversationKitStore) c09911.L$0;
                ResultKt.throwOnFailure(obj);
            }
            return new DefaultConversationKit(conversationKitStore, new DefaultConversationMetadataService(conversationKitStore));
        }
        Action.PushCacheIntegrationId pushCacheIntegrationId = new Action.PushCacheIntegrationId(conversationKitSettings2.getIntegrationId());
        c09911.L$0 = conversationKitStore;
        c09911.L$1 = null;
        c09911.label = 2;
        if (conversationKitStore.dispatch(pushCacheIntegrationId, c09911) == coroutine_suspended) {
            return coroutine_suspended;
        }
        return new DefaultConversationKit(conversationKitStore, new DefaultConversationMetadataService(conversationKitStore));
    }

    @Metadata(m17d1 = {"\u0000\u0018\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u0010\u0010\u0003\u001a\u00020\u00042\u0006\u0010\u0005\u001a\u00020\u0006H\u0007¨\u0006\u0007"}, m18d2 = {"Lzendesk/conversationkit/android/ConversationKitFactory$Companion;", "", "()V", "from", "Lzendesk/conversationkit/android/ConversationKitFactory;", "context", "Landroid/content/Context;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        @JvmStatic
        public final ConversationKitFactory from(Context context) {
            Intrinsics.checkNotNullParameter(context, "context");
            return new ConversationKitFactory(context, null);
        }
    }
}
