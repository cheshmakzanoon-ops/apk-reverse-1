package net.aihelp.core.p004ui.glide.load.engine.bitmap_recycle;

import android.graphics.Bitmap;

public class BitmapPoolAdapter implements BitmapPool {
    @Override
    public void clearMemory() {
    }

    @Override
    public Bitmap get(int i, int i2, Bitmap.Config config) {
        return null;
    }

    @Override
    public Bitmap getDirty(int i, int i2, Bitmap.Config config) {
        return null;
    }

    @Override
    public int getMaxSize() {
        return 0;
    }

    @Override
    public boolean put(Bitmap bitmap) {
        return false;
    }

    @Override
    public void setSizeMultiplier(float f) {
    }

    @Override
    public void trimMemory(int i) {
    }
}
