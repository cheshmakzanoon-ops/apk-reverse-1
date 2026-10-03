package net.aihelp.core.net.mqtt.tansport;

import java.io.EOFException;
import java.io.IOException;
import java.net.ProtocolException;
import java.net.SocketException;
import java.nio.ByteBuffer;
import java.nio.channels.GatheringByteChannel;
import java.nio.channels.ReadableByteChannel;
import java.nio.channels.SocketChannel;
import java.util.Arrays;
import java.util.LinkedList;
import net.aihelp.core.net.mqtt.hawtbuf.Buffer;
import net.aihelp.core.net.mqtt.hawtbuf.DataByteArrayOutputStream;
import net.aihelp.core.net.mqtt.util.BufferPool;
import net.aihelp.core.net.mqtt.util.BufferPools;

public abstract class AbstractProtocolCodec implements ProtocolCodec {
    protected BufferPools bufferPools;
    protected int lastReadIoSize;
    protected Action nextDecodeAction;
    protected DataByteArrayOutputStream nextWriteBuffer;
    protected ByteBuffer readBuffer;
    protected BufferPool readBufferPool;
    protected int readEnd;
    protected int readStart;
    protected BufferPool writeBufferPool;
    protected int writeBufferSize = 65536;
    protected long writeCounter = 0;
    protected GatheringByteChannel writeChannel = null;
    protected long lastWriteIoSize = 0;
    protected LinkedList<ByteBuffer> writeBuffer = new LinkedList<>();
    private long writeBufferRemaining = 0;
    protected long readCounter = 0;
    protected int readBufferSize = 65536;
    protected ReadableByteChannel readChannel = null;
    protected ByteBuffer directReadBuffer = null;

    public interface Action {
        Object apply() throws IOException;
    }

    protected abstract void encode(Object obj) throws IOException;

    protected abstract Action initialDecodeAction();

    protected void onBufferFlushed(ByteBuffer byteBuffer) {
    }

    @Override
    public void setTransport(Transport transport) {
        this.writeChannel = (GatheringByteChannel) transport.getWriteChannel();
        this.readChannel = transport.getReadChannel();
        if (this.nextDecodeAction == null) {
            this.nextDecodeAction = initialDecodeAction();
        }
        if (transport instanceof TcpTransport) {
            TcpTransport tcpTransport = (TcpTransport) transport;
            this.writeBufferSize = tcpTransport.getSendBufferSize();
            this.readBufferSize = tcpTransport.getReceiveBufferSize();
        } else if (transport instanceof UdpTransport) {
            UdpTransport udpTransport = (UdpTransport) transport;
            this.writeBufferSize = udpTransport.getSendBufferSize();
            this.readBufferSize = udpTransport.getReceiveBufferSize();
        } else {
            try {
                GatheringByteChannel gatheringByteChannel = this.writeChannel;
                if (gatheringByteChannel instanceof SocketChannel) {
                    this.writeBufferSize = ((SocketChannel) gatheringByteChannel).socket().getSendBufferSize();
                    this.readBufferSize = ((SocketChannel) this.readChannel).socket().getReceiveBufferSize();
                } else if (gatheringByteChannel instanceof SslTransport.SSLChannel) {
                    this.writeBufferSize = ((SslTransport.SSLChannel) this.readChannel).socket().getSendBufferSize();
                    this.readBufferSize = ((SslTransport.SSLChannel) this.writeChannel).socket().getReceiveBufferSize();
                }
            } catch (SocketException unused) {
            }
        }
        BufferPools bufferPools = this.bufferPools;
        if (bufferPools != null) {
            this.readBufferPool = bufferPools.getBufferPool(this.readBufferSize);
            this.writeBufferPool = this.bufferPools.getBufferPool(this.writeBufferSize);
        }
    }

    @Override
    public int getReadBufferSize() {
        return this.readBufferSize;
    }

    @Override
    public int getWriteBufferSize() {
        return this.writeBufferSize;
    }

    @Override
    public boolean full() {
        return this.writeBufferRemaining >= ((long) this.writeBufferSize);
    }

