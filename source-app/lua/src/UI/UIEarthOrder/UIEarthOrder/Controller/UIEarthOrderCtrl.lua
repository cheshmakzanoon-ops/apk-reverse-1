local UIEarthOrderCtrl = BaseClass("UIEarthOrderCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIEarthOrder, {
    anim = true,
    UIMainAnim = UIMainAnimType.AllShow
  })
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Background)
end

local function Goto(self, rId)
  GoToUtil.GotoColdStorage(rId)
end

UIEarthOrderCtrl.CloseSelf = CloseSelf
UIEarthOrderCtrl.Close = Close
UIEarthOrderCtrl.Goto = Goto
return UIEarthOrderCtrl
