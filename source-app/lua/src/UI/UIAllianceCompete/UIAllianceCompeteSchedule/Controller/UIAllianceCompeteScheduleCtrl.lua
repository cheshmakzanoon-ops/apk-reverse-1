local UIAllianceCompeteScheduleCtrl = BaseClass("UIAllianceCompeteScheduleCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceCompeteSchedule)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIAllianceCompeteScheduleCtrl.CloseSelf = CloseSelf
UIAllianceCompeteScheduleCtrl.Close = Close
return UIAllianceCompeteScheduleCtrl
