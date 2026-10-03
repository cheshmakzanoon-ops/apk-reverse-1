local SeasonMigrateServerStarDetailMessage = BaseClass("SeasonMigrateServerStarDetailMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonMigrateServerStarDetailMessage:OnCreate(serverId)
  base.OnCreate(self)
  self.sfsObj:PutInt("serverId", serverId)
end

function SeasonMigrateServerStarDetailMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActMigrationManager:OnHandleServerStarDetail(t)
  end
end

return SeasonMigrateServerStarDetailMessage
