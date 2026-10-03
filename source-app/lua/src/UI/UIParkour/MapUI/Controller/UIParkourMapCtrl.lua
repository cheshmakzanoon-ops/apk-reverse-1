local UIParkourMapCtrl = BaseClass("UIParkourMapCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIParkourMap)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetCurrentStageId(self)
  return DataCenter.ParkourManager.curStageId
end

UIParkourMapCtrl.CloseSelf = CloseSelf
UIParkourMapCtrl.Close = Close
UIParkourMapCtrl.GetCurrentStageId = GetCurrentStageId
return UIParkourMapCtrl
