local Localization = CS.GameEntry.Localization
local LWUIGoldLotteryItemComView = BaseClass("LWUIGoldLotteryItemComView", UIBaseContainer)
local base = UIBaseContainer
local LWUIGoldLotteryItemComAuto = require("UI.LWSeason4.LWUIGoldTreeThird.Auto.LWUIGoldLotteryItemComAuto")

function LWUIGoldLotteryItemComView:OnCreate()
  base.OnCreate(self)
  self.binder = LWUIGoldLotteryItemComAuto.New()
  self.binder:bind(self)
  self.btn_lwuigoldlotteryitem:SetOnClick(BindCallback(self, self.ClickBuy))
end

function LWUIGoldLotteryItemComView:OnDestroy()
  self.binder:unbind(self)
  self.binder = nil
  self.buyCount = nil
  self.cost = nil
  self.data = nil
  base.OnDestroy(self)
end

function LWUIGoldLotteryItemComView:ClickBuy()
  if not self.data then
    return
  end
  if not self.data.maturity and not self.data.canBuy then
    UIUtil.ShowTipsId("season_golden_tree_phase_third_UI_27")
    return
  end
  if self.data.hasBuy then
    UIUtil.ShowTipsId("season_golden_tree_phase_third_UI_28")
    return
  end
  if not self.data.canBuy then
    UIUtil.ShowTipsId("season_golden_tree_phase_third_UI_26")
    return
  end
  local userGoldTreeInfo = DataCenter.SeasonGoldTreeManager:GetUserGoldTreeInfo()
  local cardCount = table.count(userGoldTreeInfo.userGoldTreeCardMap)
  if cardCount < self.data.needCardCount then
    UIUtil.ShowTips(Localization:GetString("season_golden_tree_phase_third_tips3", self.data.needCardCount))
    return
  end
  local hasCount = DataCenter.ItemData:GetItemCount(self.data.itemId)
  if hasCount < self.data.price then
    LWResourceLackUtil:GotoGoodsItemLack(self.data.itemId, self.data.price)
    return
  end
  DataCenter.SeasonGoldTreeThirdManager:RequestGoldTreeBuyLottery(self.data.limit)
end

function LWUIGoldLotteryItemComView:SetData(data)
  self.data = data
end

function LWUIGoldLotteryItemComView:RefreshUI()
  self.buyed:SetActive(self.data.hasBuy)
  self.canbuy:SetActive(self.data.canBuy and not self.data.hasBuy)
  self.locked:SetActive(not self.data.maturity and not self.data.canBuy)
  self.notbuymaturity:SetActive(self.data.maturity and not self.data.hasBuy)
  if self.data.canBuy then
    self.txt_tx_bugcount:SetText(self.data.price)
  end
  self:Update1000MS()
end

function LWUIGoldLotteryItemComView:Update1000MS()
  if self.data == nil then
    return
  end
  if not self.data.maturity then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local weekDayIndex = UITimeManager:GetInstance():GetNowWeekdayIndex()
    local endTime = UITimeManager:GetInstance():GetTodayZero() + (self.data.limit - weekDayIndex) * 86400000
    self.txt_locktime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(endTime - curTime))
  end
end

return LWUIGoldLotteryItemComView
