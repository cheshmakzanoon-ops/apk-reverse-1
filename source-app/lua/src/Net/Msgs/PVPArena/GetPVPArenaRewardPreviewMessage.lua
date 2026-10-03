local GetPVPArenaRewardPreviewMessage = BaseClass("GetPVPArenaRewardPreviewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
    EventManager:GetInstance():Broadcast(EventId.PeakArenaGetMessageError)
  else
    EventManager:GetInstance():Broadcast(EventId.PeakArenaGetRewardPreview, t)
  end
end

GetPVPArenaRewardPreviewMessage.OnCreate = OnCreate
GetPVPArenaRewardPreviewMessage.HandleMessage = HandleMessage
return GetPVPArenaRewardPreviewMessage
