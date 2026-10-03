local UILWScienceGiftCtrl = BaseClass("UILWScienceGiftCtrl", UIBaseCtrl)

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.UILWScienceGift)
end

local function GetGiftInfo(self)
  return DataCenter.ScienceManager:GetGiftPack()
end

UILWScienceGiftCtrl.CloseSelf = CloseSelf
UILWScienceGiftCtrl.GetGiftInfo = GetGiftInfo
return UILWScienceGiftCtrl
