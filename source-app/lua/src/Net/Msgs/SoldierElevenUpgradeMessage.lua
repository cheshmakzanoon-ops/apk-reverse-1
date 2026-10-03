local SoldierElevenUpgradeMessage = BaseClass("SoldierElevenUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SoldierElevenUpgradeMessage:OnCreate(targetUpgradeProgressId)
  base.OnCreate(self)
  self.sfsObj:PutInt("progressId", targetUpgradeProgressId)
end

function SoldierElevenUpgradeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  elseif t.soldierElevenInfo then
    DataCenter.T11DataManager:UpdateT11LvData(t.soldierElevenInfo)
    EventManager:GetInstance():Broadcast(EventId.T11ProgressUpgradeSuccess)
  end
end

return SoldierElevenUpgradeMessage
