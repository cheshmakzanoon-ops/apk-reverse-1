local DragonRewardInfoMessage = BaseClass("DragonRewardInfoMessage", SFSBaseMessage)
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
    DataCenter.ActDragonManager:HandleGetRewardInfo(t)
  end
end

DragonRewardInfoMessage.OnCreate = OnCreate
DragonRewardInfoMessage.HandleMessage = HandleMessage
return DragonRewardInfoMessage
