local AllianceCityTip = BaseClass("AllianceCityTip")
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local SuperTextMesh = CS.SuperTextMesh
local TouchObjectEventTrigger = CS.TouchObjectEventTrigger
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local skinColorServerStr, skinColorList2, skinColorList3, skinColorList4, skinColorList5, skinColorList6, skinColorList7
local AllianceCityTipAssistanceComp = require("DataCenter.AllianceCityTip.AllianceCityTipAssistanceComp")
local SeasonAllianceWarTimeBuildingHudLogic = require("DataCenter.AllianceCityTip.Season.SeasonAllianceWarTimeBuildingHudLogic")
local AllianceSkillReinforcementHudLogic = require("DataCenter.AllianceCityTip.Season.AllianceSkillReinforcementHudLogic")
local SeasonCityAltarCityTipCompLogic = require("UI.LWSeason6.UILWSeasonCityAltar.Map.SeasonCityAltarCityTipCompLogic")
local open_tips_path = "OpenTips"
local open_tips_icon_path = "OpenTips/icon"
local open_tips_time_path = "OpenTips/time"
local nameLabel_path = "NameLabel"
local nameText_path = "NameLabel/NameText"
local levelLabel_path = "LevelLabel"
local levelText_path = "LevelLabel/LevelText"
local virus_node_path = "StatusLayout/VirusNode"
local centerLevelLabel_path = "CenterLevelLabel"
local centerLevelText_path = "CenterLevelLabel/LevelText"
local collider1_path = "LevelLabel/Collider1"
local collider2_path = "CenterLevelLabel/Collider2"
local boss_obj_path = "LevelLabel/actBoss"
local boss_icon_path = "LevelLabel/actBoss/headicon"
local boss_collider_path = "LevelLabel/actBoss/Collider"
local declareWar_path = "StatusLayout/DeclareWar"
local declareWarBtn_path = "StatusLayout/DeclareWar/DeclareWarBtn"
local declareWarList_path = "StatusLayout/DeclareWar/DeclareList"
local city_head_path = "CityHead"
local quality_icon_path = "CityHead/quality_icon"
local reward_icon_path = "CityHead/reward_icon"
local head_icon_path = "CityHead/quality_icon/head_icon"
local assistance_root_path = "AssistanceRoot"
local HP_BAR_LENGTH = 1.77
local BUILD_HP_BAR_LENGTH = 1.72
local bg2_path = "Bg2"
local build_slider_path = "Bg2/buildSlider"
local build_blood_num_path = "Bg2/buildBloodNum"
local add_text_path = "Bg2/addText"
local posOffset = Vector3.New(0, 4, 0)
local namePadding = 0.6
local colliderPadding = 0.6
local levelOffset = 0.3
local maxLod
local headIconNormalSize = 74
local headIconScale = 1.2

function AllianceCityTip:SetSpeNodeStatus(node, showIt)
  if IsNotNull(node) then
    node.gameObject:SetActive(showIt)
    if showIt and node == self.name_spr and not self.isInitName then
      self:SetName(self.cityId)
    end
  end
end

function AllianceCityTip:OnCreate(request)
  local config = SeasonUtil.GetCurServerConfig()
  if config and config.mode ~= nil and config.mode ~= 0 then
    self.forSeason = true
    self.seasonType = config:GetServerSubdivisionType()
  else
    self.forSeason = false
    self.seasonType = SeasonMapType.Nothing
  end
  self.request = request
  self.gameObject = request.gameObject
  self.transform = request.gameObject.transform
  self.name_spr = self.transform:Find(nameLabel_path):GetComponent(typeof(SpriteRenderer))
  self.name_text = self.transform:Find(nameText_path):GetComponent(typeof(CS.TextMeshProEx))
  self.assistanceTran = self.transform:Find(assistance_root_path)
  self.level_spr = self.transform:Find(levelLabel_path):GetComponent(typeof(SpriteRenderer))
  self.level_text = self.transform:Find(levelText_path):GetComponent(typeof(CS.TextMeshProEx))
  self.centerLevel_spr = self.transform:Find(centerLevelLabel_path):GetComponent(typeof(SpriteRenderer))
  self.centerLevel_text = self.transform:Find(centerLevelText_path):GetComponent(typeof(SuperTextMesh))
  self.collider1 = self.transform:Find(collider1_path):GetComponent(typeof(TouchObjectEventTrigger))
  
  function self.collider1.onPointerClick()
    self:OnClick()
  end
  
  self.collider2 = self.transform:Find(collider2_path):GetComponent(typeof(TouchObjectEventTrigger))
  
  function self.collider2.onPointerClick()
    self:OnClick()
  end
  
  self.boss_obj = self.transform:Find(boss_obj_path).gameObject
  self.boss_icon = self.transform:Find(boss_icon_path):GetComponent(typeof(SpriteRenderer))
  self.boss_collider = self.transform:Find(boss_collider_path):GetComponent(typeof(TouchObjectEventTrigger))
  
  function self.boss_collider.onPointerClick()
    self:OnBossClick()
  end
  
  self.cacheLod = 1
  self.statusLayout = self.transform:Find("StatusLayout")
  self.virus_node = self.transform:Find(virus_node_path)
  self.declareWar = self.transform:Find(declareWar_path):GetComponent(typeof(SpriteRenderer))
  self.declareWarList = self.transform:Find(declareWarList_path):GetComponent(typeof(SpriteRenderer))
  self.declareWarBtn = self.transform:Find(declareWarBtn_path):GetComponent(typeof(TouchObjectEventTrigger))
  
  function self.declareWarBtn.onPointerClick()
    self:OnClickDeclare()
  end
  
  self.lodIconProtect = self.transform:Find("LodIcon/hudun")
  self.lodIconProtectSprite = self.lodIconProtect:GetComponent(typeof(SpriteRenderer))
  self.lodIcon = self.transform:Find("LodIcon").gameObject
  self.lodIconSprite = self.lodIcon:GetComponent(typeof(SpriteRenderer))
  self.lodIconCollider = self.transform:Find("LodIcon/LodIconCollider"):GetComponent(typeof(TouchObjectEventTrigger))
  
  function self.lodIconCollider.onPointerClick()
    self:OnClickLod()
  end
  
  self.open_tips_node = self.transform:Find(open_tips_path).gameObject
  self.open_tips_icon_text = self.transform:Find(open_tips_icon_path).gameObject
  self.open_tips_time_text = self.transform:Find(open_tips_time_path):GetComponent(typeof(CS.TextMeshProEx))
  self.timer = nil
  
  function self.timer_action(temp)
    self:TimerAction()
  end
  
  self.allianceWarTimeHud = SeasonAllianceWarTimeBuildingHudLogic.New(self.gameObject)
  self.assistanceRoot = AllianceCityTipAssistanceComp.New(self.gameObject)
  self.allianceReinforce = AllianceSkillReinforcementHudLogic.New(self.gameObject)
  self.cityAltarTipLogic = SeasonCityAltarCityTipCompLogic.New(self.gameObject)
  local ThroneOccupyRoot = self.transform:Find("ThroneOccupy")
  if ThroneOccupyRoot then
    ThroneOccupyRoot.gameObject:SetActive(false)
  end
  if self.forSeason then
    self.lodIcon.transform:Set_localPosition(0, 0, 0)
  end
  if maxLod == nil then
    local lod = GetTableData(TableName.WorldLod, 65, "lod")
    if lod then
      local lod1, lod2 = string.match(lod, "([^-]+)-([^-]+)")
      if lod1 and lod2 then
        maxLod = toInt(lod2)
      end
    end
  end
  self.city_head = self.transform:Find(city_head_path).gameObject
  self.city_head:SetActive(false)
  self.quality_icon = self.transform:Find(quality_icon_path):GetComponent(typeof(SpriteRenderer))
  self.head_icon = self.transform:Find(head_icon_path):GetComponent(typeof(SpriteRenderer))
  self.reward_icon = self.transform:Find(reward_icon_path):GetComponent(typeof(SpriteRenderer))
  self.hpNode = self.transform:Find("HpLod/HpNode").gameObject
  self.shieldBarBgNode = self.transform:Find("HpLod/HpNode/ShieldBarBg").gameObject
  self.hpBarBgNode = self.transform:Find("HpLod/HpNode/HpBarBg").gameObject
  self.bpBgNode = self.transform:Find("HpLod/HpNode/BpBg").gameObject
  self.campDestroyBgNode = self.transform:Find("HpLod/HpNode/CampDestroyBg").gameObject
  self.armyBarSlow = self.transform:Find("HpLod/HpNode/ShieldBarBg/ShieldBarTween"):GetComponent(typeof(SpriteRenderer))
  self.armyBar = self.transform:Find("HpLod/HpNode/ShieldBarBg/ShieldBar"):GetComponent(typeof(SpriteRenderer))
  self.armyBarNum = self.transform:Find("HpLod/HpNode/ShieldBarBg/ShieldBarNum"):GetComponent(typeof(SuperTextMesh))
  self.hpBarSlow = self.transform:Find("HpLod/HpNode/HpBarBg/HpBarTween"):GetComponent(typeof(SpriteRenderer))
  self.hpBar = self.transform:Find("HpLod/HpNode/HpBarBg/HpBar"):GetComponent(typeof(SpriteRenderer))
  self.hpBarNum = self.transform:Find("HpLod/HpNode/HpBarBg/HpBarNum"):GetComponent(typeof(SuperTextMesh))
  self.campDestroyHpBarSlow = self.transform:Find("HpLod/HpNode/CampDestroyBg/HpBarTween"):GetComponent(typeof(SpriteRenderer))
  self.campDestroyHpBar = self.transform:Find("HpLod/HpNode/CampDestroyBg/HpBar"):GetComponent(typeof(SpriteRenderer))
  self.campDestroyHpBarNum = self.transform:Find("HpLod/HpNode/CampDestroyBg/HpBarNum"):GetComponent(typeof(SuperTextMesh))
  self:AddListeners()
  self.bg2 = self.transform:Find(bg2_path).gameObject
  self.build_slider = self.transform:Find(build_slider_path):GetComponent(typeof(SpriteRenderer))
  self.build_blood_num = self.transform:Find(build_blood_num_path):GetComponent(typeof(SuperTextMesh))
  self.add_text = self.transform:Find(add_text_path):GetComponent(typeof(SuperTextMesh))
  self.add_text.gameObject:SetActive(false)
  self.bg2:SetActive(false)
  self.isShowNuCelearBuildTip = false
  self.isInitName = false
  if self.__update_handle then
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
  end
  
  function self.__update_handle()
    self:OnUpdate()
  end
  
  UpdateManager:GetInstance():AddUpdate(self.__update_handle)
end

