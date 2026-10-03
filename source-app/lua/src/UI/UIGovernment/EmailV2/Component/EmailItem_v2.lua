local EmailItem = BaseClass("EmailItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function EmailItem:OnCreate()
  base.OnCreate(self)
end

function EmailItem:OnDestroy()
  base.OnDestroy(self)
end

function EmailItem:OnEnable()
  base.OnEnable(self)
end

function EmailItem:OnDisable()
  base.OnDisable(self)
end

function EmailItem:ReInit(index, dataConfig, dataServer)
end

function EmailItem:Update1000MS()
end

return EmailItem
