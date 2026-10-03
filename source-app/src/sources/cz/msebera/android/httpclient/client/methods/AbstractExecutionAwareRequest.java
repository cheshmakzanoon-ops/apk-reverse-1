package cz.msebera.android.httpclient.client.methods;

import cz.msebera.android.httpclient.HttpRequest;
import cz.msebera.android.httpclient.client.utils.CloneUtils;
import cz.msebera.android.httpclient.concurrent.Cancellable;
import cz.msebera.android.httpclient.conn.ClientConnectionRequest;
import cz.msebera.android.httpclient.conn.ConnectionReleaseTrigger;
import cz.msebera.android.httpclient.message.AbstractHttpMessage;
import cz.msebera.android.httpclient.message.HeaderGroup;
import cz.msebera.android.httpclient.params.HttpParams;
import java.io.IOException;
import java.util.concurrent.atomic.AtomicBoolean;
import java.util.concurrent.atomic.AtomicReference;

public abstract class AbstractExecutionAwareRequest extends AbstractHttpMessage implements HttpExecutionAware, AbortableHttpRequest, Cloneable, HttpRequest {
    private final AtomicBoolean aborted = new AtomicBoolean(false);
    private final AtomicReference<Cancellable> cancellableRef = new AtomicReference<>(null);

    protected AbstractExecutionAwareRequest() {
    }

    @Override
    @Deprecated
    public void setConnectionRequest(final ClientConnectionRequest clientConnectionRequest) {
        setCancellable(new Cancellable() {
            @Override
            public boolean cancel() {
                clientConnectionRequest.abortRequest();
                return true;
            }
        });
    }

    @Override
    @Deprecated
    public void setReleaseTrigger(final ConnectionReleaseTrigger connectionReleaseTrigger) {
        setCancellable(new Cancellable() {
            @Override
            public boolean cancel() {
                try {
                    connectionReleaseTrigger.abortConnection();
                    return true;
                } catch (IOException unused) {
                    return false;
                }
            }
        });
    }

    @Override
    public void abort() {
        Cancellable andSet;
        if (!this.aborted.compareAndSet(false, true) || (andSet = this.cancellableRef.getAndSet(null)) == null) {
            return;
        }
        andSet.cancel();
    }

    @Override
    public boolean isAborted() {
        return this.aborted.get();
    }

    @Override
    public void setCancellable(Cancellable cancellable) {
        if (this.aborted.get()) {
            return;
        }
        this.cancellableRef.set(cancellable);
    }

    public Object clone() throws CloneNotSupportedException {
        AbstractExecutionAwareRequest abstractExecutionAwareRequest = (AbstractExecutionAwareRequest) super.clone();
        abstractExecutionAwareRequest.headergroup = (HeaderGroup) CloneUtils.cloneObject(this.headergroup);
        abstractExecutionAwareRequest.params = (HttpParams) CloneUtils.cloneObject(this.params);
        return abstractExecutionAwareRequest;
    }

    public void completed() {
        this.cancellableRef.set(null);
    }

    public void reset() {
        Cancellable andSet = this.cancellableRef.getAndSet(null);
        if (andSet != null) {
            andSet.cancel();
        }
        this.aborted.set(false);
    }
}
