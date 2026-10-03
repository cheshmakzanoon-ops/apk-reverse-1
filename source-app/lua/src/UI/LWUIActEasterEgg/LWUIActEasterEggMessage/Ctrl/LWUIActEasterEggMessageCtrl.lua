local LWUIActEasterEggMessageCtrl = BaseClass("LWUIActEasterEggMessageCtrl", UIBaseCtrl)

function LWUIActEasterEggMessageCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActEasterEggMessage)
end

function LWUIActEasterEggMessageCtrl:__init()
  self.isInEditMode = false
  self.selectAll = false
  self.selectEggIdList = {}
end

function LWUIActEasterEggMessageCtrl:__delete()
  self.isInEditMode = nil
  self.selectAll = nil
  self.selectEggIdList = nil
end

function LWUIActEasterEggMessageCtrl:InEditMode()
  return self.isInEditMode
end

function LWUIActEasterEggMessageCtrl:SetInEditMode(isInEditMode)
  self.isInEditMode = isInEditMode
end

function LWUIActEasterEggMessageCtrl:SetSelectAll(selectAll)
  self.selectAll = selectAll
end

function LWUIActEasterEggMessageCtrl:GetSelectAll()
  return self.selectAll
end

function LWUIActEasterEggMessageCtrl:RequestMyPostEggsInfo()
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  if not activityData then
    Logger.LogError("activityData ia nil")
    return
  end
  local activityId = activityData.activityId
  SFSNetwork.SendMessage(MsgDefines.EasterMyEggs, activityId)
end

function LWUIActEasterEggMessageCtrl:RequestMyCommentEggsInfo(startIndex, endIndex)
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  if not activityData then
    Logger.LogError("activityData ia nil")
    return
  end
  local activityId = activityData.activityId
  SFSNetwork.SendMessage(MsgDefines.EasterMyComments, activityId, startIndex, endIndex)
end

function LWUIActEasterEggMessageCtrl:RequestDeleteEggs(type, delArr)
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  if not activityData then
    Logger.LogError("activityData ia nil")
    return
  end
  local activityId = activityData.activityId
  if not type or not delArr then
    Logger.LogError("param is wrong")
    return
  end
  SFSNetwork.SendMessage(MsgDefines.EasterDelEggs, activityId, type, delArr)
end

function LWUIActEasterEggMessageCtrl:WarpViewData(eggArr)
  for _, v in pairs(eggArr) do
    v.selected = self.selectAll
  end
  return eggArr
end

return LWUIActEasterEggMessageCtrl
