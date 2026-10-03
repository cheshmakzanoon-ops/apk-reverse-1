package net.aihelp.core.p004ui.glide.load.engine;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import net.aihelp.core.p004ui.glide.load.Key;

class OriginalKey implements Key {

    private final String f88id;
    private final Key signature;

    public OriginalKey(String str, Key key) {
        this.f88id = str;
        this.signature = key;
    }

    @Override
    public boolean equals(Object obj) {
        if (this == obj) {
            return true;
        }
        if (obj == null || getClass() != obj.getClass()) {
            return false;
        }
        OriginalKey originalKey = (OriginalKey) obj;
        return this.f88id.equals(originalKey.f88id) && this.signature.equals(originalKey.signature);
    }

    @Override
    public int hashCode() {
        return (this.f88id.hashCode() * 31) + this.signature.hashCode();
    }

    @Override
    public void updateDiskCacheKey(MessageDigest messageDigest) throws UnsupportedEncodingException {
        messageDigest.update(this.f88id.getBytes("UTF-8"));
        this.signature.updateDiskCacheKey(messageDigest);
    }
}
