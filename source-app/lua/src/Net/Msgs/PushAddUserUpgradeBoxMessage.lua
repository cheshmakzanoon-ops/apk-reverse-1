local PushAddUserUpgradeBoxMessage = BaseClass("PushAddUserUpgradeBoxMessage", SFSBaseMessage)
local base = SFSBaseMessage

function PushAddUserUpgradeBoxMessage:OnCreate(param)
  base.OnCreate(self)
end

function PushAddUserUpgradeBoxMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.UpgradeTreasureBoxManager:OnReceiveOneUpgradeTreasureBoxInfo(t)
  end
end

return PushAddUserUpgradeBoxMessage
