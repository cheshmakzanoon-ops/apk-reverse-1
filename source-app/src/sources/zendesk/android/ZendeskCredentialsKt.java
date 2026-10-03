package zendesk.android;

import android.os.Build;
import kotlin.Metadata;
import kotlin.Unit;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlinx.serialization.json.Json;
import kotlinx.serialization.json.JsonBuilder;
import kotlinx.serialization.json.JsonKt;
import okio.ByteString;
import zendesk.android.internal.ChannelKeyFields;
import zendesk.android.internal.ChannelKeyFieldsKt;
import zendesk.android.internal.ZendeskError;
import zendesk.android.internal.p013di.ZendeskComponentConfig;

@Metadata(m17d1 = {"\u0000\u0018\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0000\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u0000\u001a\u0016\u0010\u0003\u001a\u0004\u0018\u00010\u0004*\u00020\u00022\u0006\u0010\u0005\u001a\u00020\u0006H\u0000¨\u0006\u0007"}, m18d2 = {"getZendeskComponentConfig", "Lzendesk/android/internal/di/ZendeskComponentConfig;", "Lzendesk/android/ZendeskCredentials;", "toChannelKeyFields", "Lzendesk/android/internal/ChannelKeyFields;", "json", "Lkotlinx/serialization/json/Json;", "zendesk_zendesk-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ZendeskCredentialsKt {
    public static final ChannelKeyFields toChannelKeyFields(ZendeskCredentials zendeskCredentials, Json json) {
        String strUtf8;
        Intrinsics.checkNotNullParameter(zendeskCredentials, "<this>");
        Intrinsics.checkNotNullParameter(json, "json");
        try {
            ByteString byteStringDecodeBase64 = ByteString.INSTANCE.decodeBase64(zendeskCredentials.getChannelKey());
            if (byteStringDecodeBase64 == null || (strUtf8 = byteStringDecodeBase64.utf8()) == null) {
                throw ZendeskError.InvalidChannelKey.INSTANCE;
            }
            json.getSerializersModule();
            return (ChannelKeyFields) json.decodeFromString(ChannelKeyFields.INSTANCE.serializer(), strUtf8);
        } catch (Throwable unused) {
            return null;
        }
    }

    public static final ZendeskComponentConfig getZendeskComponentConfig(ZendeskCredentials zendeskCredentials) throws ZendeskError.InvalidChannelKey {
        Intrinsics.checkNotNullParameter(zendeskCredentials, "<this>");
        ChannelKeyFields channelKeyFields = toChannelKeyFields(zendeskCredentials, JsonKt.Json$default(null, new Function1<JsonBuilder, Unit>() {
            @Override
            public Unit invoke(JsonBuilder jsonBuilder) {
                invoke2(jsonBuilder);
                return Unit.INSTANCE;
            }

            public final void invoke2(JsonBuilder Json) {
                Intrinsics.checkNotNullParameter(Json, "$this$Json");
                Json.setIgnoreUnknownKeys(true);
            }
        }, 1, null));
        if (channelKeyFields == null) {
            throw ZendeskError.InvalidChannelKey.INSTANCE;
        }
        String baseUrl = ChannelKeyFieldsKt.getBaseUrl(channelKeyFields);
        String str = Build.VERSION.RELEASE;
        if (str == null) {
            str = "";
        }
        return new ZendeskComponentConfig(zendeskCredentials, baseUrl, zendesk.conversationkit.android.BuildConfig.VERSION_NAME, str);
    }
}
