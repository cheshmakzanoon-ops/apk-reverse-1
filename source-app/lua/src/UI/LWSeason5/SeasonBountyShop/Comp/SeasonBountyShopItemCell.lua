local base = UIBaseContainer
local SeasonBountyShopItemCell = BaseClass("SeasonBountyShopItemCell", base)
local RewardUtil = require("Util.RewardUtil")
local p_trans_item_root_path = "Bg/Offset/p_trans_item_root"
local goodsName_path = "Bg/Offset/name"
local limitLayout_path = "Bg/Offset/limitLayout"
local limitTxt_path = "Bg/Offset/limitLayout/limit"
local limitTimes_path = "Bg/Offset/limitLayout/limitNum"
local soldOut_path = "Bg/Offset/soldOut"
local buyBtn_path = "Bg"
local buy_btn_path = "Bg/Offset/buyBtn"
local price_path = "Bg/Offset/buyBtn/price"
local consumeIcon_path = "Bg/Offset/buyBtn/icon"
local condition_invalid_path = "Bg/Offset/ConditionInvalid"
local conditionText_path = "Bg/Offset/ConditionInvalid/BuyConditionText"
local u_i_common_res_item_path = "Bg/Offset/p_trans_item_root/UICommonResItem"
local hot_tag_icon_path = "Bg/Offset/HotTagIcon"
local special_tag_icon_path = "Bg/Offset/SpecialTagIcon"

function SeasonBountyShopItemCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonBountyShopItemCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function SeasonBountyShopItemCell:ComponentDefine()
  self.transRoot = self:AddComponent(UIBaseContainer, p_trans_item_root_path)
  self.goodsNameN = self:AddComponent(UITextMeshProUGUIEx, goodsName_path)
  self.limitTimesN = self:AddComponent(UITextMeshProUGUIEx, limitTimes_path)
  self.limitTxtN = self:AddComponent(UITextMeshProUGUIEx, limitTxt_path)
  self.limitLayoutN = self:AddComponent(UIBaseContainer, limitLayout_path)
  self.soldOutN = self:AddComponent(UITextMeshProUGUIEx, soldOut_path)
  self.soldOutN:SetLocalText(129060)
  self.goBtn = self:AddComponent(UIAnimator, buy_btn_path)
  self.buyBtnN = self:AddComponent(UIButton, buyBtn_path)
  self.buyBtnN:SetOnClick(function()
    self:OnClickBuyBtn()
  end)
  self.priceN = self:AddComponent(UITextMeshProUGUIEx, price_path)
  self.priceShadowN = self:AddComponent(UIShadow, price_path)
  self.consumeIconN = self:AddComponent(UIImage, consumeIcon_path)
  self.goCondition = self:AddComponent(UIBaseComponent, condition_invalid_path)
  self.textBuyCondition = self:AddComponent(UIText, conditionText_path)
  self.textBuyCondition:SetActive(false)
  self.u_i_common_res_item = self:AddComponent(UICommonResItem, u_i_common_res_item_path)
  self.hot_tag_icon = self:AddComponent(UIImage, hot_tag_icon_path)
  self.special_tag_icon = self:AddComponent(UIImage, special_tag_icon_path)
end

function SeasonBountyShopItemCell:ComponentDestroy()
  self.goodsNameN = nil
  self.limitTimesN = nil
  self.limitTxtN = nil
  self.limitLayoutN = nil
  self.soldOutN = nil
  self.buyBtnN = nil
  self.priceN = nil
  self.priceShadowN = nil
  self.consumeIconN = nil
  self.textBuyCondition = nil
  self.u_i_common_res_item = nil
  self.hot_tag_icon = nil
  self.special_tag_icon = nil
end

function SeasonBountyShopItemCell:DataDefine()
  self.goodsConf = nil
  self.cacheBuyCount = 0
  self.ItemIndex = 0
end

function SeasonBountyShopItemCell:DataDestroy()
  self.goodsConf = nil
  self.cacheBuyCount = nil
  self.ShopData = nil
  self.ShopCell = nil
end

function SeasonBountyShopItemCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonBountyShopExchangeUpdate, self.OnExchangeUpdate)
end

function SeasonBountyShopItemCell:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonBountyShopExchangeUpdate, self.OnExchangeUpdate)
  base.OnRemoveListener(self)
end

function SeasonBountyShopItemCell:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    self:UpdateUi()
  end
end

function SeasonBountyShopItemCell:InitData(data)
  if data ~= nil then
    self.Data = data
    if self:IsDataValid() then
      self.ShopData = self.Data.ShopData
      self.ShopCell = self.ShopData.ShopCell
      return true
    end
  end
  return false
end

function SeasonBountyShopItemCell:IsDataValid()
  if self.Data == nil or self.Data.ShopData == nil or self.Data.ShopData.ShopCell == nil then
    return false
  end
  return true
end

function SeasonBountyShopItemCell:InitUi()
  local param = {
    rewardType = self.ShopData.RewardType,
    itemId = tostring(self.ShopData.ShowId),
    count = checknumber(self.ShopData.RewardNum)
  }
  self.u_i_common_res_item:SetActive(true)
  self.u_i_common_res_item:ReInit(param)
  self.hot_tag_icon:SetActive(false)
  self.special_tag_icon:SetActive(false)
end

function SeasonBountyShopItemCell:UpdateUi()
  self:RefreshAll()
end

