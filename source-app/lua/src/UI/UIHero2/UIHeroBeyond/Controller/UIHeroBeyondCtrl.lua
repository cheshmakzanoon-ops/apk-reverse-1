local UIHeroBeyondCtrl = BaseClass("UIHeroBeyondCtrl", UIBaseCtrl)

local function CloseSelf(self)
  if self.callback then
    self.callback()
  end
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIHeroBeyond)
end

UIHeroBeyondCtrl.CloseSelf = CloseSelf
return UIHeroBeyondCtrl
