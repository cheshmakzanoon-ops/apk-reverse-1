local HeroSkillAreaComponent = BaseClass("HeroSkillAreaComponent", UIBaseContainer)
local UIHeroSkillItem = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillItem")
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local u_i_hero_skill_item1_path = "SkillListArea/UIHeroSkillItem1"
local u_i_hero_skill_item2_path = "SkillListArea/UIHeroSkillItem2"
local u_i_hero_skill_item3_path = "SkillListArea/UIHeroSkillItem3"
local u_i_hero_skill_item4_path = "SkillListArea/UIHeroSkillItem4"
local return_upgrade_mat_tip_text_path = "ReturnUpgradeMatTipText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.compUIHeroSkillItem1 = self:AddComponent(UIHeroSkillItem, u_i_hero_skill_item1_path)
  self.compUIHeroSkillItem2 = self:AddComponent(UIHeroSkillItem, u_i_hero_skill_item2_path)
  self.compUIHeroSkillItem3 = self:AddComponent(UIHeroSkillItem, u_i_hero_skill_item3_path)
  self.compUIHeroSkillItem4 = self:AddComponent(UIHeroSkillItem, u_i_hero_skill_item4_path)
  self.compSkills = {
    self.compUIHeroSkillItem1,
    self.compUIHeroSkillItem2,
    self.compUIHeroSkillItem3,
    self.compUIHeroSkillItem4
  }
  self.returnUpgradeMatText = self:AddComponent(UIText, return_upgrade_mat_tip_text_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function HeroSkillAreaComponent:SetData(fromHeroData, toHeroData)
  if not fromHeroData or not toHeroData then
    return
  end
  local levelAfterChange = toHeroData.level
  local rankAfterChange = toHeroData.rank
  local weaponLv = fromHeroData:GetUniqueWeaponLv()
  local previewHeroData = DeepCopy(fromHeroData)
  previewHeroData.rank = rankAfterChange
  previewHeroData.level = levelAfterChange
  local previewSkillList = previewHeroData.skillList
  local needReturnSkillUpgradeMat = 0
  local curSkillMaxLvAdd = previewHeroData:GetProperty(HeroEffectDefine.HeroSkillMaxLevelAdd)
  local showNeedRankId = LuaEntry.DataConfig:TryGetNum("hero_unique_weapon", "k3", 0)
  local allReplaceUniqueWeaponTemplate = {}
  if fromHeroData:HasUniqueWeapon() and rankAfterChange < showNeedRankId then
    curSkillMaxLvAdd = 0
    previewHeroData.skillMaxLvAdd = curSkillMaxLvAdd
    for i = 1, weaponLv do
      local uniqueWeaponTemplate = DataCenter.HeroUniqueWeaponTemplateManager:GetTemplateByHeroId(fromHeroData.heroId, i)
      if uniqueWeaponTemplate:IsExistReplaceSkill() then
        table.insert(allReplaceUniqueWeaponTemplate, uniqueWeaponTemplate)
      end
    end
  end
  for k, v in pairs(previewSkillList) do
    local slotIndex = k
    local skillData = v
    if slotIndex > #self.compSkills then
      break
    end
    local group = skillData.skillTemplateData.group
    if 0 < #allReplaceUniqueWeaponTemplate then
      for _, v2 in ipairs(allReplaceUniqueWeaponTemplate) do
        local ret, skillIdAfterChange = v2:GetSkillIdBeforeChange(group)
        if ret then
          group = skillIdAfterChange
          break
        end
      end
    end
    local isUnlockAfterChange = false
    local skillUnlockLevel = fromHeroData:GetSkillUnlockLevelByIndex(slotIndex)
    local skillUnlockRank = fromHeroData:GetSkillUnlockRankByIndex(slotIndex)
    isUnlockAfterChange = levelAfterChange >= skillUnlockLevel and rankAfterChange >= skillUnlockRank
    local skillIdAfterExchange = DataCenter.HeroSkillTemplateManager:GetMaxSkillIdByGroupAndRank(group, rankAfterChange)
    local skillDataBeforeChange = SkillInfo.New()
    skillDataBeforeChange:SetAddMaxLevel(curSkillMaxLvAdd or 0)
    skillDataBeforeChange:CreateFromTemplate(skillIdAfterExchange, isUnlockAfterChange, skillData.level)
    skillDataBeforeChange.slotIndex = slotIndex
    previewSkillList[slotIndex] = skillDataBeforeChange
    local skillLvBeforeChange = skillData.level
    local skillLvAfterChange = skillDataBeforeChange.level
    if skillLvBeforeChange > skillLvAfterChange then
      local heroName = Localization:GetString(fromHeroData.meta.name)
      for i = skillLvAfterChange, skillLvBeforeChange - 1 do
        local costSp = skillDataBeforeChange.skillTemplateData:GetCostSkillPointCount(i)
        needReturnSkillUpgradeMat = needReturnSkillUpgradeMat + costSp
      end
    end
  end
  self.returnUpgradeMatText:SetActive(0 < needReturnSkillUpgradeMat)
  if 0 < needReturnSkillUpgradeMat then
    self.returnUpgradeMatText:SetLocalText("activity_hero_change_cofirm_skill_tips_1", needReturnSkillUpgradeMat)
  end
  for i = 1, #self.compSkills do
    local skillData = previewSkillList[i]
    if skillData then
      skillData:SetAddMaxLevel(curSkillMaxLvAdd)
      local unlockLevel = 0
      if skillData then
        self.compSkills[i]:SetData(skillData, {
          showSkillName = false,
          showSkillLevel = true,
          showLock = true,
          showRedPoint = false,
          showStar = true,
          unlockLevel = unlockLevel
        })
        self.compSkills[i]:ForceShowLevelNumText()
      end
    end
  end
end

HeroSkillAreaComponent.OnCreate = OnCreate
HeroSkillAreaComponent.OnDestroy = OnDestroy
HeroSkillAreaComponent.OnEnable = OnEnable
HeroSkillAreaComponent.OnDisable = OnDisable
HeroSkillAreaComponent.ComponentDefine = ComponentDefine
HeroSkillAreaComponent.ComponentDestroy = ComponentDestroy
HeroSkillAreaComponent.DataDefine = DataDefine
HeroSkillAreaComponent.DataDestroy = DataDestroy
HeroSkillAreaComponent.OnAddListener = OnAddListener
HeroSkillAreaComponent.OnRemoveListener = OnRemoveListener
return HeroSkillAreaComponent
