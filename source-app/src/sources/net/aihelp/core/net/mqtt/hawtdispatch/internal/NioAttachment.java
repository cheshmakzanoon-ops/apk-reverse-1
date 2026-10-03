package net.aihelp.core.net.mqtt.hawtdispatch.internal;

import java.nio.channels.SelectionKey;
import java.util.ArrayList;

final class NioAttachment {
    SelectionKey key;
    final ArrayList<NioDispatchSource> sources = new ArrayList<>(2);

    public NioAttachment(SelectionKey selectionKey) {
        this.key = selectionKey;
    }

    public SelectionKey key() {
        return this.key;
    }

    public void selected(SelectionKey selectionKey) {
        int i = selectionKey.readyOps();
        for (NioDispatchSource nioDispatchSource : this.sources) {
            if ((nioDispatchSource.interestOps & i) != 0) {
                nioDispatchSource.fire(i);
            }
        }
    }

    public void cancel() {
        for (NioDispatchSource nioDispatchSource : new ArrayList(this.sources)) {
            this.sources.remove(nioDispatchSource);
            if (nioDispatchSource.canceled.compareAndSet(false, true)) {
                nioDispatchSource.internal_cancel();
            }
        }
    }
}
