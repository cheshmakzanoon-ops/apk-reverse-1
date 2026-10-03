local UIHeroTipView = require("UI.UIHero2.UIHeroTip.View.UIHeroTipView")
local WorldAllianceBuild = BaseClass("WorldAllianceBuild", UIAsyncContainer)
local base = UIAsyncContainer
local Localization = CS.GameEntry.Localization
local WorldAllianceBuildAttackInfo = require("UI.UIWorldPoint.Component.WorldAllianceBuildAttackInfo")
local WorldAllianceBuildS3Produce = require("UI.UIWorldPoint.Component.WorldAllianceBuildS3Produce")
local lua_path_assistance = "UI.UIWorldPoint.Component.UIWorldPointNewOtherPlayerInfoAssistanceComp"
local WorldAllianceBuildResProduce = require("UI.UIWorldPoint.Component.WorldAllianceBuildS3Produce")
local info_path = "info"
local slider_path = "info/buildObj/Slider"
local num_path = "info/buildObj/Txt_Num"
local desc_path = "info/desc"
local player_name_path = "info/buildObj/layout1/playerName"
local btn_user_path = "info/buildObj/layout1/btnUser"
local item_flag_icon_path = "info/ItemFlagIcon"
local army_root_path = "detailsList/armyRoot"
local speed_root_path = "detailsList/speedRoot"
local time_root_path = "detailsList/timeRoot"
local army_path = "detailsList/armyRoot/army"
local speed_path = "detailsList/speedRoot/speed"
local finish_time_path = "detailsList/timeRoot/finishTime"
local xy_path = "detailsList/xy"
local details_list_path = "detailsList"
local rate_root_path = "detailsList/rateRoot"
local rate_path = "detailsList/rateRoot/rate"
local desc_root_path = "DescRoot"
local des_txt_path = "DescRoot/ScrollView/Viewport/Content/desTxt"
local product_path = "info/product"
local product_icon_path = "info/product/icon"
local work_path = "work"
local work_icon_path = "work/work_icon"
local status1_path = "work/status1"
local status2_path = "work/status2"
local status0_path = "work/status0"
local goto_btn_path = "work/status0/GotoBtn"
local divide1_path = "divide1"
local divide2_path = "divide2"
local attack_info_path = "attackInfo"
local divide3_path = "divide3"
local battle_time_root_path = "detailsList/battleTimeRoot"
local battle_time_path = "detailsList/battleTimeRoot/battleTime"
local assistance_root_path = "detailsList/assistanceRoot"
local tower_root_path = "TowerRoot"
local tower_slider_path = "TowerRoot/TowerSlider"
local tower_slider_txt_path = "TowerRoot/TowerSlider/TowerSliderTxt"
local tower_attack_root_path = "detailsList/TowerAttackRoot"
local tower_attack_path = "detailsList/TowerAttackRoot/towerAttack"
local tower_time_root_path = "detailsList/TowerTimeRoot"
local tower_time_path = "detailsList/TowerTimeRoot/towerTime"

function WorldAllianceBuild:OnCreate()
  base.OnCreate(self)
  self.seasonType = SeasonUtil.GetSeasonType(false, true)
  self.dynamicNodeList = {}
  self:ComponentDefine()
  self.allianceId = nil
end

function WorldAllianceBuild:OnDestroy()
  if self.dynamicNodeList then
    for _, node in ipairs(self.dynamicNodeList) do
      if node and type(node.Delete) == "function" then
        pcall(node.Delete, node)
      end
    end
  end
  self.dynamicNodeList = nil
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function WorldAllianceBuild:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetAssistanceData, self.RefreshView)
  self:AddUIListener(EventId.LWSeasonFactionBattleInfoUpdate, self.OnFactionBattleInfoUpdate)
  self:AddUIListener(EventId.UIRefreshAssistanceDetailInfo, self.OnAssistanceDetailInfo)
  self:AddUIListener(EventId.FocusPointChanged, self.OnAssistanceDetailInfo)
end

