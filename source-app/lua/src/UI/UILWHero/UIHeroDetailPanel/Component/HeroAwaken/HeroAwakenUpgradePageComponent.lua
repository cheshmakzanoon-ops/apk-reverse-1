local base = UIBaseContainer
local HeroAwakenUpgradePageComponent = BaseClass("HeroAwakenUpgradePageComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local HeroAwakenUpgradeEffectLineItemComponent = require("UI/UILWHero/UIHeroDetailPanel/Component/HeroAwaken/HeroAwakenUpgradeEffectLineItemComponent")
local HeroAwakenStarItemComponent = require("UI.UILWHero.UIHeroDetailPanel.Component.HeroAwaken.HeroAwakenStarItemComponent")
local HeroAwakenUpgradeSkillItem = require("UI/UILWHero/UIHeroDetailPanel/Component/HeroAwaken/HeroAwakenUpgradeSkillItem")
local ANIM_NAME_IN = "HeroAwakenUpgradePage_movein"
local ANIM_NAME_SWITCH_IN = "HeroAwakenUpgradePage_switch"

function HeroAwakenUpgradePageComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HeroAwakenUpgradePageComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HeroAwakenUpgradePageComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compCommonBtnGroup = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.btnCommon = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnCommon:SetOnClick(function()
    self:OnBtnCommonClick()
  end)
  self.textCommonBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compCostGroup1 = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.imgCostIcon1 = self.viewSkin:AddComponent(self, UIImage, 5)
  self.textCostText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 6)
  self.compCostGroup2 = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
  self.imgCostIcon2 = self.viewSkin:AddComponent(self, UIImage, 8)
  self.textCostText2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 9)
  self.compNoCommonBtnGroup = self.viewSkin:AddComponent(self, UIBaseComponent, 10)
  self.btnNoCommon = self.viewSkin:AddComponent(self, UIButton, 11)
  self.btnNoCommon:SetOnClick(function()
    self:OnBtnNoCommonClick()
  end)
  self.textNoCommonBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 12)
  self.imgCostIcon3 = self.viewSkin:AddComponent(self, UIImage, 13)
  self.textCostText3 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 14)
  self.compHeroAwakenStarItem1 = self.viewSkin:AddComponent(self, HeroAwakenStarItemComponent, 15)
  self.compHeroAwakenStarItem2 = self.viewSkin:AddComponent(self, HeroAwakenStarItemComponent, 16)
  self.compHeroAwakenStarItem3 = self.viewSkin:AddComponent(self, HeroAwakenStarItemComponent, 17)
  self.compHeroAwakenStarItem4 = self.viewSkin:AddComponent(self, HeroAwakenStarItemComponent, 18)
  self.compHeroAwakenStarItem5 = self.viewSkin:AddComponent(self, HeroAwakenStarItemComponent, 19)
  self.btnHonor = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnHonor:SetOnClick(function()
    self:OnBtnHonorClick()
  end)
  self.textHonorBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.compPowerInfo = self.viewSkin:AddComponent(self, UIBaseContainer, 22)
  self.textRealPower = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.compBtnLayout = self.viewSkin:AddComponent(self, UIBaseComponent, 24)
  self.compHeroAwakenUpgradeSkillItem = self.viewSkin:AddComponent(self, HeroAwakenUpgradeSkillItem, 25)
  self.textHeroNickName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 26)
  self.textHeroName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 27)
  self.simpleAnimationHeroAwakenUpgradePage = self.viewSkin:AddComponent(self, UISimpleAnimation, 28)
  self.compEffUiHeroawakenUpgrade = self.viewSkin:AddComponent(self, UIVfx, 29)
  self.compEffUiHeroawakenTitle1 = self.viewSkin:AddComponent(self, UIBaseComponent, 30)
  self.compEffectLine = self.viewSkin:AddComponent(self, UIBaseContainer, 31)
  self.textMax = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 32)
  self.btnLWInfo = self.viewSkin:AddComponent(self, UIButton, 33)
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.compMax = self.viewSkin:AddComponent(self, UIBaseComponent, 34)
  self.compTmpLimit = self.viewSkin:AddComponent(self, UIBaseComponent, 35)
  self.textTmpLimit = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 36)
  self.compHeroAwakenStarItemList = {
    self.compHeroAwakenStarItem1,
    self.compHeroAwakenStarItem2,
    self.compHeroAwakenStarItem3,
    self.compHeroAwakenStarItem4,
    self.compHeroAwakenStarItem5
  }
  self.textCommonBtn:SetLocalText("hero_awaken_btn_19")
  self.textNoCommonBtn:SetLocalText("hero_awaken_btn_19")
  self.textHonorBtn:SetLocalText("hero_awaken_btn_10")
  self.textMax:SetLocalText("hero_awaken_desc_14")
  self.textTmpLimit:SetLocalText("hero_awaken_desc_32")
