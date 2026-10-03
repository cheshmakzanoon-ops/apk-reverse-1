local SeasonMigrateSaveAllianceMarketMessage = BaseClass("SeasonMigrateSaveAllianceMarketMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonMigrateSaveAllianceMarketMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("allianceId", param.allianceId)
  self.sfsObj:PutInt("type", param.type)
end

function SeasonMigrateSaveAllianceMarketMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActMigrationManager:OnHandleSaveAllianceMarket(t)
  end
end

return SeasonMigrateSaveAllianceMarketMessage
