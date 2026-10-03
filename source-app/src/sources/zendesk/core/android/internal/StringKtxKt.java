package zendesk.core.android.internal;

import java.net.MalformedURLException;
import java.net.URI;
import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;

@Metadata(m17d1 = {"\u0000\b\n\u0000\n\u0002\u0010\u000e\n\u0000\u001a\f\u0010\u0000\u001a\u00020\u0001*\u00020\u0001H\u0007¨\u0006\u0002"}, m18d2 = {"parseUrl", "", "zendesk.core_core-utilities"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class StringKtxKt {
    @InternalZendeskApi
    public static final String parseUrl(String str) {
        Intrinsics.checkNotNullParameter(str, "<this>");
        try {
            URI uri = new URI(str);
            return uri.getScheme() + "://" + uri.getHost();
        } catch (MalformedURLException unused) {
            return "";
        }
    }
}
