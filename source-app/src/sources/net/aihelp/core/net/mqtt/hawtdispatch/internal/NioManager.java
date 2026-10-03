package net.aihelp.core.net.mqtt.hawtdispatch.internal;

import java.io.IOException;
import java.nio.channels.CancelledKeyException;
import java.nio.channels.ClosedChannelException;
import java.nio.channels.SelectableChannel;
import java.nio.channels.SelectionKey;
import java.nio.channels.Selector;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.LinkedList;
import java.util.concurrent.TimeUnit;
import java.util.concurrent.atomic.AtomicInteger;

public class NioManager {
    private final boolean TRACE;
    private final AtomicInteger registeredKeys;
    protected volatile int selectCounter;
    final SelectStrategy selectStrategy;
    protected volatile boolean selecting;
    private Selector selector;
    private final LinkedList<String> traces;
    protected final AtomicInteger wakeupCounter;

    protected void trace(String str, Object... objArr) {
    }

    class SelectStrategy {
        SelectStrategy() {
        }

        public int select(long j) throws IOException {
            if (j == -1) {
                NioManager.this.trace("entered blocking select", new Object[0]);
                int iSelect = NioManager.this.selector.select();
                NioManager.this.trace("exited blocking select", new Object[0]);
                return iSelect;
            }
            NioManager.this.trace("entered blocking select with timeout", new Object[0]);
            int iSelect2 = NioManager.this.selector.select(j);
            NioManager.this.trace("exited blocking select with timeout", new Object[0]);
            return iSelect2;
        }
    }

    class WorkAroundSelectSpin extends SelectStrategy {
        int spins;

        WorkAroundSelectSpin() {
            super();
        }

        public boolean wakeupPending() {
            return NioManager.this.selectCounter != NioManager.this.wakeupCounter.get();
        }

        @Override
        public int select(long j) throws IOException {
            if (NioManager.this.selector.keys().isEmpty() || (j > 0 && j < 100)) {
                return super.select(j);
            }
            long jNanoTime = System.nanoTime();
            int iSelect = super.select(j);
            if (iSelect == 0 && !wakeupPending()) {
                if (TimeUnit.NANOSECONDS.toMillis(System.nanoTime() - jNanoTime) < 50) {
                    int i = this.spins + 1;
                    this.spins = i;
                    if (i > 10) {
                        reset();
                        this.spins = 0;
                    }
                } else {
                    this.spins = 0;
                }
            } else {
                this.spins = 0;
            }
            return iSelect;
        }

        private void reset() throws IOException {
            NioManager.this.trace("Selector spin detected... resetting the selector", new Object[0]);
            Selector selectorOpen = Selector.open();
            for (SelectionKey selectionKey : NioManager.this.selector.keys()) {
                NioAttachment nioAttachment = (NioAttachment) selectionKey.attachment();
                if (selectionKey.isValid()) {
                    try {
                        SelectionKey selectionKeyRegister = selectionKey.channel().register(selectorOpen, selectionKey.interestOps());
                        nioAttachment.key = selectionKeyRegister;
                        selectionKeyRegister.attach(nioAttachment);
                    } catch (IOException unused) {
                        NioManager.this.cancel(selectionKey);
                    }
                } else {
                    NioManager.this.cancel(selectionKey);
                }
            }
            NioManager.this.selector.close();
            NioManager.this.selector = selectorOpen;
        }
    }

    public NioManager() throws IOException {
        this.selectStrategy = Boolean.getBoolean("hawtdispatch.workaround-select-spin") ? new WorkAroundSelectSpin() : new SelectStrategy();
        this.wakeupCounter = new AtomicInteger();
        this.registeredKeys = new AtomicInteger();
        this.TRACE = false;
        this.traces = new LinkedList<>();
        this.selector = Selector.open();
    }

    public boolean wakeupIfSelecting() {
        if (this.wakeupCounter.getAndIncrement() != this.selectCounter || !this.selecting) {
            return false;
        }
        this.selector.wakeup();
        return true;
    }

    public int select(long j) throws IOException {
        try {
            if (j == 0) {
                this.selector.selectNow();
            } else {
                this.selecting = true;
                try {
                    if (this.selectCounter == this.wakeupCounter.get()) {
                        this.selectStrategy.select(j);
                    } else {
                        this.selector.selectNow();
                    }
                } finally {
                    this.selecting = false;
                    this.selectCounter = this.wakeupCounter.get();
                }
            }
        } catch (CancelledKeyException unused) {
        }
        return processSelected();
    }

    private int processSelected() {
        if (this.selector.keys().isEmpty()) {
            return 0;
        }
        int size = this.selector.selectedKeys().size();
        if (size != 0) {
            trace("selected: %d", Integer.valueOf(size));
            ArrayList<SelectionKey> arrayList = new ArrayList(this.selector.selectedKeys());
            this.selector.selectedKeys().clear();
            for (SelectionKey selectionKey : arrayList) {
                if (selectionKey.isValid()) {
                    try {
                        selectionKey.interestOps(selectionKey.interestOps() & (~selectionKey.readyOps()));
                        ((NioAttachment) selectionKey.attachment()).selected(selectionKey);
                    } catch (CancelledKeyException unused) {
                        cancel(selectionKey);
                    }
                } else {
                    cancel(selectionKey);
                }
            }
        }
        return size;
    }

    public void shutdown() throws IOException {
        Iterator<SelectionKey> it = this.selector.keys().iterator();
        while (it.hasNext()) {
            ((NioDispatchSource) it.next().attachment()).cancel();
        }
        this.selector.close();
    }

    public NioAttachment register(SelectableChannel selectableChannel, int i) throws ClosedChannelException {
        SelectionKey selectionKeyKeyFor = selectableChannel.keyFor(this.selector);
        if (selectionKeyKeyFor == null) {
            selectionKeyKeyFor = selectableChannel.register(this.selector, i);
            this.registeredKeys.incrementAndGet();
            selectionKeyKeyFor.attach(new NioAttachment(selectionKeyKeyFor));
        }
        try {
            selectionKeyKeyFor.interestOps(selectionKeyKeyFor.interestOps() | i);
            return (NioAttachment) selectionKeyKeyFor.attachment();
        } catch (CancelledKeyException e) {
            cancel(selectionKeyKeyFor);
            throw e;
        }
    }

    public int getRegisteredKeyCount() {
        return this.registeredKeys.get();
    }

    public void cancel(SelectionKey selectionKey) {
        NioAttachment nioAttachment = (NioAttachment) selectionKey.attachment();
        if (nioAttachment != null) {
            selectionKey.attach(null);
            nioAttachment.cancel();
            selectionKey.cancel();
            try {
                this.selector.selectNow();
            } catch (Exception unused) {
            }
            this.registeredKeys.decrementAndGet();
        }
    }
}
