package zendesk.conversationkit.android.internal.metadata;

import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.Boxing;
import kotlin.coroutines.jvm.internal.ContinuationImpl;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000<\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\b\u0002\n\u0002\u0010 \n\u0002\b\b\n\u0002\u0010\u000b\n\u0002\b\u0002\b\u0000\u0018\u00002\u00020\u0001B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u000e\u0010\u0007\u001a\u00020\bH\u0086@¢\u0006\u0002\u0010\tJ\u000e\u0010\n\u001a\u00020\bH\u0086@¢\u0006\u0002\u0010\tJ\u000e\u0010\u000b\u001a\u00020\bH\u0086@¢\u0006\u0002\u0010\tJ<\u0010\f\u001a\u0010\u0012\u0004\u0012\u00020\u000e\u0012\u0004\u0012\u00020\u0001\u0018\u00010\r2\u0014\u0010\u000f\u001a\u0010\u0012\u0004\u0012\u00020\u000e\u0012\u0004\u0012\u00020\u0001\u0018\u00010\r2\u000e\u0010\u0010\u001a\n\u0012\u0004\u0012\u00020\u000e\u0018\u00010\u0011H\u0002J\u001c\u0010\u0012\u001a\u0010\u0012\u0004\u0012\u00020\u000e\u0012\u0004\u0012\u00020\u0001\u0018\u00010\rH\u0082@¢\u0006\u0002\u0010\tJ\u0016\u0010\u0013\u001a\n\u0012\u0004\u0012\u00020\u000e\u0018\u00010\u0011H\u0082@¢\u0006\u0002\u0010\tJ\u001c\u0010\u0014\u001a\u0010\u0012\u0004\u0012\u00020\u000e\u0012\u0004\u0012\u00020\u0001\u0018\u00010\rH\u0086@¢\u0006\u0002\u0010\tJ\"\u0010\u0015\u001a\u00020\b2\u0012\u0010\u000f\u001a\u000e\u0012\u0004\u0012\u00020\u000e\u0012\u0004\u0012\u00020\u00010\rH\u0086@¢\u0006\u0002\u0010\u0016J\u001c\u0010\u0017\u001a\u00020\b2\f\u0010\u0010\u001a\b\u0012\u0004\u0012\u00020\u000e0\u0011H\u0086@¢\u0006\u0002\u0010\u0018J$\u0010\u0019\u001a\u00020\u001a2\u0014\u0010\u001b\u001a\u0010\u0012\u0004\u0012\u00020\u000e\u0012\u0004\u0012\u00020\u0001\u0018\u00010\rH\u0086@¢\u0006\u0002\u0010\u0016R\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u001c"}, m18d2 = {"Lzendesk/conversationkit/android/internal/metadata/MetadataManager;", "", "metadataStorage", "Lzendesk/conversationkit/android/internal/metadata/MetadataStorage;", "metadataFormatter", "Lzendesk/conversationkit/android/internal/metadata/MetadataFormatter;", "(Lzendesk/conversationkit/android/internal/metadata/MetadataStorage;Lzendesk/conversationkit/android/internal/metadata/MetadataFormatter;)V", "clearConversationFields", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "clearConversationTags", "clearStorage", "formatMetadata", "", "", "fields", "tags", "", "getConversationFields", "getConversationTags", "getMetadata", "saveConversationFields", "(Ljava/util/Map;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "saveConversationTags", "(Ljava/util/List;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "shouldUpdateMetadata", "", "metadata", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MetadataManager {
    private final MetadataFormatter metadataFormatter;
    private final MetadataStorage metadataStorage;

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.metadata.MetadataManager", m37f = "MetadataManager.kt", m38i = {0, 1, 1}, m39l = {61, 62}, m40m = "getMetadata", m41n = {"this", "this", "customFields"}, m42s = {"L$0", "L$0", "L$1"})
    static final class C10741 extends ContinuationImpl {
        Object L$0;
        Object L$1;
        int label;
        Object result;

        C10741(Continuation<? super C10741> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return MetadataManager.this.getMetadata(this);
        }
    }

    @Metadata(m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.metadata.MetadataManager", m37f = "MetadataManager.kt", m38i = {0}, m39l = {92}, m40m = "shouldUpdateMetadata", m41n = {"metadata"}, m42s = {"L$0"})
    static final class C10751 extends ContinuationImpl {
        Object L$0;
        int label;
        Object result;

        C10751(Continuation<? super C10751> continuation) {
            super(continuation);
        }

        @Override
        public final Object invokeSuspend(Object obj) {
            this.result = obj;
            this.label |= Integer.MIN_VALUE;
            return MetadataManager.this.shouldUpdateMetadata(null, this);
        }
    }

    public MetadataManager(MetadataStorage metadataStorage, MetadataFormatter metadataFormatter) {
        Intrinsics.checkNotNullParameter(metadataStorage, "metadataStorage");
        Intrinsics.checkNotNullParameter(metadataFormatter, "metadataFormatter");
        this.metadataStorage = metadataStorage;
        this.metadataFormatter = metadataFormatter;
    }

    public final Object saveConversationFields(Map<String, ? extends Object> map, Continuation<? super Unit> continuation) {
        Object objSaveConversationFields = this.metadataStorage.saveConversationFields(map, continuation);
        return objSaveConversationFields == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objSaveConversationFields : Unit.INSTANCE;
    }

    public final Object saveConversationTags(List<String> list, Continuation<? super Unit> continuation) {
        Object objSaveConversationTags = this.metadataStorage.saveConversationTags(list, continuation);
        return objSaveConversationTags == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objSaveConversationTags : Unit.INSTANCE;
    }

    public final Object clearConversationFields(Continuation<? super Unit> continuation) {
        Object objClearConversationFields = this.metadataStorage.clearConversationFields(continuation);
        return objClearConversationFields == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objClearConversationFields : Unit.INSTANCE;
    }

    public final Object clearConversationTags(Continuation<? super Unit> continuation) {
        Object objClearConversationTags = this.metadataStorage.clearConversationTags(continuation);
        return objClearConversationTags == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objClearConversationTags : Unit.INSTANCE;
    }

    public final Object clearStorage(Continuation<? super Unit> continuation) {
        Object objClear = this.metadataStorage.clear(continuation);
        return objClear == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objClear : Unit.INSTANCE;
    }

    public final Object getConversationTags(Continuation<? super List<String>> continuation) {
        return this.metadataStorage.getConversationTags(continuation);
    }

    public final Object getConversationFields(Continuation<? super Map<String, ? extends Object>> continuation) {
        return this.metadataStorage.getConversationFields(continuation);
    }

    public final Object getMetadata(Continuation<? super Map<String, ? extends Object>> continuation) {
        C10741 c10741;
        MetadataManager metadataManager;
        Map<String, ? extends Object> map;
        MetadataManager metadataManager2;
        if (continuation instanceof C10741) {
            c10741 = (C10741) continuation;
            if ((c10741.label & Integer.MIN_VALUE) != 0) {
                c10741.label -= Integer.MIN_VALUE;
            } else {
                c10741 = new C10741(continuation);
            }
        } else {
            c10741 = new C10741(continuation);
        }
        Object conversationFields = c10741.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10741.label;
        if (i == 0) {
            ResultKt.throwOnFailure(conversationFields);
            c10741.L$0 = this;
            c10741.label = 1;
            conversationFields = getConversationFields(c10741);
            if (conversationFields == coroutine_suspended) {
                return coroutine_suspended;
            }
            metadataManager = this;
        } else {
            if (i == 1) {
                metadataManager = (MetadataManager) c10741.L$0;
                ResultKt.throwOnFailure(conversationFields);
            } else {
                if (i != 2) {
                    throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
                }
                map = (Map) c10741.L$1;
                metadataManager2 = (MetadataManager) c10741.L$0;
                ResultKt.throwOnFailure(conversationFields);
            }
            return metadataManager2.formatMetadata(map, (List) conversationFields);
        }
        Map<String, ? extends Object> map2 = (Map) conversationFields;
        c10741.L$0 = metadataManager;
        c10741.L$1 = map2;
        c10741.label = 2;
        Object conversationTags = metadataManager.getConversationTags(c10741);
        if (conversationTags == coroutine_suspended) {
            return coroutine_suspended;
        }
        map = map2;
        conversationFields = conversationTags;
        metadataManager2 = metadataManager;
        return metadataManager2.formatMetadata(map, (List) conversationFields);
    }

    private final Map<String, Object> formatMetadata(Map<String, ? extends Object> fields, List<String> tags) {
        LinkedHashMap linkedHashMap = new LinkedHashMap();
        if (fields != null && !fields.isEmpty()) {
            linkedHashMap.putAll(this.metadataFormatter.formatConversationFields(fields));
        }
        List<String> list = tags;
        if (list != null && !list.isEmpty()) {
            linkedHashMap.putAll(this.metadataFormatter.formatConversationTags(tags));
        }
        if (linkedHashMap.isEmpty()) {
            return null;
        }
        return linkedHashMap;
    }

    public final Object shouldUpdateMetadata(Map<String, ? extends Object> map, Continuation<? super Boolean> continuation) {
        C10751 c10751;
        if (continuation instanceof C10751) {
            c10751 = (C10751) continuation;
            if ((c10751.label & Integer.MIN_VALUE) != 0) {
                c10751.label -= Integer.MIN_VALUE;
            } else {
                c10751 = new C10751(continuation);
            }
        } else {
            c10751 = new C10751(continuation);
        }
        Object metadata = c10751.result;
        Object coroutine_suspended = IntrinsicsKt.getCOROUTINE_SUSPENDED();
        int i = c10751.label;
        if (i == 0) {
            ResultKt.throwOnFailure(metadata);
            c10751.L$0 = map;
            c10751.label = 1;
            metadata = getMetadata(c10751);
            if (metadata == coroutine_suspended) {
                return coroutine_suspended;
            }
        } else {
            if (i != 1) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            map = (Map) c10751.L$0;
            ResultKt.throwOnFailure(metadata);
        }
        Map map2 = (Map) metadata;
        return Boxing.boxBoolean((map2 == null || map2.isEmpty() || Intrinsics.areEqual(map2, map)) ? false : true);
    }
}
