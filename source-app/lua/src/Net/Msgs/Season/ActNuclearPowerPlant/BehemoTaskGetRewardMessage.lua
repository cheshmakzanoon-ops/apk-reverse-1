local BehemoTaskGetRewardMessage = BaseClass("BehemoTaskGetRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, activityId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutInt("taskId", taskId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  if t.errorCode then
    UIUtil.ShowTipsId(t.errorCode)
    local msg = ""
    if t.errorMsg then
      msg = t.errorMsg
    end
    return
  end
  DataCenter.SeasonNuclearPowerPlantDataManager:ActivityBehemothTaskGetReward(t)
end

BehemoTaskGetRewardMessage.OnCreate = OnCreate
BehemoTaskGetRewardMessage.HandleMessage = HandleMessage
return BehemoTaskGetRewardMessage
