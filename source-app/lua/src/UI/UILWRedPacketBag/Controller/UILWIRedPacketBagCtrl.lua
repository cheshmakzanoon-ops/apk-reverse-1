local UILWIRedPacketBagCtrl = BaseClass("UILWIRedPacketBagCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UIRedPacketBag)
end

local function GetRedPacketList()
  return
end

UILWIRedPacketBagCtrl.GetRedPacketList = GetRedPacketList
UILWIRedPacketBagCtrl.CloseSelf = CloseSelf
return UILWIRedPacketBagCtrl
