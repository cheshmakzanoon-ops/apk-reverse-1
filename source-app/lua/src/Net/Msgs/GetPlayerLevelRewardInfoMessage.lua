local GetPlayerLevelRewardInfoMessage = BaseClass("GetPlayerLevelRewardInfoMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
  base.OnCreate(self)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode ~= nil then
    UIUtil.ShowTipsId(t.errorCode)
    return
  end
  if t.levelRewardArr ~= nil then
    DataCenter.PlayerLevelManager:InitData(t)
  end
end

GetPlayerLevelRewardInfoMessage.OnCreate = OnCreate
GetPlayerLevelRewardInfoMessage.HandleMessage = HandleMessage
return GetPlayerLevelRewardInfoMessage