end

function HeroAwakenUpgradePageComponent:ComponentDestroy()
  self.viewSkin = nil
  self.compCommonBtnGroup = nil
  self.btnCommon = nil
  self.textCommonBtn = nil
  self.compCostGroup1 = nil
  self.imgCostIcon1 = nil
  self.textCostText1 = nil
  self.compCostGroup2 = nil
  self.imgCostIcon2 = nil
  self.textCostText2 = nil
  self.compNoCommonBtnGroup = nil
  self.btnNoCommon = nil
  self.textNoCommonBtn = nil
  self.imgCostIcon3 = nil
  self.textCostText3 = nil
  self.compHeroAwakenStarItem1 = nil
  self.compHeroAwakenStarItem2 = nil
  self.compHeroAwakenStarItem3 = nil
  self.compHeroAwakenStarItem4 = nil
  self.compHeroAwakenStarItem5 = nil
  self.btnHonor = nil
  self.textHonorBtn = nil
  self.compPowerInfo = nil
  self.textRealPower = nil
  self.compBtnLayout = nil
  self.compHeroAwakenUpgradeSkillItem = nil
  self.textHeroNickName = nil
  self.textHeroName = nil
  self.simpleAnimationHeroAwakenUpgradePage = nil
  self.compEffUiHeroawakenUpgrade = nil
  self.compEffUiHeroawakenTitle1 = nil
  self.compEffectLine = nil
  self.textMax = nil
  self.btnLWInfo = nil
  self.compMax = nil
  self.compTmpLimit = nil
  self.textTmpLimit = nil
  self.compHeroAwakenStarItemList = nil
end

function HeroAwakenUpgradePageComponent:DataDefine()
  self.heroData = nil
  self.clickSkillCallBack = BindCallback(self, self.OnClickSkillItem)
  self.effectItems = {}
  self.effectItemsReqs = {}
  self.soundId = nil
end

function HeroAwakenUpgradePageComponent:DataDestroy()
  self.heroData = nil
  self.clickSkillCallBack = nil
  self.effectItems = nil
  self.effectItemsReqs = nil
  if self.soundId ~= nil then
    DataCenter.LWSoundManager:StopSound(self.soundId)
    self.soundId = nil
  end
end

function HeroAwakenUpgradePageComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
end

function HeroAwakenUpgradePageComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  base.OnRemoveListener(self)
end

function HeroAwakenUpgradePageComponent:SetData(heroData, isUpgrading)
  if not heroData then
    return
  end
  self.heroData = heroData
  if not self.heroData then
    Logger.LogError("HeroAwakenUpgradePageComponent:SetData nil")
    return
  end
  self:RefreshView(isUpgrading)
end

function HeroAwakenUpgradePageComponent:RefreshView(isUpgrading)
  self:RefreshPower()
  self:RefreshStar(isUpgrading)
  self:RefreshEffect(isUpgrading)
  self:RefreshCost()
  self:RefreshTop()
  self:RefreshSkill(isUpgrading)
end

