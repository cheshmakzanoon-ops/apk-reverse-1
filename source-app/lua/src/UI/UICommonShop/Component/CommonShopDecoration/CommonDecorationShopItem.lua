local CommonDecorationShopItem = BaseClass("CommonDecorationShopItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UnityRectTransform = typeof(CS.UnityEngine.RectTransform)
local QUEST_ENTRY_WIDTH_LIMIT = 209
local QUEST_ENTRY_ROLLING_SPD = 60
local QUEST_ENTRY_ROLLING_DELAY = 2
local QUEST_ENTRY_ROLLING_HOLD = 3

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  if self.tweenSeq then
    self.tweenSeq:Kill()
  end
  self.tweenSeq = nil
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.textName = self:AddComponent(UITextMeshProUGUIEx, "Bg/Offset/NameMask/name")
  self.name_rectTransform = self.transform:Find("Bg/Offset/NameMask/name"):GetComponent(UnityRectTransform)
  self.compUICommonResItem = self:AddComponent(UICommonResItem, "Bg/Offset/UICommonResItem")
  self.textPrice = self:AddComponent(UITextMeshProUGUIEx, "Bg/Offset/buyNode/price")
  self.imgIcon = self:AddComponent(UIImage, "Bg/Offset/buyNode/icon")
  self.buyBtn = self:AddComponent(UIButton, "Bg/Offset/buyNode/buyBtn")
  self.buyBtn:SetOnClick(function()
    if not self.isMeetSaleCondition then
      local tipsStr = DataCenter.CommonShopManager:GetNoQualificationTips(self.goodsConf and self.goodsConf.configData or nil)
      UIUtil.ShowTips(tipsStr or "")
      return
    end
    self:OnBuyBtnClick()
  end)
  self.textLimitNum = self:AddComponent(UITextMeshProUGUIEx, "Bg/Offset/limitNum")
  self.compRecommend = self:AddComponent(UIBaseContainer, "Bg/Offset/recommend")
  self.compNew = self:AddComponent(UIBaseContainer, "Bg/Offset/new")
  self.cannotBuyText = self:AddComponent(UITextMeshProUGUIEx, "Bg/Offset/cannotBuyText")
  self.seasonNode = self:AddComponent(UIBaseContainer, "Bg/Offset/SeasonNode")
  self.seasonImage = self:AddComponent(UIImage, "Bg/Offset/SeasonNode/SeasonImage")
  self.desc = self:AddComponent(UITextMeshProUGUIEx, "Bg/Offset/desc")
end

local function ComponentDestroy(self)
  self.textName = nil
  self.compUICommonResItem = nil
  self.buyBtn = nil
  self.textPrice = nil
  self.imgIcon = nil
  self.btnBg = nil
  self.textLimitNum = nil
  self.compRecommend = nil
  self.compNew = nil
  self.cannotBuyText = nil
  self.seasonNode = nil
  self.seasonImage = nil
  self.desc = nil
  self.name_rectTransform = nil
end

local function DataDefine(self)
  self.goodsConf = nil
  self.cacheBuyCount = 0
  self.goodsInfo = {}
end

local function DataDestroy(self)
  self.goodsConf = nil
  self.cacheBuyCount = nil
  self.goodsInfo = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateGold, self.RefreshAll)
  self:AddUIListener(EventId.OnBuyCommonGoodsSucc, self.OnBuySuccessCallBack)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UpdateGold, self.RefreshAll)
  self:RemoveUIListener(EventId.OnBuyCommonGoodsSucc, self.OnBuySuccessCallBack)
end

local function OnBuySuccessCallBack(self, goodsId)
  if self.goodsConf and goodsId == self.goodsConf.id then
    local rewardType = RewardType.GOODS
    local itemId = self.itemId
    if string.IsNullOrEmpty(itemId) then
      rewardType = RewardType.HERO
      itemId = self.goodsConf.hero
    end
    local pic = RewardUtil.GetPic(rewardType, itemId)
    local img = self.compUICommonResItem.item_icon
    if pic ~= "" then
      local flyNum = self.cacheBuyCount > 5 and 6 or self.cacheBuyCount
      UIUtil.DoFly(tonumber(rewardType), flyNum, pic, img.transform.position, Vector3.New(0, 0, 0))
    end
  end
