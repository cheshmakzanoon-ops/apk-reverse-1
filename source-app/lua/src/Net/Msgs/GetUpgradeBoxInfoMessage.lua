local GetUpgradeBoxInfoMessage = BaseClass("GetUpgradeBoxInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetUpgradeBoxInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function GetUpgradeBoxInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.UpgradeTreasureBoxManager:OnRecAllUpgradeTreasureBox(t)
    EventManager:GetInstance():Broadcast(EventId.RefreshAutoUpgradeTreasureBoxNum, false)
  end
end

return GetUpgradeBoxInfoMessage
