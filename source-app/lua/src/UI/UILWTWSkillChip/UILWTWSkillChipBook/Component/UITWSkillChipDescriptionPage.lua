local UITWSkillChipDescriptionPage = BaseClass("UITWSkillChipDescriptionPage", UIBaseContainer)
local base = UIBaseContainer

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
  self.image = self:AddComponent(UIRawImage, "image")
  self.text = self:AddComponent(UIText, "descText")
end

local function ComponentDestroy(self)
end

local function SetData(self, text, imgPath)
  self.image:LoadSprite(imgPath)
  self.text:SetLocalText(text)
end

UITWSkillChipDescriptionPage.OnCreate = OnCreate
UITWSkillChipDescriptionPage.OnDestroy = OnDestroy
UITWSkillChipDescriptionPage.OnEnable = OnEnable
UITWSkillChipDescriptionPage.OnDisable = OnDisable
UITWSkillChipDescriptionPage.DataDefine = DataDefine
UITWSkillChipDescriptionPage.DataDestroy = DataDestroy
UITWSkillChipDescriptionPage.ComponentDefine = ComponentDefine
UITWSkillChipDescriptionPage.ComponentDestroy = ComponentDestroy
UITWSkillChipDescriptionPage.SetData = SetData
return UITWSkillChipDescriptionPage
