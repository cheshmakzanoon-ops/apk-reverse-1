local UIGiftTypeButton = BaseClass("UIGiftTypeButton", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Param = DataClass("Param", ParamData)
local ParamData = {
  welfare_data,
  callBack,
  needClick,
  index,
  redDotNum
}
local type_text_path = "TypeButtonText"
local this_path = ""
local red_dot_path = "RedDot"
local red_dot_text_path = "RedDot/RedDotText"
local NewDot_path = "NewDot"

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

local function ComponentDefine(self)
  self.type_text = self:AddComponent(UIText, type_text_path)
  self.btn = self:AddComponent(UIButton, this_path)
  self.btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnClick()
  end)
  self.red_dot_go = self:AddComponent(UIBaseContainer, red_dot_path)
  self.red_dot_text = self:AddComponent(UIText, red_dot_text_path)
  self.NewDot = self:AddComponent(UIBaseContainer, NewDot_path)
end

local function ComponentDestroy(self)
  self.type_text = nil
  self.btn = nil
  self.red_dot_go = nil
  self.red_dot_text = nil
  self.NewDot = nil
end

local function DataDefine(self)
  self.typeText = nil
  self.typeColor = nil
end

local function DataDestroy(self)
  self.typeText = nil
  self.typeColor = nil
end

local function ReInit(self, ...)
  self.param = (...)
  if self.param == nil then
    self.gameObject:SetActive(false)
    return
  end
  self:Refresh()
  if self.param.needClick then
    self:SetSelect(true)
    self:OnClick()
  else
    self:SetSelect(false)
  end
end

local function Refresh(self)
  local _name = self.param.welfare_data:getName()
  _name = Localization:GetString(_name)
  self:SetTypeText(_name)
  self:SetRedDot(self.param.redDotNum, self.param.newFlag)
end

local function OnClick(self)
  if self.param.callBack ~= nil then
    self.param.callBack(self.transform, self.param.welfare_data:getType(), self.param.welfare_data:getID(), self.param.index)
  end
end

local function SetTypeText(self, value)
  if self.typeText ~= value then
    self.typeText = value
    self.type_text:SetText(value)
  end
end

local function SetTypeColor(self, value)
  if self.typeColor ~= value then
    self.typeColor = value
    self.type_text:SetColor(value)
  end
end

local TouchColor = Color32.New(1.0, 1.0, 1.0, 1)
local OriginColor = Color32.New(1.0, 0.8901960784313725, 0.792156862745098, 1)

local function SetSelect(self, value)
  if value then
    self:SetTypeColor(TouchColor)
    self.type_text.transform:Set_localScale(1.16, 1.16, 1.16)
  else
    self:SetTypeColor(OriginColor)
    self.type_text.transform:Set_localScale(1, 1, 1)
  end
end

local function SetRedDot(self, redDotNum, newFlag)
  self.NewDot:SetActive(newFlag ~= nil)
  if redDotNum == nil or redDotNum == 0 or newFlag ~= nil then
    self.red_dot_go:SetActive(false)
  else
    self.red_dot_go:SetActive(true)
    self.red_dot_text:SetText(redDotNum)
  end
end

UIGiftTypeButton.OnDestroy = OnDestroy
UIGiftTypeButton.OnCreate = OnCreate
UIGiftTypeButton.OnClick = OnClick
UIGiftTypeButton.Refresh = Refresh
UIGiftTypeButton.ReInit = ReInit
UIGiftTypeButton.Param = Param
UIGiftTypeButton.ComponentDefine = ComponentDefine
UIGiftTypeButton.ComponentDestroy = ComponentDestroy
UIGiftTypeButton.DataDefine = DataDefine
UIGiftTypeButton.DataDestroy = DataDestroy
UIGiftTypeButton.SetTypeText = SetTypeText
UIGiftTypeButton.SetSelect = SetSelect
UIGiftTypeButton.SetTypeColor = SetTypeColor
UIGiftTypeButton.SetRedDot = SetRedDot
return UIGiftTypeButton