function HeroAwakenUpgradePageComponent:RefreshStar(isUpgrading)
  local rankTemplate = self.heroData:GetHeroAwakenRankTemplate()
  if not rankTemplate then
    return
  end
  local playVfx = isUpgrading
  local rankLevel = rankTemplate:GetRankLevel()
  for i, v in ipairs(self.compHeroAwakenStarItemList) do
    if rankLevel >= i * 5 then
      v:SetStarCount(5, playVfx)
    else
      local starFragCount = math.max(rankLevel % (i * 5) - (i - 1) * 5, 0)
      v:SetStarCount(starFragCount, playVfx)
    end
  end
end

function HeroAwakenUpgradePageComponent:RefreshEffect(isUpgrading)
  local curRankTemplate = self.heroData:GetHeroAwakenRankTemplate()
  if not curRankTemplate then
    return
  end
  local showEffects = curRankTemplate:GetUpgradePageShowEffects(self.heroData)
  if table.IsNullOrEmpty(showEffects) then
    self.compEffectLine:SetActive(false)
  else
    self.compEffectLine:SetActive(true)
    local num = 1
    local delayTime = 0.38
    local delayDeltaTime = 0.03
    for _, v in ipairs(showEffects) do
      local index = num
      if self.effectItems[index] == nil and self.effectItemsReqs[index] == nil then
        local loadRequest = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/UIHero/LWHero/HeroAwaken/LWHeroAwakenMain/HeroAwakenUpgradeEffectLineItem.prefab")
        loadRequest:completed("+", function()
          if not IsNull(loadRequest.gameObject) then
            local pageObj = loadRequest.gameObject
            local transform = pageObj.transform
            transform:SetParent(self.compEffectLine.transform)
            transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            pageObj.name = "effectItem" .. index
            local item = self:AddComponent(HeroAwakenUpgradeEffectLineItemComponent, pageObj)
            item:SetActive(true)
            item:ReInit(v, index)
            if isUpgrading then
              item:PlayVfx(delayTime)
            end
            self.effectItems[index] = item
            delayTime = delayTime + delayDeltaTime
          end
        end)
        self.effectItemsReqs[index] = loadRequest
      elseif self.effectItems[index] ~= nil then
        self.effectItems[index]:SetActive(true)
        self.effectItems[index]:ReInit(v, index)
        if isUpgrading then
          self.effectItems[index]:PlayVfx(delayTime)
          delayTime = delayTime + delayDeltaTime
        end
      end
      num = num + 1
    end
    for i, v in pairs(self.effectItems) do
      if i > #showEffects then
        v:SetActive(false)
      end
    end
  end
end

function HeroAwakenUpgradePageComponent:RefreshPower()
  self.textRealPower:SetText(self.heroData.power)
end

