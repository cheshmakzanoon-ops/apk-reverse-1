package net.aihelp.core.p004ui.glide.load.engine.cache;

import java.io.UnsupportedEncodingException;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import net.aihelp.core.p004ui.glide.load.Key;
import net.aihelp.core.p004ui.glide.util.LruCache;
import net.aihelp.core.p004ui.glide.util.Util;

class SafeKeyGenerator {
    private final LruCache<Key, String> loadIdToSafeHash = new LruCache<>(1000);

    SafeKeyGenerator() {
    }

    public String getSafeKey(Key key) {
        String strSha256BytesToHex;
        synchronized (this.loadIdToSafeHash) {
            strSha256BytesToHex = this.loadIdToSafeHash.get(key);
        }
        if (strSha256BytesToHex == null) {
            try {
                MessageDigest messageDigest = MessageDigest.getInstance("SHA-256");
                key.updateDiskCacheKey(messageDigest);
                strSha256BytesToHex = Util.sha256BytesToHex(messageDigest.digest());
            } catch (UnsupportedEncodingException e) {
                e.printStackTrace();
            } catch (NoSuchAlgorithmException e2) {
                e2.printStackTrace();
            }
            synchronized (this.loadIdToSafeHash) {
                this.loadIdToSafeHash.put(key, strSha256BytesToHex);
            }
        }
        return strSha256BytesToHex;
    }
}
