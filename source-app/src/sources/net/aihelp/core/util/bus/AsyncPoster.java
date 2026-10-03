package net.aihelp.core.util.bus;

class AsyncPoster implements Runnable, Poster {
    private final EventBus eventBus;
    private final PendingPostQueue queue = new PendingPostQueue();

    AsyncPoster(EventBus eventBus) {
        this.eventBus = eventBus;
    }

    @Override
    public void enqueue(Subscription subscription, Object obj) {
        this.queue.enqueue(PendingPost.obtainPendingPost(subscription, obj));
        this.eventBus.getExecutorService().execute(this);
    }

    @Override
    public void run() {
        PendingPost pendingPostPoll = this.queue.poll();
        if (pendingPostPoll == null) {
            throw new IllegalStateException("No pending post available");
        }
        this.eventBus.invokeSubscriber(pendingPostPoll);
    }
}
