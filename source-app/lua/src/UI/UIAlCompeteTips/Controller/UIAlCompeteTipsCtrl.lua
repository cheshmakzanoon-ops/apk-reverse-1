local UIAlCompeteTipsCtrl = BaseClass("UIAlCompeteTipsCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAlCompeteTips)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIAlCompeteTipsCtrl.CloseSelf = CloseSelf
UIAlCompeteTipsCtrl.Close = Close
return UIAlCompeteTipsCtrl
