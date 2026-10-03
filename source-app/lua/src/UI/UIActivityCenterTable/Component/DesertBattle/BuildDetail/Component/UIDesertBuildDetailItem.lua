local UIDesertBuildDetailItem = BaseClass("UIDesertBuildDetailItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function UIDesertBuildDetailItem:OnCreate()
  base.OnCreate(self)
end

function UIDesertBuildDetailItem:OnDestroy()
  base.OnDestroy(self)
end

function UIDesertBuildDetailItem:OnEnable()
  base.OnEnable(self)
end

function UIDesertBuildDetailItem:OnDisable()
  base.OnDisable(self)
end

function UIDesertBuildDetailItem:ReInit(index, dataConfig, dataServer)
end

function UIDesertBuildDetailItem:Update1000MS()
end

return UIDesertBuildDetailItem
