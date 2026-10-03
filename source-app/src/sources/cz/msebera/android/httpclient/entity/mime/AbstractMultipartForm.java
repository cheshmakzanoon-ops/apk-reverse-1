package cz.msebera.android.httpclient.entity.mime;

import cz.msebera.android.httpclient.util.Args;
import cz.msebera.android.httpclient.util.ByteArrayBuffer;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.OutputStream;
import java.nio.ByteBuffer;
import java.nio.CharBuffer;
import java.nio.charset.Charset;
import java.util.Iterator;
import java.util.List;
import org.json.HTTP;

abstract class AbstractMultipartForm {
    private final String boundary;
    protected final Charset charset;
    private final String subType;
    private static final ByteArrayBuffer FIELD_SEP = encode(MIME.DEFAULT_CHARSET, ": ");
    private static final ByteArrayBuffer CR_LF = encode(MIME.DEFAULT_CHARSET, HTTP.CRLF);
    private static final ByteArrayBuffer TWO_DASHES = encode(MIME.DEFAULT_CHARSET, "--");

    protected abstract void formatMultipartHeader(FormBodyPart formBodyPart, OutputStream outputStream) throws IOException;

    public abstract List<FormBodyPart> getBodyParts();

    private static ByteArrayBuffer encode(Charset charset, String str) {
        ByteBuffer byteBufferEncode = charset.encode(CharBuffer.wrap(str));
        ByteArrayBuffer byteArrayBuffer = new ByteArrayBuffer(byteBufferEncode.remaining());
        byteArrayBuffer.append(byteBufferEncode.array(), byteBufferEncode.position(), byteBufferEncode.remaining());
        return byteArrayBuffer;
    }

    private static void writeBytes(ByteArrayBuffer byteArrayBuffer, OutputStream outputStream) throws IOException {
        outputStream.write(byteArrayBuffer.buffer(), 0, byteArrayBuffer.length());
    }

    private static void writeBytes(String str, Charset charset, OutputStream outputStream) throws IOException {
        writeBytes(encode(charset, str), outputStream);
    }

    private static void writeBytes(String str, OutputStream outputStream) throws IOException {
        writeBytes(encode(MIME.DEFAULT_CHARSET, str), outputStream);
    }

    protected static void writeField(MinimalField minimalField, OutputStream outputStream) throws IOException {
        writeBytes(minimalField.getName(), outputStream);
        writeBytes(FIELD_SEP, outputStream);
        writeBytes(minimalField.getBody(), outputStream);
        writeBytes(CR_LF, outputStream);
    }

    protected static void writeField(MinimalField minimalField, Charset charset, OutputStream outputStream) throws IOException {
        writeBytes(minimalField.getName(), charset, outputStream);
        writeBytes(FIELD_SEP, outputStream);
        writeBytes(minimalField.getBody(), charset, outputStream);
        writeBytes(CR_LF, outputStream);
    }

    public AbstractMultipartForm(String str, Charset charset, String str2) {
        Args.notNull(str, "Multipart subtype");
        Args.notNull(str2, "Multipart boundary");
        this.subType = str;
        this.charset = charset == null ? MIME.DEFAULT_CHARSET : charset;
        this.boundary = str2;
    }

    public AbstractMultipartForm(String str, String str2) {
        this(str, null, str2);
    }

    public String getSubType() {
        return this.subType;
    }

    public Charset getCharset() {
        return this.charset;
    }

    public String getBoundary() {
        return this.boundary;
    }

    void doWriteTo(OutputStream outputStream, boolean z) throws IOException {
        ByteArrayBuffer byteArrayBufferEncode = encode(this.charset, getBoundary());
        for (FormBodyPart formBodyPart : getBodyParts()) {
            writeBytes(TWO_DASHES, outputStream);
            writeBytes(byteArrayBufferEncode, outputStream);
            ByteArrayBuffer byteArrayBuffer = CR_LF;
            writeBytes(byteArrayBuffer, outputStream);
            formatMultipartHeader(formBodyPart, outputStream);
            writeBytes(byteArrayBuffer, outputStream);
            if (z) {
                formBodyPart.getBody().writeTo(outputStream);
            }
            writeBytes(byteArrayBuffer, outputStream);
        }
        ByteArrayBuffer byteArrayBuffer2 = TWO_DASHES;
        writeBytes(byteArrayBuffer2, outputStream);
        writeBytes(byteArrayBufferEncode, outputStream);
        writeBytes(byteArrayBuffer2, outputStream);
        writeBytes(CR_LF, outputStream);
    }

    public void writeTo(OutputStream outputStream) throws IOException {
        doWriteTo(outputStream, true);
    }

    public long getTotalLength() {
        Iterator<FormBodyPart> it = getBodyParts().iterator();
        long j = 0;
        while (it.hasNext()) {
            long contentLength = it.next().getBody().getContentLength();
            if (contentLength < 0) {
                return -1L;
            }
            j += contentLength;
        }
        ByteArrayOutputStream byteArrayOutputStream = new ByteArrayOutputStream();
        try {
            doWriteTo(byteArrayOutputStream, false);
            return j + ((long) byteArrayOutputStream.toByteArray().length);
        } catch (IOException unused) {
            return -1L;
        }
    }
}
