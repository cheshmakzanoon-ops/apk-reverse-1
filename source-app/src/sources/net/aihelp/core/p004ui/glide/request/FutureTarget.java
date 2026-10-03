package net.aihelp.core.p004ui.glide.request;

import java.util.concurrent.Future;
import net.aihelp.core.p004ui.glide.request.target.Target;

public interface FutureTarget<R> extends Future<R>, Target<R> {
    void clear();
}
