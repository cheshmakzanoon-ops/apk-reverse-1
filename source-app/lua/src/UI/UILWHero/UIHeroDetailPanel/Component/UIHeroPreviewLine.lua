local UIHeroPreviewLine = BaseClass("UIHeroPreviewLine", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray

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
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self.active = true
end

local function OnDisable(self)
  base.OnDisable(self)
  self.active = false
end

local function ComponentDefine(self)
  self.nameText = self:AddComponent(UITextMeshProUGUIEx, "Content/NameText")
  self.valueText = self:AddComponent(UITextMeshProUGUIEx, "Content/ValueContainer/ValueText")
  self.arrowIcon = self:AddComponent(UIImage, "Content/ValueContainer/ArrowIcon")
  self.nextValueText = self:AddComponent(UITextMeshProUGUIEx, "Content/ValueContainer/NextValueText")
  self.bg = self:TryAddComponent(UIImage, "Bg")
end

local function ComponentDestroy(self)
  self.nameText = nil
  self.valueText = nil
  self.arrowIcon = nil
  self.nextValueText = nil
end

local function SetName(self, name)
  self.nameText:SetLocalText(name)
end

local function SetData(self, value, nextValue, index)
  if not string.IsNullOrEmpty(value) then
    self.valueText:SetText(value)
    self.valueText:SetActive(true)
  else
    self.valueText:SetActive(false)
  end
  if not string.IsNullOrEmpty(nextValue) then
    self.nextValueText:SetText(nextValue)
    self.nextValueText:SetActive(true)
    self.arrowIcon:SetActive(not string.IsNullOrEmpty(value))
  else
    self.arrowIcon:SetActive(false)
    self.nextValueText:SetActive(false)
  end
  if index and self.bg then
    self.bg:SetActive(index % 2 == 0)
  end
end

UIHeroPreviewLine.OnCreate = OnCreate
UIHeroPreviewLine.OnDestroy = OnDestroy
UIHeroPreviewLine.OnEnable = OnEnable
UIHeroPreviewLine.OnDisable = OnDisable
UIHeroPreviewLine.DataDefine = DataDefine
UIHeroPreviewLine.DataDestroy = DataDestroy
UIHeroPreviewLine.ComponentDefine = ComponentDefine
UIHeroPreviewLine.ComponentDestroy = ComponentDestroy
UIHeroPreviewLine.SetName = SetName
UIHeroPreviewLine.SetData = SetData
return UIHeroPreviewLine
