package net.aihelp.core.net.mqtt.hawtbuf.codec;

import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.DataInput;
import java.io.DataOutput;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;

public class ObjectCodec<T> extends VariableCodec<T> {
    @Override
    public void encode(Object obj, DataOutput dataOutput) throws IOException {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        ObjectOutputStream objectOutputStream = new ObjectOutputStream(byteArrayOutputStream);
        objectOutputStream.writeObject(obj);
        objectOutputStream.close();
        byte[] byteArray = byteArrayOutputStream.toByteArray();
        dataOutput.writeInt(byteArray.length);
        dataOutput.write(byteArray);
    }

    @Override
    public T decode(DataInput dataInput) throws IOException {
        byte[] bArr = new byte[dataInput.readInt()];
        dataInput.readFully(bArr);
        try {
            return (T) new ObjectInputStream(new ByteArrayInputStream(bArr)).readObject();
        } catch (ClassNotFoundException e) {
            throw createIOException(e.getMessage(), e);
        }
    }

    private static IOException createIOException(String str, Throwable th) {
        IOException iOException = new IOException(str);
        iOException.initCause(th);
        return iOException;
    }
}
