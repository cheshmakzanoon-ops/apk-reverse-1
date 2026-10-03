local ReceiveChallengeActTaskRewardMessage = BaseClass("ReceiveChallengeActTaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, id)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("id", id)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActMonsterTowerData:GetTaskRewardHandle(t)
  end
end

ReceiveChallengeActTaskRewardMessage.OnCreate = OnCreate
ReceiveChallengeActTaskRewardMessage.HandleMessage = HandleMessage
return ReceiveChallengeActTaskRewardMessage
