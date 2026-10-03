package net.aihelp.core.net.mqtt.codec;

import java.io.IOException;
import java.net.ProtocolException;
import java.util.Arrays;
import kotlinx.serialization.json.internal.AbstractJsonLexerKt;
import net.aihelp.core.net.mqtt.hawtbuf.DataByteArrayInputStream;
import net.aihelp.core.net.mqtt.hawtbuf.DataByteArrayOutputStream;

public class SUBACK implements MessageSupport.Message {
    public static final byte[] NO_GRANTED_QOS = new byte[0];
    public static final byte TYPE = 9;
    private byte[] grantedQos = NO_GRANTED_QOS;
    private short messageId;

    @Override
    public byte messageType() {
        return (byte) 9;
    }

    @Override
    public SUBACK mo1934decode(MQTTFrame mQTTFrame) throws ProtocolException {
        DataByteArrayInputStream dataByteArrayInputStream = new DataByteArrayInputStream(mQTTFrame.buffers[0]);
        this.messageId = dataByteArrayInputStream.readShort();
        this.grantedQos = dataByteArrayInputStream.readBuffer(dataByteArrayInputStream.available()).toByteArray();
        return this;
    }

    @Override
    public MQTTFrame encode() {
        try {
            DataByteArrayOutputStream dataByteArrayOutputStream = new DataByteArrayOutputStream(this.grantedQos.length + 2);
            dataByteArrayOutputStream.writeShort(this.messageId);
            dataByteArrayOutputStream.write(this.grantedQos);
            MQTTFrame mQTTFrame = new MQTTFrame();
            mQTTFrame.commandType(9);
            return mQTTFrame.buffer(dataByteArrayOutputStream.toBuffer());
        } catch (IOException unused) {
            throw new RuntimeException("The impossible happened");
        }
    }

    public byte[] grantedQos() {
        return this.grantedQos;
    }

    public SUBACK grantedQos(byte[] bArr) {
        this.grantedQos = bArr;
        return this;
    }

    public short messageId() {
        return this.messageId;
    }

    public SUBACK messageId(short s) {
        this.messageId = s;
        return this;
    }

    public String toString() {
        return "SUBACK{grantedQos=" + Arrays.toString(this.grantedQos) + ", messageId=" + ((int) this.messageId) + AbstractJsonLexerKt.END_OBJ;
    }
}
