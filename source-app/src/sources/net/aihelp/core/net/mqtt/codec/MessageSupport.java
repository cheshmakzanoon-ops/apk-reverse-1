package net.aihelp.core.net.mqtt.codec;

import java.io.IOException;
import java.net.ProtocolException;
import kotlinx.serialization.json.internal.AbstractJsonLexerKt;
import net.aihelp.core.net.mqtt.client.QoS;
import net.aihelp.core.net.mqtt.hawtbuf.Buffer;
import net.aihelp.core.net.mqtt.hawtbuf.DataByteArrayInputStream;
import net.aihelp.core.net.mqtt.hawtbuf.DataByteArrayOutputStream;
import net.aihelp.core.net.mqtt.hawtbuf.UTF8Buffer;

public final class MessageSupport {

    public interface Acked extends Message {
        Acked dup(boolean z);

        boolean dup();

        Acked messageId(short s);

        short messageId();

        QoS qos();
    }

    public interface Message {
        Message mo1934decode(MQTTFrame mQTTFrame) throws ProtocolException;

        MQTTFrame encode();

        byte messageType();
    }

    private MessageSupport() throws InstantiationException {
        throw new InstantiationException("This class is not for instantiation");
    }

    protected static UTF8Buffer readUTF(DataByteArrayInputStream dataByteArrayInputStream) throws ProtocolException {
        int unsignedShort = dataByteArrayInputStream.readUnsignedShort();
        if (unsignedShort < 0) {
            throw new ProtocolException("Invalid message encoding");
        }
        Buffer buffer = dataByteArrayInputStream.readBuffer(unsignedShort);
        if (buffer == null || buffer.length != unsignedShort) {
            throw new ProtocolException("Invalid message encoding");
        }
        return buffer.utf8();
    }

    protected static void writeUTF(DataByteArrayOutputStream dataByteArrayOutputStream, Buffer buffer) throws IOException {
        dataByteArrayOutputStream.writeShort(buffer.length);
        dataByteArrayOutputStream.write(buffer);
    }

    public static abstract class AckBase {
        private short messageId;

        public abstract byte messageType();

        protected AckBase mo1934decode(MQTTFrame mQTTFrame) throws ProtocolException {
            this.messageId = new DataByteArrayInputStream(mQTTFrame.buffers[0]).readShort();
            return this;
        }

        public MQTTFrame encode() {
            try {
                DataByteArrayOutputStream dataByteArrayOutputStream = new DataByteArrayOutputStream(2);
                dataByteArrayOutputStream.writeShort(this.messageId);
                MQTTFrame mQTTFrame = new MQTTFrame();
                mQTTFrame.commandType((int) messageType());
                return mQTTFrame.buffer(dataByteArrayOutputStream.toBuffer());
            } catch (IOException unused) {
                throw new RuntimeException("The impossible happened");
            }
        }

        public short messageId() {
            return this.messageId;
        }

        protected AckBase messageId(short s) {
            this.messageId = s;
            return this;
        }

        public String toString() {
            return getClass().getSimpleName() + "{messageId=" + ((int) this.messageId) + AbstractJsonLexerKt.END_OBJ;
        }
    }

    public static abstract class EmptyBase {
        public EmptyBase mo1934decode(MQTTFrame mQTTFrame) throws ProtocolException {
            return this;
        }

        public abstract byte messageType();

        public MQTTFrame encode() {
            return new MQTTFrame().commandType((int) messageType());
        }
    }

    public static class HeaderBase {
        protected byte header;

        protected byte header() {
            return this.header;
        }

        protected HeaderBase header(byte b) {
            this.header = b;
            return this;
        }

        protected byte messageType() {
            return (byte) ((this.header & 240) >>> 4);
        }

        protected HeaderBase commandType(int i) {
            this.header = (byte) (((i << 4) & 240) | ((byte) (this.header & 15)));
            return this;
        }

        protected QoS qos() {
            return QoS.values()[(this.header & 6) >>> 1];
        }

        protected HeaderBase qos(QoS qoS) {
            byte b = (byte) (this.header & 249);
            this.header = b;
            this.header = (byte) (((qoS.ordinal() << 1) & 6) | b);
            return this;
        }

        protected boolean dup() {
            return (this.header & 8) > 0;
        }

        protected HeaderBase dup(boolean z) {
            if (z) {
                this.header = (byte) (this.header | 8);
            } else {
                this.header = (byte) (this.header & 247);
            }
            return this;
        }

        protected boolean retain() {
            return (this.header & 1) > 0;
        }

        protected HeaderBase retain(boolean z) {
            if (z) {
                this.header = (byte) (this.header | 1);
            } else {
                this.header = (byte) (this.header & 254);
            }
            return this;
        }
    }
}
