package net.aihelp.core.net.mqtt.codec;

import java.io.IOException;
import java.net.ProtocolException;
import kotlinx.serialization.json.internal.AbstractJsonLexerKt;
import net.aihelp.core.net.mqtt.client.QoS;
import net.aihelp.core.net.mqtt.hawtbuf.Buffer;
import net.aihelp.core.net.mqtt.hawtbuf.DataByteArrayInputStream;
import net.aihelp.core.net.mqtt.hawtbuf.DataByteArrayOutputStream;
import net.aihelp.core.net.mqtt.hawtbuf.UTF8Buffer;

public class PUBLISH extends MessageSupport.HeaderBase implements MessageSupport.Message, MessageSupport.Acked {
    public static final byte TYPE = 3;
    private short messageId;
    private Buffer payload;
    private UTF8Buffer topicName;

    @Override
    public byte messageType() {
        return (byte) 3;
    }

    public PUBLISH() {
        qos(QoS.AT_LEAST_ONCE);
    }

    @Override
    public PUBLISH mo1934decode(MQTTFrame mQTTFrame) throws ProtocolException {
        header(mQTTFrame.header());
        DataByteArrayInputStream dataByteArrayInputStream = new DataByteArrayInputStream(mQTTFrame.buffers[0]);
        this.topicName = MessageSupport.readUTF(dataByteArrayInputStream);
        if (qos() != QoS.AT_MOST_ONCE) {
            this.messageId = dataByteArrayInputStream.readShort();
        }
        Buffer buffer = dataByteArrayInputStream.readBuffer(dataByteArrayInputStream.available());
        this.payload = buffer;
        if (buffer == null) {
            this.payload = new Buffer(0);
        }
        return this;
    }

    @Override
    public MQTTFrame encode() {
        try {
            DataByteArrayOutputStream dataByteArrayOutputStream = new DataByteArrayOutputStream();
            MessageSupport.writeUTF(dataByteArrayOutputStream, this.topicName);
            if (qos() != QoS.AT_MOST_ONCE) {
                dataByteArrayOutputStream.writeShort(this.messageId);
            }
            MQTTFrame mQTTFrame = new MQTTFrame();
            mQTTFrame.header(header());
            mQTTFrame.commandType(3);
            Buffer buffer = this.payload;
            if (buffer != null && buffer.length != 0) {
                dataByteArrayOutputStream.write(this.payload);
            }
            mQTTFrame.buffer(dataByteArrayOutputStream.toBuffer());
            return mQTTFrame;
        } catch (IOException unused) {
            throw new RuntimeException("The impossible happened");
        }
    }

    @Override
    public boolean dup() {
        return super.dup();
    }

    @Override
    public PUBLISH dup(boolean z) {
        return (PUBLISH) super.dup(z);
    }

    @Override
    public QoS qos() {
        return super.qos();
    }

    @Override
    public PUBLISH qos(QoS qoS) {
        return (PUBLISH) super.qos(qoS);
    }

    @Override
    public boolean retain() {
        return super.retain();
    }

    @Override
    public PUBLISH retain(boolean z) {
        return (PUBLISH) super.retain(z);
    }

    @Override
    public short messageId() {
        return this.messageId;
    }

    @Override
    public PUBLISH messageId(short s) {
        this.messageId = s;
        return this;
    }

    public Buffer payload() {
        return this.payload;
    }

    public PUBLISH payload(Buffer buffer) {
        this.payload = buffer;
        return this;
    }

    public UTF8Buffer topicName() {
        return this.topicName;
    }

    public PUBLISH topicName(UTF8Buffer uTF8Buffer) {
        this.topicName = uTF8Buffer;
        return this;
    }

    public String toString() {
        return "PUBLISH{dup=" + dup() + ", qos=" + qos() + ", retain=" + retain() + ", messageId=" + ((int) this.messageId) + ", topicName=" + this.topicName + ", payload=" + this.payload + AbstractJsonLexerKt.END_OBJ;
    }
}
