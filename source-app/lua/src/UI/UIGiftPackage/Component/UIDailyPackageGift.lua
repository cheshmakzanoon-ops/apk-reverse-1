local UICommonResItem = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItem")
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local UIDailyPackageGift = BaseClass("UIDailyPackageGift", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local HERO_SELECT_BORDER_PATH = "Assets/Main/Sprites/UI/UIDailyPackage/cfm_youhua_chaozhitehui_meiritehui_zhuangsh2.png"
local UNIQUE_SELECT_BORDER_PATH = "Assets/Main/Sprites/UI/UIDailyPackage/ljq_meiritehui_zhuanwusuipian_xing_02.png"
local AWAKEN_SELECT_BORDER_PATH = "Assets/Main/Sprites/UI/UIDailyPackageNoneAtlas/fx_meiritehui_zhuanwusuipian_xing.png"

function UIDailyPackageGift:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIDailyPackageGift:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIDailyPackageGift:ComponentDefine()
  self.reward_rect = self:AddComponent(UIBaseContainer, "Rect_Reward/Viewport/RewardContent")
  self._buy_btn = self:AddComponent(UIButton, "Btn_Buy")
  self._buy_btn:SetOnClick(function()
    self:OnClickReward()
  end)
  self._buy_btn:SetSafeClickMode(true)
  self._price_txt = self:AddComponent(UIText, "Btn_Buy/Txt_Price")
  self._point = self:AddComponent(UIGiftPackagePoint, "Btn_Buy/UIGiftPackagePoint")
  self.discountTip = self:AddComponent(UIBaseContainer, "DiscountInfo")
  self.discountTIpText = self:AddComponent(UIText, "DiscountInfo/DiscountText")
  self.heroPiece = self:AddComponent(UICommonResItem, "HeroPieceItem")
  self.addDiamond = self:AddComponent(UIBaseContainer, "AddDiamond")
  self.addDiamondIcon = self:AddComponent(UIImage, "AddDiamond/AddDiamondIcon")
  self.addDiamondText = self:AddComponent(UIText, "AddDiamond/AddDiamondText")
end

function UIDailyPackageGift:ComponentDestroy()
  self._buy_btn = nil
  self._price_txt = nil
  self._point = nil
  self.discountTip = nil
  self.discountTIpText = nil
  self.heroPiece = nil
  self.addDiamond = nil
  self.addDiamondIcon = nil
  self.addDiamondText = nil
end

function UIDailyPackageGift:DataDefine()
  self.param = {}
end

function UIDailyPackageGift:DataDestroy()
  self.heroPieceItemInfo = nil
  self.diamondCount = nil
  self.list = nil
end

function UIDailyPackageGift:ReInit(param, isBought, dailyPackageTemplate)
  self.param = param
  self.packageInfo = GiftPackageData.get(self.param)
  if not self.packageInfo then
    return
  end
  self.dailyPackageTemplate = dailyPackageTemplate
  if isBought or self.packageInfo:isBought() then
    UIGray.SetGray(self._buy_btn.transform, true, false)
    self._price_txt:SetLocalText(2000092)
    local discount = self.packageInfo:getPercent()
    if discount then
      self.discountTip:SetActive(true)
      self.discountTIpText:SetText(string.format("%d%%", discount))
    else
      self.discountTip:SetActive(false)
    end
    self._point:SetActive(false)
  else
    UIGray.SetGray(self._buy_btn.transform, false, true)
    self._price_txt:SetText(self.packageInfo:getPriceText())
    local discount = self.packageInfo:getPercent()
    if discount then
      self.discountTip:SetActive(true)
      self.discountTIpText:SetText(string.format("%d%%", discount))
    else
      self.discountTip:SetActive(false)
    end
    self._point:SetActive(true)
    self._point:RefreshPoint(self.packageInfo)
  end
  self:RefreshReward()
end

function UIDailyPackageGift:RefreshReward()
  local heroPieceItemInfo, diamondCount, list = self:GetRewardList()
  local needRefresh = false
  if heroPieceItemInfo and (self.heroPieceItemInfo == nil or self.heroPieceItemInfo.itemId ~= heroPieceItemInfo.itemId or self.heroPieceItemInfo.count ~= heroPieceItemInfo.count) then
    needRefresh = true
  end
  if self.diamondCount == nil or self.diamondCount ~= diamondCount then
    needRefresh = true
  end
  if not self.list then
    needRefresh = true
  end
  if not needRefresh then
    return
  end
  self.heroPieceItemInfo = heroPieceItemInfo
  self.diamondCount = diamondCount
  self.list = list
  self:ClearScroll()
  self.model = {}
  for i = 1, table.length(list) do
    self.model[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.reward_rect.transform)
      go.transform:Set_localScale(0.7, 0.74, ResetScale.z)
      go.transform:Set_pivot(0.5, 0.5)
      go.name = "item" .. i
      local cell = self.reward_rect:AddComponent(UICommonResItem, go.name)
      cell:ReInit(list[i])
    end)
  end
  if heroPieceItemInfo then
    self.heroPiece:SetActive(true)
    self.heroPiece:ReInit(heroPieceItemInfo)
    self.heroPiece:SetImgQuailtyShow(false)
    self.heroPiece:SetCustomNumText(string.format("\226\156\150%d", heroPieceItemInfo.count))
    local selectPath = HERO_SELECT_BORDER_PATH
    if self.dailyPackageTemplate.content_type == DailyPackageType.HeroUniqueWeapon then
      selectPath = UNIQUE_SELECT_BORDER_PATH
    elseif self.dailyPackageTemplate.content_type == DailyPackageType.HeroAwaken then
      selectPath = AWAKEN_SELECT_BORDER_PATH
    end
    self.heroPiece:SetCustomSelectIcon(selectPath)
  else
    self.heroPiece:SetActive(false)
  end
  if 0 < diamondCount then
    self.addDiamond:SetActive(true)
    self.addDiamondText:SetText(string.format("\226\156\150%d", diamondCount))
  else
    self.addDiamond:SetActive(false)
  end