function HeroAwakenUpgradePageComponent:RefreshCost()
  if self.heroData == nil then
    return
  end
  local isTmpLimit = self.heroData:IsHeroAwakenReachTmpLimit()
  self.compBtnLayout:SetActive(not isTmpLimit)
  self.compTmpLimit:SetActive(isTmpLimit)
  self.compMax:SetActive(not isTmpLimit)
  if isTmpLimit then
    return
  end
  local isMaxLevel = self.heroData:IsHeroAwakenReachMaxLevel()
  self.compBtnLayout:SetActive(not isMaxLevel)
  self.compMax:SetActive(isMaxLevel)
  if isMaxLevel then
    return
  end
  local awakenTemplate = self.heroData:GetHeroAwakenTemplate()
  if not awakenTemplate then
    return
  end
  local rankTemplate = self.heroData:GetHeroAwakenRankTemplate()
  if not rankTemplate then
    return
  end
  local itemId = awakenTemplate:GetHeroAwakenRankUpgradeCostItemId()
  local haveCount = DataCenter.ItemData:GetItemCount(itemId)
  local costCount = rankTemplate:GetRankUpgradeCostItemCount()
  local isItemEnough = haveCount >= costCount
  local commonItemId = HeroUtils.GetHeroAwakenRankUpgradeCommonCostItemId()
  local icon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, itemId)
  local commonHaveCount = 0
  if commonItemId and 0 < commonItemId then
    commonHaveCount = DataCenter.ItemData:GetItemCount(commonItemId)
  end
  local showCommon = not isItemEnough and commonItemId and 0 < commonItemId and 0 < commonHaveCount
  self.compCommonBtnGroup:SetActive(showCommon)
  if showCommon then
    local commonIcon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, commonItemId)
    self.imgCostIcon1:LoadSprite(commonIcon)
    local commonCostCount = costCount - haveCount
    if commonHaveCount >= commonCostCount then
      self.textCostText1:SetText(string.format("<color=#5FEF87>%d</color>/%d", commonHaveCount, commonCostCount))
    else
      self.textCostText1:SetText(string.format("<color=#F97077>%d</color>/%d", commonHaveCount, commonCostCount))
    end
    self.textCostText2:SetText(string.format("<color=#5FEF87>%d</color>/%d", haveCount, haveCount))
    self.imgCostIcon2:LoadSprite(icon)
  end
  self.imgCostIcon3:LoadSprite(icon)
  if haveCount >= costCount then
    self.textCostText3:SetText(string.format("<color=#5FEF87>%d</color>/%d", haveCount, costCount))
  else
    self.textCostText3:SetText(string.format("<color=#F97077>%d</color>/%d", haveCount, costCount))
  end
end

function HeroAwakenUpgradePageComponent:RefreshTop()
  local isUnlockHonorWall = self.heroData:IsUnlockHonorWall()
  self.btnHonor:SetActive(isUnlockHonorWall)
  self.textHeroNickName:SetText(self.heroData:GetNickName())
  self.textHeroName:SetText(self.heroData:GetName())
end

function HeroAwakenUpgradePageComponent:RefreshSkill(isUpgrading)
  local skillData = self.heroData:GetHeroSkillBySlotIndex(HeroUtils.HeroAwakenReplaceSkillSlotIndex)
  self.compHeroAwakenUpgradeSkillItem:SetActive(skillData ~= nil)
  if not skillData then
    return
  end
  self.compHeroAwakenUpgradeSkillItem:SetData(skillData, {
    showSkillName = false,
    showSkillLevel = true,
    showLock = false,
    showRedPoint = false,
    showStar = true
  }, self.clickSkillCallBack, isUpgrading)
end

function HeroAwakenUpgradePageComponent:OnBtnCommonClick()
  if self.heroData == nil then
    Logger.LogError("HeroAwakenUpgradePageComponent:OnBtnCommonClick heroData nil")
    return
  end
  local isMaxLevel = self.heroData:IsHeroAwakenReachMaxLevel()
  if isMaxLevel then
    return
  end
  local awakenTemplate = self.heroData:GetHeroAwakenTemplate()
  if not awakenTemplate then
    return
  end
  local rankTemplate = self.heroData:GetHeroAwakenRankTemplate()
  if not rankTemplate then
    return
  end
  local itemId = awakenTemplate:GetHeroAwakenRankUpgradeCostItemId()
  local haveCount = DataCenter.ItemData:GetItemCount(itemId)
  local costCount = rankTemplate:GetRankUpgradeCostItemCount()
  local isItemEnough = haveCount >= costCount
  if isItemEnough then
    return
  end
  local commonItemId = HeroUtils.GetHeroAwakenRankUpgradeCommonCostItemId()
  local commonHaveCount = 0
  if commonItemId and 0 < commonItemId then
    commonHaveCount = DataCenter.ItemData:GetItemCount(commonItemId)
    local commonCostCount = costCount - haveCount
    if commonHaveCount >= commonCostCount then
      DataCenter.HeroAwakenDataManager:SendAwakenUpgradeMsg(self.heroData.uuid, true)
    else
      LWResourceLackUtil:GotoGoodsItemLack(commonItemId, commonCostCount)
    end
  end
end

