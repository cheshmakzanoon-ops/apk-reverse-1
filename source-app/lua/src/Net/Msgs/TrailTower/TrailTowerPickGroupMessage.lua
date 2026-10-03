local TrailTowerPickGroupMessage = BaseClass("TrailTowerPickGroupMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

function TrailTowerPickGroupMessage:OnCreate(trailTowerId, level)
  base.OnCreate(self)
  self.sfsObj:PutInt("id", trailTowerId)
  self.sfsObj:PutInt("groupId", level)
end

function TrailTowerPickGroupMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  if message.errorCode ~= nil then
    UIUtil.ShowTips(Localization:GetString(message.errorCode))
    return
  end
  DataCenter.LWTrailTowerManager:RefreshTrailTowerLevelData(message)
  EventManager:GetInstance():Broadcast(EventId.TrailTowerPickGroup)
end

return TrailTowerPickGroupMessage