function WorldAllianceBuild:OnRemoveListener()
  self:RemoveUIListener(EventId.GetAssistanceData, self.RefreshView)
  self:RemoveUIListener(EventId.LWSeasonFactionBattleInfoUpdate, self.OnFactionBattleInfoUpdate)
  self:RemoveUIListener(EventId.UIRefreshAssistanceDetailInfo, self.OnAssistanceDetailInfo)
  self:RemoveUIListener(EventId.FocusPointChanged, self.OnAssistanceDetailInfo)
  base.OnRemoveListener(self)
end

function WorldAllianceBuild:ComponentDefine()
  self.info = self:AddComponent(UIImage, info_path)
  self.alliance_flag = self:AddComponent(UIImage, item_flag_icon_path)
  self.num_txt = self:AddComponent(UITextMeshProUGUIEx, num_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.desc_txt = self:AddComponent(UITextMeshProUGUIEx, desc_path)
  self.player_name = self:AddComponent(UITextMeshProUGUIEx, player_name_path)
  self.desc_root = self:AddComponent(UIImage, desc_root_path)
  self.des_txt = self:AddComponent(UITextMeshProUGUIEx, des_txt_path)
  self.army_root = self:AddComponent(UIImage, army_root_path)
  self.speed_root = self:AddComponent(UIImage, speed_root_path)
  self.time_root = self:AddComponent(UIImage, time_root_path)
  self.xy = self:AddComponent(UITextMeshProUGUIEx, xy_path)
  self.army = self:AddComponent(UITextMeshProUGUIEx, army_path)
  self.speed = self:AddComponent(UITextMeshProUGUIEx, speed_path)
  self.finish_time = self:AddComponent(UITextMeshProUGUIEx, finish_time_path)
  self.details_list = self:AddComponent(UIBaseContainer, details_list_path)
  self.rate_root = self:AddComponent(UIImage, rate_root_path)
  self.rate_txt = self:AddComponent(UITextMeshProUGUIEx, rate_path)
  self.product = self:AddComponent(UITextMeshProUGUIEx, product_path)
  self.product_icon = self:AddComponent(UIImage, product_icon_path)
  self.divide1 = self:AddComponent(UIBaseContainer, divide1_path)
  self.divide2 = self:AddComponent(UIBaseContainer, divide2_path)
  self.work = self:AddComponent(UIBaseContainer, work_path)
  self.work_icon = self:AddComponent(UIImage, work_icon_path)
  self.status1 = self:AddComponent(UITextMeshProUGUIEx, status1_path)
  self.status2 = self:AddComponent(UITextMeshProUGUIEx, status2_path)
  self.status0 = self:AddComponent(UITextMeshProUGUIEx, status0_path)
  self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
  self.goto_btn:SetOnClick(function()
    if self.allianceId then
      self.view.ctrl:CloseSelf()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonStoveCenter, {anim = true, hideTop = true})
    end
  end)
  self.btn_user = self:AddComponent(UIButton, btn_user_path)
  self.btn_user:SetOnClick(function()
    if self.allianceId then
      self.view.ctrl:CloseSelf()
      UIUtil.TryShowAllianceInfo(LuaEntry.Player:GetCurServerId(), self.allianceId, "")
    end
  end)
  self.xy:SetText("")
  self.army_root:SetActive(false)
  self.desc_root:SetActive(false)
  self.work:SetActive(false)
  self.product:SetActive(false)
  self.rate_root:SetActive(false)
  self.attack_info = self:AddComponent(WorldAllianceBuildAttackInfo, attack_info_path)
  self.divide3 = self:AddComponent(UIBaseContainer, divide3_path)
  self.attack_info:SetActive(false)
  self.divide3:SetActive(false)
  self.battle_time_root = self:AddComponent(UIImage, battle_time_root_path)
  self.battle_time = self:AddComponent(UITextMeshProUGUIEx, battle_time_path)
  self.tower_root = self:AddComponent(UIBaseContainer, tower_root_path)
  self.tower_slider = self:AddComponent(UISlider, tower_slider_path)
  self.tower_slider_txt = self:AddComponent(UITextMeshProUGUIEx, tower_slider_txt_path)
  self.tower_attack_root = self:AddComponent(UIImage, tower_attack_root_path)
  self.tower_attack = self:AddComponent(UITextMeshProUGUIEx, tower_attack_path)
  self.tower_time_root = self:AddComponent(UIImage, tower_time_root_path)
  self.tower_time = self:AddComponent(UITextMeshProUGUIEx, tower_time_path)
  if WorldBattleUtil.EnableShowWorldAssistanceInfo() and not BattleFieldUtil.InBattleField() then
    self.dCompAssistance = UIAsyncLoaderBridge.New(self, "dCompAssistance", self.transform:Find(assistance_root_path), UIAssets.UIWorldPointComp_PlayerAssistanceComp, lua_path_assistance, true)
  end
