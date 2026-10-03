local LWCivilizationSparkTemplate = BaseClass("LWCivilizationSparkTemplate")

function LWCivilizationSparkTemplate:__init()
  self.id = 0
  self.level = 1
  self.upgradeNeed = nil
  self.triggerList = nil
  self.soldierLimitUp = 0
  self.buffDesc = nil
  self.uiTitleImg = nil
  self.uiItemImg = nil
  self.animationDelay = 0
end

function LWCivilizationSparkTemplate:__delete()
  self.id = nil
  self.level = nil
  self.upgradeNeed = nil
  self.triggerList = nil
  self.soldierLimitUp = nil
  self.buffDesc = nil
  self.uiTitleImg = nil
  self.uiItemImg = nil
  self.animationDelay = nil
end

function LWCivilizationSparkTemplate:InitData(cfg)
  if cfg == nil then
    return
  end
  self.id = cfg:getValue("id")
  self.level = cfg:getValue("level")
  self.upgradeNeed = cfg:getValue("upgrade_need")
  self.triggerList = cfg:getValue("trigger")
  self.soldierLimitUp = cfg:getValue("soldier_limit_up") or 0
  self.buffDesc = cfg:getValue("buff_desc")
  local uiTitleImg = cfg:getValue("UI_title_img")
  if not string.IsNullOrEmpty(uiTitleImg) then
    self.uiTitleImg = string.format(UIAssets.UICivilizationSparkTexturePath, uiTitleImg)
  end
  local uiItemImg = cfg:getValue("UI_item_img")
  if not string.IsNullOrEmpty(uiItemImg) then
    self.uiItemImg = string.format(UIAssets.UICivilizationSparkTexturePath, uiItemImg)
  end
  self.animationDelay = cfg:getValue("animation_delay") or 0
end

return LWCivilizationSparkTemplate