function AllianceCityTip:OnDestroy()
  self:RemoveVirus()
  self.isShowNuCelearBuildTip = false
  self:RemoveListeners()
  if self.armyTween then
    self.armyTween:Kill()
    self.armyTween = nil
  end
  if self.hpTween then
    self.hpTween:Kill()
    self.hpTween = nil
  end
  if self.request_battle_stronghold_effect ~= nil then
    self.request_battle_stronghold_effect:Destroy()
    self.request_battle_stronghold_effect = nil
  end
  self.eff_battle_stronghold = nil
  if self.reqBloodQueenBattleEffect ~= nil then
    self.reqBloodQueenBattleEffect:Destroy()
    self.reqBloodQueenBattleEffect = nil
  end
  self.bloodQueenBattleEffect = nil
  self.request = nil
  self.data = nil
  self.name_spr = nil
  self.name_text = nil
  self.level_spr = nil
  self.level_text = nil
  if IsNotNull(self.collider1) then
    self.collider1.onPointerClick = nil
  end
  if IsNotNull(self.collider2) then
    self.collider2.onPointerClick = nil
  end
  if IsNotNull(self.boss_collider) then
    self.boss_collider.onPointerClick = nil
  end
  if IsNotNull(self.declareWarBtn) then
    self.declareWarBtn.onPointerClick = nil
  end
  if IsNotNull(self.lodIconCollider) then
    self.lodIconCollider.onPointerClick = nil
  end
  self.open_tips_node:SetActive(false)
  if self.theHelpBubble then
    self.theHelpBubble:Delete()
    self.theHelpBubble = nil
  end
  if self.kingOccupyRoot then
    self.kingOccupyRoot:Delete()
    self.kingOccupyRoot = nil
  end
  if self.strongholdOccupyRoot then
    self.strongholdOccupyRoot:Delete()
    self.strongholdOccupyRoot = nil
  end
  if self.landlordOccupyRoot then
    self.landlordOccupyRoot:Delete()
    self.landlordOccupyRoot = nil
  end
  if self.crossKingOccupyRoot then
    self.crossKingOccupyRoot:Delete()
    self.crossKingOccupyRoot = nil
  end
  if self.crossKingResultRoot then
    self.crossKingResultRoot:Delete()
    self.crossKingResultRoot = nil
  end
  if self.battleLod45Root then
    self.battleLod45Root:Delete()
    self.battleLod45Root = nil
  end
  if self.cityCannonLogic then
    self.cityCannonLogic:Delete()
    self.cityCannonLogic = nil
  end
  if self.tradeStationTipLogicRoot then
    self.tradeStationTipLogicRoot:Delete()
    self.tradeStationTipLogicRoot = nil
  end
  if self.resetFirstHeadLogic then
    self.resetFirstHeadLogic:Delete()
    self.resetFirstHeadLogic = nil
  end
  if self.allianceWarTimeHud then
    self.allianceWarTimeHud:Delete()
    self.allianceWarTimeHud = nil
  end
  if self.cityAltarTipLogic then
    self.cityAltarTipLogic:Delete()
    self.cityAltarTipLogic = nil
  end
  if self.allianceReinforce then
    self.allianceReinforce:Delete()
    self.allianceReinforce = nil
  end
  if self.assistanceRoot then
    self.assistanceRoot:Delete()
    self.assistanceRoot = nil
  end
  if self.theOutpostRoot then
    self.theOutpostRoot:Delete()
    self.theOutpostRoot = nil
  end
  if self.theOutpostCampRoot then
    self.theOutpostCampRoot:Delete()
    self.theOutpostCampRoot = nil
  end
  if self.CityGuideEffectTime then
    self.CityGuideEffectTime:Stop()
    self.CityGuideEffectTime = nil
  end
  if self.CityGuideEffect then
    self.CityGuideEffect:Delete()
    self.CityGuideEffect = nil
  end
  self.collider1 = nil
  self.lodIconCollider = nil
  self.collider2 = nil
  self.boss_collider = nil
  self.declareWar = nil
  self.statusLayout = nil
  self.virus_node = nil
  self.declareWarList = nil
  self:DeleteTimer()
  self.timer_action = nil
  self.timer = nil
  self.city_head = nil
  self.quality_icon = nil
  self.head_icon = nil
  self.oldArmy = nil
  self.oldHp = nil
  self.bg2 = nil
  self.build_slider = nil
  self.build_blood_num = nil
  self.add_text = nil
  if self.addTextAni then
    self.addTextAni:Kill()
    self.addTextAni = nil
  end
  self.preValue = nil
  self.gameObject = nil
  self.transform = nil
  self.headIconName = nil
  self.checkAdapt = nil
  if self.resetHpRoot then
    self.resetHpRoot:Delete()
    self.resetHpRoot = nil
  end
  if self.__update_handle then
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
  end
  self.isInitName = nil
end

function AllianceCityTip:ShowCityGuideNode()
  if self.CityGuideEffect then
    self.CityGuideEffect:SetActive(true)
  else
    local effectPath = "Assets/Main/SeasonRes/Shared/Prefabs/World/WorldGuideArrow.prefab"
    self.CityGuideEffect = UIAsyncNode.New("CityGuideEffect", self.name_spr.transform, effectPath, function(go)
      if IsNotNull(go) then
        go.transform:Set_localPosition(0, 1, 0)
        go.transform:Set_localScale(1, 1, 1)
      end
    end)
  end
  if self.CityGuideEffectTime then
    self.CityGuideEffectTime:Stop()
    self.CityGuideEffectTime = nil
  end
  self.CityGuideEffectTime = TimerManager:GetInstance():DelayInvoke(function()
    if self.CityGuideEffect then
      self.CityGuideEffect:SetActive(false)
    end
  end, 3)
end

function AllianceCityTip:OnUpdate()
  if self.checkAdapt and self.head_icon and self.head_icon.sprite and self.head_icon.sprite.name == self.headIconName then
    self.checkAdapt = false
    if self.head_icon.sprite.rect then
      local spriteWidth = self.head_icon.sprite.rect.width
      local r = headIconNormalSize / spriteWidth
      local newScale = r * headIconScale
      self.head_icon.gameObject.transform:Set_localScale(newScale, newScale, newScale)
    end
  end
end

function AllianceCityTip:OnPointOutView()
  if self.strongholdOccupyRoot then
    self.strongholdOccupyRoot:OnPointOutView()
  end
  if self.landlordOccupyRoot then
    self.landlordOccupyRoot:OnPointOutView()
  end
  if self.allianceWarTimeHud then
    self.allianceWarTimeHud:OnPointOutView()
  end
  if self.allianceReinforce then
    self.allianceReinforce:OnPointOutView()
  end
  if self.cityAltarTipLogic then
    self.cityAltarTipLogic:OnPointOutView()
  end
end

function AllianceCityTip:UpdateProtectedTime(protectTime)
  if self.openTime ~= nil and protectTime ~= nil and protectTime ~= 0 then
    protectTime = math.max(toInt(self.openTime), toInt(protectTime))
    local nCurTime = UITimeManager:GetInstance():GetServerTime()
    if protectTime > nCurTime then
      self.openTime = protectTime
      self.open_tips_node:SetActive(self.lodCache < 3)
      self:TimerAction()
      self:AddTimer()
      return
    end
  end
  if self.openTime == nil and protectTime ~= nil and protectTime ~= 0 then
    local nCurTime = UITimeManager:GetInstance():GetServerTime()
    if protectTime > nCurTime then
      self.openTime = protectTime
      self.open_tips_node:SetActive(self.lodCache < 3)
      self:TimerAction()
      self:AddTimer()
      return
    end
  end
  self.openTime = nil
  self.open_tips_node:SetActive(false)
  self:DeleteTimer()
end

