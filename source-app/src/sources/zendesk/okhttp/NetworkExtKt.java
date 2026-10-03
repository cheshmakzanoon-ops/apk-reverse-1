package zendesk.okhttp;

import kotlin.Metadata;
import kotlin.jvm.internal.Intrinsics;
import okhttp3.Interceptor;
import okhttp3.OkHttpClient;

@Metadata(m17d1 = {"\u0000\u0014\n\u0000\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\u0011\n\u0002\u0018\u0002\n\u0002\b\u0002\u001a#\u0010\u0000\u001a\u00020\u0001*\u00020\u00012\u0012\u0010\u0002\u001a\n\u0012\u0006\b\u0001\u0012\u00020\u00040\u0003\"\u00020\u0004¢\u0006\u0002\u0010\u0005¨\u0006\u0006"}, m18d2 = {"addInterceptors", "Lokhttp3/OkHttpClient$Builder;", "interceptors", "", "Lokhttp3/Interceptor;", "(Lokhttp3/OkHttpClient$Builder;[Lokhttp3/Interceptor;)Lokhttp3/OkHttpClient$Builder;", "zendesk.okhttp_okhttp"}, m19k = 2, m20mv = {1, 9, 0}, m22xi = 48)
public final class NetworkExtKt {
    public static final OkHttpClient.Builder addInterceptors(OkHttpClient.Builder builder, Interceptor... interceptors) {
        Intrinsics.checkNotNullParameter(builder, "<this>");
        Intrinsics.checkNotNullParameter(interceptors, "interceptors");
        for (Interceptor interceptor : interceptors) {
            builder.addInterceptor(interceptor);
        }
        return builder;
    }
}
