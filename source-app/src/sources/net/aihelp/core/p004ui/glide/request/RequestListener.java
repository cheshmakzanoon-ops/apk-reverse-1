package net.aihelp.core.p004ui.glide.request;

import net.aihelp.core.p004ui.glide.request.target.Target;

public interface RequestListener<T, R> {
    boolean onException(Exception exc, T t, Target<R> target, boolean z);

    boolean onResourceReady(R r, T t, Target<R> target, boolean z, boolean z2);
}