function AllianceCityTip:OnPointDateUpdate()
  local data = self.data
  local cityType = data.type
  ProfilerUtil.BeginSample("AllianceCityTip:OnPointDateUpdate " .. cityType)
  local curTimeSeconds = UITimeManager:GetInstance():GetServerSeconds()
  local cityId = tonumber(data.id)
  local curServerId = data:GetCurServerId()
  self.openTime = nil
  self.serverId = curServerId
  self.pointId = data:GetPointId()
  self.assistanceRoot:UpdateCityInfo()
  self.assistanceRoot:UpdateAssistanceInfo()
  local thePointInfo = self.assistanceRoot.thePointInfo
  local extraInfo = self.assistanceRoot.theExtraInfo
  if self.kingOccupyRoot then
    self.kingOccupyRoot:UpdateCityInfo()
    self.isCrossServerThrone = self.kingOccupyRoot.isCrossServerThrone
  else
    self.isCrossServerThrone = self.assistanceRoot.isCrossServerThrone
  end
  if self.isKingCity then
    if self.kingOccupyRoot == nil then
      local theKingBattleLogic = require("DataCenter.AllianceCityTip.KingBattle.ActivityKingBattleLogic")
      self.kingOccupyRoot = theKingBattleLogic.New(self.gameObject)
    end
    self.kingOccupyRoot:ReInit(data)
    self.kingOccupyRoot:UpdateCityInfo()
  end
  if self.isCrossServerThrone then
    if self.crossKingOccupyRoot == nil then
      local theCrossKingBattleLogic = require("DataCenter.AllianceCityTip.KingBattle.ActivityCrossKingBattleLogic")
      self.crossKingOccupyRoot = theCrossKingBattleLogic.New(self.gameObject)
    end
    if self.crossKingResultRoot == nil then
      local theCrossKingBattleResult = require("DataCenter.AllianceCityTip.KingBattle.ActivityCrossKingBattleResult")
      self.crossKingResultRoot = theCrossKingBattleResult.New(self.gameObject)
    end
    self.crossKingOccupyRoot:ReInit(data)
    self.crossKingResultRoot:ReInit(data)
  end
  if cityType == WorldAllianceCityType.City or cityType == WorldAllianceCityType.King or cityType == WorldAllianceCityType.Stronghold or cityType == WorldAllianceCityType.Canon then
    self:RefreshVirus()
  end
  if self.cityType == WorldAllianceCityType.CrossZoneOutpost then
    if thePointInfo ~= nil and thePointInfo.battleStartTime ~= nil then
      local viewSeasonType = SeasonUtil.GetSeasonType(false, true, ServerEnum.View)
      local now = UITimeManager:GetInstance():GetServerTime()
      local battleStartTime = toInt(thePointInfo.battleStartTime)
      local max_battle_time = DataCenter.SeasonOutpostManager:TryGetNum("k1", 3600) * 1000
      if now >= battleStartTime and now < battleStartTime + max_battle_time then
        self.openTime = nil
        if viewSeasonType == SeasonMapType.NineNationRainforest then
          if self.theOutpostCampRoot == nil then
            local OutpostCampBattleLogic = require("DataCenter.AllianceCityTip.Season.ActivityOutpostCampBattleLogic")
            local prefabPath = "Assets/Main/Prefabs/UI/LWSeasonShared/OutpostOccupyCamp.prefab"
            self.theOutpostCampRoot = OutpostCampBattleLogic.New(self, self.transform, prefabPath)
            self.theOutpostCampRoot:ReInit(self.cityId, self.serverId, thePointInfo, data, battleStartTime + max_battle_time)
          end
          self.theOutpostCampRoot:SetLod(self.lodCache)
        elseif viewSeasonType == SeasonMapType.NineNation then
          if self.theOutpostRoot == nil then
            local OutpostBattleLogic = require("DataCenter.AllianceCityTip.Season.ActivityOutpostBattleLogic")
            local prefabPath = "Assets/Main/Prefabs/UI/LWSeasonShared/OutpostOccupy.prefab"
            self.theOutpostRoot = OutpostBattleLogic.New(self, self.transform, prefabPath)
            self.theOutpostRoot:ReInit(self.cityId, self.serverId, thePointInfo, data, battleStartTime + max_battle_time)
          end
          self.theOutpostRoot:SetLod(self.lodCache)
        end
        self:UpdateProtectedTime(0)
      else
        if self.theOutpostRoot ~= nil then
          self.theOutpostRoot:Delete()
          self.theOutpostRoot = nil
        end
        if self.theOutpostCampRoot ~= nil then
          self.theOutpostCampRoot:Delete()
          self.theOutpostCampRoot = nil
        end
        self:UpdateProtectedTime(math.max(battleStartTime, toInt(thePointInfo.protectTime)))
      end
    else
      if self.theOutpostRoot ~= nil then
        self.theOutpostRoot:Delete()
        self.theOutpostRoot = nil
      end
      if self.theOutpostCampRoot ~= nil then
        self.theOutpostCampRoot:Delete()
        self.theOutpostCampRoot = nil
      end
    end
    self.showHp = false
    self.hpNode:SetActive(false)
    self.statusLayout.gameObject:SetActive(false)
  elseif cityType == WorldAllianceCityType.CrossZoneOutpostCanon then
    self.openTime = nil
    self:TimerAction()
  elseif cityType == WorldAllianceCityType.MissileFactory then
    self.openTime = nil
    self:TimerAction()
    if self.crossKingOccupyRoot then
      self.crossKingOccupyRoot:OnPointDateUpdate()
    end
    if self.battleLod45Root then
      self.battleLod45Root:OnPointDateUpdate()
    end
  elseif cityType == WorldAllianceCityType.Canon then
    self.openTime = nil
    self:TimerAction()
    if self.crossKingOccupyRoot then
      self.crossKingOccupyRoot:OnPointDateUpdate()
    end
    if self.battleLod45Root then
      self.battleLod45Root:OnPointDateUpdate()
    end
    if self.cityCannonLogic then
      self.cityCannonLogic:OnPointDateUpdate()
    end
  elseif cityType == WorldAllianceCityType.Stronghold then
    if extraInfo ~= nil and extraInfo.protectTime and curTimeSeconds < extraInfo.protectTime then
      self.openTime = extraInfo.protectTime * 1000
      DataCenter.AllianceCityTipManager:SetProtectedTime(curServerId, cityId, self.openTime)
    else
      local protectTime = DataCenter.AllianceCityTipManager:GetProtectedTime(curServerId, cityId)
      if protectTime ~= nil and protectTime ~= 0 and curTimeSeconds < protectTime * 0.001 then
        self.openTime = protectTime
      end
    end
    if self.openTime == nil then
      self.open_tips_node:SetActive(false)
      self:DeleteTimer()
    else
      self.open_tips_node:SetActive(self.lodCache < 3)
      self:TimerAction()
      self:AddTimer()
    end
    if self.strongholdOccupyRoot then
      self.strongholdOccupyRoot:OnPointDateUpdate()
    end
    if self.allianceWarTimeHud then
      self.allianceWarTimeHud:OnPointDateUpdate()
    end
    self:OnStrongholdBattleStateUpdate()
  elseif cityType == WorldAllianceCityType.Altar then
    if self.cityAltarTipLogic then
      self.cityAltarTipLogic:OnPointDateUpdate()
    end
    if extraInfo ~= nil then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime < checknumber(extraInfo.battleStartTime) then
        self.openTime = checknumber(extraInfo.battleStartTime)
      end
    else
      local protectTime = DataCenter.AllianceCityTipManager:GetProtectedTime(curServerId, cityId)
      if protectTime ~= nil and protectTime ~= 0 and curTimeSeconds < protectTime * 0.001 then
        self.openTime = protectTime
      end
    end
    if self.openTime == nil then
      self.open_tips_node:SetActive(false)
      self:DeleteTimer()
    else
      self.open_tips_node:SetActive(self.lodCache < 3)
      self:TimerAction()
      self:AddTimer()
    end
    self:OnStrongholdBattleStateUpdate()
  elseif cityType == WorldAllianceCityType.TradingStation then
    if self.tradeStationTipLogicRoot then
      self.tradeStationTipLogicRoot:OnPointDateUpdate()
    end
    if extraInfo ~= nil then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime < extraInfo.battleStartTime then
        self.openTime = extraInfo.battleStartTime
      end
    else
      local protectTime = DataCenter.AllianceCityTipManager:GetProtectedTime(curServerId, cityId)
      if protectTime ~= nil and protectTime ~= 0 and curTimeSeconds < protectTime * 0.001 then
        self.openTime = protectTime
      end
    end
    if self.openTime == nil then
      self.open_tips_node:SetActive(false)
      self:DeleteTimer()
    else
      self.open_tips_node:SetActive(self.lodCache < 3)
      self:TimerAction()
      self:AddTimer()
    end
    self:OnStrongholdBattleStateUpdate()
  elseif cityType == WorldAllianceCityType.GoldTree or cityType == WorldAllianceCityType.Mountain then
    self.openTime = nil
    self:TimerAction()
  elseif cityType == WorldAllianceCityType.LLNormalCity or cityType == WorldAllianceCityType.LLThroneCity then
    if thePointInfo then
      local curClientState = thePointInfo.curClientState
      self:SetSpeNodeStatus(self.name_spr, curClientState ~= LLConst.LLBuildingState.Ruins and curClientState ~= LLConst.LLBuildingState.Exploding)
      self:SetSpeNodeStatus(self.level_spr, curClientState ~= LLConst.LLBuildingState.Ruins and curClientState ~= LLConst.LLBuildingState.Exploding)
      self:SetAllianceColor(self.cityId)
      if self.landlordOccupyRoot then
        self.landlordOccupyRoot:OnPointDateUpdate()
      end
    end
  else
    if cityType == WorldAllianceCityType.City then
      if self.resetFirstHeadLogic then
        self.resetFirstHeadLogic:OnPointDateUpdate()
      end
      self:RefreshHpBar(true)
      self.allianceWarTimeHud:OnPointDateUpdate()
      self.allianceReinforce:OnPointDateUpdate()
    end
    if extraInfo == nil then
      local cityWarInfo = DataCenter.WorldAllianceCityDataManager:GetCityWarInfo(curServerId)
      if cityWarInfo ~= nil and cityWarInfo.noOpenList then
        local cityInfo = cityWarInfo.noOpenList[cityId]
        if cityInfo ~= nil and cityInfo.openTime ~= nil then
          self.openTime = cityInfo.openTime
        end
        if cityWarInfo.nextOpen then
          self.nextOpenCityLevel = toInt(cityWarInfo.nextOpen.level)
        end
      end
      if self.openTime == nil then
        local protectTime = DataCenter.AllianceCityTipManager:GetProtectedTime(curServerId, cityId)
        if protectTime ~= nil and protectTime ~= 0 and curTimeSeconds < protectTime * 0.001 then
          self.openTime = protectTime
        end
      end
    elseif extraInfo ~= nil and not data:IsThroneCity() then
      if extraInfo.openTime and curTimeSeconds < extraInfo.openTime then
        self.openTime = extraInfo.openTime * 1000
      elseif extraInfo.protectTime and curTimeSeconds < extraInfo.protectTime then
        self.openTime = extraInfo.protectTime * 1000
      end
    end
    if self.openTime ~= nil then
      self.open_tips_node:SetActive(self.lodCache < 3)
      self:TimerAction()
      self:AddTimer()
    end
  end
  if data:IsThroneCity() and extraInfo ~= nil then
    local state = extraInfo.state
    local timeOpen = extraInfo.openTime or 0
    local timeEnd = extraInfo.protectTime or 0
    local need_effect = false
    if not self.isCrossServerThrone and not LuaEntry.Player:IsInSourceServer() then
      if curTimeSeconds < timeOpen then
        need_effect = true
        self.openTime = timeOpen * 1000
        self.open_tips_node:SetActive(self.lodCache < 3)
        self:TimerAction()
        self:AddTimer()
      else
        self.openTime = nil
        self.open_tips_node:SetActive(false)
        self:DeleteTimer()
      end
    else
      if curTimeSeconds > timeOpen and curTimeSeconds < timeEnd then
        self.openTime = nil
        self.open_tips_node:SetActive(false)
        self:DeleteTimer()
      elseif curTimeSeconds < timeOpen then
        need_effect = true
        self.openTime = timeOpen * 1000
        self.open_tips_node:SetActive(self.lodCache < 3)
        DataCenter.AllianceCityTipManager:SetProtectedTime(curServerId, cityId, self.openTime)
        self:TimerAction()
        self:AddTimer()
      elseif curTimeSeconds > timeEnd then
        need_effect = true
        self.openTime = nil
        self.open_tips_node:SetActive(false)
        self:DeleteTimer()
      else
        local activityServerData = DataCenter.GovernmentManager.activityServerData
        if activityServerData ~= nil and activityServerData.actFightStep == 2 and curTimeSeconds < timeEnd then
          need_effect = true
          self.openTime = timeEnd * 1000
          self.open_tips_node:SetActive(self.lodCache < 3)
          self:TimerAction()
          self:AddTimer()
        end
      end
      local kingCityPosIndex = data:GetPointId()
      local kingUuid = kingCityPosIndex
      if thePointInfo then
        kingUuid = thePointInfo.uuid
        if need_effect or state == AllianceCityState.OCCUPIED or state == AllianceCityState.SERVER_OCCUPIED or timeOpen == 0 and timeEnd == 0 then
          CityDomeProtectEffectManager:GetInstance():ShowBuildProtectEffect(kingUuid, kingCityPosIndex, curTimeSeconds + 36000, 7, WorldAllianceBuildUtil.GetKingDomeShellEffPath(), nil, self:GetPointModelParent(kingCityPosIndex), 5)
        elseif curTimeSeconds < timeOpen then
          CityDomeProtectEffectManager:GetInstance():ShowBuildProtectEffect(kingUuid, kingCityPosIndex, timeOpen, 7, WorldAllianceBuildUtil.GetKingDomeShellEffPath(), nil, self:GetPointModelParent(kingCityPosIndex), 5)
        else
          CityDomeProtectEffectManager:GetInstance():RemoveBuildProtectEffect(kingUuid)
        end
      end
    end
    if self.kingOccupyRoot then
      self.kingOccupyRoot:OnPointDateUpdate()
    end
    if self.crossKingResultRoot then
      self.crossKingResultRoot:OnPointDateUpdate()
    end
    if self.crossKingOccupyRoot then
      self.crossKingOccupyRoot:OnPointDateUpdate()
    end
    if self.battleLod45Root then
      self.battleLod45Root:OnPointDateUpdate()
    end
  end
  self:UpdateLodIcon()
  self.isShowNuCelearBuildTip = false
  if DataCenter.SeasonNuclearPowerPlantDataManager:BuildNuclearPowerBtnOpen() and self.isKingCity and not self.isCrossServerThrone then
    self.isShowNuCelearBuildTip = true
    self.bg2:SetActive(self.lodCache < 3)
    self:OnNuclearBuildDataUpdate()
    self.add_text.gameObject:SetActive(false)
  else
    self.bg2:SetActive(false)
  end
  ProfilerUtil.EndSample()
end

function AllianceCityTip:GetPointModelParent(pointId)
  local effectParentNode
  local obj = CS.SceneManager.World:GetObjectByPoint(pointId)
  if obj then
    local rootObj = obj:GetGameObject()
    if rootObj then
      effectParentNode = rootObj.transform:Find("Model")
    end
  end
  return effectParentNode
end

function AllianceCityTip:OnWorldAllianceCityDetail()
  if self.strongholdOccupyRoot then
    self.strongholdOccupyRoot:OnWorldAllianceCityDetail()
  end
  if self.landlordOccupyRoot then
    self.landlordOccupyRoot:OnWorldAllianceCityDetail()
  end
  if self.kingOccupyRoot then
    self.kingOccupyRoot:OnWorldAllianceCityDetail()
  end
  if self.crossKingOccupyRoot then
    self.crossKingOccupyRoot:OnWorldAllianceCityDetail()
  end
  if self.crossKingResultRoot then
    self.crossKingResultRoot:OnWorldAllianceCityDetail()
  end
  if self.battleLod45Root then
    self.battleLod45Root:OnWorldAllianceCityDetail()
  end
  if self.cityAltarTipLogic then
    self.cityAltarTipLogic:OnWorldAllianceCityDetail()
  end
  if self.theOutpostRoot then
    self.theOutpostRoot:OnWorldAllianceCityDetail()
  end
  if self.theOutpostCampRoot then
    self.theOutpostCampRoot:OnWorldAllianceCityDetail()
  end
  self.allianceWarTimeHud:OnWorldAllianceCityDetail()
  self.allianceReinforce:OnWorldAllianceCityDetail()
end

function AllianceCityTip:OnKingOccupyProgressRefresh()
  if self.strongholdOccupyRoot then
    self.strongholdOccupyRoot:OnKingOccupyProgressRefresh()
  end
  if self.kingOccupyRoot then
    self.kingOccupyRoot:OnKingOccupyProgressRefresh()
  end
  if self.crossKingOccupyRoot then
    self.crossKingOccupyRoot:OnKingOccupyProgressRefresh()
  end
  if self.crossKingResultRoot then
    self.crossKingResultRoot:OnKingOccupyProgressRefresh()
  end
  if self.battleLod45Root then
    self.battleLod45Root:OnKingOccupyProgressRefresh()
  end
  if self.cityAltarTipLogic then
    self.cityAltarTipLogic:OnKingOccupyProgressRefresh()
  end
  self.allianceWarTimeHud:OnKingOccupyProgressRefresh()
  self.allianceReinforce:OnKingOccupyProgressRefresh()
end

function AllianceCityTip:OnClick()
  GoToUtil.GotoPos(self.transform.position, 23, 0.3, nil, self.serverId)
end

function AllianceCityTip:OnClickLod()
  GoToUtil.GotoPos(self.transform.position, 200, 0.3, nil, self.serverId)
end

