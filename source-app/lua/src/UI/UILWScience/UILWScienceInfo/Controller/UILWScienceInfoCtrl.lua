local UILWScienceInfoCtrl = BaseClass("UILWScienceInfoCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function SetView(self, view)
  self.view = view
end

local function ClearView(self)
  self.view = nil
end

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWScienceInfo)
end

UILWScienceInfoCtrl.SetView = SetView
UILWScienceInfoCtrl.ClearView = ClearView
UILWScienceInfoCtrl.CloseSelf = CloseSelf
return UILWScienceInfoCtrl
