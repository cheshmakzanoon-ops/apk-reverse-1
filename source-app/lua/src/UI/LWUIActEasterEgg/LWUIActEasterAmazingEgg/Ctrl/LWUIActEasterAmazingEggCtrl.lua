local LWUIActEasterAmazingEggCtrl = BaseClass("LWUIActEasterAmazingEggCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIActEasterAmazingEgg)
end

local function RequestUpgrade(self, uuid)
  local activityData = DataCenter.ActEasterEggManager:GetActivityData()
  if not activityData then
    Logger.LogError("activityData ia nil")
    return
  end
  local activityId = activityData.activityId
  SFSNetwork.SendMessage(MsgDefines.EasterEggUpgrade, activityId, uuid)
end

local function OnCustomKeyCodeEscape(self)
end

LWUIActEasterAmazingEggCtrl.CloseSelf = CloseSelf
LWUIActEasterAmazingEggCtrl.RequestUpgrade = RequestUpgrade
LWUIActEasterAmazingEggCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return LWUIActEasterAmazingEggCtrl
