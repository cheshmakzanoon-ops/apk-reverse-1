local LWResourceLackCell = BaseClass("LWResourceLackCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGiftPackagePoint = require("UI.UIGiftPackage.Component.UIGiftPackagePoint")
local TacticalWeaponUtils = require("DataCenter.TacticalWeapon.TacticalWeaponManager.TacticalWeaponUtils")

function LWResourceLackCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LWResourceLackCell:OnDestroy()
  self:ClearScroll()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function LWResourceLackCell:OnEnable()
  base.OnEnable(self)
end

function LWResourceLackCell:OnDisable()
  base.OnDisable(self)
end

function LWResourceLackCell:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CheckSeasonDevoteData, self.OnCheckSeasonDevoteData)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:AddUIListener(EventId.TacticalCardDailyLimitChanged, self.OnTacticalCardDailyLimitChanged)
  self:AddUIListener(EventId.BuildExpDataUpdated, self.OnBuildExpDataUpdated)
end

function LWResourceLackCell:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CheckSeasonDevoteData, self.OnCheckSeasonDevoteData)
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  self:RemoveUIListener(EventId.TacticalCardDailyLimitChanged, self.OnTacticalCardDailyLimitChanged)
  self:RemoveUIListener(EventId.BuildExpDataUpdated, self.OnBuildExpDataUpdated)
end

function LWResourceLackCell:ComponentDefine()
  self.lightBg = self:AddComponent(UIBaseContainer, "ItemBgLight")
  self.lightIcon = self:AddComponent(UIBaseContainer, "ItemIconLight")
  self.title1 = self:AddComponent(UIText, "ItemNameInfo")
  self.title2 = self:AddComponent(UIText, "ItemPowerInfo")
  self.iconBg = self:AddComponent(UIImage, "ImgQuality")
  self.icon = self:AddComponent(UIImage, "ItemIcon")
  self.multUseContent = self:AddComponent(UIBaseContainer, "MultUseContent")
  self.multUseBtn = self:AddComponent(UIButton, "MultUseContent/MultUseBtn")
  self.multUseText = self:AddComponent(UIText, "MultUseContent/MultUseBtn/MultUseText")
  self.multUseBtn:SetOnClick(function()
    self:OnMultUseClick()
  end)
  if self.transform:Find("MultUseContent/MultUseAllBtn") ~= nil then
    self.multUseAllBtn = self:AddComponent(UIButton, "MultUseContent/MultUseAllBtn")
    self.multUseAllText = self:AddComponent(UIText, "MultUseContent/MultUseAllBtn/MultUseAllText")
    self.multUseAllBtn:SetOnClick(function()
      self:OnMultUseAllClick()
    end)
  end
  self.gotoBtn = self:AddComponent(UIButton, "GotoBtn")
  self.gotoBtnText = self:AddComponent(UIText, "GotoBtn/GotoBtnTxt")
  self.gotoBtnImg = self:AddComponent(UIImage, "GotoBtn")
  self.gotoBtn:SetOnClick(function()
    self:OnGoToBtnClick()
  end)
  self.buyBtn = self:AddComponent(UIButton, "BuyBtn")
  self.buyBtnLimit = self:AddComponent(UIText, "BuyBtn/limit")
  self.buyBtnLayout = self:AddComponent(UIBaseContainer, "BuyBtn/BuyBtnLabel")
  self.buyBtnName = self:AddComponent(UIText, "BuyBtn/BuyBtnLabel/BuyBtnName")
  self.buyBtnText = self:AddComponent(UIText, "BuyBtn/BuyBtnLabel/BuyBtnValue")
  self.buyBtnTextShadow = self:AddComponent(UIShadow, "BuyBtn/BuyBtnLabel/BuyBtnValue")
  self.buyBtnIcon = self:AddComponent(UIImage, "BuyBtn/BuyBtnLabel/BuyBtnValue/SpendIcon")
  self.buyBtnIcon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
  self.buyBtnLimit:SetActive(false)
  self.buyBtn:SetOnClick(function()
    self:OnBuyBtnClick()
  end)
  self.multBuyBtn = self:AddComponent(UIButton, "MultUseContent/MultBuyBtn")
  self.multBuyPriceText = self:AddComponent(UIText, "MultUseContent/MultBuyBtn/price")
  self.multBuyBtn:SetOnClick(function()
    self:OnMultBuyBtnClick()
  end)
  self.giftPackageContent = self:AddComponent(UIBaseContainer, "GiftPackageContent")
  self.giftPackageItemScroll = self:AddComponent(UIScrollView, "GiftPackageContent/CellScroll")
  self.giftPackageItemScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnCreateCell(itemObj, index)
  end)
  self.giftPackageItemScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnDeleteCell(itemObj, index)
  end)
  self.packageNameText = self:AddComponent(UIText, "GiftPackageContent/PackageNameText")
  self.packageIcon = self:AddComponent(UIImage, "GiftPackageContent/PackageIcon")
  self.packageDiscountTip = self:AddComponent(UIText, "GiftPackageContent/DiscountTip")
  self.packageDiscountTipText = self:AddComponent(UIText, "GiftPackageContent/DiscountTip/DiscountTipText")
  self.payBtn = self:AddComponent(UIButton, "GiftPackageContent/PayBtn")
  self.payBtn:SetOnClick(function()
    self:OnPayBtnClick()
  end)
  self.payBtn:SetSafeClickMode(true)
  self.payBtnPriceText = self:AddComponent(UIText, "GiftPackageContent/PayBtn/PayBtnPriceText")
  self.giftPackPoint = self:AddComponent(UIGiftPackagePoint, "GiftPackageContent/PayBtn/UIGiftPackagePoint")
  self.defaultIconBg = self:AddComponent(UIImage, "DefaultImageQuality")
  self.item_count = self:TryAddComponent(UITextMeshProUGUIEx, "ItemCount")
  if self.item_count then
    self.item_count:SetText("")
  end
  self.descriptionText = self:TryAddComponent(UIText, "DescriptionText")
  self.nameTextWithInfoLayout = self:TryAddComponent(UIBaseComponent, "ItemNameInfoWithInfoLayout")
  self.nameTextWithInfo = self:TryAddComponent(UITextMeshProUGUIEx, "ItemNameInfoWithInfoLayout/ItemNameInfoWithInfo")
  self.nameTextInfoBtn = self:TryAddComponent(UIButton, "ItemNameInfoWithInfoLayout/ItemNameInfoBtn")
  if self.nameTextInfoBtn then
    self.nameTextInfoBtn:SetOnClick(function()
      self:OnNameTextInfoBtnClick()
    end)
  end
  self.completedText = self:TryAddComponent(UIText, "CompletedText")
  self.countdownText = self:TryAddComponent(UIText, "CountdownText")
  self.btnClickItemIcon = self:TryAddComponent(UIButton, "ItemIcon")
  if self.btnClickItemIcon then
    self.btnClickItemIcon:SetOnClick(function()
      self:OnBtnClickItemIcon()
    end)
  end
end

function LWResourceLackCell:ShowUseBtn(IsOn)
  self.multUseBtn:SetActive(IsOn)
  self.multBuyBtn:SetActive(not IsOn)
  if self.multUseAllBtn then
    local showUseAllBtn = false
    if self.data.res_item == ResourceItemId.HeroExp and self.data.tips == LWResourceLackGetWay.UseItem then
      showUseAllBtn = true
    end
    self:ShowUseAllBtn(showUseAllBtn)
  end
end

function LWResourceLackCell:ShowUseAllBtn(showUseAllBtn)
  self.multUseAllBtn:SetActive(showUseAllBtn)
  if showUseAllBtn then
    local items = DataCenter.ItemData:GetItemById(self.data.para1)
    local itemCount = items and items.count or 0
    self.multUseAllText:SetText(Localization:GetString("110200") .. " x" .. itemCount)
  end
end

function LWResourceLackCell:ComponentDestroy()
  self:DestroyTimeLimitIcon()
  if self.data and self.data.tips == LWResourceLackGetWay.ClaimFreeStamina then
    self.gotoBtnImg:LoadSprite("Assets/Main/Sprites/UI/UILWAlliance/cfm_tongyong_anniu_3.png")
  end
  if not IsNull(self.gotoBtn) and not IsNull(self.gotoBtn.transform) then
    CS.UIGray.SetGray(self.gotoBtn.transform, false, true)
  end
  self:RemoveClaimFreeStaminaTimer()
  self:RemoveCountDownTimer()
  self.lightBg = nil
  self.lightIcon = nil
  self.title1 = nil
  self.title2 = nil
  self.iconBg = nil
  self.icon = nil
  self.multUseContent = nil
  self.multUseBtn = nil
  self.multUseText = nil
  self.multUseAllBtn = nil
  self.multUseAllText = nil
  self.gotoBtn = nil
  self.gotoBtnText = nil
  self.buyBtn = nil
  self.buyBtnName = nil
  self.buyBtnText = nil
  self.buyBtnTextShadow = nil
  self.buyBtnIcon = nil
  self.giftPackageContent = nil
  self.giftPackageItemScroll = nil
  self.packageNameText = nil
  self.packageIcon = nil
  self.packageDiscountTip = nil
  self.packageDiscountTipText = nil
  self.payBtn = nil
  self.payBtnPriceText = nil
  self.giftPackPoint = nil
  self.gotoBtnImg = nil
  self.descriptionText = nil
  self.completedText = nil
  self.countdownText = nil
end

function LWResourceLackCell:DataDefine()
  self.staminaTime = 0
  self.leftTime = 0
  self.isShowSpendLessFeature = false
end

function LWResourceLackCell:DataDestroy()
  self.packageData = nil
  self.packageRewardList = nil
  self.isVipPack = nil
  self.vipPackLv = nil
  self.vipPackState = nil
  self.ProcessPurchaseCallback = nil
  self.MessageBoxCallback = nil
  self.isShowSpendLessFeature = false
  self.leftTime = 0
  self:StopDescCountdownTimer()
end

local DefaultBgPath = "Assets/Main/Sprites/UI/LWCommon/Sprite/zyf_ziyuanbucong_di.png"

function LWResourceLackCell:RefreshBgIcon(template)
  self.defaultIconBg:SetActive(false)
  self.iconBg:SetActive(false)
  if not template then
    return
  end
  local color = template.color
  if color <= 0 then
  else
    self.iconBg:SetActive(true)
    self.iconBg:LoadSprite(UIUtil.GetItemQualityBg(color))
  end
end

function LWResourceLackCell:ParseResourceLackTemplate(data, ctrl, param)
  local context
  local tips = data.tips
  local itemId = 0
  local itemCount = 0
  if tips == LWResourceLackGetWay.UseItem then
    itemId = toInt(data.goods)
    itemCount = UIUtil.GetHaveCount(ResLackContextType.Good, itemId)
    context = {
      id = itemId,
      type = ResLackContextType.Good
    }
    if self.item_count and param and param.ShowItemCount then
      self.item_count:SetText(string.GetFormattedStr(itemCount))
    end
  elseif tips == LWResourceLackGetWay.GotoUserMail then
  elseif tips == LWResourceLackGetWay.GotoMummyCenter then
  end
  self.param = param
  self:Refresh(false, data, ctrl, context)
end

function LWResourceLackCell:Init()
end

function LWResourceLackCell:GetPic()
  if not self.data then
    return ""
  end
  if self.data.tips == LWResourceLackGetWay.GotoTacticalCardBox then
    local boxId = TacticalCardUtil.GetPreferGuideBoxId(self.context.cardId)
    if boxId then
      local boxTemplate = DataCenter.TacticalCardDataManager:GetBoxTemplate(boxId)
      if boxTemplate then
        return boxTemplate:GetIcon()
      end
    end
  elseif self.data.tips == LWResourceLackGetWay.FirstPayGetExp then
    local payExpData = DataCenter.FirstPayManager:GetCurBuildExpData()
    if payExpData and payExpData.goldPigItemId and payExpData.goldPigItemId > 0 then
      return DataCenter.ItemTemplateManager:GetIconPath(payExpData.goldPigItemId)
    end
  end
  return self.data.pic
end

function LWResourceLackCell:RefreshDes()
  if not self.data then
    return
  end
  if self.data.tips == LWResourceLackGetWay.TacticalCardDailyLimit then
    local boxId = tonumber(self.data.para1)
    if not boxId then
      return
    end
    local curNum, maxNum = DataCenter.TacticalCardDataManager:GetDailyLimit(boxId)
    if maxNum == 0 then
      curNum = ""
      maxNum = ""
    end
    self.title2:SetText(Localization:GetString(self.data.des, curNum, maxNum))
  elseif self.data.tips == LWResourceLackGetWay.FirstPayGetExp then
    local stashExp = 0
    if DataCenter.FirstPayManager.buildExpData then
      stashExp = DataCenter.FirstPayManager.buildExpData:GetCurRemainStashExpStr() or 0
    end
    self.title2:SetText(Localization:GetString(self.data.des, stashExp))
  elseif self.data.tips == LWResourceLackGetWay.GoToSeasonTower then
    self:AddCountDownTimer(self.OnRefreshSeasonTowerDesc)
    self:OnRefreshSeasonTowerDesc()
  end
end

function LWResourceLackCell:SetIsShowSpendLessFeature(state)
  self.isShowSpendLessFeature = state
end

