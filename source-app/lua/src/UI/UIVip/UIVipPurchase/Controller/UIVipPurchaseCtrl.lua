local UIVipPurchaseCtrl = BaseClass("UIVipPurchaseCtrl", UIBaseCtrl)

function UIVipPurchaseCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIVipPurchase)
end

function UIVipPurchaseCtrl:Close()
  UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function UIVipPurchaseCtrl:VipAddLoginScore()
  DataCenter.VIPManager:RequestVipGetDailyPoint()
end

function UIVipPurchaseCtrl:ReceiveFreeReward()
  DataCenter.VIPManager:ReceiveFreeReward()
end

function UIVipPurchaseCtrl:ShowOpenLvUp(vipWindowType)
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

return UIVipPurchaseCtrl
