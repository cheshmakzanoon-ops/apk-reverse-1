package zendesk.conversationkit.android.model;

import cz.msebera.android.httpclient.HttpStatus;
import java.lang.annotation.Annotation;
import java.util.Map;
import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Lazy;
import kotlin.LazyKt;
import kotlin.LazyThreadSafetyMode;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.UByte$$ExternalSyntheticBackport0;
import kotlin.collections.MapsKt;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.functions.Function0;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.jvm.internal.Reflection;
import kotlin.reflect.KClass;
import kotlinx.serialization.ContextualSerializer;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SealedClassSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.LinkedHashMapSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.internal.StringSerializer;

@Metadata(m17d1 = {"\u0000b\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0005\n\u0002\u0010$\n\u0002\b\u0003\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\b\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b7\u0018\u0000 \u001c2\u00020\u0001:\b\u001b\u001c\u001d\u001e\u001f !\"B#\b\u0017\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\u0002\u0010\bB\u000f\b\u0004\u0012\u0006\u0010\u0004\u001a\u00020\u0005¢\u0006\u0002\u0010\tJ!\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u00002\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u001aHÇ\u0001R\u0012\u0010\n\u001a\u00020\u000bX¦\u0004¢\u0006\u0006\u001a\u0004\b\f\u0010\rR\u0011\u0010\u0004\u001a\u00020\u0005¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u000fR\u001e\u0010\u0010\u001a\u000e\u0012\u0004\u0012\u00020\u000b\u0012\u0004\u0012\u00020\u00010\u0011X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0012\u0010\u0013\u0082\u0001\u0007#$%&'()¨\u0006*"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageAction;", "", "seen1", "", "messageActionType", "Lzendesk/conversationkit/android/model/MessageActionType;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/MessageActionType;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Lzendesk/conversationkit/android/model/MessageActionType;)V", "id", "", "getId", "()Ljava/lang/String;", "getMessageActionType", "()Lzendesk/conversationkit/android/model/MessageActionType;", "metadata", "", "getMetadata", "()Ljava/util/Map;", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "Buy", "Companion", "Link", "LocationRequest", "Postback", "Reply", "Share", "WebView", "Lzendesk/conversationkit/android/model/MessageAction$Buy;", "Lzendesk/conversationkit/android/model/MessageAction$Link;", "Lzendesk/conversationkit/android/model/MessageAction$LocationRequest;", "Lzendesk/conversationkit/android/model/MessageAction$Postback;", "Lzendesk/conversationkit/android/model/MessageAction$Reply;", "Lzendesk/conversationkit/android/model/MessageAction$Share;", "Lzendesk/conversationkit/android/model/MessageAction$WebView;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
@Serializable
public abstract class MessageAction {
    private final MessageActionType messageActionType;

    public static final Companion INSTANCE = new Companion(null);
    private static final KSerializer<Object>[] $childSerializers = {MessageActionType.INSTANCE.serializer()};
    private static final Lazy<KSerializer<Object>> $cachedSerializer$delegate = LazyKt.lazy(LazyThreadSafetyMode.PUBLICATION, (Function0) new Function0<KSerializer<Object>>() {
        @Override
        public final KSerializer<Object> invoke() {
            return new SealedClassSerializer("zendesk.conversationkit.android.model.MessageAction", Reflection.getOrCreateKotlinClass(MessageAction.class), new KClass[]{Reflection.getOrCreateKotlinClass(Buy.class), Reflection.getOrCreateKotlinClass(Link.class), Reflection.getOrCreateKotlinClass(LocationRequest.class), Reflection.getOrCreateKotlinClass(Postback.class), Reflection.getOrCreateKotlinClass(Reply.class), Reflection.getOrCreateKotlinClass(Share.class), Reflection.getOrCreateKotlinClass(WebView.class)}, new KSerializer[]{MessageAction$Buy$$serializer.INSTANCE, MessageAction$Link$$serializer.INSTANCE, MessageAction$LocationRequest$$serializer.INSTANCE, MessageAction$Postback$$serializer.INSTANCE, MessageAction$Reply$$serializer.INSTANCE, MessageAction$Share$$serializer.INSTANCE, MessageAction$WebView$$serializer.INSTANCE}, new Annotation[0]);
        }
    });

    public MessageAction(MessageActionType messageActionType, DefaultConstructorMarker defaultConstructorMarker) {
        this(messageActionType);
    }

    public abstract String getId();

    public abstract Map<String, Object> getMetadata();

    @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageAction$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageAction;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Companion {
        public Companion(DefaultConstructorMarker defaultConstructorMarker) {
            this();
        }

        private Companion() {
        }

        private final KSerializer get$cachedSerializer() {
            return (KSerializer) MessageAction.$cachedSerializer$delegate.getValue();
        }

        public final KSerializer<MessageAction> serializer() {
            return get$cachedSerializer();
        }
    }

    @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
    public MessageAction(int i, MessageActionType messageActionType, SerializationConstructorMarker serializationConstructorMarker) {
        this.messageActionType = messageActionType;
    }

    private MessageAction(MessageActionType messageActionType) {
        this.messageActionType = messageActionType;
    }

    @JvmStatic
    public static final void write$Self(MessageAction self, CompositeEncoder output, SerialDescriptor serialDesc) {
        output.encodeSerializableElement(serialDesc, 0, $childSerializers[0], self.messageActionType);
    }

    public final MessageActionType getMessageActionType() {
        return this.messageActionType;
    }

    @Metadata(m17d1 = {"\u0000`\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010$\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\t\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0016\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 82\u00020\u0001:\u000278Bx\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\u0019\u0010\b\u001a\u0015\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b\u0018\u00010\t\u0012\b\u0010\f\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u0007\u0012\u0006\u0010\u000e\u001a\u00020\u000f\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\u0011\u001a\u0004\u0018\u00010\u0012\u0012\b\u0010\u0013\u001a\u0004\u0018\u00010\u0014¢\u0006\u0002\u0010\u0015BP\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0019\b\u0002\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\t\u0012\u0006\u0010\f\u001a\u00020\u0007\u0012\u0006\u0010\r\u001a\u00020\u0007\u0012\u0006\u0010\u000e\u001a\u00020\u000f\u0012\u0006\u0010\u0010\u001a\u00020\u0007\u0012\u0006\u0010\u0011\u001a\u00020\u0012¢\u0006\u0002\u0010\u0016J\t\u0010\"\u001a\u00020\u0007HÆ\u0003J\u001a\u0010#\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\tHÆ\u0003J\t\u0010$\u001a\u00020\u0007HÆ\u0003J\t\u0010%\u001a\u00020\u0007HÆ\u0003J\t\u0010&\u001a\u00020\u000fHÆ\u0003J\t\u0010'\u001a\u00020\u0007HÆ\u0003J\t\u0010(\u001a\u00020\u0012HÆ\u0003J`\u0010)\u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u00072\u0019\b\u0002\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\t2\b\b\u0002\u0010\f\u001a\u00020\u00072\b\b\u0002\u0010\r\u001a\u00020\u00072\b\b\u0002\u0010\u000e\u001a\u00020\u000f2\b\b\u0002\u0010\u0010\u001a\u00020\u00072\b\b\u0002\u0010\u0011\u001a\u00020\u0012HÆ\u0001J\u0013\u0010*\u001a\u00020+2\b\u0010,\u001a\u0004\u0018\u00010\nHÖ\u0003J\t\u0010-\u001a\u00020\u0003HÖ\u0001J\t\u0010.\u001a\u00020\u0007HÖ\u0001J&\u0010/\u001a\u0002002\u0006\u00101\u001a\u00020\u00002\u0006\u00102\u001a\u0002032\u0006\u00104\u001a\u000205HÁ\u0001¢\u0006\u0002\b6R\u0011\u0010\u000e\u001a\u00020\u000f¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0011\u0010\u0010\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u001aR\u0014\u0010\u0006\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u001aR%\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\tX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001dR\u0011\u0010\u0011\u001a\u00020\u0012¢\u0006\b\n\u0000\u001a\u0004\b\u001e\u0010\u001fR\u0011\u0010\f\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b \u0010\u001aR\u0011\u0010\r\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b!\u0010\u001a¨\u00069"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageAction$Buy;", "Lzendesk/conversationkit/android/model/MessageAction;", "seen1", "", "messageActionType", "Lzendesk/conversationkit/android/model/MessageActionType;", "id", "", "metadata", "", "", "Lkotlinx/serialization/Contextual;", "text", "uri", "amount", "", "currency", "state", "Lzendesk/conversationkit/android/model/MessageActionBuyState;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/MessageActionType;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;JLjava/lang/String;Lzendesk/conversationkit/android/model/MessageActionBuyState;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;JLjava/lang/String;Lzendesk/conversationkit/android/model/MessageActionBuyState;)V", "getAmount", "()J", "getCurrency", "()Ljava/lang/String;", "getId", "getMetadata", "()Ljava/util/Map;", "getState", "()Lzendesk/conversationkit/android/model/MessageActionBuyState;", "getText", "getUri", "component1", "component2", "component3", "component4", "component5", "component6", "component7", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("buy")
    public static final class Buy extends MessageAction {
        private final long amount;
        private final String currency;
        private final String id;
        private final Map<String, Object> metadata;
        private final MessageActionBuyState state;
        private final String text;
        private final String uri;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {MessageActionType.INSTANCE.serializer(), null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0])), null, null, null, null, MessageActionBuyState.INSTANCE.serializer()};

        public final String getId() {
            return this.id;
        }

        public final Map<String, Object> component2() {
            return this.metadata;
        }

        public final String getText() {
            return this.text;
        }

        public final String getUri() {
            return this.uri;
        }

        public final long getAmount() {
            return this.amount;
        }

        public final String getCurrency() {
            return this.currency;
        }

        public final MessageActionBuyState getState() {
            return this.state;
        }

        public final Buy copy(String id, Map<String, ? extends Object> metadata, String text, String uri, long amount, String currency, MessageActionBuyState state) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(uri, "uri");
            Intrinsics.checkNotNullParameter(currency, "currency");
            Intrinsics.checkNotNullParameter(state, "state");
            return new Buy(id, metadata, text, uri, amount, currency, state);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Buy)) {
                return false;
            }
            Buy buy = (Buy) other;
            return Intrinsics.areEqual(this.id, buy.id) && Intrinsics.areEqual(this.metadata, buy.metadata) && Intrinsics.areEqual(this.text, buy.text) && Intrinsics.areEqual(this.uri, buy.uri) && this.amount == buy.amount && Intrinsics.areEqual(this.currency, buy.currency) && this.state == buy.state;
        }

        public int hashCode() {
            return (((((((((((this.id.hashCode() * 31) + this.metadata.hashCode()) * 31) + this.text.hashCode()) * 31) + this.uri.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m27m(this.amount)) * 31) + this.currency.hashCode()) * 31) + this.state.hashCode();
        }

        public String toString() {
            return "Buy(id=" + this.id + ", metadata=" + this.metadata + ", text=" + this.text + ", uri=" + this.uri + ", amount=" + this.amount + ", currency=" + this.currency + ", state=" + this.state + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageAction$Buy$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageAction$Buy;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Buy> serializer() {
                return MessageAction$Buy$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Buy(int i, MessageActionType messageActionType, String str, Map map, String str2, String str3, long j, String str4, MessageActionBuyState messageActionBuyState, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, messageActionType, serializationConstructorMarker);
            if (251 != (i & 251)) {
                PluginExceptionsKt.throwMissingFieldException(i, 251, MessageAction$Buy$$serializer.INSTANCE.getDescriptor());
            }
            this.id = str;
            if ((i & 4) == 0) {
                this.metadata = MapsKt.emptyMap();
            } else {
                this.metadata = map;
            }
            this.text = str2;
            this.uri = str3;
            this.amount = j;
            this.currency = str4;
            this.state = messageActionBuyState;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Buy self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageAction.write$Self(self, output, serialDesc);
            KSerializer<Object>[] kSerializerArr = $childSerializers;
            output.encodeStringElement(serialDesc, 1, self.getId());
            if (output.shouldEncodeElementDefault(serialDesc, 2) || !Intrinsics.areEqual(self.getMetadata(), MapsKt.emptyMap())) {
                output.encodeSerializableElement(serialDesc, 2, kSerializerArr[2], self.getMetadata());
            }
            output.encodeStringElement(serialDesc, 3, self.text);
            output.encodeStringElement(serialDesc, 4, self.uri);
            output.encodeLongElement(serialDesc, 5, self.amount);
            output.encodeStringElement(serialDesc, 6, self.currency);
            output.encodeSerializableElement(serialDesc, 7, kSerializerArr[7], self.state);
        }

        @Override
        public String getId() {
            return this.id;
        }

        public Buy(String str, Map map, String str2, String str3, long j, String str4, MessageActionBuyState messageActionBuyState, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? MapsKt.emptyMap() : map, str2, str3, j, str4, messageActionBuyState);
        }

        @Override
        public Map<String, Object> getMetadata() {
            return this.metadata;
        }

        public final String getText() {
            return this.text;
        }

        public final String getUri() {
            return this.uri;
        }

        public final long getAmount() {
            return this.amount;
        }

        public final String getCurrency() {
            return this.currency;
        }

        public final MessageActionBuyState getState() {
            return this.state;
        }

        public Buy(String id, Map<String, ? extends Object> metadata, String text, String uri, long j, String currency, MessageActionBuyState state) {
            super(MessageActionType.BUY, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(uri, "uri");
            Intrinsics.checkNotNullParameter(currency, "currency");
            Intrinsics.checkNotNullParameter(state, "state");
            this.id = id;
            this.metadata = metadata;
            this.text = text;
            this.uri = uri;
            this.amount = j;
            this.currency = currency;
            this.state = state;
        }
    }

    @Metadata(m17d1 = {"\u0000P\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010$\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0015\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 /2\u00020\u0001:\u0002./Bd\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\u0019\u0010\b\u001a\u0015\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b\u0018\u00010\t\u0012\b\u0010\f\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u0007\u0012\u0006\u0010\u000e\u001a\u00020\u000f\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011¢\u0006\u0002\u0010\u0012B@\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0019\b\u0002\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\t\u0012\u0006\u0010\f\u001a\u00020\u0007\u0012\u0006\u0010\r\u001a\u00020\u0007\u0012\u0006\u0010\u000e\u001a\u00020\u000f¢\u0006\u0002\u0010\u0013J\t\u0010\u001c\u001a\u00020\u0007HÆ\u0003J\u001a\u0010\u001d\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\tHÆ\u0003J\t\u0010\u001e\u001a\u00020\u0007HÆ\u0003J\t\u0010\u001f\u001a\u00020\u0007HÆ\u0003J\t\u0010 \u001a\u00020\u000fHÆ\u0003JL\u0010!\u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u00072\u0019\b\u0002\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\t2\b\b\u0002\u0010\f\u001a\u00020\u00072\b\b\u0002\u0010\r\u001a\u00020\u00072\b\b\u0002\u0010\u000e\u001a\u00020\u000fHÆ\u0001J\u0013\u0010\"\u001a\u00020\u000f2\b\u0010#\u001a\u0004\u0018\u00010\nHÖ\u0003J\t\u0010$\u001a\u00020\u0003HÖ\u0001J\t\u0010%\u001a\u00020\u0007HÖ\u0001J&\u0010&\u001a\u00020'2\u0006\u0010(\u001a\u00020\u00002\u0006\u0010)\u001a\u00020*2\u0006\u0010+\u001a\u00020,HÁ\u0001¢\u0006\u0002\b-R\u0011\u0010\u000e\u001a\u00020\u000f¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u0014\u0010\u0006\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017R%\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\tX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0019R\u0011\u0010\f\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0017R\u0011\u0010\r\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u001b\u0010\u0017¨\u00060"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageAction$Link;", "Lzendesk/conversationkit/android/model/MessageAction;", "seen1", "", "messageActionType", "Lzendesk/conversationkit/android/model/MessageActionType;", "id", "", "metadata", "", "", "Lkotlinx/serialization/Contextual;", "text", "uri", "default", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/MessageActionType;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;ZLkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Z)V", "getDefault", "()Z", "getId", "()Ljava/lang/String;", "getMetadata", "()Ljava/util/Map;", "getText", "getUri", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("link")
    public static final class Link extends MessageAction {
        private final boolean default;
        private final String id;
        private final Map<String, Object> metadata;
        private final String text;
        private final String uri;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {MessageActionType.INSTANCE.serializer(), null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0])), null, null, null};

        public static Link copy$default(Link link, String str, Map map, String str2, String str3, boolean z, int i, Object obj) {
            if ((i & 1) != 0) {
                str = link.id;
            }
            if ((i & 2) != 0) {
                map = link.metadata;
            }
            Map map2 = map;
            if ((i & 4) != 0) {
                str2 = link.text;
            }
            String str4 = str2;
            if ((i & 8) != 0) {
                str3 = link.uri;
            }
            String str5 = str3;
            if ((i & 16) != 0) {
                z = link.default;
            }
            return link.copy(str, map2, str4, str5, z);
        }

        public final String getId() {
            return this.id;
        }

        public final Map<String, Object> component2() {
            return this.metadata;
        }

        public final String getText() {
            return this.text;
        }

        public final String getUri() {
            return this.uri;
        }

        public final boolean getDefault() {
            return this.default;
        }

        public final Link copy(String id, Map<String, ? extends Object> metadata, String text, String uri, boolean z) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(uri, "uri");
            return new Link(id, metadata, text, uri, z);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Link)) {
                return false;
            }
            Link link = (Link) other;
            return Intrinsics.areEqual(this.id, link.id) && Intrinsics.areEqual(this.metadata, link.metadata) && Intrinsics.areEqual(this.text, link.text) && Intrinsics.areEqual(this.uri, link.uri) && this.default == link.default;
        }

        public int hashCode() {
            return (((((((this.id.hashCode() * 31) + this.metadata.hashCode()) * 31) + this.text.hashCode()) * 31) + this.uri.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.default);
        }

        public String toString() {
            return "Link(id=" + this.id + ", metadata=" + this.metadata + ", text=" + this.text + ", uri=" + this.uri + ", default=" + this.default + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageAction$Link$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageAction$Link;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Link> serializer() {
                return MessageAction$Link$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Link(int i, MessageActionType messageActionType, String str, Map map, String str2, String str3, boolean z, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, messageActionType, serializationConstructorMarker);
            if (59 != (i & 59)) {
                PluginExceptionsKt.throwMissingFieldException(i, 59, MessageAction$Link$$serializer.INSTANCE.getDescriptor());
            }
            this.id = str;
            if ((i & 4) == 0) {
                this.metadata = MapsKt.emptyMap();
            } else {
                this.metadata = map;
            }
            this.text = str2;
            this.uri = str3;
            this.default = z;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Link self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageAction.write$Self(self, output, serialDesc);
            KSerializer<Object>[] kSerializerArr = $childSerializers;
            output.encodeStringElement(serialDesc, 1, self.getId());
            if (output.shouldEncodeElementDefault(serialDesc, 2) || !Intrinsics.areEqual(self.getMetadata(), MapsKt.emptyMap())) {
                output.encodeSerializableElement(serialDesc, 2, kSerializerArr[2], self.getMetadata());
            }
            output.encodeStringElement(serialDesc, 3, self.text);
            output.encodeStringElement(serialDesc, 4, self.uri);
            output.encodeBooleanElement(serialDesc, 5, self.default);
        }

        @Override
        public String getId() {
            return this.id;
        }

        public Link(String str, Map map, String str2, String str3, boolean z, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? MapsKt.emptyMap() : map, str2, str3, z);
        }

        @Override
        public Map<String, Object> getMetadata() {
            return this.metadata;
        }

        public final String getText() {
            return this.text;
        }

        public final String getUri() {
            return this.uri;
        }

        public final boolean getDefault() {
            return this.default;
        }

        public Link(String id, Map<String, ? extends Object> metadata, String text, String uri, boolean z) {
            super(MessageActionType.LINK, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(uri, "uri");
            this.id = id;
            this.metadata = metadata;
            this.text = text;
            this.uri = uri;
            this.default = z;
        }
    }

    @Metadata(m17d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010$\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\f\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 (2\u00020\u0001:\u0002'(BR\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\u0019\u0010\b\u001a\u0015\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b\u0018\u00010\t\u0012\b\u0010\f\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u000e¢\u0006\u0002\u0010\u000fB0\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0019\b\u0002\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\t\u0012\u0006\u0010\f\u001a\u00020\u0007¢\u0006\u0002\u0010\u0010J\t\u0010\u0016\u001a\u00020\u0007HÆ\u0003J\u001a\u0010\u0017\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\tHÆ\u0003J\t\u0010\u0018\u001a\u00020\u0007HÆ\u0003J8\u0010\u0019\u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u00072\u0019\b\u0002\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\t2\b\b\u0002\u0010\f\u001a\u00020\u0007HÆ\u0001J\u0013\u0010\u001a\u001a\u00020\u001b2\b\u0010\u001c\u001a\u0004\u0018\u00010\nHÖ\u0003J\t\u0010\u001d\u001a\u00020\u0003HÖ\u0001J\t\u0010\u001e\u001a\u00020\u0007HÖ\u0001J&\u0010\u001f\u001a\u00020 2\u0006\u0010!\u001a\u00020\u00002\u0006\u0010\"\u001a\u00020#2\u0006\u0010$\u001a\u00020%HÁ\u0001¢\u0006\u0002\b&R\u0014\u0010\u0006\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0011\u0010\u0012R%\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\tX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0011\u0010\f\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0012¨\u0006)"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageAction$LocationRequest;", "Lzendesk/conversationkit/android/model/MessageAction;", "seen1", "", "messageActionType", "Lzendesk/conversationkit/android/model/MessageActionType;", "id", "", "metadata", "", "", "Lkotlinx/serialization/Contextual;", "text", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/MessageActionType;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;)V", "getId", "()Ljava/lang/String;", "getMetadata", "()Ljava/util/Map;", "getText", "component1", "component2", "component3", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("locationRequest")
    public static final class LocationRequest extends MessageAction {
        private final String id;
        private final Map<String, Object> metadata;
        private final String text;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {MessageActionType.INSTANCE.serializer(), null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0])), null};

        public static LocationRequest copy$default(LocationRequest locationRequest, String str, Map map, String str2, int i, Object obj) {
            if ((i & 1) != 0) {
                str = locationRequest.id;
            }
            if ((i & 2) != 0) {
                map = locationRequest.metadata;
            }
            if ((i & 4) != 0) {
                str2 = locationRequest.text;
            }
            return locationRequest.copy(str, map, str2);
        }

        public final String getId() {
            return this.id;
        }

        public final Map<String, Object> component2() {
            return this.metadata;
        }

        public final String getText() {
            return this.text;
        }

        public final LocationRequest copy(String id, Map<String, ? extends Object> metadata, String text) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            Intrinsics.checkNotNullParameter(text, "text");
            return new LocationRequest(id, metadata, text);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof LocationRequest)) {
                return false;
            }
            LocationRequest locationRequest = (LocationRequest) other;
            return Intrinsics.areEqual(this.id, locationRequest.id) && Intrinsics.areEqual(this.metadata, locationRequest.metadata) && Intrinsics.areEqual(this.text, locationRequest.text);
        }

        public int hashCode() {
            return (((this.id.hashCode() * 31) + this.metadata.hashCode()) * 31) + this.text.hashCode();
        }

        public String toString() {
            return "LocationRequest(id=" + this.id + ", metadata=" + this.metadata + ", text=" + this.text + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageAction$LocationRequest$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageAction$LocationRequest;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<LocationRequest> serializer() {
                return MessageAction$LocationRequest$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public LocationRequest(int i, MessageActionType messageActionType, String str, Map map, String str2, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, messageActionType, serializationConstructorMarker);
            if (11 != (i & 11)) {
                PluginExceptionsKt.throwMissingFieldException(i, 11, MessageAction$LocationRequest$$serializer.INSTANCE.getDescriptor());
            }
            this.id = str;
            if ((i & 4) == 0) {
                this.metadata = MapsKt.emptyMap();
            } else {
                this.metadata = map;
            }
            this.text = str2;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(LocationRequest self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageAction.write$Self(self, output, serialDesc);
            KSerializer<Object>[] kSerializerArr = $childSerializers;
            output.encodeStringElement(serialDesc, 1, self.getId());
            if (output.shouldEncodeElementDefault(serialDesc, 2) || !Intrinsics.areEqual(self.getMetadata(), MapsKt.emptyMap())) {
                output.encodeSerializableElement(serialDesc, 2, kSerializerArr[2], self.getMetadata());
            }
            output.encodeStringElement(serialDesc, 3, self.text);
        }

        @Override
        public String getId() {
            return this.id;
        }

        public LocationRequest(String str, Map map, String str2, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? MapsKt.emptyMap() : map, str2);
        }

        @Override
        public Map<String, Object> getMetadata() {
            return this.metadata;
        }

        public final String getText() {
            return this.text;
        }

        public LocationRequest(String id, Map<String, ? extends Object> metadata, String text) {
            super(MessageActionType.LOCATION_REQUEST, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            Intrinsics.checkNotNullParameter(text, "text");
            this.id = id;
            this.metadata = metadata;
            this.text = text;
        }
    }

    @Metadata(m17d1 = {"\u0000P\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010$\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\n\u0002\u0010\u000b\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0014\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 .2\u00020\u0001:\u0002-.Bd\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\u0019\u0010\b\u001a\u0015\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b\u0018\u00010\t\u0012\b\u0010\f\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u0007\u0012\u0006\u0010\u000e\u001a\u00020\u000f\u0012\b\u0010\u0010\u001a\u0004\u0018\u00010\u0011¢\u0006\u0002\u0010\u0012B@\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0019\b\u0002\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\t\u0012\u0006\u0010\f\u001a\u00020\u0007\u0012\u0006\u0010\r\u001a\u00020\u0007\u0012\u0006\u0010\u000e\u001a\u00020\u000f¢\u0006\u0002\u0010\u0013J\t\u0010\u001b\u001a\u00020\u0007HÆ\u0003J\u001a\u0010\u001c\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\tHÆ\u0003J\t\u0010\u001d\u001a\u00020\u0007HÆ\u0003J\t\u0010\u001e\u001a\u00020\u0007HÆ\u0003J\t\u0010\u001f\u001a\u00020\u000fHÆ\u0003JL\u0010 \u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u00072\u0019\b\u0002\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\t2\b\b\u0002\u0010\f\u001a\u00020\u00072\b\b\u0002\u0010\r\u001a\u00020\u00072\b\b\u0002\u0010\u000e\u001a\u00020\u000fHÆ\u0001J\u0013\u0010!\u001a\u00020\u000f2\b\u0010\"\u001a\u0004\u0018\u00010\nHÖ\u0003J\t\u0010#\u001a\u00020\u0003HÖ\u0001J\t\u0010$\u001a\u00020\u0007HÖ\u0001J&\u0010%\u001a\u00020&2\u0006\u0010'\u001a\u00020\u00002\u0006\u0010(\u001a\u00020)2\u0006\u0010*\u001a\u00020+HÁ\u0001¢\u0006\u0002\b,R\u0014\u0010\u0006\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0014\u0010\u0015R\u0011\u0010\u000e\u001a\u00020\u000f¢\u0006\b\n\u0000\u001a\u0004\b\u000e\u0010\u0016R%\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\tX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0017\u0010\u0018R\u0011\u0010\r\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0015R\u0011\u0010\f\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u0015¨\u0006/"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageAction$Postback;", "Lzendesk/conversationkit/android/model/MessageAction;", "seen1", "", "messageActionType", "Lzendesk/conversationkit/android/model/MessageActionType;", "id", "", "metadata", "", "", "Lkotlinx/serialization/Contextual;", "text", "payload", "isLoading", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/MessageActionType;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;ZLkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Z)V", "getId", "()Ljava/lang/String;", "()Z", "getMetadata", "()Ljava/util/Map;", "getPayload", "getText", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("postback")
    public static final class Postback extends MessageAction {
        private final String id;
        private final boolean isLoading;
        private final Map<String, Object> metadata;
        private final String payload;
        private final String text;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {MessageActionType.INSTANCE.serializer(), null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0])), null, null, null};

        public static Postback copy$default(Postback postback, String str, Map map, String str2, String str3, boolean z, int i, Object obj) {
            if ((i & 1) != 0) {
                str = postback.id;
            }
            if ((i & 2) != 0) {
                map = postback.metadata;
            }
            Map map2 = map;
            if ((i & 4) != 0) {
                str2 = postback.text;
            }
            String str4 = str2;
            if ((i & 8) != 0) {
                str3 = postback.payload;
            }
            String str5 = str3;
            if ((i & 16) != 0) {
                z = postback.isLoading;
            }
            return postback.copy(str, map2, str4, str5, z);
        }

        public final String getId() {
            return this.id;
        }

        public final Map<String, Object> component2() {
            return this.metadata;
        }

        public final String getText() {
            return this.text;
        }

        public final String getPayload() {
            return this.payload;
        }

        public final boolean getIsLoading() {
            return this.isLoading;
        }

        public final Postback copy(String id, Map<String, ? extends Object> metadata, String text, String payload, boolean isLoading) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(payload, "payload");
            return new Postback(id, metadata, text, payload, isLoading);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Postback)) {
                return false;
            }
            Postback postback = (Postback) other;
            return Intrinsics.areEqual(this.id, postback.id) && Intrinsics.areEqual(this.metadata, postback.metadata) && Intrinsics.areEqual(this.text, postback.text) && Intrinsics.areEqual(this.payload, postback.payload) && this.isLoading == postback.isLoading;
        }

        public int hashCode() {
            return (((((((this.id.hashCode() * 31) + this.metadata.hashCode()) * 31) + this.text.hashCode()) * 31) + this.payload.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.isLoading);
        }

        public String toString() {
            return "Postback(id=" + this.id + ", metadata=" + this.metadata + ", text=" + this.text + ", payload=" + this.payload + ", isLoading=" + this.isLoading + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageAction$Postback$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageAction$Postback;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Postback> serializer() {
                return MessageAction$Postback$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Postback(int i, MessageActionType messageActionType, String str, Map map, String str2, String str3, boolean z, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, messageActionType, serializationConstructorMarker);
            if (59 != (i & 59)) {
                PluginExceptionsKt.throwMissingFieldException(i, 59, MessageAction$Postback$$serializer.INSTANCE.getDescriptor());
            }
            this.id = str;
            if ((i & 4) == 0) {
                this.metadata = MapsKt.emptyMap();
            } else {
                this.metadata = map;
            }
            this.text = str2;
            this.payload = str3;
            this.isLoading = z;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Postback self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageAction.write$Self(self, output, serialDesc);
            KSerializer<Object>[] kSerializerArr = $childSerializers;
            output.encodeStringElement(serialDesc, 1, self.getId());
            if (output.shouldEncodeElementDefault(serialDesc, 2) || !Intrinsics.areEqual(self.getMetadata(), MapsKt.emptyMap())) {
                output.encodeSerializableElement(serialDesc, 2, kSerializerArr[2], self.getMetadata());
            }
            output.encodeStringElement(serialDesc, 3, self.text);
            output.encodeStringElement(serialDesc, 4, self.payload);
            output.encodeBooleanElement(serialDesc, 5, self.isLoading);
        }

        @Override
        public String getId() {
            return this.id;
        }

        public Postback(String str, Map map, String str2, String str3, boolean z, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? MapsKt.emptyMap() : map, str2, str3, z);
        }

        @Override
        public Map<String, Object> getMetadata() {
            return this.metadata;
        }

        public final String getText() {
            return this.text;
        }

        public final String getPayload() {
            return this.payload;
        }

        public final boolean isLoading() {
            return this.isLoading;
        }

        public Postback(String id, Map<String, ? extends Object> metadata, String text, String payload, boolean z) {
            super(MessageActionType.POSTBACK, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(payload, "payload");
            this.id = id;
            this.metadata = metadata;
            this.text = text;
            this.payload = payload;
            this.isLoading = z;
        }
    }

    @Metadata(m17d1 = {"\u0000R\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010$\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0002\b\u0010\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 .2\u00020\u0001:\u0002-.Bf\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\u0019\u0010\b\u001a\u0015\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b\u0018\u00010\t\u0012\b\u0010\f\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\u000f\u001a\u0004\u0018\u00010\u0010¢\u0006\u0002\u0010\u0011BB\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0019\b\u0002\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\t\u0012\u0006\u0010\f\u001a\u00020\u0007\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u0007\u0012\u0006\u0010\u000e\u001a\u00020\u0007¢\u0006\u0002\u0010\u0012J\t\u0010\u001a\u001a\u00020\u0007HÆ\u0003J\u001a\u0010\u001b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\tHÆ\u0003J\t\u0010\u001c\u001a\u00020\u0007HÆ\u0003J\u000b\u0010\u001d\u001a\u0004\u0018\u00010\u0007HÆ\u0003J\t\u0010\u001e\u001a\u00020\u0007HÆ\u0003JN\u0010\u001f\u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u00072\u0019\b\u0002\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\t2\b\b\u0002\u0010\f\u001a\u00020\u00072\n\b\u0002\u0010\r\u001a\u0004\u0018\u00010\u00072\b\b\u0002\u0010\u000e\u001a\u00020\u0007HÆ\u0001J\u0013\u0010 \u001a\u00020!2\b\u0010\"\u001a\u0004\u0018\u00010\nHÖ\u0003J\t\u0010#\u001a\u00020\u0003HÖ\u0001J\t\u0010$\u001a\u00020\u0007HÖ\u0001J&\u0010%\u001a\u00020&2\u0006\u0010'\u001a\u00020\u00002\u0006\u0010(\u001a\u00020)2\u0006\u0010*\u001a\u00020+HÁ\u0001¢\u0006\u0002\b,R\u0013\u0010\r\u001a\u0004\u0018\u00010\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0013\u0010\u0014R\u0014\u0010\u0006\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0015\u0010\u0014R%\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\tX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0016\u0010\u0017R\u0011\u0010\u000e\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0014R\u0011\u0010\f\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u0019\u0010\u0014¨\u0006/"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageAction$Reply;", "Lzendesk/conversationkit/android/model/MessageAction;", "seen1", "", "messageActionType", "Lzendesk/conversationkit/android/model/MessageActionType;", "id", "", "metadata", "", "", "Lkotlinx/serialization/Contextual;", "text", "iconUrl", "payload", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/MessageActionType;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;)V", "getIconUrl", "()Ljava/lang/String;", "getId", "getMetadata", "()Ljava/util/Map;", "getPayload", "getText", "component1", "component2", "component3", "component4", "component5", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("reply")
    public static final class Reply extends MessageAction {
        private final String iconUrl;
        private final String id;
        private final Map<String, Object> metadata;
        private final String payload;
        private final String text;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {MessageActionType.INSTANCE.serializer(), null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0])), null, null, null};

        public static Reply copy$default(Reply reply, String str, Map map, String str2, String str3, String str4, int i, Object obj) {
            if ((i & 1) != 0) {
                str = reply.id;
            }
            if ((i & 2) != 0) {
                map = reply.metadata;
            }
            Map map2 = map;
            if ((i & 4) != 0) {
                str2 = reply.text;
            }
            String str5 = str2;
            if ((i & 8) != 0) {
                str3 = reply.iconUrl;
            }
            String str6 = str3;
            if ((i & 16) != 0) {
                str4 = reply.payload;
            }
            return reply.copy(str, map2, str5, str6, str4);
        }

        public final String getId() {
            return this.id;
        }

        public final Map<String, Object> component2() {
            return this.metadata;
        }

        public final String getText() {
            return this.text;
        }

        public final String getIconUrl() {
            return this.iconUrl;
        }

        public final String getPayload() {
            return this.payload;
        }

        public final Reply copy(String id, Map<String, ? extends Object> metadata, String text, String iconUrl, String payload) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(payload, "payload");
            return new Reply(id, metadata, text, iconUrl, payload);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Reply)) {
                return false;
            }
            Reply reply = (Reply) other;
            return Intrinsics.areEqual(this.id, reply.id) && Intrinsics.areEqual(this.metadata, reply.metadata) && Intrinsics.areEqual(this.text, reply.text) && Intrinsics.areEqual(this.iconUrl, reply.iconUrl) && Intrinsics.areEqual(this.payload, reply.payload);
        }

        public int hashCode() {
            int iHashCode = ((((this.id.hashCode() * 31) + this.metadata.hashCode()) * 31) + this.text.hashCode()) * 31;
            String str = this.iconUrl;
            return ((iHashCode + (str == null ? 0 : str.hashCode())) * 31) + this.payload.hashCode();
        }

        public String toString() {
            return "Reply(id=" + this.id + ", metadata=" + this.metadata + ", text=" + this.text + ", iconUrl=" + this.iconUrl + ", payload=" + this.payload + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageAction$Reply$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageAction$Reply;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Reply> serializer() {
                return MessageAction$Reply$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Reply(int i, MessageActionType messageActionType, String str, Map map, String str2, String str3, String str4, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, messageActionType, serializationConstructorMarker);
            if (59 != (i & 59)) {
                PluginExceptionsKt.throwMissingFieldException(i, 59, MessageAction$Reply$$serializer.INSTANCE.getDescriptor());
            }
            this.id = str;
            if ((i & 4) == 0) {
                this.metadata = MapsKt.emptyMap();
            } else {
                this.metadata = map;
            }
            this.text = str2;
            this.iconUrl = str3;
            this.payload = str4;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Reply self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageAction.write$Self(self, output, serialDesc);
            KSerializer<Object>[] kSerializerArr = $childSerializers;
            output.encodeStringElement(serialDesc, 1, self.getId());
            if (output.shouldEncodeElementDefault(serialDesc, 2) || !Intrinsics.areEqual(self.getMetadata(), MapsKt.emptyMap())) {
                output.encodeSerializableElement(serialDesc, 2, kSerializerArr[2], self.getMetadata());
            }
            output.encodeStringElement(serialDesc, 3, self.text);
            output.encodeNullableSerializableElement(serialDesc, 4, StringSerializer.INSTANCE, self.iconUrl);
            output.encodeStringElement(serialDesc, 5, self.payload);
        }

        @Override
        public String getId() {
            return this.id;
        }

        public Reply(String str, Map map, String str2, String str3, String str4, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? MapsKt.emptyMap() : map, str2, str3, str4);
        }

        @Override
        public Map<String, Object> getMetadata() {
            return this.metadata;
        }

        public final String getText() {
            return this.text;
        }

        public final String getIconUrl() {
            return this.iconUrl;
        }

        public final String getPayload() {
            return this.payload;
        }

        public Reply(String id, Map<String, ? extends Object> metadata, String text, String str, String payload) {
            super(MessageActionType.REPLY, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(payload, "payload");
            this.id = id;
            this.metadata = metadata;
            this.text = text;
            this.iconUrl = str;
            this.payload = payload;
        }
    }

    @Metadata(m17d1 = {"\u0000P\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010$\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\n\n\u0002\u0010\u000b\n\u0002\b\u0004\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 %2\u00020\u0001:\u0002$%BH\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\u0019\u0010\b\u001a\u0015\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b\u0018\u00010\t\u0012\b\u0010\f\u001a\u0004\u0018\u00010\r¢\u0006\u0002\u0010\u000eB(\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0019\b\u0002\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\t¢\u0006\u0002\u0010\u000fJ\t\u0010\u0014\u001a\u00020\u0007HÆ\u0003J\u001a\u0010\u0015\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\tHÆ\u0003J.\u0010\u0016\u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u00072\u0019\b\u0002\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\tHÆ\u0001J\u0013\u0010\u0017\u001a\u00020\u00182\b\u0010\u0019\u001a\u0004\u0018\u00010\nHÖ\u0003J\t\u0010\u001a\u001a\u00020\u0003HÖ\u0001J\t\u0010\u001b\u001a\u00020\u0007HÖ\u0001J&\u0010\u001c\u001a\u00020\u001d2\u0006\u0010\u001e\u001a\u00020\u00002\u0006\u0010\u001f\u001a\u00020 2\u0006\u0010!\u001a\u00020\"HÁ\u0001¢\u0006\u0002\b#R\u0014\u0010\u0006\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0010\u0010\u0011R%\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\tX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u0012\u0010\u0013¨\u0006&"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageAction$Share;", "Lzendesk/conversationkit/android/model/MessageAction;", "seen1", "", "messageActionType", "Lzendesk/conversationkit/android/model/MessageActionType;", "id", "", "metadata", "", "", "Lkotlinx/serialization/Contextual;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/MessageActionType;Ljava/lang/String;Ljava/util/Map;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/util/Map;)V", "getId", "()Ljava/lang/String;", "getMetadata", "()Ljava/util/Map;", "component1", "component2", "copy", "equals", "", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("share")
    public static final class Share extends MessageAction {
        private final String id;
        private final Map<String, Object> metadata;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {MessageActionType.INSTANCE.serializer(), null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0]))};

        public static Share copy$default(Share share, String str, Map map, int i, Object obj) {
            if ((i & 1) != 0) {
                str = share.id;
            }
            if ((i & 2) != 0) {
                map = share.metadata;
            }
            return share.copy(str, map);
        }

        public final String getId() {
            return this.id;
        }

        public final Map<String, Object> component2() {
            return this.metadata;
        }

        public final Share copy(String id, Map<String, ? extends Object> metadata) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            return new Share(id, metadata);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof Share)) {
                return false;
            }
            Share share = (Share) other;
            return Intrinsics.areEqual(this.id, share.id) && Intrinsics.areEqual(this.metadata, share.metadata);
        }

        public int hashCode() {
            return (this.id.hashCode() * 31) + this.metadata.hashCode();
        }

        public String toString() {
            return "Share(id=" + this.id + ", metadata=" + this.metadata + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageAction$Share$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageAction$Share;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Share> serializer() {
                return MessageAction$Share$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Share(int i, MessageActionType messageActionType, String str, Map map, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, messageActionType, serializationConstructorMarker);
            if (3 != (i & 3)) {
                PluginExceptionsKt.throwMissingFieldException(i, 3, MessageAction$Share$$serializer.INSTANCE.getDescriptor());
            }
            this.id = str;
            if ((i & 4) == 0) {
                this.metadata = MapsKt.emptyMap();
            } else {
                this.metadata = map;
            }
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Share self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageAction.write$Self(self, output, serialDesc);
            KSerializer<Object>[] kSerializerArr = $childSerializers;
            output.encodeStringElement(serialDesc, 1, self.getId());
            if (!output.shouldEncodeElementDefault(serialDesc, 2) && Intrinsics.areEqual(self.getMetadata(), MapsKt.emptyMap())) {
                return;
            }
            output.encodeSerializableElement(serialDesc, 2, kSerializerArr[2], self.getMetadata());
        }

        @Override
        public String getId() {
            return this.id;
        }

        public Share(String str, Map map, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? MapsKt.emptyMap() : map);
        }

        @Override
        public Map<String, Object> getMetadata() {
            return this.metadata;
        }

        public Share(String id, Map<String, ? extends Object> metadata) {
            super(MessageActionType.SHARE, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            this.id = id;
            this.metadata = metadata;
        }
    }

    @Metadata(m17d1 = {"\u0000X\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010$\n\u0002\u0010\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000b\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u001c\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0087\b\u0018\u0000 :2\u00020\u0001:\u00029:B\u0080\u0001\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\b\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\u0019\u0010\b\u001a\u0015\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b\u0018\u00010\t\u0012\b\u0010\f\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\r\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\u000e\u001a\u0004\u0018\u00010\u0007\u0012\u0006\u0010\u000f\u001a\u00020\u0010\u0012\u0006\u0010\u0011\u001a\u00020\u0010\u0012\b\u0010\u0012\u001a\u0004\u0018\u00010\u0013\u0012\b\u0010\u0014\u001a\u0004\u0018\u00010\u0015¢\u0006\u0002\u0010\u0016BX\u0012\u0006\u0010\u0006\u001a\u00020\u0007\u0012\u0019\b\u0002\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\t\u0012\u0006\u0010\f\u001a\u00020\u0007\u0012\u0006\u0010\r\u001a\u00020\u0007\u0012\u0006\u0010\u000e\u001a\u00020\u0007\u0012\u0006\u0010\u000f\u001a\u00020\u0010\u0012\u0006\u0010\u0011\u001a\u00020\u0010\u0012\u0006\u0010\u0012\u001a\u00020\u0013¢\u0006\u0002\u0010\u0017J\t\u0010$\u001a\u00020\u0007HÆ\u0003J\u001a\u0010%\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\tHÆ\u0003J\t\u0010&\u001a\u00020\u0007HÆ\u0003J\t\u0010'\u001a\u00020\u0007HÆ\u0003J\t\u0010(\u001a\u00020\u0007HÆ\u0003J\t\u0010)\u001a\u00020\u0010HÆ\u0003J\t\u0010*\u001a\u00020\u0010HÆ\u0003J\t\u0010+\u001a\u00020\u0013HÆ\u0003Jj\u0010,\u001a\u00020\u00002\b\b\u0002\u0010\u0006\u001a\u00020\u00072\u0019\b\u0002\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\t2\b\b\u0002\u0010\f\u001a\u00020\u00072\b\b\u0002\u0010\r\u001a\u00020\u00072\b\b\u0002\u0010\u000e\u001a\u00020\u00072\b\b\u0002\u0010\u000f\u001a\u00020\u00102\b\b\u0002\u0010\u0011\u001a\u00020\u00102\b\b\u0002\u0010\u0012\u001a\u00020\u0013HÆ\u0001J\u0013\u0010-\u001a\u00020\u00102\b\u0010.\u001a\u0004\u0018\u00010\nHÖ\u0003J\t\u0010/\u001a\u00020\u0003HÖ\u0001J\t\u00100\u001a\u00020\u0007HÖ\u0001J&\u00101\u001a\u0002022\u0006\u00103\u001a\u00020\u00002\u0006\u00104\u001a\u0002052\u0006\u00106\u001a\u000207HÁ\u0001¢\u0006\u0002\b8R\u0011\u0010\u000f\u001a\u00020\u0010¢\u0006\b\n\u0000\u001a\u0004\b\u0018\u0010\u0019R\u0011\u0010\u000e\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\u001a\u0010\u001bR\u0014\u0010\u0006\u001a\u00020\u0007X\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001c\u0010\u001bR%\u0010\b\u001a\u0013\u0012\u0004\u0012\u00020\u0007\u0012\t\u0012\u00070\n¢\u0006\u0002\b\u000b0\tX\u0096\u0004¢\u0006\b\n\u0000\u001a\u0004\b\u001d\u0010\u001eR\u0011\u0010\u0011\u001a\u00020\u0010¢\u0006\b\n\u0000\u001a\u0004\b\u001f\u0010\u0019R\u0011\u0010\u0012\u001a\u00020\u0013¢\u0006\b\n\u0000\u001a\u0004\b \u0010!R\u0011\u0010\f\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b\"\u0010\u001bR\u0011\u0010\r\u001a\u00020\u0007¢\u0006\b\n\u0000\u001a\u0004\b#\u0010\u001b¨\u0006;"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageAction$WebView;", "Lzendesk/conversationkit/android/model/MessageAction;", "seen1", "", "messageActionType", "Lzendesk/conversationkit/android/model/MessageActionType;", "id", "", "metadata", "", "", "Lkotlinx/serialization/Contextual;", "text", "uri", "fallback", "default", "", "openOnReceive", "size", "Lzendesk/conversationkit/android/model/MessageActionSize;", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILzendesk/conversationkit/android/model/MessageActionType;Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZLzendesk/conversationkit/android/model/MessageActionSize;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/util/Map;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;ZZLzendesk/conversationkit/android/model/MessageActionSize;)V", "getDefault", "()Z", "getFallback", "()Ljava/lang/String;", "getId", "getMetadata", "()Ljava/util/Map;", "getOpenOnReceive", "getSize", "()Lzendesk/conversationkit/android/model/MessageActionSize;", "getText", "getUri", "component1", "component2", "component3", "component4", "component5", "component6", "component7", "component8", "copy", "equals", "other", "hashCode", "toString", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    @SerialName("webview")
    public static final class WebView extends MessageAction {
        private final boolean default;
        private final String fallback;
        private final String id;
        private final Map<String, Object> metadata;
        private final boolean openOnReceive;
        private final MessageActionSize size;
        private final String text;
        private final String uri;

        public static final Companion INSTANCE = new Companion(null);
        private static final KSerializer<Object>[] $childSerializers = {MessageActionType.INSTANCE.serializer(), null, new LinkedHashMapSerializer(StringSerializer.INSTANCE, new ContextualSerializer(Reflection.getOrCreateKotlinClass(Object.class), null, new KSerializer[0])), null, null, null, null, null, MessageActionSize.INSTANCE.serializer()};

        public final String getId() {
            return this.id;
        }

        public final Map<String, Object> component2() {
            return this.metadata;
        }

        public final String getText() {
            return this.text;
        }

        public final String getUri() {
            return this.uri;
        }

        public final String getFallback() {
            return this.fallback;
        }

        public final boolean getDefault() {
            return this.default;
        }

        public final boolean getOpenOnReceive() {
            return this.openOnReceive;
        }

        public final MessageActionSize getSize() {
            return this.size;
        }

        public final WebView copy(String id, Map<String, ? extends Object> metadata, String text, String uri, String fallback, boolean z, boolean openOnReceive, MessageActionSize size) {
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(uri, "uri");
            Intrinsics.checkNotNullParameter(fallback, "fallback");
            Intrinsics.checkNotNullParameter(size, "size");
            return new WebView(id, metadata, text, uri, fallback, z, openOnReceive, size);
        }

        public boolean equals(Object other) {
            if (this == other) {
                return true;
            }
            if (!(other instanceof WebView)) {
                return false;
            }
            WebView webView = (WebView) other;
            return Intrinsics.areEqual(this.id, webView.id) && Intrinsics.areEqual(this.metadata, webView.metadata) && Intrinsics.areEqual(this.text, webView.text) && Intrinsics.areEqual(this.uri, webView.uri) && Intrinsics.areEqual(this.fallback, webView.fallback) && this.default == webView.default && this.openOnReceive == webView.openOnReceive && this.size == webView.size;
        }

        public int hashCode() {
            return (((((((((((((this.id.hashCode() * 31) + this.metadata.hashCode()) * 31) + this.text.hashCode()) * 31) + this.uri.hashCode()) * 31) + this.fallback.hashCode()) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.default)) * 31) + UByte$$ExternalSyntheticBackport0.m30m(this.openOnReceive)) * 31) + this.size.hashCode();
        }

        public String toString() {
            return "WebView(id=" + this.id + ", metadata=" + this.metadata + ", text=" + this.text + ", uri=" + this.uri + ", fallback=" + this.fallback + ", default=" + this.default + ", openOnReceive=" + this.openOnReceive + ", size=" + this.size + ')';
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/model/MessageAction$WebView$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/model/MessageAction$WebView;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<WebView> serializer() {
                return MessageAction$WebView$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public WebView(int i, MessageActionType messageActionType, String str, Map map, String str2, String str3, String str4, boolean z, boolean z2, MessageActionSize messageActionSize, SerializationConstructorMarker serializationConstructorMarker) {
            super(i, messageActionType, serializationConstructorMarker);
            if (507 != (i & HttpStatus.SC_INSUFFICIENT_STORAGE)) {
                PluginExceptionsKt.throwMissingFieldException(i, HttpStatus.SC_INSUFFICIENT_STORAGE, MessageAction$WebView$$serializer.INSTANCE.getDescriptor());
            }
            this.id = str;
            if ((i & 4) == 0) {
                this.metadata = MapsKt.emptyMap();
            } else {
                this.metadata = map;
            }
            this.text = str2;
            this.uri = str3;
            this.fallback = str4;
            this.default = z;
            this.openOnReceive = z2;
            this.size = messageActionSize;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(WebView self, CompositeEncoder output, SerialDescriptor serialDesc) {
            MessageAction.write$Self(self, output, serialDesc);
            KSerializer<Object>[] kSerializerArr = $childSerializers;
            output.encodeStringElement(serialDesc, 1, self.getId());
            if (output.shouldEncodeElementDefault(serialDesc, 2) || !Intrinsics.areEqual(self.getMetadata(), MapsKt.emptyMap())) {
                output.encodeSerializableElement(serialDesc, 2, kSerializerArr[2], self.getMetadata());
            }
            output.encodeStringElement(serialDesc, 3, self.text);
            output.encodeStringElement(serialDesc, 4, self.uri);
            output.encodeStringElement(serialDesc, 5, self.fallback);
            output.encodeBooleanElement(serialDesc, 6, self.default);
            output.encodeBooleanElement(serialDesc, 7, self.openOnReceive);
            output.encodeSerializableElement(serialDesc, 8, kSerializerArr[8], self.size);
        }

        @Override
        public String getId() {
            return this.id;
        }

        public WebView(String str, Map map, String str2, String str3, String str4, boolean z, boolean z2, MessageActionSize messageActionSize, int i, DefaultConstructorMarker defaultConstructorMarker) {
            this(str, (i & 2) != 0 ? MapsKt.emptyMap() : map, str2, str3, str4, z, z2, messageActionSize);
        }

        @Override
        public Map<String, Object> getMetadata() {
            return this.metadata;
        }

        public final String getText() {
            return this.text;
        }

        public final String getUri() {
            return this.uri;
        }

        public final String getFallback() {
            return this.fallback;
        }

        public final boolean getDefault() {
            return this.default;
        }

        public final boolean getOpenOnReceive() {
            return this.openOnReceive;
        }

        public final MessageActionSize getSize() {
            return this.size;
        }

        public WebView(String id, Map<String, ? extends Object> metadata, String text, String uri, String fallback, boolean z, boolean z2, MessageActionSize size) {
            super(MessageActionType.WEBVIEW, null);
            Intrinsics.checkNotNullParameter(id, "id");
            Intrinsics.checkNotNullParameter(metadata, "metadata");
            Intrinsics.checkNotNullParameter(text, "text");
            Intrinsics.checkNotNullParameter(uri, "uri");
            Intrinsics.checkNotNullParameter(fallback, "fallback");
            Intrinsics.checkNotNullParameter(size, "size");
            this.id = id;
            this.metadata = metadata;
            this.text = text;
            this.uri = uri;
            this.fallback = fallback;
            this.default = z;
            this.openOnReceive = z2;
            this.size = size;
        }
    }
}
