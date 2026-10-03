local UITWSkillDetailDesc = BaseClass("UITWSkillDetailDesc", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIGray = CS.UIGray
local UITWSkillEffectLine = require("UI.UILWTacticalWeaponSkillDetail.Component.UITWSkillEffectLine")
local skill_desc_text_path = "SkillDescText"
local content_path = "DescLayout/Viewport/Content"
local next_effect_value_line_path = "DescLayout/Viewport/Content/NextEffectValueLine"
local desc_layout_path = "DescLayout"
local seperateLine_path = "SeperateLine"

local function OnCreate(self)
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ClearLines()
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
  self.skill_desc_text = self:AddComponent(UIText, skill_desc_text_path)
  self.skill_desc_layout = self:AddComponent(UILayoutElement, skill_desc_text_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.next_effect_value_line = self.transform:Find(next_effect_value_line_path).gameObject
  self.next_effect_value_line:GameObjectCreatePool()
  self:ResetDescText()
  self.effect_scroll = self:AddComponent(UIScrollRect, desc_layout_path)
  self.seperateLine = self:AddComponent(UIBaseContainer, seperateLine_path)
end

local function ClearLines(self)
  if self.next_effect_value_line then
    self.content:RemoveComponents(UITWSkillEffectLine)
    self.next_effect_value_line:GameObjectRecycleAll()
  end
  self.lines = {}
end

local function ComponentDestroy(self)
end

local function SetMaxHeight(self, height)
  self.descMaxHeight = height
end

local function ResetDescText(self)
  self.skill_desc_layout:SetEnable(true)
  self.skill_desc_text:SetBestFitEnable(false)
end

local function SetData(self, descText, effectLines, index)
  self.skill_desc_text:SetText(descText)
  if self.descMaxHeight then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
    local textHeight = self.skill_desc_text:GetHeight()
    if textHeight > self.descMaxHeight then
      self.skill_desc_layout:SetEnable(false)
      self.skill_desc_text:SetBestFitEnable(true)
      self.skill_desc_layout:SetPreferredHeight(self.descMaxHeight)
    else
      self.skill_desc_layout:SetEnable(true)
      self.skill_desc_text:SetBestFitEnable(false)
    end
  end
  self:ClearLines()
  if not table.IsNullOrEmpty(effectLines) then
    self.seperateLine:SetActive(true)
    for i = 1, #effectLines do
      self.content:SetActive(true)
      local item = self.next_effect_value_line:GameObjectSpawn(self.content.transform)
      item.name = "item" .. i
      local cell = self.content:AddComponent(UITWSkillEffectLine, item.name)
      cell:SetData(effectLines[i].isUnlock, effectLines[i].outDesc, i)
      table.insert(self.lines, cell)
    end
    if index then
      if index < 1 then
        index = 1
      elseif index > #self.lines then
        index = #self.lines
      end
      CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
      local contentSizeY = self.content.rectTransform.rect.size.y
      local progress = 0
      if 1 < index and index < #self.lines then
        local itemPosY = self.lines[index]:GetAnchoredPositionY()
        progress = 1 - -itemPosY / contentSizeY
      elseif index == 1 then
        progress = 1
      elseif index == #self.lines then
        progress = 0
      end
      self.effect_scroll:StopMovement()
      self.effect_scroll:SetVerticalNormalizedPosition(progress)
    end
  else
    self.content:SetActive(false)
    self.seperateLine:SetActive(false)
  end
end

local function ShowWillUnlockEffect(self, index, lockDesc, unlockDesc)
  if self.lines and self.lines[index] then
    self.lines[index]:ShowWillUnlockEffect(lockDesc, unlockDesc)
  end
end

UITWSkillDetailDesc.OnCreate = OnCreate
UITWSkillDetailDesc.OnDestroy = OnDestroy
UITWSkillDetailDesc.OnEnable = OnEnable
UITWSkillDetailDesc.OnDisable = OnDisable
UITWSkillDetailDesc.DataDefine = DataDefine
UITWSkillDetailDesc.DataDestroy = DataDestroy
UITWSkillDetailDesc.ComponentDefine = ComponentDefine
UITWSkillDetailDesc.ComponentDestroy = ComponentDestroy
UITWSkillDetailDesc.SetData = SetData
UITWSkillDetailDesc.ClearLines = ClearLines
UITWSkillDetailDesc.SetMaxHeight = SetMaxHeight
UITWSkillDetailDesc.ResetDescText = ResetDescText
UITWSkillDetailDesc.ShowWillUnlockEffect = ShowWillUnlockEffect
return UITWSkillDetailDesc
