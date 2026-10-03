package net.aihelp.core.net.mqtt.tansport;

import java.io.EOFException;
import java.io.IOException;
import java.net.Socket;
import java.net.URI;
import java.nio.ByteBuffer;
import java.nio.channels.GatheringByteChannel;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.ScatteringByteChannel;
import java.nio.channels.SocketChannel;
import java.nio.channels.WritableByteChannel;
import java.security.cert.Certificate;
import java.security.cert.X509Certificate;
import java.util.ArrayList;
import javax.net.ssl.SSLContext;
import javax.net.ssl.SSLEngine;
import javax.net.ssl.SSLEngineResult;
import javax.net.ssl.SSLPeerUnverifiedException;
import javax.net.ssl.SSLSession;
import net.aihelp.core.net.mqtt.hawtdispatch.Task;

public class SslTransport extends TcpTransport implements SecuredSession {
    private SSLEngine engine;
    private ByteBuffer readBuffer;
    private ByteBuffer readOverflowBuffer;
    private boolean readUnderflow;
    private SSLContext sslContext;
    private ByteBuffer writeBuffer;
    private boolean writeFlushing;
    private ClientAuth clientAuth = ClientAuth.WANT;
    private String disabledCypherSuites = null;
    private String enabledCipherSuites = null;
    private SSLChannel ssl_channel = new SSLChannel();

    enum ClientAuth {
        WANT,
        NEED,
        NONE
    }

    public static String protocol(String str) {
        if (str.equals("tls")) {
            return "TLS";
        }
        if (str.startsWith("tlsv")) {
            return "TLSv" + str.substring(4);
        }
        if (str.equals("ssl")) {
            return "SSL";
        }
        if (!str.startsWith("sslv")) {
            return null;
        }
        return "SSLv" + str.substring(4);
    }

    public void setSSLContext(SSLContext sSLContext) {
        this.sslContext = sSLContext;
    }

    public static SslTransport createTransport(URI uri) throws Exception {
        String strProtocol = protocol(uri.getScheme());
        if (strProtocol == null) {
            return null;
        }
        SslTransport sslTransport = new SslTransport();
        sslTransport.setSSLContext(SSLContext.getInstance(strProtocol));
        return sslTransport;
    }

    public class SSLChannel implements ScatteringByteChannel, GatheringByteChannel {
        public SSLChannel() {
        }

        @Override
        public int write(ByteBuffer byteBuffer) throws IOException {
            return SslTransport.this.secure_write(byteBuffer);
        }

        @Override
        public int read(ByteBuffer byteBuffer) throws IOException {
            return SslTransport.this.secure_read(byteBuffer);
        }

        @Override
        public boolean isOpen() {
            return SslTransport.this.getSocketChannel().isOpen();
        }

        @Override
        public void close() throws IOException {
            SslTransport.this.getSocketChannel().close();
        }

        @Override
        public long write(ByteBuffer[] byteBufferArr, int i, int i2) throws IOException {
            if (i + i2 > byteBufferArr.length || i2 < 0 || i < 0) {
                throw new IndexOutOfBoundsException();
            }
            long jWrite = 0;
            for (int i3 = 0; i3 < i2; i3++) {
                ByteBuffer byteBuffer = byteBufferArr[i + i3];
                if (byteBuffer.hasRemaining()) {
                    jWrite += (long) write(byteBuffer);
                }
                if (byteBuffer.hasRemaining()) {
                    return jWrite;
                }
            }
            return jWrite;
        }

        @Override
        public long write(ByteBuffer[] byteBufferArr) throws IOException {
            return write(byteBufferArr, 0, byteBufferArr.length);
        }

