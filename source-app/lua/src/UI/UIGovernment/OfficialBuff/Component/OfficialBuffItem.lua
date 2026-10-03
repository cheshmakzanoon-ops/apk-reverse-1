local OfficialBuffItem = BaseClass("OfficialBuffItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function OfficialBuffItem:OnCreate()
  base.OnCreate(self)
end

function OfficialBuffItem:OnDestroy()
  base.OnDestroy(self)
end

function OfficialBuffItem:OnEnable()
  base.OnEnable(self)
end

function OfficialBuffItem:OnDisable()
  base.OnDisable(self)
end

function OfficialBuffItem:ReInit(index, dataConfig, dataServer)
end

function OfficialBuffItem:Update1000MS()
end

return OfficialBuffItem
