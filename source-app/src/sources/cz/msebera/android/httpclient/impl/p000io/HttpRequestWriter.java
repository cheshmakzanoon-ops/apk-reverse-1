package cz.msebera.android.httpclient.impl.p000io;

import cz.msebera.android.httpclient.HttpRequest;
import cz.msebera.android.httpclient.message.LineFormatter;
import cz.msebera.android.httpclient.p001io.SessionOutputBuffer;
import cz.msebera.android.httpclient.params.HttpParams;
import java.io.IOException;

@Deprecated
public class HttpRequestWriter extends AbstractMessageWriter<HttpRequest> {
    public HttpRequestWriter(SessionOutputBuffer sessionOutputBuffer, LineFormatter lineFormatter, HttpParams httpParams) {
        super(sessionOutputBuffer, lineFormatter, httpParams);
    }

    @Override
    public void writeHeadLine(HttpRequest httpRequest) throws IOException {
        this.lineFormatter.formatRequestLine(this.lineBuf, httpRequest.getRequestLine());
        this.sessionBuffer.writeLine(this.lineBuf);
    }
}