        @Override
        public long read(ByteBuffer[] byteBufferArr, int i, int i2) throws IOException {
            if (i + i2 > byteBufferArr.length || i2 < 0 || i < 0) {
                throw new IndexOutOfBoundsException();
            }
            long j = 0;
            for (int i3 = 0; i3 < i2; i3++) {
                ByteBuffer byteBuffer = byteBufferArr[i + i3];
                if (byteBuffer.hasRemaining()) {
                    j += (long) read(byteBuffer);
                }
                if (byteBuffer.hasRemaining()) {
                    return j;
                }
            }
            return j;
        }

        @Override
        public long read(ByteBuffer[] byteBufferArr) throws IOException {
            return read(byteBufferArr, 0, byteBufferArr.length);
        }

        public Socket socket() {
            SocketChannel socketChannel = SslTransport.this.channel;
            if (socketChannel == null) {
                return null;
            }
            return socketChannel.socket();
        }
    }

    public SSLSession getSSLSession() {
        SSLEngine sSLEngine = this.engine;
        if (sSLEngine == null) {
            return null;
        }
        return sSLEngine.getSession();
    }

    @Override
    public X509Certificate[] getPeerX509Certificates() {
        if (this.engine == null) {
            return null;
        }
        try {
            ArrayList arrayList = new ArrayList();
            for (Certificate certificate : this.engine.getSession().getPeerCertificates()) {
                if (certificate instanceof X509Certificate) {
                    arrayList.add((X509Certificate) certificate);
                }
            }
            return (X509Certificate[]) arrayList.toArray(new X509Certificate[arrayList.size()]);
        } catch (SSLPeerUnverifiedException unused) {
            return null;
        }
    }

    @Override
    public void connecting(URI uri, URI uri2) throws Exception {
        SSLEngine sSLEngineCreateSSLEngine = this.sslContext.createSSLEngine(uri.getHost(), uri.getPort());
        this.engine = sSLEngineCreateSSLEngine;
        sSLEngineCreateSSLEngine.setUseClientMode(true);
        super.connecting(uri, uri2);
    }

    @Override
    public void connected(SocketChannel socketChannel) throws Exception {
        if (this.engine == null) {
            SSLEngine sSLEngineCreateSSLEngine = this.sslContext.createSSLEngine();
            this.engine = sSLEngineCreateSSLEngine;
            sSLEngineCreateSSLEngine.setUseClientMode(false);
            int i = C05404.f73x2e15451[this.clientAuth.ordinal()];
            if (i == 1) {
                this.engine.setWantClientAuth(true);
            } else if (i == 2) {
                this.engine.setNeedClientAuth(true);
            } else if (i == 3) {
                this.engine.setWantClientAuth(false);
            }
        }
        String str = this.enabledCipherSuites;
        if (str != null) {
            this.engine.setEnabledCipherSuites(splitOnCommas(str));
        } else {
            SSLEngine sSLEngine = this.engine;
            sSLEngine.setEnabledCipherSuites(sSLEngine.getSupportedCipherSuites());
        }
        String str2 = this.disabledCypherSuites;
        if (str2 != null) {
            String[] strArrSplitOnCommas = splitOnCommas(str2);
            ArrayList arrayList = new ArrayList();
            for (String str3 : this.engine.getEnabledCipherSuites()) {
                int length = strArrSplitOnCommas.length;
                int i2 = 0;
                while (true) {
                    if (i2 < length) {
                        if (str3.contains(strArrSplitOnCommas[i2])) {
                            break;
                        } else {
                            i2++;
                        }
                    } else {
                        arrayList.add(str3);
                        break;
                    }
                }
            }
            this.engine.setEnabledCipherSuites((String[]) arrayList.toArray(new String[arrayList.size()]));
        }
        super.connected(socketChannel);
    }

    private String[] splitOnCommas(String str) {
        ArrayList arrayList = new ArrayList();
        for (String str2 : str.split(",")) {
            arrayList.add(str2.trim());
        }
        return (String[]) arrayList.toArray(new String[arrayList.size()]);
    }

