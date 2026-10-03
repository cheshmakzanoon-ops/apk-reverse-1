local UIHeroSkillItem = BaseClass("UIHeroSkillItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local activeStateIconPath = "ActiveIcon"
local deactiveStateIconPath = "DeactiveIcon"

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
  self.type = nil
  self.activeState = false
end

local function DataDestroy(self)
  self.type = nil
  self.activeState = false
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function OnClick(self)
  if self.clickCallBack ~= nil and self.type ~= nil then
    self.clickCallBack(self.type)
  end
end

local function ComponentDefine(self)
  self.activeStateIcon = self:AddComponent(UIImage, activeStateIconPath)
  self.deactiveStateIcon = self:AddComponent(UIImage, deactiveStateIconPath)
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(BindCallback(self, OnClick))
end

local function ComponentDestroy(self)
  self.activeStateIcon = nil
  self.deactiveStateIcon = nil
  self.btn = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function SetType(self, type)
  self.type = type
end

local function SetClickCallBack(self, callBack)
  self.clickCallBack = callBack
end

local function SetActiveState(self, activeState)
  self.activeState = activeState
  if self.activeState then
    self.activeStateIcon:SetActive(true)
    self.deactiveStateIcon:SetActive(false)
  else
    self.activeStateIcon:SetActive(false)
    self.deactiveStateIcon:SetActive(true)
  end
end

UIHeroSkillItem.OnCreate = OnCreate
UIHeroSkillItem.OnDestroy = OnDestroy
UIHeroSkillItem.OnEnable = OnEnable
UIHeroSkillItem.OnDisable = OnDisable
UIHeroSkillItem.DataDefine = DataDefine
UIHeroSkillItem.DataDestroy = DataDestroy
UIHeroSkillItem.ComponentDefine = ComponentDefine
UIHeroSkillItem.ComponentDestroy = ComponentDestroy
UIHeroSkillItem.SetActiveState = SetActiveState
UIHeroSkillItem.OnAddListener = OnAddListener
UIHeroSkillItem.OnRemoveListener = OnRemoveListener
UIHeroSkillItem.SetType = SetType
UIHeroSkillItem.SetClickCallBack = SetClickCallBack
return UIHeroSkillItem
