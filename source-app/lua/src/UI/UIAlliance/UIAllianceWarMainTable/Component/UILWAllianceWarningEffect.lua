local UILWAllianceWarningEffect = BaseClass("UILWAllianceWarningEffect", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local bg_path = "mainContent/bg"
local player_head_path = "mainContent/PlayerHead"
local name_path = "mainContent/image/name"
local time_txt_path = "mainContent/bg/time_txt"
local icon_bg_from_path = "mainContent/iconBgFrom"
local from_path = "mainContent/iconBgFrom/from"
local icon_bg_to_path = "mainContent/iconBgTo"
local to_path = "mainContent/iconBgTo/to"
local icon_from_path = "mainContent/iconBgFrom/iconFrom"
local from_pos_path = "mainContent/iconBgFrom/fromPos"
local to_pos_path = "mainContent/iconBgTo/toPos"

function UILWAllianceWarningEffect:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWAllianceWarningEffect:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAllianceWarningEffect:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.player_head = self:AddComponent(UICommonHead, player_head_path)
  self.name = self:AddComponent(UITextMeshProUGUIEx, name_path)
  self.time_txt = self:AddComponent(UITextMeshProUGUIEx, time_txt_path)
  self.icon_bg_from = self:AddComponent(UIButton, icon_bg_from_path)
  self.fromTxt = self:AddComponent(UITextMeshProUGUIEx, from_path)
  self.icon_bg_to = self:AddComponent(UIButton, icon_bg_to_path)
  self.toTxt = self:AddComponent(UITextMeshProUGUIEx, to_path)
  self.icon_from = self:AddComponent(UIImage, icon_from_path)
  self.from_pos = self:AddComponent(UITextMeshProUGUIEx, from_pos_path)
  self.to_pos = self:AddComponent(UITextMeshProUGUIEx, to_pos_path)
  self.icon_bg_to:SetOnClick(function()
    if self.data and self.data.targetPointId then
      GoToUtil.TryJumpToWorld({
        action = "Jump",
        pointId = self.data.targetPointId,
        server = self.data.serverId,
        worldId = self.data.worldId or 0
      })
    end
  end)
  self.icon_bg_from:SetOnClick(function()
    if self.data and self.data.startPointId then
      GoToUtil.TryJumpToWorld({
        action = "Jump",
        pointId = self.data.startPointId,
        server = self.data.serverId,
        worldId = self.data.worldId or 0
      })
    end
  end)
  self.player_head:SetEnableClickShowInfo(true, true)
end

function UILWAllianceWarningEffect:ComponentDestroy()
  self.bg = nil
  self.icon_bg_to = nil
  self.icon_bg_from = nil
  self.player_head = nil
  self.name = nil
  self.time_txt = nil
  self.fromTxt = nil
  self.toTxt = nil
  self.icon_from = nil
  self.from_pos = nil
  self.to_pos = nil
end

function UILWAllianceWarningEffect:SetData(data)
  self.data = data
  self.sendRequest = false
end

function UILWAllianceWarningEffect:RefreshData()
  local data = self.data
  if data == nil or data.effectType ~= AlAlertType.AresMissile and data.effectType ~= AlAlertType.MissileFactory and data.effectType ~= AlAlertType.GoddessMummy then
    return
  end
  local effectType = data.effectType
  local path = "Assets/Main/Sprites/UI/UIAllianceNew/zyf_tongmengronglu_jianzhuqietu.png"
  if effectType == AlAlertType.AresMissile then
    path = DataCenter.AllianceGovernmentSkillManager:GetSkillBigIconBySkillType(AlOfficialSkillType.AresMissile)
  elseif effectType == AlAlertType.MissileFactory then
    path = DataCenter.AllianceGovernmentSkillManager:GetSkillBigIconBySkillType(AlOfficialSkillType.MissileFactory)
  elseif effectType == AlAlertType.GoddessMummy then
    path = DataCenter.AllianceGovernmentSkillManager:GetSkillBigIconBySkillType(AlOfficialSkillType.GoddessMummy)
  end
  local skillId = data.skillId
  if skillId then
    local skillConfig = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(skillId)
    if skillConfig and not string.IsNullOrEmpty(skillConfig.skill_show) then
      path = skillConfig.skill_show
    end
  end
  self.icon_from:LoadSprite(path)
  local tilePosFrom = SceneUtils.IndexToTilePos(data.startPointId, ForceChangeScene.World)
  local strPosFrom = UIUtil.FormatServerPosition(nil, tilePosFrom.x, tilePosFrom.y)
  local tilePosTo = SceneUtils.IndexToTilePos(data.targetPointId, ForceChangeScene.World)
  local strPosTo = UIUtil.FormatServerPosition(nil, tilePosTo.x, tilePosTo.y)
  self.player_head:ParseHeadInfo(data.user)
  self.name:SetText(UIUtil.FormatServerAllianceName(data.serverId, data.user.abbr) .. "\n" .. data.user.name)
  local langKey = "season_alliance_government_skill_02"
  if effectType == AlAlertType.GoddessMummy then
    langKey = "season_alliance_government_skill_goddess_02"
  elseif effectType == AlAlertType.MissileFactory then
    langKey = "season_alliance_government_skill_41_name"
  end
  self.fromTxt:SetLocalText(langKey)
  self.from_pos:SetText(strPosFrom)
  self.toTxt:SetLocalText(110154)
  self.to_pos:SetText(strPosTo)
  local seasonType = SeasonUtil.GetSeasonType(false, true)
  local allianceId = data.allianceId
  local myAllianceId = LuaEntry.Player:GetAllianceUid()
  local bgPathRed = "Assets/Main/Sprites/UI/UILWAlliance/lyp_tongmeng_tiao.png"
  local bgPathBlue = "Assets/Main/Sprites/UI/UILWAlliance/lyp_tongmengjijie_tiao.png"
  local bgPath = bgPathRed
  if allianceId == myAllianceId then
    bgPath = bgPathBlue
  elseif SeasonUtil.SeasonHasFactionWar(seasonType) then
    local factionMgr = DataCenter.SeasonFactionWarDataManager
    local myCampId = factionMgr.myCampId
    if myCampId ~= 0 and (factionMgr.currStep == SeasonFactionDeclareWarStep.battle_before or factionMgr.currStep == SeasonFactionDeclareWarStep.battle or factionMgr.currStep == SeasonFactionDeclareWarStep.battle_after) then
      if factionMgr.theAttackerList[myAllianceId] and factionMgr.theAttackerList[allianceId] or factionMgr.theDefenderList[myAllianceId] and factionMgr.theDefenderList[allianceId] then
        bgPath = bgPathBlue
      end
      if factionMgr.theAttackerList[myAllianceId] and factionMgr.theDefenderList[allianceId] or factionMgr.theDefenderList[myAllianceId] and factionMgr.theAttackerList[allianceId] then
        bgPath = bgPathRed
      end
    end
  end
  self.bg:LoadSprite(bgPath)
  self:Update1000MS()
end

function UILWAllianceWarningEffect:Update1000MS()
  if self.data then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local langKey = self.data.effectType == AlAlertType.AresMissile and "season_s2_government_skill_tips11" or "season_s3_government_skill_tips11"
    if self.data.effectType == AlAlertType.MissileFactory then
      langKey = "season_activity_1000086_tips39"
    end
    local remainTime = self.data.activeTime - curTime
    if 0 < remainTime then
      local txt = Localization:GetString(langKey)
      self.time_txt:SetText(txt .. [[

<size=50>]] .. UITimeManager:GetInstance():MilliSecondToFmtString(remainTime) .. "</size>")
    else
      self.time_txt:SetLocalText(langKey)
      if not self.sendRequest then
        self.sendRequest = true
        SFSNetwork.SendMessage(MsgDefines.GetWorldEffectAlter, 0)
      end
    end
  end
end

return UILWAllianceWarningEffect
