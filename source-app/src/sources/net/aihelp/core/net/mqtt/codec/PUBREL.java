package net.aihelp.core.net.mqtt.codec;

import java.io.IOException;
import java.net.ProtocolException;
import kotlinx.serialization.json.internal.AbstractJsonLexerKt;
import net.aihelp.core.net.mqtt.client.QoS;
import net.aihelp.core.net.mqtt.hawtbuf.DataByteArrayInputStream;
import net.aihelp.core.net.mqtt.hawtbuf.DataByteArrayOutputStream;

public class PUBREL extends MessageSupport.HeaderBase implements MessageSupport.Message, MessageSupport.Acked {
    public static final byte TYPE = 6;
    private short messageId;

    @Override
    public byte messageType() {
        return (byte) 6;
    }

    public PUBREL() {
        qos(QoS.AT_LEAST_ONCE);
    }

    @Override
    public PUBREL mo1934decode(MQTTFrame mQTTFrame) throws ProtocolException {
        header(mQTTFrame.header());
        this.messageId = new DataByteArrayInputStream(mQTTFrame.buffers[0]).readShort();
        return this;
    }

    @Override
    public MQTTFrame encode() {
        try {
            DataByteArrayOutputStream dataByteArrayOutputStream = new DataByteArrayOutputStream(2);
            dataByteArrayOutputStream.writeShort(this.messageId);
            MQTTFrame mQTTFrame = new MQTTFrame();
            mQTTFrame.header(header());
            mQTTFrame.commandType(6);
            return mQTTFrame.buffer(dataByteArrayOutputStream.toBuffer());
        } catch (IOException unused) {
            throw new RuntimeException("The impossible happened");
        }
    }

    @Override
    public boolean dup() {
        return super.dup();
    }

    @Override
    public PUBREL dup(boolean z) {
        return (PUBREL) super.dup(z);
    }

    @Override
    public QoS qos() {
        return super.qos();
    }

    @Override
    public short messageId() {
        return this.messageId;
    }

    @Override
    public PUBREL messageId(short s) {
        this.messageId = s;
        return this;
    }

    public String toString() {
        return "PUBREL{dup=" + dup() + ", qos=" + qos() + ", messageId=" + ((int) this.messageId) + AbstractJsonLexerKt.END_OBJ;
    }
}
