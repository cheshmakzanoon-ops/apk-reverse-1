package net.aihelp.core.p004ui.glide.request.target;

import android.content.res.Resources;
import android.graphics.Canvas;
import android.graphics.ColorFilter;
import android.graphics.PorterDuff;
import android.graphics.Rect;
import android.graphics.drawable.Drawable;
import net.aihelp.core.p004ui.glide.load.resource.drawable.GlideDrawable;

public class SquaringDrawable extends GlideDrawable {
    private boolean mutated;
    private State state;
    private GlideDrawable wrapped;

    public SquaringDrawable(GlideDrawable glideDrawable, int i) {
        this(new State(glideDrawable.getConstantState(), i), glideDrawable, null);
    }

    SquaringDrawable(State state, GlideDrawable glideDrawable, Resources resources) {
        this.state = state;
        if (glideDrawable != null) {
            this.wrapped = glideDrawable;
        } else if (resources != null) {
            this.wrapped = (GlideDrawable) state.wrapped.newDrawable(resources);
        } else {
            this.wrapped = (GlideDrawable) state.wrapped.newDrawable();
        }
    }

    @Override
    public void setBounds(int i, int i2, int i3, int i4) {
        super.setBounds(i, i2, i3, i4);
        this.wrapped.setBounds(i, i2, i3, i4);
    }

    @Override
    public void setBounds(Rect rect) {
        super.setBounds(rect);
        this.wrapped.setBounds(rect);
    }

    @Override
    public void setChangingConfigurations(int i) {
        this.wrapped.setChangingConfigurations(i);
    }

    @Override
    public int getChangingConfigurations() {
        return this.wrapped.getChangingConfigurations();
    }

    @Override
    public void setDither(boolean z) {
        this.wrapped.setDither(z);
    }

    @Override
    public void setFilterBitmap(boolean z) {
        this.wrapped.setFilterBitmap(z);
    }

    @Override
    public Drawable.Callback getCallback() {
        return this.wrapped.getCallback();
    }

    @Override
    public int getAlpha() {
        return this.wrapped.getAlpha();
    }

    @Override
    public void setColorFilter(int i, PorterDuff.Mode mode) {
        this.wrapped.setColorFilter(i, mode);
    }

    @Override
    public void clearColorFilter() {
        this.wrapped.clearColorFilter();
    }

    @Override
    public Drawable getCurrent() {
        return this.wrapped.getCurrent();
    }

    @Override
    public boolean setVisible(boolean z, boolean z2) {
        return this.wrapped.setVisible(z, z2);
    }

    @Override
    public int getIntrinsicWidth() {
        return this.state.side;
    }

    @Override
    public int getIntrinsicHeight() {
        return this.state.side;
    }

    @Override
    public int getMinimumWidth() {
        return this.wrapped.getMinimumWidth();
    }

    @Override
    public int getMinimumHeight() {
        return this.wrapped.getMinimumHeight();
    }

    @Override
    public boolean getPadding(Rect rect) {
        return this.wrapped.getPadding(rect);
    }

    @Override
    public void invalidateSelf() {
        super.invalidateSelf();
        this.wrapped.invalidateSelf();
    }

    @Override
    public void unscheduleSelf(Runnable runnable) {
        super.unscheduleSelf(runnable);
        this.wrapped.unscheduleSelf(runnable);
    }

    @Override
    public void scheduleSelf(Runnable runnable, long j) {
        super.scheduleSelf(runnable, j);
        this.wrapped.scheduleSelf(runnable, j);
    }

    @Override
    public void draw(Canvas canvas) {
        this.wrapped.draw(canvas);
    }

    @Override
    public void setAlpha(int i) {
        this.wrapped.setAlpha(i);
    }

    @Override
    public void setColorFilter(ColorFilter colorFilter) {
        this.wrapped.setColorFilter(colorFilter);
    }

    @Override
    public int getOpacity() {
        return this.wrapped.getOpacity();
    }

    @Override
    public boolean isAnimated() {
        return this.wrapped.isAnimated();
    }

    @Override
    public void setLoopCount(int i) {
        this.wrapped.setLoopCount(i);
    }

    @Override
    public void start() {
        this.wrapped.start();
    }

    @Override
    public void stop() {
        this.wrapped.stop();
    }

    @Override
    public boolean isRunning() {
        return this.wrapped.isRunning();
    }

    @Override
    public Drawable mutate() {
        if (!this.mutated && super.mutate() == this) {
            this.wrapped = (GlideDrawable) this.wrapped.mutate();
            this.state = new State(this.state);
            this.mutated = true;
        }
        return this;
    }

    @Override
    public Drawable.ConstantState getConstantState() {
        return this.state;
    }

    static class State extends Drawable.ConstantState {
        private final int side;
        private final Drawable.ConstantState wrapped;

        @Override
        public int getChangingConfigurations() {
            return 0;
        }

        State(State state) {
            this(state.wrapped, state.side);
        }

        State(Drawable.ConstantState constantState, int i) {
            this.wrapped = constantState;
            this.side = i;
        }

        @Override
        public Drawable newDrawable() {
            return newDrawable(null);
        }

        @Override
        public Drawable newDrawable(Resources resources) {
            return new SquaringDrawable(this, null, resources);
        }
    }
}
