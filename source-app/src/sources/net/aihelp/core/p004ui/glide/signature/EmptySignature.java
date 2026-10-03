package net.aihelp.core.p004ui.glide.signature;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import net.aihelp.core.p004ui.glide.load.Key;

public final class EmptySignature implements Key {
    private static final EmptySignature EMPTY_KEY = new EmptySignature();

    @Override
    public void updateDiskCacheKey(MessageDigest messageDigest) throws UnsupportedEncodingException {
    }

    public static EmptySignature obtain() {
        return EMPTY_KEY;
    }

    private EmptySignature() {
    }
}
