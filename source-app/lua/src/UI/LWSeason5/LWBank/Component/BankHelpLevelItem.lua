local base = UIBaseContainer
local BankHelpLevelItem = BaseClass("BankHelpLevelItem", base)
local bg_path = "bg"
local icon1_path = "bg/icon1"
local icon2_path = "bg/icon2"
local icon3_path = "bg/icon3"
local icon4_path = "bg/icon4"
local icon5_path = "bg/icon5"
local level_path = "level"
local default_path = "default"
local limitTotal_path = "limitTotal"
local limitSingle_path = "limitSingle"
local limitCount_path = "limitCount"
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
  self.icon5 = self:AddComponent(UIImage, icon5_path)
  self.level = self:AddComponent(UIText, level_path)
  self.default = self:AddComponent(UIText, default_path)
  self.limitTotal = self:AddComponent(UIText, limitTotal_path)
  self.limitSingle = self:AddComponent(UIText, limitSingle_path)
  self.limitCount = self:AddComponent(UIText, limitCount_path)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.icon1 = nil
  self.icon2 = nil
  self.icon3 = nil
  self.icon4 = nil
  self.icon5 = nil
  self.level = nil
  self.default = nil
  self.limitTotal = nil
  self.limitSingle = nil
  self.limitCount = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function BankHelpLevelItem:ReInit(data, index, level)
  self.level:SetText(data.level)
  self.default:SetText(data.default_asset)
  self.limitTotal:SetText(data.max_asset)
  self.limitSingle:SetText(data.max_into_asset)
  self.limitCount:SetText(data.max_player)
  local color = colorNormal
  if level == data.level then
    color = colorLight
  elseif index % 2 == 1 then
    color = colorNormal2
  end
  for i = 1, 5 do
    self[string.format("icon%s", i)]:SetColor(color)
  end
end

BankHelpLevelItem.OnCreate = OnCreate
BankHelpLevelItem.OnDestroy = OnDestroy
BankHelpLevelItem.OnEnable = OnEnable
BankHelpLevelItem.OnDisable = OnDisable
BankHelpLevelItem.ComponentDefine = ComponentDefine
BankHelpLevelItem.ComponentDestroy = ComponentDestroy
BankHelpLevelItem.DataDefine = DataDefine
BankHelpLevelItem.DataDestroy = DataDestroy
return BankHelpLevelItem
