package cz.msebera.android.httpclient.impl.p000io;

import cz.msebera.android.httpclient.HttpResponse;
import cz.msebera.android.httpclient.message.LineFormatter;
import cz.msebera.android.httpclient.p001io.SessionOutputBuffer;
import cz.msebera.android.httpclient.params.HttpParams;
import java.io.IOException;

@Deprecated
public class HttpResponseWriter extends AbstractMessageWriter<HttpResponse> {
    public HttpResponseWriter(SessionOutputBuffer sessionOutputBuffer, LineFormatter lineFormatter, HttpParams httpParams) {
        super(sessionOutputBuffer, lineFormatter, httpParams);
    }

    @Override
    public void writeHeadLine(HttpResponse httpResponse) throws IOException {
        this.lineFormatter.formatStatusLine(this.lineBuf, httpResponse.getStatusLine());
        this.sessionBuffer.writeLine(this.lineBuf);
    }
}
