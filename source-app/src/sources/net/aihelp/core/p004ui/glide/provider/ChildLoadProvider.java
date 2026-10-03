package net.aihelp.core.p004ui.glide.provider;

import java.io.File;
import net.aihelp.core.p004ui.glide.load.Encoder;
import net.aihelp.core.p004ui.glide.load.ResourceDecoder;
import net.aihelp.core.p004ui.glide.load.ResourceEncoder;
import net.aihelp.core.p004ui.glide.load.model.ModelLoader;
import net.aihelp.core.p004ui.glide.load.resource.transcode.ResourceTranscoder;

public class ChildLoadProvider<A, T, Z, R> implements LoadProvider<A, T, Z, R>, Cloneable {
    private ResourceDecoder<File, Z> cacheDecoder;
    private ResourceEncoder<Z> encoder;
    private final LoadProvider<A, T, Z, R> parent;
    private ResourceDecoder<T, Z> sourceDecoder;
    private Encoder<T> sourceEncoder;
    private ResourceTranscoder<Z, R> transcoder;

    public ChildLoadProvider(LoadProvider<A, T, Z, R> loadProvider) {
        this.parent = loadProvider;
    }

    @Override
    public ModelLoader<A, T> getModelLoader() {
        return this.parent.getModelLoader();
    }

    public void setCacheDecoder(ResourceDecoder<File, Z> resourceDecoder) {
        this.cacheDecoder = resourceDecoder;
    }

    public void setSourceDecoder(ResourceDecoder<T, Z> resourceDecoder) {
        this.sourceDecoder = resourceDecoder;
    }

    public void setEncoder(ResourceEncoder<Z> resourceEncoder) {
        this.encoder = resourceEncoder;
    }

    public void setTranscoder(ResourceTranscoder<Z, R> resourceTranscoder) {
        this.transcoder = resourceTranscoder;
    }

    public void setSourceEncoder(Encoder<T> encoder) {
        this.sourceEncoder = encoder;
    }

    @Override
    public ResourceDecoder<File, Z> getCacheDecoder() {
        ResourceDecoder<File, Z> resourceDecoder = this.cacheDecoder;
        return resourceDecoder != null ? resourceDecoder : this.parent.getCacheDecoder();
    }

    @Override
    public ResourceDecoder<T, Z> getSourceDecoder() {
        ResourceDecoder<T, Z> resourceDecoder = this.sourceDecoder;
        return resourceDecoder != null ? resourceDecoder : this.parent.getSourceDecoder();
    }

    @Override
    public Encoder<T> getSourceEncoder() {
        Encoder<T> encoder = this.sourceEncoder;
        return encoder != null ? encoder : this.parent.getSourceEncoder();
    }

    @Override
    public ResourceEncoder<Z> getEncoder() {
        ResourceEncoder<Z> resourceEncoder = this.encoder;
        return resourceEncoder != null ? resourceEncoder : this.parent.getEncoder();
    }

    @Override
    public ResourceTranscoder<Z, R> getTranscoder() {
        ResourceTranscoder<Z, R> resourceTranscoder = this.transcoder;
        return resourceTranscoder != null ? resourceTranscoder : this.parent.getTranscoder();
    }

    public ChildLoadProvider<A, T, Z, R> clone() {
        try {
            return (ChildLoadProvider) super.clone();
        } catch (CloneNotSupportedException e) {
            throw new RuntimeException(e);
        }
    }
}
