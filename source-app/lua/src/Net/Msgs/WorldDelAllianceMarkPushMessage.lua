local WorldDelAllianceMarkPushMessage = BaseClass("WorldDelAllianceMarkPushMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.WorldFavoDataManager:OnDelAllianceMarkPush(t)
    EventManager:GetInstance():Broadcast(EventId.RefreshBookmark)
  end
end

WorldDelAllianceMarkPushMessage.OnCreate = OnCreate
WorldDelAllianceMarkPushMessage.HandleMessage = HandleMessage
return WorldDelAllianceMarkPushMessage
