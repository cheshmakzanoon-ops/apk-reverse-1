local UICreateSetAllianceCtrl = BaseClass("UICreateSetAllianceCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UICreateSetAlliance)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UICreateSetAllianceCtrl.CloseSelf = CloseSelf
UICreateSetAllianceCtrl.Close = Close
return UICreateSetAllianceCtrl