    public boolean isEmpty() {
        DataByteArrayOutputStream dataByteArrayOutputStream;
        return this.writeBufferRemaining == 0 && ((dataByteArrayOutputStream = this.nextWriteBuffer) == null || dataByteArrayOutputStream.size() == 0);
    }

    @Override
    public long getWriteCounter() {
        return this.writeCounter;
    }

    @Override
    public long getLastWriteSize() {
        return this.lastWriteIoSize;
    }

    @Override
    public ProtocolCodec.BufferState write(Object obj) throws IOException {
        if (full()) {
            return ProtocolCodec.BufferState.FULL;
        }
        boolean zIsEmpty = isEmpty();
        if (this.nextWriteBuffer == null) {
            this.nextWriteBuffer = allocateNextWriteBuffer();
        }
        encode(obj);
        if (this.nextWriteBuffer.size() >= ((double) this.writeBufferSize) * 0.75d) {
            flushNextWriteBuffer();
        }
        if (zIsEmpty) {
            return ProtocolCodec.BufferState.WAS_EMPTY;
        }
        return ProtocolCodec.BufferState.NOT_EMPTY;
    }

    private DataByteArrayOutputStream allocateNextWriteBuffer() {
        if (this.writeBufferPool != null) {
            return new DataByteArrayOutputStream(this.writeBufferPool.checkout()) {
                @Override
                protected void resize(int i) {
                    byte[] bArr = this.buf;
                    super.resize(i);
                    if (bArr.length == AbstractProtocolCodec.this.writeBufferPool.getBufferSize()) {
                        AbstractProtocolCodec.this.writeBufferPool.checkin(bArr);
                    }
                }
            };
        }
        return new DataByteArrayOutputStream(this.writeBufferSize);
    }

    protected void writeDirect(ByteBuffer byteBuffer) throws IOException {
        int iPosition = this.nextWriteBuffer.position();
        int iRemaining = byteBuffer.remaining();
        if (this.nextWriteBuffer.getData().length - iPosition > iRemaining) {
            byteBuffer.get(this.nextWriteBuffer.getData(), iPosition, iRemaining);
            this.nextWriteBuffer.position(iPosition + iRemaining);
            return;
        }
        DataByteArrayOutputStream dataByteArrayOutputStream = this.nextWriteBuffer;
        if (dataByteArrayOutputStream != null && dataByteArrayOutputStream.size() != 0) {
            flushNextWriteBuffer();
        }
        this.writeBuffer.add(byteBuffer);
        this.writeBufferRemaining += (long) byteBuffer.remaining();
    }

    protected void flushNextWriteBuffer() {
        DataByteArrayOutputStream dataByteArrayOutputStreamAllocateNextWriteBuffer = allocateNextWriteBuffer();
        ByteBuffer byteBuffer = this.nextWriteBuffer.toBuffer().toByteBuffer();
        this.writeBuffer.add(byteBuffer);
        this.writeBufferRemaining += (long) byteBuffer.remaining();
        this.nextWriteBuffer = dataByteArrayOutputStreamAllocateNextWriteBuffer;
    }

    @Override
    public ProtocolCodec.BufferState flush() throws IOException {
        DataByteArrayOutputStream dataByteArrayOutputStream;
        while (true) {
            if (this.writeBufferRemaining != 0) {
                if (this.writeBuffer.size() == 1) {
                    ByteBuffer first = this.writeBuffer.getFirst();
                    long jWrite = this.writeChannel.write(first);
                    this.lastWriteIoSize = jWrite;
                    if (jWrite == 0) {
                        return ProtocolCodec.BufferState.NOT_EMPTY;
                    }
                    this.writeBufferRemaining -= jWrite;
                    this.writeCounter += jWrite;
                    if (!first.hasRemaining()) {
                        onBufferFlushed(this.writeBuffer.removeFirst());
                    }
                } else {
                    LinkedList<ByteBuffer> linkedList = this.writeBuffer;
                    ByteBuffer[] byteBufferArr = (ByteBuffer[]) linkedList.toArray(new ByteBuffer[linkedList.size()]);
                    long jWrite2 = this.writeChannel.write(byteBufferArr, 0, byteBufferArr.length);
                    this.lastWriteIoSize = jWrite2;
                    if (jWrite2 == 0) {
                        return ProtocolCodec.BufferState.NOT_EMPTY;
                    }
                    this.writeBufferRemaining -= jWrite2;
                    this.writeCounter += jWrite2;
                    while (!this.writeBuffer.isEmpty() && !this.writeBuffer.getFirst().hasRemaining()) {
                        onBufferFlushed(this.writeBuffer.removeFirst());
                    }
                }
            } else {
                DataByteArrayOutputStream dataByteArrayOutputStream2 = this.nextWriteBuffer;
                if (dataByteArrayOutputStream2 == null || dataByteArrayOutputStream2.size() == 0) {
                    BufferPool bufferPool = this.writeBufferPool;
                    if (bufferPool != null && (dataByteArrayOutputStream = this.nextWriteBuffer) != null) {
                        bufferPool.checkin(dataByteArrayOutputStream.getData());
                        this.nextWriteBuffer = null;
                    }
                    return ProtocolCodec.BufferState.EMPTY;
                }
                flushNextWriteBuffer();
            }
        }
    }

