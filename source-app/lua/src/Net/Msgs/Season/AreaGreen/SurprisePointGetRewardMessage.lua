local SurprisePointGetRewardMessage = BaseClass("SurprisePointGetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, pointId, worldId)
  base.OnCreate(self)
  self.sfsObj:PutInt("pointId", pointId or 0)
  self.sfsObj:PutLong("worldId", worldId or 0)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  DataCenter.SurprisePointManager:OnSurprisePointGetReward(t)
end

local function GetTestData(self)
  local t = {}
  return t
end

SurprisePointGetRewardMessage.GetTestData = GetTestData
SurprisePointGetRewardMessage.OnCreate = OnCreate
SurprisePointGetRewardMessage.HandleMessage = HandleMessage
return SurprisePointGetRewardMessage