function AllianceCityTip:SetData(data, lod)
  local curServerId = LuaEntry.Player:GetCurServerId()
  local info = SeasonUtil.GetSeasonInfo(curServerId)
  self.data = data
  self.lodCache = lod or 1
  self.isKingCity = data:IsThroneCity()
  self.cityId = toInt(self.data.id)
  self.cityType = toInt(self.data.type)
  self.bigMapIndex = toInt(self.data.bigMapIndex)
  self.serverId = self.data:GetCurServerId()
  self:SetAllianceColor(data.id)
  self.allianceWarTimeHud:ReInit(data)
  self.allianceReinforce:ReInit(data)
  self.assistanceRoot:ReInit(data)
  self.assistanceRoot:UpdateCityInfo()
  self.assistanceRoot:UpdateAssistanceInfo()
  self.cityAltarTipLogic:ReInit(data)
  self.cityAltarTipLogic:UpdateCityInfo()
  self.isCrossServerThrone = self.assistanceRoot.isCrossServerThrone
  if self.cityType == WorldAllianceCityType.Canon or self.cityType == WorldAllianceCityType.MissileFactory or self.cityType == WorldAllianceCityType.CrossZoneOutpostCanon then
    self:SetSpeNodeStatus(self.name_spr, false)
    self:SetSpeNodeStatus(self.level_spr, false)
    if self.cityType == WorldAllianceCityType.Canon then
      if self.cityCannonLogic == nil then
        local theCityCannonLogic = require("DataCenter.AllianceCityTip.Season.CityCannonLogic")
        self.cityCannonLogic = theCityCannonLogic.New(self.gameObject)
      end
      self.cityCannonLogic:ReInit(data)
    end
  elseif self.cityType == WorldAllianceCityType.LLThroneCity or self.cityType == WorldAllianceCityType.LLNormalCity then
    local thePointInfo = self.assistanceRoot.thePointInfo
    if thePointInfo then
      local curClientState = thePointInfo.curClientState
      local showIt = curClientState ~= LLConst.LLBuildingState.Ruins and curClientState ~= LLConst.LLBuildingState.Exploding
      self:SetSpeNodeStatus(self.name_spr, showIt)
      self:SetSpeNodeStatus(self.level_spr, showIt)
    else
      self:SetSpeNodeStatus(self.name_spr, false)
      self:SetSpeNodeStatus(self.level_spr, false)
    end
  else
    self:SetSpeNodeStatus(self.name_spr, true)
    self:SetSpeNodeStatus(self.level_spr, true)
    self:SetName(data.id)
  end
  if self.isKingCity or data.type == WorldAllianceCityType.Canon or data.type == WorldAllianceCityType.MissileFactory then
    if self.battleLod45Root == nil then
      local theCityBattleLod45 = require("DataCenter.AllianceCityTip.KingBattle.ActivityCityBattleLod45")
      self.battleLod45Root = theCityBattleLod45.New(self.gameObject)
    end
    self.battleLod45Root:ReInit(data)
  end
  if data.type == WorldAllianceCityType.Stronghold or data.type == WorldAllianceCityType.Altar then
    self.level_text.color32 = Color32.New(255, 255, 255, 255)
    self.level_spr:LoadSprite("Assets/Main/Sprites/LodIcon/stronghold_level.png")
  else
    self.level_text.color32 = Color32.New(255, 255, 255, 255)
    if DataCenter.ActMigrationManager:IsNBServer() then
      self.level_spr:LoadSprite("Assets/Main/Sprites/LodIcon/mjc_alliancecity_level_qiangfu.png")
    else
      self.level_spr:LoadSprite("Assets/Main/Sprites/LodIcon/alliancecity_level.png")
    end
  end
  if self.cityType == WorldAllianceCityType.TradingStation then
    if self.tradeStationTipLogicRoot == nil then
      local TradeStationTipLogic = require("DataCenter.AllianceCityTip.Season.TradeStation.ActivityTradeStationTipLogic")
      self.tradeStationTipLogicRoot = TradeStationTipLogic.New(self.gameObject)
    end
    self.tradeStationTipLogicRoot:ReInit(data)
  end
  if self.cityType == WorldAllianceCityType.City then
    if self.resetFirstHeadLogic == nil then
      local theCityTipResetFirstHeadLogic = require("DataCenter.AllianceCityTip.AllianceCityTipResetFirstHeadLogic")
      self.resetFirstHeadLogic = theCityTipResetFirstHeadLogic.New(self.gameObject)
    end
    self.resetFirstHeadLogic:ReInit(data)
    if self.resetHpRoot == nil then
      local theCityTipResetHpComp = require("DataCenter.AllianceCityTip.AllianceCityTipResetHpComp")
      self.resetHpRoot = theCityTipResetHpComp.New(self.gameObject)
    end
    self.resetHpRoot:ReInit(data)
  end
  if self.data and (self.data.type == WorldAllianceCityType.Stronghold or self.data.type == WorldAllianceCityType.Altar) then
    if self.strongholdOccupyRoot == nil then
      local theCityStrongholdLogic = require("DataCenter.AllianceCityTip.Season.ActivityCityStrongholdLogic")
      self.strongholdOccupyRoot = theCityStrongholdLogic.New(self.gameObject)
    end
    self.strongholdOccupyRoot:ReInit(data)
  end
  if self.data and (self.data.type == WorldAllianceCityType.LLNormalCity or self.data.type == WorldAllianceCityType.LLThroneCity) then
    if self.landlordOccupyRoot == nil then
      local LandlordCityLogic = require("DataCenter.AllianceCityTip.LandlordBattle.LandlordCityLogic")
      self.landlordOccupyRoot = LandlordCityLogic.New(self.gameObject)
    end
    self.landlordOccupyRoot:ReInit(data)
  end
  self:SetLevel(data.level)
  self:SetTilePos(data.pos)
  self:OnPointDateUpdate()
  self:CheckBossData()
  self:CheckCityDeclare()
  self:InitHpBar()
  self:OnStrongholdBattleStateUpdate()
  self:RefreshVirus()
  self:RefreshBloodQueenBattleEffect()
  self:SetLod(lod, true)
end

function AllianceCityTip:SetAllianceColor(cityId)
  local pic = "Assets/Main/Sprites/LodIcon/alliancecity_name_gray.png"
  local cityData = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId)
  if cityData ~= nil then
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    local curServerId = LuaEntry.Player:GetCurServerId()
    local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
    local theKey = "season_map_zone_mode"
    local theDefaultValue = false
    if self.seasonType == SeasonMapType.NineNationRainforest and seasonInfo:IsInBattleServerGroupInt(mySourceServerId) then
      theKey = "season6_map_zone_mode"
      theDefaultValue = true
    end
    local activeSkinColor = skinColorServerStr ~= nil and skinColorServerStr ~= "" and self.serverId ~= nil and Setting:GetPrivateBool(theKey, theDefaultValue) and string.match(skinColorServerStr, ";" .. self.serverId .. ";")
    if activeSkinColor then
      if cityData.allianceId == LuaEntry.Player.allianceId and skinColorList2 ~= nil and skinColorList2[2] ~= nil then
        pic = "Assets/Main/Sprites/LodIcon/alliancecity_name_green.png"
        self.name_spr:LoadSprite(pic)
        return
      end
      if cityData.occupyServerId == nil or cityData.occupyServerId == 0 then
        if skinColorList5 ~= nil and skinColorList5[2] ~= nil then
          pic = "Assets/Main/Sprites/LodIcon/alliancecity_name_gray.png"
          self.name_spr:LoadSprite(pic)
          return
        end
      elseif self.seasonType == SeasonMapType.NineNationRainforest and theKey == "season6_map_zone_mode" then
        if DataCenter.SeasonFactionWarDataManager:IsInSameCampByServer(cityData.occupyServerId, mySourceServerId) then
          if skinColorList3 ~= nil and skinColorList3[2] ~= nil then
            pic = "Assets/Main/Sprites/LodIcon/alliancecity_name_blue.png"
            self.name_spr:LoadSprite(pic)
            return
          end
        elseif skinColorList4 ~= nil and skinColorList4[2] ~= nil then
          pic = "Assets/Main/Sprites/LodIcon/alliancecity_name_red.png"
          self.name_spr:LoadSprite(pic)
          return
        end
      elseif cityData.occupyServerId == mySourceServerId then
        if skinColorList3 ~= nil and skinColorList3[2] ~= nil then
          pic = "Assets/Main/Sprites/LodIcon/alliancecity_name_blue.png"
          self.name_spr:LoadSprite(pic)
          return
        end
      elseif skinColorList4 ~= nil and skinColorList4[2] ~= nil then
        pic = "Assets/Main/Sprites/LodIcon/alliancecity_name_red.png"
        self.name_spr:LoadSprite(pic)
        return
      end
      return
    end
    if cityData.allianceId == nil or cityData.allianceId == "" then
      if cityData.isCityStronghold then
        pic = "Assets/Main/Sprites/LodIcon/stronghold_name_gray.png"
      else
        pic = "Assets/Main/Sprites/LodIcon/alliancecity_name_gray.png"
      end
    elseif cityData.isCityStronghold then
      if cityData.allianceId == LuaEntry.Player.allianceId then
        pic = "Assets/Main/Sprites/LodIcon/stronghold_name_blue.png"
      else
        pic = "Assets/Main/Sprites/LodIcon/stronghold_name_red.png"
      end
    elseif cityData.allianceId == LuaEntry.Player.allianceId then
      pic = "Assets/Main/Sprites/LodIcon/alliancecity_name_blue.png"
    elseif cityData:IsServerOccupied() then
      pic = "Assets/Main/Sprites/LodIcon/alliancecity_name_green.png"
    else
      pic = "Assets/Main/Sprites/LodIcon/alliancecity_name_red.png"
    end
  elseif self.cityType == WorldAllianceCityType.LLNormalCity or self.cityType == WorldAllianceCityType.LLThroneCity then
    local thePointInfo = self.assistanceRoot.thePointInfo
    if thePointInfo then
      local myCampId = DataCenter.LandlordMgr:GetMyGroup()
      if myCampId == LLConst.LandLordGroup.NONE or thePointInfo.tmpOwnerCampId == LLConst.LandLordGroup.NONE then
        pic = "Assets/Main/Sprites/LodIcon/alliancecity_name_gray.png"
      elseif thePointInfo.tmpOwnerCampId == myCampId then
        pic = "Assets/Main/Sprites/LodIcon/alliancecity_name_blue.png"
      else
        pic = "Assets/Main/Sprites/LodIcon/alliancecity_name_red.png"
      end
    end
  end
  self.name_spr:LoadSprite(pic)
end

