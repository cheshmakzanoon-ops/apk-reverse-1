local TrailTowerInfoMessage = BaseClass("TrailTowerInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function TrailTowerInfoMessage:OnCreate()
  base.OnCreate(self)
end

function TrailTowerInfoMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWTrailTowerManager:InitData(message)
  EventManager:GetInstance():Broadcast(EventId.GetTrailTowerInfo)
end

return TrailTowerInfoMessage
