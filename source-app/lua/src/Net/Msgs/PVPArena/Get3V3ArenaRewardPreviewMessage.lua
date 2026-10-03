local Get3V3ArenaRewardPreviewMessage = BaseClass("Get3V3ArenaRewardPreviewMessage", SFSBaseMessage)
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
    DataCenter.LW3V3ArenaManager:ParseRankingRewardData(t)
    EventManager:GetInstance():Broadcast(EventId.ArenaPVPRewardDataGet)
  end
end

Get3V3ArenaRewardPreviewMessage.OnCreate = OnCreate
Get3V3ArenaRewardPreviewMessage.HandleMessage = HandleMessage
return Get3V3ArenaRewardPreviewMessage
