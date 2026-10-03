local NewReceiveBPStageRewardMessage = BaseClass("NewReceiveBPStageRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, level, type)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("level", level)
  self.sfsObj:PutInt("type", type)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActBattlePassData:GetStageRewardHandle(t)
  end
end

NewReceiveBPStageRewardMessage.OnCreate = OnCreate
NewReceiveBPStageRewardMessage.HandleMessage = HandleMessage
return NewReceiveBPStageRewardMessage
