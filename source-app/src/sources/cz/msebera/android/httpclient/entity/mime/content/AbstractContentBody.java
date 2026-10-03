package cz.msebera.android.httpclient.entity.mime.content;

import cz.msebera.android.httpclient.entity.ContentType;
import cz.msebera.android.httpclient.util.Args;
import java.nio.charset.Charset;

public abstract class AbstractContentBody implements ContentBody {
    private final ContentType contentType;

    public AbstractContentBody(ContentType contentType) {
        Args.notNull(contentType, "Content type");
        this.contentType = contentType;
    }

    @Deprecated
    public AbstractContentBody(String str) {
        this(ContentType.parse(str));
    }

    public ContentType getContentType() {
        return this.contentType;
    }

    @Override
    public String getMimeType() {
        return this.contentType.getMimeType();
    }

    @Override
    public String getMediaType() {
        String mimeType = this.contentType.getMimeType();
        int iIndexOf = mimeType.indexOf(47);
        return iIndexOf != -1 ? mimeType.substring(0, iIndexOf) : mimeType;
    }

    @Override
    public String getSubType() {
        String mimeType = this.contentType.getMimeType();
        int iIndexOf = mimeType.indexOf(47);
        if (iIndexOf != -1) {
            return mimeType.substring(iIndexOf + 1);
        }
        return null;
    }

    @Override
    public String getCharset() {
        Charset charset = this.contentType.getCharset();
        if (charset != null) {
            return charset.name();
        }
        return null;
    }
}