    @Override
    public void unread(byte[] bArr) {
        ByteBuffer byteBufferAllocate = ByteBuffer.allocate(bArr.length);
        this.readBuffer = byteBufferAllocate;
        byteBufferAllocate.put(bArr);
        this.readCounter += (long) bArr.length;
    }

    @Override
    public long getReadCounter() {
        return this.readCounter;
    }

    @Override
    public long getLastReadSize() {
        return this.lastReadIoSize;
    }

    @Override
    public Object read() throws IOException {
        int iPosition;
        boolean z;
        int iMax;
        byte[] bArrCheckout;
        Object objApply = null;
        while (objApply == null) {
            if (this.directReadBuffer != null) {
                while (this.directReadBuffer.hasRemaining()) {
                    int i = this.readChannel.read(this.directReadBuffer);
                    this.lastReadIoSize = i;
                    this.readCounter += (long) i;
                    if (i == -1) {
                        throw new EOFException("Peer disconnected");
                    }
                    if (i == 0) {
                        return null;
                    }
                }
                objApply = this.nextDecodeAction.apply();
            } else {
                ByteBuffer byteBuffer = this.readBuffer;
                if (byteBuffer == null || this.readEnd >= byteBuffer.position()) {
                    ByteBuffer byteBuffer2 = this.readBuffer;
                    if (byteBuffer2 != null) {
                        iPosition = byteBuffer2.position();
                        z = this.readBufferPool != null && this.readStart == 0 && this.readBuffer.capacity() == this.readBufferPool.getBufferSize();
                    } else {
                        iPosition = 0;
                        z = false;
                    }
                    ByteBuffer byteBuffer3 = this.readBuffer;
                    if (byteBuffer3 == null || byteBuffer3.remaining() == 0) {
                        int i2 = this.readStart;
                        int i3 = iPosition - i2;
                        int i4 = this.readEnd - i2;
                        if (i4 > i3) {
                            iMax = Math.max(this.readBufferSize, i4);
                        } else {
                            iMax = this.readBufferSize + i3;
                        }
                        if (i3 > 0) {
                            byte[] bArrArray = this.readBuffer.array();
                            int i5 = this.readStart;
                            bArrCheckout = Arrays.copyOfRange(bArrArray, i5, iMax + i5);
                        } else {
                            BufferPool bufferPool = this.readBufferPool;
                            if (bufferPool != null && iMax == bufferPool.getBufferSize()) {
                                bArrCheckout = this.readBufferPool.checkout();
                            } else {
                                bArrCheckout = new byte[iMax];
                            }
                        }
                        if (z) {
                            this.readBufferPool.checkin(this.readBuffer.array());
                        }
                        ByteBuffer byteBufferWrap = ByteBuffer.wrap(bArrCheckout);
                        this.readBuffer = byteBufferWrap;
                        byteBufferWrap.position(i3);
                        this.readStart = 0;
                        this.readEnd = i4;
                    }
                    int i6 = this.readChannel.read(this.readBuffer);
                    this.lastReadIoSize = i6;
                    long j = this.readCounter + ((long) i6);
                    this.readCounter = j;
                    if (i6 == -1) {
                        this.readCounter = j + 1;
                        throw new EOFException("Peer disconnected");
                    }
                    if (i6 == 0) {
                        if (this.readStart == this.readBuffer.position()) {
                            if (z) {
                                this.readBufferPool.checkin(this.readBuffer.array());
                            }
                            this.readStart = 0;
                            this.readEnd = 0;
                            this.readBuffer = null;
                        }
                        return null;
                    }
                    if (this.readBuffer.hasRemaining() && this.readEnd <= this.readBuffer.position()) {
                        ByteBuffer byteBufferWrap2 = ByteBuffer.wrap(Arrays.copyOfRange(this.readBuffer.array(), 0, this.readBuffer.position()));
                        byteBufferWrap2.position(this.readBuffer.position());
                        if (z) {
                            this.readBufferPool.checkin(this.readBuffer.array());
                        }
                        this.readBuffer = byteBufferWrap2;
                    }
                }
                objApply = this.nextDecodeAction.apply();
            }
        }
        return objApply;
    }