    @Override
    protected void initializeChannel() throws Exception {
        super.initializeChannel();
        SSLSession session = this.engine.getSession();
        ByteBuffer byteBufferAllocateDirect = ByteBuffer.allocateDirect(session.getPacketBufferSize());
        this.readBuffer = byteBufferAllocateDirect;
        byteBufferAllocateDirect.flip();
        this.writeBuffer = ByteBuffer.allocateDirect(session.getPacketBufferSize());
    }

    @Override
    protected void onConnected() throws IOException {
        super.onConnected();
        this.engine.beginHandshake();
        handshake();
    }

    @Override
    public void flush() {
        if (this.engine.getHandshakeStatus() != SSLEngineResult.HandshakeStatus.NOT_HANDSHAKING) {
            handshake();
        } else {
            super.flush();
        }
    }

    @Override
    public void drainInbound() {
        if (this.engine.getHandshakeStatus() != SSLEngineResult.HandshakeStatus.NOT_HANDSHAKING) {
            handshake();
        } else {
            super.drainInbound();
        }
    }

    @Override
    protected boolean transportFlush() throws IOException {
        while (!this.writeFlushing) {
            if (this.writeBuffer.position() == 0) {
                return true;
            }
            this.writeBuffer.flip();
            this.writeFlushing = true;
            resumeWrite();
        }
        super.getWriteChannel().write(this.writeBuffer);
        if (this.writeBuffer.hasRemaining()) {
            return false;
        }
        this.writeBuffer.clear();
        this.writeFlushing = false;
        suspendWrite();
        return true;
    }

    public int secure_write(ByteBuffer byteBuffer) throws IOException {
        SSLEngineResult sSLEngineResultWrap;
        if (!transportFlush()) {
            return 0;
        }
        int iBytesConsumed = 0;
        do {
            if (!(byteBuffer.hasRemaining() ^ (this.engine.getHandshakeStatus() == SSLEngineResult.HandshakeStatus.NEED_WRAP))) {
                break;
            }
            sSLEngineResultWrap = this.engine.wrap(byteBuffer, this.writeBuffer);
            iBytesConsumed += sSLEngineResultWrap.bytesConsumed();
            if (!transportFlush()) {
                break;
            }
        } while (sSLEngineResultWrap.getStatus() != SSLEngineResult.Status.CLOSED);
        if (byteBuffer.remaining() == 0 && this.engine.getHandshakeStatus() != SSLEngineResult.HandshakeStatus.NOT_HANDSHAKING) {
            this.dispatchQueue.execute(new Task() {
                @Override
                public void run() {
                    SslTransport.this.handshake();
                }
            });
        }
        return iBytesConsumed;
    }

