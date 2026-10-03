local UILeadingQuestWayCtrl = BaseClass("UILeadingQuestWayCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILeadingQuestWay, {anim = false})
end

local function OnCustomKeyCodeEscape(self)
  self:CloseSelf()
end

UILeadingQuestWayCtrl.CloseSelf = CloseSelf
UILeadingQuestWayCtrl.OnCustomKeyCodeEscape = OnCustomKeyCodeEscape
return UILeadingQuestWayCtrl
