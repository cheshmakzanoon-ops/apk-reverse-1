package net.aihelp.core.p004ui.glide.util;

import java.util.Arrays;
import net.aihelp.core.p004ui.glide.ListPreloader;

public class FixedPreloadSizeProvider<T> implements ListPreloader.PreloadSizeProvider<T> {
    private final int[] size;

    public FixedPreloadSizeProvider(int i, int i2) {
        this.size = new int[]{i, i2};
    }

    @Override
    public int[] getPreloadSize(T t, int i, int i2) {
        int[] iArr = this.size;
        return Arrays.copyOf(iArr, iArr.length);
    }
}
