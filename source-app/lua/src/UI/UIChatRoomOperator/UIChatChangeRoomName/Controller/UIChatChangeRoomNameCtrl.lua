local UIChatChangeRoomNameCtrl = BaseClass("UIChatChangeRoomNameCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIChatChangeRoomName)
end

local function Close(self)
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIChatChangeRoomNameCtrl.CloseSelf = CloseSelf
UIChatChangeRoomNameCtrl.Close = Close
return UIChatChangeRoomNameCtrl
