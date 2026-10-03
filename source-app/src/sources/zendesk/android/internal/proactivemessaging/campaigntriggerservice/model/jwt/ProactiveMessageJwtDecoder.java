package zendesk.android.internal.proactivemessaging.campaigntriggerservice.model.jwt;

import javax.inject.Inject;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.Charsets;
import kotlin.text.StringsKt;
import kotlinx.serialization.SerializationException;
import kotlinx.serialization.json.Json;
import okio.ByteString;
import zendesk.logger.Logger;

@Metadata(m17d1 = {"\u0000 \n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u000e\n\u0002\b\u0002\b\u0000\u0018\u0000 \t2\u00020\u0001:\u0001\tB\u000f\b\u0007\u0012\u0006\u0010\u0002\u001a\u00020\u0003¢\u0006\u0002\u0010\u0004J\u0010\u0010\u0005\u001a\u0004\u0018\u00010\u00062\u0006\u0010\u0007\u001a\u00020\bR\u000e\u0010\u0002\u001a\u00020\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\n"}, m18d2 = {"Lzendesk/android/internal/proactivemessaging/campaigntriggerservice/model/jwt/ProactiveMessageJwtDecoder;", "", "json", "Lkotlinx/serialization/json/Json;", "(Lkotlinx/serialization/json/Json;)V", "decode", "Lzendesk/android/internal/proactivemessaging/campaigntriggerservice/model/jwt/ProactiveMessageResponse;", "jwt", "", "Companion", "zendesk_zendesk-android"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class ProactiveMessageJwtDecoder {
    private static final String LOG_TAG = "ProactiveMessageJwtDecoder";
    private final Json json;

    @Inject
    public ProactiveMessageJwtDecoder(Json json) {
        Intrinsics.checkNotNullParameter(json, "json");
        this.json = json;
    }

    public final ProactiveMessageResponse decode(String jwt) {
        Intrinsics.checkNotNullParameter(jwt, "jwt");
        ByteString byteStringDecodeBase64 = ByteString.INSTANCE.decodeBase64((String) StringsKt.split$default((CharSequence) jwt, new char[]{'.'}, false, 0, 6, (Object) null).get(1));
        String strString = byteStringDecodeBase64 != null ? byteStringDecodeBase64.string(Charsets.UTF_8) : null;
        if (strString == null) {
            strString = "";
        }
        try {
            Json json = this.json;
            json.getSerializersModule();
            return (ProactiveMessageResponse) json.decodeFromString(ProactiveMessageResponse.INSTANCE.serializer(), strString);
        } catch (SerializationException e) {
            Logger.m219e(LOG_TAG, e.getMessage(), new Object[0]);
            return null;
        }
    }
}