function LWResourceLackCell:Refresh(lightBgActive, template, ctrl, context)
  self.data = template
  self.context = context
  self.ctrl = ctrl
  if self.data.tips ~= LWResourceLackGetWay.GoBuilding then
    self:RefreshLightBg(lightBgActive)
  end
  local pic = self:GetPic()
  if not string.IsNullOrEmpty(pic) then
    self.icon:LoadSpriteAuto(pic)
  end
  if not string.IsNullOrEmpty(template.name) then
    self.title1:SetText(Localization:GetString(template.name))
  end
  self.multUseContent:SetActive(false)
  self.chooseItemIndex = nil
  self.continueUse = false
  if self.descriptionText then
    self.descriptionText:SetActive(false)
  end
  self:RemoveCountDownTimer()
  if self.completedText then
    self.completedText:SetActive(false)
  end
  if self.countdownText then
    self.countdownText:SetActive(false)
  end
  self:StopDescCountdownTimer()
  if template.tips == LWResourceLackGetWay.GiftPackage or template.tips == LWResourceLackGetWay.GiftPackageList then
    self.iconBg:SetActive(false)
    self.giftPackageContent:SetActive(true)
    self.title1:SetActive(false)
    self.title2:SetActive(false)
    if self.nameTextWithInfoLayout then
      self.nameTextWithInfoLayout:SetActive(false)
    end
    self.icon:SetLocalScaleXYZ(1, 1, 1)
  elseif template.tips == LWResourceLackGetWay.FirstPayGetExp then
    self.title1:SetActive(false)
    if self.nameTextWithInfoLayout then
      self.nameTextWithInfoLayout:SetActive(true)
    end
    self.nameTextWithInfo:SetText(Localization:GetString(template.name))
    self.icon:SetLocalScaleXYZ(1.2, 1.2, 1)
  else
    self.iconBg:SetActive(true)
    self.giftPackageContent:SetActive(false)
    self.title1:SetActive(true)
    self.title2:SetActive(true)
    if self.nameTextWithInfoLayout then
      self.nameTextWithInfoLayout:SetActive(false)
    end
    self.icon:SetLocalScaleXYZ(1, 1, 1)
  end
  self:RefreshBgIcon(template)
  self:DestroyTimeLimitIcon()
  local mainLv = DataCenter.BuildManager.MainLv
  if mainLv < self.data.minLevel then
    self.title2:SetText(Localization:GetString("450089", self.data.minLevel))
    self.giftPackageContent:SetActive(false)
  elseif string.IsNullOrEmpty(template.des) then
    self.title2:SetText("")
    self.giftPackageContent:SetActive(false)
  elseif template.tips == LWResourceLackGetWay.GotoUserMail then
    self.iconBg:SetActive(false)
    self.title1:SetLocalText(template.name)
    self.title2:SetLocalText(template.des)
  elseif template.tips == LWResourceLackGetWay.GotoMummyCenter then
    self.iconBg:SetActive(false)
    self.title1:SetLocalText(template.name)
    self.title2:SetLocalText(template.des)
  elseif template.tips == LWResourceLackGetWay.UseItem or template.tips == LWResourceLackGetWay.DecoSelfSelectItem then
    local items = DataCenter.ItemData:GetItemById(template.para1)
    local itemCount = items and items.count or 0
    local itemTempalte = DataCenter.ItemTemplateManager:GetItemTemplate(template.para1)
    local desc
    if itemTempalte then
      local itemType = itemTempalte.type
      if itemTempalte:IsSelectBox() or itemType == GOODS_TYPE.GOODS_TYPE_109 then
        local name = Localization:GetString(template.name)
        self:RefreshPerGainCount(itemType, itemTempalte)
        local isShowSelectBoxHaveNum = true
        if itemType == GOODS_TYPE.GOODS_TYPE_59 and (itemTempalte.popupType == GOODS_POPUP_TYPE.Hero or itemTempalte.popupType == GOODS_POPUP_TYPE.Dominator or itemTempalte.popupType == GOODS_POPUP_TYPE.TWSkillChip or itemTempalte.popupType == GOODS_POPUP_TYPE.CommonRewardSelection) then
          isShowSelectBoxHaveNum = false
        end
        if self.perGainItemCount and 0 < self.perGainItemCount and isShowSelectBoxHaveNum then
          name = string.format("%s (%s)", name, string.GetFormattedStr(self.perGainItemCount))
        else
          name = string.format("%s", name)
        end
        self.title1:SetText(name)
      elseif itemType == GOODS_TYPE.GOODS_TYPE_133 then
        local name = DataCenter.ItemTemplateManager:GetName(template.para1)
        self.title1:SetText(name)
      else
        self.title1:SetText(itemTempalte:GetName())
      end
    end
    self.title2:SetText(Localization:GetString(template.des, itemCount))
  elseif template.tips == LWResourceLackGetWay.ZombieBattle then
    if DataCenter.StageManager.stageId then
      local stageMeta = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage), DataCenter.StageManager.stageId)
      if stageMeta then
        local stageName = Localization:GetString(stageMeta.name)
        self.title2:SetText(Localization:GetString(template.des, stageName))
      end
    else
      self.title2:SetText(Localization:GetString(450054))
    end
  elseif template.tips == LWResourceLackGetWay.BuyGiftBag then
  elseif template.tips == LWResourceLackGetWay.CityCollection then
    local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(self.data.para1))
    if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
      Logger.LogError("\230\178\161\230\156\137\229\187\186\231\173\145\231\177\187\229\158\139:" .. self.data.para1)
      return
    end
    local total = 0
    for k, v in pairs(buildList) do
      local storage = DataCenter.ProductLineManager:GetBuildingCurrStorage(v.uuid)
      total = total + storage
    end
    self.title2:SetText(Localization:GetString(template.des, math.floor(total)))
  elseif template.tips == LWResourceLackGetWay.HangUp then
    self.title2:SetText(Localization:GetString(template.des, 0))
  elseif template.tips == LWResourceLackGetWay.QuestReward then
    local total = DataCenter.ChapterTaskManager:GetAllChapterRewardsByRes(self.context.resType) or 0
    self.title2:SetText(Localization:GetString(template.des, math.floor(total)))
  elseif template.tips == LWResourceLackGetWay.Buy then
    if template.special_trigger and template.special_trigger == ResLackContextType.Energy then
      local recoverNum = 0
      local goldStr = LuaEntry.DataConfig:TryGetStr("role_stamina", "k1")
      local strArr = string.split(goldStr, "|")
      local useCount = LuaEntry.Player:GetCurStaminaGoldNum()
      if 0 < #strArr then
        local index = math.min(useCount + 1, #strArr)
        local str = strArr[index]
        local arr = string.split(str, ";")
        if 2 <= #arr then
          recoverNum = tonumber(arr[2])
        end
      end
      self.title2:SetText(Localization:GetString(template.des, recoverNum))
    else
      self.title2:SetText(Localization:GetString(template.des))
    end
  elseif template.tips == LWResourceLackGetWay.GiftPackage then
    local packsInfo
    local groups = string.split(self.data.para1, "|")
    for i = 1, #groups do
      packsInfo = GiftPackManager.GetPacksByGroupId(groups[i], false)
      packsInfo = GiftPackManager.FilterVipPacksExclude(packsInfo, VipPayGoodState.HasGet, true)
      if not table.IsNullOrEmpty(packsInfo) then
        break
      end
    end
    if table.IsNullOrEmpty(packsInfo) then
      return
    end
    self.packageData = packsInfo[1]
    self.packageNameText:SetText(self.packageData:getNameText())
    self.packageIcon:LoadSprite(template.pic)
    self.packageIcon:SetNativeSize()
    self.packageIcon:SetLocalScaleXYZ(0.8, 0.8, 1)
    if self.packageData:hasPercent() then
      self.packageDiscountTip:SetActive(true)
      self.packageDiscountTipText:SetText(self.packageData:getPercent() .. "%")
    else
      self.packageDiscountTip:SetActive(false)
      self.packageDiscountTipText:SetText("")
    end
    self:ClearScroll()
    self.packageRewardList = self.packageData:getItems(false)
    if 0 < #self.packageRewardList then
      self.giftPackageItemScroll:SetActive(true)
      self.giftPackageItemScroll:SetTotalCount(#self.packageRewardList)
      self.giftPackageItemScroll:RefillCells()
    else
      self.giftPackageItemScroll:SetActive(false)
    end
  elseif template.tips == LWResourceLackGetWay.ClaimFreeStamina then
    local cd = LuaEntry.DataConfig:TryGetNum("role_stamina", "k3")
    local count = LuaEntry.DataConfig:TryGetNum("role_stamina", "k2")
    self.title2:SetText(Localization:GetString(template.des, UITimeManager:GetInstance():SecondToFmtStringForCountdownByDialog(cd), count - LuaEntry.Player.todayFreeStamina))
    self.staminaTime = UIUtil.GetFreeStaminaTime()
    local staminaFree = LuaEntry.DataConfig:TryGetNum("role_stamina", "k4")
    local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SEASON_EFFECT_94037)
    staminaFree = staminaFree * (1 + effectValue)
    self.title1:SetText(Localization:GetString("season_mastery_UI_tips_23", staminaFree))
  elseif template.tips == LWResourceLackGetWay.GroupActivity then
  elseif template.tips == LWResourceLackGetWay.GiftPackageList then
    local packInfo
    local packs = string.split(self.data.para1, "|") or {}
    for i = 1, #packs do
      local pack = GiftPackManager.get(packs[i])
      if pack and 0 < pack:getCountdown() and pack:canGet() then
        packInfo = pack
        break
      end
    end
    if packInfo == nil then
      return
    end
    self.packageData = packInfo
    self.packageNameText:SetText(self.packageData:getNameText())
    self.packageIcon:LoadSprite(template.pic)
    self.packageIcon:SetNativeSize()
    self.packageIcon:SetLocalScaleXYZ(0.8, 0.8, 1)
    if self.packageData:hasPercent() then
      self.packageDiscountTip:SetActive(true)
      self.packageDiscountTipText:SetLocalText(2000111, self.packageData:getPercent())
    else
      self.packageDiscountTip:SetActive(false)
      self.packageDiscountTipText:SetText("")
    end
    self:ClearScroll()
    self.packageRewardList = self.packageData:getItems(false)
    if 0 < #self.packageRewardList then
      self.giftPackageItemScroll:SetActive(true)
      self.giftPackageItemScroll:SetTotalCount(#self.packageRewardList)
      self.giftPackageItemScroll:RefillCells()
    else
      self.giftPackageItemScroll:SetActive(false)
    end
  elseif template.tips == LWResourceLackGetWay.ChooseUseItem then
    local items = DataCenter.ItemData:GetItemById(template.para1)
    local itemCount = items and items.count or 0
    local itemTempalte = DataCenter.ItemTemplateManager:GetItemTemplate(template.para1)
    if itemTempalte then
      self.title1:SetText(itemTempalte:GetName())
    end
    self.title2:SetText(Localization:GetString(template.des, itemCount))
  elseif template.tips == LWResourceLackGetWay.GuideToUseChooseBox then
    local items = DataCenter.ItemData:GetItemById(template.para1)
    local itemCount = items and items.count or 0
    local itemTempalte = DataCenter.ItemTemplateManager:GetItemTemplate(template.para1)
    local desc
    if itemTempalte then
      local itemType = itemTempalte.type
      if itemType == GOODS_TYPE.GOODS_TYPE_109 then
        local name = Localization:GetString(template.name)
        self:RefreshPerGainCount(itemType, itemTempalte)
        if self.perGainItemCount and 0 < self.perGainItemCount then
          name = string.format("%s (%s)", name, string.GetFormattedStr(self.perGainItemCount))
        else
          name = string.format("%s", name)
        end
        self.title1:SetText(name)
      elseif itemType == GOODS_TYPE.GOODS_TYPE_133 then
        local name = DataCenter.ItemTemplateManager:GetName(template.para1)
        self.title1:SetText(name)
      else
        self.title1:SetText(itemTempalte:GetName())
      end
    end
    self.title2:SetText(Localization:GetString(template.des, itemCount))
  elseif template.tips == LWResourceLackGetWay.DecoChipExchange then
    local items = DataCenter.ItemData:GetItemById(template.para1)
    local itemCount = items and items.count or 0
    local itemTempalte = DataCenter.ItemTemplateManager:GetItemTemplate(template.para1)
    if itemTempalte then
      self.title1:SetText(itemTempalte:GetName())
    end
    self.title2:SetText(Localization:GetString(template.des, itemCount))
  elseif template.tips == LWResourceLackGetWay.ResourceList then
    local speed = LWResourceLackUtil:GetResourceSpeedCountPerHour(self.context.resType)
    self.title1:SetLocalText(template.name)
    self.title2:SetText(string.GetFormattedStr(speed) .. "/H")
    self:CreateTimeLimitIcon()
  elseif template.tips == LWResourceLackGetWay.ActivityAndCheckOpen or template.tips == LWResourceLackGetWay.GoToActivityAndDontCloseSelf or template.tips == LWResourceLackGetWay.GotoWorldBossTask then
    local rawDes = Localization:GetString(template.des)
    local rawName = Localization:GetString(template.name)
    local fillDes = string.contains(rawDes, "{0}")
    local fillName = string.contains(rawName, "{0}")
    if fillDes or fillName then
      local idList = string.split(tostring(template.para1), "|")
      for _, v in ipairs(idList) do
        local activityNameKey = ""
        local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tonumber(v))
        if actInfo then
          activityNameKey = actInfo.activityName or ""
        else
          activityNameKey = LocalController:instance():getValue(TableName.Activity, tonumber(v), "name") or ""
        end
        if fillDes then
          rawDes = Localization:GetString(template.des, Localization:GetString(activityNameKey))
        end
        if fillName then
          rawName = Localization:GetString(template.name, Localization:GetString(activityNameKey))
        end
        break
      end
    end
    self.title1:SetText(rawName)
    self.title2:SetText(rawDes)
  elseif template.tips == LWResourceLackGetWay.GotoEmptyActivity then
    if self.descriptionText then
      self.descriptionText:SetActive(true)
      self.descriptionText:SetLocalText("rescource_activity_08")
    end
    local rawDes = Localization:GetString(template.des)
    local rawName = Localization:GetString(template.name)
    local fillDes = string.contains(rawDes, "{0}")
    local fillName = string.contains(rawName, "{0}")
    if fillDes or fillName then
      local idList = string.split(tostring(template.para2), "|")
      if idList[1] then
        local activityName = Localization:GetString(LocalController:instance():getValue(TableName.Activity, tonumber(idList[1]), "name"))
        if fillDes then
          rawDes = Localization:GetString(template.des, activityName)
        end
        if fillName then
          rawName = Localization:GetString(template.name, activityName)
        end
      end
    end
    self.title1:SetText(rawName)
    self.title2:SetText(rawDes)
  elseif template.tips == LWResourceLackGetWay.GiftShopSell then
    local rawDes = Localization:GetString(template.des)
    local rawName = Localization:GetString(template.name)
    self.title1:SetText(rawName)
    self.title2:SetText(rawDes)
  elseif template.tips == LWResourceLackGetWay.GiftShopNotSell or template.tips == LWResourceLackGetWay.LackTypeMutal or template.tips == LWResourceLackGetWay.OnlyDescType or template.tips == LWResourceLackGetWay.GoSeasonActivityEmpty then
    local rawDes = Localization:GetString(template.des)
    local rawName = Localization:GetString(template.name)
    self.title1:SetText(rawName)
    self.title2:SetText(rawDes)
  elseif template.tips == LWResourceLackGetWay.TacticalCardDailyLimit then
    self.title1:SetLocalText(template.name)
    self:RefreshDes()
  elseif template.tips == LWResourceLackGetWay.GoToSeasonTower then
    self:RefreshDes()
  elseif template.tips == LWResourceLackGetWay.FirstPayGetExp then
    self:RefreshDes()
  elseif template.des == "season_s4_lack_tips_3603" then
    local dailyDropTimes = toInt(DataCenter.SeasonDataManager.dailyDropTimes)
    local dailyDropMaxTimes = toInt(GetTableData(TableName.WorldTreasure, 33, "daily_max", 5))
    self.title2:SetText(Localization:GetString(template.des, string.format("%s/%s", dailyDropTimes, dailyDropMaxTimes)))
  elseif template.tips == LWResourceLackGetWay.MultiUseItem then
    local itemId = LWResourceLackUtil:GetShowItemIdFromMultiUseItemGetWay(template)
    if not itemId then
      if not string.IsNullOrEmpty(template.name) then
        self.title1:SetText(Localization:GetString(template.name))
      end
      if not string.IsNullOrEmpty(template.des) then
        self.title2:SetText(Localization:GetString(template.des))
      end
    else
      local items = DataCenter.ItemData:GetItemById(itemId)
      local itemCount = items and items.count or 0
      local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
      local desc
      if itemTemplate then
        local itemType = itemTemplate.type
        if itemTemplate:IsSelectBox() or itemType == GOODS_TYPE.GOODS_TYPE_109 then
          local name = Localization:GetString(template.name)
          self:RefreshPerGainCount(itemType, itemTemplate)
          local isShowSelectBoxHaveNum = true
          if itemType == GOODS_TYPE.GOODS_TYPE_59 and (itemTemplate.popupType == GOODS_POPUP_TYPE.Hero or itemTemplate.popupType == GOODS_POPUP_TYPE.Dominator) then
            isShowSelectBoxHaveNum = false
          end
          if self.perGainItemCount and 0 < self.perGainItemCount and isShowSelectBoxHaveNum then
            name = string.format("%s (%s)", name, string.GetFormattedStr(self.perGainItemCount))
          else
            name = string.format("%s", name)
          end
          self.title1:SetText(name)
        elseif itemType == GOODS_TYPE.GOODS_TYPE_133 then
          local name = DataCenter.ItemTemplateManager:GetName(itemId)
          self.title1:SetText(name)
        else
          self.title1:SetText(itemTemplate:GetName())
        end
      end
      self.title2:SetText(Localization:GetString(template.des, itemCount))
    end
  else
    self.title2:SetText(Localization:GetString(template.des))
  end
  if self.data.tips == LWResourceLackGetWay.UseItem or self.data.tips == LWResourceLackGetWay.DecoSelfSelectItem then
    local items = DataCenter.ItemData:GetItemById(self.data.para1)
    local itemCount = items and items.count or 0
    if 0 < itemCount then
      self:RefreshUseCell(items)
    end
  elseif self.data.tips == LWResourceLackGetWay.BuyGiftBag and self.costGoldNum then
    self:RefreshBuyCell()
  elseif self.data.tips == LWResourceLackGetWay.MultiUseItem then
    local itemId = LWResourceLackUtil:GetShowItemIdFromMultiUseItemGetWay(self.data)
    if itemId then
      local items = DataCenter.ItemData:GetItemById(itemId)
      local itemCount = items and items.count or 0
      if 1 < itemCount then
        self:RefreshUseCell(items)
      end
    end
  end
  self:RefreshButton()
end

function LWResourceLackCell:RefreshUseCount()
  local items = DataCenter.ItemData:GetItemById(self.data.para1)
  self:RefreshUseCell(items)
end

function LWResourceLackCell:OnMultBuyBtnClick()
  self:BuyGiftBag(self.useNum, true)
end

function LWResourceLackCell:RefreshLightBg(lightBgActive)
  self.lightBg:SetActive(lightBgActive)
end

function LWResourceLackCell:RefreshCollectionCount()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(tonumber(self.data.para1))
  if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
    Logger.LogError("\230\178\161\230\156\137\229\187\186\231\173\145\231\177\187\229\158\139:" .. self.data.para1)
    return
  end
  local total = 0
  for k, v in pairs(buildList) do
    local storage = DataCenter.ProductLineManager:GetBuildingCurrStorage(v.uuid)
    total = total + storage
  end
  self.title2:SetText(Localization:GetString(self.data.des, math.floor(total)))
end

function LWResourceLackCell:AddClaimFreeStaminaTimer()
  if self.claimFreeStaminaTimer == nil then
    self.claimFreeStaminaTimer = TimerManager:GetInstance():GetTimer(1, self.ClaimStaminaTimeUpdate, self, false, false, false)
    self.claimFreeStaminaTimer:Start()
  end
end

function LWResourceLackCell:ClaimStaminaTimeUpdate()
  if self.staminaTime == nil then
    self:RemoveClaimFreeStaminaTimer()
    self:RefreshButton()
    return
  end
  if self.staminaTime <= 0 then
    self:RemoveClaimFreeStaminaTimer()
  end
  self.staminaTime = self.staminaTime - 1
  if self.staminaTime <= 1 then
    self:RemoveClaimFreeStaminaTimer()
    self:RefreshButton()
  else
    self.gotoBtnText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.staminaTime * 1000))
  end
