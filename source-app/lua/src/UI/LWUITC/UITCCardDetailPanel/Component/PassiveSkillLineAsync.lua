local PassiveSkillLineAsync = BaseClass("PassiveSkillLineAsync", UIAsyncContainer)
local UILWScienceDetailDesc = require("UI.UILWScience.UILWScienceDetail.Component.UILWScienceDetailDesc")
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.name_txt = self:AddComponent(UILWScienceDetailDesc, "content/name_txt")
  self.value_txt = self:AddComponent(UITextMeshProUGUIEx, "content/ValueContainer/ValueText")
  self.arrow_icon = self:AddComponent(UIImage, "content/ValueContainer/ArrowIcon")
  self.nextValue_txt = self:AddComponent(UITextMeshProUGUIEx, "content/ValueContainer/NextValueText")
  self.bg = self:AddComponent(UIImage, "bg")
  self.content_layout = self:AddComponent(UIHorizontalOrVerticalLayoutGroup, "content")
  self.contentNew = self:AddComponent(UITextMeshProUGUIEx, "contentNew")
  self.content = self:AddComponent(UITextMeshProUGUIEx, "content")
  self.fullDesc = self:AddComponent(UILWScienceDetailDesc, "contentNew/fullDesc")
end

local function ComponentDestroy(self)
  self.name_txt = nil
  self.value_txt = nil
  self.bg = nil
  self.bg = nil
  self.content_layout = nil
end

function PassiveSkillLineAsync:UpdateSkill(skillDesc, curVal, nextVal, cardData, containNextValue)
  self.cardData = cardData
  self.skillDesc = skillDesc
  self.curVal = curVal
  self.nextVal = nextVal
  self.containNextValue = containNextValue
  self:RefreshView()
end

function PassiveSkillLineAsync:UpdateData()
  local useNewSkillDesc = self.cardData and self.cardData:IsUseNewSkillDesc()
  if useNewSkillDesc then
    self:UpdateNewDescView()
  else
    self:UpdateOriginView()
  end
  self.contentNew:SetActive(useNewSkillDesc)
  self.content:SetActive(not useNewSkillDesc)
end

function PassiveSkillLineAsync:UpdateNewDescView()
  if self.containNextValue then
    self.fullDesc:SetText(self.cardData:GetBaseSkillUpgradeDesc())
  else
    self.fullDesc:SetText(self.cardData:GetBaseSkillDesc())
  end
end

function PassiveSkillLineAsync:UpdateOriginView()
  self.name_txt:SetText(self.skillDesc)
  self.value_txt:SetText(self.curVal)
  if self.nextVal and self.nextVal ~= self.curVal then
    self.arrow_icon:SetActive(true)
    self.nextValue_txt:SetActive(true)
    self.nextValue_txt:SetText(self.nextVal)
  else
    self.arrow_icon:SetActive(false)
    self.nextValue_txt:SetActive(false)
  end
end

PassiveSkillLineAsync.OnCreate = OnCreate
PassiveSkillLineAsync.OnDestroy = OnDestroy
PassiveSkillLineAsync.ComponentDestroy = ComponentDestroy
PassiveSkillLineAsync.ComponentDefine = ComponentDefine
return PassiveSkillLineAsync
