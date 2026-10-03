package com.caverock.androidsvg;

import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.graphics.Typeface;
import android.util.Log;
import coil.util.Utils;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.charset.Charset;
import java.util.HashSet;
import java.util.Set;

public class SimpleAssetResolver extends SVGExternalFileResolver {
    private static final String TAG = "SimpleAssetResolver";
    private static final Set<String> supportedFormats;
    private AssetManager assetManager;

    public SimpleAssetResolver(AssetManager assetManager) {
        this.assetManager = assetManager;
    }

    static {
        HashSet hashSet = new HashSet(8);
        supportedFormats = hashSet;
        hashSet.add("image/svg+xml");
        hashSet.add(Utils.MIME_TYPE_JPEG);
        hashSet.add("image/png");
        hashSet.add("image/pjpeg");
        hashSet.add("image/gif");
        hashSet.add("image/bmp");
        hashSet.add("image/x-windows-bmp");
        hashSet.add(Utils.MIME_TYPE_WEBP);
    }

    @Override
    public Typeface resolveFont(String str, int i, String str2) {
        Log.i(TAG, "resolveFont(" + str + "," + i + "," + str2 + ")");
        try {
            try {
                return Typeface.createFromAsset(this.assetManager, str + ".ttf");
            } catch (RuntimeException unused) {
                return null;
            }
        } catch (RuntimeException unused2) {
            return Typeface.createFromAsset(this.assetManager, str + ".otf");
        }
    }

    @Override
    public Bitmap resolveImage(String str) {
        Log.i(TAG, "resolveImage(" + str + ")");
        try {
            return BitmapFactory.decodeStream(this.assetManager.open(str));
        } catch (IOException unused) {
            return null;
        }
    }

    @Override
    public boolean isFormatSupported(String str) {
        return supportedFormats.contains(str);
    }

    @Override
    public String resolveCSSStyleSheet(String str) {
        Log.i(TAG, "resolveCSSStyleSheet(" + str + ")");
        return getAssetAsString(str);
    }

    private String getAssetAsString(String str) throws Throwable {
        Throwable th;
        InputStream inputStreamOpen;
        try {
            inputStreamOpen = this.assetManager.open(str);
            try {
                InputStreamReader inputStreamReader = new InputStreamReader(inputStreamOpen, Charset.forName("UTF-8"));
                char[] cArr = new char[4096];
                StringBuilder sb = new StringBuilder();
                for (int i = inputStreamReader.read(cArr); i > 0; i = inputStreamReader.read(cArr)) {
                    sb.append(cArr, 0, i);
                }
                String string = sb.toString();
                if (inputStreamOpen != null) {
                    try {
                        inputStreamOpen.close();
                    } catch (IOException unused) {
                    }
                }
                return string;
            } catch (IOException unused2) {
                if (inputStreamOpen != null) {
                    try {
                        inputStreamOpen.close();
                    } catch (IOException unused3) {
                    }
                }
                return null;
            } catch (Throwable th2) {
                th = th2;
                if (inputStreamOpen != null) {
                    try {
                        inputStreamOpen.close();
                    } catch (IOException unused4) {
                    }
                }
                throw th;
            }
        } catch (IOException unused5) {
            inputStreamOpen = null;
        } catch (Throwable th3) {
            th = th3;
            inputStreamOpen = null;
        }
    }
}
