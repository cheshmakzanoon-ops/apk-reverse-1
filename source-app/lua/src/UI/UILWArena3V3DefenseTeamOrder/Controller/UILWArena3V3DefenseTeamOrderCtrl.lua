local UILWArena3V3DefenseTeamOrderCtrl = BaseClass("UILWArena3V3DefenseTeamOrderCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UILWArena3V3DefenseTeamOrder)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UILWArena3V3DefenseTeamOrderCtrl.CloseSelf = CloseSelf
UILWArena3V3DefenseTeamOrderCtrl.Close = Close
return UILWArena3V3DefenseTeamOrderCtrl
