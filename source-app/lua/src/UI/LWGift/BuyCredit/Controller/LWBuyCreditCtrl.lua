local LWBuyCreditCtrl = BaseClass("LWBuyCreditCtrl", UIBaseCtrl)

function LWBuyCreditCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIBuyCredit, {anim = false})
end

function LWBuyCreditCtrl:InitData()
end

function LWBuyCreditCtrl:BuyGift(info, selectedCombineIndex)
  if not info then
    return
  end
  local vec = string.split(info:getItem2Str(), "@", 0, true)
  local combinationData = ""
  if vec ~= nil and selectedCombineIndex ~= nil and selectedCombineIndex < #vec then
    combinationData = vec[selectedCombineIndex]
  end
  DataCenter.PayManager:CallPayment(info, "GoldExchangeView", combinationData)
end

function LWBuyCreditCtrl:SetPage(pageId)
  self.curPageId = pageId
end

function LWBuyCreditCtrl:GetPage()
  return self.curPageId
end

function LWBuyCreditCtrl:ClaimDailyRewards(mcId)
  SFSNetwork.SendMessage(MsgDefines.ClaimGolloesDailyReward, mcId)
end

return LWBuyCreditCtrl
