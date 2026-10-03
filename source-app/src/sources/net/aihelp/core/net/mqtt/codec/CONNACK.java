package net.aihelp.core.net.mqtt.codec;

import java.io.IOException;
import java.net.ProtocolException;
import kotlinx.serialization.json.internal.AbstractJsonLexerKt;
import net.aihelp.core.net.mqtt.hawtbuf.DataByteArrayInputStream;
import net.aihelp.core.net.mqtt.hawtbuf.DataByteArrayOutputStream;

public class CONNACK implements MessageSupport.Message {
    public static final byte TYPE = 2;
    private Code code = Code.CONNECTION_ACCEPTED;

    public enum Code {
        CONNECTION_ACCEPTED,
        CONNECTION_REFUSED_UNACCEPTED_PROTOCOL_VERSION,
        CONNECTION_REFUSED_IDENTIFIER_REJECTED,
        CONNECTION_REFUSED_SERVER_UNAVAILABLE,
        CONNECTION_REFUSED_BAD_USERNAME_OR_PASSWORD,
        CONNECTION_REFUSED_NOT_AUTHORIZED
    }

    @Override
    public byte messageType() {
        return (byte) 2;
    }

    @Override
    public CONNACK mo1934decode(MQTTFrame mQTTFrame) throws ProtocolException {
        DataByteArrayInputStream dataByteArrayInputStream = new DataByteArrayInputStream(mQTTFrame.buffers[0]);
        dataByteArrayInputStream.skip(1);
        byte b = dataByteArrayInputStream.readByte();
        if (b >= Code.values().length) {
            throw new ProtocolException("Invalid CONNACK encoding");
        }
        this.code = Code.values()[b];
        return this;
    }

    @Override
    public MQTTFrame encode() {
        try {
            DataByteArrayOutputStream dataByteArrayOutputStream = new DataByteArrayOutputStream(2);
            dataByteArrayOutputStream.writeByte(0);
            dataByteArrayOutputStream.writeByte(this.code.ordinal());
            MQTTFrame mQTTFrame = new MQTTFrame();
            mQTTFrame.commandType(2);
            return mQTTFrame.buffer(dataByteArrayOutputStream.toBuffer());
        } catch (IOException unused) {
            throw new RuntimeException("The impossible happened");
        }
    }

    public Code code() {
        return this.code;
    }

    public CONNACK code(Code code) {
        this.code = code;
        return this;
    }

    public String toString() {
        return "CONNACK{code=" + this.code + AbstractJsonLexerKt.END_OBJ;
    }
}
