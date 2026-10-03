local UIHeroPropertyItem = BaseClass("UIHeroPropertyItem", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIImage, "Bg")
  self.nameText = self:AddComponent(UIText, "Content/Name")
  self.valueText = self:AddComponent(UIText, "Content/Value")
  self.button = self:AddComponent(UIButton, "")
  self.button:SetOnClick(function()
    if self.clickCallBack ~= nil then
      self.clickCallBack(self.transform, self.propertyData.desc)
    end
  end)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.nameText = nil
  self.valueText = nil
  self.button = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
  self.propertyId = nil
  self.propertyName = nil
  self.propertyValue = nil
  self.isCombatProperty = nil
end

local function SetData(self, index, data, clickCallBack)
  if data == nil then
    self:SetActive(false)
    return
  end
  self:SetActive(true)
  self.propertyData = data[1]
  self.propertyName = self.propertyData.name
  self.propertyValue = self.propertyData.value
  self.isCombatProperty = data[2]
  self.index = index
  self.nameText:SetLocalText(self.propertyName)
  self.valueText:SetText(self.propertyValue)
  if self.isCombatProperty then
    self.valueText:SetColorRGBA(1, 1, 1, 1)
  else
    self.valueText:SetColorRGBA(0.996, 0.9098, 0.7373, 1)
  end
  if self.index % 2 == 0 then
    self.bg:SetActive(false)
  else
    self.bg:SetActive(true)
  end
  self.clickCallBack = clickCallBack
end

UIHeroPropertyItem.OnCreate = OnCreate
UIHeroPropertyItem.OnDestroy = OnDestroy
UIHeroPropertyItem.OnEnable = OnEnable
UIHeroPropertyItem.OnDisable = OnDisable
UIHeroPropertyItem.ComponentDefine = ComponentDefine
UIHeroPropertyItem.ComponentDestroy = ComponentDestroy
UIHeroPropertyItem.DataDefine = DataDefine
UIHeroPropertyItem.DataDestroy = DataDestroy
UIHeroPropertyItem.SetData = SetData
return UIHeroPropertyItem
