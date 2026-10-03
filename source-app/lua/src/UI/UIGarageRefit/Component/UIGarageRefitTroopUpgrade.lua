local UIGarageRefitTroopUpgrade = BaseClass("UIGarageRefitTroopUpgrade", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local title_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local next_path = "UICommonRewardPopUp/Panel"
local left_path = "Root/LeftVal"
local right_path = "Root/RightVal"
local desc_path = "Root/Desc"
local level_path = "Root/UIGarageRefitItem/Level"

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
  self.title_text = self:AddComponent(UIText, title_path)
  self.title_text:SetLocalText(120062)
  self.next_btn = self:AddComponent(UIButton, next_path)
  self.next_btn:SetOnClick(function()
    self:Next()
  end)
  self.left_text = self:AddComponent(UIText, left_path)
  self.right_text = self:AddComponent(UIText, right_path)
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.level_text = self:AddComponent(UIText, level_path)
end

local function ComponentDestroy(self)
  self.title_text = nil
  self.next_btn = nil
  self.left_text = nil
  self.right_text = nil
  self.desc_text = nil
  self.level_text = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function SetData(self, leftTemplate, rightTemplate, garageIndex)
  local leftEffect, leftVal, leftEffectDesc, rightEffect, rightVal, rightEffectDesc
  if leftTemplate then
    leftEffect, leftVal = leftTemplate:GetAdditionalEffect()
    leftEffectDesc = GetTableData(TableName.EffectNumDesc, leftEffect, "des")
  end
  if rightTemplate then
    rightEffect, rightVal = rightTemplate:GetAdditionalEffect()
    rightEffectDesc = GetTableData(TableName.EffectNumDesc, rightEffect, "des")
  end
  if leftEffect ~= nil then
    self.left_text:SetActive(true)
    self.left_text:SetText(Localization:GetString(leftEffectDesc) .. " +" .. string.GetFormattedSeperatorNum(leftVal))
  else
    self.left_text:SetActive(false)
  end
  if rightEffect ~= nil then
    self.right_text:SetActive(true)
    self.right_text:SetText(Localization:GetString(rightEffectDesc) .. " +" .. string.GetFormattedSeperatorNum(rightVal))
  else
    self.right_text:SetActive(false)
  end
  self.desc_text:SetLocalText(140407, garageIndex, rightTemplate.level)
  self.level_text:SetText("Lv." .. rightTemplate.level)
end

local function Next(self)
  self:SetActive(false)
end

UIGarageRefitTroopUpgrade.OnCreate = OnCreate
UIGarageRefitTroopUpgrade.OnDestroy = OnDestroy
UIGarageRefitTroopUpgrade.ComponentDefine = ComponentDefine
UIGarageRefitTroopUpgrade.ComponentDestroy = ComponentDestroy
UIGarageRefitTroopUpgrade.DataDefine = DataDefine
UIGarageRefitTroopUpgrade.DataDestroy = DataDestroy
UIGarageRefitTroopUpgrade.OnEnable = OnEnable
UIGarageRefitTroopUpgrade.OnDisable = OnDisable
UIGarageRefitTroopUpgrade.SetData = SetData
UIGarageRefitTroopUpgrade.Next = Next
return UIGarageRefitTroopUpgrade
