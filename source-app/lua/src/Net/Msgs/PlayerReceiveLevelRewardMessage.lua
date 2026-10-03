local PlayerReceiveLevelRewardMessage = BaseClass("PlayerReceiveLevelRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, level)
  base.OnCreate(self)
  self.sfsObj:PutInt("level", level)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.PlayerLevelManager:PlayerReceiveLevelReward(t)
  end
end

PlayerReceiveLevelRewardMessage.OnCreate = OnCreate
PlayerReceiveLevelRewardMessage.HandleMessage = HandleMessage
return PlayerReceiveLevelRewardMessage