function AllianceCityTip:SetName(cityId)
  if IsNull(self.name_text) then
    return
  end
  if self.name_text.gameObject.activeSelf then
    self.isInitName = true
  end
  local name = Localization:GetString(self.data.name)
  local cityName = name
  local showHead = false
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local defaultOwner
  local cityInfo = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(cityId)
  if self.cityType == WorldAllianceCityType.CrossZoneOutpost and DataCenter.ActivityListDataManager:GetOneOpenActivityByType(EnumActivity.SeasonWarZoneOutpostFix.Type) ~= nil then
    defaultOwner = SeasonUtil.GetOutpostDefaultOwner(cityId)
  end
  if cityInfo then
    local occupyServerId = cityInfo.occupyServerId
    if cityInfo.cityName ~= nil and cityInfo.cityName ~= "" then
      name = cityInfo.cityName
      cityName = cityInfo.cityName
    end
    if cityInfo.abbr ~= nil and cityInfo.abbr ~= "" then
      if mySourceServerId == occupyServerId and LuaEntry.Player:AtHomeNow() then
        name = UIUtil.FormatAllianceAndName(cityInfo.abbr, name)
      else
        name = UIUtil.FormatServerAllianceName(occupyServerId, cityInfo.abbr, name)
      end
    elseif cityInfo:IsServerOccupied() and not string.IsNullOrEmpty(cityInfo.allianceName) then
      name = string.format("[%s]%s", cityInfo.allianceName, name)
    else
      showHead = true
      if defaultOwner ~= nil and defaultOwner ~= 0 then
        name = UIUtil.FormatServerAllianceName(defaultOwner, nil, name)
      end
    end
  else
    showHead = true
    if defaultOwner ~= nil and defaultOwner ~= 0 then
      name = UIUtil.FormatServerAllianceName(defaultOwner, nil, name)
    end
  end
  if self.cityType == WorldAllianceCityType.LLNormalCity then
    name = self.data.name
  elseif self.cityType == WorldAllianceCityType.LLThroneCity then
    name = Localization:GetString(self.data.name)
  end
  if showHead and self.data.type ~= 1 then
    showHead = false
  end
  local cfg_head_icon_path = self.data.head_icon
  if showHead and not string.IsNullOrEmpty(cfg_head_icon_path) then
    if string.sub(cfg_head_icon_path, 1, 7) == "Assets/" then
      self.head_icon:LoadSprite(cfg_head_icon_path)
    else
      self.head_icon:LoadSprite(string.format(LoadPath.UIPlayerIcon, cfg_head_icon_path))
    end
    self.quality_icon:LoadSprite("Assets/Main/Sprites/UI/UIRadarCenter/zyf_leida_qipao_cheng")
    self.headIconName = cfg_head_icon_path
    self.checkAdapt = true
    self.showHead = true
  else
    self.showHead = false
  end
  local event = DataCenter.RadarCenterDataManager:GetCityEventDataByPointIndex(self.data:GetPointId())
  if event and event.state == DetectEventState.DETECT_EVENT_STATE_NOT_FINISH then
    if event.template.type == DetectEventType.ScoutDeclareCity then
      self.reward_icon:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_scout.png")
    elseif event.template.type == DetectEventType.ScoutOccupyCity then
      self.reward_icon:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_bossreward.png")
    end
    self.showHead = true
    self.reward_icon.gameObject:SetActive(true)
    self.quality_icon.gameObject:SetActive(false)
  else
    self.reward_icon.gameObject:SetActive(false)
    self.quality_icon.gameObject:SetActive(true)
  end
  if CS.CommonUtils.IsDebug() then
    if Localization:GetLanguage() == Language.ChineseSimplified then
      if self.cityType == WorldAllianceCityType.City then
        name = name .. "\n[\229\159\142\229\184\130]"
      elseif self.cityType == WorldAllianceCityType.Canon then
        name = name .. "\n[\231\130\174\229\161\148]"
      elseif self.cityType == WorldAllianceCityType.King then
        name = name .. "\n[\231\142\139\229\186\167]"
      elseif self.cityType == WorldAllianceCityType.Stronghold then
        name = name .. "\n[\230\141\174\231\130\185]"
      elseif self.cityType == WorldAllianceCityType.TradingStation then
        name = name .. "\n[\232\180\184\230\152\147\231\171\153]"
      elseif self.cityType == WorldAllianceCityType.MissileFactory then
        name = name .. "\n[\233\163\158\229\188\185\229\183\165\229\142\130]"
      elseif self.cityType == WorldAllianceCityType.GoldTree then
        name = name .. "\n[\233\187\132\233\135\145\230\160\145]"
      elseif self.cityType == WorldAllianceCityType.Mountain then
        name = name .. "\n[\229\175\140\229\163\171\229\177\177]"
      elseif self.cityType == WorldAllianceCityType.CrossZoneOutpost then
        name = name .. "\n[\230\136\152\229\140\186\229\137\141\229\147\168\231\171\153]"
      elseif self.cityType == WorldAllianceCityType.CrossZoneOutpostCanon then
        name = name .. "\n[\229\137\141\229\147\168\231\130\174\229\161\148]"
      elseif self.cityType == WorldAllianceCityType.Altar then
        name = name .. "\n[\231\165\173\229\157\155]"
      elseif self.cityType == WorldAllianceCityType.LLNormalCity then
        name = name .. "\n[\233\135\145\232\132\137\229\159\142\229\184\130]"
      elseif self.cityType == WorldAllianceCityType.LLThroneCity then
        name = name .. "\n[\233\135\145\232\132\137\231\142\139\229\186\167]"
      elseif self.cityType == WorldAllianceCityType.LLBuffCity then
        name = name .. "\n[\233\135\145\232\132\137buff\229\187\186\231\173\145]"
      elseif self.cityType == WorldAllianceCityType.LLCanon then
        name = name .. "\n[\233\135\145\232\132\137\231\130\174\229\143\176]"
      end
      if SeasonUtil.InSeasonBigMapMode(self.serverId) then
        name = string.format("\231\172\172%s\229\140\186 %s (id=%s)", self.data.bigMapIndex, name, cityId)
      else
        name = string.format("%s (id=%s)", name, cityId)
      end
    else
      name = string.format("%s(id=%s)", name, cityId)
    end
  end
  self.name_text.text = name
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.name_text.transform)
  local textWidth = self.name_text:GetWidth()
  local s_x, s_y = self.name_spr:Get_size()
  s_x = textWidth + namePadding
  self.name_spr:Set_size(s_x, s_y)
  self.nameTextWidth = textWidth
  local scale_x, scale_y, scale_z = self.collider1.transform:Get_localScale()
  scale_x = textWidth + colliderPadding
  self.collider1.transform:Set_localScale(scale_x, scale_y, scale_z)
  self:UpdateTitleNodeScale()
end

function AllianceCityTip:SetLevel(level)
  if IsNull(self.level_text) then
    return
  end
  self.level_text.text = level
  self.centerLevel_text.text = level
end

function AllianceCityTip:UpdateTitleNodeScale()
  if self.nameTextWidth == nil then
    return
  end
  local textWidth = self.nameTextWidth
  local pos_x = -textWidth * 0.5 - levelOffset
  if self.forSeason then
    if self.lodCache < 3 then
      self.name_spr.transform:Set_localPosition(0, 0, 0)
      if self.tradeStationTipLogicRoot then
        self.assistanceTran:Set_localPosition(-0.04, -0.779, 0)
      elseif self.isKingCity then
        self.assistanceTran:Set_localPosition(-0.04, -0.342, 0)
      else
        self.assistanceTran:Set_localPosition(-0.04, -0.779, 0)
      end
      self.level_spr.transform:Set_localPosition(pos_x, 0, 0)
      self.statusLayout.transform:Set_localPosition(-pos_x, 0.037, 0)
      self.collider1.transform:Set_localPosition(-pos_x, 0.04, 0)
      self.name_spr.transform:Set_localScale(1, 1, 1)
      self.assistanceTran:Set_localScale(0.7, 0.7, 1)
      self.bg2.transform:Set_localScale(1, 1, 1)
      self.level_spr.transform:Set_localScale(1, 1, 1)
      self.statusLayout.transform:Set_localScale(0.8, 0.8, 0.8)
      if GameObjectIsValid(self.eff_battle_stronghold) then
        self.eff_battle_stronghold.transform:Set_localPosition(-pos_x, 0.037, 0)
      end
      if GameObjectIsValid(self.bloodQueenBattleEffect) then
        self.bloodQueenBattleEffect.transform:Set_localPosition(-pos_x, 0.037, 0)
      end
    else
      pos_x = pos_x * 0.6
      self.name_spr.transform:Set_localPosition(0, 0.25, 0)
      self.level_spr.transform:Set_localPosition(pos_x, 0.25, 0)
      self.assistanceTran:Set_localPosition(-0.045, 0.491, 0)
      self.statusLayout.transform:Set_localPosition(-pos_x, 0.26, 0)
      self.collider1.transform:Set_localPosition(-pos_x, 0.26, 0)
      self.name_spr.transform:Set_localScale(0.6, 0.6, 0.6)
      self.assistanceTran:Set_localScale(0.5, 0.5, 1)
      self.bg2.transform:Set_localScale(0.6, 0.6, 0.6)
      self.level_spr.transform:Set_localScale(0.6, 0.6, 0.6)
      self.statusLayout.transform:Set_localScale(0.5, 0.5, 0.5)
      if GameObjectIsValid(self.eff_battle_stronghold) then
        if (self.data.type == WorldAllianceCityType.Stronghold or self.data.type == WorldAllianceCityType.Altar) and self.lodCache > 6 then
          self.eff_battle_stronghold.transform:Set_localPosition(0, 0, 0)
        else
          self.eff_battle_stronghold.transform:Set_localPosition(-pos_x, 0.26, 0)
        end
      end
      if GameObjectIsValid(self.bloodQueenBattleEffect) then
        if self.data.type == WorldAllianceCityType.City and self.lodCache > 6 then
          self.bloodQueenBattleEffect.transform:Set_localPosition(0, 0, 0)
        else
          self.bloodQueenBattleEffect.transform:Set_localPosition(-pos_x, 0.26, 0)
        end
      end
    end
  else
    if self.lodCache < 3 then
      self.name_spr.transform:Set_localPosition(0, 0, 0)
      self.name_spr.transform:Set_localScale(1, 1, 1)
      self.level_spr.transform:Set_localPosition(pos_x, 0, 0)
      self.level_spr.transform:Set_localScale(1, 1, 1)
      self.assistanceTran:Set_localPosition(-0.077, 0.364, 0)
      self.assistanceTran:Set_localScale(0.6, 0.6, 1)
    elseif self.lodCache < 6 then
      pos_x = pos_x * 0.6
      self.name_spr.transform:Set_localPosition(0, 0.25, 0)
      self.name_spr.transform:Set_localScale(0.6, 0.6, 0.6)
      self.level_spr.transform:Set_localPosition(pos_x, 0.25, 0)
      self.level_spr.transform:Set_localScale(0.6, 0.6, 0.6)
      self.assistanceTran:Set_localPosition(-0.077, 0.486, 0)
      self.assistanceTran:Set_localScale(0.5, 0.5, 1)
    else
      self.name_spr.transform:Set_localPosition(0, 0, 0)
      self.name_spr.transform:Set_localScale(1, 1, 1)
      self.level_spr.transform:Set_localPosition(pos_x, 0, 0)
      self.level_spr.transform:Set_localScale(1, 1, 1)
    end
    self.statusLayout.transform:Set_localPosition(-pos_x, 0.037, 0)
    self.collider1.transform:Set_localPosition(-pos_x, 0.04, 0)
    self.bg2.transform:Set_localScale(1, 1, 1)
    self.statusLayout.transform:Set_localScale(0.8, 0.8, 0.8)
  end
end

