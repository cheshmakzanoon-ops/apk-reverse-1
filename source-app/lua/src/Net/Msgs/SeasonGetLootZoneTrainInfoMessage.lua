local SeasonGetLootZoneTrainInfoMessage = BaseClass("SeasonGetLootZoneTrainInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonGetLootZoneTrainInfoMessage:OnCreate(trainUuid)
  base.OnCreate(self)
  self.sfsObj:PutLong("uuid", trainUuid)
end

function SeasonGetLootZoneTrainInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.HSRDataManager:ClearVictimList()
  else
    DataCenter.HSRDataManager:HandleVictimList(t)
  end
end

return SeasonGetLootZoneTrainInfoMessage
