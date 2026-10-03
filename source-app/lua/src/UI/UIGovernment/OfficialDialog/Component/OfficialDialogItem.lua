local OfficialDialogItem = BaseClass("OfficialDialogItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function OfficialDialogItem:OnCreate()
  base.OnCreate(self)
end

function OfficialDialogItem:OnDestroy()
  base.OnDestroy(self)
end

function OfficialDialogItem:OnEnable()
  base.OnEnable(self)
end

function OfficialDialogItem:OnDisable()
  base.OnDisable(self)
end

function OfficialDialogItem:ReInit(index, dataConfig, dataServer)
end

function OfficialDialogItem:Update1000MS()
end

return OfficialDialogItem