end

local function SetItem(self, goodsConf, curShopType)
  self.goodsConf = goodsConf
  self.curShopType = curShopType
  self.itemId = self.goodsConf.itemId
  self:RefreshAll()
end

local function OnBuyBtnClick(self)
  local goodsConf = self.goodsConf
  if self.state == DecorationShoGoodsState.isHave then
    UIUtil.ShowTipsId("item_use_alerttips_002")
    return
  end
  if self.state == DecorationShoGoodsState.isUnlock then
    UIUtil.ShowTipsId("optional_chest_desc01")
    return
  end
  if self.state == DecorationShoGoodsState.SoldOut then
    UIUtil.ShowTipsId("129060")
    return
  end
  if not self.curShopType then
    Logger.LogError("curShopType is nil")
    return
  end
  if not DataCenter.CommonShopManager:CheckCostEnough(self.goodsConf, false) then
    DataCenter.CommonShopManager:OpenDirectPurchaseView(self.curShopType)
  else
    DataCenter.CommonShopManager:Buy(self.goodsConf.id, self.goodsConf.shopType, function(buyCount)
      self:ProcessPurchase(buyCount, goodsConf)
    end)
  end
end

local function ProcessPurchase(self, buyCount, goodsConf)
  if not DataCenter.CommonShopManager:CheckCostEnough(goodsConf, false) then
    return
  end
  self.cacheBuyCount = buyCount
  SFSNetwork.SendMessage(MsgDefines.BuyCommonShopGoods, goodsConf.id, nil, buyCount)
end

local function AdjustMaskText(self)
  if self.tweenSeq then
    self.tweenSeq:Kill()
  end
  self.tweenSeq = UIUtil.SetTMPHorseRaceLamp(self.textName, QUEST_ENTRY_WIDTH_LIMIT, QUEST_ENTRY_ROLLING_DELAY, QUEST_ENTRY_ROLLING_SPD, QUEST_ENTRY_ROLLING_HOLD, self.name_rectTransform)
end

local function RefreshAll(self)
  if not self.goodsConf then
    return
  end
  local param = {}
  if not self.itemId then
    Logger.Log("itemId is nil")
    return
  end
  param = {
    rewardType = RewardType.GOODS,
    itemId = self.itemId,
    count = self.goodsConf.itemNum
  }
  self.compUICommonResItem:ReInit(param)
  local itemName = DataCenter.ItemTemplateManager:GetName(self.itemId)
  self.textName:SetText(itemName)
  self.goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(self.goodsConf.shopType, self.goodsConf.id)
  local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(CommonShopType.DecorationShop, self.goodsConf.id)
  local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
  self.textLimitNum:SetLocalText(135225, self.goodsConf.maxTimes - boughtTimes, self.goodsConf.maxTimes)
  self.textLimitNum:SetActive(true)
  self.desc:SetActive(false)
  self.state = self.goodsConf.state
  if self.state == DecorationShoGoodsState.SoldOut then
    self.compUICommonResItem:SetGray(true, true)
    self.cannotBuyText:SetActive(true)
    self.cannotBuyText:SetLocalText(129060)
    self.imgIcon:SetActive(false)
    self.textPrice:SetActive(false)
  elseif self.state == DecorationShoGoodsState.isUnlock then
    self.compUICommonResItem:SetGray(true, true)
    self.cannotBuyText:SetActive(true)
    self.cannotBuyText:SetLocalText("optional_chest_desc01")
    self.imgIcon:SetActive(false)
    self.textPrice:SetActive(false)
  elseif self.state == DecorationShoGoodsState.isHave then
    self.compUICommonResItem:SetGray(true, true)
    self.cannotBuyText:SetActive(true)
    self.cannotBuyText:SetLocalText("building_center_desc23")
    self.imgIcon:SetActive(false)
    self.textPrice:SetActive(false)
  elseif self.state == DecorationShoGoodsState.Sale then
    self.compUICommonResItem:SetGray(false, true)
    self.cannotBuyText:SetActive(false)
    self.imgIcon:SetActive(true)
    self.textPrice:SetActive(true)
    self.textPrice:SetText(string.GetFormattedSeparatorNum(self.goodsConf.costNum))
    if DataCenter.CommonShopManager:CheckCostEnough(self.goodsConf, false) then
      self.textPrice:SetColor(WhiteColor)
    else
      self.textPrice:SetColor(RedColor)
    end
  end
  self.isMeetSaleCondition = self.goodsConf.matchBuyCondition
  if not self.isMeetSaleCondition then
    local tipsStr = DataCenter.CommonShopManager:GetNoQualificationTips(self.goodsConf and self.goodsConf.configData or nil)
    self.textLimitNum:SetActive(false)
    self.compUICommonResItem:SetGray(true, true)
    self.desc:SetActive(true)
    self.desc:SetText(tipsStr)
  end
  self:ShowRecommendOrNew()
  self:ShowSeasonTips()
