local base = UIAsyncContainer
local FormationSeasonResistanceV2 = BaseClass("FormationSeasonResistanceV2", UIAsyncContainer)

function FormationSeasonResistanceV2:OnCreate()
  base.OnCreate(self)
  self.fun_btn = self:AddComponent(UIButton, "funBtn")
  self.icon = self:AddComponent(UIImage, "funBtn/icon")
  self.icon_status = self:AddComponent(UIImage, "funBtn/iconStatus")
  self.effect = self:AddComponent(UIBaseContainer, "funBtn/iconStatus/effect")
  self.keyNode = self:AddComponent(UITextMeshProUGUIEx, "Key")
  self.valueNode = self:AddComponent(UITextMeshProUGUIEx, "Value")
  self.fun_btn:SetOnClick(function()
    if self.has_resistance == nil or self.need_resistance == nil then
      return
    end
    local resistance_type = toInt(self.resistance_type)
    local selfPercent = SeasonUtil.GetSeasonResistanceSelf(self.has_resistance, self.need_resistance, resistance_type) - 1
    local otherPercent = SeasonUtil.GetSeasonResistanceOther(self.has_resistance, self.need_resistance, resistance_type)
    if selfPercent and otherPercent then
      if 0 <= selfPercent then
        UIUtil.ShowTipsId("season_tiles_popui_info007")
      else
        local seasonType, seasonVersion = SeasonUtil.GetSeasonTypeAndVersion()
        if seasonType ~= SeasonMapType.CityStronghold or seasonVersion == 0 or not DataCenter.SeasonDataManager:InNormalMode() then
          UIUtil.ShowResistanceDetail(selfPercent, otherPercent, true)
        else
          local data = {}
          data.resistance = self.need_resistance
          data.selfValue = self.has_resistance
          data.selfPercent = selfPercent
          data.otherPercent = otherPercent
          data.checkResistance = false
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIResistanceWarningPanel, {
            anim = true,
            UIMainAnim = UIMainAnimType.LeftRightBottomHide
          }, data)
        end
      end
    end
  end)
  self:SetAsLastSibling()
end

function FormationSeasonResistanceV2:OnDestroy()
  self.fun_btn = nil
  self.icon = nil
  self.icon_status = nil
  self.effect = nil
  self.keyNode = nil
  self.valueNode = nil
  base.OnDestroy(self)
end

function FormationSeasonResistanceV2:RefreshData(resistance_type, selfValue, resistance)
  self.need_resistance = toInt(resistance)
  self.has_resistance = toInt(selfValue)
  self.resistance_type = toInt(resistance_type)
  self:UpdateData()
end

function FormationSeasonResistanceV2:UpdateData()
  if self.has_resistance == nil or self.need_resistance == nil or not self:AsyncLoadDone() then
    return
  end
  local has_resistance = toInt(self.has_resistance)
  local need_resistance = toInt(self.need_resistance)
  local str_has_resistance = string.GetFormattedSeparatorNum(has_resistance)
  local str_need_resistance = string.GetFormattedSeparatorNum(need_resistance)
  self.keyNode:SetLocalText("season_popUI_desc002")
  if has_resistance > need_resistance then
    self.icon_status:LoadSpriteAsync("Assets/Main/Sprites/UI/LWUIFormation/Mjc_saijijianzhu_tanhao04.png")
    self.valueNode:SetText("<color=#5fef87>" .. str_has_resistance .. "/" .. str_need_resistance .. "</color>")
  elseif has_resistance == need_resistance then
    self.icon_status:LoadSpriteAsync("Assets/Main/Sprites/UI/LWUIFormation/mjc_chuzheng_tanhao_huang.png")
    self.valueNode:SetText("<color=#fdc839>" .. str_has_resistance .. "/" .. str_need_resistance .. "</color>")
  else
    self.icon_status:LoadSpriteAsync("Assets/Main/Sprites/UI/LWUIFormation/Mjc_saijijianzhu_tanhao03.png")
    self.valueNode:SetText("<color=#f53c3d>" .. str_has_resistance .. "/" .. str_need_resistance .. "</color>")
  end
  self.effect:SetActive(false)
end

local FormationRallyResistanceV2 = BaseClass("FormationRallyResistanceV2", UIAsyncContainer)
local bg1_path = "KangXingSelf/bg1"
local key1_path = "KangXingSelf/Key1"
local value1_path = "KangXingSelf/Value1"
local msg_btn1_path = "KangXingSelf/MsgBtn1"
local bg2_path = "KangXingLeader/bg2"
local key2_path = "KangXingLeader/Key2"
local value2_path = "KangXingLeader/Value2"
local msg_btn2_path = "KangXingLeader/MsgBtn2"
local value_outline1_path = "KangXingSelf/ValueOutline1"
local value_outline2_path = "KangXingLeader/ValueOutline2"

