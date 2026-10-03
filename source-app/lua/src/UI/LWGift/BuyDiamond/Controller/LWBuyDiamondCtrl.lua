local LWBuyDiamondCtrl = BaseClass("LWBuyDiamondCtrl", UIBaseCtrl)
local ResGroupManager = CS.DownloadResGroupCommonManager.Instance

function LWBuyDiamondCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.LWBuyDiamond, {anim = false})
end

function LWBuyDiamondCtrl:InitData()
end

function LWBuyDiamondCtrl:BuyGift(info, selectedCombineIndex)
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

function LWBuyDiamondCtrl:SetPage(pageId)
  self.curPageId = pageId
end

function LWBuyDiamondCtrl:GetPage()
  return self.curPageId
end

function LWBuyDiamondCtrl:ClaimDailyRewards(mcId)
  SFSNetwork.SendMessage(MsgDefines.ClaimGolloesDailyReward, mcId)
end

function LWBuyDiamondCtrl:IsNeedCheckDownloadRes(pageId)
  local tagInfo = WelfareController.getShowTagInfoById(pageId)
  if not tagInfo then
    return false
  end
  local pageType = tagInfo:getType()
  if pageType == WelfareTagType.SingleActivity then
    local actData = tagInfo:getInfo()
    if actData then
      local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(actData.id)
      return actInfo ~= nil and actInfo:IsNeedCheckDownloadRes()
    end
  end
  return false
end

function LWBuyDiamondCtrl:IsDownloadResComplete(pageId)
  local tagInfo = WelfareController.getShowTagInfoById(pageId)
  if not tagInfo then
    return true
  end
  local packConfigIdList = {}
  local pageType = tagInfo:getType()
  if pageType == WelfareTagType.SingleActivity then
    local actData = tagInfo:getInfo()
    if actData then
      local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(actData.id)
      if actInfo then
        packConfigIdList = actInfo:GetDownloadResPackConfigIdList()
      end
    end
  end
  if not table.IsNullOrEmpty(packConfigIdList) then
    for i, configId in pairs(packConfigIdList) do
      if not ResGroupManager:IsDownload(configId) then
        return false
      end
    end
  end
  return true
end

return LWBuyDiamondCtrl
