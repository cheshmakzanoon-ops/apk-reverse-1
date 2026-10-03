local UIArenaHistoryCtrl = BaseClass("UIArenaHistoryCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIArenaHistory, {anim = true})
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UIArenaHistoryCtrl.CloseSelf = CloseSelf
UIArenaHistoryCtrl.Close = Close
return UIArenaHistoryCtrl
