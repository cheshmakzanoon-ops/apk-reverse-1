package com.google.common.p001io;

import com.google.common.base.Preconditions;
import java.io.BufferedOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.nio.charset.Charset;

@ElementTypesAreNonnullByDefault
public abstract class ByteSink {
    public abstract OutputStream openStream() throws IOException;

    protected ByteSink() {
    }

    public CharSink asCharSink(Charset charset) {
        return new AsCharSink(charset);
    }

    public OutputStream openBufferedStream() throws IOException {
        OutputStream outputStreamOpenStream = openStream();
        if (outputStreamOpenStream instanceof BufferedOutputStream) {
            return (BufferedOutputStream) outputStreamOpenStream;
        }
        return new BufferedOutputStream(outputStreamOpenStream);
    }

    public void write(byte[] bArr) throws Throwable {
        Preconditions.checkNotNull(bArr);
        Closer closerCreate = Closer.create();
        try {
            OutputStream outputStream = (OutputStream) closerCreate.register(openStream());
            outputStream.write(bArr);
            outputStream.flush();
            closerCreate.close();
        } catch (Throwable th) {
            try {
                throw closerCreate.rethrow(th);
            } catch (Throwable th2) {
                closerCreate.close();
                throw th2;
            }
        }
    }

    public long writeFrom(InputStream inputStream) throws Throwable {
        Preconditions.checkNotNull(inputStream);
        Closer closerCreate = Closer.create();
        try {
            OutputStream outputStream = (OutputStream) closerCreate.register(openStream());
            long jCopy = ByteStreams.copy(inputStream, outputStream);
            outputStream.flush();
            closerCreate.close();
            return jCopy;
        } catch (Throwable th) {
            try {
                throw closerCreate.rethrow(th);
            } catch (Throwable th2) {
                closerCreate.close();
                throw th2;
            }
        }
    }

    private final class AsCharSink extends CharSink {
        private final Charset charset;

        private AsCharSink(Charset charset) {
            this.charset = (Charset) Preconditions.checkNotNull(charset);
        }

        @Override
        public Writer openStream() throws IOException {
            return new OutputStreamWriter(ByteSink.this.openStream(), this.charset);
        }

        public String toString() {
            String string = ByteSink.this.toString();
            String strValueOf = String.valueOf(this.charset);
            StringBuilder sb = new StringBuilder(String.valueOf(string).length() + 13 + String.valueOf(strValueOf).length());
            sb.append(string);
            sb.append(".asCharSink(");
            sb.append(strValueOf);
            sb.append(")");
            return sb.toString();
        }
    }
}
