local UIDesertWelcomeItem = BaseClass("UIDesertWelcomeItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function UIDesertWelcomeItem:OnCreate()
  base.OnCreate(self)
end

function UIDesertWelcomeItem:OnDestroy()
  base.OnDestroy(self)
end

function UIDesertWelcomeItem:OnEnable()
  base.OnEnable(self)
end

function UIDesertWelcomeItem:OnDisable()
  base.OnDisable(self)
end

function UIDesertWelcomeItem:ReInit(index, dataConfig, dataServer)
end

function UIDesertWelcomeItem:Update1000MS()
end

return UIDesertWelcomeItem
