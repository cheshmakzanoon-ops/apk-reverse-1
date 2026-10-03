local BPTaskRewardMessage = BaseClass("BPTaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, taskId)
  base.OnCreate(self)
  if activityId then
    self.sfsObj:PutInt("activityId", activityId)
  end
  if taskId then
    self.sfsObj:PutUtfString("taskId", tostring(taskId))
  end
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.ActBattlePassData:GetTaskRewardHandle(t)
  end
end

BPTaskRewardMessage.OnCreate = OnCreate
BPTaskRewardMessage.HandleMessage = HandleMessage
return BPTaskRewardMessage
