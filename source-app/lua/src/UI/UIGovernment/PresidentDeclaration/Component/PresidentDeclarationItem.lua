local PresidentDeclarationItem = BaseClass("PresidentDeclarationItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function PresidentDeclarationItem:OnCreate()
  base.OnCreate(self)
end

function PresidentDeclarationItem:OnDestroy()
  base.OnDestroy(self)
end

function PresidentDeclarationItem:OnEnable()
  base.OnEnable(self)
end

function PresidentDeclarationItem:OnDisable()
  base.OnDisable(self)
end

function PresidentDeclarationItem:ReInit(index, dataConfig, dataServer)
end

function PresidentDeclarationItem:Update1000MS()
end

return PresidentDeclarationItem
