local SeasonRefreshLootZoneTrainInfoMessage = BaseClass("SeasonRefreshLootZoneTrainInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonRefreshLootZoneTrainInfoMessage:OnCreate(param)
  base.OnCreate(self)
end

function SeasonRefreshLootZoneTrainInfoMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    DataCenter.HSRDataManager:ClearVictimList()
  else
    DataCenter.HSRDataManager:HandleVictimList(t)
  end
end

return SeasonRefreshLootZoneTrainInfoMessage
