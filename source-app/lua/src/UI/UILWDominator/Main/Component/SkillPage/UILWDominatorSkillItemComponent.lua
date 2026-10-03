local UILWDominatorSkillItemComponent = BaseClass("UILWDominatorSkillItemComponent", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
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
end

local function DataDestroy(self)
  self.skillData = nil
  self.callBack = nil
  self.templateItemCallBack = nil
  self.showSkillLevel = nil
  self.showSkillName = nil
  self.selected = nil
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
    self.newAddStar = nil
  end
end

local function ComponentDefine(self)
  self.root = self:AddComponent(UIBaseContainer, "")
  self.skillNameText = self:AddComponent(UIText, "ContentContainer/NameText")
  self.skillBtn = self:AddComponent(UIButton, "ContentContainer")
  self.skillIcon = self:AddComponent(UIImage, "ContentContainer/Icon")
  self.levelText = self:AddComponent(UIText, "ContentContainer/LevelText")
  self.lockContent = self:AddComponent(UIImage, "ContentContainer/LockContent")
  self.contentContainer = self:AddComponent(UIBaseContainer, "ContentContainer")
  self.redPoint = self:AddComponent(UIImage, "ContentContainer/RedPoint")
  self.newTag = self:AddComponent(UIImage, "ContentContainer/NewTag")
  self.stars = self:AddComponent(UIBaseContainer, "ContentContainer/Stars")
  self.starTempalte = self.transform:Find("ContentContainer/Stars/StarTemplate").gameObject
  self.starTempalte:GameObjectCreatePool()
  self.selectedBg = self:AddComponent(UIImage, "ContentContainer/SelectedBg")
  self.skillBtn:SetOnClick(BindCallback(self, self.OnItemClick))
end

local function ComponentDestroy(self)
  self.root = nil
  self.skillNameText = nil
  self.skillBtn = nil
  self.skillIcon = nil
  self.levelText = nil
  self.lockContent = nil
  self.contentContainer = nil
  self.redPoint = nil
  self.newTag = nil
  self.stars = nil
  ClearStars(self)
  self.starTempalte = nil
  self.selectedBg = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetSelected(self, state)
  self.selected = state
  self.selectedBg:SetActive(state)
end

local function GetSelected(self)
  return self.selected
end

local function GetSkillData(self)
  return self.skillData
end

local function SetData(self, skillData, param, callBack)
  if param ~= nil then
    self.showSkillName = param.showSkillName
    self.showSkillLevel = param.showSkillLevel
    self.showLock = param.showLock
    self.showRedPoint = param.showRedPoint
    self.unlockLevel = param.unlockLevel
    self.showStar = param.showStar
    self.showLockForce = param.showLockForce
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
  if self.showSkillName then
    self.skillNameText:SetActive(true)
    self.skillNameText:SetLocalText(self.skillData.skillTemplateData.name)
  else
    self.skillNameText:SetActive(false)
  end
  self.skillIcon:LoadSprite(self.skillData.skillTemplateData.icon)
  local showSkillLevel = self.showSkillLevel
  if showSkillLevel == nil then
    showSkillLevel = true
  end
  if self.showLock then
    if self.showLockForce or not self.skillData:IsUnlock() then
      UIGray.SetGray(self.skillIcon.transform, true, true)
      self.lockContent:SetActive(true)
    else
      UIGray.SetGray(self.skillIcon.transform, false, true)
      self.lockContent:SetActive(false)
    end
  else
    UIGray.SetGray(self.skillIcon.transform, false, true)
    self.lockContent:SetActive(false)
  end
  self.levelText:SetActive(showSkillLevel)
  if showSkillLevel then
    if self.skillData:IsReachGroupMaxLevel() then
      self.levelText:SetLocalText("110000")
    else
      self.levelText:SetText("Lv." .. self.skillData:GetLevel())
    end
  else
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
      for i = 1, showStarCount do
        local item = self.starTempalte:GameObjectSpawn(self.stars.transform)
        item.name = "star" .. i
        local viewStarIndex = leftWindow + i
        local cell = self.stars:AddComponent(UIHeroSkillStar, item.name)
        cell:SetFilled(true)
        cell:SetStarIndex(viewStarIndex)
      end
    end
    self.curStar = curStar
  else
    self.stars:SetActive(false)
  end
  self.newTag:SetActive(false)
  SetSelected(self, false)
end

local function OnItemClick(self)
  if self.callBack and self.skillData then
    self.callBack(self.skillData, self)
  elseif self.templateItemCallBack and self.skillId then
    self.templateItemCallBack(self.skillId, self.level, self.addMaxLv, self)
  end
end

local function ShowNewTag(self)
  self.newTag:SetActive(true)
  if self.showRedPoint then
    self.redPoint:SetActive(false)
  end
end

local function HideNewTag(self)
  self.newTag:SetActive(false)
  if self.showRedPoint then
    self.redPoint:SetActive(true)
  end
end

local function GetNewTagShowState(self)
  return self.newTag.gameObject.activeSelf
end

local function ShowNewStarEffect(self)
  if not self.newAddStar then
    local star = self.starTempalte:GameObjectSpawn(self.stars.transform)
    star.name = "NewAddStar"
    self.newAddStar = self.stars:AddComponent(UIHeroSkillStar, star.name)
    star.transform:SetAsFirstSibling()
  end
  self.newAddStar:SetFilled(true)
  self.newAddStar:SetStarIndex((self.curStar or 0) + 1)
  self.newAddStar:PlayBreathEffect()
end

local function SetTemplateData(self, skillId, level, addMaxLv, param, callBack)
  if not skillId then
    self:SetActive(false)
    return
  else
    self:SetActive(true)
  end
  if param ~= nil then
    self.showSkillName = param.showSkillName
    self.showSkillLevel = param.showSkillLevel
    self.showLock = param.showLock
    self.showRedPoint = param.showRedPoint
    self.showStar = param.showStar
  end
  local heroSkillTemplate = DataCenter.HeroSkillTemplateManager:GetTemplate(skillId)
  if heroSkillTemplate == nil then
    self:SetActive(false)
    return
  end
  local _level = level or 1
  local _star = heroSkillTemplate.star
  local _addMaxLevel = addMaxLv or 0
  if callBack ~= nil then
    self.templateItemCallBack = callBack
  end
  self.callBack = nil
  self.skillId = skillId
  self.level = _level
  self.addMaxLv = _addMaxLevel
  if self.showSkillName then
    self.skillNameText:SetActive(true)
    self.skillNameText:SetLocalText(heroSkillTemplate.name)
  else
    self.skillNameText:SetActive(false)
  end
  self.skillIcon:LoadSprite(heroSkillTemplate.icon)
  local showSkillLevel = self.showSkillLevel
  if showSkillLevel == nil then
    showSkillLevel = true
  end
  if self.showLock then
    UIGray.SetGray(self.skillIcon.transform, true, true)
    self.lockContent:SetActive(true)
  else
    UIGray.SetGray(self.skillIcon.transform, false, true)
    self.lockContent:SetActive(false)
  end
  if showSkillLevel then
    local groupMaxLevel = DataCenter.HeroSkillTemplateManager:GetSkillGroupMaxLevel(heroSkillTemplate.group, _addMaxLevel)
    if groupMaxLevel == _level then
      self.levelText:SetText("max")
    else
      self.levelText:SetText(_level)
    end
  else
  end
  self.redPoint:SetActive(false)
  if self.showStar then
    self.stars:SetActive(true)
    ClearStars(self)
    local curStar = _star
    if 0 < curStar then
      local showStarCount = math.min(curStar, 5)
      local leftWindow = math.max(0, curStar - 5)
      for i = 1, showStarCount do
        local item = self.starTempalte:GameObjectSpawn(self.stars.transform)
        item.name = "star" .. i
        local viewStarIndex = leftWindow + i
        local cell = self.stars:AddComponent(UIHeroSkillStar, item.name)
        cell:SetFilled(true)
        cell:SetStarIndex(viewStarIndex)
      end
    end
    self.curStar = curStar
  else
    self.stars:SetActive(false)
  end
  self.newTag:SetActive(false)
  SetSelected(self, false)
end

local function SetParamsForUniqueWeaponEffect(self, icon, locked)
  self.skillIcon:LoadSprite(icon)
  self.skillNameText:SetActive(false)
  self.redPoint:SetActive(false)
  self.stars:SetActive(false)
  self.newTag:SetActive(false)
  SetSelected(self, false)
  if locked then
    UIGray.SetGray(self.skillIcon.transform, true, true)
    self.lockContent:SetActive(true)
  else
    UIGray.SetGray(self.skillIcon.transform, false, true)
    self.lockContent:SetActive(false)
  end
end

UILWDominatorSkillItemComponent.OnCreate = OnCreate
UILWDominatorSkillItemComponent.OnDestroy = OnDestroy
UILWDominatorSkillItemComponent.OnEnable = OnEnable
UILWDominatorSkillItemComponent.OnDisable = OnDisable
UILWDominatorSkillItemComponent.DataDefine = DataDefine
UILWDominatorSkillItemComponent.DataDestroy = DataDestroy
UILWDominatorSkillItemComponent.ComponentDefine = ComponentDefine
UILWDominatorSkillItemComponent.ComponentDestroy = ComponentDestroy
UILWDominatorSkillItemComponent.SetData = SetData
UILWDominatorSkillItemComponent.OnAddListener = OnAddListener
UILWDominatorSkillItemComponent.OnRemoveListener = OnRemoveListener
UILWDominatorSkillItemComponent.OnItemClick = OnItemClick
UILWDominatorSkillItemComponent.ShowNewTag = ShowNewTag
UILWDominatorSkillItemComponent.HideNewTag = HideNewTag
UILWDominatorSkillItemComponent.GetNewTagShowState = GetNewTagShowState
UILWDominatorSkillItemComponent.ShowNewStarEffect = ShowNewStarEffect
UILWDominatorSkillItemComponent.SetSelected = SetSelected
UILWDominatorSkillItemComponent.GetSelected = GetSelected
UILWDominatorSkillItemComponent.SetTemplateData = SetTemplateData
UILWDominatorSkillItemComponent.GetSkillData = GetSkillData
return UILWDominatorSkillItemComponent
