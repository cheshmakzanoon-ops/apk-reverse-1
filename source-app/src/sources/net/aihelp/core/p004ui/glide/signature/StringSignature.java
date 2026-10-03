package net.aihelp.core.p004ui.glide.signature;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import net.aihelp.core.p004ui.glide.load.Key;

public class StringSignature implements Key {
    private final String signature;

    public StringSignature(String str) {
        if (str == null) {
            throw new NullPointerException("Signature cannot be null!");
        }
        this.signature = str;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        return this.signature.equals(((StringSignature) obj).signature);
    }

    @Override
    public int hashCode() {
        return this.signature.hashCode();
    }

    @Override
    public void updateDiskCacheKey(MessageDigest messageDigest) throws UnsupportedEncodingException {
        messageDigest.update(this.signature.getBytes("UTF-8"));
    }

    public String toString() {
        return "StringSignature{signature='" + this.signature + "'}";
    }
}
