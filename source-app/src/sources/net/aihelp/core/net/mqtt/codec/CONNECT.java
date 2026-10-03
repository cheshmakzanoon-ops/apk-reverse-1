package net.aihelp.core.net.mqtt.codec;

import java.io.IOException;
import java.net.ProtocolException;
import kotlin.UByte;
import kotlin.jvm.internal.ByteCompanionObject;
import kotlinx.serialization.json.internal.AbstractJsonLexerKt;
import net.aihelp.core.net.mqtt.client.QoS;
import net.aihelp.core.net.mqtt.hawtbuf.Buffer;
import net.aihelp.core.net.mqtt.hawtbuf.DataByteArrayInputStream;
import net.aihelp.core.net.mqtt.hawtbuf.DataByteArrayOutputStream;
import net.aihelp.core.net.mqtt.hawtbuf.UTF8Buffer;

public class CONNECT implements MessageSupport.Message {
    public static final byte TYPE = 1;
    private static final UTF8Buffer V3_PROTOCOL_NAME = new UTF8Buffer("MQIsdp");
    private static final UTF8Buffer V4_PROTOCOL_NAME = new UTF8Buffer("MQTT");
    private boolean cleanSession;
    private UTF8Buffer clientId;
    private short keepAlive;
    private UTF8Buffer password;
    private UTF8Buffer userName;
    private int version;
    private UTF8Buffer willMessage;
    private byte willQos;
    private boolean willRetain;
    private UTF8Buffer willTopic;

    @Override
    public byte messageType() {
        return (byte) 1;
    }

    public CONNECT() {
        this.keepAlive = (short) 30;
        this.willMessage = new UTF8Buffer("");
        this.cleanSession = true;
        this.version = 3;
    }

    public CONNECT(CONNECT connect) {
        this.keepAlive = (short) 30;
        this.willMessage = new UTF8Buffer("");
        this.cleanSession = true;
        this.version = 3;
        this.keepAlive = connect.keepAlive;
        this.clientId = connect.clientId;
        this.willTopic = connect.willTopic;
        this.willMessage = connect.willMessage;
        this.willRetain = connect.willRetain;
        this.willQos = connect.willQos;
        this.cleanSession = connect.cleanSession;
        this.userName = connect.userName;
        this.password = connect.password;
        this.version = connect.version;
    }

    @Override
    public CONNECT mo1934decode(MQTTFrame mQTTFrame) throws ProtocolException {
        DataByteArrayInputStream dataByteArrayInputStream = new DataByteArrayInputStream(mQTTFrame.buffers[0]);
        UTF8Buffer utf = MessageSupport.readUTF(dataByteArrayInputStream);
        if (V4_PROTOCOL_NAME.equals((Buffer) utf)) {
            int i = dataByteArrayInputStream.readByte() & UByte.MAX_VALUE;
            this.version = i;
            if (i < 4) {
                throw new ProtocolException("Invalid CONNECT frame: protocol name/version mismatch");
            }
        } else if (V3_PROTOCOL_NAME.equals((Buffer) utf)) {
            int i2 = dataByteArrayInputStream.readByte() & UByte.MAX_VALUE;
            this.version = i2;
            if (i2 != 3) {
                throw new ProtocolException("Invalid CONNECT frame: protocol name/version mismatch");
            }
        } else {
            throw new ProtocolException("Invalid CONNECT frame");
        }
        byte b = dataByteArrayInputStream.readByte();
        boolean z = (b & ByteCompanionObject.MIN_VALUE) > 0;
        boolean z2 = (b & 64) > 0;
        this.willRetain = (b & 32) > 0;
        this.willQos = (byte) ((b & 24) >>> 3);
        boolean z3 = (b & 4) > 0;
        this.cleanSession = (b & 2) > 0;
        this.keepAlive = dataByteArrayInputStream.readShort();
        UTF8Buffer utf2 = MessageSupport.readUTF(dataByteArrayInputStream);
        this.clientId = utf2;
        if (utf2.length == 0) {
            this.clientId = null;
        }
        if (z3) {
            this.willTopic = MessageSupport.readUTF(dataByteArrayInputStream);
            this.willMessage = MessageSupport.readUTF(dataByteArrayInputStream);
        }
        if (z) {
            this.userName = MessageSupport.readUTF(dataByteArrayInputStream);
        }
        if (z2) {
            this.password = MessageSupport.readUTF(dataByteArrayInputStream);
        }
        return this;
    }