function FormationRallyResistanceV2:OnCreate()
  base.OnCreate(self)
  self.bg1 = self:AddComponent(UIImage, bg1_path)
  self.key1 = self:AddComponent(UITextMeshProUGUIEx, key1_path)
  self.value1 = self:AddComponent(UITextMeshProUGUIEx, value1_path)
  self.msg_btn1 = self:AddComponent(UIButton, msg_btn1_path)
  self.bg2 = self:AddComponent(UIImage, bg2_path)
  self.key2 = self:AddComponent(UITextMeshProUGUIEx, key2_path)
  self.value2 = self:AddComponent(UITextMeshProUGUIEx, value2_path)
  self.msg_btn2 = self:AddComponent(UIButton, msg_btn2_path)
  self.value_outline1 = self:AddComponent(UITextMeshProUGUIEx, value_outline1_path)
  self.value_outline2 = self:AddComponent(UITextMeshProUGUIEx, value_outline2_path)
  self.msg_btn1:SetOnClick(function()
    UIUtil.ShowButtonTips(self.msg_btn1, "", "season_monster_resistance_selfactive_desc")
  end)
  self.msg_btn2:SetOnClick(function()
    UIUtil.ShowButtonTips(self.msg_btn2, "", "season_monster_resistance_captainactive_desc")
  end)
  self:SetAsLastSibling()
end

function FormationRallyResistanceV2:OnDestroy()
  self.bg1 = nil
  self.key1 = nil
  self.value1 = nil
  self.msg_btn1 = nil
  self.bg2 = nil
  self.key2 = nil
  self.value2 = nil
  self.msg_btn2 = nil
  self.value_outline1 = nil
  self.value_outline2 = nil
  base.OnDestroy(self)
end

function FormationRallyResistanceV2:SetRallyInfo(allianceWarData)
  self.allianceWarData = allianceWarData
  if allianceWarData ~= nil then
    self.leaderMarch = allianceWarData.leaderMarch
  end
end

function FormationRallyResistanceV2:RefreshData(resistance_type, selfValue, resistance, theBattleTeamInfo)
  self.need_resistance = toInt(resistance)
  self.has_resistance = toInt(selfValue)
  self.resistance_type = toInt(resistance_type)
  self.theBattleTeamInfo = theBattleTeamInfo
  self:UpdateData()
end

function FormationRallyResistanceV2:UpdateData()
  if self.has_resistance == nil or self.need_resistance == nil or not self:AsyncLoadDone() then
    return
  end
  local has_resistance = toInt(self.has_resistance)
  local need_resistance = toInt(self.need_resistance)
  local str_has_resistance = string.GetFormattedSeparatorNum(has_resistance)
  local str_need_resistance = string.GetFormattedSeparatorNum(need_resistance)
  self.key1:SetLocalText("season_monster_resistance_self_limit")
  self.key2:SetLocalText("season_monster_resistance_captain_limit")
  self.value1:SetText(str_has_resistance)
  self.value_outline1:SetText(str_has_resistance)
  if self.theBattleTeamInfo then
    local resistanceValue = toInt(self.theBattleTeamInfo.resistanceValue)
    self.value2:SetText(string.GetFormattedSeparatorNum(resistanceValue))
    self.value_outline2:SetText(string.GetFormattedSeparatorNum(resistanceValue))
    if has_resistance >= resistanceValue then
      self.key1:SetLocalText("season_monster_resistance_self_used_limit")
      self.key1:SetColorHex("#099b4a")
      self.key2:SetColorHex("#2A2830")
      self.bg1:SetColorHex("#DDF2BA")
      self.bg2:SetColorRGBA255(241, 237, 235, 255)
      self.value1:SetActive(false)
      self.value2:SetActive(true)
      self.value_outline1:SetActive(true)
      self.value_outline2:SetActive(false)
      self.msg_btn1:SetActive(true)
      self.msg_btn2:SetActive(false)
    else
      self.key2:SetLocalText("season_monster_resistance_captain_used_limit")
      self.key1:SetColorHex("#2A2830")
      self.key2:SetColorHex("#099b4a")
      self.bg1:SetColorRGBA255(241, 237, 235, 255)
      self.bg2:SetColorHex("#DDF2BA")
      self.value1:SetActive(true)
      self.value2:SetActive(false)
      self.value_outline1:SetActive(false)
      self.value_outline2:SetActive(true)
      self.msg_btn1:SetActive(false)
      self.msg_btn2:SetActive(true)
    end
  else
    self.bg1:SetColorRGBA255(241, 237, 235, 255)
    self.bg2:SetColorRGBA255(241, 237, 235, 255)
    self.key1:SetColorHex("#2A2830")
    self.key2:SetColorHex("#2A2830")
    self.value2:SetText("-")
    self.value1:SetActive(true)
    self.value2:SetActive(true)
    self.value_outline1:SetActive(false)
    self.value_outline2:SetActive(false)
    self.msg_btn1:SetActive(false)
    self.msg_btn2:SetActive(false)
  end
end

