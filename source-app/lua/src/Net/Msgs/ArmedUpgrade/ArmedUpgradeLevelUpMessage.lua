local ArmedUpgradeLevelUpMessage = BaseClass("ArmedUpgradeLevelUpMessage", SFSBaseMessage)
local base = SFSBaseMessage

function ArmedUpgradeLevelUpMessage:OnCreate(targetLevel)
  base.OnCreate(self)
  self.sfsObj:PutInt("targetLevel", targetLevel)
end

function ArmedUpgradeLevelUpMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWArmedUpgradeManager:UpdateData(t)
  end
end

return ArmedUpgradeLevelUpMessage
