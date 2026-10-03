local UIArenaNewbieRankItemSegment = BaseClass("UIArenaNewbieRankItemSegment", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "txtRank",
    name = "txtRank",
    type = UIText
  }
}

function UIArenaNewbieRankItemSegment:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIArenaNewbieRankItemSegment:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIArenaNewbieRankItemSegment:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function UIArenaNewbieRankItemSegment:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UIArenaNewbieRankItemSegment:Refresh(segCfg)
  self.txtRank:SetText(Localization:GetString("801140", segCfg.rank_low .. "-" .. segCfg.rank_high))
end

return UIArenaNewbieRankItemSegment
