local base = UIBaseContainer
local BankInterestItem = BaseClass("BankInterestItem", base)
local bg_path = "bg"
local icon1_path = "bg/icon1"
local icon2_path = "bg/icon2"
local icon3_path = "bg/icon3"
local icon4_path = "bg/icon4"
local level_path = "level"
local value1_path = "value1"
local value2_path = "value2"
local value3_path = "value3"
local colorNormal = Color.New(0.945098, 0.9176471, 0.9058824, 1)
local colorNormal2 = Color.New(0, 0, 0, 0)
local colorLight = Color.New(0.9960784, 0.8862745, 0.7333333, 1)

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIBaseContainer, bg_path)
  self.icon1 = self:AddComponent(UIImage, icon1_path)
  self.icon2 = self:AddComponent(UIImage, icon2_path)
  self.icon3 = self:AddComponent(UIImage, icon3_path)
  self.icon4 = self:AddComponent(UIImage, icon4_path)
  self.level = self:AddComponent(UIText, level_path)
  self.value1 = self:AddComponent(UIText, value1_path)
  self.value2 = self:AddComponent(UIText, value2_path)
  self.value3 = self:AddComponent(UIText, value3_path)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.icon1 = nil
  self.icon2 = nil
  self.icon3 = nil
  self.icon4 = nil
  self.level = nil
  self.value1 = nil
  self.value2 = nil
  self.value3 = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function BankInterestItem:ReInit(data, index, level)
  self.level:SetText(data.level)
  for i, v in ipairs(data.interest) do
    local txt = self["value" .. i]
    if not txt then
      break
    end
    txt:SetText(string.format("%0.f%%", v * 100))
  end
  local color = colorNormal
  if level == data.level then
    color = colorLight
  elseif index % 2 == 1 then
    color = colorNormal2
  end
  for i = 1, 4 do
    self[string.format("icon%s", i)]:SetColor(color)
  end
end

BankInterestItem.OnCreate = OnCreate
BankInterestItem.OnDestroy = OnDestroy
BankInterestItem.OnEnable = OnEnable
BankInterestItem.OnDisable = OnDisable
BankInterestItem.ComponentDefine = ComponentDefine
BankInterestItem.ComponentDestroy = ComponentDestroy
BankInterestItem.DataDefine = DataDefine
BankInterestItem.DataDestroy = DataDestroy
return BankInterestItem
