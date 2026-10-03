local UILWSeasonTradeShopItem = BaseClass("UILWSeasonTradeShopItem", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "Bg"
local res_item_path = "Bg/UICommonResItem"
local mask_path = "Bg/Mask"
local over_path = "Bg/Over"
local tips_text_path = "Bg/TipsText"
local sold_text_path = "Bg/SoldText"
local buy_group_path = "Bg/BuyGroup"
local price_icon_path = "Bg/BuyGroup/PriceIcon"
local o_price_text_path = "Bg/BuyGroup/PriceGroup/OPriceText"
local cur_price_text_path = "Bg/BuyGroup/PriceGroup/CurPriceText"
local exclusive_path = "Bg/Exclusive"
local off_path = "Bg/Off"
local text_path = "Bg/Off/Text"
local IMG_BUY = "Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_xuanze_duihao.png"
local IMG_OVER = "Assets/Main/SeasonRes/Shared/Sprites/UI/UITradeStation/mjc_S3_maoyizhan_shouqing.png"

function UILWSeasonTradeShopItem:OnCreate()
  base.OnCreate(self)
  self.itemParam = UICommonResItem.Param.New()
  self.bg = self:AddComponent(UIButton, bg_path)
  self.bg:SetOnClick(function()
    if self.buy_group:GetActive() then
      self.view:OnClickItem(self.template, self.itemCost)
    end
  end)
  self.res_item = self:AddComponent(UICommonResItem, res_item_path)
  self.mask = self:AddComponent(UIBaseComponent, mask_path)
  self.over = self:AddComponent(UIImage, over_path)
  self.tips_text = self:AddComponent(UITextMeshProUGUIEx, tips_text_path)
  self.sold_text = self:AddComponent(UITextMeshProUGUIEx, sold_text_path)
  self.buy_group = self:AddComponent(UIBaseComponent, buy_group_path)
  self.price_icon = self:AddComponent(UIImage, price_icon_path)
  self.o_price_text = self:AddComponent(UITextMeshProUGUIEx, o_price_text_path)
  self.cur_price_text = self:AddComponent(UITextMeshProUGUIEx, cur_price_text_path)
  self.exclusive = self:AddComponent(UIImage, exclusive_path)
  self.off = self:AddComponent(UIImage, off_path)
  self.text = self:AddComponent(UITextMeshProUGUIEx, text_path)
end

function UILWSeasonTradeShopItem:OnDestroy()
  self.bg = nil
  self.itemParam = nil
  self.mask = nil
  self.over = nil
  self.res_item = nil
  self.tips_text = nil
  self.sold_text = nil
  self.buy_group = nil
  self.price_icon = nil
  self.o_price_text = nil
  self.cur_price_text = nil
  self.exclusive = nil
  self.off = nil
  self.text = nil
  base.OnDestroy(self)
end

function UILWSeasonTradeShopItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetTradeShopGoodsInfo, self.OnRefresh)
end

function UILWSeasonTradeShopItem:OnRemoveListener()
  self:RemoveUIListener(EventId.GetTradeShopGoodsInfo, self.OnRefresh)
  base.OnRemoveListener(self)
end

function UILWSeasonTradeShopItem:OnRefresh(configId)
  if configId == self.template.id then
    self:Refresh()
  end
end

function UILWSeasonTradeShopItem:ReInit(template, alPercent, lordUid, allianceId, discount)
  self.template = template
  self.alPercent = alPercent
  self.lordUid = lordUid
  self.allianceId = allianceId
  self.discount = discount
  self:Refresh()
end

function UILWSeasonTradeShopItem:Refresh()
  local template = self.template
  local configId = self.template.id
  local maxNum = template.cycle_times
  local limitTimes = self.view.maxTimes
  local exNum, selfBuyNum = DataCenter.SeasonTradeShopDataManager:GetShopGoodsExchangeNum(configId)
  local myExNum = DataCenter.SeasonTradeShopDataManager.buyNumber or 0
  local leftTimes = maxNum - (exNum < 0 and 0 or exNum)
  leftTimes = leftTimes < 0 and 0 or leftTimes
  local bExclusive = template.exclusive_flag
  local bOff = self.alPercent < 1
  local daily_limit = 1
  local canBuy = 0 < leftTimes and limitTimes > myExNum and selfBuyNum < daily_limit
  if self.alPercent < 1 then
    self.text:SetActive(true)
    local discount = 100 * (1 - self.alPercent)
    self.text:SetLocalText("season_s3_trade_tips12", math.floor(discount + 0.5))
  else
    self.text:SetActive(false)
  end
  self.itemParam.rewardType = template.rewardType
  self.itemParam.itemId = template.itemId
  self.itemParam.count = template.count
  self.itemParam.enableClick = true
  self.res_item:ReInit(self.itemParam)
  self.tips_text:SetLocalText("130194", leftTimes)
  self.sold_text:SetActive(not canBuy)
  self.buy_group:SetActive(canBuy)
  local overFlag
  local maskFlag = false
  if canBuy then
    self.price_icon:LoadSprite(CommonUtil.GetResOrItemIcon(template.currency_id))
    self.o_price_text:SetActive(bOff)
    local cost = template.currency_num
    if bOff then
      self.o_price_text:SetText(cost)
      cost = math.ceil(self.alPercent * cost)
    end
    self.itemCost = cost
    self.cur_price_text:SetText(cost)
    if bExclusive and self.lordUid ~= LuaEntry.Player:GetUid() then
      maskFlag = true
    end
  else
    self.itemCost = nil
    maskFlag = true
    if selfBuyNum >= daily_limit then
      overFlag = IMG_BUY
      self.sold_text:SetLocalText("season_alliance_trade_list_8")
    elseif exNum < 0 then
      overFlag = IMG_OVER
      self.sold_text:SetLocalText("season_s3_activity_1000072_desc29")
    elseif leftTimes == 0 then
      overFlag = IMG_OVER
      self.sold_text:SetLocalText("2901019")
    else
      self.sold_text:SetLocalText("season_s3_activity_1000072_desc54")
    end
  end
  self.mask:SetActive(maskFlag)
  self.over:SetActive(not string.IsNullOrEmpty(overFlag))
  if self.over:GetActive() then
    self.over:LoadSprite(overFlag)
    self.over:SetNativeSize()
  end
  self.exclusive:SetActive(bExclusive)
  self.off:SetActive(not bExclusive and bOff)
end

return UILWSeasonTradeShopItem
