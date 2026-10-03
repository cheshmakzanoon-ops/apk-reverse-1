local GetCityWarTarget = BaseClass("GetCityWarTarget", SFSBaseMessage)
local base = SFSBaseMessage

function GetCityWarTarget:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutUtfString("activityId", activityId)
end

function GetCityWarTarget:HandleMessage(data)
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
    DataCenter.ActivityAttackCityDataManager:UpdateTaskData(data)
    EventManager:GetInstance():Broadcast(EventId.ActivityAttackCityTaskDataUpdate)
  end
end

return GetCityWarTarget
