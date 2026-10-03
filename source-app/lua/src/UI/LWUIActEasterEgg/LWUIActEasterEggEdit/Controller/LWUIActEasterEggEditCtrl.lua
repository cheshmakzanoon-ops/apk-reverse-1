local LWUIActEasterEggEditCtrl = BaseClass("LWUIActEasterEggEditCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function LWUIActEasterEggEditCtrl:CloseSelf()
  UIManager.Instance:DestroyWindow(UIWindowNames.LWUIActEasterEggEditView)
end

function LWUIActEasterEggEditCtrl:RequestThrowEgg(type, context, optionA, optionB)
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  if not activityData then
    Logger.LogError("activityData ia nil")
    return
  end
  local activityId = activityData.activityId
  SFSNetwork.SendMessage(MsgDefines.EasterEggThrow, activityId, type, context, optionA, optionB)
end

function LWUIActEasterEggEditCtrl:GetQuestion()
  return ""
end

return LWUIActEasterEggEditCtrl
