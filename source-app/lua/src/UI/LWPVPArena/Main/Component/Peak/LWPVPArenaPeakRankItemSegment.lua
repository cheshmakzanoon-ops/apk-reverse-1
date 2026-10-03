local LWPVPArenaPeakRankItemSegment = BaseClass("LWPVPArenaPeakRankItemSegment", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "txtRank",
    name = "txtRank",
    type = UIText
  }
}

function LWPVPArenaPeakRankItemSegment:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWPVPArenaPeakRankItemSegment:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWPVPArenaPeakRankItemSegment:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function LWPVPArenaPeakRankItemSegment:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWPVPArenaPeakRankItemSegment:Refresh(low, high)
  self.txtRank:SetText(Localization:GetString("801140", low .. "-" .. high))
end

return LWPVPArenaPeakRankItemSegment
