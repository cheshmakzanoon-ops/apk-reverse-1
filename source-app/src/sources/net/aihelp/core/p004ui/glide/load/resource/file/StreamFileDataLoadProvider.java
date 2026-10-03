package net.aihelp.core.p004ui.glide.load.resource.file;

import java.io.File;
import java.io.InputStream;
import net.aihelp.core.p004ui.glide.load.Encoder;
import net.aihelp.core.p004ui.glide.load.ResourceDecoder;
import net.aihelp.core.p004ui.glide.load.ResourceEncoder;
import net.aihelp.core.p004ui.glide.load.engine.Resource;
import net.aihelp.core.p004ui.glide.load.model.StreamEncoder;
import net.aihelp.core.p004ui.glide.load.resource.NullResourceEncoder;
import net.aihelp.core.p004ui.glide.provider.DataLoadProvider;

public class StreamFileDataLoadProvider implements DataLoadProvider<InputStream, File> {
    private static final ErrorSourceDecoder ERROR_DECODER = new ErrorSourceDecoder();
    private final ResourceDecoder<File, File> cacheDecoder = new FileDecoder();
    private final Encoder<InputStream> encoder = new StreamEncoder();

    @Override
    public ResourceDecoder<File, File> getCacheDecoder() {
        return this.cacheDecoder;
    }

    @Override
    public ResourceDecoder<InputStream, File> getSourceDecoder() {
        return ERROR_DECODER;
    }

    @Override
    public Encoder<InputStream> getSourceEncoder() {
        return this.encoder;
    }

    @Override
    public ResourceEncoder<File> getEncoder() {
        return NullResourceEncoder.get();
    }

    private static class ErrorSourceDecoder implements ResourceDecoder<InputStream, File> {
        private ErrorSourceDecoder() {
        }

        @Override
        public Resource<File> decode(InputStream inputStream, int i, int i2) {
            throw new Error("You cannot decode a File from an InputStream by default, try either #diskCacheStratey(DiskCacheStrategy.SOURCE) to avoid this call or #decoder(ResourceDecoder) to replace this Decoder");
        }

        @Override
        public String getId() {
            return "";
        }
    }
}
