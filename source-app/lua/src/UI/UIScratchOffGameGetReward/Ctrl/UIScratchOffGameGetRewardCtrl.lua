local UIScratchOffGameGetRewardCtrl = BaseClass("UIScratchOffGameGetRewardCtrl", UIBaseCtrl)

function UIScratchOffGameGetRewardCtrl:CloseSelf()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.ScratchOffGameGetRewardPage)
  EventManager:GetInstance():Broadcast(EventId.BackToScratchOff)
end

function UIScratchOffGameGetRewardCtrl:GetRecentLotteryRes(activityId)
  local info = DataCenter.ScratchOffGameManager:GetRecentLotteryRes()
  if info == nil or #info == 0 then
    return nil
  end
  local choose = DataCenter.ScratchOffGameManager:GetSelectedHeroIndexByActId(activityId)
  local lotteryResInfo = {}
  lotteryResInfo.diamond = info.diamond
  lotteryResInfo.ifLottery = 0 < lotteryResInfo.diamond
  lotteryResInfo.lotteryCount = #info
  lotteryResInfo.luckyIconItemInfoList = {}
  lotteryResInfo.commonResItemInfoList = {}
  lotteryResInfo.diamondInfoList = {}
  for k, v in ipairs(info) do
    local luckyIconItemInfo = {}
    luckyIconItemInfo.iconPath1 = v.iconPath1
    luckyIconItemInfo.iconPath2 = v.iconPath2
    luckyIconItemInfo.iconPath3 = v.iconPath3
    luckyIconItemInfo.ifLottery = v.ifLottery
    table.insert(lotteryResInfo.luckyIconItemInfoList, luckyIconItemInfo)
    table.insert(lotteryResInfo.commonResItemInfoList, v.commonItemInfo.resItemInfo[math.min(choose, #v.commonItemInfo.resItemInfo)])
    if v.ifLottery then
      local diamondInfo = {}
      diamondInfo.diamond = v.diamond
      diamondInfo.levelTxt = v.levelTxt
      table.insert(lotteryResInfo.diamondInfoList, diamondInfo)
    end
  end
  return lotteryResInfo
end

return UIScratchOffGameGetRewardCtrl