function HeroAwakenUpgradePageComponent:OnBtnNoCommonClick()
  if self.heroData == nil then
    Logger.LogError("HeroAwakenUpgradePageComponent:OnBtnNoCommonClick heroData nil")
    return
  end
  local isMaxLevel = self.heroData:IsHeroAwakenReachMaxLevel()
  if isMaxLevel then
    return
  end
  local awakenTemplate = self.heroData:GetHeroAwakenTemplate()
  if not awakenTemplate then
    return
  end
  local rankTemplate = self.heroData:GetHeroAwakenRankTemplate()
  if not rankTemplate then
    return
  end
  local itemId = awakenTemplate:GetHeroAwakenRankUpgradeCostItemId()
  local haveCount = DataCenter.ItemData:GetItemCount(itemId)
  local costCount = rankTemplate:GetRankUpgradeCostItemCount()
  local isItemEnough = haveCount >= costCount
  if isItemEnough then
    DataCenter.HeroAwakenDataManager:SendAwakenUpgradeMsg(self.heroData.uuid, false)
  else
    LWResourceLackUtil:GotoGoodsItemLack(itemId, costCount)
  end
end

function HeroAwakenUpgradePageComponent:OnBtnHonorClick()
  if self.heroData == nil then
    Logger.LogError("HeroAwakenUpgradePageComponent:OnBtnHonorClick heroData nil")
    return
  end
  if self.heroData:IsUnlockHonorWall() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHeroHonorLevelUpgrade, {anim = true}, self.heroData.uuid)
  end
end

function HeroAwakenUpgradePageComponent:OnClickSkillItem(skillData, skillItem)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroSkillDetailPanel, {anim = true}, skillData, skillItem)
end

function HeroAwakenUpgradePageComponent:PlaySwitchInAnim()
  self.simpleAnimationHeroAwakenUpgradePage:Play(ANIM_NAME_SWITCH_IN)
end

function HeroAwakenUpgradePageComponent:PlayInAnim()
  self.simpleAnimationHeroAwakenUpgradePage:Play(ANIM_NAME_IN)
end

function HeroAwakenUpgradePageComponent:OnHeroAwakenUpgradeSuccess(uuid)
  if self.heroData == nil then
    return
  end
  local awakenRankLevel = self.heroData:GetHeroAwakenRankLevel()
  local isUnlocking = awakenRankLevel == 1
  if isUnlocking or self.heroData.uuid ~= uuid then
    return
  end
  local rankLevel = self.heroData:GetHeroAwakenRankLevel()
  local isShowStarUpgradeEffectView = 0 < rankLevel and rankLevel % 5 == 0
  if isShowStarUpgradeEffectView then
    UIManager:GetInstance():OpenWindow(UIWindowNames.HeroAwakenUpgradeStarEffect, {anim = false}, rankLevel, self.heroData)
  else
    self.soundId = DataCenter.LWSoundManager:PlaySound(SoundAssetId.SFX_Hero_Awaken_Upgrade, false)
  end
  self.compEffUiHeroawakenUpgrade:PlayByOnce(VfxAssets.HeroAwakenSpineEffect)
end

function HeroAwakenUpgradePageComponent:PreloadTitleVfx()
  if self.titleVfxReq ~= nil then
    return
  end
  self.titleVfxReq = self:GameObjectInstantiateAsync(VfxAssets.HeroAwakenTitleEffect, function(req)
    if req == nil or IsNull(req.gameObject) then
      return
    end
    local item = req.gameObject
    item:SetActive(true)
    item.transform:SetParent(self.compEffUiHeroawakenTitle1.transform)
    item.transform:Set_localScale(1, 1, 1)
    item.transform:Set_localPosition(0, 0, 0)
  end)
end

function HeroAwakenUpgradePageComponent:OnBtnLWInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("hero_awaken_info_16")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function HeroAwakenUpgradePageComponent:OnRefreshItems()
  self:RefreshCost()
end

return HeroAwakenUpgradePageComponent
