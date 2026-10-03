package zendesk.conversationkit.android.internal.metadata;

import java.util.List;
import java.util.Map;
import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;
import kotlin.Metadata;
import kotlin.ResultKt;
import kotlin.Unit;
import kotlin.coroutines.Continuation;
import kotlin.coroutines.intrinsics.IntrinsicsKt;
import kotlin.coroutines.jvm.internal.DebugMetadata;
import kotlin.coroutines.jvm.internal.SuspendLambda;
import kotlin.jvm.functions.Function2;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.MutablePropertyReference1Impl;
import kotlin.jvm.internal.Reflection;
import kotlin.jvm.internal.StringCompanionObject;
import kotlin.reflect.KProperty;
import kotlinx.coroutines.BuildersKt;
import kotlinx.coroutines.CoroutineScope;
import kotlinx.coroutines.ExecutorCoroutineDispatcher;
import kotlinx.coroutines.ExecutorsKt;
import kotlinx.serialization.SerializersKt;
import kotlinx.serialization.builtins.BuiltinSerializersKt;
import kotlinx.serialization.internal.ArrayListSerializer;
import kotlinx.serialization.internal.LinkedHashMapSerializer;
import kotlinx.serialization.internal.StringSerializer;
import kotlinx.serialization.json.Json;
import zendesk.storage.android.PersistedProperty;
import zendesk.storage.android.Storage;