function AllianceCityTip:UpdateLodIcon()
  self:UpdateTitleNodeScale()
  local showIt = self.cityType ~= WorldAllianceCityType.Canon and self.cityType ~= WorldAllianceCityType.MissileFactory and self.cityType ~= WorldAllianceCityType.CrossZoneOutpostCanon
  if self.cityType == WorldAllianceCityType.LLThroneCity or self.cityType == WorldAllianceCityType.LLNormalCity then
    local thePointInfo = self.assistanceRoot.thePointInfo
    if thePointInfo then
      local curClientState = thePointInfo.curClientState
      local lodShow = self.lodCache < 3
      local stateShow = curClientState ~= LLConst.LLBuildingState.Ruins and curClientState ~= LLConst.LLBuildingState.Exploding and curClientState ~= LLConst.LLBuildingState.WillExplode and curClientState ~= LLConst.LLBuildingState.Rebuilding
      local occupyShow = false
      showIt = stateShow and (occupyShow or lodShow)
    else
      showIt = false
    end
  end
  if maxLod and self.lodCache <= maxLod then
    self.lodIcon:SetActive(false)
    self:SetSpeNodeStatus(self.name_spr, showIt)
    self:SetSpeNodeStatus(self.level_spr, showIt)
    self.city_head:SetActive(self.showHead and not self.showHp)
    return
  end
  if self.lodCache < 3 then
    self.lodIcon:SetActive(false)
    self:SetSpeNodeStatus(self.name_spr, showIt)
    self:SetSpeNodeStatus(self.level_spr, showIt)
    self.city_head:SetActive(self.showHead and not self.showHp)
    return
  end
  self.city_head:SetActive(false)
  if (self.cityType == WorldAllianceCityType.Canon or self.cityType == WorldAllianceCityType.MissileFactory or self.cityType == WorldAllianceCityType.CrossZoneOutpostCanon) and self.lodCache > 5 then
    self.lodIcon:SetActive(false)
    return
  end
  if (self.cityType == WorldAllianceCityType.Stronghold or self.cityType == WorldAllianceCityType.Altar) and self.lodCache > 6 then
    self:SetSpeNodeStatus(self.name_spr, false)
    self:SetSpeNodeStatus(self.level_spr, false)
    self.lodIcon:SetActive(false)
    return
  else
    self:SetSpeNodeStatus(self.name_spr, showIt)
    self:SetSpeNodeStatus(self.level_spr, showIt)
  end
  if not self.forSeason and self.lodCache > 5 then
    self.lodIcon:SetActive(false)
    return
  end
  self.lodIcon.transform:Set_localScale(0.6, 0.6, 0.6)
  if self.lodCache >= 6 then
    self.lodIcon.transform:Set_localPosition(0, 0, 0)
  else
    self.lodIcon.transform:Set_localPosition(0, -0.2, 0)
  end
  local pic
  if self.data and self.data.lod_icon ~= nil and self.data.lod_icon ~= "" then
    pic = self.data.lod_icon
  else
    pic = DataCenter.WorldAllianceCityDataManager:GetAllianceLoadIcon(self.cityId, self.data.type, self.data.level)
  end
  local cityData = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(self.cityId)
  if cityData ~= nil and cityData:IsRuins() and self.data.lod_icon_ruins ~= nil and self.data.lod_icon_ruins ~= "" then
    pic = self.data.lod_icon_ruins
  end
  if DataCenter.LandlordMgr:IsCityWithBoom(self.data.id) then
    local info = self.data:GetPointInfo()
    if info then
      if not DataCenter.LandlordMgr:IsInNewCenterMapPeriod() then
        pic = self.data:IsThroneCity() and self.data.half_boom_icon or self.data.full_boom_icon
      else
        local curClientState = info.curClientState
        local progress = info.progress
        if curClientState == LLConst.LLBuildingState.Ruins then
          pic = self.data.ruins_icon
        elseif curClientState == LLConst.LLBuildingState.WillExplode or curClientState == LLConst.LLBuildingState.Exploding then
          pic = self.data.full_boom_icon
        elseif curClientState == LLConst.LLBuildingState.Rebuilding then
          pic = self.data.lod_icon
        elseif curClientState == LLConst.LLBuildingState.Fighting then
          pic = self.data.lod_icon
        elseif curClientState == LLConst.LLBuildingState.NotOpen or curClientState == LLConst.LLBuildingState.OpenButShield then
          pic = 0 < progress and self.data.half_boom_icon or self.data.lod_icon
        end
      end
    end
  end
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local curServerId = LuaEntry.Player:GetCurServerId()
  local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
  local lodIconColor
  local theKey = "season_map_zone_mode"
  local theDefaultValue = false
  if self.seasonType == SeasonMapType.NineNationRainforest and seasonInfo:IsInBattleServerGroupInt(mySourceServerId) then
    theKey = "season6_map_zone_mode"
    theDefaultValue = true
  end
  local activeSkinColor = skinColorServerStr ~= nil and skinColorServerStr ~= "" and self.serverId ~= nil and Setting:GetPrivateBool(theKey, theDefaultValue) and string.match(skinColorServerStr, ";" .. self.serverId .. ";")
  if activeSkinColor then
    local cityData = DataCenter.WorldAllianceCityDataManager:GetAllianceCityDataByCityId(self.cityId)
    if cityData ~= nil then
      if cityData.allianceId == LuaEntry.Player.allianceId then
        if skinColorList2 ~= nil and skinColorList2[1] ~= nil then
          lodIconColor = UIUtil.HexToColor(skinColorList2[1])
        end
      elseif cityData.occupyServerId == nil or cityData.occupyServerId == 0 then
        if skinColorList5 ~= nil and skinColorList5[1] ~= nil then
          lodIconColor = UIUtil.HexToColor(skinColorList5[1])
        end
      elseif self.seasonType == SeasonMapType.NineNationRainforest and theKey == "season6_map_zone_mode" then
        if DataCenter.SeasonFactionWarDataManager:IsInSameCampByServer(cityData.occupyServerId, mySourceServerId) then
          if skinColorList3 ~= nil and skinColorList3[1] ~= nil then
            lodIconColor = UIUtil.HexToColor(skinColorList3[1])
          end
        elseif skinColorList4 ~= nil and skinColorList4[1] ~= nil then
          lodIconColor = UIUtil.HexToColor(skinColorList4[1])
        end
      elseif cityData.occupyServerId == mySourceServerId then
        if skinColorList3 ~= nil and skinColorList3[1] ~= nil then
          lodIconColor = UIUtil.HexToColor(skinColorList3[1])
        end
      elseif skinColorList4 ~= nil and skinColorList4[1] ~= nil then
        lodIconColor = UIUtil.HexToColor(skinColorList4[1])
      end
    end
  end
  if lodIconColor == nil then
    lodIconColor = DataCenter.WorldAllianceCityDataManager:GetAllianceLodIconColor(self.cityId, self.data.type, self.data:GetPointId(), self.serverId)
  end
  self.lodIconSprite.color = lodIconColor
  self.lodIconSprite:LoadSprite(pic)
  self.lodIcon:SetActive(true)
  if self.lodIconProtect ~= nil then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local showProtect = curTime < toInt(self.openTime) or self.isKingCity and toInt(self.nextOpenCityLevel) == 7
    local scale = 0.8
    local alpha = 1
    if DataCenter.LandlordMgr:IsLandlordCity(self.cityId, self.serverId) then
      local info = self.data:GetPointInfo()
      if info then
        showProtect = info.curClientState == LLConst.LLBuildingState.NotOpen or info.curClientState == LLConst.LLBuildingState.OpenButShield
        if showProtect then
          scale = 1
          alpha = 0.27
        end
      end
    end
    self.lodIconProtect.gameObject:SetActive(showProtect)
    self.lodIconProtect.transform:Set_localScale(scale, scale, scale)
    self:SetIconProtectSprite(alpha)
  end
end

function AllianceCityTip:SetIconProtectSprite(alpha)
  local color = self.lodIconProtectSprite.color
  color.a = alpha
  self.lodIconProtectSprite.color = color
end

function AllianceCityTip:SetTilePos(tilePos)
  local pos = SceneUtils.TileToWorld(tilePos)
  if self.bigMapIndex ~= nil and self.bigMapIndex > 0 then
    local x, y, z = SceneUtils.GetNinePalacesOffsetByIndex(self.bigMapIndex)
    if x ~= nil and z ~= nil then
      pos.x = pos.x + x
      pos.z = pos.z + z
    end
  end
  self:SetPos(pos)
end

function AllianceCityTip:SetPos(pos, offset)
  local t = pos + posOffset
  if offset then
    t = t + offset
  end
  self.OriginalPos = t
  self.transform:Set_position(t.x, t.y, t.z)
  self:TryUpdatePosition()
end

function AllianceCityTip:TryUpdatePosition()
  local t = self.OriginalPos
  if self.transform == nil or t == nil then
    return
  end
  if self.lodCache and self.lodCache < 3 and (self.cityType == WorldAllianceCityType.City or self.cityType == WorldAllianceCityType.King) then
    local theWorld = CS.SceneManager.World
    if theWorld == nil then
      return
    end
    local marchInfo = theWorld:GetMonster(self.pointId)
    if marchInfo ~= nil and marchInfo.uuid ~= nil then
      local monsterId = marchInfo.monsterId
      local monster = DataCenter.MonsterTemplateManager:GetMonsterTemplate(monsterId)
      if monster ~= nil and monster.special == WorldMonsterSpecialType.CityGhostBoss then
        self.transform:Set_position(t.x, 12, t.z)
        return
      end
    end
  end
  self.transform:Set_position(t.x, t.y, t.z)
end

function AllianceCityTip:ShowAllianceFriendsHelpTips(data)
  local cityId = toInt(data.cityId)
  if cityId ~= self.cityId then
    return
  end
  if self.theHelpBubble == nil then
    local bubble = require("DataCenter.AllianceCityTip.Season.AllianceFriendsHelpBubble")
    if bubble then
      local effectPath = "Assets/Main/SeasonRes/S6/Prefabs/UI/Component/AllianceFriendsHelpTip.prefab"
      self.theHelpBubble = bubble.New("HelpBubbleEffect", self.transform, effectPath)
    end
  end
  if self.theHelpBubble ~= nil then
    self.theHelpBubble:SetActive(true)
    self.theHelpBubble:UpdateLod(self.lodCache)
    self.theHelpBubble:AddFriendsHelp(data)
  end
end

function AllianceCityTip:SetNameBg(path)
  self.name_spr:LoadSprite(path)
end

function AllianceCityTip:CheckBossData()
  if self.cityType ~= WorldAllianceCityType.City then
    self.boss_obj:SetActive(false)
    return
  end
  local activityId = DataCenter.ActBossDataManager.activityId
  if activityId ~= nil and self.lodCache >= 7 then
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
    if activityData ~= nil then
      self.monsterData = DataCenter.ActBossDataManager:GetActBossDataByCityId(self.data.id)
      if self.monsterData ~= nil then
        self.boss_obj:SetActive(true)
        self.boss_icon:LoadSprite("Assets/Main/Sprites/ActivityIcons/" .. activityData.list_icon)
      else
        self.boss_obj:SetActive(false)
      end
    else
      self.boss_obj:SetActive(false)
    end
  else
    self.boss_obj:SetActive(false)
  end
end

function AllianceCityTip:CheckCityDeclare()
  local serverValid = self.serverId == LuaEntry.Player:GetSelfServerId()
  local isBigMapMode, curSame, srcSame, loginSame = SeasonUtil.InSeasonBigMapMode(self.serverId)
  if isBigMapMode then
    serverValid = loginSame
  end
  if self.cityType ~= WorldAllianceCityType.City or not serverValid then
    self.declareWar.gameObject:SetActive(false)
    return
  end
  local data = DataCenter.AllianceDeclareWarManager:GetWarDataByCityId(self.data.id)
  if next(data) then
    local isSelfAlliance = false
    local selfAlliance = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    for i = 1, #data do
      if selfAlliance and data[i].aId == selfAlliance.uid then
        isSelfAlliance = true
      end
    end
    if isSelfAlliance then
      local pic = string.format(LoadPath.LodIcon, "UImap_img_declare-war_blue")
      self.declareWar:LoadSprite(pic)
    else
      local pic = string.format(LoadPath.LodIcon, "UImap_img_declare-war_red")
      self.declareWar:LoadSprite(pic)
    end
    self.declareWar.gameObject:SetActive(true)
    if 1 < table.count(data) then
      self.declareWarList.gameObject:SetActive(true)
    else
      self.declareWarList.gameObject:SetActive(false)
    end
  else
    self.declareWar.gameObject:SetActive(false)
  end
end

function AllianceCityTip:OnRefreshVirus(pointId)
  if self.data:GetPointId() == pointId then
    self:RefreshVirus()
  end
end

function AllianceCityTip:RefreshVirus()
  if not SeasonUtil.IsNewS1(false, LuaEntry.Player:GetCurServerId()) then
    return
  end
  local pointInfo = self.data:GetPointInfo()
  if pointInfo and pointInfo.GetStatusByType then
    local status = pointInfo:GetStatusByType(AllianceCityVirusType)
    if not status then
      self:RemoveVirus()
      return
    end
    local statusId = status.Id
    local virusLayer, virusEndTime = SeasonUtil.CalcVirusLevel(status.Layer, status.ExpireTime, statusId)
    if virusLayer <= 0 then
      self:RemoveVirus()
      return
    end
    local uuid = pointInfo.uuid
    if self.virusComponent then
      self.virusComponent:SetData(virusLayer, virusEndTime, statusId, uuid, self)
    end
    if not self.virusReq then
      do
        local request = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/UI/LWSeason1/AllianceCityVirus.prefab")
        self.virusReq = request
        request:completed("+", function()
          local go = request.gameObject
          if IsNull(go) then
            return
          end
          go:SetActive(true)
          local trans = go.transform
          trans:SetParent(self.virus_node)
          trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
          trans:Set_localPosition(0, 0, 0)
          trans:Set_localRotation(0, 0, 0)
          local theCityVirus = require("DataCenter.AllianceCityTip.Season.AllianceCityVirus")
          self.virusComponent = theCityVirus.New()
          self.virusComponent:OnCreate(go)
          self.virusComponent:SetData(virusLayer, virusEndTime, statusId, uuid, self)
        end)
      end
    end
  end
end

function AllianceCityTip:RemoveVirus()
  if self.virusComponent then
    self.virusComponent:OnDestroy()
    self.virusComponent = nil
  end
  if self.virusReq then
    self.virusReq:Destroy()
    self.virusReq = nil
  end
end

function AllianceCityTip:OnClickDeclare()
  if self.cityType ~= WorldAllianceCityType.City then
    return
  end
  local data = DataCenter.AllianceDeclareWarManager:GetWarDataByCityId(self.data.id)
  if next(data) and self.lodCache >= 4 and table.count(data) > 1 then
    CS.SceneManager.World:SetUseInput(false)
    GoToUtil.GotoOpenView(UIWindowNames.UIWorldDeclareList, SceneUtils.TilePosToIndex(self.data.pos), self.data.id)
  end
end

