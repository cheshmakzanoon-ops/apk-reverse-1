local HeroAwakenUpgradeSkillItem = BaseClass("HeroAwakenUpgradeSkillItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local UIHeroSkillStar = require("UI.UILWHero.UIHeroDetailPanel.Component.UIHeroSkillStar")

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function DataDefine(self)
  self.showSkillName = true
  self.showSkillLevel = true
  self.selected = false
  self.isHeroAwakenSkill = false
  self.showStarCount = 0
end

local function DataDestroy(self)
  self.skillData = nil
  self.callBack = nil
  self.templateItemCallBack = nil
  self.showSkillLevel = nil
  self.showSkillName = nil
  self.selected = nil
  self.isHeroAwakenSkill = nil
  self.showStarCount = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function ClearStars(self)
  if self.stars then
    self.stars:RemoveComponents(UIHeroSkillStar)
    self.starTempalte.gameObject:GameObjectRecycleAll()
    self.starEffectTempalte.gameObject:GameObjectRecycleAll()
    self.newAddStar = nil
  end
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.skillNameText = self:AddComponent(UIText, "ContentContainer/NameText")
  self.skillBtn = self:AddComponent(UIButton, "ContentContainer")
  self.skillIcon = self:AddComponent(UIImage, "ContentContainer/Icon")
  self.levelBg = self:AddComponent(UIImage, "ContentContainer/LevelBg")
  self.levelText = self:AddComponent(UIText, "ContentContainer/LevelBg/LevelText")
  self.lockContent = self:AddComponent(UIBaseComponent, "ContentContainer/LockContent")
  self.imgLockMask = self:AddComponent(UIImage, "ContentContainer/LockContent/BlackMask")
  self.imgLockMaskHeroAwaken = self:TryAddComponent(UIImage, "ContentContainer/LockContent/BlackMaskHeroAwaken")
  self.contentContainer = self:AddComponent(UIBaseContainer, "ContentContainer")
  self.redPoint = self:AddComponent(UIImage, "ContentContainer/RedPoint")
  self.newTag = self:AddComponent(UIImage, "ContentContainer/NewTag")
  self.stars = self:AddComponent(UIBaseContainer, "ContentContainer/Stars")
  self.starTempalte = self.transform:Find("ContentContainer/Stars/StarTemplate").gameObject
  self.starTempalte:GameObjectCreatePool()
  self.starTempalte:SetActive(false)
  self.starEffectTempalte = self.transform:Find("ContentContainer/Stars/StarEffectTemplate").gameObject
  self.starEffectTempalte:GameObjectCreatePool()
  self.starEffectTempalte:SetActive(false)
  self.selectedBg = self:AddComponent(UIImage, "ContentContainer/SelectedBg")
  self.skillBtn:SetOnClick(BindCallback(self, self.OnItemClick))
  self.imgSkillFrame = self:AddComponent(UIImage, "ContentContainer/SkillFrame")
  self.imgSkillFrameHeroAwaken = self:TryAddComponent(UIImage, "ContentContainer/SkillFrameHeroAwaken")
end

local function ComponentDestroy(self)
  self.root = nil
  self.skillNameText = nil
  self.skillBtn = nil
  self.skillIcon = nil
  self.levelBg = nil
  self.levelText = nil
  self.lockContent = nil
  self.imgLockMask = nil
  self.imgLockMaskHeroAwaken = nil
  self.contentContainer = nil
  self.redPoint = nil
  self.newTag = nil
  self.stars = nil
  ClearStars(self)
  self.starTempalte = nil
  self.selectedBg = nil
  self.imgSkillFrame = nil
  self.imgSkillFrameHeroAwaken = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetSelected(self, state)
  self.selected = state
  self.selectedBg:SetActive(self.selected)
end

local function SetLocked(self, isLocked)
  local isShowLock = self.showLock and isLocked
  if isShowLock then
    UIGray.SetGray(self.skillIcon.transform, true, true)
    self.lockContent:SetActive(true)
    if self.imgLockMaskHeroAwaken then
      self.imgLockMaskHeroAwaken:SetActive(self.isHeroAwakenSkill)
      self.imgLockMask:SetActive(not self.isHeroAwakenSkill)
      if self.isHeroAwakenSkill then
        self.imgLockMaskHeroAwaken:LoadSpriteAuto(UIAssets.HeroAwakenSkillFrameMaskImagePath)
      end
    else
      self.imgLockMask:SetActive(true)
    end
  else
    UIGray.SetGray(self.skillIcon.transform, false, true)
    self.lockContent:SetActive(false)
  end
end

local function GetSelected(self)
  return self.selected
end

local function GetSkillData(self)
  return self.skillData
end

local function SetData(self, skillData, param, callBack, showStarEffect)
  self.isHeroAwakenSkill = false
  if param ~= nil then
    self.showSkillName = param.showSkillName
    self.showSkillLevel = param.showSkillLevel
    self.showLock = param.showLock
    self.showRedPoint = param.showRedPoint
    self.unlockLevel = param.unlockLevel
    self.showStar = param.showStar
    self.showSkillMaxLevel = param.showSkillMaxLevel
    self.showNewTag = param.showNewTag
  end
  if callBack ~= nil then
    self.callBack = callBack
  end
  self.templateItemCallBack = nil
  if skillData == nil then
    self:SetActive(false)
    return
  else
    self:SetActive(true)
  end
  self.skillData = skillData
  self.skillId = skillData.skillId
  self.level = skillData.level
  self.addMaxLv = skillData.addMaxLv
  local showSkillData = skillData
  if self.skillData.heroUuid then
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.skillData.heroUuid)
    if heroData then
      showSkillData = DataCenter.LWArmedUpgradeManager:GetArmedUpgradeSkillInfoData(heroData, self.skillData)
    end
  end
  self.isHeroAwakenSkill = showSkillData:IsHeroAwakenSkill()
  if self.showSkillName then
    self.skillNameText:SetActive(true)
    self.skillNameText:SetLocalText(showSkillData.skillTemplateData.name)
  else
    self.skillNameText:SetActive(false)
  end
  self.skillIcon:LoadSprite(showSkillData.skillTemplateData.icon)
  local showSkillLevel = self.showSkillLevel
  if showSkillLevel == nil then
    showSkillLevel = true
  end
  SetLocked(self, not self.skillData:IsUnlock())
  if showSkillLevel then
    self.levelBg:SetActive(true)
    if (self.showSkillMaxLevel == nil or self.showSkillMaxLevel == true) and self.skillData:IsReachGroupMaxLevel() then
      self.levelText:SetLocalText("110000")
    else
      self.levelText:SetText(self.skillData:GetLevel())
    end
    if self.isHeroAwakenSkill then
      self.levelBg:LoadSpriteAuto(UIAssets.HeroAwakenSkillLevelBgImagePath)
    else
      self.levelBg:LoadSpriteAuto(UIAssets.CommonHeroSkillLevelBgImagePath)
    end
  else
    self.levelBg:SetActive(false)
  end
  if self.showRedPoint then
    self.redPoint:SetActive(true)
  else
    self.redPoint:SetActive(false)
  end
  if self.showStar and not self.skillData:IsUnlock() then
    self.showStar = false
  end
  if self.showStar then
    self.stars:SetActive(true)
    ClearStars(self)
    local curStar = self.skillData:GetStar()
    if 0 < curStar then
      local showStarCount = math.min(curStar, 5)
      local leftWindow = math.max(0, curStar - 5)
      local showAddStarEffect = showStarCount > self.showStarCount and showStarEffect == true
      if showAddStarEffect then
        local effectItem = self.starEffectTempalte:GameObjectSpawn(self.stars.transform)
        effectItem.name = "star" .. showStarCount
        local staticStarCount = showStarCount - 1
        if 0 < staticStarCount then
          for i = 1, staticStarCount do
            local item = self.starTempalte:GameObjectSpawn(self.stars.transform)
            item.name = "star" .. i
            local viewStarIndex = leftWindow + i
            local cell = self.stars:AddComponent(UIHeroSkillStar, item.name)
            cell:SetFilled(true)
            local imagePath = HeroUtils.GetHeroSkillItemStarImageAssetPath(self.isHeroAwakenSkill, viewStarIndex)
            cell:SetStarImageByPath(imagePath)
          end
        end
      else
        for i = 1, showStarCount do
          local item = self.starTempalte:GameObjectSpawn(self.stars.transform)
          item.name = "star" .. i
          local viewStarIndex = leftWindow + i
          local cell = self.stars:AddComponent(UIHeroSkillStar, item.name)
          cell:SetFilled(true)
          local imagePath = HeroUtils.GetHeroSkillItemStarImageAssetPath(self.isHeroAwakenSkill, viewStarIndex)
          cell:SetStarImageByPath(imagePath)
        end
      end
      self.showStarCount = showStarCount
    end
    self.curStar = curStar
  else
    self.stars:SetActive(false)
  end
  self.newTag:SetActive(self.showNewTag == true)
  self.imgSkillFrame:SetActive(not self.isHeroAwakenSkill)
  if self.imgSkillFrameHeroAwaken then
    self.imgSkillFrameHeroAwaken:SetActive(self.isHeroAwakenSkill)
    if self.isHeroAwakenSkill then
      self.imgSkillFrameHeroAwaken:LoadSpriteAuto(UIAssets.HeroAwakenSkillFrameImagePath)
    end
  end
  SetSelected(self, false)
