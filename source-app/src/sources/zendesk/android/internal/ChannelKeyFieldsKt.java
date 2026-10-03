package zendesk.android.internal;

import android.net.Uri;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0000\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0002H\u0000¨\u0006\u0003"}, m18d2 = {"getBaseUrl", "", "Lzendesk/android/internal/ChannelKeyFields;", "zendesk_zendesk-android"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class ChannelKeyFieldsKt {
    public static final String getBaseUrl(ChannelKeyFields channelKeyFields) {
        Intrinsics.checkNotNullParameter(channelKeyFields, "<this>");
        Uri uri = Uri.parse(channelKeyFields.getSettingsUrl());
        String string = new Uri.Builder().scheme(uri.getScheme()).encodedAuthority(uri.getEncodedAuthority()).build().toString();
        Intrinsics.checkNotNullExpressionValue(string, "toString(...)");
        return string;
    }
}
