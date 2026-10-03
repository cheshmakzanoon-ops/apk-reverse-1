local UILWTorchRelayRankCtrl = BaseClass("UILWTorchRelayRankCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
  UIManager.Instance:DestroyWindow(UIWindowNames.TorchRelayRank)
end

UILWTorchRelayRankCtrl.CloseSelf = CloseSelf
return UILWTorchRelayRankCtrl