end

function WorldAllianceBuild:ComponentDestroy()
  self.tower_root = nil
  self.tower_slider = nil
  self.tower_slider_txt = nil
  self.tower_attack_root = nil
  self.tower_attack = nil
  self.tower_time_root = nil
  self.tower_time = nil
  self.work = nil
  self.work_icon = nil
  self.status1 = nil
  self.status2 = nil
  self.status0 = nil
  self.goto_btn = nil
  self.divide1 = nil
  self.attack_info = nil
  self.divide3 = nil
  self.battle_time_root = nil
  self.battle_time = nil
  self.info = nil
  self.product_icon = nil
  if self.dCompAssistance then
    self.dCompAssistance:Delete()
    self.dCompAssistance = nil
  end
end

function WorldAllianceBuild:RefreshView()
  if self.data then
    local info = DataCenter.FormationAssistanceDataManager:GetAssistanceData(self.data.uuid)
    if info then
      local armyCount = info:GetMemberCount(MarchStatus.STATION) + info:GetMemberCount(MarchStatus.ASSISTANCE) + info:GetMemberCount(MarchStatus.BUILD_ALLIANCE_BUILDING)
      local holdMemberCount = info:GetHoldMemberCount(MarchStatus.STATION) + info:GetHoldMemberCount(MarchStatus.ASSISTANCE) + info:GetHoldMemberCount(MarchStatus.BUILD_ALLIANCE_BUILDING)
      self.army_root:SetActive(true)
      self.army:SetText(Localization:GetString("season_alliance_building_UItips001") .. armyCount + holdMemberCount)
      self:RebuildLayout()
    end
  end
end

function WorldAllianceBuild:ReAutoFitUI()
  if self.view.ReAutoFitUI then
    self.view:ReAutoFitUI()
  end
end

function WorldAllianceBuild:OnFactionBattleInfoUpdate()
  local mgr = DataCenter.SeasonFactionWarDataManager
  if mgr.defenderAllianceId ~= self.allianceId then
    self.battle_time_root:SetActive(false)
  elseif table.count(mgr.theAttackerList) > 0 then
    local currStep = mgr:GetCurrStep()
    if currStep == SeasonFactionDeclareWarStep.battle_before or currStep == SeasonFactionDeclareWarStep.battle then
      self.battleStep = currStep
      self.battleEndTime = mgr.stepEndTime
      self.battle_time_root:SetActive(true)
      self:Update1000MS()
    else
      self.battle_time_root:SetActive(false)
    end
  else
    self.battle_time_root:SetActive(false)
  end
  self:RebuildLayout()
end

