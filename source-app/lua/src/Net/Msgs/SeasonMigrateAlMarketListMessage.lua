local SeasonMigrateAlMarketListMessage = BaseClass("SeasonMigrateAlMarketListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonMigrateAlMarketListMessage:OnCreate(param)
  base.OnCreate(self)
  self.sfsObj:PutInt("startIndex", param.startIndex)
  self.sfsObj:PutInt("num", param.num)
  self.sfsObj:PutUtfString("searchName", param.searchName)
  self.sfsObj:PutUtfString("searchTag", param.searchTag)
  self.sfsObj:PutUtfString("searchLanguage", param.searchLanguage)
  self.sfsObj:PutInt("saveTag", param.saveTag)
  if param.comprehensiveScore then
    self.sfsObj:PutInt("comprehensiveScore", param.comprehensiveScore)
  end
  if param.desertTime then
    self.sfsObj:PutInt("desertTime", param.desertTime)
  end
end

function SeasonMigrateAlMarketListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActMigrationManager:OnHandleAllianceMarketListData(t)
  end
end

return SeasonMigrateAlMarketListMessage
