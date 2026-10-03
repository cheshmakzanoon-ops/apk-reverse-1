local UIAllianceEveryDayTaskCtrl = BaseClass("UIAllianceEveryDayTaskCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceEveryDayTask, {anim = true})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIAllianceEveryDayTaskCtrl.CloseSelf = CloseSelf
UIAllianceEveryDayTaskCtrl.Close = Close
return UIAllianceEveryDayTaskCtrl