function WorldAllianceBuild:OnStoveCenterUpdate(serverData)
  local seasonType = self.seasonType
  local isGuardianTower = self.data and self.data.isGuardianTower
  if serverData ~= nil and serverData.scoreList and self.data ~= nil then
    self.attack_info:ReInit(serverData.scoreList, self.divide3, toInt(self.data.maxHp))
  else
    self.attack_info:SetActive(false)
    self.divide3:SetActive(false)
  end
  if seasonType ~= SeasonMapType.Snow or isGuardianTower then
    self.product:SetActive(false)
    self.work:SetActive(false)
    self.divide1:SetActive(isGuardianTower)
    return
  end
  if serverData ~= nil and serverData.furnace and self.data and self.data.state ~= AllianceMineStatus.Build then
    local resourceNum = serverData.furnace.resourceNum
    local state = serverData.furnace.state
    local endTime = serverData.furnace.endTime
    if resourceNum and state and endTime then
      self.allianceFurnaceInfo = serverData.furnace
      self.product:SetActive(true)
      self.product:SetText(Localization:GetString("season_s2_prosperity_tips01") .. ":" .. string.GetFormattedStr(resourceNum))
      self.product_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceStone))
      if state == 1 or state == 2 then
        self.endTimeForCoal = toInt(endTime)
        if self.endTimeForCoal > 0 then
          self.descStr = Localization:GetString("season_s2_alliance_building_ui013")
          local curTime = UITimeManager:GetInstance():GetServerTime()
          local deltaTime = self.endTimeForCoal - curTime
          if 0 <= deltaTime then
            self.status2:SetText(self.descStr .. UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
          else
            self.status2:SetText(self.descStr .. "00:00:00")
          end
          self.status2:SetActive(true)
        end
        local level = toInt(self.data.level)
        local mineInfo = DataCenter.AllianceMineManager:GetAllianceMineTemplate(level + BuildingTypes.SEASON_STOVE_CENTER)
        local temperatureCfg = mineInfo.temperatureCfg
        local active_temperature = temperatureCfg.active_temperature
        local overload_temperature = temperatureCfg.overload_temperature
        if state == 2 then
          self.status1:SetActive(true)
          self.status0:SetActive(false)
          self.status1:SetText(Localization:GetString("season_s2_temperature_status_name05") .. ":+" .. overload_temperature .. "\194\176C")
          self.work_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/icon/FX_S2saiji_huolu_icon_guozai.png")
        elseif state == 1 then
          self.status1:SetActive(true)
          self.status0:SetActive(false)
          self.status1:SetText(Localization:GetString("season_s2_temperature_status_name04") .. ":+" .. active_temperature .. "\194\176C")
          self.work_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/icon/FX_S2saiji_huolu_icon.png")
        end
      else
        self.status0:SetActive(true)
        self.status1:SetActive(false)
        self.status2:SetActive(false)
        self.work_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/icon/FX_S2saiji_huolu_icon_close.png")
        self.endTimeForCoal = nil
      end
      self.divide1:SetActive(true)
      self.work:SetActive(true)
      self.goto_btn:SetActive(self.isMineBuild)
    else
      self.product:SetActive(false)
      self.work:SetActive(false)
      self.divide1:SetActive(false)
    end
  else
    self.product:SetActive(false)
    self.work:SetActive(false)
    self.divide1:SetActive(false)
  end
end

function WorldAllianceBuild:RefreshData(param)
  self.data = param
  self.buildType = param.type
  self.allianceId = param.allianceId
  self.isMineBuild = param.allianceId == LuaEntry.Player.allianceId
  self.player_name:SetText("")
  self.num_txt:SetText("")
  self.pointId = param.pointId
  local pos = SceneUtils.IndexToTilePos(param.pointId, ForceChangeScene.World)
  self.xy:SetText(string.format("<u> X:%s Y:%s </u>", pos.x, pos.y))
  self.rate_root:SetActive(false)
  if param.buildId == BuildingTypes.LW_ALLIANCE_WAR_CAMP_2 then
    SFSNetwork.SendMessage(MsgDefines.AllianceAssistCampInfo, param.uuid)
  else
    SFSNetwork.SendMessage(MsgDefines.AllianceAssistanceInfo, param.uuid, AssistanceType.AllianceBuild)
  end
  if self.data ~= nil and self.data.curHp and self.data.maxHp then
    self.slider:SetActive(true)
    self:OnStoveCenterUpdate(self.serverData)
    local maxHpStr = string.GetFormattedSeparatorNum(math.floor(self.data.maxHp))
    if self.data.maxHp <= self.data.curHp then
      self.num_txt:SetText(maxHpStr .. "/" .. maxHpStr)
      self.slider:SetValue(1)
      self.time_root:SetActive(false)
      self.speed_root:SetActive(false)
    else
      local curHpStr = string.GetFormattedSeparatorNum(math.floor(self.data.curHp))
      self.num_txt:SetText(curHpStr .. "/" .. maxHpStr)
      self.slider:SetValue(self.data.curHp / self.data.maxHp)
      self:Update1000MS()
    end
  else
    self.slider:SetActive(false)
  end
  local seasonType = self.seasonType
  if SeasonUtil.SeasonHasFactionWar(seasonType) then
    local factionWarActivityType = SeasonUtil.GetFactionWarActivityType(seasonType)
    if DataCenter.ActivityListDataManager:CheckIfActivityOpen(factionWarActivityType) then
      local mgr = DataCenter.SeasonFactionWarDataManager
      local actObj = mgr.declareWarActObj
      if mgr.currStep == nil or mgr.warInfo == nil or actObj == nil or actObj ~= nil and (actObj.stepEndTime ~= mgr.stepEndTime or actObj.currStep ~= mgr.currStep) then
        mgr:InitData()
      end
      self:OnFactionBattleInfoUpdate()
    else
      self.battle_time_root:SetActive(false)
    end
    if SeasonUtil.SeasonHasMilitaryCenterAttachment(seasonType) then
      self:UpdateProduceStatus()
    end
  else
    self.battle_time_root:SetActive(false)
  end
  self:OnGuardianTowerUpdate()
  self:RebuildLayout()
end

function WorldAllianceBuild:Update1000MS()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.battleEndTime then
    local deltaTime = self.battleEndTime - curTime
    if 0 <= deltaTime then
      if self.battleStep == SeasonFactionDeclareWarStep.battle_before then
        self.battle_time:SetLocalText("season_s2_win_popui009", UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
      elseif self.battleStep == SeasonFactionDeclareWarStep.battle then
        self.battle_time:SetLocalText("season_s2_win_popui008", UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
      else
        self.battleEndTime = nil
        self.battle_time_root:SetActive(false)
      end
    else
      self.battleEndTime = nil
      self.battle_time_root:SetActive(false)
      if self.requestStoveCenterBattleInfo ~= true then
        self.requestStoveCenterBattleInfo = true
        SFSNetwork.SendMessage(MsgDefines.FetchSeasonFactionVsInfo)
      end
    end
  end
  if self.allianceFurnaceInfo and self.descStr and self.endTimeForCoal then
    local deltaTime = self.endTimeForCoal - curTime
    if 0 <= deltaTime then
      self.status2:SetText(self.descStr .. UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
      self.status0:SetActive(true)
      self.status1:SetActive(false)
      self.status2:SetActive(false)
      self.goto_btn:SetActive(self.isMineBuild)
      self.work_icon:LoadSprite("Assets/Main/Sprites/UI/UISeason/UISeason2/icon/FX_S2saiji_huolu_icon_close.png")
      self.endTimeForCoal = nil
    end
  end
  self:OnGuardianTowerUpdate()
  if self.data == nil or self.data.lastHpTime == nil or self.data.coverSpeed == 0 then
    self.time_root:SetActive(false)
    self.speed_root:SetActive(false)
    self.desc_txt:SetActive(false)
    return
  end
  if self.data ~= nil and self.data.curHp and self.data.maxHp and self.data.maxHp <= self.data.curHp then
    self.time_root:SetActive(false)
    self.speed_root:SetActive(false)
    self.desc_txt:SetActive(false)
    return
  end
  local deltaTime = curTime - self.data.lastHpTime
  self.desc_txt:SetText("")
  if 0 < self.data.maxHp then
    if deltaTime <= 0 then
      deltaTime = 0
    end
    local realBlood = math.min(deltaTime / 1000 * self.data.coverSpeed + self.data.curHp, self.data.maxHp)
    local percent = math.min(realBlood / self.data.maxHp, 1)
    self.num_txt:SetText(string.GetFormattedSeperatorNum(math.floor(realBlood)) .. "/" .. string.GetFormattedSeperatorNum(math.floor(self.data.maxHp)))
    self.slider:SetValue(percent)
    if percent < 1 then
      self.desc_txt:SetActive(true)
      self.desc_txt:SetLocalText("season_tips112")
      self.speed_root:SetActive(true)
      self.speed:SetText(Localization:GetString("season_alliance_building_UItips002") .. string.GetFloatStr(self.data.coverSpeed) .. "/s")
      if 0 < self.data.coverSpeed then
        local full_time = (self.data.maxHp - realBlood) / self.data.coverSpeed
        local strInterval = UITimeManager:GetInstance():MilliSecondToFmtString(full_time * 1000)
        self.time_root:SetActive(true)
        self.finish_time:SetText(Localization:GetString("season_alliance_building_UItips003") .. strInterval)
      else
        self.time_root:SetActive(false)
      end
    else
      self.data.coverSpeed = 0
      self.data.curHp = self.data.maxHp
      self.time_root:SetActive(false)
      self.desc_txt:SetText("")
      self.speed_root:SetActive(false)
      self.desc_txt:SetActive(false)
    end
  else
    self.desc_txt:SetActive(false)
    self.num_txt:SetText("0/0")
    self.slider:SetValue(0)
    self.time_root:SetActive(false)
    self.speed_root:SetActive(false)
  end
end

function WorldAllianceBuild:OnGuardianTowerUpdate()
  if self.data and self.data.isGuardianTower and self.data.shieldSkillInfo then
    local now = UITimeManager:GetInstance():GetServerTime()
    local OverTime = toInt(self.data.shieldSkillInfo.OverTime)
    if 100 <= OverTime - now then
      local mgrSkill = DataCenter.AllianceGovernmentSkillManager
      local SkillId = toInt(self.data.shieldSkillInfo.SkillId)
      local StartTime = toInt(self.data.shieldSkillInfo.StartTime)
      local OnceTime = 10000
      local skill_cfg = mgrSkill:GetTemplatesById(SkillId)
      if skill_cfg ~= nil and skill_cfg.skill_flag == AlOfficialSkillType.GuardianTower then
        OnceTime = math.max(toInt(skill_cfg.skill_para8) * 1000, 5000)
        repeat
          StartTime = StartTime + OnceTime
        until now < StartTime
      end
      local NextTime = StartTime - now
      self.info:SetActive(false)
      self.divide2:SetActive(false)
      self.work:SetActive(false)
      self.divide1:SetActive(true)
      self.tower_root:SetActive(true)
      self.tower_attack_root:SetActive(true)
      self.tower_time_root:SetActive(true)
      self.tower_attack:SetLocalText("alliance_government_10005_12", math.ceil(NextTime / 1000))
      self.tower_time:SetLocalText("alliance_government_10005_13", math.ceil(toInt(OverTime - now) / 1000))
      if self.data.shieldSkillInfo then
        local curHp = toInt(self.data.shieldSkillInfo.CurShield)
        local maxHp = toInt(self.data.shieldSkillInfo.MaxShield)
        self.tower_slider_txt:SetText(string.GetFormattedSeperatorNum(curHp))
        self.tower_slider:SetValue(curHp / math.max(1, maxHp, curHp))
      end
      if self.view and self.view.name_text then
        self.view.name_text:SetLocalText("alliance_government_10005_01")
      end
      if self.data.shareName then
        self.data.shareNameOld = self.data.shareName
        self.data.shareName = Localization:GetString("alliance_government_10005_01")
      end
      return
    end
  end
  if self.tower_root:GetActive() == true or self.info:GetActive() ~= true then
    self.data.isGuardianTower = false
    self.data.shieldSkillInfo = nil
    self.tower_root:SetActive(false)
    self.tower_attack_root:SetActive(false)
    self.tower_time_root:SetActive(false)
    self.info:SetActive(true)
    self.divide2:SetActive(true)
    if self.view and self.view.name_text then
      self.view.name_text:SetLocalText(self.data.name)
    end
    if self.data.shareNameOld then
      self.data.shareName = self.data.shareNameOld
    end
    self:UpdateProduceStatus()
  end
end

function WorldAllianceBuild:SetData(pointId, serverData)
  self.pointId = pointId
  self.serverData = serverData.playerData
  local pos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
  self.xy:SetText(string.format("<u> X:%s Y:%s </u>", pos.x, pos.y))
  self.rate_root:SetActive(false)
  if self.serverData and self.serverData.furnace then
    self:OnStoveCenterUpdate(self.serverData)
  end
  local detail = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.pointId)
  if detail ~= nil then
    local allianceBuild = detail.alBuilding
    if allianceBuild ~= nil then
      self.allianceId = allianceBuild.allianceId
      local allianceInfo = DataCenter.AllianceTempListManager:GetSearchAllianceDataByUid(allianceBuild.allianceId)
      if allianceInfo == nil then
        local allianceName = ""
        if allianceBuild.alAbbr ~= nil and allianceBuild.alAbbr ~= "" then
          allianceName = "[" .. allianceBuild.alAbbr .. "]" .. allianceBuild.alName
        else
          allianceName = "-"
        end
        if allianceBuild.allianceId == LuaEntry.Player.allianceId then
          self.player_name:SetText("<color=#0091e8>" .. allianceName .. "</color>")
        else
          self.player_name:SetText("<color=#e64141>" .. allianceName .. "</color>")
        end
        local srcServer = self.serverData.srcServer
        local otherServerPlayer = srcServer ~= nil and srcServer ~= 0 and srcServer ~= LuaEntry.Player:GetSourceServerId()
        if allianceBuild.allianceId == LuaEntry.Player.allianceId then
          self.player_name:SetText("<color=#0091e8>" .. allianceName .. "</color>")
        elseif otherServerPlayer then
          self.player_name:SetText("<color=#e64141>" .. allianceName .. "</color>")
        else
          self.player_name:SetText("<color=#2A2830>" .. allianceName .. "</color>")
        end
        SFSNetwork.SendMessage(MsgDefines.GetAllianceInfo, allianceBuild.allianceId)
      else
        self:ShowAllianceInfo(allianceInfo)
      end
    end
  end
  self:UpdateProduceStatus()
  self:RefreshAssistance()
  self:OnGuardianTowerUpdate()
end

function WorldAllianceBuild:UpdateProduceStatus()
  if self.data and self.data.isGuardianTower and self.data.shieldSkillInfo then
    if self.AllianceBuildS3Produce ~= nil then
      self.AllianceBuildS3Produce:SetActive(false)
    end
    self.work:SetActive(false)
    self.divide1:SetActive(true)
    return
  end
  local seasonType = self.seasonType
  local buildId = self.data.buildId
  local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
  if meta ~= nil and (meta.type == AllianceBuildType.MilitaryCenter or meta.type == AllianceBuildType.MilitaryCenterS4 or meta.type == AllianceBuildType.Attachment) then
    local allianceBuildInfo
    if self.serverData and self.serverData.allianceBuildInfo then
      allianceBuildInfo = self.serverData.allianceBuildInfo
    end
    self.work:SetActive(false)
    if self.AllianceBuildS3Produce == nil then
      local state = self.data.state or AllianceMineStatus.Build
      if state ~= AllianceMineStatus.Build and state ~= AllianceMineStatus.Constructing then
        local prefabPath = "Assets/Main/SeasonRes/Shared/Prefabs/Component/AllianceBuildProduce.prefab"
        local produce = WorldAllianceBuildResProduce.New(self, self.transform, prefabPath, function()
          if ComponentIsValid(self) then
            self:RebuildLayout()
          end
        end)
        produce:SetActive(true)
        produce:ReInit(self.data, allianceBuildInfo)
        self.AllianceBuildS3Produce = produce
        table.insert(self.dynamicNodeList, produce)
        self.divide1:SetActive(true)
      else
        self.divide1:SetActive(false)
      end
    else
      self.divide1:SetActive(true)
      self.AllianceBuildS3Produce:SetActive(true)
      self.AllianceBuildS3Produce:ReInit(self.data, allianceBuildInfo)
    end
    local resourceNum = 0
    if allianceBuildInfo then
      resourceNum = toInt(allianceBuildInfo.resourceNum)
    end
    if meta ~= nil and (meta.type == AllianceBuildType.StoveCenter or meta.type == AllianceBuildType.MilitaryCenter) then
      if self.allianceId == LuaEntry.Player.allianceId then
        resourceNum = LuaEntry.Resource:GetCntByResType(ResourceType.AllianceStone)
      end
      self.product:SetActive(true)
      self.product:SetText(Localization:GetString("season_s3_alliance_building_tips03") .. ":" .. string.GetFormattedStr(resourceNum))
      self.product_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceStone))
    else
      self.product:SetActive(false)
    end
    local factionWarActivityType = SeasonUtil.GetFactionWarActivityType(seasonType)
    local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(factionWarActivityType)
    local actData
    if actList and 0 < #actList then
      actData = actList[1]
    end
    if actData ~= nil and actData.para_3 then
      local rate1, rate2 = string.split_ii(actData.para_3, "|")
      self.rate_root:SetActive(true)
      if meta.type == AllianceBuildType.MilitaryCenter or meta.type == AllianceBuildType.MilitaryCenterS4 then
        self.rate_txt:SetText(Localization:GetString("season_s3_alliance_building_tips05") .. " " .. (rate1 or 10) .. "%")
      elseif meta.type == AllianceBuildType.Attachment then
        self.rate_txt:SetText(Localization:GetString("season_s3_alliance_building_tips05") .. " " .. (rate2 or 5) .. "%")
      end
    else
      self.rate_root:SetActive(false)
    end
    self:RebuildLayout()
  elseif self.AllianceBuildS3Produce ~= nil then
    self.AllianceBuildS3Produce:SetActive(false)
  end
end

function WorldAllianceBuild:OnReturnClick()
  self.desc_root:SetActive(false)
end

function WorldAllianceBuild:OnInfoClick()
  if self.data ~= nil then
    if self.data and self.data.isGuardianTower and self.data.shieldSkillInfo then
      self.desc_root:SetActive(true)
      self.des_txt:SetLocalText("alliance_government_10005_03")
    else
      local buildId = self.data.buildId
      local alCityData = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
      if alCityData and alCityData.world_desc then
        self.desc_root:SetActive(true)
        self.des_txt:SetLocalText(alCityData.world_desc)
      end
    end
  end
end

function WorldAllianceBuild:OnEnable()
  base.OnEnable(self)
end

function WorldAllianceBuild:OnDisable()
  base.OnDisable(self)
end

function WorldAllianceBuild:OnAssistanceDetailInfo(pointId)
  pointId = pointId and tonumber(pointId)
  if pointId and pointId == self.pointId then
    self.view.ctrl:RequestWorldPointDetail()
  end
end

function WorldAllianceBuild:RefreshAssistance()
  if not self.dCompAssistance then
    return
  end
  local assistanceList = self.serverData and self.serverData.assistanceList
  if not assistanceList or #assistanceList <= 0 then
    self.dCompAssistance:SetActive(false)
  else
    self.dCompAssistance:SetActive(true)
    self.dCompAssistance:Setup({
      isCity = true,
      pointId = self.pointId,
      assistanceList = assistanceList,
      maxMember = self.serverData.maxAssistance,
      memberCount = self.serverData.currAssistance,
      totalPower = self.serverData.assistanceTotalPower,
      limit = 10
    })
    self:RebuildLayout()
  end
end

function WorldAllianceBuild:RebuildLayout()
  if IsNotNull(self.transform) then
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.details_list.transform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.info.transform)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
  end
end

function WorldAllianceBuild:ShowAllianceInfo(allianceInfo)
  local allianceName = allianceInfo.allianceName or "-"
  if allianceInfo.abbr ~= nil and allianceInfo.abbr ~= "" then
    allianceName = "[" .. allianceInfo.abbr .. "]" .. allianceInfo.allianceName
  end
  if self.allianceId == LuaEntry.Player.allianceId then
    self.player_name:SetText("<color=#0091e8>" .. allianceName .. "</color>")
  else
    self.player_name:SetText("<color=#e64141>" .. allianceName .. "</color>")
  end
  self.alliance_flag:LoadSprite(string.format(AL_FLAG_SPRITE_PATH, tostring(allianceInfo.icon)))
end

return WorldAllianceBuild
