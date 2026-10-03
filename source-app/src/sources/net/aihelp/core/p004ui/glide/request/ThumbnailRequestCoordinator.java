package net.aihelp.core.p004ui.glide.request;

public class ThumbnailRequestCoordinator implements RequestCoordinator, Request {
    private RequestCoordinator coordinator;
    private Request full;
    private Request thumb;

    public ThumbnailRequestCoordinator() {
        this(null);
    }

    public ThumbnailRequestCoordinator(RequestCoordinator requestCoordinator) {
        this.coordinator = requestCoordinator;
    }

    public void setRequests(Request request, Request request2) {
        this.full = request;
        this.thumb = request2;
    }

    @Override
    public boolean canSetImage(Request request) {
        return parentCanSetImage() && (request.equals(this.full) || !this.full.isResourceSet());
    }

    private boolean parentCanSetImage() {
        RequestCoordinator requestCoordinator = this.coordinator;
        return requestCoordinator == null || requestCoordinator.canSetImage(this);
    }

    @Override
    public boolean canNotifyStatusChanged(Request request) {
        return parentCanNotifyStatusChanged() && request.equals(this.full) && !isAnyResourceSet();
    }

    private boolean parentCanNotifyStatusChanged() {
        RequestCoordinator requestCoordinator = this.coordinator;
        return requestCoordinator == null || requestCoordinator.canNotifyStatusChanged(this);
    }

    @Override
    public boolean isAnyResourceSet() {
        return parentIsAnyResourceSet() || isResourceSet();
    }

    @Override
    public void onRequestSuccess(Request request) {
        if (request.equals(this.thumb)) {
            return;
        }
        RequestCoordinator requestCoordinator = this.coordinator;
        if (requestCoordinator != null) {
            requestCoordinator.onRequestSuccess(this);
        }
        if (this.thumb.isComplete()) {
            return;
        }
        this.thumb.clear();
    }

    private boolean parentIsAnyResourceSet() {
        RequestCoordinator requestCoordinator = this.coordinator;
        return requestCoordinator != null && requestCoordinator.isAnyResourceSet();
    }

    @Override
    public void begin() {
        if (!this.thumb.isRunning()) {
            this.thumb.begin();
        }
        if (this.full.isRunning()) {
            return;
        }
        this.full.begin();
    }

    @Override
    public void pause() {
        this.full.pause();
        this.thumb.pause();
    }

    @Override
    public void clear() {
        this.thumb.clear();
        this.full.clear();
    }

    @Override
    public boolean isPaused() {
        return this.full.isPaused();
    }

    @Override
    public boolean isRunning() {
        return this.full.isRunning();
    }

    @Override
    public boolean isComplete() {
        return this.full.isComplete() || this.thumb.isComplete();
    }

    @Override
    public boolean isResourceSet() {
        return this.full.isResourceSet() || this.thumb.isResourceSet();
    }

    @Override
    public boolean isCancelled() {
        return this.full.isCancelled();
    }

    @Override
    public boolean isFailed() {
        return this.full.isFailed();
    }

    @Override
    public void recycle() {
        this.full.recycle();
        this.thumb.recycle();
    }
}
