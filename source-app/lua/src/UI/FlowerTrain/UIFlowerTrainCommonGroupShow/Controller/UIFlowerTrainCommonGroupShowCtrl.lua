local UIActivityCenterTableCtrl = require("UI.UIActivityCenterTable.Controller.UIActivityCenterTableCtrl")
local UIFlowerTrainCommonGroupShowCtrl = BaseClass("UIFlowerTrainCommonGroupShowCtrl", UIActivityCenterTableCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIFlowerTrainCommonGroupShow)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

UIFlowerTrainCommonGroupShowCtrl.CloseSelf = CloseSelf
UIFlowerTrainCommonGroupShowCtrl.Close = Close
return UIFlowerTrainCommonGroupShowCtrl