    public int secure_read(ByteBuffer byteBuffer) throws IOException {
        int iBytesProduced = 0;
        while (true) {
            if (!(byteBuffer.hasRemaining() ^ (this.engine.getHandshakeStatus() == SSLEngineResult.HandshakeStatus.NEED_UNWRAP))) {
                break;
            }
            if (this.readOverflowBuffer != null) {
                if (!byteBuffer.hasRemaining()) {
                    return iBytesProduced;
                }
                int iMin = Math.min(byteBuffer.remaining(), this.readOverflowBuffer.remaining());
                byteBuffer.put(this.readOverflowBuffer.array(), this.readOverflowBuffer.position(), iMin);
                ByteBuffer byteBuffer2 = this.readOverflowBuffer;
                byteBuffer2.position(byteBuffer2.position() + iMin);
                if (!this.readOverflowBuffer.hasRemaining()) {
                    this.readOverflowBuffer = null;
                }
                iBytesProduced += iMin;
            } else if (this.readUnderflow) {
                int i = super.getReadChannel().read(this.readBuffer);
                if (i == -1) {
                    if (iBytesProduced == 0) {
                        return -1;
                    }
                    return iBytesProduced;
                }
                if (i == 0) {
                    return iBytesProduced;
                }
                this.readUnderflow = false;
                this.readBuffer.flip();
            } else {
                SSLEngineResult sSLEngineResultUnwrap = this.engine.unwrap(this.readBuffer, byteBuffer);
                iBytesProduced += sSLEngineResultUnwrap.bytesProduced();
                if (sSLEngineResultUnwrap.getStatus() == SSLEngineResult.Status.BUFFER_OVERFLOW) {
                    ByteBuffer byteBufferAllocate = ByteBuffer.allocate(this.engine.getSession().getApplicationBufferSize());
                    this.readOverflowBuffer = byteBufferAllocate;
                    sSLEngineResultUnwrap = this.engine.unwrap(this.readBuffer, byteBufferAllocate);
                    if (this.readOverflowBuffer.position() == 0) {
                        this.readOverflowBuffer = null;
                    } else {
                        this.readOverflowBuffer.flip();
                    }
                }
                int i2 = C05404.$SwitchMap$javax$net$ssl$SSLEngineResult$Status[sSLEngineResultUnwrap.getStatus().ordinal()];
                if (i2 == 1) {
                    if (iBytesProduced != 0) {
                        break;
                    }
                    this.engine.closeInbound();
                    return -1;
                }
                if (i2 != 2) {
                    if (i2 == 3) {
                        this.readBuffer.compact();
                        this.readUnderflow = true;
                    } else if (i2 == 4) {
                        throw new AssertionError("Unexpected case.");
                    }
                } else if (this.engine.getHandshakeStatus() != SSLEngineResult.HandshakeStatus.NOT_HANDSHAKING) {
                    this.dispatchQueue.execute(new Task() {
                        @Override
                        public void run() {
                            SslTransport.this.handshake();
                        }
                    });
                }
            }
        }
        return iBytesProduced;
    }

    public void handshake() {
        try {
            try {
                if (!transportFlush()) {
                    if (this.engine.getHandshakeStatus() == SSLEngineResult.HandshakeStatus.NOT_HANDSHAKING) {
                        this.drainOutboundSource.merge(1);
                        super.drainInbound();
                        return;
                    }
                    return;
                }
                int i = C05404.$SwitchMap$javax$net$ssl$SSLEngineResult$HandshakeStatus[this.engine.getHandshakeStatus().ordinal()];
                if (i == 1) {
                    final Runnable delegatedTask = this.engine.getDelegatedTask();
                    if (delegatedTask != null) {
                        this.blockingExecutor.execute(new Task() {
                            @Override
                            public void run() {
                                delegatedTask.run();
                                SslTransport.this.dispatchQueue.execute(new Task() {
                                    @Override
                                    public void run() {
                                        if (SslTransport.this.isConnected()) {
                                            SslTransport.this.handshake();
                                        }
                                    }
                                });
                            }
                        });
                    }
                } else if (i == 2) {
                    secure_write(ByteBuffer.allocate(0));
                } else if (i != 3) {
                    if (i != 4 && i != 5) {
                        System.err.println("Unexpected ssl engine handshake status: " + this.engine.getHandshakeStatus());
                    }
                } else if (secure_read(ByteBuffer.allocate(0)) == -1) {
                    throw new EOFException("Peer disconnected during ssl handshake");
                }
                if (this.engine.getHandshakeStatus() != SSLEngineResult.HandshakeStatus.NOT_HANDSHAKING) {
                    return;
                }
                this.drainOutboundSource.merge(1);
                super.drainInbound();
            } catch (IOException e) {
                onTransportFailure(e);
                if (this.engine.getHandshakeStatus() != SSLEngineResult.HandshakeStatus.NOT_HANDSHAKING) {
                }
            }
        } catch (Throwable th) {
            if (this.engine.getHandshakeStatus() == SSLEngineResult.HandshakeStatus.NOT_HANDSHAKING) {
                this.drainOutboundSource.merge(1);
                super.drainInbound();
            }
            throw th;
        }
    }