function FormationSeasonResistanceV2.CheckResistance(parent, root, targetType, fixedSoldierType, rallyType, targetUuid)
  if parent == nil or root == nil or parent.view == nil or parent.view.ctrl == nil then
    return 0, 0, 0
  end
  local isDragonWorld = BattleFieldUtil.InBattleField()
  local isInSeason = SeasonUtil.IsInSeason(false)
  if isDragonWorld or not isInSeason then
    if parent and parent.kang_xing_root then
      parent.kang_xing_root:SetActive(false)
    end
    return 0, 0, 0
  end
  local resistance_type = 0
  local resistance = 0
  local selfValue = 0
  local theTargetType = targetType
  local theTargetUuid = targetUuid
  local allianceWarData, monsterId
  if targetType == MarchTargetType.JOIN_RALLY then
    theTargetType = rallyType
    allianceWarData = DataCenter.AllianceWarDataManager:GetAllianceWarDataByUuid(targetUuid)
    if allianceWarData ~= nil then
      theTargetUuid = allianceWarData.targetUuid
      monsterId = toInt(allianceWarData.targetContentId)
    end
  end
  if theTargetType == MarchTargetType.ATTACK_DESERT or theTargetType == MarchTargetType.ATTACK_ALLIANCE_CITY or theTargetType == MarchTargetType.RALLY_FOR_ALLIANCE_CITY or theTargetType == MarchTargetType.ATTACK_CITY_STRONGHOLD or theTargetType == MarchTargetType.RALLY_CITY_STRONGHOLD or theTargetType == MarchTargetType.ATTACK_MONSTER or theTargetType == MarchTargetType.RALLY_FOR_BOSS then
    if theTargetType == MarchTargetType.ATTACK_MONSTER or theTargetType == MarchTargetType.RALLY_FOR_BOSS then
      if monsterId == nil then
        local marchInfo = CS.SceneManager.World:GetMarch(theTargetUuid)
        if marchInfo then
          monsterId = marchInfo.monsterId
        end
      end
      if monsterId then
        local monsterConfig = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
        if monsterConfig ~= nil then
          if 0 < monsterConfig.monster_resistance then
            resistance = monsterConfig.monster_resistance + SeasonUtil.GetBloodyNightResistanceValueAdd()
          end
          resistance_type = toInt(monsterConfig.resistance_type)
          selfValue = SeasonUtil.GetSelfSeasonResistanceValue()
        end
      end
    elseif theTargetType == MarchTargetType.ATTACK_DESERT then
      selfValue = SeasonUtil.GetSelfSeasonResistanceValue()
      if parent and parent.kang_xing_root then
        parent.kang_xing_root:SetActive(false)
      end
      return 0, 0, 0
    else
      selfValue = SeasonUtil.GetSelfSeasonResistanceValue()
      if parent and parent.kang_xing_root then
        parent.kang_xing_root:SetActive(false)
      end
      return 0, 0, 0
    end
    if resistance and 0 < resistance then
      if fixedSoldierType == SoldierType.Mummy then
        local effect94115 = LuaEntry.Effect:GetGameEffect(94115)
        if effect94115 ~= nil and effect94115 ~= 0 then
          selfValue = selfValue + effect94115
        end
      end
      if parent.kang_xing_root == nil then
        local luaClass = FormationSeasonResistanceV2
        local prefabPath = "Assets/Main/Prefabs/UI/UIFormation/V2/KangXingRootV2.prefab"
        if targetType == MarchTargetType.JOIN_RALLY then
          luaClass = FormationRallyResistanceV2
          prefabPath = "Assets/Main/Prefabs/UI/UIFormation/V2/KangXingRallyV2.prefab"
          if theTargetUuid ~= nil and parent.theBattleTeamInfo == nil and allianceWarData ~= nil then
            SFSNetwork.SendMessage(MsgDefines.FetchBattleTeamInfo, targetUuid, allianceWarData.server, allianceWarData.worldId or 0)
          end
        end
        parent.kang_xing_root = UIBaseComponent.LoadComponentAsync(parent, luaClass, prefabPath, root.transform, function(view, go, lua, callback_param)
          if go and root and ComponentIsValid(root) then
            CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(root.rectTransform)
          end
        end)
      end
      if parent.kang_xing_root ~= nil then
        if targetType == MarchTargetType.JOIN_RALLY then
          if parent.kang_xing_root.SetRallyInfo ~= nil then
            parent.kang_xing_root:SetRallyInfo(allianceWarData)
          end
          parent.kang_xing_root:SetActive(parent.theBattleTeamInfo ~= nil)
        else
          parent.kang_xing_root:SetActive(true)
        end
        parent.kang_xing_root:RefreshData(resistance_type, selfValue, resistance, parent.theBattleTeamInfo)
      end
    elseif parent and parent.kang_xing_root then
      parent.kang_xing_root:SetActive(false)
    end
  end
  return selfValue, resistance, resistance_type
end

return FormationSeasonResistanceV2
