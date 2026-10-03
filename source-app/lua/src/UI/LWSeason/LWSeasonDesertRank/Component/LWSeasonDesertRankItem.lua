local LWSeasonDesertRankItem = BaseClass("LWSeasonDesertRankItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization

function LWSeasonDesertRankItem:OnCreate()
  base.OnCreate(self)
end

function LWSeasonDesertRankItem:OnDestroy()
  base.OnDestroy(self)
end

function LWSeasonDesertRankItem:OnEnable()
  base.OnEnable(self)
end

function LWSeasonDesertRankItem:OnDisable()
  base.OnDisable(self)
end

function LWSeasonDesertRankItem:ReInit(index, dataConfig, dataServer)
end

function LWSeasonDesertRankItem:Update1000MS()
end

return LWSeasonDesertRankItem
