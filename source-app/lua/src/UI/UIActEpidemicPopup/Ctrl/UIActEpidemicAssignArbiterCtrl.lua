local UIActEpidemicAssignArbiterCtrl = BaseClass("UIActEpidemicAssignArbiterCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActEpidemicAssignArbiterView)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function UIActEpidemicAssignArbiterCtrl:GetMembers(group)
  local roles = ActEpidemicUtils.GetPlayersByGroup(group)
  return roles
end

UIActEpidemicAssignArbiterCtrl.CloseSelf = CloseSelf
UIActEpidemicAssignArbiterCtrl.Close = Close
return UIActEpidemicAssignArbiterCtrl
