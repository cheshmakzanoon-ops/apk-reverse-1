package zendesk.conversationkit.android.internal.metadata;

import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.jvm.internal.Intrinsics;
import zendesk.conversationkit.android.internal.Action;
import zendesk.conversationkit.android.internal.ConversationKitStore;

@Metadata(m17d1 = {"\u00000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0000\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\u0010\u0000\n\u0002\b\u0003\n\u0002\u0010 \n\u0002\b\u0005\b\u0000\u0018\u00002\u00020\u0001B\r\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\"\u0010\u0005\u001a\u00020\u00062\u0012\u0010\u0007\u001a\u000e\u0012\u0004\u0012\u00020\t\u0012\u0004\u0012\u00020\n0\bH\u0096@¢\u0006\u0002\u0010\u000bJ\u001c\u0010\f\u001a\u00020\u00062\f\u0010\r\u001a\b\u0012\u0004\u0012\u00020\t0\u000eH\u0096@¢\u0006\u0002\u0010\u000fJ\u000e\u0010\u0010\u001a\u00020\u0006H\u0096@¢\u0006\u0002\u0010\u0011J\u000e\u0010\u0012\u001a\u00020\u0006H\u0096@¢\u0006\u0002\u0010\u0011R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0013"}, m18d2 = {"Lzendesk/conversationkit/android/internal/metadata/DefaultConversationMetadataService;", "Lzendesk/conversationkit/android/internal/metadata/ConversationMetadataService;", "conversationKitStore", "Lzendesk/conversationkit/android/internal/ConversationKitStore;", "(Lzendesk/conversationkit/android/internal/ConversationKitStore;)V", "addConversationFields", "", "fields", "", "", "", "(Ljava/util/Map;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "addConversationTags", "tags", "", "(Ljava/util/List;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "removeConversationFields", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "removeConversationTags", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class DefaultConversationMetadataService implements ConversationMetadataService {
    private final ConversationKitStore conversationKitStore;

    public DefaultConversationMetadataService(ConversationKitStore conversationKitStore) {
        Intrinsics.checkNotNullParameter(conversationKitStore, "conversationKitStore");
        this.conversationKitStore = conversationKitStore;
    }

    @Override
    public Object addConversationFields(Map<String, ? extends Object> map, Continuation<? super Unit> continuation) throws Throwable {
        Object objDispatch = this.conversationKitStore.dispatch(new Action.AddConversationFields(map), continuation);
        return objDispatch == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDispatch : Unit.INSTANCE;
    }

    @Override
    public Object addConversationTags(List<String> list, Continuation<? super Unit> continuation) throws Throwable {
        Object objDispatch = this.conversationKitStore.dispatch(new Action.AddConversationTags(list), continuation);
        return objDispatch == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDispatch : Unit.INSTANCE;
    }

    @Override
    public Object removeConversationFields(Continuation<? super Unit> continuation) throws Throwable {
        Object objDispatch = this.conversationKitStore.dispatch(Action.ClearConversationFields.INSTANCE, continuation);
        return objDispatch == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDispatch : Unit.INSTANCE;
    }

    @Override
    public Object removeConversationTags(Continuation<? super Unit> continuation) throws Throwable {
        Object objDispatch = this.conversationKitStore.dispatch(Action.ClearConversationTags.INSTANCE, continuation);
        return objDispatch == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objDispatch : Unit.INSTANCE;
    }
}