end

function LWResourceLackCell:RemoveClaimFreeStaminaTimer()
  if self.claimFreeStaminaTimer then
    self.claimFreeStaminaTimer:Stop()
    self.claimFreeStaminaTimer = nil
  end
end

function LWResourceLackCell:RefreshStamina()
  local cd = LuaEntry.DataConfig:TryGetNum("role_stamina", "k3")
  local count = LuaEntry.DataConfig:TryGetNum("role_stamina", "k2")
  self.title2:SetText(Localization:GetString(self.data.des, UITimeManager:GetInstance():SecondToFmtStringForCountdownByDialog(cd), count - LuaEntry.Player.todayFreeStamina))
  self.staminaTime = UIUtil.GetFreeStaminaTime()
  self:RefreshButton()
end

function LWResourceLackCell:RefreshButton()
  self.buyBtnLimit:SetActive(false)
  if not string.IsNullOrEmpty(self.data.btn_name) then
    self.gotoBtnText:SetText(Localization:GetString(self.data.btn_name))
    self.buyBtnName:SetText(Localization:GetString(self.data.btn_name))
  end
  if self.data.tips == LWResourceLackGetWay.GotoMummyCenter then
    self.gotoBtn:SetActive(true)
    self.buyBtn:SetActive(false)
    self.gotoBtnText:SetLocalText("450037")
  elseif self.data.tips == LWResourceLackGetWay.Buy then
    self.gotoBtn:SetActive(false)
    self.buyBtn:SetActive(true)
    self.costGoldNum = 0
    if self.data.special_trigger and self.data.special_trigger == ResLackContextType.Energy then
      local goldStr = LuaEntry.DataConfig:TryGetStr("role_stamina", "k1")
      local strArr = string.split(goldStr, "|")
      local useCount = LuaEntry.Player:GetCurStaminaGoldNum()
      if 0 < #strArr then
        local index = math.min(useCount + 1, #strArr)
        local str = strArr[index]
        local arr = string.split(str, ";")
        if 2 <= #arr then
          self.costGoldNum = tonumber(arr[1])
        end
      end
    end
    self.buyBtnIcon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
    self.buyBtnText:SetText(string.GetFormattedSeperatorNum(self.costGoldNum))
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buyBtnText.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buyBtn.rectTransform)
    self:RefreshColor(LuaEntry.Player.gold)
  elseif self.data.tips == LWResourceLackGetWay.DiamondStore then
    self.gotoBtn:SetActive(false)
    self.buyBtn:SetActive(true)
    self.costGoldNum = 0
    local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(CommonShopType.Goods, tonumber(self.data.para1))
    if goodsConf then
      self.costGoldNum = goodsConf.costNum
    end
    self.buyBtnText:SetText(string.GetFormattedSeperatorNum(self.costGoldNum))
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buyBtnText.rectTransform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buyBtn.rectTransform)
    self.buyBtnText:SetColor(WhiteColor)
    self.buyBtnTextShadow:AllEnable(true)
  elseif self.data.tips == LWResourceLackGetWay.GiftPackage or self.data.tips == LWResourceLackGetWay.GiftPackageList then
    self.gotoBtn:SetActive(false)
    self.buyBtn:SetActive(false)
    self.payBtn:SetActive(true)
    self.payBtnPriceText:SetColor(WhiteColor)
    if self.packageData then
      local packId = self.packageData:getID()
      local isVipPack = DataCenter.VIPManager:IsVipPack(packId)
      self.isVipPack = isVipPack
      if not self.isVipPack then
        self.payBtnPriceText:SetText(self.packageData:getPriceText())
        CS.UIGray.SetGray(self.payBtn.transform, false, true)
        self.giftPackPoint:SetActive(true)
        self.giftPackPoint:RefreshPoint(self.packageData)
      else
        self.vipPackLv = DataCenter.VIPManager:GetPackVipLv(packId)
        self.vipPackState = DataCenter.VIPManager:AnalyzePayGoodState(self.vipPackLv, packId)
        if self.vipPackState == VipPayGoodState.HasGet or self.vipPackState == VipPayGoodState.CanGet then
          self.giftPackPoint:SetActive(false)
          return
        elseif self.vipPackState == VipPayGoodState.CanBuy then
          self.payBtnPriceText:SetText(self.packageData:getPriceText())
          CS.UIGray.SetGray(self.payBtn.transform, false, true)
          self.giftPackPoint:SetActive(true)
          self.giftPackPoint:RefreshPoint(self.packageData)
        elseif self.vipPackState == VipPayGoodState.Lock then
          self.payBtnPriceText:SetLocalText(2000292)
          CS.UIGray.SetGray(self.payBtn.transform, true, true)
          self.giftPackPoint:SetActive(false)
        end
      end
    else
      self.giftPackPoint:SetActive(false)
    end
  elseif self.data.tips == LWResourceLackGetWay.BuyGiftBag then
    local goodsConf = DataCenter.ItemTemplateManager:GetItemTemplate(self.data.para1)
    self.costGoldNum = 0
    if goodsConf then
      self.costGoldNum = goodsConf.price
    end
    self:RefreshBuyCell()
    self.buyBtnText:SetText(string.GetFormattedStr(self.costGoldNum))
    self.gotoBtn:SetActive(false)
    self.buyBtn:SetActive(true)
  elseif self.data.tips == LWResourceLackGetWay.ClaimFreeStamina then
    self.gotoBtn:SetActive(true)
    self.gotoBtnImg:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/tongyong_cfm_anniu_1.png")
    self.buyBtn:SetActive(false)
    if self.staminaTime ~= nil and 0 < self.staminaTime then
      self.gotoBtnText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.staminaTime * 1000))
      self:AddClaimFreeStaminaTimer()
      CS.UIGray.SetGray(self.gotoBtn.transform, true, false)
    else
      self.gotoBtnText:SetLocalText(self.data.btn_name)
      CS.UIGray.SetGray(self.gotoBtn.transform, false, true)
    end
  elseif self.data.tips == LWResourceLackGetWay.FirstPayGetExp then
    local stashExp = 0
    if DataCenter.FirstPayManager.buildExpData then
      stashExp = DataCenter.FirstPayManager.buildExpData:GetCurRemainStashExp() or 0
    end
    self.gotoBtn:SetActive(0 < stashExp)
    self.buyBtn:SetActive(false)
    local isBoughtFirstPay = DataCenter.FirstPayManager:IsHasBoughtFirstPay()
    local btnSpritePath = string.format("Assets/Main/Sprites/UI/LWCommon/Sprite/%s", isBoughtFirstPay and "tongyong_cfm_anniu_1.png" or "tongyong_cfm_anniu_5.png")
    self.gotoBtnImg:LoadSprite(btnSpritePath)
    self.gotoBtnText:SetLocalText(isBoughtFirstPay and "450099" or "450004")
  elseif self.data.tips == LWResourceLackGetWay.VIPShop then
    if self.data.goods == 200002 then
      self.gotoBtn:SetActive(false)
      self.buyBtn:SetActive(true)
      self.costGoldNum = 0
      local shopId = 0
      local paraSplitStr = string.split(self.data.para1, "|")
      if paraSplitStr[1] then
        shopId = tonumber(paraSplitStr[1])
      end
      local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(CommonShopType.Vip, shopId)
      if goodsConf then
        self.costGoldNum = goodsConf.costNum
        local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(CommonShopType.Vip, shopId)
        local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
        if 0 < goodsConf.maxTimes then
          self.buyBtnLimit:SetActive(true)
          self.buyBtnLimit:SetLocalText(458283, goodsConf.maxTimes - boughtTimes)
        end
      end
      self.buyBtnIcon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
      self.buyBtnText:SetText(string.GetFormattedSeperatorNum(self.costGoldNum))
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buyBtnText.rectTransform)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buyBtnLayout.rectTransform)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buyBtn.rectTransform)
      self:RefreshColor(LuaEntry.Player.gold)
    elseif self.isShowSpendLessFeature and not LWResourceLackUtil:HasAnyShopCanBuy(self.data, CommonShopType.Vip) then
      self:SetBtnCompletedState(129060)
    else
      self:SetDefaultBtnState()
    end
  elseif self.data.tips == LWResourceLackGetWay.AllianceShop then
    if self.data.goods == 200002 then
      self.gotoBtn:SetActive(false)
      self.buyBtn:SetActive(true)
      self.costGoldNum = 0
      local shopId = 0
      local paraSplitStr = string.split(self.data.para1, "|")
      if paraSplitStr[1] then
        shopId = tonumber(paraSplitStr[1])
      end
      local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(CommonShopType.AllianceShop, shopId)
      if goodsConf then
        self.costGoldNum = goodsConf.costNum
        local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(CommonShopType.AllianceShop, shopId)
        local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
        if 0 < goodsConf.maxTimes then
          self.buyBtnLimit:SetActive(true)
          self.buyBtnLimit:SetLocalText(458283, goodsConf.maxTimes - boughtTimes)
        end
      end
      self.buyBtnLimit:SetActive(true)
      self.buyBtnIcon:LoadSprite("Assets/Main/Sprites/UI/UILWAlliance/zyf_lianmengkejijuanxian_jifen_xiao.png")
      self.buyBtnText:SetText(string.GetFormattedSeperatorNum(self.costGoldNum))
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buyBtnText.rectTransform)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buyBtnLayout.rectTransform)
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.buyBtn.rectTransform)
      local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
      if baseData ~= nil then
        self:RefreshColor(baseData.accPoint)
      end
    elseif self.isShowSpendLessFeature and not LWResourceLackUtil:HasAnyShopCanBuy(self.data, CommonShopType.AllianceShop) then
      self:SetBtnCompletedState(129060)
    else
      self:SetDefaultBtnState()
    end
  elseif self.data.tips == LWResourceLackGetWay.GoCommonShop then
    if self.isShowSpendLessFeature and not LWResourceLackUtil:HasAnyShopCanBuy_GoCommonShop(self.data) then
      self:SetBtnCompletedState(129060)
    else
      self:SetDefaultBtnState()
    end
  elseif self.data.tips == LWResourceLackGetWay.HonorShopNew then
    if self.isShowSpendLessFeature and not LWResourceLackUtil:HasAnyShopCanBuy(self.data, CommonShopType.HonorShop) then
      self:SetBtnCompletedState(129060)
    else
      self:SetDefaultBtnState()
    end
  elseif self.data.tips == LWResourceLackGetWay.SecretTask then
    if self.isShowSpendLessFeature and DataCenter.ActDispatchTaskDataManager:IsAllSingleTaskDispatched() then
      self:SetBtnCompletedState(170008)
    else
      self:SetDefaultBtnState()
    end
  elseif self.data.tips == LWResourceLackGetWay.TruckStation then
    if self.isShowSpendLessFeature and DataCenter.LWMyStationDataManager:IsAllTruckDispatchedAndRobUsedUp() then
      self:SetBtnCompletedState(170008)
    else
      self:SetDefaultBtnState()
    end
  elseif self.data.tips == LWResourceLackGetWay.DailyTask then
    if self.isShowSpendLessFeature and DataCenter.DailyTaskManager:IsAllBoxRewardReceived() then
      self:SetBtnCompletedState(170008)
    else
      self:SetDefaultBtnState()
    end
  elseif self.data.tips == LWResourceLackGetWay.AllyDuel then
    if self.isShowSpendLessFeature and DataCenter.AllianceCompeteDataManager:IsAll9BoxRewardReceived() then
      self:SetBtnCompletedState(170008)
    else
      self:SetDefaultBtnState()
    end
  elseif self.data.tips == LWResourceLackGetWay.Promote then
    if self.isShowSpendLessFeature and DataCenter.RadarCenterDataManager:GetUnFinishedDetectEventNum() == 0 then
      local nextRefreshTime = DataCenter.RadarCenterDataManager:GetDetectInfoNextRefreshTime()
      local now = UITimeManager:GetInstance():GetServerTime()
      local remainTime = math.max(math.ceil((nextRefreshTime - now) / 1000), 0)
      self:SetBtnCountdownState(remainTime)
    else
      self:SetDefaultBtnState()
    end
  elseif self.data.tips == LWResourceLackGetWay.PersonalArms then
    if self.isShowSpendLessFeature and DataCenter.ActivityPersonalArmsDataManager:IsAllBoxRewardReceivedByType(EnumActivity.PersonalArmsNew.Type) then
      local actData = DataCenter.ActivityPersonalArmsDataManager:GetDataByType(EnumActivity.PersonalArmsNew.Type)
      local remainTime = 0
      if actData ~= nil and actData.stage_end_time ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerSeconds()
        local leftTime = actData.stage_end_time - curTime
        remainTime = math.max(leftTime, 0)
      end
      self:SetBtnCountdownState(remainTime)
    else
      self:SetDefaultBtnState()
    end
  elseif self.data.tips == LWResourceLackGetWay.ActivityAndCheckOpen or self.data.tips == LWResourceLackGetWay.GoToActivityAndDontCloseSelf then
    if self.isShowSpendLessFeature and not UIUtil.CheckWayTypeOfActivityAndCheckOpenIsOpen(self.data) then
      self:SetBtnCompletedState("activity_commander_tips1")
    else
      self:SetDefaultBtnState()
    end
  elseif self.data.tips == LWResourceLackGetWay.VIPGiftPackage then
    local functionUnlock, tip = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_VIP)
    if functionUnlock then
      self.gotoBtn:SetActive(true)
      self.buyBtn:SetActive(false)
      self.payBtn:SetActive(false)
    else
      self.gotoBtn:SetActive(true)
      self.gotoBtnText:SetLocalText(tip)
      self.buyBtn:SetActive(false)
      self.payBtn:SetActive(false)
    end
  elseif self.data.tips == LWResourceLackGetWay.ResourceList then
    self.gotoBtn:SetActive(true)
    self.buyBtn:SetActive(false)
    self.payBtn:SetActive(false)
  elseif self.data.tips == LWResourceLackGetWay.GotoEmptyActivity then
    self.gotoBtn:SetActive(false)
    self.buyBtn:SetActive(false)
    self.payBtn:SetActive(false)
  elseif self.data.tips == LWResourceLackGetWay.GiftShopSell then
    self.gotoBtn:SetActive(false)
    self.buyBtn:SetActive(false)
    self.payBtn:SetActive(false)
  elseif self.data.tips == LWResourceLackGetWay.GiftShopNotSell or self.data.tips == LWResourceLackGetWay.LackTypeMutal or self.data.tips == LWResourceLackGetWay.OnlyDescType or self.data.tips == LWResourceLackGetWay.GoSeasonActivityEmpty then
    self.gotoBtn:SetActive(false)
    self.buyBtn:SetActive(false)
    self.payBtn:SetActive(false)
  else
    self:SetDefaultBtnState()
  end
end

