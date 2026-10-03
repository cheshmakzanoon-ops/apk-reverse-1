local UITalentInfoTitle = BaseClass("UITalentInfoTitle", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.typeText = self:AddComponent(UIText, "TypeText")
  self.numText = self:AddComponent(UIText, "NumText")
end

local function ComponentDestroy(self)
end

local function SetData(self, data)
  self.typeText:SetLocalText(data.name)
  self.numText:SetLocalText(150033, data.openNum, data.totalNum)
end

UITalentInfoTitle.OnCreate = OnCreate
UITalentInfoTitle.OnDestroy = OnDestroy
UITalentInfoTitle.ComponentDefine = ComponentDefine
UITalentInfoTitle.ComponentDestroy = ComponentDestroy
UITalentInfoTitle.SetData = SetData
return UITalentInfoTitle