    protected Buffer readUntil(Byte b) throws ProtocolException {
        return readUntil(b, -1);
    }

    protected Buffer readUntil(Byte b, int i) throws ProtocolException {
        return readUntil(b, i, "Maximum protocol buffer length exeeded");
    }

    protected Buffer readUntil(Byte b, int i, String str) throws ProtocolException {
        byte[] bArrArray = this.readBuffer.array();
        Buffer buffer = new Buffer(bArrArray, this.readEnd, this.readBuffer.position() - this.readEnd);
        int iIndexOf = buffer.indexOf(b.byteValue());
        if (iIndexOf >= 0) {
            int i2 = this.readStart;
            int i3 = this.readEnd + iIndexOf + 1;
            this.readEnd = i3;
            this.readStart = i3;
            int i4 = i3 - i2;
            if (i >= 0 && i4 > i) {
                throw new ProtocolException(str);
            }
            return new Buffer(bArrArray, i2, i4);
        }
        int i5 = this.readEnd + buffer.length;
        this.readEnd = i5;
        if (i < 0 || i5 - this.readStart <= i) {
            return null;
        }
        throw new ProtocolException(str);
    }

    protected Buffer readBytes(int i) {
        this.readEnd = this.readStart + i;
        int iPosition = this.readBuffer.position();
        int i2 = this.readEnd;
        if (iPosition < i2) {
            return null;
        }
        int i3 = this.readStart;
        this.readStart = i2;
        return new Buffer(this.readBuffer.array(), i3, i);
    }

    protected Buffer peekBytes(int i) {
        this.readEnd = this.readStart + i;
        if (this.readBuffer.position() < this.readEnd) {
            return null;
        }
        this.readEnd = this.readStart;
        return new Buffer(this.readBuffer.array(), this.readStart, i);
    }

    protected Boolean readDirect(ByteBuffer byteBuffer) {
        if (byteBuffer.hasRemaining()) {
            int iPosition = this.readBuffer.position();
            int iMin = Math.min(iPosition - this.readStart, byteBuffer.remaining());
            byte[] bArrArray = this.readBuffer.array();
            byteBuffer.put(bArrArray, this.readStart, iMin);
            int i = this.readStart;
            int i2 = iPosition - (i + iMin);
            if (i2 > 0) {
                System.arraycopy(bArrArray, iMin + i, bArrArray, i, i2);
            }
            this.readBuffer.position(this.readStart + i2);
        }
        if (byteBuffer.hasRemaining()) {
            this.directReadBuffer = byteBuffer;
            return false;
        }
        this.directReadBuffer = null;
        byteBuffer.flip();
        return true;
    }

    public BufferPools getBufferPools() {
        return this.bufferPools;
    }

    public void setBufferPools(BufferPools bufferPools) {
        this.bufferPools = bufferPools;
        if (bufferPools != null) {
            this.readBufferPool = bufferPools.getBufferPool(this.readBufferSize);
            this.writeBufferPool = bufferPools.getBufferPool(this.writeBufferSize);
        } else {
            this.readBufferPool = null;
            this.writeBufferPool = null;
        }
    }
}
