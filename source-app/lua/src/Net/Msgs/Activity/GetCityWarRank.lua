local GetCityWarRank = BaseClass("GetCityWarRank", SFSBaseMessage)
local base = SFSBaseMessage

function GetCityWarRank:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("activityId", activityId)
end

function GetCityWarRank:HandleMessage(data)
  base.HandleMessage(self, data)
  if data.errorCode ~= nil then
    print(data.errorCode)
    if data.errorMsg ~= nil then
      print(data.errorMsg)
    end
    UIUtil.ShowTipsId(data.errorCode)
    return
  end
  if data ~= nil then
    DataCenter.ActivityAttackCityDataManager:UpdateRankData(data)
    EventManager:GetInstance():Broadcast(EventId.ActivityAttackCityRankDataUpdate)
  end
end

return GetCityWarRank