function LWResourceLackCell:SetBtnCompletedState(textId)
  self.gotoBtn:SetActive(false)
  self.buyBtn:SetActive(false)
  if self.completedText then
    self.completedText:SetActive(true)
    self.completedText:SetLocalText(textId)
  end
end

function LWResourceLackCell:SetBtnCountdownState(time)
  self.leftTime = math.max(math.ceil(time or 0), 0)
  self.gotoBtn:SetActive(self.leftTime <= 0)
  self.buyBtn:SetActive(false)
  if self.countdownText then
    self.countdownText:SetActive(self.leftTime > 0)
  end
  if self.leftTime <= 0 then
    return
  end
  if self.countdownText then
    self.countdownText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.leftTime * 1000))
  end
  self:StopDescCountdownTimer()
  self.descCountdownTimer = TimerManager:GetInstance():GetTimer(1, self.UpdateCountdownTime, self, false, false, false)
  self.descCountdownTimer:Start()
end

function LWResourceLackCell:UpdateCountdownTime()
  if self.leftTime == nil then
    self:StopDescCountdownTimer()
    return
  end
  self.leftTime = math.max(self.leftTime - 1, 0)
  if self.countdownText then
    self.countdownText:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.leftTime * 1000))
  end
  if self.leftTime <= 0 then
    self.gotoBtn:SetActive(true)
    if self.countdownText then
      self.countdownText:SetActive(false)
    end
    self:StopDescCountdownTimer()
    EventManager:GetInstance():Broadcast(EventId.RefreshLackViewList)
  end
end

function LWResourceLackCell:StopDescCountdownTimer()
  if self.descCountdownTimer then
    self.descCountdownTimer:Stop()
    self.descCountdownTimer = nil
  end
end

function LWResourceLackCell:SetDefaultBtnState()
  self.gotoBtn:SetActive(true)
  self.buyBtn:SetActive(false)
end

function LWResourceLackCell:RefreshBuyCell(isClick)
  local goodsConf = DataCenter.ItemTemplateManager:GetItemTemplate(self.data.para1)
  if goodsConf == nil then
    return
  end
  self:ShowUseBtn(false)
  local have = UIUtil.GetHaveCount(self.context.type, self.context.id or self.context.resType)
  local need = self.context.need
  local count = Mathf.Ceil((need - have) / tonumber(goodsConf.para))
  if isClick then
    count = count - 1
  end
  if 1 < count then
    self.multUseContent:SetActive(true)
  end
  self.useNum = count
  local gold = count * self.costGoldNum
  self.multBuyPriceText:SetText(string.GetFormattedGoldNum(gold))
  self.multBuyPriceText:SetColor(gold > LuaEntry.Player.gold and RedColor or WhiteColor)
end

function LWResourceLackCell:RefreshColor(gold)
  if gold ~= nil and self.costGoldNum ~= nil then
    if gold < self.costGoldNum then
      self.buyBtnText:SetColor(RedColor)
      self.buyBtnTextShadow:AllEnable(false)
    else
      self.buyBtnText:SetColor(WhiteColor)
      self.buyBtnTextShadow:AllEnable(true)
    end
  end
end

function LWResourceLackCell:OnBuyBtnClick()
  local mainLv = DataCenter.BuildManager.MainLv
  if mainLv < self.data.minLevel then
    self:GuideToUpgradeMainBuilding()
  elseif self.data.tips == LWResourceLackGetWay.Buy then
    self:GuideToBuy()
  elseif self.data.tips == LWResourceLackGetWay.DiamondStore then
    self:GuideToDiamondStore()
  elseif self.data.tips == LWResourceLackGetWay.BuyGiftBag then
    self:RefreshBuyCell(true)
    self:BuyGiftBag(1)
  elseif self.data.tips == LWResourceLackGetWay.AllianceShop then
    local shopIdList = {}
    local paraSplitList = string.split(self.data.para1, "|")
    for i, v in ipairs(paraSplitList) do
      table.insert(shopIdList, tonumber(v))
    end
    for _, shopId in ipairs(shopIdList) do
      local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(CommonShopType.AllianceShop, shopId)
      local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(CommonShopType.AllianceShop, shopId)
      if goodsConf then
        local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
        if not (0 < goodsConf.maxTimes) or not (boughtTimes >= goodsConf.maxTimes) then
          if goodsConf.GetInconsistentConditions then
            local inconsistentConditions = goodsConf:GetInconsistentConditions()
            if not table.IsNullOrEmpty(inconsistentConditions) then
              goto lbl_120
            end
          end
          DataCenter.CommonShopManager:Buy(goodsConf.id, goodsConf.shopType, function(buyCount)
            SFSNetwork.SendMessage(MsgDefines.BuyCommonShopGoods, shopId, nil, buyCount)
          end)
          break
        end
      end
      ::lbl_120::
    end
  elseif self.data.tips == LWResourceLackGetWay.VIPShop then
    local shopIdList = {}
    local paraSplitList = string.split(self.data.para1, "|")
    for i, v in ipairs(paraSplitList) do
      table.insert(shopIdList, tonumber(v))
    end
    for _, shopId in ipairs(shopIdList) do
      local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(CommonShopType.Vip, shopId)
      local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(CommonShopType.Vip, shopId)
      if goodsConf then
        local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
        if not (0 < goodsConf.maxTimes) or not (boughtTimes >= goodsConf.maxTimes) then
          if goodsConf.GetInconsistentConditions then
            local inconsistentConditions = goodsConf:GetInconsistentConditions()
            if not table.IsNullOrEmpty(inconsistentConditions) then
              goto lbl_201
            end
          end
          DataCenter.CommonShopManager:Buy(goodsConf.id, goodsConf.shopType, function(buyCount)
            SFSNetwork.SendMessage(MsgDefines.BuyCommonShopGoods, shopId, nil, buyCount)
          end)
          break
        end
      end
      ::lbl_201::
    end
  elseif self.data.tips == LWResourceLackGetWay.TrailTowerShop then
    local shopId = tonumber(self.data.para1)
    local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(CommonShopType.TrailTowerShop, shopId)
    if goodsConf then
      DataCenter.CommonShopManager:Buy(goodsConf.id, goodsConf.shopType, function(buyCount)
        SFSNetwork.SendMessage(MsgDefines.BuyCommonShopGoods, shopId, nil, buyCount)
      end)
    end
  end
end

function LWResourceLackCell:GetChipSelectedBoxOrder(config)
  local order
  if config ~= nil and not string.IsNullOrEmpty(config.para1) then
    local chipPairList = string.split(config.para1, "|")
    for i, itemIdDara in ipairs(chipPairList) do
      local strList = string.split(itemIdDara, ",")
      local itemId = tonumber(strList[1])
      local itemConfig = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
      if itemConfig and itemConfig.linked_item_type == ItemLinkType.DroneSkillChip then
        local chipId = itemConfig.linked_item_id
        if chipId == self.context.chipId then
          order = i
          break
        end
      end
    end
  end
  if not order then
    Logger.LogError("order is error")
  end
  return order
end

function LWResourceLackCell:BuyGiftBag(number, isAll)
  local goodsConf = DataCenter.ItemTemplateManager:GetItemTemplate(self.data.para1)
  local buyGold = goodsConf.price * number
  if buyGold <= LuaEntry.Player.gold then
    local function OnConfirm()
      UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog, Localization:GetString(GameDialogDefine.COST_DIAMOND_CONFIRM_TIPS2, string.GetFormattedSeperatorNum(buyGold)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.BuyItemAndResource, nil, {
          [goodsConf.id] = number
        })
        UIUtil.ShowTipsId(320004)
        if isAll and self.multUseContent then
          self.multUseContent:SetActive(false)
        end
      end, function()
      end)
    end
    
    if DataCenter.LWResourceLackManager:IsShowGoldSecondConfirmByGoldNum(buyGold) then
      UIUtil.ShowMessage(Localization:GetString("diamond_lack_tips"), 2, GameDialogDefine.RESOURCE_LACK_FILL, GameDialogDefine.STILL_CONTINUE, function()
        if self.context then
          local lackTab = {}
          local param = {
            resType = self.context.resType,
            need = self.context.need
          }
          table.insert(lackTab, param)
          LWResourceLackUtil:GotoResLack(lackTab)
        end
      end, function()
        OnConfirm()
      end, nil, "diamond_lack_title")
      DataCenter.LWResourceLackManager:SetHasShownGoldSecondConfirmToday()
    else
      OnConfirm()
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.DiamondShop)
  end
end

function LWResourceLackCell:OnPayBtnClick()
  if (self.data.tips == LWResourceLackGetWay.GiftPackage or self.data.tips == LWResourceLackGetWay.GiftPackageList) and self.packageData then
    if not self.isVipPack then
      DataCenter.PayManager:CallPayment(self.packageData, "GoldExchangeView", "")
    elseif self.vipPackState == VipPayGoodState.CanBuy then
      DataCenter.PayManager:CallPayment(self.packageData, "GoldExchangeView", "")
    elseif self.vipPackState == VipPayGoodState.Lock then
      UIUtil.ShowTips(Localization:GetString(2000370, self.vipPackLv))
    end
  end
end

function LWResourceLackCell:GuideToBuy()
  if self.data.special_trigger and self.data.special_trigger == ResLackContextType.Energy then
    if LuaEntry.Player.gold >= self.costGoldNum then
      local useCount = LuaEntry.Player:GetCurStaminaGoldNum()
      local needTipNum = 0
      if useCount >= needTipNum then
        local recoverNum = 0
        local goldStr = LuaEntry.DataConfig:TryGetStr("role_stamina", "k1")
        local strArr = string.split(goldStr, "|")
        local useCount = LuaEntry.Player:GetCurStaminaGoldNum()
        if 0 < #strArr then
          local index = math.min(useCount + 1, #strArr)
          local str = strArr[index]
          local arr = string.split(str, ";")
          if 2 <= #arr then
            recoverNum = tonumber(arr[2])
          end
        end
        UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyStaminaTip, Localization:GetString("450116", self.costGoldNum, recoverNum), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          UIUtil.ShowTips(Localization:GetString(120028, Localization:GetString(self.data.name), 1))
          SFSNetwork.SendMessage(MsgDefines.UserRecoverPlayerStamina)
        end)
      else
        UIUtil.ShowTips(Localization:GetString(120028, Localization:GetString(self.data.name), 1))
        SFSNetwork.SendMessage(MsgDefines.UserRecoverPlayerStamina)
      end
    else
      GoToUtil.GotoPayTips(self.costGoldNum)
    end
  else
  end
end

function LWResourceLackCell:GuideToDiamondStore()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_SHOP)
  if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
    GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_BUILD_SHOP)
    return
  end
  local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(CommonShopType.Goods, tonumber(self.data.para1))
  if goodsConf then
    if self.ProcessPurchaseCallback == nil then
      function self.ProcessPurchaseCallback(buyCount)
        if not DataCenter.CommonShopManager:CheckCostEnough(goodsConf, true) then
          return
        end
        local configNum = LuaEntry.DataConfig:TryGetNum("diamond_shop_config", "k1", 1)
        local costGoldNum = goodsConf.costNum * buyCount
        if self.MessageBoxCallback == nil then
          function self:MessageBoxCallback(buyCount)
            SFSNetwork.SendMessage(MsgDefines.BuyCommonShopGoods, goodsConf.id, nil, buyCount)
          end
        end
        if configNum <= costGoldNum then
          UIUtil.ShowMessage(Localization:GetString("shop_cost_alarm_001", costGoldNum), 2, nil, nil, Bind(self, self.MessageBoxCallback, buyCount), nil, nil)
        else
          self:MessageBoxCallback(buyCount)
        end
      end
    end
    DataCenter.CommonShopManager:OnClickBuyBtn(goodsConf, self.ProcessPurchaseCallback, self.context.need)
  else
    Logger.LogError("\233\146\187\231\159\179\229\149\134\229\186\151\229\134\133\230\178\161\230\156\137\233\129\147\229\133\183: " .. self.data.para1)
  end
end

function LWResourceLackCell:GuideToVIPShop()
  local gotoShopId
  local shopIdList = {}
  local paraSplitList = string.split(self.data.para1, "|")
  for i, v in ipairs(paraSplitList) do
    table.insert(shopIdList, tonumber(v))
  end
  for _, shopId in ipairs(shopIdList) do
    local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(CommonShopType.Vip, shopId)
    local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(CommonShopType.Vip, shopId)
    if goodsConf then
      local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
      if not (0 < goodsConf.maxTimes) or not (boughtTimes >= goodsConf.maxTimes) then
        if goodsConf.GetInconsistentConditions then
          local inconsistentConditions = goodsConf:GetInconsistentConditions()
          if not table.IsNullOrEmpty(inconsistentConditions) then
            goto lbl_67
          end
        end
        gotoShopId = shopId
        break
      end
    end
    ::lbl_67::
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.Vip, gotoShopId)
end

function LWResourceLackCell:GuideToTrailTowerShop()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.TrailTowerShop)
end

function LWResourceLackCell:GuideToActivity()
  if self.data.tips == LWResourceLackGetWay.Activity and self.data.para1 == "cross_king" then
    local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local mainBuildLV = DataCenter.BuildManager.MainLv
    if configSchedule == nil or configSchedule.needMainCityLevel ~= nil and mainBuildLV < configSchedule.needMainCityLevel or curTime >= configSchedule.endTime or curTime < configSchedule.startTime or not DataCenter.ZoneWarManager:IsBattleMember() then
      UIUtil.ShowTipsId(801606)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentServerBattleMain)
    end
    return
  end
  local idList = string.split(tostring(self.data.para1), "|")
  for _, v in ipairs(idList) do
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tonumber(v))
    if actInfo ~= nil then
      GoToUtil.GoActWindow({
        tonumber(actInfo.id)
      })
      break
    end
  end
end

function LWResourceLackCell:GuideToActivityCheckOpen(closeAllWindow)
  local idList = string.split(tostring(self.data.para1), "|")
  for _, v in ipairs(idList) do
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tonumber(v))
    if actInfo ~= nil then
      if actInfo.type == EnumActivity.DecorationGacha.Type then
        PostEventLog.Track(PostEventLog.Defines.GoActDecorationGachaMainOpenFromLackPage, {})
      end
      GoToUtil.GoActWindow({
        tonumber(actInfo.id)
      }, closeAllWindow)
      break
    end
  end
end

function LWResourceLackCell:GuideToActivityShopOpen()
  local idList = string.split(tostring(self.data.para1), "|")
  for _, v in ipairs(idList) do
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tonumber(v))
    if actInfo ~= nil then
      GoToUtil.GotoActShopWindowMission(tonumber(actInfo.id))
      break
    end
  end
end

function LWResourceLackCell:GuideToSeasonMain()
  local id = tonumber(self.data.para1)
  if id and 0 < id then
    SeasonUtil.ShowSeasonUI(UIWindowNames.UILWSeasonMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, id)
  end
end

function LWResourceLackCell:GuideToHeroMonthCard()
  local needMonthCardId = tonumber(self.data.para1)
  local cardData = DataCenter.HeroMonthCardManager:GetHeroMonthCardInfo(needMonthCardId)
  local template
  local targetRechargeId = 0
  if cardData ~= nil then
    template = DataCenter.HeroMonthCardManager:GetTemplate(cardData.activityId)
    targetRechargeId = DataCenter.HeroMonthCardManager:GetRechargeIdByExchangeId(cardData.exchangeId)
  end
  if template ~= nil and targetRechargeId and 0 < targetRechargeId then
    PostEventLog.Track(PostEventLog.Defines.HeroMonthCardResLackTip, {})
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, nil, targetRechargeId)
  end
end