end

function UIDailyPackageGift:GetRewardList()
  local listParam = {}
  local info = self.packageInfo
  listParam = DeepCopy(info:getItems(true))
  local dailyPackageReward
  if self.dailyPackageTemplate then
    dailyPackageReward = DeepCopy(self.dailyPackageTemplate:GetItemByPackageId(self.param))
  end
  if dailyPackageReward then
    local dailyPackageRewardList = dailyPackageReward
    table.insertto(dailyPackageRewardList, listParam)
    listParam = dailyPackageRewardList
  end
  local heroPieceItemInfo
  local diamondCount = 0
  local removeList = {}
  if not table.IsNullOrEmpty(listParam) then
    for i, v in pairs(listParam) do
      if v.rewardType == RewardType.GOODS and heroPieceItemInfo == nil then
        local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
        if itemTemplate and (itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99 or itemTemplate.type == GOODS_TYPE.GOODS_TYPE_98 or itemTemplate.type == GOODS_TYPE.GOODS_TYPE_142 or itemTemplate.type == GOODS_TYPE.GOODS_TYPE_191) then
          heroPieceItemInfo = v
          table.insert(removeList, i)
        end
      elseif v.rewardType == RewardType.GOLD then
        diamondCount = v.count
        table.insert(removeList, i)
      end
    end
  end
  if not table.IsNullOrEmpty(removeList) then
    local offset = 0
    for i = 1, #removeList do
      table.remove(listParam, removeList[i] - offset)
      offset = offset + 1
    end
  end
  return heroPieceItemInfo, diamondCount, listParam
end

function UIDailyPackageGift:ClearScroll()
  self.reward_rect:RemoveComponents(UICommonResItem)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
end

function UIDailyPackageGift:OnClickReward()
  local dailyConfig = self.dailyPackageTemplate
  if not dailyConfig then
    Logger.LogError("dailyConfig is nil!  ")
    return
  end
  if dailyConfig.content_type == DailyPackageType.Hero then
    self.view.ctrl:BuyGift(self.packageInfo)
    return
  end
  local result
  if dailyConfig.content_type == DailyPackageType.HeroUniqueWeapon then
    result = self:_onBuyUniqueWeapon()
  elseif dailyConfig.content_type == DailyPackageType.HeroAwaken then
    result = self:_onBuyAwaken()
  end
  if result then
    self.view.ctrl:BuyGift(self.packageInfo)
  end
