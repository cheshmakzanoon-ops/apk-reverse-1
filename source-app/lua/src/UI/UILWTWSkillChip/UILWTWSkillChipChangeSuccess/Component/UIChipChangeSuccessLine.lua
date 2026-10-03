local UIChipChangeSuccessLine = BaseClass("UIChipChangeSuccessLine", UIBaseContainer)
local base = UIBaseContainer
local desc_path = "Desc"
local desc1_path = "Desc1"
local left_val_path = "RightGo/LeftVal"
local right_val_path = "RightGo/RightVal"
local right_val1_path = "RightVal1"
local arrow_path = "RightGo/Arrow"
local specialIcon_path = "SpecialIcon"

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
  self.desc_text = self:AddComponent(UIText, desc_path)
  self.desc1_text = self:AddComponent(UIText, desc1_path)
  self.arrow = self:AddComponent(UIImage, arrow_path)
  self.left_val_text = self:AddComponent(UIText, left_val_path)
  self.right_val_text = self:AddComponent(UIText, right_val_path)
  self.right_val1_text = self:AddComponent(UIText, right_val1_path)
  self.specialIcon = self:AddComponent(UIImage, specialIcon_path)
end

local function ComponentDestroy(self)
  self.desc_text = nil
  self.left_val_text = nil
  self.right_val_text = nil
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

local function SetData(self, id, leftVal, rightVal)
  self.desc_text:SetActive(false)
  self.desc1_text:SetActive(false)
  self.arrow:SetActive(false)
  self.left_val_text:SetActive(false)
  self.right_val_text:SetActive(false)
  self.right_val1_text:SetActive(false)
  self.specialIcon:SetActive(false)
  if leftVal == nil then
    self.desc1_text:SetLocalText(HeroUtils.GetHeroPropertyNameId(id))
    self.right_val1_text:SetText(HeroUtils.GetFormattedPropertyValue(id, rightVal))
    self.desc1_text:SetActive(true)
    self.right_val1_text:SetActive(true)
    self.desc1_text.transform:Set_anchoredPosition(0, 0)
  else
    self.desc_text:SetActive(true)
    self.arrow:SetActive(true)
    self.left_val_text:SetActive(true)
    self.right_val_text:SetActive(true)
    self.desc_text:SetLocalText(HeroUtils.GetHeroPropertyNameId(id))
    self.left_val_text:SetText(HeroUtils.GetFormattedPropertyValue(id, leftVal))
    self.right_val_text:SetText(HeroUtils.GetFormattedPropertyValue(id, rightVal))
    self.right_val_text:SetColor(leftVal == rightVal and WhiteColor or AttributeGreen)
    self.desc_text.transform:Set_anchoredPosition(0, 0)
  end
end

UIChipChangeSuccessLine.OnCreate = OnCreate
UIChipChangeSuccessLine.OnDestroy = OnDestroy
UIChipChangeSuccessLine.ComponentDefine = ComponentDefine
UIChipChangeSuccessLine.ComponentDestroy = ComponentDestroy
UIChipChangeSuccessLine.DataDefine = DataDefine
UIChipChangeSuccessLine.DataDestroy = DataDestroy
UIChipChangeSuccessLine.OnEnable = OnEnable
UIChipChangeSuccessLine.OnDisable = OnDisable
UIChipChangeSuccessLine.SetData = SetData
return UIChipChangeSuccessLine
