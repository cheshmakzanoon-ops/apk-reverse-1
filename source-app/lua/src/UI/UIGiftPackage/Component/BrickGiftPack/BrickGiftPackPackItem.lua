local UIGiftPackageCell = require("UI.UIGiftPackage.Component.UIGiftPackageCell")
local LWBtnBuyRefundRemind = require("UI.LWBtnBuyRefundRemind.LWBtnBuyRefundRemind")
local BrickGiftPackPackItem = BaseClass("BrickGiftPackPackItem", UIBaseContainer)
local base = UIBaseContainer
local M = BrickGiftPackPackItem
local Localization = CS.GameEntry.Localization
local Timer = CS.GameEntry.Timer

function M:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function M:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function M:ComponentDefine()
  self.title_name = self:AddComponent(UIText, "TxtName")
  self.time = self:AddComponent(UIText, "TimeIcon/TxtCd")
  self.remain_count = self:AddComponent(UIText, "Txt_GiftState")
  self.buy_btn = self:AddComponent(LWBtnBuyRefundRemind, "Btn_Buy")
  self.buy_btn:SetBuyClickAction(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    DataCenter.PayManager:BuyGift(self.param)
  end)
  self.buy_btn:SetSafeClickMode(true)
  self.discount_root = self:AddComponent(UIBaseContainer, "Discount")
  self.txt_discount = self:AddComponent(UIText, "Discount/DiscountTxt")
  self.scroll_view = self:AddComponent(UIScrollView, "CellScroll")
  self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
end

function M:ComponentDestroy()
  self.title_name = nil
  self.time = nil
  self.buy_btn = nil
  self.discount_root = nil
  self.txt_discount = nil
  self.scroll_view = nil
end

function M:DataDefine()
  self.param = {}
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  self.timeValue = nil
  self.buyBtnEnable = nil
  self.listParam = {}
end

function M:DataDestroy()
  self.param = nil
  self.timer_action = nil
  self:DeleteTimer()
  self.timeValue = nil
  self.buyBtnEnable = nil
  self.listParam = nil
end

function M:ReInit(param)
  self.param = param
  if not self.param then
    return
  end
  local info = self.param
  self.title_name:SetLocalText(info:getName())
  self:RefreshTime()
  if self:ShowRefundTip(info) then
    self.remain_count:SetAnchoredPositionXY(self.remain_count:GetAnchoredPositionX(), -50)
  else
    self.remain_count:SetAnchoredPositionXY(self.remain_count:GetAnchoredPositionX(), -201)
  end
  local remainTime = self.param:getBuyTimes() - self.param:getHasGetCount()
  self.remain_count:SetLocalText(2000707, string.format(" %s", remainTime))
  local discountTips = info:GetDiscountTips()
  if discountTips and discountTips[3] then
    self.discount_root:SetActive(true)
    self.txt_discount:SetText(discountTips[3])
  else
    local hasPercent = info:hasPercent()
    if hasPercent then
      self.discount_root:SetActive(true)
      self.txt_discount:SetLocalText("giftpackage_value", info:getPercent())
    else
      self.discount_root:SetActive(false)
    end
  end
  self.buy_btn:Init(info)
  self.buy_btn:RefreshPoint()
  if remainTime <= 0 then
    self.buy_btn:SetGray(true, false)
    self.buy_btn:SetPriceText(Localization:GetString("total_mobilization_desc4"))
  else
    self.buy_btn:SetGray(false, true)
  end
  if self.param:getTimeType() ~= PackTimeType.AlwaysHideTime then
    self:AddTimer()
  end
  self:ShowAllCells()
end

function M:ShowRefundTip(info)
  local isKoreaRegion = CS.GameEntry.Sdk:IsKoreaRegion()
  if isKoreaRegion then
    return false
  end
  local show = LuaEntry.DataConfig:CheckSwitch("refund_client3") and not info:getCanRefund()
  return show
end

function M:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function M:AddTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

function M:RefreshTime()
  if self.param:getTimeType() == PackTimeType.AlwaysHideTime then
    self:SetTime("")
    self:SetBuyButtonEnable(true)
    return
  end
  local curTime = Timer:GetServerTime()
  local nextMonthTime = UITimeManager:GetInstance():GetNextMonth()
  local leftTime, b2 = math.modf(nextMonthTime - curTime)
  if 0 <= leftTime then
    self:SetTime(Timer:MilliSecondToFmtString(leftTime))
    self:SetBuyButtonEnable(true)
  else
    self:SetTime(Localization:GetString("120077"))
    self:SetBuyButtonEnable(false)
  end
end

function M:SetBuyButtonEnable(value)
  if self.buyBtnEnable ~= value then
    self.buyBtnEnable = value
    self.buy_btn:SetBuyButtonInteractable(value)
  end
end

function M:SetTime(value)
  if self.timeValue ~= value then
    self.timeValue = value
    self.time:SetText(value)
  end
end

function M:ShowAllCells()
  self:GetCellsList()
  self:ClearScroll()
  if #self.listParam > 0 then
    self.scroll_view:SetTotalCount(#self.listParam)
    self.scroll_view:RefillCells()
  end
end

function M:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll_view:AddComponent(UIGiftPackageCell, itemObj)
  cellItem:ReInit(self.listParam[index])
  local jpBubbleGo = cellItem.transform:Find("JpBubble").gameObject
  local jpBrickNumText = UIUtil.GetComponent(jpBubbleGo, CS.TextMeshProUGUIEx, "TextBrickNum")
  local bonusGo = cellItem.transform:Find("Bonus").gameObject
  if index == 1 then
    if LuaEntry.Player.JPUser then
      jpBubbleGo:SetActive(true)
      jpBrickNumText:SetText(self.param:getGoldBrick())
    else
      jpBubbleGo:SetActive(false)
    end
    bonusGo:SetActive(false)
  else
    jpBubbleGo:SetActive(false)
    bonusGo:SetActive(true)
  end
end

function M:OnDeleteCell(itemObj, index)
  self.scroll_view:RemoveComponent(itemObj.name, UIGiftPackageCell)
end

function M:ClearScroll()
  self.scroll_view:ClearCells()
  self.scroll_view:RemoveComponents(UIGiftPackageCell)
end

function M:GetCellsList()
  local info = self.param
  self.listParam = info:getItems(true)
end

return M
