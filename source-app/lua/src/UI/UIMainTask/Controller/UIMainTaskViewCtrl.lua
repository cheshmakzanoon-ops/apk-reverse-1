local UIMainTaskCtrl = BaseClass("UIMainTaskCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIMainTask, {anim = true})
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function JumpToActivity(self, overviewInfo)
  DataCenter.DailyActivityManager:JumpToActOverview(overviewInfo.type)
end

UIMainTaskCtrl.CloseSelf = CloseSelf
UIMainTaskCtrl.Close = Close
UIMainTaskCtrl.JumpToActivity = JumpToActivity
return UIMainTaskCtrl
