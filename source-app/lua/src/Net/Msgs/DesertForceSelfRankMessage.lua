local DesertForceSelfRankMessage = BaseClass("DesertForceSelfRankMessage", SFSBaseMessage)
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
    local rank = 5000
    if t.rank ~= nil then
      rank = t.rank
    end
    DataCenter.DesertDataManager:SetSelfForceRank(rank)
    EventManager:GetInstance():Broadcast(EventId.ForceSelfRank, rank)
  end
end

DesertForceSelfRankMessage.OnCreate = OnCreate
DesertForceSelfRankMessage.HandleMessage = HandleMessage
return DesertForceSelfRankMessage
