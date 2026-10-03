package cz.msebera.android.httpclient.entity;

import cz.msebera.android.httpclient.util.Args;
import java.io.ByteArrayInputStream;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.ObjectOutputStream;
import java.io.OutputStream;
import java.io.Serializable;

public class SerializableEntity extends AbstractHttpEntity {
    private Serializable objRef;
    private byte[] objSer;

    @Override
    public boolean isRepeatable() {
        return true;
    }

    public SerializableEntity(Serializable serializable, boolean z) throws IOException {
        Args.notNull(serializable, "Source object");
        if (z) {
            createBytes(serializable);
        } else {
            this.objRef = serializable;
        }
    }

    public SerializableEntity(Serializable serializable) {
        Args.notNull(serializable, "Source object");
        this.objRef = serializable;
    }

    private void createBytes(Serializable serializable) throws IOException {
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        ObjectOutputStream objectOutputStream = new ObjectOutputStream(byteArrayOutputStream);
        objectOutputStream.writeObject(serializable);
        objectOutputStream.flush();
        this.objSer = byteArrayOutputStream.toByteArray();
    }

    @Override
    public InputStream getContent() throws IllegalStateException, IOException {
        if (this.objSer == null) {
            createBytes(this.objRef);
        }
        return new ByteArrayInputStream(this.objSer);
    }

    @Override
    public long getContentLength() {
        byte[] bArr = this.objSer;
        if (bArr == null) {
            return -1L;
        }
        return bArr.length;
    }

    @Override
    public boolean isStreaming() {
        return this.objSer == null;
    }

    @Override
    public void writeTo(OutputStream outputStream) throws IOException {
        Args.notNull(outputStream, "Output stream");
        byte[] bArr = this.objSer;
        if (bArr == null) {
            ObjectOutputStream objectOutputStream = new ObjectOutputStream(outputStream);
            objectOutputStream.writeObject(this.objRef);
            objectOutputStream.flush();
        } else {
            outputStream.write(bArr);
            outputStream.flush();
        }
    }
}
