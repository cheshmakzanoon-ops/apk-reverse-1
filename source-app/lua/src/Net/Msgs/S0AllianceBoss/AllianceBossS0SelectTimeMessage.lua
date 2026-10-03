local AllianceBossS0SelectTimeMessage = BaseClass("AllianceBossS0SelectTimeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function AllianceBossS0SelectTimeMessage:OnCreate(startTime, difficulty)
  base.OnCreate(self)
  self.sfsObj:PutLong("startTime", startTime)
  self.sfsObj:PutInt("difficulty", difficulty)
end

function AllianceBossS0SelectTimeMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  EventManager:GetInstance():Broadcast(EventId.OnS0AllianceBossOnSelectLevel, message)
  local errorCode = message.errorCode
  if errorCode ~= nil then
    UIUtil.ShowTipsId(errorCode)
    return
  end
  DataCenter.S0AllianceBossDataManager:MarkAppointChanged(true)
end

return AllianceBossS0SelectTimeMessage
