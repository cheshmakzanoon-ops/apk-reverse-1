local base = UIBaseContainer
local HeroAwakenUnlockPageComponent = BaseClass("HeroAwakenUnlockPageComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIHeroPreviewLine = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroPreviewLine")
local ANIM_NAME_IN = "HeroAwakenUnlockPage_movein"
local ANIM_NAME_SWITCH_OUT = "HeroAwakenUnlockPage_switch"

function HeroAwakenUnlockPageComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function HeroAwakenUnlockPageComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function HeroAwakenUnlockPageComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compConditionItem01 = self.viewSkin:AddComponent(self, UIBaseComponent, 2)
  self.textConditionText01 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.imgConditionCheck01 = self.viewSkin:AddComponent(self, UIImage, 4)
  self.textConditionText02 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgConditionCheck02 = self.viewSkin:AddComponent(self, UIImage, 6)
  self.textDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textHead = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.imgHeadIcon = self.viewSkin:AddComponent(self, UIImage, 9)
  self.textSkill = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 10)
  self.imgSkillIcon = self.viewSkin:AddComponent(self, UIImage, 11)
  self.compHpItem = self.viewSkin:AddComponent(self, UIHeroPreviewLine, 12)
  self.compAttackItem = self.viewSkin:AddComponent(self, UIHeroPreviewLine, 13)
  self.compDefenseItem = self.viewSkin:AddComponent(self, UIHeroPreviewLine, 14)
  self.btnUnlock = self.viewSkin:AddComponent(self, UIButton, 15)
  self.btnUnlock:SetOnClick(function()
    self:OnBtnUnlockClick()
  end)
  self.textUnlockBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 16)
  self.compCostGroup1 = self.viewSkin:AddComponent(self, UIBaseComponent, 17)
  self.imgCostIcon1 = self.viewSkin:AddComponent(self, UIImage, 18)
  self.textCostText1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 19)
  self.btnHonor = self.viewSkin:AddComponent(self, UIButton, 20)
  self.btnHonor:SetOnClick(function()
    self:OnBtnHonorClick()
  end)
  self.textHonorBtn = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 21)
  self.textHeroNickName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 22)
  self.textHeroName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 23)
  self.btnHead = self.viewSkin:AddComponent(self, UIButton, 24)
  self.btnHead:SetOnClick(function()
    self:OnBtnHeadClick()
  end)
  self.btnSkill = self.viewSkin:AddComponent(self, UIButton, 25)
  self.btnSkill:SetOnClick(function()
    self:OnBtnSkillClick()
  end)
  self.compEffUiHeroawakenHintSkill = self.viewSkin:AddComponent(self, UIVfx, 26)
  self.compEffUiHeroawakenHintHead = self.viewSkin:AddComponent(self, UIVfx, 27)
  self.animatorHeroAwakenUnlockPage = self.viewSkin:AddComponent(self, UIAnimator, 28)
  self.btnLWInfo = self.viewSkin:AddComponent(self, UIButton, 29)
  self.btnLWInfo:SetOnClick(function()
    self:OnBtnLWInfoClick()
  end)
  self.textTitle:SetLocalText("hero_awaken_desc_1")
  self.textDes:SetLocalText("hero_awaken_desc_5")
  self.textHead:SetLocalText("hero_awaken_desc_6")
  self.textSkill:SetLocalText("hero_awaken_desc_7")
  self.textUnlockBtn:SetLocalText("hero_awaken_btn_8")
  self.textHonorBtn:SetLocalText("hero_awaken_btn_10")
  self.compEffUiHeroawakenHintSkill:PlayByStay(VfxAssets.HeroAwakenUnlockHint)
  self.compEffUiHeroawakenHintHead:PlayByStay(VfxAssets.HeroAwakenUnlockHint)
end

function HeroAwakenUnlockPageComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.compConditionItem01 = nil
  self.textConditionText01 = nil
  self.imgConditionCheck01 = nil
  self.textConditionText02 = nil
  self.imgConditionCheck02 = nil
  self.textDes = nil
  self.textHead = nil
  self.imgHeadIcon = nil
  self.textSkill = nil
  self.imgSkillIcon = nil
  self.compHpItem = nil
  self.compAttackItem = nil
  self.compDefenseItem = nil
  self.btnUnlock = nil
  self.textUnlockBtn = nil
  self.compCostGroup1 = nil
  self.imgCostIcon1 = nil
  self.textCostText1 = nil
  self.btnHonor = nil
  self.textHonorBtn = nil
  self.textHeroNickName = nil
  self.textHeroName = nil
  self.btnHead = nil
  self.btnSkill = nil
  self.compEffUiHeroawakenHintSkill = nil
  self.compEffUiHeroawakenHintHead = nil
  self.animatorHeroAwakenUnlockPage = nil
  self.btnLWInfo = nil
end

function HeroAwakenUnlockPageComponent:DataDefine()
  self.heroData = nil
  self.skillData = nil
end

function HeroAwakenUnlockPageComponent:DataDestroy()
  self.heroData = nil
  self.skillData = nil
end

function HeroAwakenUnlockPageComponent:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
end

function HeroAwakenUnlockPageComponent:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
  base.OnRemoveListener(self)
end

function HeroAwakenUnlockPageComponent:SetData(heroData)
  if not heroData then
    return
  end
  self.heroData = heroData
  if not self.heroData then
    Logger.LogError("HeroAwakenUnlockPageComponent:SetData nil")
    return
  end
  self:RefreshView()
end

function HeroAwakenUnlockPageComponent:RefreshView()
  self:RefreshCondition()
  self:RefreshUnlockBonus()
  self:RefreshEffect()
  self:RefreshCost()
  self:RefreshTop()
end

function HeroAwakenUnlockPageComponent:RefreshCondition()
  self.textConditionText01:SetColorRGBA255(95, 239, 135, 255)
  self.textConditionText01:SetLocalText("hero_awaken_desc_3", 5)
  self.imgConditionCheck01:SetActive(true)
  local minUniqueWeaponLv = LuaEntry.DataConfig:TryGetNum("hero_awaken_config", "k2", 0)
  local uniqueWeaponLv = self.heroData:GetUniqueWeaponLv()
  local isUniqueWeaponLvEnough = minUniqueWeaponLv <= uniqueWeaponLv
  self.imgConditionCheck02:SetActive(isUniqueWeaponLvEnough)
  if isUniqueWeaponLvEnough then
    self.textConditionText02:SetColorRGBA255(95, 239, 135, 255)
  else
    self.textConditionText02:SetColorRGBA255(249, 112, 119, 255)
  end
  self.textConditionText02:SetLocalText("hero_awaken_desc_4", minUniqueWeaponLv)
end

function HeroAwakenUnlockPageComponent:RefreshUnlockBonus()
  local awakenTemplate = DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenTemplateById(self.heroData.heroId, true)
  if not awakenTemplate then
    return
  end
  local iconPath = HeroUtils.GetHeroIconPath(self.heroData.modelId, HeroIconType.small_icon, awakenTemplate.awaken_skin_id)
  self.imgHeadIcon:LoadSpriteAuto(iconPath)
  local rankTemplate = DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenRankTemplateByHeroIdAndLevel(self.heroData.heroId, 1)
  if not rankTemplate then
    return
  end
  local skillId = rankTemplate:GetSkillId()
  if skillId then
    local skillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
    if skillTemplate then
      self.imgSkillIcon:LoadSpriteAuto(skillTemplate.icon)
      self.skillData = SkillInfo.New()
      self.skillData:CreateFromTemplate(skillId, false, 1)
    end
  end
end

