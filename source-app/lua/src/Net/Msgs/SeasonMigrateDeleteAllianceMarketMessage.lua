local SeasonMigrateDeleteAllianceMarketMessage = BaseClass("SeasonMigrateDeleteAllianceMarketMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonMigrateDeleteAllianceMarketMessage:OnCreate(param)
  base.OnCreate(self)
end

function SeasonMigrateDeleteAllianceMarketMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActMigrationManager:OnHandleCancelPublishSelfAllianceMarketData(t)
  end
end

return SeasonMigrateDeleteAllianceMarketMessage
