local UICommonResItemBase = require("UI.UICommonResItem.UICommonResItemV2.UICommonResItemBase")
local UICommonResItemPartyMonster = BaseClass("UICommonResItemPartyMonster", UICommonResItemBase)
local base = UICommonResItemBase

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
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  base.DataDefine(self)
end

local function DataDestroy(self)
  base.DataDestroy(self)
end

local function ConvertGiftBoxQuality(quality)
  if quality == 1 or quality == 6 then
    return ItemColor.GREEN
  elseif quality == 2 then
    return ItemColor.BLUE
  elseif quality == 3 then
    return ItemColor.PURPLE
  elseif quality == 4 then
    return ItemColor.ORANGE
  elseif quality == 5 then
    return ItemColor.GOLDEN
  end
end

local function OnReInit(self)
  local template = DataCenter.ActivityPartyMonsterTemplateManager:GetTemplate(self.param.itemId)
  if template then
    self:SetFlagActive(false)
    self:SetItemCountActive(false)
    self:SetItemIconImage(string.format(LoadPath.PartyMonsterSpritePath, template.pic_name))
    self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(self:ConvertGiftBoxQuality(template.quality)))
  end
end

UICommonResItemPartyMonster.OnCreate = OnCreate
UICommonResItemPartyMonster.OnDestroy = OnDestroy
UICommonResItemPartyMonster.ComponentDefine = ComponentDefine
UICommonResItemPartyMonster.ComponentDestroy = ComponentDestroy
UICommonResItemPartyMonster.DataDefine = DataDefine
UICommonResItemPartyMonster.DataDestroy = DataDestroy
UICommonResItemPartyMonster.OnReInit = OnReInit
return UICommonResItemPartyMonster