function LWResourceLackCell:OnGoToBtnClick()
  local mainLv = DataCenter.BuildManager.MainLv
  local tips = self.data.tips
  if mainLv < self.data.minLevel then
    self:GuideToUpgradeMainBuilding()
  elseif tips == LWResourceLackGetWay.GotoMummyAllianceCenter then
    local build = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
    if build and build.status ~= AllianceMineStatus.FoldUp then
      build:JumpTo()
    else
      SFSNetwork.SendMessage(MsgDefines.GetCrossOccupyCityList)
      GoToUtil.GoToAllianceFurnace()
    end
  elseif tips == LWResourceLackGetWay.GotoMummyCenter then
    if DataCenter.SeasonMummyDataManager:GetWaitConvertArmyCount() == 0 then
      UIUtil.ShowTipsId("season_s3_Mummy_tips014")
    else
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(), ForceChangeScene.World), CS.SceneManager.World.InitZoom)
    end
  elseif tips == LWResourceLackGetWay.GotoUserMail then
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoOpenView(UIWindowNames.UILWMailMain)
  elseif tips == LWResourceLackGetWay.SeasonBuild then
    if SeasonUtil.IsInSeasonDesertMode() then
      GoToUtil.CloseAllWindows()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonBuild, {
        anim = true,
        hideTop = false,
        UIMainAnim = UIMainAnimType.AllHide
      }, 2)
    else
      UIUtil.ShowTipsId(2000012)
    end
  elseif tips == LWResourceLackGetWay.SeasonScience then
    if SeasonUtil.IsInSeason() then
      local hasAlliance = LuaEntry.Player:IsInAlliance()
      if hasAlliance then
        GoToUtil.CloseAllWindows()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlMain, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        })
      else
        UIUtil.ShowTipsId("800935")
      end
    else
      UIUtil.ShowTipsId(2000012)
    end
  elseif tips == LWResourceLackGetWay.GoSeasonActivity then
    self.ctrl:CloseSelf()
    GoToUtil.GotoSeasonActivityView(self.data.para1)
  elseif tips == LWResourceLackGetWay.FirstPayGetExp then
    local isBoughtFirstPay = DataCenter.FirstPayManager:IsHasBoughtFirstPay()
    if not isBoughtFirstPay then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFirstPay, {
        anim = false,
        UIMainAnim = UIMainAnimType.AllHide
      }, {delay = 0.5})
    else
      local stashExp = 0
      if DataCenter.FirstPayManager.buildExpData then
        stashExp = DataCenter.FirstPayManager.buildExpData:GetCurRemainStashExp() or 0
      end
      if 0 < stashExp then
        SFSNetwork.SendMessage(MsgDefines.FirstRechargeReward)
      end
    end
  elseif tips == LWResourceLackGetWay.GoSeasonWeekCard then
    GoToUtil.GotoSeasonWeekCardView()
  elseif tips == LWResourceLackGetWay.GoSeasonFLINT then
    local maxLevel = DataCenter.SeasonDataManager:GetDesertMaxLevel()
    if maxLevel == nil or maxLevel == 0 then
      maxLevel = 1
    end
    GoToUtil.CloseAllWindows()
    SFSNetwork.SendMessage(MsgDefines.FindResourcePoint, ResourceType.FLINT, maxLevel)
  elseif tips == LWResourceLackGetWay.GoSeasonOBSIDIAN then
    local maxLevel = DataCenter.SeasonDataManager:GetDesertMaxLevel()
    if maxLevel == nil or maxLevel == 0 then
      maxLevel = 1
    end
    GoToUtil.CloseAllWindows()
    SFSNetwork.SendMessage(MsgDefines.FindResourcePoint, ResourceType.OBSIDIAN, maxLevel)
  elseif self.data.tips == LWResourceLackGetWay.CityCollection then
    self:GuideToCityCollection()
  elseif self.data.tips == LWResourceLackGetWay.UseItem or self.data.tips == LWResourceLackGetWay.DecoSelfSelectItem or self.data.tips == LWResourceLackGetWay.MultiUseItem then
    self:GuideToUseItem()
  elseif self.data.tips == LWResourceLackGetWay.Recruit then
    self:GuideToRecruit()
  elseif self.data.tips == LWResourceLackGetWay.ZombieBattle then
    self:GuideToZombieBattle()
  elseif self.data.tips == LWResourceLackGetWay.UpgradeBuilding then
    self:GuideToUpgradeBuilding()
  elseif self.data.tips == LWResourceLackGetWay.WorldMonster then
    self:GuideToWorldMonster()
  elseif self.data.tips == LWResourceLackGetWay.Gather then
    self:GuideToWorldGatherMonster()
  elseif self.data.tips == LWResourceLackGetWay.WorldCollection then
    self:GuideToWorldCollection()
  elseif self.data.tips == LWResourceLackGetWay.HangUp then
    self:GuideToHangUp()
  elseif self.data.tips == LWResourceLackGetWay.Pay then
    self:GuideToPay()
  elseif self.data.tips == LWResourceLackGetWay.QuestReward then
    self:GuideToQuestReward()
  elseif self.data.tips == LWResourceLackGetWay.Promote then
    self:GuideToPromote()
  elseif self.data.tips == LWResourceLackGetWay.EquipForge then
    self:GuideToEquip(true)
  elseif self.data.tips == LWResourceLackGetWay.EquipCompose then
    self:GuideToEquip(false)
  elseif self.data.tips == LWResourceLackGetWay.SoldierTrain then
    self:GuideToSoldierTrain()
  elseif self.data.tips == LWResourceLackGetWay.AllyDuel then
    self:GuideToAllyDuel()
  elseif self.data.tips == LWResourceLackGetWay.AllianceShop then
    self:GuideToAllianceShop()
  elseif self.data.tips == LWResourceLackGetWay.AllianceHelp then
    self:GuideToAllianceHelp()
  elseif self.data.tips == LWResourceLackGetWay.AllianceDonate then
    self:GuideToAllianceDonate()
  elseif self.data.tips == LWResourceLackGetWay.BuyGiftBag then
    self:GuideToBuyGiftBag()
  elseif self.data.tips == LWResourceLackGetWay.ClaimFreeStamina then
    self:GuideToClaim()
  elseif self.data.tips == LWResourceLackGetWay.VIPShop then
    self:GuideToVIPShop()
  elseif self.data.tips == LWResourceLackGetWay.Activity then
    self:GuideToActivity()
  elseif self.data.tips == LWResourceLackGetWay.ActivityAndCheckOpen then
    self:GuideToActivityCheckOpen()
  elseif self.data.tips == LWResourceLackGetWay.GoToActivityAndDontCloseSelf then
    self:GuideToActivityCheckOpen(false)
  elseif self.data.tips == LWResourceLackGetWay.GotoActShop then
    self:GuideToActivityShopOpen()
  elseif self.data.tips == LWResourceLackGetWay.HeroMonthCard then
    self:GuideToHeroMonthCard()
  elseif self.data.tips == LWResourceLackGetWay.GoBuilding then
    local data = DataCenter.BuildManager:GetFunbuildByItemID(tonumber(self.data.para1))
    if data and data:GetCenterVec() then
      GoToUtil.CloseAllWindows()
      GoToUtil.GotoPos(data:GetCenterVec(), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
        local param = {}
        param.position = CS.CSUtils.WorldPositionToUISpacePosition(data:GetCenterVec())
        param.arrowType = ArrowType.Building
        param.positionType = PositionType.Screen
        DataCenter.ArrowManager:ShowArrow(param)
      end)
    end
  elseif self.data.tips == LWResourceLackGetWay.DailyBuy then
    self:GuidToDailyMustBuyPanel()
  elseif self.data.tips == LWResourceLackGetWay.WeeklyBuy then
    self:GuidToWeeklyMustBuyPanel()
  elseif self.data.tips == LWResourceLackGetWay.WorldBoss then
    self:GuideToWorldBoss()
  elseif self.data.tips == LWResourceLackGetWay.Radar then
    self:GuideToRadar()
  elseif self.data.tips == LWResourceLackGetWay.ActivityShop then
    local para1 = self.data.para1
    if not string.IsNullOrEmpty(para1) then
      local str = string.split(para1, "|") or {}
      if str and 3 <= #str then
        local actId = str[1]
        local giftPackGroupId = str[2]
        local costResItemIds = {}
        local costResItemStr = str[3]
        local split = string.split(costResItemStr, ";") or {}
        for i = 1, #split do
          local itemId = tonumber(split[i])
          table.insert(costResItemIds, itemId)
        end
        GoToUtil.GotoActShopWindow(actId, giftPackGroupId, costResItemIds)
      end
    end
  elseif self.data.tips == LWResourceLackGetWay.DailyTask then
    self:GuideToDailyTask()
  elseif self.data.tips == LWResourceLackGetWay.SaveGirl then
    self:GuideToSaveGirl()
  elseif self.data.tips == LWResourceLackGetWay.Arena3V3 then
    self:GuideToArena3V3()
  elseif self.data.tips == LWResourceLackGetWay.HonorShop then
    self:GuideToHonorShop()
  elseif self.data.tips == LWResourceLackGetWay.SurvivorRecruit then
    self:GuideToSurvivorRecruit()
  elseif self.data.tips == LWResourceLackGetWay.VIPDailyReward then
    self:GuideToVIPDailyReward()
  elseif self.data.tips == LWResourceLackGetWay.AllyStation then
    self:GuideToAllianceStation()
  elseif self.data.tips == LWResourceLackGetWay.TruckStation then
    self:GuideToTruckStation()
  elseif self.data.tips == LWResourceLackGetWay.AllyDrill then
    self:GuideToActivityByActivityType(EnumActivity.AllyDrill, false)
  elseif self.data.tips == LWResourceLackGetWay.HeroTrail then
    self:GuideToActivityByActivityType(EnumActivity.KillZombieActivity, false)
  elseif self.data.tips == LWResourceLackGetWay.ZombieInvasion then
    self:GuideToActivityByActivityType(EnumActivity.MonsterInvasion, false)
  elseif self.data.tips == LWResourceLackGetWay.DesertStormBattleField then
    self:GuideToActivityByActivityType(EnumActivity.ActDragon, false)
  elseif self.data.tips == LWResourceLackGetWay.PersonalArms then
    self:GuideToActivityByActivityType(EnumActivity.PersonalArmsNew, false)
  elseif self.data.tips == LWResourceLackGetWay.SecretTask then
    self:GuideToActivityByActivityType(EnumActivity.DispatchTask, false)
  elseif self.data.tips == LWResourceLackGetWay.GoSeasonMain then
    self:GuideToSeasonMain()
  elseif self.data.tips == LWResourceLackGetWay.GogoBuilding then
    local buildId = tonumber(self.data.para1)
    local res_item = self.data.res_item
    GoToUtil.CloseAllWindows()
    if res_item == ResourceType.AllianceStone then
      local cityInfo = DataCenter.AllianceCityTemplateManager:GetNearestCity(LuaEntry.Player:GetMainWorldPos(), WorldAllianceCityType.City)
      if cityInfo then
        local cityPos = SceneUtils.TileIndexToWorld(cityInfo:GetPointId(), ForceChangeScene.World)
        GoToUtil.GotoWorldPos(cityPos)
      else
        GoToUtil.GotoNearestCity(true, WorldAllianceCityType.City)
      end
    else
      GoToUtil.GotoCityByBuildId(buildId)
    end
  elseif self.data.tips == LWResourceLackGetWay.GogoAllianceCity then
    local cityInfo = DataCenter.AllianceCityTemplateManager:GetNearestCity(LuaEntry.Player:GetMainWorldPos(), WorldAllianceCityType.City)
    if cityInfo then
      local cityPos = SceneUtils.TileIndexToWorld(cityInfo:GetPointId(), ForceChangeScene.World)
      GoToUtil.GotoWorldPos(cityPos)
    else
      GoToUtil.GotoNearestCity(true, WorldAllianceCityType.City)
    end
  elseif self.data.tips == LWResourceLackGetWay.GoSeasonRewardPanel then
    local seasonType = SeasonUtil.GetSeasonType()
    if seasonType ~= SeasonMapType.Nothing or seasonType ~= SeasonMapType.Desert then
      self.ctrl:CloseSelf()
      if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UILWSingleActivityContainer) then
        EventManager:GetInstance():Broadcast(EventId.UILWSingleActivityContainerOpenPanel, {
          activityId = "SeasonScoreReward"
        })
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSingleActivityContainer, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, "SeasonScoreReward")
      end
    else
      local id = tonumber(self.data.para1)
      GoToUtil.GotoOpenView(UIWindowNames.UILWSeasonReward, id)
    end
  elseif self.data.tips == LWResourceLackGetWay.GoAllianceSeasonRank then
    if LuaEntry.Player:IsInAlliance() then
      if SeasonUtil.IsInSeason() then
        local existDevoteData = DataCenter.SeasonDataManager.ExistDevoteData
        if not existDevoteData then
          SFSNetwork.SendMessage(MsgDefines.CheckSeasonDevoteData, LuaEntry.Player:GetAllianceUid())
        else
          local tab = tonumber(self.data.para1)
          GoToUtil.GotoOpenView(UIWindowNames.LWSeasonAllianceRank, tab)
        end
      else
        UIUtil.ShowTipsId("season_tips179")
      end
    else
      UIUtil.ShowTipsId("season_tips179")
    end
  elseif self.data.tips == LWResourceLackGetWay.GoCommonShop then
    self:GoCommonShop()
  elseif self.data.tips == LWResourceLackGetWay.GoToWorkerRecruit then
    GoToUtil.GotoWorkerRecruitView(true)
  elseif self.data.tips == LWResourceLackGetWay.GuideToUseChooseBox then
    self:GuideToUseChooseBox()
  elseif self.data.tips == LWResourceLackGetWay.VIPGiftPackage then
    local fucntionUnlock, tip = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_VIP)
    if fucntionUnlock then
      self:GuideToVIPGiftPackage()
    else
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_Upgrade)
    end
  elseif self.data.tips == LWResourceLackGetWay.GoExchangeUI then
    local params = string.split(self.data.para1, "|") or {}
    if #params == 2 then
      if params[1] == tostring(SplinterExchangeType.DispatchTreasure.Id) or params[1] == tostring(SplinterExchangeType.DigTreasure.Id) then
        self.ctrl:CloseSelf()
      else
        GoToUtil.CloseAllWindows()
      end
      UIManager:GetInstance():OpenWindow(UIWindowNames.UISplinterExchange, {anim = true}, tonumber(params[1]), 1, tonumber(params[2]))
    end
  elseif self.data.tips == LWResourceLackGetWay.GoNearestCity then
    GoToUtil.GotoNearestCity(true, WorldAllianceCityType.City)
  elseif self.data.tips == LWResourceLackGetWay.GoWorld then
    GoToUtil.GoToByTypeAndParam(QuestGoType.GoWorld)
  elseif self.data.tips == LWResourceLackGetWay.GoUnownedCityStronghold then
    GoToUtil.GoToByTypeAndParam(QuestGoType.GoUnownedCityStronghold)
  elseif self.data.tips == LWResourceLackGetWay.TorchRelayTaskDaily then
    DataCenter.ActivityTorchRelayManager:OpenDailyTask()
  elseif self.data.tips == LWResourceLackGetWay.TorchRelayTaskTotal then
    DataCenter.ActivityTorchRelayManager:OpenTotalTask()
  elseif self.data.tips == LWResourceLackGetWay.DailyPackage then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, nil, nil, RechargeEntryType.Store)
  elseif self.data.tips == LWResourceLackGetWay.TacticalChipFactory then
    if not CS.SceneManager:IsInCity() and not CS.SceneManager:IsInWorld() then
      UIUtil.ShowTipsId("chips_cannot_jump_tips")
      return
    end
    self:GuideToChipFactory()
  elseif self.data.tips == LWResourceLackGetWay.GotoFarmerCurBuilding then
    DataCenter.SeasonFarmerManager:GotoCurBuilding()
  elseif self.data.tips == LWResourceLackGetWay.GoToDragonHospital then
    self.ctrl:CloseSelf()
    BattleFieldUtil.TryOpenHospital()
  elseif self.data.tips == LWResourceLackGetWay.GoToDesertCollect then
    self.ctrl:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWDesertBattleTreatmentSoldier)
  elseif self.data.tips == LWResourceLackGetWay.TrailTowerShop then
    self:GuideToTrailTowerShop()
  elseif self.data.tips == LWResourceLackGetWay.DecoChipExchange then
    local buildingUuid = self.context.decoBuildingUuid
    local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(buildingUuid)
    local upLevelScarceInfos = BuildingUtils.GetDecorateUpLevelBuilds(buildingData)
    local have = 0
    if upLevelScarceInfos and 0 < table.count(upLevelScarceInfos) then
      local lastData = upLevelScarceInfos[#upLevelScarceInfos]
      have = lastData.count
    end
    if buildingData then
      local viewData = {}
      viewData.buildingData = buildingData
      viewData.need = self.context.need - have
      viewData.haveNum = have
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildDecorateExchangeNew, {anim = true}, viewData)
    end
  elseif self.data.tips == LWResourceLackGetWay.HonorShopNew then
    self:GuideToHonorShopNew()
  elseif self.data.tips == LWResourceLackGetWay.GoToDispatchTreasureView then
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.DispatchTreasure.Type)
    if actList and 0 < #actList then
      local actId = tonumber(actList[1].id)
      GoToUtil.CloseAllWindows()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTaskMain, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, actId)
    else
      UIUtil.ShowTipsId(801141)
    end
  elseif self.data.tips == LWResourceLackGetWay.GoToDigTreasureShare then
    self.ctrl:CloseSelf()
    DataCenter.DigTreasureManager:GoToShare()
  elseif self.data.tips == LWResourceLackGetWay.ResourceList then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWResourceList, {anim = true})
  elseif self.data.tips == LWResourceLackGetWay.GotoTacticalCardBox then
    self.ctrl:CloseSelf()
    self:GuideToTacticalCardBox()
  elseif self.data.tips == LWResourceLackGetWay.TacticalCardDailyLimit then
    self:GuideToTacticalCardDailyLimit()
  elseif self.data.tips == LWResourceLackGetWay.GoToEasterEggTaskView then
    local para1 = self.data.para1
    if not string.IsNullOrEmpty(para1) then
      local str = string.split(para1, "|") or {}
      if str and 2 <= #str then
        local actId = str[1]
        local uiName = str[2]
        local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
        if activityInfo then
          self.ctrl:CloseSelf()
          UIManager:GetInstance():OpenWindow(uiName, actId)
        else
          UIUtil.ShowTipsId(801141)
        end
      end
    end
  elseif self.data.tips == LWResourceLackGetWay.CityPos then
    GoToUtil.CloseAllWindows()
    if not string.IsNullOrEmpty(self.data.para1) then
      local posStr = self.data.para1
      posStr = string.split(posStr, "|")
      GoToUtil.GotoCityPos(SceneUtils.TileIndexToWorld(SceneUtils.WorldToTileIndex({
        x = tonumber(posStr[1]),
        y = 0,
        z = tonumber(posStr[2])
      }, ForceChangeScene.City), ForceChangeScene.City), nil, nil)
    end
  elseif self.data.tips == LWResourceLackGetWay.TacticalCardSalvage then
    self:GuideToTacticalCardSalvage()
  elseif self.data.tips == LWResourceLackGetWay.BountyHunterOpenHistoryView then
    self:GuideToBountyHunterHistoryView()
  elseif self.data.tips == LWResourceLackGetWay.T11IdleGameMainView then
    if not DataCenter.T11IdleGameManager:IsGuideFinished() then
      local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_ALERTTOWER)
      if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
        GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_BUILD_ALERTTOWER)
        return
      end
      GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_ALERTTOWER, WorldTileBtnType.AlertTowerTrail)
    else
      DataCenter.T11IdleGameManager:OpenMain()
    end
  elseif self.data.tips == LWResourceLackGetWay.OpenBuyDiamondViewWeekCard then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.WeekCard)
  elseif self.data.tips == LWResourceLackGetWay.OpenAllyDuelTodayGacha then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local weekday = UITimeManager:GetInstance():GetWeekdayIndex(curTime)
    if weekday == 7 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDuel, {anim = true}, LeagueMatchTab.GachaSunday)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDuel, {anim = true}, LeagueMatchTab.Activity, 12)
    end
  elseif self.data.tips == LWResourceLackGetWay.OpenAllyDuelRewardView then
    local isInMatch = DataCenter.LeagueMatchManager:IsLeagueOpen()
    if not isInMatch then
      UIUtil.ShowTipsId("alliance_duel_gacha_tips_1019")
      return
    else
      local targetTab = 3
      local targetSeg = SegmentType.Diamond
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIAllyDuelRewardPanel, {anim = true}, targetTab, targetSeg)
    end
  elseif self.data.tips == LWResourceLackGetWay.GotoSkyBattleGrowChapter then
    self.ctrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISkyBattlePlaneEquipDetail, {anim = true})
    local data = {growMode = true}
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWStageSkyBattleChapter) then
      EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterViewRefresh, data)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWStageSkyBattleChapter, {anim = true}, data)
    end
  elseif self.data.tips == LWResourceLackGetWay.GotoSkyBattleGrowBag then
    self.ctrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISkyBattlePlaneEquipDetail, {anim = true})
    local data = {
      growMode = true,
      tab = 3,
      guideType = SkyBattleChapterGrowthGuideType.Recycle
    }
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWStageSkyBattleChapter) then
      EventManager:GetInstance():Broadcast(EventId.SkyBattleChapterViewRefresh, data)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWStageSkyBattleChapter, {anim = true}, data)
    end
  elseif self.data.tips == LWResourceLackGetWay.GoBirthdaySetView then
    local isBirthdayFuncOpne = DataCenter.BirthdayDataManager:GetIsSelfBirthdayFuncOpen()
    if isBirthdayFuncOpne then
      UIUtil.OpenUIPlayerInfo(LuaEntry.Player.uid)
      UIManager:GetInstance():OpenWindow(UIWindowNames.BirthdayDataSetPanel, {anim = true})
    end
  elseif self.data.tips == LWResourceLackGetWay.GoGiftPrivilegeView then
    if IsGiftSystemOpen then
      UIUtil.OpenUIPlayerInfo(LuaEntry.Player.uid)
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIGiftPrivilege, {anim = true})
    end
  elseif tips == LWResourceLackGetWay.GoToAdList then
    self.ctrl:CloseSelf()
    DataCenter.MaxAdManager:ShowAdsCollectionPanel()
  elseif tips == LWResourceLackGetWay.AllianceSkill then
    self.ctrl:CloseSelf()
    GoToUtil.GoToNewAllianceSkill()
  elseif tips == LWResourceLackGetWay.GoToSeasonTower then
    GoToUtil.CloseAllWindows()
    DataCenter.LWSeasonTowerManager:OnAlertTowerBubbleClick()
  elseif self.data.tips == LWResourceLackGetWay.GotoActRecycleSubView then
    local para1 = self.data.para1
    if not string.IsNullOrEmpty(para1) then
      local str = string.split(para1, "|") or {}
      if str and 2 <= #str then
        local actId = str[1]
        local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
        if activityInfo then
          if UIManager:GetInstance():IsWindowOpen(UIWindowNames.LWUIActRecycleExchange) then
            EventManager:GetInstance():Broadcast(EventId.ActRecycleExchangeChangeToggle, {index = 1})
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActRecycleExchange, {anim = true}, actId, 1)
          end
          self.ctrl:CloseSelf()
        else
          UIUtil.ShowTipsId(801141)
        end
      end
    end
  elseif self.data.tips == LWResourceLackGetWay.GotoWorldBossTask then
    self:GuideToActivityCheckOpen()
  elseif self.data.tips == LWResourceLackGetWay.OpenHeroTryOutTask and DataCenter.HeroTryOutManager:IsHeroTryOutFunctionOn() and DataCenter.HeroTryOutManager:IsUserDataReady() then
    local tagId = checknumber(self.data.para1)
    local tagTemplate = DataCenter.HeroTryOutManager:GetLWHeroTryOutTagTemplateById(tagId)
    if tagTemplate then
      self.ctrl:CloseSelf()
      DataCenter.HeroTryOutManager:OpenHeroDetail(tagTemplate.hero_id)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHeroTryOutTask, {anim = true}, tagTemplate.hero_id, tagId)
    end
  end
  EventManager:GetInstance():Broadcast(EventId.GF_goods_lack_goto_clicked, tips)