function SeasonBountyShopItemCell:RefreshAll()
  if not self:IsDataValid() then
    return
  end
  local itemName = self.ShopData:GetName()
  self.goodsNameN:SetText(itemName)
  self.limitLayoutN:SetActive(false)
  self.soldOutN:SetActive(false)
  self.buyBtnN:SetInteractable(true)
  self.goCondition:SetActive(false)
  self.goBtn:SetActive(false)
  self.hot_tag_icon:SetActive(false)
  self.special_tag_icon:SetActive(false)
  if self.ShopData.CostNum > 0 then
    self.goBtn:SetActive(true)
    self.priceN:SetActive(true)
    self.priceN:SetText(string.GetFormattedSeparatorNum(self.ShopData.CostNum))
    local iconPath = DataCenter.ItemTemplateManager:GetIconPath(checknumber(self.ShopData.CostId))
    self.consumeIconN:LoadSprite(iconPath)
    self:RefreshPriceColor()
  end
  local validInfo = self.ShopData:ConditionValid()
  local isOpen, openTime = self.ShopData:IsOpen()
  if not validInfo.IsValid then
    self.goCondition:SetActive(true)
    if not string.IsNullOrEmpty(validInfo.InvalidText) then
      self.textBuyCondition:SetActive(true)
      self.textBuyCondition:SetText(validInfo.InvalidText)
    end
  elseif not isOpen then
    self.goCondition:SetActive(true)
    self.textBuyCondition:SetActive(false)
  else
    local leftBuyTime = self.ShopData:GetLeftBuyTimes()
    if 0 < leftBuyTime then
      self.limitTxtN:SetLocalText(104208)
      self.limitTimesN:SetText(string.GetFormattedSeparatorNum(leftBuyTime))
      self.limitLayoutN:SetActive(true)
      local tag = checknumber(self.Data.ShopData.ShopCell.flag)
      self.hot_tag_icon:SetActive(tag == 1)
      self.special_tag_icon:SetActive(tag == 2)
    else
      self.goCondition:SetActive(true)
      self.goBtn:SetActive(false)
      self.soldOutN:SetActive(true)
      self.buyBtnN:SetInteractable(false)
    end
  end
end

function SeasonBountyShopItemCell:RefreshPriceColor()
  if not self:IsDataValid() then
    return
  end
  if self.priceN ~= nil then
    self.priceN:SetColor(self.ShopData:GetCurrencyColor())
  end
end

function SeasonBountyShopItemCell:SetConsumeIcon()
  local iconPath = DataCenter.ItemTemplateManager:GetIconPath(toInt(self.goodsConf.currencyId))
  self.consumeIconN:LoadSprite(iconPath)
end

function SeasonBountyShopItemCell:OnClickBuyBtn()
  if self.ShopData == nil then
    DataCenter.SeasonBountyShopManager:Log("click buy but ShopData is nil")
    return
  end
  local isOpen, openTime = self.ShopData:IsOpen()
  if not isOpen then
    local leftTime = openTime - UITimeManager:GetInstance():GetServerTime()
    if 0 < leftTime then
      local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      UIUtil.ShowTips(CS.GameEntry.Localization:GetString("season_s5_activity_1200042_desc02", timeStr))
    end
    return
  end
  local validInfo = self.ShopData:ConditionValid()
  if not validInfo.IsValid then
    if validInfo.InvalidAction ~= nil then
      validInfo.InvalidAction()
    end
    return
  end
  local preConditionValid = self.ShopData:PreConditionValid()
  if not preConditionValid then
    DataCenter.SeasonBountyShopManager:Log("click buy but pre_ondition invalid")
    return
  end
  local moneyEnough, lack = self.ShopData:ItemEnough()
  if not moneyEnough then
    LWResourceLackUtil:GotoGoodsItemLack(self.ShopData.CostId, lack)
    return
  end
  local canBuy = self.ShopData:CanBuy()
  if canBuy then
    self:HandleBuy()
  end
end

function SeasonBountyShopItemCell:HandleBuy()
  local leftTime = self.ShopData:GetLeftBuyTimes()
  if leftTime <= 0 then
    UIUtil.ShowTipsId(129061)
    return
  end
  
  local function buy()
    local param = {}
    param.goodsInfo = {}
    param.goodsInfo.rewardType = self.ShopData.RewardType
    param.goodsInfo.itemId = self.ShopData.ShowId
    param.goodsInfo.count = self.ShopData.RewardNum
    param.goodsInfo.limitCount = leftTime
    param.goodsInfo.eachPrice = self.ShopData.CostNum
    param.consumeInfo = {}
    param.consumeInfo.currencyType = RewardType.GOODS
    param.consumeInfo.currencyId = self.ShopData.CostId
    
    function param.callback(buyCount)
      self:ProcessPurchase(buyCount)
    end
    
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMultiBuy, {anim = true}, param)
  end
  
  if not self.ShopData:NeedConfirm() then
    buy()
  else
    local param = {}
    param.tipText = CS.GameEntry.Localization:GetString("season_s5_bounty_shop_desc01")
    param.btnNum = 2
    param.text1 = GameDialogDefine.CONFIRM
    param.text2 = GameDialogDefine.CANCEL
    param.isChangeImg = true
    param.sureAction = buy
    param.showToggle = false
    param.delayConfirm = {delayTime = 5}
    UIUtil.ShowSecondMessageByParam(param)
  end
end

function SeasonBountyShopItemCell:ProcessPurchase(buyCount)
  if self.ShopData ~= nil and self.ShopData:CanBuy() then
    DataCenter.SeasonBountyShopManager:SendExchange(self.ShopData.ShopCell.id, buyCount)
    self.CacheBuyCount = buyCount
  end
end

function SeasonBountyShopItemCell:OnExchangeUpdate(evt)
  if evt == nil or evt.productInfo == nil then
    return
  end
  if self.ShopData ~= nil and self.ShopData.ShopCell ~= nil then
    if evt.configId == self.ShopData.ShopCell.id then
      self:RefreshAll()
    else
      self:RefreshPriceColor()
    end
  end
end

return SeasonBountyShopItemCell