    @Override
    public MQTTFrame encode() {
        try {
            UTF8Buffer uTF8Buffer = this.clientId;
            if ((uTF8Buffer == null || uTF8Buffer.length == 0) && !this.cleanSession) {
                throw new IllegalArgumentException("A clean session must be used when no clientId is specified");
            }
            DataByteArrayOutputStream dataByteArrayOutputStream = new DataByteArrayOutputStream(500);
            int i = this.version;
            if (i == 3) {
                MessageSupport.writeUTF(dataByteArrayOutputStream, V3_PROTOCOL_NAME);
                dataByteArrayOutputStream.writeByte(this.version);
            } else if (i >= 4) {
                MessageSupport.writeUTF(dataByteArrayOutputStream, V4_PROTOCOL_NAME);
                dataByteArrayOutputStream.writeByte(this.version);
            } else {
                throw new IllegalArgumentException("Invalid version: " + this.version);
            }
            int i2 = this.userName != null ? 128 : 0;
            if (this.password != null) {
                i2 |= 64;
            }
            if (this.willTopic != null && this.willMessage != null) {
                int i3 = i2 | 4;
                if (this.willRetain) {
                    i3 = i2 | 36;
                }
                i2 = ((this.willQos << 3) & 24) | i3;
            }
            if (this.cleanSession) {
                i2 |= 2;
            }
            dataByteArrayOutputStream.writeByte(i2);
            dataByteArrayOutputStream.writeShort(this.keepAlive);
            MessageSupport.writeUTF(dataByteArrayOutputStream, this.clientId);
            UTF8Buffer uTF8Buffer2 = this.willTopic;
            if (uTF8Buffer2 != null && this.willMessage != null) {
                MessageSupport.writeUTF(dataByteArrayOutputStream, uTF8Buffer2);
                MessageSupport.writeUTF(dataByteArrayOutputStream, this.willMessage);
            }
            UTF8Buffer uTF8Buffer3 = this.userName;
            if (uTF8Buffer3 != null) {
                MessageSupport.writeUTF(dataByteArrayOutputStream, uTF8Buffer3);
            }
            UTF8Buffer uTF8Buffer4 = this.password;
            if (uTF8Buffer4 != null) {
                MessageSupport.writeUTF(dataByteArrayOutputStream, uTF8Buffer4);
            }
            MQTTFrame mQTTFrame = new MQTTFrame();
            mQTTFrame.commandType(1);
            return mQTTFrame.buffer(dataByteArrayOutputStream.toBuffer());
        } catch (IOException unused) {
            throw new RuntimeException("The impossible happened");
        }
    }

    public boolean cleanSession() {
        return this.cleanSession;
    }

    public CONNECT cleanSession(boolean z) {
        this.cleanSession = z;
        return this;
    }

    public UTF8Buffer clientId() {
        return this.clientId;
    }

    public CONNECT clientId(UTF8Buffer uTF8Buffer) {
        this.clientId = uTF8Buffer;
        return this;
    }

    public short keepAlive() {
        return this.keepAlive;
    }

    public CONNECT keepAlive(short s) {
        this.keepAlive = s;
        return this;
    }

    public UTF8Buffer password() {
        return this.password;
    }

    public CONNECT password(UTF8Buffer uTF8Buffer) {
        this.password = uTF8Buffer;
        return this;
    }

    public UTF8Buffer userName() {
        return this.userName;
    }

    public CONNECT userName(UTF8Buffer uTF8Buffer) {
        this.userName = uTF8Buffer;
        return this;
    }

    public UTF8Buffer willMessage() {
        return this.willMessage;
    }

    public CONNECT willMessage(UTF8Buffer uTF8Buffer) {
        this.willMessage = uTF8Buffer;
        return this;
    }

    public QoS willQos() {
        return QoS.values()[this.willQos];
    }

    public CONNECT willQos(QoS qoS) {
        this.willQos = (byte) qoS.ordinal();
        return this;
    }

    public boolean willRetain() {
        return this.willRetain;
    }

    public CONNECT willRetain(boolean z) {
        this.willRetain = z;
        return this;
    }

    public UTF8Buffer willTopic() {
        return this.willTopic;
    }

    public CONNECT willTopic(UTF8Buffer uTF8Buffer) {
        this.willTopic = uTF8Buffer;
        return this;
    }

    public int version() {
        return this.version;
    }

    public CONNECT version(int i) {
        if (i == 3 || i >= 4) {
            this.version = i;
            return this;
        }
        throw new IllegalArgumentException("Invalid version: " + i);
    }

    public String toString() {
        return "CONNECT{cleanSession=" + this.cleanSession + ", keepAlive=" + ((int) this.keepAlive) + ", clientId=" + this.clientId + ", willTopic=" + this.willTopic + ", willMessage=" + this.willMessage + ", willRetain=" + this.willRetain + ", willQos=" + ((int) this.willQos) + ", userName=" + this.userName + ", password=" + this.password + AbstractJsonLexerKt.END_OBJ;
    }
}