function AllianceCityTip:SetLod(lod, force)
  if force or self.lodCache ~= lod then
    local isBattle = SeasonUtil.CityIsInBattle(self.serverId, self.cityId)
    self.lodCache = lod
    if not isBattle and 7 < lod and self.cityId and not SeasonUtil.IsKingCity(self.cityId, self.serverId) and not SeasonUtil.IsOutpost(self.cityId, self.serverId) and not DataCenter.LandlordMgr:IsLandlordCity(self.cityId, self.serverId) then
      self.gameObject:SetActive(false)
      return
    end
    self.gameObject:SetActive(true)
    if self.strongholdOccupyRoot then
      self.strongholdOccupyRoot:SetLod(lod)
    end
    if self.landlordOccupyRoot then
      self.landlordOccupyRoot:SetLod(lod)
    end
    self.allianceWarTimeHud:SetLod(lod)
    self.allianceReinforce:SetLod(lod)
    if self.cityAltarTipLogic then
      self.cityAltarTipLogic:SetLod(lod)
    end
    if self.kingOccupyRoot then
      self.kingOccupyRoot:SetLod(lod)
    end
    if self.crossKingOccupyRoot then
      self.crossKingOccupyRoot:SetLod(lod)
    end
    if self.crossKingResultRoot then
      self.crossKingResultRoot:SetLod(lod)
    end
    if self.battleLod45Root then
      self.battleLod45Root:SetLod(lod)
    end
    if self.cityCannonLogic then
      self.cityCannonLogic:SetLod(lod)
    end
    if self.tradeStationTipLogicRoot then
      self.tradeStationTipLogicRoot:SetLod(lod)
    end
    if self.resetFirstHeadLogic then
      self.resetFirstHeadLogic:SetLod(lod)
    end
    if self.theOutpostRoot then
      self.theOutpostRoot:SetLod(lod)
    end
    if self.theOutpostCampRoot then
      self.theOutpostCampRoot:SetLod(lod)
    end
    self.assistanceRoot:SetLod(lod)
    if self.resetHpRoot then
      self.resetHpRoot:SetLod(lod)
    end
    if self.theHelpBubble ~= nil then
      self.theHelpBubble:UpdateLod(lod)
    end
    self:TryUpdatePosition()
  end
end

function AllianceCityTip:CheckLod(lod)
  if self.lodCache ~= lod then
    local isBattle = SeasonUtil.CityIsInBattle(self.serverId, self.cityId)
    self.lodCache = lod
    if not isBattle and 7 < lod and self.cityId and not SeasonUtil.IsKingCity(self.cityId, self.serverId) and not SeasonUtil.IsOutpost(self.cityId, self.serverId) and not DataCenter.LandlordMgr:IsLandlordCity(self.cityId, self.serverId) then
      self.gameObject:SetActive(false)
      return
    end
    self.gameObject:SetActive(true)
    if self.data then
      self:UpdateLodIcon()
    end
    self:CheckBossData()
    if self.strongholdOccupyRoot then
      self.strongholdOccupyRoot:CheckLod(lod)
    end
    if self.landlordOccupyRoot then
      self.landlordOccupyRoot:CheckLod(lod)
    end
    self.allianceWarTimeHud:CheckLod(lod)
    self.allianceReinforce:CheckLod(lod)
    if self.cityAltarTipLogic then
      self.cityAltarTipLogic:CheckLod(lod)
    end
    if self.kingOccupyRoot then
      self.kingOccupyRoot:CheckLod(lod)
    end
    if self.crossKingOccupyRoot then
      self.crossKingOccupyRoot:CheckLod(lod)
    end
    if self.crossKingResultRoot then
      self.crossKingResultRoot:CheckLod(lod)
    end
    if self.battleLod45Root then
      self.battleLod45Root:CheckLod(lod)
    end
    if self.cityCannonLogic then
      self.cityCannonLogic:CheckLod(lod)
    end
    if self.tradeStationTipLogicRoot then
      self.tradeStationTipLogicRoot:CheckLod(lod)
    end
    if self.theOutpostRoot then
      self.theOutpostRoot:CheckLod(lod)
    end
    if self.theOutpostCampRoot then
      self.theOutpostCampRoot:CheckLod(lod)
    end
    if self.resetFirstHeadLogic then
      self.resetFirstHeadLogic:CheckLod(lod)
    end
    if self.theHelpBubble ~= nil then
      self.theHelpBubble:UpdateLod(lod)
    end
    self.open_tips_node:SetActive(self.lodCache < 3 and self.openTime ~= nil and self.openTime ~= 0)
    self.bg2:SetActive(self.isShowNuCelearBuildTip and self.lodCache < 3)
    self.hpNode:SetActive(self.lodCache <= 2 and self.showHp)
    self.assistanceRoot:CheckLod(lod)
    if self.resetHpRoot then
      self.resetHpRoot:CheckLod(lod)
    end
    self:TryUpdatePosition()
  end
end

function AllianceCityTip:OnBossClick()
end

function AllianceCityTip:AddTimer()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local theEndTime = toInt(self.openTime)
  if curTime >= theEndTime then
    if self.lodIconProtect ~= nil then
      self.lodIconProtect.gameObject:SetActive(false)
    end
    self.open_tips_node:SetActive(false)
    self:DeleteTimer()
    return
  end
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
    self.timer:Start()
  end
  if self.lodIconProtect ~= nil then
    local showProtect = true
    local scale = 0.8
    local alpha = 1
    if DataCenter.LandlordMgr:IsLandlordCity(self.cityId, self.serverId) then
      local info = self.data:GetPointInfo()
      if info then
        showProtect = info.curClientState == LLConst.LLBuildingState.NotOpen or info.curClientState == LLConst.LLBuildingState.OpenButShield
        if showProtect then
          scale = 1
          alpha = 0.27
        end
      end
    end
    self.lodIconProtect.gameObject:SetActive(showProtect)
    self.lodIconProtect.transform:Set_localScale(scale, scale, scale)
    self:SetIconProtectSprite(alpha)
  end
end

function AllianceCityTip:TimerAction()
  if self.openTime ~= nil and self.openTime ~= 0 then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.openTime - curTime
    if 0 < remainTime then
      if remainTime > OneDayTime * 365 * 1000 then
        self.open_tips_time_text.text = Localization:GetString("456511")
        local textWidth = self.open_tips_time_text:GetWidth()
        self.open_tips_icon_text.transform:Set_localPosition(-textWidth * 0.5 - 0.14, 0, 0)
      else
        local txt = Localization:GetString("456521")
        self.open_tips_time_text.text = txt .. UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
        local textWidth = self.open_tips_time_text:GetWidth()
        self.open_tips_icon_text.transform:Set_localPosition(-textWidth * 0.5 - 0.14, 0, 0)
      end
    else
      self.openTime = nil
      self.open_tips_node:SetActive(false)
      self:OnStrongholdBattleStateUpdate()
      if self.lodIconProtect ~= nil then
        self.lodIconProtect.gameObject:SetActive(false)
      end
      if self.cityType == WorldAllianceCityType.CrossZoneOutpost then
        self:OnPointDateUpdate()
      end
    end
  end
  if self.openTime == nil or self.openTime == 0 then
    self.open_tips_node:SetActive(false)
    self:DeleteTimer()
    if self.lodIconProtect ~= nil then
      self.lodIconProtect.gameObject:SetActive(false)
    end
  end
end

function AllianceCityTip:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function AllianceCityTip:AddListeners()
  if self.onDeclareWar == nil then
    function self.onDeclareWar()
      self:OnDeclareWar()
    end
    
    EventManager:GetInstance():AddListener(EventId.DeclareWar, self.onDeclareWar)
  end
  if self.onDetectEventHelpEnd == nil then
    function self.onDetectEventHelpEnd(pointIndex)
      self:OnDetectEventHelpEnd(pointIndex)
    end
    
    EventManager:GetInstance():AddListener(EventId.DetectEventHelpEnd, self.onDetectEventHelpEnd)
  end
  if self.onCounterAttackActInfo == nil then
    function self.onCounterAttackActInfo(cityId)
      self:OnCounterAttackActInfo(cityId)
    end
    
    EventManager:GetInstance():AddListener(EventId.OnCounterAttackActInfo, self.onCounterAttackActInfo)
  end
  if self.onNuclearBuildValueChange == nil then
    function self.onNuclearBuildValueChange()
      self:OnNuclearBuildDataUpdate()
    end
    
    EventManager:GetInstance():AddListener(EventId.ActNuclearScoreUpdate, self.onNuclearBuildValueChange)
  end
  if self.onAllianceCityVirusRefresh == nil then
    function self.onAllianceCityVirusRefresh(pointId)
      self:OnRefreshVirus(pointId)
    end
    
    EventManager:GetInstance():AddListener(EventId.AllianceCityVirusRefresh, self.onAllianceCityVirusRefresh)
  end
  if self.onBloodQueenHpChange == nil then
    function self.onBloodQueenHpChange(cityInfo)
      self:OnBloodQueenHpChange(cityInfo)
    end
    
    EventManager:GetInstance():AddListener(EventId.PushBloodQueenHpChange, self.onBloodQueenHpChange)
  end
  if self.onBloodQueenNextRound == nil then
    function self.onBloodQueenNextRound()
      self:OnBloodQueenNextRound()
    end
    
    EventManager:GetInstance():AddListener(EventId.PushBloodQueenNextRound, self.onBloodQueenNextRound)
  end
  if self.onQueenOfBloodMainInfoUpdate == nil then
    function self.onQueenOfBloodMainInfoUpdate()
      self:RefreshBloodQueenBattleEffect()
    end
    
    EventManager:GetInstance():AddListener(EventId.QueenOfBloodMainInfoUpdate, self.onQueenOfBloodMainInfoUpdate)
  end
  if self.onPushRecaptureActMonsterDead == nil then
    function self.onPushRecaptureActMonsterDead(cityId)
      self:OnPushRecaptureActMonsterDead(cityId)
    end
    
    EventManager:GetInstance():AddListener(EventId.PushRecaptureActMonsterDead, self.onPushRecaptureActMonsterDead)
  end
end

function AllianceCityTip:RemoveListeners()
  if self.onDeclareWar ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.DeclareWar, self.onDeclareWar)
    self.onDeclareWar = nil
  end
  if self.onDetectEventHelpEnd ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.DetectEventHelpEnd, self.onDetectEventHelpEnd)
    self.onDetectEventHelpEnd = nil
  end
  if self.onCounterAttackActInfo ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.OnCounterAttackActInfo, self.onCounterAttackActInfo)
    self.onCounterAttackActInfo = nil
  end
  if self.onNuclearBuildValueChange ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.ActNuclearScoreUpdate, self.onNuclearBuildValueChange)
    self.onNuclearBuildValueChange = nil
  end
  if self.onAllianceCityVirusRefresh ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.AllianceCityVirusRefresh, self.onAllianceCityVirusRefresh)
    self.onAllianceCityVirusRefresh = nil
  end
  if self.onBloodQueenHpChange ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.PushBloodQueenHpChange, self.onBloodQueenHpChange)
    self.onBloodQueenHpChange = nil
  end
  if self.onBloodQueenNextRound ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.PushBloodQueenNextRound, self.onBloodQueenNextRound)
    self.onBloodQueenNextRound = nil
  end
  if self.onQueenOfBloodMainInfoUpdate ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.QueenOfBloodMainInfoUpdate, self.onQueenOfBloodMainInfoUpdate)
    self.onQueenOfBloodMainInfoUpdate = nil
  end
  if self.onPushRecaptureActMonsterDead ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.PushRecaptureActMonsterDead, self.onPushRecaptureActMonsterDead)
    self.onPushRecaptureActMonsterDead = nil
  end
end

function AllianceCityTip:OnDeclareWar()
  if self.cityType ~= WorldAllianceCityType.City then
    return
  end
  self:InitHpBar()
  if self.data and self.data.id then
    self:SetName(self.data.id)
    self:UpdateLodIcon()
  end
end

function AllianceCityTip:OnDetectEventHelpEnd(pointIndex)
  if self.cityType ~= WorldAllianceCityType.City then
    return
  end
  if self.data:GetPointId() == pointIndex then
    self.reward_icon.gameObject:SetActive(false)
  end
end

function AllianceCityTip:OnCounterAttackActInfo(cityId)
  if self.cityId == cityId then
    self:OnDeclareWar()
  end
end

