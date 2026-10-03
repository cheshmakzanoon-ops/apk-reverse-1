local UICareerTag = BaseClass("UICareerTag", UIBaseContainer)
local base = UIBaseContainer
local this_path = ""
local name_path = "Name"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(BindCallback(self, self.OnClick))
  self.name_text = self:AddComponent(UIText, name_path)
end

local function ComponentDestroy(self)
  self.btn = nil
  self.name_text = nil
end

local function DataDefine(self)
  self.onClick = nil
end

local function DataDestroy(self)
  self.onClick = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, tagInfo)
  self.btn:LoadSprite(HeroUtils.GetQualityBgPath(tagInfo.color))
  self.name_text:SetLocalText(tagInfo.title)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.name_text.transform)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

local function SetOnClick(self, onClick)
  self.onClick = onClick
end

local function OnClick(self)
  if self.onClick then
    self.onClick()
  end
end

UICareerTag.OnCreate = OnCreate
UICareerTag.OnDestroy = OnDestroy
UICareerTag.ComponentDefine = ComponentDefine
UICareerTag.ComponentDestroy = ComponentDestroy
UICareerTag.DataDefine = DataDefine
UICareerTag.DataDestroy = DataDestroy
UICareerTag.OnAddListener = OnAddListener
UICareerTag.OnRemoveListener = OnRemoveListener
UICareerTag.OnEnable = OnEnable
UICareerTag.OnDisable = OnDisable
UICareerTag.SetData = SetData
UICareerTag.SetOnClick = SetOnClick
UICareerTag.OnClick = OnClick
return UICareerTag
