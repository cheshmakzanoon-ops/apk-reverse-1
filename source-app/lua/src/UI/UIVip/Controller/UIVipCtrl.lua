local UIVipCtrl = BaseClass("UIVipCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UIVipCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVip)
end

function UIVipCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function UIVipCtrl:VipAddLoginScore()
  DataCenter.VIPManager:RequestVipGetDailyPoint()
end

function UIVipCtrl:ReceiveFreeReward()
  DataCenter.VIPManager:ReceiveFreeReward()
end

function UIVipCtrl:BuyPack(info)
  DataCenter.PayManager:CallPayment(info, "GoldExchangeView", "")
end

function UIVipCtrl:ShowOpenLvUp(vipWindowType)
  if vipWindowType == 1 then
    local vipInfo = DataCenter.VIPManager:GetVipData()
    local vip18Level = LuaEntry.DataConfig:TryGetNum("vip_letter", "k1")
    if vipInfo.level == vip18Level then
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVIPUpgradePopUp, {anim = true})
  elseif vipWindowType == 2 then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVIPRewardPopUp, {anim = true})
  end
end

function UIVipCtrl:OnOpenPurchase()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIVipPurchase, {anim = true})
end

return UIVipCtrl