end

local function ShowRecommendOrNew(self)
  if self.state ~= DecorationShoGoodsState.Sale then
    self.compRecommend:SetActive(false)
    self.compNew:SetActive(false)
    return
  end
  local showRecommend = false
  if self.goodsConf and self.goodsConf.configData then
    local recommend = self.goodsConf.configData:getIntValue("recommend")
    showRecommend = recommend == 1
  end
  local isNew = DataCenter.CommonShopManager:IfShopItemNew(self.itemId)
  self.compRecommend:SetActive(showRecommend and not isNew)
  self.compNew:SetActive(isNew)
end

local function ShowSeasonTips(self)
  local seasonMarkTips = self.goodsConf.seasonMarkTips
  if seasonMarkTips and table.count(seasonMarkTips) > 0 and seasonMarkTips.beginSeason and seasonMarkTips.endSeason and seasonMarkTips.showSeason then
    local curSeason = SeasonUtil.GetSeason()
    local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curSeason and (curSeason == seasonMarkTips.beginSeason or infoPlayer and curTime and curSeason == seasonMarkTips.endSeason and curTime < infoPlayer.seasonSettleTime or curSeason > seasonMarkTips.beginSeason and curSeason < seasonMarkTips.endSeason) then
      self.seasonNode:SetActive(true)
      local iconPath = SeasonUtil.GetSeasonSmallIconPath(seasonMarkTips.showSeason)
      self.seasonImage:LoadSprite(iconPath)
      return
    end
  end
  self.seasonNode:SetActive(false)
end

CommonDecorationShopItem.OnCreate = OnCreate
CommonDecorationShopItem.OnDestroy = OnDestroy
CommonDecorationShopItem.OnEnable = OnEnable
CommonDecorationShopItem.OnDisable = OnDisable
CommonDecorationShopItem.ComponentDefine = ComponentDefine
CommonDecorationShopItem.ComponentDestroy = ComponentDestroy
CommonDecorationShopItem.DataDefine = DataDefine
CommonDecorationShopItem.DataDestroy = DataDestroy
CommonDecorationShopItem.OnAddListener = OnAddListener
CommonDecorationShopItem.OnRemoveListener = OnRemoveListener
CommonDecorationShopItem.OnBuyBtnClick = OnBuyBtnClick
CommonDecorationShopItem.SetItem = SetItem
CommonDecorationShopItem.OnBuySuccessCallBack = OnBuySuccessCallBack
CommonDecorationShopItem.ProcessPurchase = ProcessPurchase
CommonDecorationShopItem.RefreshAll = RefreshAll
CommonDecorationShopItem.ShowRecommendOrNew = ShowRecommendOrNew
CommonDecorationShopItem.ShowSeasonTips = ShowSeasonTips
CommonDecorationShopItem.AdjustMaskText = AdjustMaskText
return CommonDecorationShopItem
