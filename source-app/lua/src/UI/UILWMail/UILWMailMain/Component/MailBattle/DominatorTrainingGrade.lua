local DominatorTrainingGrade = BaseClass("DominatorTrainingGrade", UIBaseContainer)
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
  self.bg_icon = self:AddComponent(UIImage, "bg_icon")
  self.level_icon = self:AddComponent(UIImage, "level_icon")
  self.name_txt = self:AddComponent(UIText, "name_txt")
end

local function ComponentDestroy(self)
  self.bg_icon = nil
  self.level_icon = nil
  self.name_txt = nil
end

local function SetData(self, groupId, lv, showEmpty)
  local trainTemplate
  if groupId and lv then
    trainTemplate = DataCenter.DominatorTemplateManager:GetTrainLevelTemplateById(groupId + (lv or 0))
  end
  if trainTemplate then
    self:SetActive(true)
    self.level_icon:SetEnable(true)
    self.level_icon:LoadSpriteAuto(trainTemplate:GetNumberIconPath())
    self.name_txt:SetText(trainTemplate:GetColoredName(false))
    local ret, r, g, b, a = trainTemplate:GetQualityImageColorRGBA()
    if ret then
      self.bg_icon:SetColorRGBA255(r, g, b, a)
    else
      self.bg_icon:SetColorRGBA255(1, 1, 1, 0)
    end
  elseif showEmpty then
    self:SetActive(true)
    self.level_icon:SetEnable(false)
    self.name_txt:SetLocalText("dominator_train_rating_desc_6")
    self.bg_icon:SetColorRGBA255(1, 1, 1, 0)
  else
    self:SetActive(false)
  end
end

DominatorTrainingGrade.OnCreate = OnCreate
DominatorTrainingGrade.OnDestroy = OnDestroy
DominatorTrainingGrade.ComponentDefine = ComponentDefine
DominatorTrainingGrade.ComponentDestroy = ComponentDestroy
DominatorTrainingGrade.SetData = SetData
return DominatorTrainingGrade
