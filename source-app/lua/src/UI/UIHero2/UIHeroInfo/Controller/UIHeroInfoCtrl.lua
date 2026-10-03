local UIHeroInfoCtrl = BaseClass("UIHeroInfoCtrl", UIBaseCtrl)

local function CloseSelf(self)
  if self.onClose ~= nil then
    self.onClose()
    self.onClose = nil
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroInfo)
end

UIHeroInfoCtrl.CloseSelf = CloseSelf
return UIHeroInfoCtrl