end

function LWResourceLackCell:GuideToClaim()
  local staminaFree = LuaEntry.DataConfig:TryGetNum("role_stamina", "k4")
  local effectValue = LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SEASON_EFFECT_94037)
  staminaFree = staminaFree * (1 + effectValue)
  UIUtil.ShowTips(Localization:GetString(120028, Localization:GetString("season_mastery_UI_tips_23", staminaFree), 1))
  SFSNetwork.SendMessage(MsgDefines.ClaimDailyStamina)
end

function LWResourceLackCell:GuideToBuyGiftBag()
end

function LWResourceLackCell:GuidToDailyMustBuyPanel()
  self.ctrl:CloseSelf()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.DailyMustBuy, nil, nil, self.data.para1)
end

function LWResourceLackCell:GuidToWeeklyMustBuyPanel()
  self.ctrl:CloseSelf()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.WeeklyPackageNew, nil, nil, self.data.para1)
end

function LWResourceLackCell:GuideToWorldBoss()
  self.ctrl:CloseSelf()
  local actInfo = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.WorldBoss.Type)
  if not table.IsNullOrEmpty(actInfo) then
    GoToUtil.GoActWindow({
      actInfo[1].id
    })
  else
    UIUtil.ShowTipsId("E100172")
  end
end

function LWResourceLackCell:GuideToRadar()
  GoToUtil.CloseAllWindows()
  if not UIUtil.CheckDetectCanCrossServer() and CrossServerUtil:NeedIntercept(500019) then
    return
  end
  DataCenter.RadarCenterDataManager:RecordDetectTriggerTime()
  local inCity = SceneUtils.GetIsInCity()
  if inCity then
    local count = DataCenter.RadarCenterDataManager:GetFinishedDetectEventNum()
    if 0 < count then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent)
    else
      GoToUtil.GotoCityByBuildId(BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
    end
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectEvent)
  end
end

function LWResourceLackCell:GuideToCityCollection()
  local origin_pos = self.gotoBtn.transform.position
  local target_pos = self.view:GetFlyTargetPos()
  BuildingUtils.CityCollectionByItemId(tonumber(self.data.para1), origin_pos, target_pos)
end

function LWResourceLackCell:GuideToUseItem()
  local items
  if self.data.tips == LWResourceLackGetWay.MultiUseItem then
    local itemId = LWResourceLackUtil:GetShowItemIdFromMultiUseItemGetWay(self.data)
    if itemId then
      items = DataCenter.ItemData:GetItemById(itemId)
    end
  else
    items = DataCenter.ItemData:GetItemById(self.data.para1)
  end
  local itemCount = items and items.count or 0
  if 0 < itemCount then
    if 1 < itemCount then
      local shouldPreviewConsume = true
      if items and items.goods then
        local template
        if self.param and self.param.SeasonType == SeasonMapType.Mummy and self.param.MaxUseCount then
          template = DataCenter.ItemTemplateManager:GetItemTemplate(self.data.para1)
          if template then
            shouldPreviewConsume = false
          end
        elseif items.goods:IsGuarantBox() then
          shouldPreviewConsume = false
        elseif items.goods:IsSelectBox() then
          shouldPreviewConsume = false
        end
      end
      self:RefreshUseCell(items, shouldPreviewConsume)
    end
    if items and items.goods and self.param and self.param.SeasonType == SeasonMapType.Mummy and self.param.MaxUseCount then
      local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.data.para1)
      if template then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityBoxSelect, {
          anim = true,
          UIMainAnim = UIMainAnimType.AllHide
        }, items.uuid, self.param.MaxUseCount, template, false, false, {
          mode = "ItemMultiUse"
        })
        return
      end
    end
    if items and items.goods and items.goods.type == GOODS_TYPE.GOODS_TYPE_59 and self.context and self.context.chipId and self.context.type == ResLackContextType.TWSkillChip then
      local order = self:GetChipSelectedBoxOrder(items)
      if order and 0 < order then
        SFSNetwork.SendMessage(MsgDefines.ItemUse, {
          uuid = items.uuid,
          num = 1,
          para1 = tostring(order)
        })
        return
      end
    end
    if items and items.goods and items.goods:IsGuarantBox() then
      local para3 = string.split(items.goods.para3, ";")
      local guarantId = tonumber(para3[1])
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGuarantBox, {anim = true}, guarantId, items.itemId)
      return
    end
    if items and items.goods and items.goods.type == GOODS_TYPE.GOODS_TYPE_59 and (items.goods.popupType == GOODS_POPUP_TYPE.Hero or items.goods.popupType == GOODS_POPUP_TYPE.Decoration or items.goods.popupType == GOODS_POPUP_TYPE.Dominator) and self.chooseItemIndex then
      SFSNetwork.SendMessage(MsgDefines.ItemUse, {
        uuid = items.uuid,
        num = 1,
        para1 = tostring(self.chooseItemIndex),
        continueUse = self.continueUse
      })
      return
    end
    if items and items.goods and items.goods:IsSelectBox() then
      local template = DataCenter.ItemTemplateManager:GetItemTemplate(self.data.para1)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityBoxSelect, {
        anim = true,
        UIMainAnim = UIMainAnimType.AllHide
      }, items.uuid, 1, template)
      return
    end
    if self.chooseItemIndex then
      SFSNetwork.SendMessage(MsgDefines.ItemUse, {
        uuid = items.uuid,
        num = 1,
        para1 = tostring(self.chooseItemIndex),
        continueUse = self.continueUse
      })
      return
    end
    SFSNetwork.SendMessage(MsgDefines.ItemUse, {
      uuid = items.uuid,
      num = 1
    })
  else
    UIUtil.ShowTipsId(120021)
  end
end

function LWResourceLackCell:GuideToDailyTask()
  GoToUtil.GotoOpenView(UIWindowNames.UILWQuestList, UIQuestTab.Daily)
end

function LWResourceLackCell:GuideToSaveGirl()
  if DataCenter.LWSaveGirlManager:IsShowBubble() then
    GoToUtil.GotoOpenView(UIWindowNames.UILWSaveGirl)
  end
end

