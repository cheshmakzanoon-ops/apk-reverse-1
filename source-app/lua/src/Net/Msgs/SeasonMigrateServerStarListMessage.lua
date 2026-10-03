local SeasonMigrateServerStarListMessage = BaseClass("SeasonMigrateServerStarListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonMigrateServerStarListMessage:OnCreate()
  base.OnCreate(self)
end

function SeasonMigrateServerStarListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActMigrationManager:OnHandleServerStarList(t)
  end
end

return SeasonMigrateServerStarListMessage
