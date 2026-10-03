local GetCrossOccupyStationListMessage = BaseClass("GetCrossOccupyStationListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function GetCrossOccupyStationListMessage:OnCreate()
  base.OnCreate(self)
end

function GetCrossOccupyStationListMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    return
  end
  DataCenter.SeasonDataManager.GetCrossOccupyStationRewardInfo = t.rewardInfo
  DataCenter.SeasonDataManager.dailyStationOccupyNum = t.dailyOccupyNum
  DataCenter.SeasonDataManager.dailyStationOccupyMaxNum = t.dailyOccupyMaxNum
  DataCenter.SeasonDataManager.GetCrossOccupyStationList = t.list
  DataCenter.SeasonDataManager.GetCrossOccupyStationMaxNum = t.maxNum
  DataCenter.SeasonDataManager.CrossOccupyStationMaxNum = t.maxNum
  EventManager:GetInstance():Broadcast(EventId.GetCrossOccupyStationListUpdate)
end

return GetCrossOccupyStationListMessage
