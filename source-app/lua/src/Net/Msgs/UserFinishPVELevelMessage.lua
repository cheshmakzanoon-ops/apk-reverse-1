local UserFinishPVELevelMessage = BaseClass("UserFinishPVELevelMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, level, rewardIndex, isSuccess)
  base.OnCreate(self)
  self.sfsObj:PutInt("level", level)
  self.sfsObj:PutInt("rewardIndex", rewardIndex)
  self.sfsObj:PutBool("isSuccess", isSuccess)
end

local function HandleMessage(self, message)
  base.HandleMessage(self, message)
  DataCenter.BattleLevel:OnFinishLevelMessage(message)
end

UserFinishPVELevelMessage.OnCreate = OnCreate
UserFinishPVELevelMessage.HandleMessage = HandleMessage
return UserFinishPVELevelMessage
