package com.joke.basetoollib;

import android.content.Context;
import android.content.res.AssetManager;
import android.graphics.drawable.Drawable;
import java.io.IOException;
import java.io.InputStream;

public class LoadDrawableUtils {
    private static final LoadDrawableUtils INSTANCE = new LoadDrawableUtils();
    private Context context;

    public static LoadDrawableUtils getInstance() {
        return INSTANCE;
    }

    public void initContext(Context context) {
        this.context = context.getApplicationContext();
    }

    public Drawable getDrawable(String fileName) {
        if (this.context == null) {
            return null;
        }
        String assetName = fileName.startsWith("zkdrawable/") ? fileName : "zkdrawable/" + fileName;
        AssetManager assetManager = this.context.getAssets();
        try {
            InputStream inputStream = assetManager.open(assetName);
            try {
                Drawable drawableCreateFromStream = Drawable.createFromStream(inputStream, null);
                if (inputStream != null) {
                    inputStream.close();
                }
                return drawableCreateFromStream;
            } catch (Throwable th) {
                if (inputStream != null) {
                    try {
                        inputStream.close();
                    } catch (Throwable th2) {
                        th.addSuppressed(th2);
                    }
                }
                throw th;
            }
        } catch (IOException e) {
            return null;
        }
    }
}
