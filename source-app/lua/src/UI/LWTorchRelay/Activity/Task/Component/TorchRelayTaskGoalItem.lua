local TorchRelayTaskGoalItem = BaseClass("TorchRelayTaskGoalItem", UIBaseContainer)
local base = UIBaseContainer
local u_i_common_res_item_path = "UICommonResItem"
local goal_point_text_path = "GoalPointBg/GoalPointText"
local can_get_effect_path = "canGetEffect"

function TorchRelayTaskGoalItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function TorchRelayTaskGoalItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TorchRelayTaskGoalItem:ComponentDefine()
  self.commonResItem = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.goal_point_text = self:AddComponent(UITextMeshProUGUIEx, goal_point_text_path)
  self.can_get_effect = self:AddComponent(UIBaseContainer, can_get_effect_path)
end

function TorchRelayTaskGoalItem:ComponentDestroy()
  self.commonResItem = nil
  self.mouth_text = nil
end

function TorchRelayTaskGoalItem:ReInit(param, index, curProgress, activityId)
  if param == nil then
    Logger.LogError("param is nil")
    return
  end
  index = index - 1
  if curProgress >= param.progress then
    local isGetReward = DataCenter.ActivityTorchRelayTaskManager:CheckMilestonesComplete(activityId, index)
    param.reward.isShowReceFlag = isGetReward
    param.reward.clickCallBack = nil
    self.can_get_effect:SetActive(not isGetReward)
    if not isGetReward then
      function param.reward.clickCallBack()
        SFSNetwork.SendMessage(MsgDefines.ActivityTorchRelayMilesRewardGet, activityId, index)
      end
    end
  else
    self.can_get_effect:SetActive(false)
  end
  self.commonResItem:ReInit(param.reward)
  self.goal_point_text:SetText(param.progress)
end

return TorchRelayTaskGoalItem
