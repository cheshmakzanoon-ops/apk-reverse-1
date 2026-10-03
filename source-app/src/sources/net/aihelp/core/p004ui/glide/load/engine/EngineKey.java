package net.aihelp.core.p004ui.glide.load.engine;

import java.io.UnsupportedEncodingException;
import java.nio.ByteBuffer;
import java.security.MessageDigest;
import net.aihelp.core.p004ui.glide.load.Encoder;
import net.aihelp.core.p004ui.glide.load.Key;
import net.aihelp.core.p004ui.glide.load.ResourceDecoder;
import net.aihelp.core.p004ui.glide.load.ResourceEncoder;
import net.aihelp.core.p004ui.glide.load.Transformation;
import net.aihelp.core.p004ui.glide.load.resource.transcode.ResourceTranscoder;

class EngineKey implements Key {
    private static final String EMPTY_LOG_STRING = "";
    private final ResourceDecoder cacheDecoder;
    private final ResourceDecoder decoder;
    private final ResourceEncoder encoder;
    private int hashCode;
    private final int height;

    private final String f87id;
    private Key originalKey;
    private final Key signature;
    private final Encoder sourceEncoder;
    private String stringKey;
    private final ResourceTranscoder transcoder;
    private final Transformation transformation;
    private final int width;

    public EngineKey(String str, Key key, int i, int i2, ResourceDecoder resourceDecoder, ResourceDecoder resourceDecoder2, Transformation transformation, ResourceEncoder resourceEncoder, ResourceTranscoder resourceTranscoder, Encoder encoder) {
        this.f87id = str;
        this.signature = key;
        this.width = i;
        this.height = i2;
        this.cacheDecoder = resourceDecoder;
        this.decoder = resourceDecoder2;
        this.transformation = transformation;
        this.encoder = resourceEncoder;
        this.transcoder = resourceTranscoder;
        this.sourceEncoder = encoder;
    }

    public Key getOriginalKey() {
        if (this.originalKey == null) {
            this.originalKey = new OriginalKey(this.f87id, this.signature);
        }
        return this.originalKey;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        EngineKey engineKey = (EngineKey) obj;
        if (!this.f87id.equals(engineKey.f87id) || !this.signature.equals(engineKey.signature) || this.height != engineKey.height || this.width != engineKey.width) {
            return false;
        }
        Transformation transformation = this.transformation;
        if ((transformation == null) ^ (engineKey.transformation == null)) {
            return false;
        }
        if (transformation != null && !transformation.getId().equals(engineKey.transformation.getId())) {
            return false;
        }
        ResourceDecoder resourceDecoder = this.decoder;
        if ((resourceDecoder == null) ^ (engineKey.decoder == null)) {
            return false;
        }
        if (resourceDecoder != null && !resourceDecoder.getId().equals(engineKey.decoder.getId())) {
            return false;
        }
        ResourceDecoder resourceDecoder2 = this.cacheDecoder;
        if ((resourceDecoder2 == null) ^ (engineKey.cacheDecoder == null)) {
            return false;
        }
        if (resourceDecoder2 != null && !resourceDecoder2.getId().equals(engineKey.cacheDecoder.getId())) {
            return false;
        }
        ResourceEncoder resourceEncoder = this.encoder;
        if ((resourceEncoder == null) ^ (engineKey.encoder == null)) {
            return false;
        }
        if (resourceEncoder != null && !resourceEncoder.getId().equals(engineKey.encoder.getId())) {
            return false;
        }
        ResourceTranscoder resourceTranscoder = this.transcoder;
        if ((resourceTranscoder == null) ^ (engineKey.transcoder == null)) {
            return false;
        }
        if (resourceTranscoder != null && !resourceTranscoder.getId().equals(engineKey.transcoder.getId())) {
            return false;
        }
        Encoder encoder = this.sourceEncoder;
        if ((encoder == null) ^ (engineKey.sourceEncoder == null)) {
            return false;
        }
        return encoder == null || encoder.getId().equals(engineKey.sourceEncoder.getId());
    }