function LWResourceLackCell:RefreshUseCell(items, isClick)
  if not items or self.context == nil or self.param ~= nil and self.param.SeasonType == SeasonMapType.Mummy then
    return
  end
  self:ShowUseBtn(self.data.tips ~= LWResourceLackGetWay.BuyGiftBag)
  local have = 0
  if self.context.type == 2 then
    have = DataCenter.ResourceItemDataManager:GetCountByItemId(self.context.id)
  elseif self.context.type == 1 then
    have = DataCenter.ItemData:GetItemCount(self.context.id)
  elseif self.context.type == 17 then
    local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.context.decoBuildingUuid)
    if buildingData then
      local upLevelScarceInfos = BuildingUtils.GetDecorateUpLevelBuilds(buildingData)
      if upLevelScarceInfos and 0 < table.count(upLevelScarceInfos) then
        local lastData = upLevelScarceInfos[#upLevelScarceInfos]
        have = lastData.count
      end
    end
  else
    have = UIUtil.GetHaveCount(self.context.type, self.context.id or self.context.resType)
  end
  local need = self.context.need
  local itemCount = items and items.count or 0
  itemCount = isClick and itemCount - 1 or itemCount
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(items.itemId)
  local type = tonumber(goods.type)
  if type == GOODS_TYPE.GOODS_TYPE_3 or type == GOODS_TYPE.GOODS_TYPE_133 then
    local give
    if type == GOODS_TYPE.GOODS_TYPE_3 then
      give = tonumber(items.para2) or 0
    else
      give = tonumber(items.para1) or 0
    end
    if 0 < give and need > have + give then
      local glod = isClick and need - have - give or need - have
      local useNum = Mathf.Min(Mathf.Ceil(glod / give), itemCount)
      if 0 < useNum then
        self.useNum = useNum
        self.multUseContent:SetActive(true)
        self.multUseText:SetText("x" .. useNum)
      end
    end
    if self.data.canUseAll == 1 then
      if not self.multUseContent:GetActive() then
        self.multUseBtn:SetActive(false)
      end
      self.multUseContent:SetActive(true)
      self:ShowUseAllBtn(true)
    end
  elseif type == 5 then
    self.useNum = itemCount
    if goods:IsGuarantBox() then
      self.multUseContent:SetActive(false)
    else
      self.multUseContent:SetActive(true)
      self.multUseText:SetText("x" .. self.useNum)
    end
  elseif goods:IsSelectBox() or type == GOODS_TYPE.GOODS_TYPE_109 then
    if self.context.type == ResLackContextType.TWSkillChip and self.context.chipId then
      local ownNum = DataCenter.TacticalChipManager:GetChipFreeCount(self.context.chipId)
      local realNeed = need - ownNum
      realNeed = math.max(0, realNeed)
      self.useNum = math.min(realNeed, items.count)
      self.multUseText:SetText("x" .. self.useNum)
      self.multUseContent:SetActive(0 < realNeed)
      return
    end
    if goods:IsSelectBox() and goods:IsGuarantBox() then
      self.multUseContent:SetActive(false)
      return
    end
    self:RefreshPerGainCount(type, goods)
    if self.perGainItemCount ~= 0 and 0 < need then
      local glod = isClick and need - have - self.perGainItemCount or need - have
      self.useNum = Mathf.Min(Mathf.Ceil(glod / self.perGainItemCount), itemCount)
      if 1 < self.useNum then
        self.multUseContent:SetActive(true)
        self.multUseText:SetText("x" .. self.useNum)
      else
        self.multUseContent:SetActive(false)
      end
    else
      self.multUseContent:SetActive(false)
    end
    if type == GOODS_TYPE.GOODS_TYPE_109 then
      if not self.multUseContent:GetActive() then
        self.multUseBtn:SetActive(false)
      end
      self.multUseContent:SetActive(true)
      self:ShowUseAllBtn(true)
    end
    return
  end
end

function LWResourceLackCell:RefreshPerGainCount(type, template)
  if not self.perGainCount then
    local needId = self.context.id
    needId = needId or self.context.resType
    self.perGainItemCount = 0
    if self.context.type == ResLackContextType.Resource and template and template:IsSelectBox() and not template:IsGuarantBox() then
      local List = string.split(template.para1, "|")
      local options = {}
      local optionsIndices = {}
      for i = 1, #List do
        local item = string.split(List[i], ",")
        options[tonumber(item[1])] = tonumber(item[2])
        optionsIndices[tonumber(item[1])] = i
      end
      local templates = {}
      templates = DataCenter.LWResourceLackManager:GetResourceWay(needId)
      self.chooseItemIndex = nil
      self.continueUse = true
      if templates then
        for i = 1, #templates do
          local lackTemplate = templates[i]
          local para1Num = tonumber(lackTemplate.para1)
          if para1Num and (lackTemplate.tips == LWResourceLackGetWay.UseItem or lackTemplate.tips == LWResourceLackGetWay.DecoSelfSelectItem) and options[para1Num] then
            local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(para1Num)
            local perGainItemCount = GoodsUtil.GetGoodsReturnItemCount(goodsTemplate.id, needId)
            self.perGainItemCount = perGainItemCount * options[para1Num]
            self.chooseItemIndex = optionsIndices[para1Num]
            break
          end
        end
      end
    elseif self.context.type == ResLackContextType.Good and template and template.type == GOODS_TYPE.GOODS_TYPE_59 then
      self.perGainItemCount = GoodsUtil.GetGoodsReturnItemCount(template.id, needId)
      local List = string.split(template.para1, "|")
      local options = {}
      local optionsIndices = {}
      for i = 1, #List do
        local item = string.split(List[i], ",")
        local itemId = 0
        local itemNum = 0
        if template.popupType == GOODS_POPUP_TYPE.Hero and template.tipsType == GOODS_TIPS_TYPE.BoxTag then
          itemId = item[2]
          itemNum = item[3]
        else
          itemId = item[1]
          itemNum = item[2]
        end
        options[tonumber(itemId)] = tonumber(itemNum)
        optionsIndices[tonumber(itemId)] = i
      end
      if optionsIndices[needId] then
        self.chooseItemIndex = optionsIndices[needId]
      end
    elseif self.context.type == ResLackContextType.BuildingDecoration and template.type == GOODS_TYPE.GOODS_TYPE_59 then
      self.perGainItemCount = 0
      local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.context.decoBuildingUuid)
      if buildingData then
        local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildingData.itemId, 1)
        if buildTemplate and not string.IsNullOrEmpty(buildTemplate.para4) then
          local targetId = toInt(buildTemplate.para4)
          local List = string.split(template.para1, "|")
          for i = 1, #List do
            local item = string.split(List[i], ",")
            local itemId = toInt(item[1])
            local itemNum = toInt(item[2])
            if itemId == targetId then
              self.chooseItemIndex = i
              self.perGainItemCount = itemNum
              break
            end
          end
        end
      end
    else
      self.perGainItemCount = GoodsUtil.GetGoodsReturnItemCount(template.id, needId)
    end
  end
end

function LWResourceLackCell:RefreshMultUseBtn()
  local items
  if self.data.tips == LWResourceLackGetWay.MultiUseItem then
    local itemId = LWResourceLackUtil:GetShowItemIdFromMultiUseItemGetWay(self.data)
    if itemId then
      items = DataCenter.ItemData:GetItemById(itemId)
    end
  else
    items = DataCenter.ItemData:GetItemById(self.data.para1)
  end
  if not items then
    return
  end
  local itemCount = items and items.count or 0
  local have = UIUtil.GetHaveCount(self.context.type, self.context.id or self.context.resType)
  local need = self.context.need
  local goods = DataCenter.ItemTemplateManager:GetItemTemplate(items.itemId)
  local type = tonumber(goods.type)
  if type == GOODS_TYPE.GOODS_TYPE_3 or type == GOODS_TYPE.GOODS_TYPE_133 then
    local give
    if type == GOODS_TYPE.GOODS_TYPE_3 then
      give = tonumber(items.para2) or 0
    else
      give = tonumber(items.para1) or 0
    end
    if 0 < give and need > have + give then
      local useNum = Mathf.Min(Mathf.Ceil((need - have - give) / give), itemCount)
      if 0 < useNum then
        self.useNum = useNum
        self.multUseContent:SetActive(true)
        self.multUseText:SetText("x" .. useNum)
      else
        self.multUseContent:SetActive(false)
      end
    end
  elseif type == 5 then
    self.useNum = itemCount
    self.multUseContent:SetActive(true)
    self.multUseText:SetText("x" .. self.useNum)
  elseif goods:IsSelectBox() or type == GOODS_TYPE.GOODS_TYPE_109 then
    self:RefreshPerGainCount(type, goods)
    if self.perGainItemCount ~= 0 and 0 < need then
      self.useNum = Mathf.Min(Mathf.Ceil((need - have) / self.perGainItemCount), itemCount)
      if self.useNum > 1 then
        self.multUseContent:SetActive(true)
        self.multUseText:SetText("x" .. self.useNum)
      else
        self.multUseContent:SetActive(false)
      end
    else
      self.multUseContent:SetActive(false)
    end
    if type == GOODS_TYPE.GOODS_TYPE_109 then
      if not self.multUseContent:GetActive() then
        self.multUseBtn:SetActive(false)
      end
      self.multUseContent:SetActive(true)
      self:ShowUseAllBtn(true)
    end
    return
  end
end

function LWResourceLackCell:OnMultUseClick()
  if toInt(self.useNum) > 0 then
    local items
    if self.data.tips == LWResourceLackGetWay.MultiUseItem then
      local itemId = LWResourceLackUtil:GetShowItemIdFromMultiUseItemGetWay(self.data)
      if itemId then
        items = DataCenter.ItemData:GetItemById(itemId)
      end
    else
      items = DataCenter.ItemData:GetItemById(self.data.para1)
    end
    if not items then
      return
    end
    if self.context.type == ResLackContextType.TWSkillChip then
      if not self.context.chipId then
        Logger.LogError("chip id is error.  ")
        return
      end
      local order = self:GetChipSelectedBoxOrder(items)
      if not order then
        return
      end
      SFSNetwork.SendMessage(MsgDefines.ItemUse, {
        uuid = items.uuid,
        num = self.useNum,
        para1 = tostring(order)
      })
      self.multUseContent:SetActive(false)
      return
    end
    if self.chooseItemIndex then
      SFSNetwork.SendMessage(MsgDefines.ItemUse, {
        uuid = items.uuid,
        num = self.useNum,
        para1 = tostring(self.chooseItemIndex),
        continueUse = self.continueUse
      })
      return
    end
    SFSNetwork.SendMessage(MsgDefines.ItemUse, {
      uuid = items.uuid,
      num = self.useNum
    })
    self.multUseContent:SetActive(false)
  end
end

function LWResourceLackCell:OnMultUseAllClick()
  local items = DataCenter.ItemData:GetItemById(self.data.para1)
  local itemCount = items and items.count or 0
  SFSNetwork.SendMessage(MsgDefines.ItemUse, {
    uuid = items.uuid,
    num = itemCount
  })
  self.multUseContent:SetActive(false)
end

function LWResourceLackCell:GuideToRecruit()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_PUB)
  if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
    return
  end
  local targetBuilding = buildList[1]
  GoToUtil.CloseAllWindows()
  self:SwitchToCity(function()
    GoToUtil.GotoPos(targetBuilding:GetCenterVec(), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      WorldArrowManager:GetInstance():ShowArrowEffect(0, targetBuilding:GetCenterVec(), ArrowType.Normal)
      local destroyTimer = TimerManager:GetInstance():GetTimer(1, function()
        WorldArrowManager:GetInstance():RemoveEffect()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = true})
      end, nil, true, false, false)
      destroyTimer:Start()
    end)
  end)
end

function LWResourceLackCell:GuideToZombieBattle()
  GoToUtil.CloseAllWindows()
  if not DataCenter.StageManager.stageId then
    UIUtil.PlayCutSceneAnim(function()
      DataCenter.LWHummerSceneManager:Enter()
    end, function()
      return DataCenter.LWHummerSceneManager:CheckLoadingState()
    end)
  else
    self:SwitchToCity(function()
      local data = DataCenter.MonopolyManager.dataManager:GetCurData()
      if not data or not self.data then
        return
      end
      GoToUtil.GotoPos(data:GetCenterWorldPos(), CS.SceneManager.World.InitZoom, LookAtFocusTime)
    end)
  end
end

function LWResourceLackCell:GuideToUpgradeMainBuilding()
  GoToUtil.CloseAllWindows()
  self:SwitchToCity(function()
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_Upgrade)
  end)
end

function LWResourceLackCell:GuideToUpgradeBuilding()
  local list = DataCenter.BuildManager:GetCanUpgradeBuildUuidListFilterd()
  if table.count(list) > 0 then
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(list[1])
    if buildData ~= nil then
      GoToUtil.GotoCityByBuildId(buildData.itemId, WorldTileBtnType.City_Upgrade)
    else
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_Upgrade)
    end
  else
    GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_MAIN, WorldTileBtnType.City_Upgrade)
  end
end

function LWResourceLackCell:GuideToWorldMonster()
  GoToUtil.CloseAllWindows()
  self:SwitchToWorld(function()
    local index = 1
    local type = tonumber(self.data.para1)
    if type == LWWorldMonsterType.ResMetal then
      index = 1
    elseif type == LWWorldMonsterType.ResFood then
      index = 2
    elseif type == LWWorldMonsterType.ResGold then
      index = 3
    end
    GoToUtil.GotoOpenView(UIWindowNames.UISearch, UISearchType.Monster, nil, index, "SearchBtn")
  end)
end

function LWResourceLackCell:GuideToWorldGatherMonster()
  GoToUtil.CloseAllWindows()
  self:SwitchToWorld(function()
    GoToUtil.GotoOpenView(UIWindowNames.UISearch, UISearchType.Boss)
  end)
end

function LWResourceLackCell:GuideToWorldCollection()
  GoToUtil.CloseAllWindows()
  self:SwitchToWorld(function()
    local index = 1
    local type = tonumber(self.data.para1)
    if type == ResourceType.Metal then
      index = 1
    elseif type == ResourceType.Food then
      index = 2
    elseif type == ResourceType.Wood then
      index = 3
    end
    GoToUtil.GotoOpenView(UIWindowNames.UISearch, UISearchType.Resource, nil, index, "SearchBtn")
  end)
end

function LWResourceLackCell:GuideToPay()
  self.ctrl:CloseSelf()
  UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.DiamondShop)
end

function LWResourceLackCell:GuideToHangUp()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_BATTLE_HANGUP_REWARD)
  if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
    GoToUtil.CloseAllWindows()
    self:SwitchToCity(function()
      GoToUtil.GoLandLockById(5)
    end)
  elseif DataCenter.StageManager.idleReward and 0 < #DataCenter.StageManager.idleReward then
    SFSNetwork.SendMessage(MsgDefines.HangUpRewardMessage, 1)
  end
end

function LWResourceLackCell:GuideToQuestReward()
  local view = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain)
  if view then
    GoToUtil.CloseAllWindows()
    self:SwitchToCity(function()
      local param = {
        position = view.View:GetSavePos(UIMainSavePosType.Quest),
        arrowType = ArrowType.Capacity,
        positionType = PositionType.Screen
      }
      DataCenter.ArrowManager:ShowArrow(param)
    end)
  end
end

function LWResourceLackCell:GuideToPromote()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.Lw_BUILD_BATTLE_FEATURE_ENTRY)
  if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
    Logger.LogError("\230\178\161\230\156\137\229\187\186\231\173\145 \233\133\141\231\189\174\231\177\187\229\158\139:")
    return
  end
  local targetBuilding = buildList[1]
  self:SwitchToCity(function()
    GoToUtil.GotoPos(targetBuilding:GetCenterVec(), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      WorldArrowManager:GetInstance():ShowArrowEffect(0, targetBuilding:GetCenterVec(), ArrowType.Normal)
    end)
  end)
  GoToUtil.CloseAllWindows()
end

function LWResourceLackCell:GuideToEquip(is_forge)
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_SMITH_SHOP)
  if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
    GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_BUILD_SMITH_SHOP)
    return
  end
  local targetBuilding = buildList[1]
  GoToUtil.CloseAllWindows()
  self:SwitchToCity(function()
    GoToUtil.GotoPos(targetBuilding:GetCenterVec(), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      WorldArrowManager:GetInstance():ShowArrowEffect(0, targetBuilding:GetCenterVec(), ArrowType.Normal)
      local destroyTimer = TimerManager:GetInstance():GetTimer(1, function()
        WorldArrowManager:GetInstance():RemoveEffect()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIEquipMainPanel, {anim = false}, targetBuilding.uuid, is_forge and 1 or 3)
      end, nil, true, false, false)
      destroyTimer:Start()
    end)
  end)
end

function LWResourceLackCell:GuideToChipFactory()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY)
  if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
    GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY)
    return
  end
  GoToUtil.GotoCityByCondBuildId(BuildingTypes.LW_BUILDING_TACTICAL_CHIP_FACTORY, WorldTileBtnType.City_Upgrade)
end

function LWResourceLackCell:ShowTacticalChipQuickMake()
end

function LWResourceLackCell:ShowSlider()
end

function LWResourceLackCell:GuideToSoldierTrain()
  local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_MILITARY_CAMP)
  if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
    GoToUtil.GotoBuildListByBuildId(BuildingTypes.LW_BUILD_MILITARY_CAMP)
    return
  end
  local targetBuilding = buildList[1]
  GoToUtil.CloseAllWindows()
  self:SwitchToCity(function()
    GoToUtil.GotoPos(targetBuilding:GetCenterVec(), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
      WorldArrowManager:GetInstance():ShowArrowEffect(0, targetBuilding:GetCenterVec(), ArrowType.Normal)
    end)
  end)
end

function LWResourceLackCell:GuideToAllyDuel()
  if DataCenter.AllianceCompeteDataManager:CanOpenAllyDuelUI() then
    GoToUtil.CloseAllWindows()
    DataCenter.AllianceCompeteDataManager:TryOpenAllyDuelUI()
  else
    UIUtil.ShowTipsId(self.data.para1)
  end
end

function LWResourceLackCell:GuideToAllianceShop()
  if LuaEntry.Player:IsInAlliance() == false then
    UIUtil.ShowTipsId(451015)
  else
    local gotoShopId
    local shopIdList = {}
    local paraSplitList = string.split(self.data.para1, "|")
    for i, v in ipairs(paraSplitList) do
      table.insert(shopIdList, tonumber(v))
    end
    for _, shopId in ipairs(shopIdList) do
      local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(CommonShopType.AllianceShop, shopId)
      local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(CommonShopType.AllianceShop, shopId)
      if goodsConf then
        local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
        if not (0 < goodsConf.maxTimes) or not (boughtTimes >= goodsConf.maxTimes) then
          if goodsConf.GetInconsistentConditions then
            local inconsistentConditions = goodsConf:GetInconsistentConditions()
            if not table.IsNullOrEmpty(inconsistentConditions) then
              goto lbl_78
            end
          end
          gotoShopId = shopId
          break
        end
      end
      ::lbl_78::
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.AllianceShop, gotoShopId)
  end
