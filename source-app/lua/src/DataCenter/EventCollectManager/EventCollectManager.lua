local EventCollectManager = BaseClass("EventCollectManager")

function EventCollectManager:__init()
  self.countClick = 0
  self.countChat = 0
  self.countBackGesture = 0
  self.countDubCheck = 0
  self.lastSyncTime = 0
  self.updateSecTimer = TimerManager:GetInstance():GetTimer(1, self.OnUpdateSec, self, false, false, false)
  self.updateSecTimer:Start()
  EventManager:GetInstance():AddListener(EventId.OnWorldInputPointDown, EventCollectManager.OnTouch)
  EventManager:GetInstance():AddListener(EventId.CHAT_SEND_ROOM_MSG_COMMAND, EventCollectManager.OnChat)
  EventManager:GetInstance():AddListener(EventId.OnAndroidNavigationGestureEscape, EventCollectManager.OnBackGesture)
end

function EventCollectManager:__delete()
  if self.updateSecTimer then
    self.updateSecTimer:Stop()
    self.updateSecTimer = nil
  end
  EventManager:GetInstance():RemoveListener(EventId.OnWorldInputPointDown, EventCollectManager.OnTouch)
  EventManager:GetInstance():RemoveListener(EventId.CHAT_SEND_ROOM_MSG_COMMAND, EventCollectManager.OnChat)
  EventManager:GetInstance():RemoveListener(EventId.OnAndroidNavigationGestureEscape, EventCollectManager.OnBackGesture)
end

function EventCollectManager:OnEnterGame()
end

function EventCollectManager:OnUpdateSec()
  local now = UITimeManager:GetInstance():GetServerTime()
  if self.lastSyncTime == nil or now - self.lastSyncTime > 180000 then
    PostEventLog.Track(PostEventLog.Defines.USER_ACTION_COLLECT, {
      act_action_count = self.countClick or 0,
      sendtime = self.countChat or 0,
      marktime = self.countBackGesture or 0,
      remain_count = self.countDubCheck or 0
    })
    self.countClick = 0
    self.countChat = 0
    self.countBackGesture = 0
    self.countDubCheck = 0
    self.lastSyncTime = now
  end
end

function EventCollectManager.OnTouch()
  DataCenter.EventCollectManager.countClick = 1 + toInt(DataCenter.EventCollectManager.countClick)
end

function EventCollectManager.OnChat()
  DataCenter.EventCollectManager.countChat = 1 + toInt(DataCenter.EventCollectManager.countChat)
end

function EventCollectManager.OnBackGesture()
  DataCenter.EventCollectManager.countBackGesture = 1 + toInt(DataCenter.EventCollectManager.countBackGesture)
end

function EventCollectManager.OnDubCheckAssetDownloaded()
  DataCenter.EventCollectManager.countDubCheck = 1 + toInt(DataCenter.EventCollectManager.countDubCheck)
end

local submitCache = {}

function EventCollectManager.OnDownloadStep(configId, nTotalProgress)
  if configId and nTotalProgress then
    local key = PostEventLog.Defines.SEASON_DOWN_COLLECT .. configId
    local now = UITimeManager:GetInstance():GetServerTime()
    local first_down = toInt(Setting:GetPrivateString(key))
    if nTotalProgress < 10 and first_down == 0 then
      Setting:SetPrivateString(key, tostring(now))
      PostEventLog.Track(PostEventLog.Defines.SEASON_DOWN_COLLECT, {
        sendtime = now,
        atk_num = 0,
        index = configId
      })
    elseif nTotalProgress == 25 or nTotalProgress == 50 or nTotalProgress == 75 then
      local need_submit = false
      if submitCache == nil then
        submitCache = {}
        need_submit = true
      elseif submitCache[configId] == nil then
        submitCache[configId] = {}
        need_submit = true
      elseif submitCache[configId][nTotalProgress] == nil then
        submitCache[configId][nTotalProgress] = now
        need_submit = true
      end
      if need_submit then
        PostEventLog.Track(PostEventLog.Defines.SEASON_DOWN_COLLECT, {
          sendtime = now,
          atk_num = nTotalProgress,
          index = configId
        })
      end
    end
  end
end

function EventCollectManager.OnDownloadFinish(configId)
  if configId then
    local now = UITimeManager:GetInstance():GetServerTime()
    PostEventLog.Track(PostEventLog.Defines.SEASON_DOWN_COLLECT, {
      sendtime = now,
      atk_num = 100,
      index = configId
    })
  end
end

return EventCollectManager
