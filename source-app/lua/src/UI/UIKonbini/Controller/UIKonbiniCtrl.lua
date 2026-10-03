local UIKonbiniCtrl = BaseClass("UIKonbiniCtrl", UIBaseCtrl)
local LandLockReceive = require("DataCenter.LandLock.LandLockReceive")

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIKonbini)
end

local function Close(self)
  UIManager.Instance:DestroyWindowByLayer(UILayer.Background, false)
end

local function DropOneBox(self, pointId)
  local receiveItem = LandLockReceive.New()
  receiveItem:Init(nil, pointId, LandLockRewardType.CallChest)
  receiveItem:PlayFall()
end

UIKonbiniCtrl.CloseSelf = CloseSelf
UIKonbiniCtrl.Close = Close
UIKonbiniCtrl.DropOneBox = DropOneBox
return UIKonbiniCtrl
