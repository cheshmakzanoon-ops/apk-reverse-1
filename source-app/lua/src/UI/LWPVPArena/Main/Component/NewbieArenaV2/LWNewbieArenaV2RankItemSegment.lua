local LWNewbieArenaV2RankItemSegment = BaseClass("LWNewbieArenaV2RankItemSegment", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "txtRank",
    name = "txtRank",
    type = UIText
  }
}

function LWNewbieArenaV2RankItemSegment:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWNewbieArenaV2RankItemSegment:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWNewbieArenaV2RankItemSegment:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function LWNewbieArenaV2RankItemSegment:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWNewbieArenaV2RankItemSegment:Refresh(segCfg)
  self.txtRank:SetText(Localization:GetString("801140", segCfg.rank_low .. "-" .. segCfg.rank_high))
end

return LWNewbieArenaV2RankItemSegment
