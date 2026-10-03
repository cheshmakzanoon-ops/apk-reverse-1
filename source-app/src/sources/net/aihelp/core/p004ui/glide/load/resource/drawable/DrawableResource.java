package net.aihelp.core.p004ui.glide.load.resource.drawable;

import android.graphics.drawable.Drawable;
import net.aihelp.core.p004ui.glide.load.engine.Resource;

public abstract class DrawableResource<T extends Drawable> implements Resource<T> {
    protected final T drawable;

    public DrawableResource(T t) {
        if (t == null) {
            throw new NullPointerException("Drawable must not be null!");
        }
        this.drawable = t;
    }

    @Override
    public final T get() {
        return (T) this.drawable.getConstantState().newDrawable();
    }
}
