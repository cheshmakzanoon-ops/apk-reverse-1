local UIChampionpropagandaViewController = BaseClass("UIChampionpropagandaViewController", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChampionpropaganda)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIChampionpropagandaViewController.CloseSelf = CloseSelf
UIChampionpropagandaViewController.Close = Close
return UIChampionpropagandaViewController