function HeroAwakenUnlockPageComponent:RefreshEffect()
  local rankTemplate = DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenRankTemplateByHeroIdAndLevel(self.heroData.heroId, 1)
  if not rankTemplate then
    return
  end
  local hpFactor = self.heroData:GetHpFactor()
  local curHp = self.heroData.rankTemplate:GetEffectAdd(HeroEffectDefine.HealthPoint, false) * hpFactor
  curHp = tostring(math.floor(curHp))
  local addHp = rankTemplate:GetEffectAdd(HeroEffectDefine.UniqueWeaponHp, false)
  addHp = self.heroData:ProcessEffectValue(HeroEffectDefine.UniqueWeaponHp, addHp)
  local nextHp = addHp + curHp
  nextHp = tostring(math.floor(nextHp))
  self.compHpItem:SetData(0, tostring(math.floor(addHp)), 0)
  if addHp <= 0 then
    Logger.LogError(rankTemplate.id .. " \232\139\177\233\155\132\232\167\137\233\134\146rank\232\161\168:attr_add\229\136\151\228\184\173\229\191\133\233\161\187\233\133\141\231\189\174\232\161\128\233\135\143\229\177\158\230\128\16751000")
  end
  local atkFactor = self.heroData:GetAtkFactor()
  local curAtk = self.heroData.rankTemplate:GetEffectAdd(HeroEffectDefine.PhysicalAttack, false) * atkFactor
  curAtk = tostring(math.floor(curAtk))
  local addAtk = rankTemplate:GetEffectAdd(HeroEffectDefine.UniqueWeaponAtk, false)
  addAtk = self.heroData:ProcessEffectValue(HeroEffectDefine.UniqueWeaponAtk, addAtk)
  local nextAtk = addAtk + curAtk
  nextAtk = tostring(math.floor(nextAtk))
  self.compAttackItem:SetData(0, tostring(math.floor(addAtk)), 1)
  if addAtk <= 0 then
    Logger.LogError(rankTemplate.id .. " \232\139\177\233\155\132\232\167\137\233\134\146rank\232\161\168:attr_add\229\136\151\228\184\173\229\191\133\233\161\187\233\133\141\231\189\174\230\148\187\229\135\187\229\177\158\230\128\16751050")
  end
  local defFactor = self.heroData:GetDefFactor()
  local curDef = self.heroData.rankTemplate:GetEffectAdd(HeroEffectDefine.PhysicalDefense, false) * defFactor
  curDef = tostring(math.floor(curDef))
  local addDef = rankTemplate:GetEffectAdd(HeroEffectDefine.UniqueWeaponDef, false)
  addDef = self.heroData:ProcessEffectValue(HeroEffectDefine.UniqueWeaponDef, addDef)
  local nextDef = addDef + curDef
  nextDef = tostring(math.floor(nextDef))
  self.compDefenseItem:SetData(0, tostring(math.floor(addDef)), 2)
  if addDef <= 0 then
    Logger.LogError(rankTemplate.id .. " \232\139\177\233\155\132\232\167\137\233\134\146rank\232\161\168:attr_add\229\136\151\228\184\173\229\191\133\233\161\187\233\133\141\231\189\174\233\152\178\229\190\161\229\177\158\230\128\16751100")
  end
end

function HeroAwakenUnlockPageComponent:RefreshCost()
  if self.heroData == nil then
    return
  end
  local awakenTemplate = DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenTemplateById(self.heroData.heroId, true)
  if not awakenTemplate then
    return
  end
  local rankTemplate = DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenRankTemplateByHeroIdAndLevel(self.heroData.heroId, 0)
  if not rankTemplate then
    return
  end
  local costItemId = awakenTemplate:GetHeroAwakenRankUpgradeCostItemId()
  local costItemCount = rankTemplate:GetRankUpgradeCostItemCount()
  local haveItemCount = DataCenter.ItemData:GetItemCount(costItemId)
  local costItemIcon = DataCenter.RewardManager:GetPicByType(RewardType.GOODS, costItemId)
  self.imgCostIcon1:LoadSpriteAuto(costItemIcon)
  if costItemCount <= haveItemCount then
    self.textCostText1:SetText(string.format("<color=#5FEF87>%d</color>/%d", haveItemCount, costItemCount))
  else
    self.textCostText1:SetText(string.format("<color=#F97077>%d</color>/%d", haveItemCount, costItemCount))
  end
  local minUniqueWeaponLv = LuaEntry.DataConfig:TryGetNum("hero_awaken_config", "k2", 0)
  local uniqueWeaponLv = self.heroData:GetUniqueWeaponLv()
  local isUniqueWeaponLvEnough = minUniqueWeaponLv <= uniqueWeaponLv
  if isUniqueWeaponLvEnough then
    if costItemCount <= haveItemCount then
      self.textUnlockBtn:SetLocalText("hero_awaken_btn_8")
    else
      self.textUnlockBtn:SetLocalText("hero_awaken_btn_17")
    end
    CS.UIGray.SetGray(self.btnUnlock.transform, false, true)
  else
    self.textUnlockBtn:SetLocalText("hero_awaken_btn_18")
    CS.UIGray.SetGray(self.btnUnlock.transform, true, true)
  end
