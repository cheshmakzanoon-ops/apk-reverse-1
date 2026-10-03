local SeasonZoneTrainSetLootFilterMessage = BaseClass("SeasonZoneTrainSetLootFilterMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonZoneTrainSetLootFilterMessage:OnCreate(isOn)
  base.OnCreate(self)
  self.sfsObj:PutInt("status", isOn and 1 or 0)
end

function SeasonZoneTrainSetLootFilterMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.HSRDataManager:HandleFilter(t)
  end
end

return SeasonZoneTrainSetLootFilterMessage
