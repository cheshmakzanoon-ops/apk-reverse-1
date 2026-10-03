local NewReceiveBPAllRewardMessage = BaseClass("NewReceiveBPAllRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActBattlePassData:ReceiveBattlePassAllRewardHandle(t)
  end
end

NewReceiveBPAllRewardMessage.OnCreate = OnCreate
NewReceiveBPAllRewardMessage.HandleMessage = HandleMessage
return NewReceiveBPAllRewardMessage
