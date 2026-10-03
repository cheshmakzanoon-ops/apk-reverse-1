local base = UIBaseContainer
local TradeTitleItem = BaseClass("TradeTitleItem", base)
local bg_path = ""
local icon_path = "TitileIcon"
local level_path = "Titlelevel"
local name_path = "TitleName"

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
  self.bg = self:AddComponent(UIImage, bg_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.level = self:AddComponent(UIText, level_path)
  self.name = self:AddComponent(UIText, name_path)
end

local function ComponentDestroy(self)
  self.bg = nil
  self.icon = nil
  self.level = nil
  self.name = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

function TradeTitleItem:ReInit(index, titleId, selfTemp)
  local conf = titleId and DataCenter.PlayerTitleTemplateManager:GetTitleInfo(titleId)
  if not conf then
    return
  end
  self.level:SetText(index)
  self.name:SetLocalText(conf.name)
  self.icon:LoadSprite(conf.title_show_icon)
  if selfTemp and selfTemp.id == conf.id then
    self.bg:SetColorRGBA(0.8666667, 0.9490197, 0.7294118, 1)
    self.level:SetColorRGBA(0.03529412, 0.6078432, 0.2901961, 1)
    self.name:SetColorRGBA(0.03529412, 0.6078432, 0.2901961, 1)
  elseif index % 2 == 0 then
    self.bg:SetColorRGBA(0.8901961, 0.8588236, 0.8431373, 1)
    self.level:SetColorRGBA(0.1647059, 0.1568628, 0.1882353, 1)
    self.name:SetColorRGBA(0.1647059, 0.1568628, 0.1882353, 1)
  else
    self.bg:SetColorRGBA(0.9137256, 0.8862746, 0.8745099, 1)
    self.level:SetColorRGBA(0.1647059, 0.1568628, 0.1882353, 1)
    self.name:SetColorRGBA(0.1647059, 0.1568628, 0.1882353, 1)
  end
end

TradeTitleItem.OnCreate = OnCreate
TradeTitleItem.OnDestroy = OnDestroy
TradeTitleItem.OnEnable = OnEnable
TradeTitleItem.OnDisable = OnDisable
TradeTitleItem.ComponentDefine = ComponentDefine
TradeTitleItem.ComponentDestroy = ComponentDestroy
TradeTitleItem.DataDefine = DataDefine
TradeTitleItem.DataDestroy = DataDestroy
return TradeTitleItem
