local UILWScienceMainCtrl = BaseClass("UILWScienceMainCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function SetView(self, view)
  self.view = view
end

local function ClearView(self)
  self.view = nil
end

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWScienceMain)
end

local function GetRecommendScience(self)
  return nil
end

UILWScienceMainCtrl.SetView = SetView
UILWScienceMainCtrl.ClearView = ClearView
UILWScienceMainCtrl.CloseSelf = CloseSelf
UILWScienceMainCtrl.GetRecommendScience = GetRecommendScience
return UILWScienceMainCtrl
