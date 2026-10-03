local UIServerBattleLastKingKillRank = BaseClass("UIServerBattleLastKingKillRank", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local player_path = "Player"
local name_path = "Name"
local score_path = "Score"
local rank_btn_path = "RankBtn"
local no1_path = "NO1"
local rank_info_btn_path = "title/RankInfoBtn"

function UIServerBattleLastKingKillRank:OnCreate()
  base.OnCreate(self)
  self.playerUI = self:AddComponent(UICommonHead, player_path)
  self.name = self:AddComponent(UIText, name_path)
  self.score = self:AddComponent(UIText, score_path)
  self.NO1 = self:AddComponent(UIText, no1_path)
  self.rank_btn = self:AddComponent(UIButton, rank_btn_path)
  self.rank_btn:SetOnClick(function()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentServerBattleRank, {anim = true}, 1)
  end)
  self.rank_info_btn = self:AddComponent(UIButton, rank_info_btn_path)
  self.rank_info_btn:SetOnClick(function()
    UIUtil.ShowBubbleTips(Localization:GetString("zone_war_ui_tips100"), self.rank_info_btn.transform.position, -10, -30, 0, nil, nil)
  end)
  self.playerUI:SetEnableClickShowInfo(true, true)
  self.NO1:SetLocalText(800323, 1)
  self:AddUIListener(EventId.GetNewUserInfoSucc, self.OnPlayerDataCallBack)
end

function UIServerBattleLastKingKillRank:OnDestroy()
  self:RemoveUIListener(EventId.GetNewUserInfoSucc, self.OnPlayerDataCallBack)
  base.OnDestroy(self)
end

function UIServerBattleLastKingKillRank:ReInit(configSchedule, fightInfo, config, serverBattleType)
  self.selfMvp = nil
  self.win = fightInfo.curVsRound and fightInfo.curVsRound[1] and fightInfo.curVsRound[1].win or 0
  local rankMVP = fightInfo.rankMVP
  if rankMVP then
    local name = UIUtil.FormatServerAllianceName(rankMVP.serverId, rankMVP.abbr, rankMVP.name, rankMVP.uid)
    self.name:SetText(name)
    self.playerUI:ParseHeadInfo(rankMVP)
    self.score:SetText("+" .. string.GetFormattedSeparatorNum(rankMVP.score or 0) .. "pt")
    if not string.IsNullOrEmpty(rankMVP.country) then
      self.playerUI:SetFlag(rankMVP.country)
    end
    if self.win ~= 0 then
      self.selfMvp = rankMVP.uid == LuaEntry.Player.uid and rankMVP
      DataCenter.ZoneWarManager:TryShowThumbUp(rankMVP, "ServerBattleKingRank", "zone_war_ui_tittle02")
    end
  end
end

function UIServerBattleLastKingKillRank:OnPlayerDataCallBack(uid)
  if self.win ~= 0 and self.selfMvp and uid == self.selfMvp.uid then
    DataCenter.ZoneWarManager:TryShowThumbUp(self.selfMvp, "ServerBattleKingRank", "zone_war_ui_tittle02")
    self.selfMvp = nil
  end
end

return UIServerBattleLastKingKillRank
