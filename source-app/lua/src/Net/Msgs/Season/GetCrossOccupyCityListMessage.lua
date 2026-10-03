local GetCrossOccupyCityListMessage = BaseClass("GetCrossOccupyCityListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCrossOccupyCityListMessage:OnCreate()
  base.OnCreate(self)
end

function GetCrossOccupyCityListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonDataManager.CrossOccupyCityRewardInfo = t.rewardInfo
  DataCenter.AllianceBaseDataManager:UpdateResource(t.alResItem)
  DataCenter.SeasonDataManager.CrossOccupyCityList = t.list
  DataCenter.SeasonDataManager.dailyDeclareNum = t.allianceCityDeclareTimes
  if t.localMaxNum then
    DataCenter.SeasonDataManager.CrossOccupyCityMaxNumLocal = t.localMaxNum
  end
  if t.crossMaxNum then
    DataCenter.SeasonDataManager.CrossOccupyCityMaxNumOther = t.crossMaxNum
  end
  EventManager:GetInstance():Broadcast(EventId.LWSeasonCrossOccupyCityListUpdate)
  EventManager:GetInstance():Broadcast(EventId.DeclareWar)
end

return GetCrossOccupyCityListMessage
