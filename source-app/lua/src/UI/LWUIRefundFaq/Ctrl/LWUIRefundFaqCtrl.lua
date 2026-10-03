local LWUIRefundFaqCtrl = BaseClass("LWUIRefundFaqCtrl", UIBaseCtrl)

function LWUIRefundFaqCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWUIRefundFaq)
end

function LWUIRefundFaqCtrl:GetShowRequestBtn()
  local packageName = CS.NetworkURLConfig.PackageName
  return packageName == "com.fun.lastwar.gp" or packageName == "com.fun.lastwar.debug"
end

function LWUIRefundFaqCtrl:GetShowGoldBlockBtn()
  local switch = LuaEntry.DataConfig:CheckSwitch("undo_goldbrick")
  if not switch then
    return false
  end
  local goldBrickCount = DataCenter.GoldBrickDataManager:GetGoldBrickCount() or 0
  if Config.IsPC() then
    return true
  end
  local hasHistory = LuaEntry.Player:GetAlreadyBuyGoldBrick()
  local canOpen = WelfareController.CanOpenGoldBrickStore()
  if 0 < goldBrickCount or goldBrickCount < 0 or hasHistory or canOpen then
    return true
  else
    return false
  end
end

function LWUIRefundFaqCtrl:IsRefundBan()
  return DataCenter.LWRefundManager.refundBlackStatus
end

return LWUIRefundFaqCtrl
