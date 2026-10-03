local SeasonFactionWarKillRank = BaseClass("SeasonFactionWarKillRank", UIBaseContainer)
local base = UIBaseContainer
local player_path = "Player"
local name_path = "Name"
local score_path = "Score"
local rank_btn_path = "RankBtn"
local no1_path = "NO1"

function SeasonFactionWarKillRank:OnCreate()
  base.OnCreate(self)
  self.playerUI = self:AddComponent(UICommonHead, player_path)
  self.name = self:AddComponent(UIText, name_path)
  self.score = self:AddComponent(UIText, score_path)
  self.NO1 = self:AddComponent(UIText, no1_path)
  self.rank_btn = self:AddComponent(UIButton, rank_btn_path)
  self.rank_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonFactionWarScoreRankList)
  end)
  self.playerUI:SetEnableClickShowInfo(true, true)
end

function SeasonFactionWarKillRank:OnDestroy()
  base.OnDestroy(self)
end

function SeasonFactionWarKillRank:ReInit(rankMVP)
  if rankMVP then
    self.score:SetText("+" .. string.GetFormattedSeparatorNum(rankMVP.score or 0) .. "pt")
    self.name:SetText(UIUtil.FormatServerAllianceName(rankMVP.serverId, rankMVP.abbr, rankMVP.name))
    self.playerUI:ParseHeadInfo(rankMVP)
    if rankMVP.rank == -1 then
      self.NO1:SetLocalText(361054)
    else
      self.NO1:SetLocalText(800323, rankMVP.rank or "1")
    end
    if not string.IsNullOrEmpty(rankMVP.country) then
      self.playerUI:SetFlag(rankMVP.country)
    end
  end
end

return SeasonFactionWarKillRank