end

function UIDailyPackageGift:_onBuyUniqueWeapon()
  local dailyConfig = self.dailyPackageTemplate
  local targetHeroId = dailyConfig.selectConditionHeroId
  local targetStarId = dailyConfig.selectConditionStarId
  local heroRankConfig = DataCenter.HeroRankTemplateManager:GetTemplate(targetStarId)
  if heroRankConfig == nil then
    Logger.LogError("isValid targetStarId!  Daily ID:" .. dailyConfig.id)
    return
  end
  local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(targetHeroId)
  if heroConfig == nil then
    Logger.LogError("isValid heroId!  Daily ID:" .. dailyConfig.id)
    return
  end
  local curStarId = 0
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(targetHeroId)
  if heroData ~= nil then
    curStarId = heroData.rankTemplate.id
  end
  if targetStarId > curStarId then
    UIUtil.ShowMessage(Localization:GetString("dailygift_buy_tips1", Localization:GetString(heroConfig.name)), 2, nil, nil, function()
      self.view.ctrl:BuyGift(self.packageInfo)
      return
    end)
    return
  end
  local uniqueMaxLv = DataCenter.HeroUniqueWeaponTemplateManager:GetMaxLevel(targetHeroId)
  local curUniqueLv = 0
  if heroData then
    curUniqueLv = heroData.uniqueWeaponLv
  end
  if uniqueMaxLv ~= 0 and uniqueMaxLv <= curUniqueLv and heroData:IsAllUnitMaxLv() then
    UIUtil.ShowMessage(Localization:GetString("dailygift_buy_tips2", Localization:GetString(heroConfig.name), uniqueMaxLv), 2, nil, nil, function()
      self.view.ctrl:BuyGift(self.packageInfo)
      return
    end)
    return
  end
  return true
end

function UIDailyPackageGift:_onBuyAwaken()
  local dailyConfig = self.dailyPackageTemplate
  local targetHeroId = dailyConfig:GetHeroId()
  local targetUniqueLv = dailyConfig.selectConditionStarId
  local heroConfig = DataCenter.HeroTemplateManager:GetTemplate(targetHeroId)
  if heroConfig == nil then
    Logger.LogError("isValid heroId!  Daily ID:" .. dailyConfig.id)
    return
  end
  local heroData = DataCenter.HeroDataManager:GetHeroByHeroId(targetHeroId)
  local curUniqueLv = 0
  if heroData then
    curUniqueLv = heroData.uniqueWeaponLv
  end
  if targetUniqueLv > curUniqueLv then
    UIUtil.ShowMessage(Localization:GetString("dailygift3_buy_2", Localization:GetString(heroConfig.name), targetUniqueLv), 2, nil, nil, function()
      self.view.ctrl:BuyGift(self.packageInfo)
      return
    end)
    return
  end
  local isMaxAwakenLv = heroData:IsHeroAwakenReachMaxLevel()
  local maxAwakenLv = heroData:GetHeroAwakenMaxLevel()
  if isMaxAwakenLv then
    UIUtil.ShowMessage(Localization:GetString("dailygift3_buy_4", Localization:GetString(heroConfig.name), maxAwakenLv), 2, nil, nil, function()
      self.view.ctrl:BuyGift(self.packageInfo)
      return
    end)
    return
  else
    local targetStar = dailyConfig.awakenConditionStarId
    local curAwakenStar = heroData:GetHeroAwakenRankLevel()
    if targetStar and curAwakenStar < dailyConfig.awakenConditionStarId then
      UIUtil.ShowMessage(Localization:GetString("dailygift3_buy_7", Localization:GetString(heroConfig.name), targetStar), 2, nil, nil, function()
        self.view.ctrl:BuyGift(self.packageInfo)
        return
      end)
      return
    end
  end
  return true
end

return UIDailyPackageGift
