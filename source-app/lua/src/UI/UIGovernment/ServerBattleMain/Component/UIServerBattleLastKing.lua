local UIServerBattleLastKing = BaseClass("UIServerBattleLastKing", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local UIServerBattleLastKingServerInfo1 = require("UI.UIGovernment.ServerBattleMain.Component.King.UIServerBattleLastKingServerInfo1")
local UIServerBattleLastKingServerInfo2 = require("UI.UIGovernment.ServerBattleMain.Component.King.UIServerBattleLastKingServerInfo2")
local UIServerBattleLastKingBattleAnim = require("UI.UIGovernment.ServerBattleMain.Component.King.UIServerBattleLastKingBattleAnim")
local UIServerBattleLastKingZoneReward = require("UI.UIGovernment.ServerBattleMain.Component.King.UIServerBattleLastKingZoneReward")
local UIServerBattleLastKingKillRank = require("UI.UIGovernment.ServerBattleMain.Component.King.UIServerBattleLastKingKillRank")
local UIServerBattleLastKingPlayerReward = require("UI.UIGovernment.ServerBattleMain.Component.King.UIServerBattleLastKingPlayerReward")
local scroll_content_path = "Viewport/Content"
local server_info_title_path = "Viewport/Content/serverInfoTitle"
local info_btn_path = "Viewport/Content/serverInfoTitle/InfoBtn"
local remain_time_path = "Viewport/Content/GameObject/remainTime"
local server_info1_path = "Viewport/Content/ServerInfo1"
local server_info2_path = "Viewport/Content/ServerInfo2"
local battle_anim_path = "Viewport/Content/BattleAnim"
local zone_reward_info_path = "Viewport/Content/ZoneRewardInfo"
local kill_rank_path = "Viewport/Content/KillRank"
local player_reward_info_path = "Viewport/Content/PlayerRewardInfo"

function UIServerBattleLastKing:OnCreate()
  base.OnCreate(self)
  self.rootContent = self:AddComponent(UIBaseContainer, scroll_content_path)
  self.title = self:AddComponent(UIText, server_info_title_path)
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.remain_time = self:AddComponent(UIText, remain_time_path)
end

function UIServerBattleLastKing:OnDestroy()
  base.OnDestroy(self)
end

function UIServerBattleLastKing:InitComponent()
  if self.server_info1 == nil or self.server_info2 == nil then
    self.server_info1 = self:AddComponent(UIServerBattleLastKingServerInfo1, server_info1_path)
    self.server_info2 = self:AddComponent(UIServerBattleLastKingServerInfo2, server_info2_path)
    self.battle_anim = self:AddComponent(UIServerBattleLastKingBattleAnim, battle_anim_path)
    self.zone_reward_info = self:AddComponent(UIServerBattleLastKingZoneReward, zone_reward_info_path)
    self.kill_rank = self:AddComponent(UIServerBattleLastKingKillRank, kill_rank_path)
    self.player_reward_info = self:AddComponent(UIServerBattleLastKingPlayerReward, player_reward_info_path)
    self.info_btn:SetOnClick(function()
      local param = {}
      param.title = "801453"
      local content = self.serverBattleType == ServerBattleType.VSCamp and "season_s2_camp_war_info02" or "801454"
      param.activityRulesStr = Localization:GetString(content)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
    end)
  end
end

function UIServerBattleLastKing:OnEnable()
  base.OnEnable(self)
  self:AddUIListener(EventId.CrossKingFightInfoRefresh, self.UpdateData)
end

function UIServerBattleLastKing:OnDisable()
  self:RemoveUIListener(EventId.CrossKingFightInfoRefresh, self.UpdateData)
  base.OnDisable(self)
end

function UIServerBattleLastKing:UpdateData()
  local fightInfo = DataCenter.ZoneWarManager:GetCrossKingFightInfo(true)
  local configSchedule = DataCenter.ZoneWarManager:GetCrossKingSchedule()
  if configSchedule == nil or fightInfo == nil then
    return
  end
  self.fightInfo = fightInfo
  self.configSchedule = configSchedule
  self:InitComponent()
  self:RefreshUI(configSchedule, fightInfo, self.config, self.serverBattleType)
end

function UIServerBattleLastKing:ReInit(configSchedule, config, serverBattleType)
  self.config = config
  self.configSchedule = configSchedule
  self.serverBattleType = serverBattleType
  self:UpdateData()
end

function UIServerBattleLastKing:RefreshUI(configSchedule, fightInfo, config, serverBattleType)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if curTime < configSchedule.crossStartTime then
    self.endTime = configSchedule.breakThroneProtectTime
    self.title:SetLocalText("458012")
    self.server_info1:SetActive(true)
    self.server_info2:SetActive(false)
    self.battle_anim:SetActive(false)
    self.kill_rank:SetActive(false)
    self.server_info1:ReInit(configSchedule, fightInfo, config, serverBattleType)
  elseif curTime < configSchedule.roundSettleTime then
    self.endTime = configSchedule.roundSettleTime
    if fightInfo.curVsRound[1].win ~= 0 then
      self.title:SetLocalText("457084")
    elseif curTime < configSchedule.breakThroneProtectTime then
      self.endTime = configSchedule.breakThroneProtectTime
      self.title:SetLocalText("801458")
    else
      self.title:SetLocalText("801459")
    end
    self.server_info1:SetActive(false)
    self.server_info2:SetActive(true)
    self.battle_anim:SetActive(true)
    self.server_info2:ReInit(configSchedule, fightInfo, config, serverBattleType)
    self.battle_anim:ReInit(configSchedule, fightInfo, config, serverBattleType)
    if fightInfo.rankMVP and fightInfo.rankMVP.uid ~= nil then
      self.kill_rank:SetActive(true)
      self.kill_rank:ReInit(configSchedule, fightInfo, config, serverBattleType)
    else
      self.kill_rank:SetActive(false)
    end
  else
    self.title:SetLocalText("801460")
    if curTime < configSchedule.startTime then
      self.endTime = configSchedule.startTime
    else
      self.endTime = configSchedule.endTime
    end
  end
  self.zone_reward_info:ReInit(configSchedule, fightInfo, config, serverBattleType)
  self.player_reward_info:ReInit(configSchedule, fightInfo, config, serverBattleType, self.rootContent)
  if curTime > self.endTime then
    self.endTime = configSchedule.endTime
  end
  self:Update1000MS()
end

function UIServerBattleLastKing:Update1000MS()
  if self.endTime then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if 0 < remainTime then
      self.remain_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
      self.endTime = nil
      self.remain_time:SetText("00:00:00")
    end
  end
end

return UIServerBattleLastKing
