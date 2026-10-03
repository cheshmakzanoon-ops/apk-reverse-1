local base = UIBaseContainer
local GreenAreaShowCountItem = BaseClass("GreenAreaShowCountItem", base)
local level_path = "levelDes"
local num_path = "num"
local bg_path = ""

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
  self.level = self:AddComponent(UIText, level_path)
  self.num = self:AddComponent(UIText, num_path)
  self.bg = self:AddComponent(UIImage, bg_path)
end

local function ComponentDestroy(self)
  self.level = nil
  self.num = nil
  self.bg = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function GreenAreaShowCountItem:ReInit(index, data, curOpenLevel)
  self.level:SetLocalText("season_oasis_UI_12", data.level)
  if data.open == 1 then
    self.num:SetText(string.format("%0.1f%%", data.greenRate * 100))
  else
    self.num:SetLocalText("season_oasis_UI_13")
  end
  if curOpenLevel == data.level then
    self.level:SetColorRGBA(0.03529412, 0.6078432, 0.2901961, 1)
    self.num:SetColorRGBA(0.03529412, 0.6078432, 0.2901961, 1)
    self.bg:SetColorRGBA(0.8980392, 0.9607843, 0.7529412, 1)
  else
    self.level:SetColorRGBA(0.4509804, 0.4078431, 0.3882353, 1)
    self.num:SetColorRGBA(0.4509804, 0.4078431, 0.3882353, 1)
    self.bg:SetColorRGBA(0.945098, 0.9294118, 0.9215686, 1)
  end
end

GreenAreaShowCountItem.OnCreate = OnCreate
GreenAreaShowCountItem.OnDestroy = OnDestroy
GreenAreaShowCountItem.OnEnable = OnEnable
GreenAreaShowCountItem.OnDisable = OnDisable
GreenAreaShowCountItem.ComponentDefine = ComponentDefine
GreenAreaShowCountItem.ComponentDestroy = ComponentDestroy
GreenAreaShowCountItem.DataDefine = DataDefine
GreenAreaShowCountItem.DataDestroy = DataDestroy
return GreenAreaShowCountItem
