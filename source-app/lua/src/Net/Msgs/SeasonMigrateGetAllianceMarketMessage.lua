local SeasonMigrateGetAllianceMarketMessage = BaseClass("SeasonMigrateGetAllianceMarketMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonMigrateGetAllianceMarketMessage:OnCreate(param)
  base.OnCreate(self)
end

function SeasonMigrateGetAllianceMarketMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActMigrationManager:OnHandleSelfAllianceMarketData(t)
  end
end

return SeasonMigrateGetAllianceMarketMessage
