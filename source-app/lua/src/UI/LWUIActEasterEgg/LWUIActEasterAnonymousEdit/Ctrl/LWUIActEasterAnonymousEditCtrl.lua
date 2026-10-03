local LWUIActEasterAnonymousEditCtrl = BaseClass("LWUIActEasterAnonymousEditCtrl", UIBaseCtrl)

function LWUIActEasterAnonymousEditCtrl:__init()
  self.curSelectIndex = 0
end

function LWUIActEasterAnonymousEditCtrl:__delete()
  self.curSelectIndex = nil
end

function LWUIActEasterAnonymousEditCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActEasterAnonymousEdit)
end

function LWUIActEasterAnonymousEditCtrl:RequestChangeAnonymous(state, headIndex, type)
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  if not activityData then
    Logger.LogError("activityData ia nil")
    return
  end
  local activityId = activityData.activityId
  local stateNum = 1
  if state then
    stateNum = 0
  end
  headIndex = headIndex - 1
  SFSNetwork.SendMessage(MsgDefines.EasterChangeAnonymous, activityId, stateNum, headIndex, type)
end

function LWUIActEasterAnonymousEditCtrl:SetCurSelectHeadIndex(index)
  self.curSelectIndex = index
end

function LWUIActEasterAnonymousEditCtrl:GetCurSelectHeadIndex()
  return self.curSelectIndex
end

return LWUIActEasterAnonymousEditCtrl
