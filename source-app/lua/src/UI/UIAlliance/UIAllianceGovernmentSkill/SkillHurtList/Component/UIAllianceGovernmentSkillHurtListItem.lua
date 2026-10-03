local UIAllianceGovernmentSkillHurtListItem = BaseClass("UIAllianceGovernmentSkillHurtListItem", UIBaseContainer)
local base = UIBaseContainer

function UIAllianceGovernmentSkillHurtListItem:OnCreate()
  base.OnCreate(self)
  self.player_head = self:AddComponent(UICommonHead, "UIPlayerHead")
  self.txt_time = self:AddComponent(UITextMeshProUGUIEx, "Txt_Time")
  self.txt_title = self:AddComponent(UITextMeshProUGUIEx, "Txt_Title")
  self.txt_des = self:AddComponent(UITextMeshProUGUIEx, "Txt_Des")
  self.player_head:SetEnableClickShowInfo(true, true)
end

function UIAllianceGovernmentSkillHurtListItem:OnDestroy()
  base.OnDestroy(self)
end

function UIAllianceGovernmentSkillHurtListItem:ReInit(index, data, serverData, skillType)
  local seasonType = SeasonUtil.GetSeasonType(false, true)
  local factionMgr = DataCenter.SeasonFactionWarDataManager
  local myCampId = factionMgr.myCampId
  if myCampId ~= 0 and data.serverId then
    local theCampId = factionMgr:GetCampIdByServerId(data.serverId)
    if theCampId ~= 0 then
      if myCampId ~= theCampId then
        self.txt_title:SetColorRGBA(1, 0.09, 0.22, 1)
      else
        self.txt_title:SetColorRGBA(0.14, 0.61, 0.77, 1)
      end
    end
  end
  if data.allianceId ~= nil and SeasonUtil.SeasonHasFactionWar(seasonType) then
    local currStep = factionMgr:GetCurrStep()
    if myCampId ~= 0 and (currStep == SeasonFactionDeclareWarStep.battle_before or currStep == SeasonFactionDeclareWarStep.battle or currStep == SeasonFactionDeclareWarStep.battle_after) then
      local myAllianceId = LuaEntry.Player:GetAllianceUid()
      local allianceId = data.allianceId
      if factionMgr.theAttackerList[myAllianceId] and factionMgr.theAttackerList[allianceId] or factionMgr.theDefenderList[myAllianceId] and factionMgr.theDefenderList[allianceId] then
        self.txt_title:SetColorRGBA(0.14, 0.61, 0.77, 1)
      elseif factionMgr.theAttackerList[myAllianceId] and factionMgr.theDefenderList[allianceId] or factionMgr.theDefenderList[myAllianceId] and factionMgr.theAttackerList[allianceId] then
        self.txt_title:SetColorRGBA(1, 0.09, 0.22, 1)
      else
        self.txt_title:SetColorRGBA255(182, 182, 182, 255)
      end
    end
  end
  self.player_head:ParseHeadInfo(data)
  self.txt_title:SetText(UIUtil.FormatServerAllianceName(data.serverId, data.abbr, data.name))
  if serverData and serverData.chantOverTime then
    self.txt_time:SetText(UITimeManager:GetInstance():ConvertServerTimeToLocalTime(serverData.chantOverTime, false))
  else
    self.txt_time:SetText("")
  end
  if skillType == AlOfficialSkillType.AresMissile then
    self.txt_des:SetLocalText("season_s2_government_skill_tips21")
  elseif skillType == AlOfficialSkillType.GoddessMummy then
    self.txt_des:SetLocalText("season_s3_government_skill_tips21")
  elseif skillType == AlOfficialSkillType.MissileFactory then
    self.txt_des:SetLocalText("season_s2_government_skill_tips21")
  end
end

return UIAllianceGovernmentSkillHurtListItem
