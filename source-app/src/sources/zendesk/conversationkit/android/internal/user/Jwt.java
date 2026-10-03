package zendesk.conversationkit.android.internal.user;

import kotlin.Deprecated;
import kotlin.DeprecationLevel;
import kotlin.Metadata;
import kotlin.ReplaceWith;
import kotlin.Unit;
import kotlin.jvm.JvmStatic;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.DefaultConstructorMarker;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.Charsets;
import kotlin.text.StringsKt;
import kotlinx.serialization.KSerializer;
import kotlinx.serialization.SerialName;
import kotlinx.serialization.Serializable;
import kotlinx.serialization.descriptors.SerialDescriptor;
import kotlinx.serialization.encoding.CompositeEncoder;
import kotlinx.serialization.internal.LongSerializer;
import kotlinx.serialization.internal.PluginExceptionsKt;
import kotlinx.serialization.internal.SerializationConstructorMarker;
import kotlinx.serialization.json.Json;
import kotlinx.serialization.json.JsonBuilder;
import kotlinx.serialization.json.JsonKt;
import okio.ByteString;
import zendesk.conversationkit.android.ConversationKitResult;

@Metadata(m17d1 = {"\u0000\"\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0010\t\n\u0002\b\u0003\n\u0002\u0010\u000e\n\u0002\b\u0004\n\u0002\u0018\u0002\n\u0000\b0\u0018\u00002\u00020\u0001:\u0002\u000b\fB\u0007\b\u0004¢\u0006\u0002\u0010\u0002R\u0014\u0010\u0003\u001a\u0004\u0018\u00010\u0004X¦\u0004¢\u0006\u0006\u001a\u0004\b\u0005\u0010\u0006R\u0012\u0010\u0007\u001a\u00020\bX¦\u0004¢\u0006\u0006\u001a\u0004\b\t\u0010\n\u0082\u0001\u0001\r¨\u0006\u000e"}, m18d2 = {"Lzendesk/conversationkit/android/internal/user/Jwt;", "", "()V", "exp", "", "getExp", "()Ljava/lang/Long;", "externalId", "", "getExternalId", "()Ljava/lang/String;", "Decoder", "Unified", "Lzendesk/conversationkit/android/internal/user/Jwt$Unified;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public abstract class Jwt {
    public Jwt(DefaultConstructorMarker defaultConstructorMarker) {
        this();
    }

    public abstract Long getExp();

    public abstract String getExternalId();

    private Jwt() {
    }

    @Metadata(m17d1 = {"\u0000:\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\b\n\u0000\n\u0002\u0010\u000e\n\u0000\n\u0002\u0010\t\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u000b\n\u0002\u0010\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0004\b\u0001\u0018\u0000 \u001d2\u00020\u0001:\u0002\u001c\u001dB1\b\u0011\u0012\u0006\u0010\u0002\u001a\u00020\u0003\u0012\n\b\u0001\u0010\u0004\u001a\u0004\u0018\u00010\u0005\u0012\n\b\u0001\u0010\u0006\u001a\u0004\u0018\u00010\u0007\u0012\b\u0010\b\u001a\u0004\u0018\u00010\t¢\u0006\u0002\u0010\nB\u0017\u0012\u0006\u0010\u0004\u001a\u00020\u0005\u0012\b\u0010\u0006\u001a\u0004\u0018\u00010\u0007¢\u0006\u0002\u0010\u000bJ&\u0010\u0014\u001a\u00020\u00152\u0006\u0010\u0016\u001a\u00020\u00002\u0006\u0010\u0017\u001a\u00020\u00182\u0006\u0010\u0019\u001a\u00020\u001aHÁ\u0001¢\u0006\u0002\b\u001bR \u0010\u0006\u001a\u0004\u0018\u00010\u00078\u0016X\u0097\u0004¢\u0006\u0010\n\u0002\u0010\u0010\u0012\u0004\b\f\u0010\r\u001a\u0004\b\u000e\u0010\u000fR\u001c\u0010\u0004\u001a\u00020\u00058\u0016X\u0097\u0004¢\u0006\u000e\n\u0000\u0012\u0004\b\u0011\u0010\r\u001a\u0004\b\u0012\u0010\u0013¨\u0006\u001e"}, m18d2 = {"Lzendesk/conversationkit/android/internal/user/Jwt$Unified;", "Lzendesk/conversationkit/android/internal/user/Jwt;", "seen1", "", "externalId", "", "exp", "", "serializationConstructorMarker", "Lkotlinx/serialization/internal/SerializationConstructorMarker;", "(ILjava/lang/String;Ljava/lang/Long;Lkotlinx/serialization/internal/SerializationConstructorMarker;)V", "(Ljava/lang/String;Ljava/lang/Long;)V", "getExp$annotations", "()V", "getExp", "()Ljava/lang/Long;", "Ljava/lang/Long;", "getExternalId$annotations", "getExternalId", "()Ljava/lang/String;", "write$Self", "", "self", "output", "Lkotlinx/serialization/encoding/CompositeEncoder;", "serialDesc", "Lkotlinx/serialization/descriptors/SerialDescriptor;", "write$Self$zendesk_conversationkit_conversationkit_android", "$serializer", "Companion", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    @Serializable
    public static final class Unified extends Jwt {

        public static final Companion INSTANCE = new Companion(null);
        private final Long exp;
        private final String externalId;

        @SerialName("exp")
        public static void getExp$annotations() {
        }

        @SerialName("external_id")
        public static void getExternalId$annotations() {
        }

        @Metadata(m17d1 = {"\u0000\u0016\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\b\u0086\u0003\u0018\u00002\u00020\u0001B\u0007\b\u0002¢\u0006\u0002\u0010\u0002J\u000f\u0010\u0003\u001a\b\u0012\u0004\u0012\u00020\u00050\u0004HÆ\u0001¨\u0006\u0006"}, m18d2 = {"Lzendesk/conversationkit/android/internal/user/Jwt$Unified$Companion;", "", "()V", "serializer", "Lkotlinx/serialization/KSerializer;", "Lzendesk/conversationkit/android/internal/user/Jwt$Unified;", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
        public static final class Companion {
            public Companion(DefaultConstructorMarker defaultConstructorMarker) {
                this();
            }

            private Companion() {
            }

            public final KSerializer<Unified> serializer() {
                return Jwt$Unified$$serializer.INSTANCE;
            }
        }

        @Deprecated(level = DeprecationLevel.HIDDEN, message = "This synthesized declaration should not be used directly", replaceWith = @ReplaceWith(expression = "", imports = {}))
        public Unified(int i, @SerialName("external_id") String str, @SerialName("exp") Long l, SerializationConstructorMarker serializationConstructorMarker) {
            super(null);
            if (3 != (i & 3)) {
                PluginExceptionsKt.throwMissingFieldException(i, 3, Jwt$Unified$$serializer.INSTANCE.getDescriptor());
            }
            this.externalId = str;
            this.exp = l;
        }

        @JvmStatic
        public static final void write$Self$zendesk_conversationkit_conversationkit_android(Unified self, CompositeEncoder output, SerialDescriptor serialDesc) {
            output.encodeStringElement(serialDesc, 0, self.getExternalId());
            output.encodeNullableSerializableElement(serialDesc, 1, LongSerializer.INSTANCE, self.getExp());
        }

        @Override
        public String getExternalId() {
            return this.externalId;
        }

        @Override
        public Long getExp() {
            return this.exp;
        }

        public Unified(String externalId, Long l) {
            super(null);
            Intrinsics.checkNotNullParameter(externalId, "externalId");
            this.externalId = externalId;
            this.exp = l;
        }
    }

    @Metadata(m17d1 = {"\u0000$\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0000\b\u0000\u0018\u00002\u00020\u0001B\u0005¢\u0006\u0002\u0010\u0002J\u0014\u0010\u0006\u001a\b\u0012\u0004\u0012\u00020\b0\u00072\u0006\u0010\t\u001a\u00020\nR\u0014\u0010\u0003\u001a\u00020\u0004X\u0082\u0004¢\u0006\b\n\u0000\u0012\u0004\b\u0005\u0010\u0002¨\u0006\u000b"}, m18d2 = {"Lzendesk/conversationkit/android/internal/user/Jwt$Decoder;", "", "()V", "json", "Lkotlinx/serialization/json/Json;", "getJson$annotations", "decode", "Lzendesk/conversationkit/android/ConversationKitResult;", "Lzendesk/conversationkit/android/internal/user/Jwt;", "jwt", "", "zendesk.conversationkit_conversationkit-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
    public static final class Decoder {
        private final Json json = JsonKt.Json$default(null, new Function1<JsonBuilder, Unit>() {
            @Override
            public Unit invoke(JsonBuilder jsonBuilder) {
                invoke2(jsonBuilder);
                return Unit.INSTANCE;
            }

            public final void invoke2(JsonBuilder Json) {
                Intrinsics.checkNotNullParameter(Json, "$this$Json");
                Json.setEncodeDefaults(true);
                Json.setIgnoreUnknownKeys(true);
                Json.setExplicitNulls(false);
                Json.setLenient(true);
            }
        }, 1, null);

        private static void getJson$annotations() {
        }

        public final ConversationKitResult<Jwt> decode(String jwt) {
            Intrinsics.checkNotNullParameter(jwt, "jwt");
            try {
                ByteString byteStringDecodeBase64 = ByteString.INSTANCE.decodeBase64((String) StringsKt.split$default((CharSequence) jwt, new char[]{'.'}, false, 0, 6, (Object) null).get(1));
                String strString = byteStringDecodeBase64 != null ? byteStringDecodeBase64.string(Charsets.UTF_8) : null;
                if (strString == null) {
                    strString = "";
                }
                Json json = this.json;
                json.getSerializersModule();
                return new ConversationKitResult.Success((Unified) json.decodeFromString(Unified.INSTANCE.serializer(), strString));
            } catch (Exception e) {
                return new ConversationKitResult.Failure(e);
            }
        }
    }
}
