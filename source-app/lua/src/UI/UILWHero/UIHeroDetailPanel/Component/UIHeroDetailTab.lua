local UIHeroDetailTab = BaseClass("UIHeroDetailTab", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
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
  self.selectedBg = self:AddComponent(UIImage, "SelectedBg")
  self.unselectedBg = self:AddComponent(UIImage, "UnselectedBg")
  self.nameText = self:AddComponent(UIText, "Text")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnClick()
  end)
end

local function ComponentDestroy(self)
  self.selectedBg = nil
  self.unselectedBg = nil
  self.nameText = nil
  self.btn = nil
end

local function SetData(self, nameId, index, callback)
  self.index = index
  self.nameText:SetLocalText(nameId)
  self.data = data
  self.callback = callback
end

local function OnClick(self)
  if self.callback ~= nil then
    self.callback(self.index)
  end
end

local function SetSelectedState(self, selected)
  self.selectedBg.gameObject:SetActive(selected)
  self.unselectedBg.gameObject:SetActive(not selected)
end

UIHeroDetailTab.OnCreate = OnCreate
UIHeroDetailTab.OnDestroy = OnDestroy
UIHeroDetailTab.OnEnable = OnEnable
UIHeroDetailTab.OnDisable = OnDisable
UIHeroDetailTab.ComponentDefine = ComponentDefine
UIHeroDetailTab.ComponentDestroy = ComponentDestroy
UIHeroDetailTab.SetData = SetData
UIHeroDetailTab.OnClick = OnClick
UIHeroDetailTab.SetSelectedState = SetSelectedState
return UIHeroDetailTab
