package net.aihelp.core.net.mqtt.hawtbuf.codec;

import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;

public class StringCodec implements Codec<String> {
    public static final StringCodec INSTANCE = new StringCodec();

    @Override
    public String deepCopy(String str) {
        return str;
    }

    @Override
    public int getFixedSize() {
        return -1;
    }

    @Override
    public boolean isDeepCopySupported() {
        return true;
    }

    @Override
    public boolean isEstimatedSizeSupported() {
        return true;
    }

    @Override
    public void encode(String str, DataOutput dataOutput) throws IOException {
        dataOutput.writeUTF(str);
    }

    @Override
    public String decode(DataInput dataInput) throws IOException {
        return dataInput.readUTF();
    }

    @Override
    public int estimatedSize(String str) {
        return str.length() + 2;
    }
}
