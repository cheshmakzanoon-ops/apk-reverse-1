package kotlinx.coroutines.internal;

import kotlin.Metadata;
import kotlinx.serialization.json.internal.AbstractJsonLexerKt;

@Metadata(m17d1 = {"\u0000\u001c\n\u0002\u0018\u0002\n\u0002\u0010\u0000\n\u0000\n\u0002\u0018\u0002\n\u0002\u0018\u0002\n\u0002\b\u0004\n\u0002\u0010\u000e\n\u0000\b\u0002\u0018\u00002\u00020\u0001B\u0013\u0012\n\u0010\u0002\u001a\u00060\u0004j\u0002`\u0003¢\u0006\u0004\b\u0005\u0010\u0006J\b\u0010\b\u001a\u00020\tH\u0016R\u0016\u0010\u0002\u001a\u00060\u0004j\u0002`\u00038\u0006X\u0087\u0004¢\u0006\u0004\n\u0002\u0010\u0007¨\u0006\n"}, m18d2 = {"Lkotlinx/coroutines/internal/Removed;", "", "ref", "Lkotlinx/coroutines/internal/Node;", "Lkotlinx/coroutines/internal/LockFreeLinkedListNode;", "<init>", "(Lkotlinx/coroutines/internal/LockFreeLinkedListNode;)V", "Lkotlinx/coroutines/internal/LockFreeLinkedListNode;", "toString", "", "kotlinx-coroutines-core"}, m19k = 1, m20mv = {2, 0, 0}, m22xi = 48)
final class Removed {
    public final LockFreeLinkedListNode ref;

    public Removed(LockFreeLinkedListNode lockFreeLinkedListNode) {
        this.ref = lockFreeLinkedListNode;
    }

    public String toString() {
        return "Removed[" + this.ref + AbstractJsonLexerKt.END_LIST;
    }
}