function AllianceCityTip:InitHpBar()
  if self.data == nil or self.cityType ~= WorldAllianceCityType.City then
    self.showHp = false
    self.useCampDestroyHp = false
    self.hpNode:SetActive(false)
    return
  end
  local serverId = self.serverId or LuaEntry.Player:GetCurServerId()
  local showHp = DataCenter.AllianceDeclareWarManager:GetDeclareStateByCityId(self.cityId) == DeclareWarState.Formal or DataCenter.CounterAttackDataManager:CheckAllianceCityIsBeingAttack(self.cityId, serverId)
  local isCampDestroyDeclareCity = false
  if DataCenter.SeasonCampDestroyManager ~= nil and self.cityId ~= nil then
    isCampDestroyDeclareCity = DataCenter.SeasonCampDestroyManager:CanDestroyCity(self.cityId) == true
  end
  if isCampDestroyDeclareCity then
    self.showHp = showHp
    self.useCampDestroyHp = true
    self.hpNode:SetActive(true)
    self.hpBarBgNode:SetActive(false)
    self.bpBgNode:SetActive(true)
    self.campDestroyBgNode:SetActive(true)
    self.shieldBarBgNode:SetActive(true)
    self:RefreshHpBar(false)
    return
  end
  self.showHp = showHp
  self.useCampDestroyHp = false
  if self.showHp then
    self.hpNode:SetActive(true)
    self.shieldBarBgNode:SetActive(true)
    self.hpBarBgNode:SetActive(true)
    self.bpBgNode:SetActive(true)
    self.campDestroyBgNode:SetActive(false)
    self:RefreshHpBar(false)
  else
    self.hpNode:SetActive(false)
  end
end

function AllianceCityTip:RefreshHpBar(withAnim)
  if self.data == nil or self.showHp ~= true or self.cityType ~= WorldAllianceCityType.City then
    self.hpNode:SetActive(false)
    return
  end
  local info = self.data:GetPointInfo()
  if info == nil then
    self.hpNode:SetActive(false)
    return
  end
  local allianceCityPointInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceCityPointInfo")
  if allianceCityPointInfo == nil then
    self.hpNode:SetActive(false)
    return
  end
  self.hpNode:SetActive(true)
  local template = self.data
  local maxDurability = template.wall
  local durability = allianceCityPointInfo.durability
  local lastDurabilityTime = allianceCityPointInfo.lastDurabilityTime
  local cityRecoverSpeed = template.wall_recover
  local curTime = UITimeManager:GetInstance():GetServerSeconds()
  local addNum = (curTime - lastDurabilityTime) * tonumber(cityRecoverSpeed)
  local realDurabilityNum = durability + math.max(addNum, 0)
  local curDurability = math.min(realDurabilityNum, maxDurability)
  local curArmy = allianceCityPointInfo.soldierRemain
  local maxArmy = template.monster_id_count
  self:RefreshHpBarView(withAnim, curArmy, maxArmy, curDurability, maxDurability)
  if self.lodCache > 2 then
    self.hpNode:SetActive(false)
  end
end

function AllianceCityTip:RefreshHpBarView(withAnim, army, maxArmy, hp, maxHp)
  if self.cityType ~= WorldAllianceCityType.City then
    return
  end
  if self.oldArmy == nil then
    withAnim = false
  end
  if army ~= self.oldArmy then
    self.oldArmy = army
    local endValue = army / maxArmy * HP_BAR_LENGTH
    local vec = self.armyBar.size
    vec.x = endValue
    if self.armyTween then
      self.armyTween:Kill()
      self.armyTween = nil
    end
    if withAnim then
      self.armyTween = DOTween.To(function()
        return self.armyBarSlow.size.x
      end, function(x)
        local vec2 = self.armyBarSlow.size
        vec2.x = x
        self.armyBarSlow.size = vec2
      end, endValue, 1)
    else
      self.armyBarSlow.size = vec
    end
    self.armyBar.size = vec
    self.armyBarNum.text = string.format("%s/%s", army, maxArmy)
  end
  if self.useCampDestroyHp then
    if hp ~= self.oldHp then
      self.oldHp = hp
      local endValue = hp / maxHp * HP_BAR_LENGTH
      local vec = self.campDestroyHpBar.size
      vec.x = endValue
      if self.hpTween then
        self.hpTween:Kill()
        self.hpTween = nil
      end
      if withAnim then
        self.hpTween = DOTween.To(function()
          return self.campDestroyHpBarSlow.size.x
        end, function(x)
          local vec2 = self.campDestroyHpBarSlow.size
          vec2.x = x
          self.campDestroyHpBarSlow.size = vec2
        end, endValue, 1)
      else
        self.campDestroyHpBarSlow.size = vec
      end
      self.campDestroyHpBar.size = vec
      self.campDestroyHpBarNum.text = string.format("%s/%s", hp, maxHp)
    end
    return
  end
  if hp ~= self.oldHp then
    self.oldHp = hp
    local endValue = hp / maxHp * HP_BAR_LENGTH
    local vec = self.hpBar.size
    vec.x = endValue
    if self.hpTween then
      self.hpTween:Kill()
      self.hpTween = nil
    end
    if withAnim then
      self.hpTween = DOTween.To(function()
        return self.hpBarSlow.size.x
      end, function(x)
        local vec2 = self.hpBarSlow.size
        vec2.x = x
        self.hpBarSlow.size = vec2
      end, endValue, 1)
    else
      self.hpBarSlow.size = vec
    end
    self.hpBar.size = vec
    self.hpBarNum.text = string.format("%s/%s", hp, maxHp)
  end
end

function AllianceCityTip:OnStrongholdBattleStateUpdate()
  if self.cityType ~= WorldAllianceCityType.Stronghold and self.cityType ~= WorldAllianceCityType.TradingStation and self.cityType ~= WorldAllianceCityType.Altar then
    if GameObjectIsValid(self.eff_battle_stronghold) then
      self.eff_battle_stronghold:SetActive(false)
    end
    return
  end
  if self.forSeason then
    local effect_node_exist = GameObjectIsValid(self.eff_battle_stronghold)
    local serverId = self.serverId or LuaEntry.Player:GetCurServerId()
    local isBattle = SeasonUtil.CityIsInBattle(serverId, self.cityId)
    if effect_node_exist then
      self.eff_battle_stronghold:SetActive(isBattle == true)
    end
    if isBattle then
      if not effect_node_exist and self.request_battle_stronghold_effect == nil then
        self.eff_battle_stronghold = nil
        local modelName = "Assets/_Art_LastWar/Effect/Prefab/dafuw/Eff_dafuw_jiaozhan_X_S1.prefab"
        local request = ResourceManager:InstantiateAsync(modelName)
        request:completed("+", function()
          if request.isError or self.request_battle_stronghold_effect == nil or IsNull(self.transform) then
            return
          end
          local go = request.gameObject
          go:SetActive(true)
          go.transform:SetParent(self.transform)
          go.transform:Set_localScale(0.1, 0.1, 0.1)
          go.transform:Set_localPosition(0, 0, -5.18)
          go.transform:Set_localRotation(0, 0, 0, 1)
          self.eff_battle_stronghold = go
          self:UpdateTitleNodeScale()
        end)
        self.request_battle_stronghold_effect = request
      end
    elseif self.strongholdOccupyRoot then
      self.strongholdOccupyRoot:OnBattleFinish()
    end
    self.allianceWarTimeHud:OnProtectTimeUpdate()
  elseif GameObjectIsValid(self.eff_battle_stronghold) then
    self.eff_battle_stronghold:SetActive(false)
  end
end

function AllianceCityTip:OnNuclearBuildDataUpdate()
  if self.data and self.isKingCity then
    local max = DataCenter.SeasonNuclearPowerPlantDataManager:GetScoreMax()
    local actNuclearScore = DataCenter.WorldAllianceCityDataManager:GetThroneNuclearScore(LuaEntry.Player:GetCurServerId())
    if self.preValue ~= nil and not self.preValue ~= 0 then
      local add = actNuclearScore - self.preValue
      if add ~= 0 then
        local flag = add < 0 or self.addTextAni == nil
        if flag then
          if self.addTextAni then
            self.addTextAni:Kill()
            self.addTextAni = nil
          end
          local text = 0 < add and "+" .. add or "-" .. add
          local color = 0 < add and UIUtil.HexToColor32("00FF08") or UIUtil.HexToColor32("FF0003")
          self.add_text.transform:Set_localPosition(0, 0, 0)
          self.add_text.color32 = color
          self.add_text.text = text
          self.add_text.gameObject:SetActive(true)
          self.addTextAni = self.add_text.transform:DOLocalMoveY(0.5, 2)
          
          function self.addTextAni.onComplete()
            self.addTextAni = nil
            if not IsNull(self.add_text) then
              self.add_text.gameObject:SetActive(false)
            end
          end
        end
      end
    end
    self.preValue = actNuclearScore
    local r = 0
    if max <= actNuclearScore then
      r = 1
    else
      r = actNuclearScore / max
    end
    local value = r * BUILD_HP_BAR_LENGTH
    local vec2 = self.build_slider.size
    vec2.x = value
    self.build_slider.size = vec2
    r = r * 100
    r = math.floor(r * 100) / 100
    self.build_blood_num.text = tostring(r) .. "%"
  end
end

function AllianceCityTip:OnBloodQueenHpChange(cityInfo)
  if self.cityId and cityInfo and self.cityId == cityInfo.cityId and self.resetHpRoot then
    self.resetHpRoot:RefreshHpBar(true)
  end
end

function AllianceCityTip:OnBloodQueenNextRound()
  if self.resetHpRoot then
    self.resetHpRoot:RefreshHpBar(false)
  end
end

function AllianceCityTip:RefreshBloodQueenBattleEffect()
  if self.cityId and DataCenter.OffSeason1QueenOfBloodManager:InQueenOfBloodBattle() and DataCenter.OffSeason1QueenOfBloodManager:GetCityInfoById(self.cityId) then
    if self.reqBloodQueenBattleEffect == nil then
      local modelName = "Assets/_Art_LastWar/Effect/Prefab/dafuw/Eff_dafuw_jiaozhan_X_S1.prefab"
      self.reqBloodQueenBattleEffect = ResourceManager:InstantiateAsync(modelName)
      self.reqBloodQueenBattleEffect:completed("+", function(request)
        if request.isError or IsNull(self.transform) then
          request:Destroy()
          self.reqBloodQueenBattleEffect = nil
          return
        end
        local go = request.gameObject
        go.transform:SetParent(self.transform)
        go.transform:Set_localScale(0.1, 0.1, 0.1)
        go.transform:Set_localPosition(0, 0, -5.18)
        go.transform:Set_localRotation(0, 0, 0, 1)
        go.name = "bloodQueenBattleEffect"
        self.bloodQueenBattleEffect = go
        if self.cityId and DataCenter.OffSeason1QueenOfBloodManager:InQueenOfBloodBattle() and DataCenter.OffSeason1QueenOfBloodManager:GetCityInfoById(self.cityId) then
          go:SetActive(true)
          self:UpdateTitleNodeScale()
        else
          go:SetActive(false)
        end
      end)
    elseif self.bloodQueenBattleEffect then
      self.bloodQueenBattleEffect:SetActive(true)
      self:UpdateTitleNodeScale()
    end
  elseif GameObjectIsValid(self.bloodQueenBattleEffect) then
    self.bloodQueenBattleEffect:SetActive(false)
  end
end

function AllianceCityTip:OnCitySkinColorSettingChanged()
  if self.cityId ~= nil then
    self:UpdateLodIcon()
    self:SetAllianceColor(self.cityId)
  end
end

function AllianceCityTip:OnPushRecaptureActMonsterDead(cityId)
  if cityId and self.cityId == cityId then
    self:OnDeclareWar()
    self:SetAllianceColor(cityId)
  end
end

function AllianceCityTip:ShowBloodQueenHpChangeTip(totalDamage)
  if self.resetHpRoot then
    self.resetHpRoot:ShowHpDamageTip(totalDamage)
  end
end

function AllianceCityTip:ShowBloodQueenButcherExplodeTip(totalDamage)
  if self.resetHpRoot then
    self.resetHpRoot:ShowSoldierDamageTip(totalDamage)
  end
end

function AllianceCityTip.UpdateZoneSkinColor(serverStr, k2ColorList, k3ColorList, k4ColorList, k5ColorList, k6ColorList, k7ColorList)
  skinColorServerStr = serverStr
  skinColorList2 = k2ColorList
  skinColorList3 = k3ColorList
  skinColorList4 = k4ColorList
  skinColorList5 = k5ColorList
  skinColorList6 = k6ColorList
  skinColorList7 = k7ColorList
end

return AllianceCityTip
