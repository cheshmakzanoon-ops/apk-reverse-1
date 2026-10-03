package zendesk.okhttp;

import java.io.IOException;
import java.text.Normalizer;
import java.util.Set;
import kotlin.Metadata;
import kotlin.Pair;
import kotlin.coroutines.Continuation;
import kotlin.jvm.functions.Function1;
import kotlin.jvm.internal.Intrinsics;
import kotlin.text.Regex;
import kotlin.text.StringsKt;
import kotlinx.coroutines.BuildersKt__BuildersKt;
import okhttp3.Interceptor;
import okhttp3.Request;
import okhttp3.Response;

@Metadata(m17d1 = {"\u00004\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0010\"\n\u0002\u0018\u0002\n\u0002\u0010\u000e\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0002\b\u0002\n\u0002\u0018\u0002\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u0018\u00002\u00020\u0001B7\u00120\u0010\u0002\u001a,\u0012(\u0012&\u0012\u0004\u0012\u00020\u0005\u0012\u001c\u0012\u001a\b\u0001\u0012\f\u0012\n\u0012\u0006\u0012\u0004\u0018\u00010\u00050\u0007\u0012\u0006\u0012\u0004\u0018\u00010\b0\u00060\u00040\u0003¢\u0006\u0002\u0010\tJ\u0010\u0010\n\u001a\u00020\u000b2\u0006\u0010\f\u001a\u00020\rH\u0016J\u0010\u0010\u000e\u001a\u00020\u00052\u0006\u0010\u000f\u001a\u00020\u0005H\u0002R8\u0010\u0002\u001a,\u0012(\u0012&\u0012\u0004\u0012\u00020\u0005\u0012\u001c\u0012\u001a\b\u0001\u0012\f\u0012\n\u0012\u0006\u0012\u0004\u0018\u00010\u00050\u0007\u0012\u0006\u0012\u0004\u0018\u00010\b0\u00060\u00040\u0003X\u0082\u0004¢\u0006\u0002\n\u0000¨\u0006\u0010"}, m18d2 = {"Lzendesk/okhttp/HeaderInterceptor;", "Lokhttp3/Interceptor;", "headers", "", "Lkotlin/Pair;", "", "Lkotlin/Function1;", "Lkotlin/coroutines/Continuation;", "", "(Ljava/util/Set;)V", "intercept", "Lokhttp3/Response;", "chain", "Lokhttp3/Interceptor$Chain;", "normalizeHeaderValue", "headerValue", "zendesk.okhttp_okhttp"}, m19k = 1, m20mv = {1, 9, 0}, m22xi = 48)
public final class HeaderInterceptor implements Interceptor {
    private final Set<Pair<String, Function1<Continuation<? super String>, Object>>> headers;

    public HeaderInterceptor(Set<? extends Pair<String, ? extends Function1<? super Continuation<? super String>, ? extends Object>>> headers) {
        Intrinsics.checkNotNullParameter(headers, "headers");
        this.headers = headers;
    }

    @Override
    public Response intercept(Interceptor.Chain chain) throws IOException {
        Intrinsics.checkNotNullParameter(chain, "chain");
        Request.Builder builderNewBuilder = chain.request().newBuilder();
        for (Pair<String, Function1<Continuation<? super String>, Object>> pair : this.headers) {
            String strComponent1 = pair.component1();
            String str = (String) BuildersKt__BuildersKt.runBlocking$default(null, new HeaderInterceptor$intercept$headerValue$1(pair.component2(), null), 1, null);
            if (str != null) {
                String str2 = StringsKt.isBlank(str) ? null : str;
                if (str2 != null) {
                    builderNewBuilder.addHeader(strComponent1, normalizeHeaderValue(str2));
                }
            }
        }
        return chain.proceed(builderNewBuilder.build());
    }

    private final String normalizeHeaderValue(String headerValue) {
        String strNormalize = Normalizer.normalize(headerValue, Normalizer.Form.NFD);
        Intrinsics.checkNotNullExpressionValue(strNormalize, "normalize(...)");
        return new Regex("[^\\p{ASCII}]").replace(strNormalize, "");
    }
}