end

function HeroAwakenUnlockPageComponent:RefreshTop()
  self.textHeroNickName:SetText(self.heroData:GetNickName())
  self.textHeroName:SetText(self.heroData:GetName())
  local isUnlockHonorWall = self.heroData:IsUnlockHonorWall()
  self.btnHonor:SetActive(isUnlockHonorWall)
end

function HeroAwakenUnlockPageComponent:OnBtnUnlockClick()
  if not self.heroData then
    Logger.LogError("HeroAwakenUnlockPageComponent:OnBtnUnlockClick heroData nil")
    return
  end
  if self.heroData:IsHeroAwakened() or self.heroData:IsHeroAwakenReachMaxLevel() then
    return
  end
  if not self.heroData:IsHeroAwakenCanUpgrade() then
    return
  end
  local awakenTemplate = DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenTemplateById(self.heroData.heroId, true)
  if not awakenTemplate then
    return
  end
  local rankTemplate = DataCenter.HeroAwakenTemplateManager:GetLwHeroAwakenRankTemplateByHeroIdAndLevel(self.heroData.heroId, 0)
  if not rankTemplate then
    return
  end
  local costItemId = awakenTemplate:GetHeroAwakenRankUpgradeCostItemId()
  local costItemCount = rankTemplate:GetRankUpgradeCostItemCount()
  local haveItemCount = DataCenter.ItemData:GetItemCount(costItemId)
  if costItemCount <= haveItemCount then
    DataCenter.HeroAwakenDataManager:SendAwakenUpgradeMsg(self.heroData.uuid, false)
  else
    LWResourceLackUtil:GotoGoodsItemLack(costItemId, costItemCount)
  end
end

function HeroAwakenUnlockPageComponent:OnBtnHonorClick()
  if self.heroData == nil then
    Logger.LogError("HeroAwakenUnlockPageComponent:OnBtnHonorClick heroData nil")
    return
  end
  if self.heroData:IsUnlockHonorWall() then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHeroHonorLevelUpgrade, {anim = true}, self.heroData.uuid)
  end
end

function HeroAwakenUnlockPageComponent:OnBtnHeadClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.HeroAwakenSkinPreview, {anim = true}, self.heroData)
end

function HeroAwakenUnlockPageComponent:OnBtnSkillClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.HeroAwakenSkillPreview, {anim = true}, self.heroData)
end

function HeroAwakenUnlockPageComponent:PlaySwitchOutAnimReturnTime()
  return self.animatorHeroAwakenUnlockPage:PlayAnimationReturnTime(ANIM_NAME_SWITCH_OUT)
end

function HeroAwakenUnlockPageComponent:PlayInAnim()
  return self.animatorHeroAwakenUnlockPage:Play(ANIM_NAME_IN)
end

function HeroAwakenUnlockPageComponent:OnBtnLWInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("hero_awaken_info_16")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function HeroAwakenUnlockPageComponent:GetHeroSpineContainer()
  return self.compHeroSpineContainer
end

function HeroAwakenUnlockPageComponent:OnRefreshItems()
  self:RefreshCost()
end

return HeroAwakenUnlockPageComponent