@Metadata(m17d1 = {"\u0000>\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0010\u000e\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\b\u0005\n\u0002\u0010\u0002\n\u0002\b\u0004\n\u0002\u0010$\n\u0000\n\u0002\u0010 \n\u0002\b\u0007\b\u0000\u0018\u0000 $2\u00020\u0001:\u0001$B\u0015\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\u0006J\u000e\u0010\u0016\u001a\u00020\u0017H\u0086@¢\u0006\u0002\u0010\u0018J\u000e\u0010\u0019\u001a\u00020\u0017H\u0086@¢\u0006\u0002\u0010\u0018J\u000e\u0010\u001a\u001a\u00020\u0017H\u0086@¢\u0006\u0002\u0010\u0018J\u001c\u0010\u001b\u001a\u0010\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u0001\u0018\u00010\u001cH\u0086@¢\u0006\u0002\u0010\u0018J\u0016\u0010\u001d\u001a\n\u0012\u0004\u0012\u00020\b\u0018\u00010\u001eH\u0086@¢\u0006\u0002\u0010\u0018J\"\u0010\u001f\u001a\u00020\u00172\u0012\u0010 \u001a\u000e\u0012\u0004\u0012\u00020\b\u0012\u0004\u0012\u00020\u00010\u001cH\u0086@¢\u0006\u0002\u0010!J\u001c\u0010\"\u001a\u00020\u00172\f\u0010\u0012\u001a\b\u0012\u0004\u0012\u00020\b0\u001eH\u0086@¢\u0006\u0002\u0010#R/\u0010\t\u001a\u0004\u0018\u00010\b2\b\u0010\u0007\u001a\u0004\u0018\u00010\b8B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b\u000e\u0010\u000f\u001a\u0004\b\n\u0010\u000b\"\u0004\b\f\u0010\rR\u000e\u0010\u0004\u001a\u00020\u0005X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0010\u001a\u00020\u0011X\u0082\u0004¢\u0006\u0002\n\u0000R\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000R/\u0010\u0012\u001a\u0004\u0018\u00010\b2\b\u0010\u0007\u001a\u0004\u0018\u00010\b8B@BX\u0082\u008e\u0002¢\u0006\u0012\n\u0004\b\u0015\u0010\u000f\u001a\u0004\b\u0013\u0010\u000b\"\u0004\b\u0014\u0010\r¨\u0006%"}, m18d2 = {"Lzendesk/conversationkit/android/internal/metadata/MetadataStorage;", "", "storage", "Lzendesk/storage/android/Storage;", "json", "Lkotlinx/serialization/json/Json;", "(Lzendesk/storage/android/Storage;Lkotlinx/serialization/json/Json;)V", "<set-?>", "", "customFields", "getCustomFields", "()Ljava/lang/String;", "setCustomFields", "(Ljava/lang/String;)V", "customFields$delegate", "Lzendesk/storage/android/PersistedProperty;", "persistenceDispatcher", "Lkotlinx/coroutines/ExecutorCoroutineDispatcher;", "tags", "getTags", "setTags", "tags$delegate", "clear", "", "(Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "clearConversationFields", "clearConversationTags", "getConversationFields", "", "getConversationTags", "", "saveConversationFields", "fields", "(Ljava/util/Map;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "saveConversationTags", "(Ljava/util/List;Lkotlin/coroutines/Continuation;)Ljava/lang/Object;", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class MetadataStorage {
    static final KProperty<Object>[] $$delegatedProperties = {Reflection.mutableProperty1(new MutablePropertyReference1Impl(MetadataStorage.class, "customFields", "getCustomFields()Ljava/lang/String;", 0)), Reflection.mutableProperty1(new MutablePropertyReference1Impl(MetadataStorage.class, "tags", "getTags()Ljava/lang/String;", 0))};
    private static final String KEY_CUSTOM_FIELDS = "CUSTOM_FIELDS";
    private static final String KEY_TAGS = "TAGS";

    private final PersistedProperty customFields;
    private final Json json;
    private final ExecutorCoroutineDispatcher persistenceDispatcher;
    private final Storage storage;

    private final PersistedProperty tags;

    public MetadataStorage(Storage storage, Json json) {
        Intrinsics.checkNotNullParameter(storage, "storage");
        Intrinsics.checkNotNullParameter(json, "json");
        this.storage = storage;
        this.json = json;
        ExecutorService executorServiceNewSingleThreadExecutor = Executors.newSingleThreadExecutor();
        Intrinsics.checkNotNullExpressionValue(executorServiceNewSingleThreadExecutor, "newSingleThreadExecutor(...)");
        this.persistenceDispatcher = ExecutorsKt.from(executorServiceNewSingleThreadExecutor);
        this.customFields = new PersistedProperty(storage, KEY_CUSTOM_FIELDS, String.class);
        this.tags = new PersistedProperty(storage, KEY_TAGS, String.class);
    }

    public final String getCustomFields() {
        return (String) this.customFields.getValue(this, $$delegatedProperties[0]);
    }

    public final void setCustomFields(String str) {
        this.customFields.setValue(this, $$delegatedProperties[0], str);
    }

    public final String getTags() {
        return (String) this.tags.getValue(this, $$delegatedProperties[1]);
    }

    public final void setTags(String str) {
        this.tags.setValue(this, $$delegatedProperties[1], str);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.metadata.MetadataStorage$saveConversationFields$2", m37f = "MetadataStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10812 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final Map<String, Object> $fields;
        int label;

        C10812(Map<String, ? extends Object> map, Continuation<? super C10812> continuation) {
            super(2, continuation);
            this.$fields = map;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return MetadataStorage.this.new C10812(this.$fields, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10812) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                Json json = MetadataStorage.this.json;
                MetadataStorage.this.setCustomFields(json.encodeToString(new LinkedHashMapSerializer(StringSerializer.INSTANCE, SerializersKt.noCompiledSerializer(json.getSerializersModule(), Reflection.getOrCreateKotlinClass(Object.class))), this.$fields));
                return Unit.INSTANCE;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object saveConversationFields(Map<String, ? extends Object> map, Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C10812(map, null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\u0012\n\u0000\n\u0002\u0010$\n\u0002\u0010\u000e\n\u0002\u0010\u0000\n\u0002\u0018\u0002\u0010\u0000\u001a\u0010\u0012\u0004\u0012\u00020\u0002\u0012\u0004\u0012\u00020\u0003\u0018\u00010\u0001*\u00020\u0004H\u008a@"}, m18d2 = {"<anonymous>", "", "", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.metadata.MetadataStorage$getConversationFields$2", m37f = "MetadataStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10792 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Map<String, ? extends Object>>, Object> {
        int label;

        C10792(Continuation<? super C10792> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return MetadataStorage.this.new C10792(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Map<String, ? extends Object>> continuation) {
            return ((C10792) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                String customFields = MetadataStorage.this.getCustomFields();
                if (customFields == null) {
                    return null;
                }
                Json json = MetadataStorage.this.json;
                return (Map) json.decodeFromString(BuiltinSerializersKt.getNullable(new LinkedHashMapSerializer(StringSerializer.INSTANCE, SerializersKt.noCompiledSerializer(json.getSerializersModule(), Reflection.getOrCreateKotlinClass(Object.class)))), customFields);
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object getConversationFields(Continuation<? super Map<String, ? extends Object>> continuation) {
        return BuildersKt.withContext(this.persistenceDispatcher, new C10792(null), continuation);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.metadata.MetadataStorage$clearConversationFields$2", m37f = "MetadataStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10772 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C10772(Continuation<? super C10772> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return MetadataStorage.this.new C10772(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10772) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                MetadataStorage.this.setCustomFields(null);
                return Unit.INSTANCE;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object clearConversationFields(Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C10772(null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.metadata.MetadataStorage$saveConversationTags$2", m37f = "MetadataStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10822 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        final List<String> $tags;
        int label;

        C10822(List<String> list, Continuation<? super C10822> continuation) {
            super(2, continuation);
            this.$tags = list;
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return MetadataStorage.this.new C10822(this.$tags, continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10822) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label != 0) {
                throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
            }
            ResultKt.throwOnFailure(obj);
            MetadataStorage metadataStorage = MetadataStorage.this;
            Json json = metadataStorage.json;
            List<String> list = this.$tags;
            json.getSerializersModule();
            metadataStorage.setTags(json.encodeToString(new ArrayListSerializer(StringSerializer.INSTANCE), list));
            return Unit.INSTANCE;
        }
    }

    public final Object saveConversationTags(List<String> list, Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C10822(list, null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\u000e\n\u0000\n\u0002\u0010 \n\u0002\u0010\u000e\n\u0002\u0018\u0002\u0010\u0000\u001a\n\u0012\u0004\u0012\u00020\u0002\u0018\u00010\u0001*\u00020\u0003H\u008a@"}, m18d2 = {"<anonymous>", "", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.metadata.MetadataStorage$getConversationTags$2", m37f = "MetadataStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10802 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super List<? extends String>>, Object> {
        int label;

        C10802(Continuation<? super C10802> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return MetadataStorage.this.new C10802(continuation);
        }

        @Override
        public Object invoke(CoroutineScope coroutineScope, Continuation<? super List<? extends String>> continuation) {
            return invoke2(coroutineScope, (Continuation<? super List<String>>) continuation);
        }

        public final Object invoke2(CoroutineScope coroutineScope, Continuation<? super List<String>> continuation) {
            return ((C10802) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                String tags = MetadataStorage.this.getTags();
                if (tags != null) {
                    return (List) MetadataStorage.this.json.decodeFromString(BuiltinSerializersKt.ListSerializer(BuiltinSerializersKt.serializer(StringCompanionObject.INSTANCE)), tags);
                }
                return null;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object getConversationTags(Continuation<? super List<String>> continuation) {
        return BuildersKt.withContext(this.persistenceDispatcher, new C10802(null), continuation);
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.metadata.MetadataStorage$clearConversationTags$2", m37f = "MetadataStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10782 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C10782(Continuation<? super C10782> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return MetadataStorage.this.new C10782(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10782) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                MetadataStorage.this.setTags(null);
                return Unit.INSTANCE;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object clearConversationTags(Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C10782(null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }

    @Metadata(m17d1 = {"\u0000\n\n\u0000\n\u0002\u0010\u0002\n\u0002\u0018\u0002\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u008a@"}, m18d2 = {"<anonymous>", "", "Lkotlinx/coroutines/CoroutineScope;"}, m19k = 3, m20mv = {1, 9, 0}, m22xi = 48)
    @DebugMetadata(m36c = "zendesk.conversationkit.android.internal.metadata.MetadataStorage$clear$2", m37f = "MetadataStorage.kt", m38i = {}, m39l = {}, m40m = "invokeSuspend", m41n = {}, m42s = {})
    static final class C10762 extends SuspendLambda implements Function2<CoroutineScope, Continuation<? super Unit>, Object> {
        int label;

        C10762(Continuation<? super C10762> continuation) {
            super(2, continuation);
        }

        @Override
        public final Continuation<Unit> create(Object obj, Continuation<?> continuation) {
            return MetadataStorage.this.new C10762(continuation);
        }

        @Override
        public final Object invoke(CoroutineScope coroutineScope, Continuation<? super Unit> continuation) {
            return ((C10762) create(coroutineScope, continuation)).invokeSuspend(Unit.INSTANCE);
        }

        @Override
        public final Object invokeSuspend(Object obj) throws Throwable {
            IntrinsicsKt.getCOROUTINE_SUSPENDED();
            if (this.label == 0) {
                ResultKt.throwOnFailure(obj);
                MetadataStorage.this.storage.clear();
                return Unit.INSTANCE;
            }
            throw new IllegalStateException("call to 'resume' before 'invoke' with coroutine");
        }
    }

    public final Object clear(Continuation<? super Unit> continuation) {
        Object objWithContext = BuildersKt.withContext(this.persistenceDispatcher, new C10762(null), continuation);
        return objWithContext == IntrinsicsKt.getCOROUTINE_SUSPENDED() ? objWithContext : Unit.INSTANCE;
    }
}