end

local function OnItemClick(self)
  if self.callBack and self.skillData then
    self.callBack(self.skillData, self)
  elseif self.templateItemCallBack and self.skillId then
    self.templateItemCallBack(self.skillId, self.level, self.addMaxLv, self)
  end
end

function HeroAwakenUpgradeSkillItem:SetSelectBgScale(scale)
  self.selectedBg:SetLocalScaleXYZ(scale, scale, scale)
end

HeroAwakenUpgradeSkillItem.OnCreate = OnCreate
HeroAwakenUpgradeSkillItem.OnDestroy = OnDestroy
HeroAwakenUpgradeSkillItem.OnEnable = OnEnable
HeroAwakenUpgradeSkillItem.OnDisable = OnDisable
HeroAwakenUpgradeSkillItem.DataDefine = DataDefine
HeroAwakenUpgradeSkillItem.DataDestroy = DataDestroy
HeroAwakenUpgradeSkillItem.ComponentDefine = ComponentDefine
HeroAwakenUpgradeSkillItem.ComponentDestroy = ComponentDestroy
HeroAwakenUpgradeSkillItem.SetData = SetData
HeroAwakenUpgradeSkillItem.OnAddListener = OnAddListener
HeroAwakenUpgradeSkillItem.OnRemoveListener = OnRemoveListener
HeroAwakenUpgradeSkillItem.OnItemClick = OnItemClick
HeroAwakenUpgradeSkillItem.SetSelected = SetSelected
HeroAwakenUpgradeSkillItem.GetSelected = GetSelected
HeroAwakenUpgradeSkillItem.GetSkillData = GetSkillData
return HeroAwakenUpgradeSkillItem
