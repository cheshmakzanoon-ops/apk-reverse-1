local UILWPowerBatteryItem = BaseClass("UILWPowerBatteryItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function UILWPowerBatteryItem:OnCreate()
  base.OnCreate(self)
end

function UILWPowerBatteryItem:OnDestroy()
  base.OnDestroy(self)
end

function UILWPowerBatteryItem:OnEnable()
  base.OnEnable(self)
end

function UILWPowerBatteryItem:OnDisable()
  base.OnDisable(self)
end

function UILWPowerBatteryItem:ReInit(index, dataConfig, dataServer)
end

function UILWPowerBatteryItem:Update1000MS()
end

return UILWPowerBatteryItem