    static class C05404 {
        static final int[] $SwitchMap$javax$net$ssl$SSLEngineResult$HandshakeStatus;
        static final int[] $SwitchMap$javax$net$ssl$SSLEngineResult$Status;

        static final int[] f73x2e15451;

        static {
            int[] iArr = new int[SSLEngineResult.HandshakeStatus.values().length];
            $SwitchMap$javax$net$ssl$SSLEngineResult$HandshakeStatus = iArr;
            try {
                iArr[SSLEngineResult.HandshakeStatus.NEED_TASK.ordinal()] = 1;
            } catch (NoSuchFieldError unused) {
            }
            try {
                $SwitchMap$javax$net$ssl$SSLEngineResult$HandshakeStatus[SSLEngineResult.HandshakeStatus.NEED_WRAP.ordinal()] = 2;
            } catch (NoSuchFieldError unused2) {
            }
            try {
                $SwitchMap$javax$net$ssl$SSLEngineResult$HandshakeStatus[SSLEngineResult.HandshakeStatus.NEED_UNWRAP.ordinal()] = 3;
            } catch (NoSuchFieldError unused3) {
            }
            try {
                $SwitchMap$javax$net$ssl$SSLEngineResult$HandshakeStatus[SSLEngineResult.HandshakeStatus.FINISHED.ordinal()] = 4;
            } catch (NoSuchFieldError unused4) {
            }
            try {
                $SwitchMap$javax$net$ssl$SSLEngineResult$HandshakeStatus[SSLEngineResult.HandshakeStatus.NOT_HANDSHAKING.ordinal()] = 5;
            } catch (NoSuchFieldError unused5) {
            }
            int[] iArr2 = new int[SSLEngineResult.Status.values().length];
            $SwitchMap$javax$net$ssl$SSLEngineResult$Status = iArr2;
            try {
                iArr2[SSLEngineResult.Status.CLOSED.ordinal()] = 1;
            } catch (NoSuchFieldError unused6) {
            }
            try {
                $SwitchMap$javax$net$ssl$SSLEngineResult$Status[SSLEngineResult.Status.OK.ordinal()] = 2;
            } catch (NoSuchFieldError unused7) {
            }
            try {
                $SwitchMap$javax$net$ssl$SSLEngineResult$Status[SSLEngineResult.Status.BUFFER_UNDERFLOW.ordinal()] = 3;
            } catch (NoSuchFieldError unused8) {
            }
            try {
                $SwitchMap$javax$net$ssl$SSLEngineResult$Status[SSLEngineResult.Status.BUFFER_OVERFLOW.ordinal()] = 4;
            } catch (NoSuchFieldError unused9) {
            }
            int[] iArr3 = new int[ClientAuth.values().length];
            f73x2e15451 = iArr3;
            try {
                iArr3[ClientAuth.WANT.ordinal()] = 1;
            } catch (NoSuchFieldError unused10) {
            }
            try {
                f73x2e15451[ClientAuth.NEED.ordinal()] = 2;
            } catch (NoSuchFieldError unused11) {
            }
            try {
                f73x2e15451[ClientAuth.NONE.ordinal()] = 3;
            } catch (NoSuchFieldError unused12) {
            }
        }
    }

    @Override
    public ReadableByteChannel getReadChannel() {
        return this.ssl_channel;
    }

    @Override
    public WritableByteChannel getWriteChannel() {
        return this.ssl_channel;
    }

    public String getClientAuth() {
        return this.clientAuth.name();
    }

    public void setClientAuth(String str) {
        this.clientAuth = ClientAuth.valueOf(str.toUpperCase());
    }

    public String getDisabledCypherSuites() {
        return this.disabledCypherSuites;
    }

    public String getEnabledCypherSuites() {
        return this.enabledCipherSuites;
    }

    public void setDisabledCypherSuites(String str) {
        this.disabledCypherSuites = str;
    }

    public void setEnabledCypherSuites(String str) {
        this.enabledCipherSuites = str;
    }
}
