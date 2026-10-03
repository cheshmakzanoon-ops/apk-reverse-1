local ActivityTaskRewardMessage = BaseClass("ActivityTaskRewardMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, taskId)
  base.OnCreate(self)
  self.sfsObj:PutInt("activityId", activityId)
  self.sfsObj:PutUtfString("taskId", taskId)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    if t.reward ~= nil then
      DataCenter.RewardManager:AddRewards(t.reward)
      if t.type == EnumActivity.ActTask.Type then
        self:CheckIsNeedPlayAniAtActTask(t)
      else
        DataCenter.RewardManager:ShowCommonReward(t)
      end
      if t.type == EnumActivity.ContinuePay.Type then
        DataCenter.ContinuePayActivityManager:GetOneTaskReward(t)
      end
    end
    DataCenter.ActTaskManager:TaskDataUpdateAtGetReward(t)
    EventManager:GetInstance():Broadcast(EventId.GetActTaskDataUpdateMsg)
    EventManager:GetInstance():Broadcast(EventId.ActTaskRewardGet)
  end
end

local function CheckIsNeedPlayAniAtActTask(self, t)
  local activityId = t.activityId
  local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
  local isNeedPlayAni = false
  if activityInfo and activityInfo.para_5 and not string.IsNullOrEmpty(activityInfo.para_5) then
    local targetItemId = activityInfo.para_5
    if t.reward and #t.reward > 0 then
      for k, v in ipairs(t.reward) do
        if v.type == RewardType.GOODS and v.value and v.value.itemId == targetItemId then
          isNeedPlayAni = true
          break
        end
      end
    end
  end
  if not isNeedPlayAni then
    DataCenter.RewardManager:ShowCommonReward(t)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIRewardPreAniShow, {anim = false}, t)
  end
end

ActivityTaskRewardMessage.OnCreate = OnCreate
ActivityTaskRewardMessage.HandleMessage = HandleMessage
ActivityTaskRewardMessage.CheckIsNeedPlayAniAtActTask = CheckIsNeedPlayAniAtActTask
return ActivityTaskRewardMessage
