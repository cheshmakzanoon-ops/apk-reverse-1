package net.aihelp.core.net.mqtt.codec;

import java.io.IOException;
import kotlin.jvm.internal.ByteCompanionObject;
import net.aihelp.core.net.mqtt.hawtbuf.Buffer;
import net.aihelp.core.net.mqtt.tansport.AbstractProtocolCodec;
import net.aihelp.core.net.mqtt.util.BufferPools;

public class MQTTProtocolCodec extends AbstractProtocolCodec {
    private static final BufferPools BUFFER_POOLS = new BufferPools();
    private int maxMessageLength = 104857600;
    private final AbstractProtocolCodec.Action readHeader = new AbstractProtocolCodec.Action() {
        @Override
        public MQTTFrame apply() throws IOException {
            int length = MQTTProtocolCodec.this.readLength();
            if (length < 0) {
                return null;
            }
            if (length <= MQTTProtocolCodec.this.maxMessageLength) {
                byte b = MQTTProtocolCodec.this.readBuffer.get(MQTTProtocolCodec.this.readStart);
                MQTTProtocolCodec mQTTProtocolCodec = MQTTProtocolCodec.this;
                mQTTProtocolCodec.readStart = mQTTProtocolCodec.readEnd;
                if (length > 0) {
                    MQTTProtocolCodec mQTTProtocolCodec2 = MQTTProtocolCodec.this;
                    mQTTProtocolCodec2.nextDecodeAction = mQTTProtocolCodec2.readBody(b, length);
                    return null;
                }
                return new MQTTFrame().header(b);
            }
            throw new IOException("The maximum message length was exceeded");
        }
    };

    public MQTTProtocolCodec() {
        this.bufferPools = BUFFER_POOLS;
    }

    public int getMaxMessageLength() {
        return this.maxMessageLength;
    }

    public void setMaxMessageLength(int i) {
        this.maxMessageLength = i;
    }

    @Override
    protected void encode(Object obj) throws IOException {
        MQTTFrame mQTTFrame = (MQTTFrame) obj;
        this.nextWriteBuffer.write(mQTTFrame.header());
        int i = 0;
        for (Buffer buffer : mQTTFrame.buffers) {
            i += buffer.length;
        }
        do {
            byte b = (byte) (i & 127);
            i >>>= 7;
            if (i > 0) {
                b = (byte) (b | ByteCompanionObject.MIN_VALUE);
            }
            this.nextWriteBuffer.write(b);
        } while (i > 0);
        for (Buffer buffer2 : mQTTFrame.buffers) {
            this.nextWriteBuffer.write(buffer2.data, buffer2.offset, buffer2.length);
        }
    }

    @Override
    protected AbstractProtocolCodec.Action initialDecodeAction() {
        return this.readHeader;
    }

    public int readLength() throws IOException {
        this.readEnd = this.readStart + 2;
        int iPosition = this.readBuffer.position();
        int i = 0;
        int i2 = 1;
        while (this.readEnd - 1 < iPosition) {
            byte b = this.readBuffer.get(this.readEnd - 1);
            i += (b & 127) * i2;
            if ((b & ByteCompanionObject.MIN_VALUE) == 0) {
                return i;
            }
            i2 <<= 7;
            this.readEnd++;
        }
        return -1;
    }

    AbstractProtocolCodec.Action readBody(final byte b, final int i) {
        return new AbstractProtocolCodec.Action() {
            @Override
            public MQTTFrame apply() throws IOException {
                int iPosition = MQTTProtocolCodec.this.readBuffer.position();
                if (iPosition - MQTTProtocolCodec.this.readStart < i) {
                    MQTTProtocolCodec.this.readEnd = iPosition;
                    return null;
                }
                Buffer buffer = new Buffer(MQTTProtocolCodec.this.readBuffer.array(), MQTTProtocolCodec.this.readStart, i);
                MQTTProtocolCodec mQTTProtocolCodec = MQTTProtocolCodec.this;
                mQTTProtocolCodec.readEnd = mQTTProtocolCodec.readStart += i;
                MQTTProtocolCodec mQTTProtocolCodec2 = MQTTProtocolCodec.this;
                mQTTProtocolCodec2.nextDecodeAction = mQTTProtocolCodec2.readHeader;
                return new MQTTFrame(buffer).header(b);
            }
        };
    }
}
