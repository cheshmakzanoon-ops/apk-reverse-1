package cz.msebera.android.httpclient.conn;

import cz.msebera.android.httpclient.HttpEntity;
import cz.msebera.android.httpclient.entity.HttpEntityWrapper;
import cz.msebera.android.httpclient.util.Args;
import cz.msebera.android.httpclient.util.EntityUtils;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.SocketException;

@Deprecated
public class BasicManagedEntity extends HttpEntityWrapper implements ConnectionReleaseTrigger, EofSensorWatcher {
    protected final boolean attemptReuse;
    protected ManagedClientConnection managedConn;

    @Override
    public boolean isRepeatable() {
        return false;
    }

    public BasicManagedEntity(HttpEntity httpEntity, ManagedClientConnection managedClientConnection, boolean z) {
        super(httpEntity);
        Args.notNull(managedClientConnection, "Connection");
        this.managedConn = managedClientConnection;
        this.attemptReuse = z;
    }

    @Override
    public InputStream getContent() throws IOException {
        return new EofSensorInputStream(this.wrappedEntity.getContent(), this);
    }

    private void ensureConsumed() throws IOException {
        ManagedClientConnection managedClientConnection = this.managedConn;
        if (managedClientConnection == null) {
            return;
        }
        try {
            if (this.attemptReuse) {
                EntityUtils.consume(this.wrappedEntity);
                this.managedConn.markReusable();
            } else {
                managedClientConnection.unmarkReusable();
            }
        } finally {
            releaseManagedConnection();
        }
    }

    @Override
    @Deprecated
    public void consumeContent() throws IOException {
        ensureConsumed();
    }

    @Override
    public void writeTo(OutputStream outputStream) throws IOException {
        super.writeTo(outputStream);
        ensureConsumed();
    }

    @Override
    public void releaseConnection() throws IOException {
        ensureConsumed();
    }

    @Override
    public void abortConnection() throws IOException {
        ManagedClientConnection managedClientConnection = this.managedConn;
        if (managedClientConnection != null) {
            try {
                managedClientConnection.abortConnection();
            } finally {
                this.managedConn = null;
            }
        }
    }

    @Override
    public boolean eofDetected(InputStream inputStream) throws IOException {
        try {
            ManagedClientConnection managedClientConnection = this.managedConn;
            if (managedClientConnection != null) {
                if (this.attemptReuse) {
                    inputStream.close();
                    this.managedConn.markReusable();
                } else {
                    managedClientConnection.unmarkReusable();
                }
            }
            return false;
        } finally {
            releaseManagedConnection();
        }
    }

    @Override
    public boolean streamClosed(InputStream inputStream) throws IOException {
        try {
            ManagedClientConnection managedClientConnection = this.managedConn;
            if (managedClientConnection != null) {
                if (this.attemptReuse) {
                    boolean zIsOpen = managedClientConnection.isOpen();
                    try {
                        inputStream.close();
                        this.managedConn.markReusable();
                    } catch (SocketException e) {
                        if (zIsOpen) {
                            throw e;
                        }
                    }
                } else {
                    managedClientConnection.unmarkReusable();
                }
            }
            releaseManagedConnection();
            return false;
        } catch (Throwable th) {
            releaseManagedConnection();
            throw th;
        }
    }

    @Override
    public boolean streamAbort(InputStream inputStream) throws IOException {
        ManagedClientConnection managedClientConnection = this.managedConn;
        if (managedClientConnection == null) {
            return false;
        }
        managedClientConnection.abortConnection();
        return false;
    }

    protected void releaseManagedConnection() throws IOException {
        ManagedClientConnection managedClientConnection = this.managedConn;
        if (managedClientConnection != null) {
            try {
                managedClientConnection.releaseConnection();
            } finally {
                this.managedConn = null;
            }
        }
    }
}
