package cz.msebera.android.httpclient.impl.p000io;

import cz.msebera.android.httpclient.p001io.EofSensor;
import cz.msebera.android.httpclient.params.HttpParams;
import cz.msebera.android.httpclient.util.Args;
import java.io.IOException;
import java.net.Socket;

@Deprecated
public class SocketInputBuffer extends AbstractSessionInputBuffer implements EofSensor {
    private boolean eof;
    private final Socket socket;

    public SocketInputBuffer(Socket socket, int i, HttpParams httpParams) throws IOException {
        Args.notNull(socket, "Socket");
        this.socket = socket;
        this.eof = false;
        i = i < 0 ? socket.getReceiveBufferSize() : i;
        init(socket.getInputStream(), i < 1024 ? 1024 : i, httpParams);
    }

    @Override
    protected int fillBuffer() throws IOException {
        int iFillBuffer = super.fillBuffer();
        this.eof = iFillBuffer == -1;
        return iFillBuffer;
    }

    @Override
    public boolean isDataAvailable(int i) throws IOException {
        boolean zHasBufferedData = hasBufferedData();
        if (zHasBufferedData) {
            return zHasBufferedData;
        }
        int soTimeout = this.socket.getSoTimeout();
        try {
            this.socket.setSoTimeout(i);
            fillBuffer();
            return hasBufferedData();
        } finally {
            this.socket.setSoTimeout(soTimeout);
        }
    }

    @Override
    public boolean isEof() {
        return this.eof;
    }
}
