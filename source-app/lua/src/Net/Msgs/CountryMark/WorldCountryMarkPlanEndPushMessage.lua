local WorldCountryMarkPlanEndPushMessage = BaseClass("WorldCountryMarkPlanEndPushMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldFavoDataManager:HandleAddCountryMarkMessage(t, true)
    EventManager:GetInstance():Broadcast(EventId.RefreshBookmark)
  end
end

WorldCountryMarkPlanEndPushMessage.OnCreate = OnCreate
WorldCountryMarkPlanEndPushMessage.HandleMessage = HandleMessage
return WorldCountryMarkPlanEndPushMessage