    @Override
    public int hashCode() {
        if (this.hashCode == 0) {
            int iHashCode = this.f87id.hashCode();
            this.hashCode = iHashCode;
            int iHashCode2 = (((((iHashCode * 31) + this.signature.hashCode()) * 31) + this.width) * 31) + this.height;
            this.hashCode = iHashCode2;
            int i = iHashCode2 * 31;
            ResourceDecoder resourceDecoder = this.cacheDecoder;
            int iHashCode3 = i + (resourceDecoder != null ? resourceDecoder.getId().hashCode() : 0);
            this.hashCode = iHashCode3;
            int i2 = iHashCode3 * 31;
            ResourceDecoder resourceDecoder2 = this.decoder;
            int iHashCode4 = i2 + (resourceDecoder2 != null ? resourceDecoder2.getId().hashCode() : 0);
            this.hashCode = iHashCode4;
            int i3 = iHashCode4 * 31;
            Transformation transformation = this.transformation;
            int iHashCode5 = i3 + (transformation != null ? transformation.getId().hashCode() : 0);
            this.hashCode = iHashCode5;
            int i4 = iHashCode5 * 31;
            ResourceEncoder resourceEncoder = this.encoder;
            int iHashCode6 = i4 + (resourceEncoder != null ? resourceEncoder.getId().hashCode() : 0);
            this.hashCode = iHashCode6;
            int i5 = iHashCode6 * 31;
            ResourceTranscoder resourceTranscoder = this.transcoder;
            int iHashCode7 = i5 + (resourceTranscoder != null ? resourceTranscoder.getId().hashCode() : 0);
            this.hashCode = iHashCode7;
            int i6 = iHashCode7 * 31;
            Encoder encoder = this.sourceEncoder;
            this.hashCode = i6 + (encoder != null ? encoder.getId().hashCode() : 0);
        }
        return this.hashCode;
    }

    public String toString() {
        if (this.stringKey == null) {
            StringBuilder sb = new StringBuilder("EngineKey{");
            sb.append(this.f87id);
            sb.append('+');
            sb.append(this.signature);
            sb.append("+[");
            sb.append(this.width);
            sb.append('x');
            sb.append(this.height);
            sb.append("]+'");
            ResourceDecoder resourceDecoder = this.cacheDecoder;
            sb.append(resourceDecoder != null ? resourceDecoder.getId() : "");
            sb.append("'+'");
            ResourceDecoder resourceDecoder2 = this.decoder;
            sb.append(resourceDecoder2 != null ? resourceDecoder2.getId() : "");
            sb.append("'+'");
            Transformation transformation = this.transformation;
            sb.append(transformation != null ? transformation.getId() : "");
            sb.append("'+'");
            ResourceEncoder resourceEncoder = this.encoder;
            sb.append(resourceEncoder != null ? resourceEncoder.getId() : "");
            sb.append("'+'");
            ResourceTranscoder resourceTranscoder = this.transcoder;
            sb.append(resourceTranscoder != null ? resourceTranscoder.getId() : "");
            sb.append("'+'");
            Encoder encoder = this.sourceEncoder;
            sb.append(encoder != null ? encoder.getId() : "");
            sb.append("'}");
            this.stringKey = sb.toString();
        }
        return this.stringKey;
    }

    @Override
    public void updateDiskCacheKey(MessageDigest messageDigest) throws UnsupportedEncodingException {
        byte[] bArrArray = ByteBuffer.allocate(8).putInt(this.width).putInt(this.height).array();
        this.signature.updateDiskCacheKey(messageDigest);
        messageDigest.update(this.f87id.getBytes("UTF-8"));
        messageDigest.update(bArrArray);
        ResourceDecoder resourceDecoder = this.cacheDecoder;
        messageDigest.update((resourceDecoder != null ? resourceDecoder.getId() : "").getBytes("UTF-8"));
        ResourceDecoder resourceDecoder2 = this.decoder;
        messageDigest.update((resourceDecoder2 != null ? resourceDecoder2.getId() : "").getBytes("UTF-8"));
        Transformation transformation = this.transformation;
        messageDigest.update((transformation != null ? transformation.getId() : "").getBytes("UTF-8"));
        ResourceEncoder resourceEncoder = this.encoder;
        messageDigest.update((resourceEncoder != null ? resourceEncoder.getId() : "").getBytes("UTF-8"));
        Encoder encoder = this.sourceEncoder;
        messageDigest.update((encoder != null ? encoder.getId() : "").getBytes("UTF-8"));
    }
}
