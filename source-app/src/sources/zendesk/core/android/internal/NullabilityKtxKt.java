package zendesk.core.android.internal;

import kotlin.Metadata;

@Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0002\u0010\u000b\n\u0002\u0010\u000e\n\u0000\u001a\u000e\u0010\u0000\u001a\u00020\u0001*\u0004\u0018\u00010\u0002H\u0007¨\u0006\u0003"}, m18d2 = {"isNotNullOrEmpty", "", "", "zendesk.core_core-utilities"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class NullabilityKtxKt {
    @InternalZendeskApi
    public static final boolean isNotNullOrEmpty(String str) {
        String str2 = str;
        return !(str2 == null || str2.length() == 0);
    }
}
