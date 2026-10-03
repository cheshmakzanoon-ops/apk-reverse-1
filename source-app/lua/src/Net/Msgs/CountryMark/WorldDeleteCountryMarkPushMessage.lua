local WorldDeleteCountryMarkPushMessage = BaseClass("WorldDeleteCountryMarkPushMessage", SFSBaseMessage)
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
    DataCenter.WorldFavoDataManager:OnDelCountryMark(t, true)
    EventManager:GetInstance():Broadcast(EventId.RefreshBookmark)
  end
end

WorldDeleteCountryMarkPushMessage.OnCreate = OnCreate
WorldDeleteCountryMarkPushMessage.HandleMessage = HandleMessage
return WorldDeleteCountryMarkPushMessage