end

function LWResourceLackCell:GuideToAllianceHelp()
  if LuaEntry.Player:IsInAlliance() == false then
    UIUtil.ShowTipsId(451015)
  else
    GoToUtil.GotoOpenView(UIWindowNames.UILWAlHelp, {
      anim = true,
      hideTop = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  end
end

function LWResourceLackCell:GuideToAllianceDonate()
  if LuaEntry.Player:IsInAlliance() == false then
    UIUtil.ShowTipsId(451015)
  else
    GoToUtil.GotoOpenView(UIWindowNames.UIAllianceScience, {
      anim = true,
      hideTop = true,
      UIMainAnim = UIMainAnimType.LeftRightBottomHide
    }, {autoOpenRecScience = true})
  end
end

function LWResourceLackCell:GuideToActivityByActivityType(enumActivity, checkAlliance)
  local tipsKey = 458822
  if enumActivity == EnumActivity.DispatchTask then
    tipsKey = 456253
  end
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(enumActivity.Type)
  if #dataList == 0 then
    UIUtil.ShowTipsId(tipsKey)
    return
  end
  if checkAlliance and LuaEntry.Player:IsInAlliance() == false then
    local params = {guide = false}
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
    return
  end
  local data = dataList[1]
  if enumActivity == EnumActivity.DispatchTask then
    GoToUtil.CloseAllWindows()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDispatchTaskMain, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    })
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, {
      anim = true,
      UIMainAnim = UIMainAnimType.AllHide
    }, tonumber(data.id))
  end
end

local ALLIANCE_MEMBER_LIMIT = 20

function LWResourceLackCell:GuideToAllianceStation()
  local lock = DataCenter.LWAllyStationDataManager:IsTrainFunctionLock()
  if lock then
    UIUtil.ShowTipsId(458628)
  end
  if LuaEntry.Player:IsInAlliance() == false then
    local params = {guide = false}
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, params)
    return
  end
  local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
  if baseData.curMember < ALLIANCE_MEMBER_LIMIT then
    UIUtil.ShowTipsId(458627)
    return
  end
  local now = UITimeManager:GetInstance():GetServerTime()
  if baseData.joinTime == nil or now - baseData.joinTime <= 86400000 then
    UIUtil.ShowTipsId(458626)
    return
  end
  local cur, max = DataCenter.LWAllyStationDataManager:BuyCount()
  if max <= cur then
    UIUtil.ShowTipsId(458619)
  else
    RailwayUtil.BuyAllyTrain()
  end
end

function LWResourceLackCell:GuideToTruckStation()
  local id = DataCenter.MonopolyManager.player.curId
  if id and id < DataCenter.LWMyStationDataManager:GET_TRAIN_FOG_ID() then
    UIUtil.ShowTipsId(120167)
    return
  end
  local dataList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.TruckActivity.Type)
  if #dataList == 0 then
    UIUtil.ShowTipsId(120167)
    return
  end
  GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_TRUCK_STATION_2)
end

function LWResourceLackCell:GuideToArena3V3()
  local arena3V3State = DataCenter.LW3V3ArenaManager.state
  if arena3V3State == PVPArenaState.Invalide then
    UIUtil.ShowTipsId(120167)
    return
  end
  local buildingId = tostring(self.data.para1)
  if self:CheckHasBuilding(buildingId) then
    DataCenter.LWPVPArenaManager.ShowPVPArenaMain(PVPArenaType.Arena3V3, nil)
  end
end

function LWResourceLackCell:GuideToHonorShop()
  local buildingId = tostring(self.data.para1)
  if self:CheckHasBuilding(buildingId) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.HonorShop)
  end
end

function LWResourceLackCell:GuideToHonorShopNew()
  local gotoShopId
  local shopIdList = {}
  local paraSplitList = string.split(self.data.para1, "|")
  for i, v in ipairs(paraSplitList) do
    table.insert(shopIdList, tonumber(v))
  end
  for _, shopId in ipairs(shopIdList) do
    local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(CommonShopType.HonorShop, shopId)
    local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(CommonShopType.HonorShop, shopId)
    if goodsConf then
      local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
      if not (0 < goodsConf.maxTimes) or not (boughtTimes >= goodsConf.maxTimes) then
        if goodsConf.GetInconsistentConditions then
          local inconsistentConditions = goodsConf:GetInconsistentConditions()
          if not table.IsNullOrEmpty(inconsistentConditions) then
            goto lbl_67
          end
        end
        gotoShopId = shopId
        break
      end
    end
    ::lbl_67::
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, CommonShopType.HonorShop, gotoShopId)
end

function LWResourceLackCell:GoCommonShop()
  local paraList = {}
  local paraSplitList = string.split(self.data.para1, ";")
  for i, v in ipairs(paraSplitList) do
    table.insert(paraList, v)
  end
  for _, para in ipairs(paraList) do
    local splitPara = string.split(para, "|")
    if #splitPara == 2 then
      local shopType = tonumber(splitPara[1])
      local shopId = tonumber(splitPara[2])
      local goodsConf = DataCenter.CommonShopManager:GetGoodsConfByShopId(shopType, shopId)
      local goodsInfo = DataCenter.CommonShopManager:GetGoodsInfoById(shopType, shopId)
      if goodsConf then
        local boughtTimes = goodsInfo and goodsInfo.boughtTimes or 0
        if not (0 < goodsConf.maxTimes) or not (boughtTimes >= goodsConf.maxTimes) then
          if goodsConf.GetInconsistentConditions then
            local inconsistentConditions = goodsConf:GetInconsistentConditions()
            if not table.IsNullOrEmpty(inconsistentConditions) then
              goto lbl_86
            end
          end
          UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, {anim = true}, shopType, shopId)
          break
        end
      end
    end
    ::lbl_86::
  end
end

function LWResourceLackCell:GuideToSurvivorRecruit()
  local isWorkerUnlock, lockTips = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.Worker_Lottery)
  if not isWorkerUnlock then
    UIUtil.ShowTips(lockTips)
    return
  end
  local buildingId = tostring(self.data.para1)
  if self:CheckHasBuilding(buildingId) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroRecruit, {anim = true}, false, false, nil, nil, true)
  end
end

function LWResourceLackCell:GuideToVIPDailyReward()
  local unlock, tips = DataCenter.LWFunctionUnlockManager:CheckCanShow(LWFunctionUnlockType.MainUI_VIP)
  if not unlock then
    UIUtil.ShowTips(tips)
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip, {anim = true, hideTop = true})
end

function LWResourceLackCell:CheckHasBuilding(buildingId)
  if not DataCenter.BuildManager:HasBuilding(DataCenter.BuildManager:GetBuildId(buildingId)) then
    local lineData = LocalController:instance():getLine(DataCenter.BuildTemplateManager:GetTableName(), buildingId)
    if lineData ~= nil then
      local buildName = Localization:GetString(lineData.name)
      local buildingLevel = DataCenter.BuildManager:GetBuildLevel(buildingId)
      UIUtil.ShowTips(Localization:GetString("800371", buildName, buildingLevel))
    end
    return false
  end
  return true
end

function LWResourceLackCell:SwitchToCity(callback)
  if BattleFieldUtil.InBattleField() then
    CrossServerUtil.OnBackSelfServerFromDragonWorld()
    SceneUtils.ChangeToCity(callback)
  elseif not CS.SceneManager:IsInCity() then
    SceneUtils.ChangeToCity(callback)
  elseif callback then
    callback()
  end
end

function LWResourceLackCell:SwitchToWorld(callback)
  if BattleFieldUtil.InBattleField() then
    CrossServerUtil.OnBackSelfServerFromDragonWorld()
    SceneUtils.ChangeToWorld(function()
      if callback then
        callback()
      end
    end)
  elseif not CS.SceneManager:IsInWorld() then
    SceneUtils.ChangeToWorld(callback)
  elseif callback then
    callback()
  end
end

function LWResourceLackCell:OnCreateCell(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.giftPackageItemScroll:AddComponent(UICommonResItem, itemObj)
  cellItem:ReInit(self.packageRewardList[index])
end

function LWResourceLackCell:OnDeleteCell(itemObj, index)
  self.giftPackageItemScroll:RemoveComponent(itemObj.name, UICommonResItem)
end

function LWResourceLackCell:ClearScroll()
  self.giftPackageItemScroll:ClearCells()
  self.giftPackageItemScroll:RemoveComponents(UICommonResItem)
end

function LWResourceLackCell:OnCheckSeasonDevoteData()
  if self.data.tips == LWResourceLackGetWay.GoAllianceSeasonRank and SeasonUtil.IsInSeason() then
    local existDevoteData = DataCenter.SeasonDataManager.ExistDevoteData
    if existDevoteData then
      local tab = tonumber(self.data.para1)
      GoToUtil.GotoOpenView(UIWindowNames.LWSeasonAllianceRank, tab)
    else
      UIUtil.ShowTipsId("season_tips179")
    end
  end
end

function LWResourceLackCell:GuideToUseChooseBox()
  local items = DataCenter.ItemData:GetItemById(self.data.para1)
  local itemCount = items and items.count or 0
  if 0 < itemCount then
    if items.goods:IsGuarantBox() then
      local para3 = string.split(items.goods.para3, ";")
      local guarantId = tonumber(para3[1])
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWGuarantBox, {anim = true}, guarantId, items.itemId)
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICapacityBoxSelect, {anim = true}, items.uuid, 1, items.goods)
  end
end

function LWResourceLackCell:GuideToVIPGiftPackage()
  local giftPackId, vipLevel = DataCenter.VIPManager:GetVipPackContainsItem(self.data.res, self.data.goods, self.data.res_item)
  if giftPackId then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip, {anim = true}, vipLevel)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip, {anim = true})
  end
end

function LWResourceLackCell:GuideToTacticalCardBox()
  if not TacticalCardUtil.IsFunctionOpen() then
    UIUtil.ShowTipsId(120105)
    return
  end
  local boxId = TacticalCardUtil.GetPreferGuideBoxId(self.context.cardId)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UITCCardBoxPanel, {anim = true}, boxId)
end

function LWResourceLackCell:GuideToTacticalCardDailyLimit()
  local boxId = tonumber(self.data.para1)
  if not boxId then
    return
  end
  local curNum, maxNum = DataCenter.TacticalCardDataManager:GetDailyLimit(boxId)
  if maxNum <= curNum then
    UIUtil.ShowTipsId("battle_card_max_now")
  else
    self.ctrl:CloseSelf()
    TacticalCardUtil.OpenTacticalCardMain()
  end
end

function LWResourceLackCell:GuideToTacticalCardSalvage()
  if not TacticalCardUtil.IsFunctionOpen() then
    UIUtil.ShowTipsId(120105)
    return
  end
  self.ctrl:CloseSelf()
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.TCCardBag) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.TCCardBag, {anim = true}, {
      goType = TacticalCardType.Battle,
      onInitFinished = function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.TCCardSalvage, {anim = true}, TacticalCardType.Battle)
      end
    })
  elseif not UIManager:GetInstance():IsWindowOpen(UIWindowNames.TCCardSalvage) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.TCCardSalvage, {anim = true}, TacticalCardType.Battle)
  end
end

function LWResourceLackCell:GuideToBountyHunterHistoryView()
  local activityData = DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.ActBountyHunter.Type)
  if activityData then
    local actData = DataCenter.BountyHunterActDataManager:GetActData(tonumber(activityData.activityId))
    if actData then
      local canClaimRewardDataList = actData:GetCurStashRewardData()
      if 0 < #canClaimRewardDataList then
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIActBountyHunterHistory, {anim = true}, tonumber(activityData.activityId))
      end
    end
  end
end

function LWResourceLackCell:OnRefreshItems()
  if self.data and self.data.tips == LWResourceLackGetWay.DecoSelfSelectItem then
    local items = DataCenter.ItemData:GetItemById(self.data.para1)
    if not items then
      self.multUseContent:SetActive(false)
      return
    end
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(items.itemId)
    if not goods then
      return
    end
    local type = tonumber(goods.type)
    if type ~= GOODS_TYPE.GOODS_TYPE_5 then
      return
    end
    local itemCount = items.count or 0
    if items.count < 1 then
      self.multUseContent:SetActive(false)
    else
      self.multUseContent:SetActive(true)
      self.multUseText:SetText("x" .. itemCount)
    end
  end
end

function LWResourceLackCell:OnTacticalCardDailyLimitChanged()
  if self.data and self.data.tips == LWResourceLackGetWay.TacticalCardDailyLimit then
    self:RefreshDes()
  end
end

function LWResourceLackCell:OnBuildExpDataUpdated()
  if self.data and self.data.res_item == ResourceItemId.HeroExp then
    self:RefreshSelf()
  end
end

function LWResourceLackCell:CreateTimeLimitIcon()
  if self.timeLimitReq == nil then
    self.timeLimitReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/LWResource/LWResourceInfoTimeLimit.prefab", function(req)
      local obj = req.gameObject
      if IsNull(obj) or self.icon == nil then
        return
      end
      local go = obj.transform
      go:SetParent(self.icon.transform)
      go:Set_anchorMin(1, 0)
      go:Set_anchorMax(1, 0)
      go:Set_localScale(1, 1, 1)
      go:Set_sizeDelta(32.4, 32.4)
      go:Set_anchoredPosition(-23.72, 16.97, 0)
      local name = "TimeLimit_Async"
      go.name = name
    end)
  end
end

function LWResourceLackCell:DestroyTimeLimitIcon()
  if self.timeLimitReq then
    self:GameObjectDestroy(self.timeLimitReq)
  end
end

function LWResourceLackCell:RefreshSelf()
  self:Refresh(false, self.data, self.ctrl, self.context)
end

function LWResourceLackCell:OnNameTextInfoBtnClick()
  if self.data.tips == LWResourceLackGetWay.FirstPayGetExp then
    UIManager:GetInstance():OpenWindow(UIWindowNames.FirstPayGetExpHistoryPopView)
  end
end

function LWResourceLackCell:AddCountDownTimer(func)
  self:RemoveCountDownTimer()
  if self.countDownTimer == nil then
    self.countDownTimer = TimerManager:GetInstance():GetTimer(1, func, self, false, false, false)
    self.countDownTimer:Start()
  end
end

function LWResourceLackCell:RemoveCountDownTimer()
  if self.countDownTimer then
    self.countDownTimer:Stop()
    self.countDownTimer = nil
  end
end

function LWResourceLackCell:OnRefreshSeasonTowerDesc()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if DataCenter.LWSeasonTowerManager:IsPreview() then
    local endTime = DataCenter.LWSeasonTowerManager:GetFirstStageOpenTime()
    if endTime then
      local leftTime = math.max(endTime - curTime, 0)
      local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
      self.title2:SetText(leftTimeStr)
      self.title2:SetText(Localization:GetString("season_tower_getmore_desc3", leftTimeStr))
    end
  else
    local endTime = DataCenter.LWSeasonTowerManager:GetEndTime()
    local leftTime = math.max(endTime - curTime, 0)
    local current, all = DataCenter.LWSeasonTowerManager:GetSpecialItemInfo()
    local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    local str1 = Localization:GetString("season_tower_getmore_desc1", current .. " / " .. all)
    local str2 = Localization:GetString("season_tower_getmore_desc2", leftTimeStr)
    self.title2:SetText(str1 .. "\n" .. str2)
  end
end

function LWResourceLackCell:OnBtnClickItemIcon()
  if not string.IsNullOrEmpty(self.data.para1) then
    local para1List = string.split(self.data.para1, "|")
    if #para1List == 1 then
      local goodsTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(tonumber(para1List[1]))
      if goodsTemplate then
        local tipsType = goodsTemplate.tipsType
        if tipsType == GOODS_TIPS_TYPE.Box or tipsType == GOODS_TIPS_TYPE.BoxWithoutProbability or tipsType == GOODS_TIPS_TYPE.BoxTag then
          local param = {}
          param.itemId = goodsTemplate.id
          param.alignObject = self.icon
          param.showArrow = true
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIBoxItemTips, {anim = true}, param)
        else
          local param = {}
          param.itemId = goodsTemplate.id
          param.alignObject = self.icon
          param.rewardType = RewardType.GOODS
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
        end
      end
    end
  end
end

return LWResourceLackCell
