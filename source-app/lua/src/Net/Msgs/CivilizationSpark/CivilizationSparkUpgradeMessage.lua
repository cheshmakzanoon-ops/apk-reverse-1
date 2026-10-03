local CivilizationSparkUpgradeMessage = BaseClass("CivilizationSparkUpgradeMessage", SFSBaseMessage)
local base = SFSBaseMessage

function CivilizationSparkUpgradeMessage:OnCreate(targetLevel)
  base.OnCreate(self)
  self.sfsObj:PutInt("targetLevel", targetLevel)
end

function CivilizationSparkUpgradeMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.LWCivilizationSparkManager:UpdateData(t)
  end
end

return CivilizationSparkUpgradeMessage
