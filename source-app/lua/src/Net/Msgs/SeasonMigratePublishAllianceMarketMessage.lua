local SeasonMigratePublishAllianceMarketMessage = BaseClass("SeasonMigratePublishAllianceMarketMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonMigratePublishAllianceMarketMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("notice", param.notice)
  self.sfsObj:PutUtfString("tags", param.tags)
  if param.desertTime then
    self.sfsObj:PutInt("desertTime", param.desertTime)
  end
  if param.identifyFlag then
    self.sfsObj:PutInt("identifyFlag", param.identifyFlag)
  end
end

function SeasonMigratePublishAllianceMarketMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    if t.errorPara2 then
      local tipText = CS.GameEntry.Localization:GetString(errCode, t.errorPara2[1])
      UIUtil.ShowTips(tipText)
    else
      UIUtil.ShowTipsId(errCode)
    end
  else
    DataCenter.ActMigrationManager:OnHandlePublishSelfAllianceMarketData(t)
  end
end

return SeasonMigratePublishAllianceMarketMessage
