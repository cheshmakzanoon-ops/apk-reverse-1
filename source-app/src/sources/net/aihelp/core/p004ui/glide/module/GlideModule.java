package net.aihelp.core.p004ui.glide.module;

import android.content.Context;
import net.aihelp.core.p004ui.glide.Glide;
import net.aihelp.core.p004ui.glide.GlideBuilder;

public interface GlideModule {
    void applyOptions(Context context, GlideBuilder glideBuilder);

    void registerComponents(Context context, Glide glide);
}
