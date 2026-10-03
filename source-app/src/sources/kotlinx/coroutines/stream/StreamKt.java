package kotlinx.coroutines.stream;

import j$.util.stream.Stream;
import kotlin.Metadata;
import kotlinx.coroutines.flow.Flow;

@Metadata(m17d1 = {"\u0000\f\n\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\b\u0003\u001a#\u0010\u0003\u001a\b\u0012\u0004\u0012\u00028\u00000\u0002\"\u0004\b\u0000\u0010\u0000*\b\u0012\u0004\u0012\u00028\u00000\u0001¢\u0006\u0004\b\u0003\u0010\u0004¨\u0006\u0005"}, m18d2 = {"T", "j$/util/stream/Stream", "Lkotlinx/coroutines/flow/Flow;", "consumeAsFlow", "(Lj$/util/stream/Stream;)Lkotlinx/coroutines/flow/Flow;", "kotlinx-coroutines-core"}, m19k = 2, m20mv = {2, 0, 0}, m22xi = 48)
public final class StreamKt {
    public static final <T> Flow<T> consumeAsFlow(Stream<T> stream) {
        return new StreamFlow(stream);
    }
}
