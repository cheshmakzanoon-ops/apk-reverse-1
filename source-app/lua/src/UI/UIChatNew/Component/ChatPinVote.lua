local ChatPinVote = BaseClass("ChatPinVote", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local countStr = "%s:%s/%s[%s]"

function ChatPinVote:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

function ChatPinVote:DataDefine()
end

function ChatPinVote:ComponentDefine()
  self.title = self:AddComponent(UIText, "title")
  self.countText = self:AddComponent(UIText, "countText")
  self.endTimeText = self:AddComponent(UIText, "endTimeText")
end

function ChatPinVote:ReInit(data)
  self.data = data
  if not data.voteData then
    return
  end
  local str = data.voteData.titleTrans or data.voteData.voteInfo.title
  self.title:SetText(str)
  local options = self.data.voteData.voteInfo.options
  local isTotal = false
  for i = 1, #options do
    if options[i].isTotal then
      isTotal = true
    end
  end
  local str = isTotal and "poll_participate" or "poll_not_participate"
  self.countText:SetText(string.format(countStr, Localization:GetString("poll_user_number"), data.voteData.voteResult.count, data.voteData.total, Localization:GetString(str)))
  self:RefreshTime()
  if not self:GetIsEnd() then
    self:StopTimer()
    self:AddTimer()
  end
end

function ChatPinVote:GetIsEnd()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = self.data.voteData.endTime - curTime
  return time < 0
end

function ChatPinVote:RefreshTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local time = self.data.voteData.endTime - curTime
  if 0 < time then
    self.endTimeText:SetText(Localization:GetString("poll_end_count") .. ":" .. UITimeManager:GetInstance():MilliSecondToFmtString(time))
  else
    self.endTimeText:SetLocalText("poll_end")
    self:StopTimer()
    self:OnTimeEnd()
  end
end

function ChatPinVote:OnTimeEnd()
end

function ChatPinVote:OnDisable()
  self:StopTimer()
end

function ChatPinVote:AddTimer()
  if self.timer == nil then
    function self.timer_action()
      self:RefreshTime()
    end
    
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function ChatPinVote:StopTimer()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
end

function ChatPinVote:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ChatPinVote:DataDestroy()
end

function ChatPinVote:ComponentDestroy()
  self:StopTimer()
  self.title = nil
  self.countText = nil
  self.endTimeText = nil
end

return ChatPinVote
