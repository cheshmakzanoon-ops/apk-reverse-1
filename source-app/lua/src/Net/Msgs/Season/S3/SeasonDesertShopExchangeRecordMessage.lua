local SeasonDesertShopExchangeRecordMessage = BaseClass("SeasonDesertShopExchangeRecordMessage", SFSBaseMessage)
local base = SFSBaseMessage

function SeasonDesertShopExchangeRecordMessage:OnCreate(activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

function SeasonDesertShopExchangeRecordMessage:HandleMessage(t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    local data = DataCenter.ActivityListDataManager:GetActivityDataById(t.activityId)
    if data then
      data:InitShopExchangeRecord(t.recordArr)
      EventManager:GetInstance():Broadcast(EventId.InitDesertShopRecordData)
    end
  end
end

return SeasonDesertShopExchangeRecordMessage
