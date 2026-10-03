local UIWorldPointBtn = BaseClass("UIWorldPointBtn", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local Localization = CS.GameEntry.Localization
local rapidjson = require("rapidjson")
local this_path = ""
local btn_image_path = "BtnImage"
local btn_text_path = "BtnImage/BtnText"
local effect_path = "effect"
local costPanel_path = "BtnImage/CostPanel"
local costIcon_path = "BtnImage/CostPanel/CostIcon"
local costText_path = "BtnImage/CostPanel/CostText"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
  self:AddUIListener(EventId.DispatchTaskUpdateSingle, self.RefreshStatus)
  self:AddUIListener(EventId.GhostreconRefreshWorldPointBtn, self.RefreshStatus)
  self:AddUIListener(EventId.WorldGetAllianceCollectResDetailUpdate, self.RefreshStatus)
  self:AddUIListener(EventId.MasteryFortifyDailyCountUpdate, self.RefreshStatus)
end

local function OnDisable(self)
  self:RemoveUIListener(EventId.DispatchTaskUpdateSingle, self.RefreshStatus)
  self:RemoveUIListener(EventId.GhostreconRefreshWorldPointBtn, self.RefreshStatus)
  self:RemoveUIListener(EventId.WorldGetAllianceCollectResDetailUpdate, self.RefreshStatus)
  self:RemoveUIListener(EventId.MasteryFortifyDailyCountUpdate, self.RefreshStatus)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.btn = self:AddComponent(UIButton, btn_image_path)
  self.btnImage = self:AddComponent(UIImage, btn_image_path)
  self.btnText = self:AddComponent(UIText, btn_text_path)
  self.anim = self:TryAddComponent(UIAnimator, this_path)
  if self.anim then
    self.anim:Enable(false)
  end
  self.btn:SetOnClick(function()
    self:OnBtnClick()
  end)
  self.effect = self:AddComponent(UIBaseContainer, effect_path)
  self.effect:SetActive(false)
  self.btnText:SetActive(false)
  self.costPanel = self:AddComponent(UIImage, costPanel_path)
  self.costIcon = self:AddComponent(UIImage, costIcon_path)
  self.costText = self:AddComponent(UIText, costText_path)
  self.costPanel:SetActive(false)
end

local function ComponentDestroy(self)
  UIGray.SetGray(self.btnImage.transform, false, true)
  self.effect:SetActive(false)
  self.btnText:SetActive(false)
  self.costPanel:SetActive(false)
  self.btn = nil
  self.btnImage = nil
  self.btnText = nil
  self.effect = nil
  self.anim = nil
end

function UIWorldPointBtn:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorldPointDetail, self.OnWorldPointDetail)
end

function UIWorldPointBtn:OnRemoveListener()
  self:RemoveUIListener(EventId.WorldPointDetail, self.OnWorldPointDetail)
  base.OnRemoveListener(self)
end

function UIWorldPointBtn:OnWorldPointDetail()
  if self.param and self.param.pointId and self.param.btnType == WorldPointBtnType.SendPowerHelper then
    local otherPowerWorkerNum, otherPowerWorkerMaxNum
    local data = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.param.pointId)
    if data then
      otherPowerWorkerNum = data.otherPowerWorkerNum
      otherPowerWorkerMaxNum = data.otherPowerWorkerMaxNum
    end
    if otherPowerWorkerNum and otherPowerWorkerMaxNum then
      self.btnText:SetActive(true)
      self.btnText:SetText(string.format("<color=#FFFFFF><size=36>%s/%s</size></color>", otherPowerWorkerNum, otherPowerWorkerMaxNum))
    else
      self.btnText:SetActive(false)
    end
  end
end

local function DataDefine(self)
  self.param = nil
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  local btnType = param.btnType
  self.param = param
  if btnType == WorldPointBtnType.Treasure then
    if self.param.info.pointData then
      local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(self.param.info.pointData.eventId)
      if template and template:JudgeIsDroneTreasure() then
        self.btnImage:LoadSpriteAuto(string.format(LoadPath.UIBuildBtns, "uibuild_btn_repair"))
      else
        self.btnImage:LoadSpriteAuto(LoadPath.GetBuildBtnSpritePath(btnType))
      end
    end
  else
    self.btnImage:LoadSpriteAuto(LoadPath.GetBuildBtnSpritePath(btnType))
    if btnType == WorldPointBtnType.AllyDrilStart then
      local stage = DataCenter.AllyDrillDataManager:GetCurStageAndCountDown()
      if stage ~= AllyDrillStage.ReadyStage or not DataCenter.AllianceBaseDataManager:IsR4orR5() then
        UIGray.SetGray(self.btnImage.transform, true, true)
      end
    end
    if btnType == WorldPointBtnType.MoveCity then
      CrossServerUtil.TryGetCrossEnableServerList()
    end
  end
  self.btnImage.transform:Set_localPosition(param.position.x, param.position.y, param.position.z)
  if param.pointId ~= nil then
    if btnType == WorldPointBtnType.DispatchTask or btnType == WorldPointBtnType.DispatchTaskHelp or btnType == WorldPointBtnType.DispatchTaskSteal or btnType == WorldPointBtnType.Firefighting or btnType == WorldPointBtnType.GhostreconTaskSteal or btnType == WorldPointBtnType.WorldSupplies or btnType == WorldPointBtnType.ZoneMobilizationDonateSupplies or btnType == WorldPointBtnType.AttackPlayerRuinBuilding or btnType == WorldPointBtnType.Charge or btnType == WorldPointBtnType.ReinforceWall or btnType == WorldPointBtnType.ChargeBack then
      self:RefreshStatus()
    end
  else
    self.btnText:SetActive(false)
    UIGray.SetGray(self.btnImage.transform, false, true)
  end
  if btnType == WorldPointBtnType.EliminateVirus and self.param.info and self.param.info.refuseTreadVirus ~= nil then
    self.refuseTreadVirus = self.param.info.refuseTreadVirus
    UIGray.SetGray(self.btnImage.transform, self.refuseTreadVirus, true)
  end
  if btnType == WorldPointBtnType.SendPowerHelper and self.param.info then
    UIGray.SetGray(self.btnImage.transform, false, true)
  end
  self:RefreshScout()
  self:OnWorldPointDetail()
  if self.param.byDetect then
    if btnType == WorldPointBtnType.AttackMonster or btnType == WorldPointBtnType.RallyBoss or btnType == WorldPointBtnType.AttackCity or btnType == WorldPointBtnType.AttackActBoss or btnType == WorldPointBtnType.DetectEventFakePVP or btnType == WorldPointBtnType.S0AllianceBossBuildingRally then
      self.effect.transform.position = self.btnImage.transform.position
      self.effect:SetActive(true)
      self.anim:Enable(true)
      self.anim:Play("V_ui_WorldTileBuildBtn_tip", 0, 0)
      local particleSystem = self.effect.transform:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
      if particleSystem ~= nil then
        local m = particleSystem.main
        m.startColor = CS.UnityEngine.ParticleSystem.MinMaxGradient(CS.UnityEngine.Color(0.9333, 0.4745, 0.1294, 1))
      end
    elseif btnType == WorldPointBtnType.HelperDetect or btnType == WorldPointBtnType.Collect or btnType == WorldPointBtnType.Treasure or btnType == WorldPointBtnType.Sample or btnType == WorldPointBtnType.Rescue then
      self.effect.transform.position = self.btnImage.transform.position
      self.effect:SetActive(true)
      self.anim:Enable(true)
      self.anim:Play("V_ui_WorldTileBuildBtn_tip", 0, 0)
      local particleSystem = self.effect.transform:GetComponent(typeof(CS.UnityEngine.ParticleSystem))
      if particleSystem ~= nil then
        local m = particleSystem.main
        m.startColor = CS.UnityEngine.ParticleSystem.MinMaxGradient(CS.UnityEngine.Color(0.1294, 0.7255, 0.9333, 1))
      end
    end
  end
end

function UIWorldPointBtn:RefreshStatus()
  local btnType = self.param and self.param.btnType or -1
  if self.param and self.param.pointId ~= nil and (btnType == WorldPointBtnType.DispatchTask or btnType == WorldPointBtnType.DispatchTaskHelp or btnType == WorldPointBtnType.DispatchTaskSteal) then
    local info = CS.SceneManager.World:GetPointInfo(self.param.pointId)
    if info ~= nil then
      local setGray = true
      local player = LuaEntry.Player
      local selfUid = player:GetUid()
      local now = UITimeManager:GetInstance():GetServerTime()
      local canAward = info.completionTime > 0 and now >= info.completionTime and info.rewarded == 0
      if canAward then
        local protectTime = tonumber(GetTableData(TableName.LwDispatchTask, info.cfgId, "protect_times")) * 60000
        if now >= info.completionTime + protectTime then
          setGray = false
        end
      elseif info.completionTime == 0 and selfUid == info.ownerUid then
        setGray = false
      end
      if selfUid == info.ownerUid then
        self.btnText:SetActive(false)
      elseif player:IsInAlliance() and player.allianceId == info.allianceId then
        self.btnText:SetActive(false)
      else
        local mgr = DataCenter.ActDispatchTaskDataManager
        local todayStealNum = mgr:GetTodayStealNum()
        local steal_count = mgr:GetDispatchSetting("steal_count")
        local stealMax = tonumber(GetTableData(TableName.LwDispatchTask, info.cfgId, "steal_maxtimes"))
        local txtColor = "<color=#1CEA2B>"
        if info.stealList:Contains(selfUid) then
          setGray = true
        elseif todayStealNum < steal_count then
          if stealMax > info.stealList.Count then
          else
            setGray = true
          end
        else
          setGray = true
        end
        if setGray then
          txtColor = "<color=#FFFFFF>"
        end
        self.btnText:SetActive(true)
        self.btnText:SetText(txtColor .. info.stealList.Count .. "/" .. stealMax .. "</color>")
      end
      UIGray.SetGray(self.btnImage.transform, setGray, true)
    else
      self.btnText:SetActive(false)
      UIGray.SetGray(self.btnImage.transform, false, true)
    end
  elseif btnType == WorldPointBtnType.WorldSupplies or btnType == WorldPointBtnType.Charge or btnType == WorldPointBtnType.ChargeBack then
    local gray = false
    local info = CS.SceneManager.World:GetPointInfo(self.param.pointId)
    cast(info, typeof(CS.WorldSuppliesPoint))
    if info then
      if btnType ~= WorldPointBtnType.Charge and btnType ~= WorldPointBtnType.ChargeBack then
        local config = LocalController:instance():getLine(TableName.LWIceSupplies, info.configId)
        if info.userCount >= config.total_limit then
          gray = true
        end
      end
      if not gray then
        local detailData = DataCenter.WorldPointDetailManager:GetWorldSuppliesPointDetailData(info.uuid)
        if detailData then
          if 0 < detailData.expireTime and detailData.type ~= WorldSuppliesType.DarknessSeasonSmallType then
            gray = true
          elseif self.param.btnType == WorldPointBtnType.Charge then
            local percent = detailData.chargeData and detailData.chargeData:GetPercent()
            if percent and 1 <= percent then
              gray = true
            end
          elseif self.param.btnType == WorldPointBtnType.ChargeBack then
            gray = not detailData:HasPlayer()
          else
            gray = detailData:HasPlayer()
          end
        end
      end
    end
    UIGray.SetGray(self.btnImage.transform, gray, true)
  elseif btnType == WorldPointBtnType.ZoneMobilizationDonateSupplies then
    local gray = false
    local info = CS.SceneManager.World:GetPointInfo(self.param.pointId)
    cast(info, typeof(CS.WorldSuppliesPoint))
    if info then
      local config = LocalController:instance():getLine(TableName.LWIceSupplies, info.configId)
      if info.userCount >= config.total_limit then
        gray = true
      else
        local limit = tonumber(config.limit)
        local listCount = 0
        local count = 0
        if info.uidList then
          listCount = info.uidList.Count
          for i = 0, listCount - 1 do
            if info.uidList[i] == LuaEntry.Player:GetUid() then
              count = count + 1
            end
          end
        end
        if limit <= count then
          gray = true
        end
      end
      if not gray then
        local detailData = DataCenter.WorldPointDetailManager:GetWorldSuppliesPointDetailData(info.uuid)
        if detailData then
          local curNum, maxNum = 0, 0
          if config.type == WorldSuppliesType.ZoneMobilizationType then
            maxNum = DataCenter.LWZoneMobilizationManager.allianceMax
            curNum = detailData.suppliesRewardTimes
          elseif config.type == WorldSuppliesType.ZoneMobilizationSmallType then
            maxNum = DataCenter.LWZoneMobilizationManager.personalMax
            curNum = detailData.playerSuppliesRewardTimes
          end
          if maxNum <= curNum then
            gray = true
          end
        end
      end
    end
    UIGray.SetGray(self.btnImage.transform, gray, true)
  elseif btnType == WorldPointBtnType.AttackPlayerRuinBuilding then
    local masteryData = DataCenter.MasteryManager:GetData()
    local id = masteryData and masteryData.home_id or 0
    local isEngineer = id == MasteryHome.Gather
    local gray = not isEngineer or not LuaEntry.Player:IsInAlliance()
    UIGray.SetGray(self.btnImage.transform, gray, true)
  elseif self.btnImage then
    UIGray.SetGray(self.btnImage.transform, false, true)
  end
  if self.param and self.param.pointId ~= nil and btnType == WorldPointBtnType.Firefighting then
    self.costPanel:SetActive(true)
    if DataCenter.BuildHelpStopFireManager:IsFree() then
      self.costIcon:SetActive(false)
      self.costText:SetLocalText("121059")
      self.costText:SetColor(Color.New(0.23921568627450981, 0.06666666666666667, 0.06274509803921569, 1))
      self.costPanel:LoadSprite(string.format(LoadPath.UIBuildBtns, "ljq_xiezhumiehuo_diban_02.png"))
    else
      self.costIcon:SetActive(true)
      self.costText:SetText(LuaEntry.DataConfig:TryGetNum("city_wall", "k9"))
      self.costText:SetColor(Color.New(0.03137254901960784, 0.15294117647058825, 0.058823529411764705, 1))
      self.costPanel:LoadSprite(string.format(LoadPath.UIBuildBtns, "ljq_xiezhumiehuo_diban_01.png"))
    end
  end
  if self.param and self.param.pointId ~= nil and btnType == WorldPointBtnType.GhostreconTaskSteal then
    local info = CS.SceneManager.World:GetPointInfo(self.param.pointId)
    if info then
      local cfg = DataCenter.ActGhostreconManager:GetTaskTemplate(info.cfgId)
      local todayStealNum = DataCenter.ActGhostreconManager.stealTimes
      local maxStealNum = DataCenter.ActGhostreconManager:GetNowSettingCfg().stealCount
      local taskStealNum = info.stealList.Count
      local taskMaxStealNum = cfg.stealMaxtimes
      local setGray = taskStealNum >= taskMaxStealNum or todayStealNum >= maxStealNum or info.completionTime > UITimeManager:GetInstance():GetServerTime()
      if 0 < taskStealNum then
        for i = 1, taskStealNum do
          local uid = info.stealList[i - 1]
          if uid == LuaEntry.Player.uid then
            setGray = true
            break
          end
        end
      end
      local txtColor = "<color=#1CEA2B>"
      if setGray then
        txtColor = "<color=#FFFFFF>"
      end
      self.btnText:SetActive(true)
      self.btnText:SetText(txtColor .. taskStealNum .. "/" .. taskMaxStealNum .. "</color>")
      UIGray.SetGray(self.btnImage.transform, setGray, not setGray)
    end
  end
  if self.param and self.param.pointId ~= nil and btnType == WorldPointBtnType.ReinforceWall then
    local fortifyData = DataCenter.MasteryManager:GetFortifyDailyCount(self.param.info.ownerUid)
    if fortifyData then
      local used = fortifyData.usedCount
      local limit = fortifyData.dailyLimit
      local txtColor = used < limit and "<color=#1CEA2B>" or "<color=#FFFFFF>"
      self.btnText:SetActive(true)
      self.btnText:SetText(txtColor .. used .. "/" .. limit .. "</color>")
      if used >= limit then
        UIGray.SetGray(self.btnImage.transform, true, true)
      else
        UIGray.SetGray(self.btnImage.transform, false, true)
      end
    else
      self.btnText:SetText("")
      UIGray.SetGray(self.btnImage.transform, false, false)
    end
  end
end

local function OnBtnClick(self)
  local btnType = self.param.btnType
  local pointInfo = self.param.info
  local isDragonWorld = BattleFieldUtil.InBattleField()
  local uuid = self.view.ctrl.uuid
  local pointId = self.view.ctrl.pointId
  local serverId = self.view.ctrl.serverId
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local curServerId = serverId or LuaEntry.Player:GetCurServerId()
  local isCrossServer = loginServerId ~= serverId
  local bigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(serverId)
  if bigMapMode then
    local theSeasonTypeView = SeasonUtil.GetSeasonType(false, true, ServerEnum.View)
    if btnType == WorldPointBtnType.AttackMonster or btnType == WorldPointBtnType.RallyBoss or btnType == WorldPointBtnType.S0AllianceBossBuildingRally then
      local special = pointInfo.special
      if special == WorldMonsterSpecialType.CityStrongholdPVP then
        if self.param.info.belongSelf then
          UIUtil.ShowTipsId("season_tips204")
          self.view.ctrl:CloseSelf(true)
          return
        end
        if self.param.info.canAttack == 2 then
          UIUtil.ShowTipsId("season_tips226")
          self.view.ctrl:CloseSelf(true)
          return
        end
        if theSeasonTypeView == SeasonMapType.NineNationRainforest then
          local isDeclareDay = DataCenter.UILWSeasonAllianceWarTimeManager:IsDeclareDay()
          if not isDeclareDay then
            return UIUtil.ShowTipsId("s6_stronghold_tips01")
          end
        end
      end
      if special == WorldMonsterSpecialType.CityStrongholdPVE or special == WorldMonsterSpecialType.CityStrongholdPVP or special == WorldMonsterSpecialType.CityStrongholdBOSS then
        local cityId = SceneUtils.GetZoneIdByPosId(pointId, curServerId)
        local cityTemplate = DataCenter.AllianceCityTemplateManager:GetTemplate(cityId, curServerId)
        if cityTemplate ~= nil then
          local only_original_zone = cityTemplate.only_original_zone
          if only_original_zone == -1 and mySourceServerId ~= serverId then
            UIUtil.ShowTipsId("s5_map_ui_38")
            self.view.ctrl:CloseSelf(true)
            return
          end
          local city_info = cityTemplate:GetPointInfo()
          if city_info then
            local allianceCityPointInfo = SeasonUtil.TryParseAllianceCityPointInfo(city_info.PointType, city_info.extraInfo, city_info)
            if allianceCityPointInfo ~= nil then
              local curTime = UITimeManager:GetInstance():GetServerSeconds()
              local protectTime = allianceCityPointInfo.protectTime or 0
              if curTime < toInt(protectTime) then
                UIUtil.ShowTipsId("s5_map_tips_1")
                self.view.ctrl:CloseSelf(true)
                return
              end
            end
          end
        end
      end
    end
  end
  if isCrossServer and not isDragonWorld then
    local isMyBerserkBoss = false
    if (btnType == WorldPointBtnType.BerserkBossRank or btnType == WorldPointBtnType.BerserkBossAttack) and srcSameGroup and loginSameGroup and curServerId == mySourceServerId then
      isMyBerserkBoss = true
    end
    if bigMapMode and (btnType == WorldPointBtnType.AttackCity or btnType == WorldPointBtnType.AttackMonster or btnType == WorldPointBtnType.AttackArmyCollect or btnType == WorldPointBtnType.ScoutCity or btnType == WorldPointBtnType.AssistanceCity or btnType == WorldPointBtnType.Search or btnType == WorldPointBtnType.Detail or btnType == WorldPointBtnType.CheckActBossRank or btnType == WorldPointBtnType.Treasure or btnType == WorldPointBtnType.AttackHSR or btnType == WorldPointBtnType.TradeHSR or btnType == WorldPointBtnType.CallBack or btnType == WorldPointBtnType.Collect or btnType == WorldPointBtnType.S0AllianceBossBuildingRally or isMyBerserkBoss) then
      if not loginSameGroup then
        if self.view ~= nil and self.view.ctrl ~= nil then
          self.view.ctrl:CloseSelf(true)
        end
        UIUtil.ShowTipsId("season_s5_march_tips03")
        return
      end
    elseif btnType == WorldPointBtnType.AttackActBoss then
    elseif btnType == WorldPointBtnType.MoveCity then
      local SourceServerId = LuaEntry.Player:GetSourceServerId()
      if bigMapMode and curSameGroup then
      elseif curServerId ~= SourceServerId and CrossServerUtil.IsCrossMoveCD(true, curServerId) then
        return
      end
      local moveType = MoveCityUtil.TryGetMoveCityType(curServerId)
      if moveType then
        if MoveCityUtil.TryMoveCity(pointId, moveType) then
          if self.view ~= nil and self.view.ctrl ~= nil then
            self.view.ctrl:CloseSelf(true)
          end
          CrossServerUtil.SetLastJumpToParam({
            mode = JumpServerMode.CrossServerMoveCity,
            type = moveType,
            serverId = curServerId
          })
        end
      elseif SeasonUtil.CurServerIsInSeason() then
        UIUtil.ShowTipsId("season_tips169")
      else
        UIUtil.ShowTipsId("104274")
      end
      return
    elseif btnType == WorldPointBtnType.MasterySkill then
      if SeasonUtil.InSeasonBigMapMode() and SeasonUtil.IsInSameGroup(LuaEntry.Player:GetCurServerId(), ServerEnum.Login) then
      else
        UIUtil.ShowTipsId("season_tips143")
        return
      end
    elseif btnType == WorldPointBtnType.KirovBossRank and DataCenter.ActivityKillZombieManager:GetActivityData() ~= nil then
    elseif btnType == WorldPointBtnType.KillZombieKirovBox and DataCenter.ActivityKillZombieManager:GetActivityData() ~= nil then
    elseif btnType == WorldPointBtnType.DispatchTaskSteal and DataCenter.ActDispatchTaskDataManager:IsOpenCrossSteal() then
    elseif btnType == WorldPointBtnType.ReinforceWall and loginSameGroup then
    elseif not isDragonWorld and btnType ~= WorldPointBtnType.AttackTrain and btnType ~= WorldPointBtnType.GhostreconTaskSteal and btnType ~= WorldPointBtnType.DispatchTaskHelp then
      UIUtil.ShowTipsId("season_tips143")
      return
    end
  end
  if btnType == WorldPointBtnType.MummyConvert then
    MarchUtil.LaunchScout(MarchTargetType.SEASON_MUMMY_CONVERT, pointId, uuid)
  elseif btnType == WorldPointBtnType.GuardianTowerSkill then
    local memberInfo = DataCenter.AllianceGovernmentSkillManager:GetMemberInfoByOfficialPos(LWAlMemberOffcialType.Al_Ambassadoe)
    if memberInfo ~= nil and memberInfo.uid == LuaEntry.Player.uid then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceSkill, {anim = true, hideTop = true}, {pointId = pointId, uuid = uuid})
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceGovernmentSkill, {anim = true, hideTop = true}, LWAlMemberOffcialType.Al_Ambassadoe)
    end
  elseif btnType == WorldPointBtnType.BuildCityAttachment then
    local baseData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    local now = UITimeManager:GetInstance():GetServerTime()
    if baseData and baseData.joinTime and now < baseData.joinTime + 86400000 then
      local leftTime = baseData.joinTime + 86400000 - now
      if 0 < leftTime then
        local mgr = UITimeManager:GetInstance()
        UIUtil.ShowTips(Localization:GetString("season_builders_alliance_tips_45", mgr:MilliSecondToFmtString(leftTime)))
        return
      end
    end
    local resNeed = 1000
    local buildAdd = 1000
    local expAdd = 1000
    local cfg = DataCenter.SeasonFarmerTemplateManager:GetMainCfg()
    if cfg and not string.IsNullOrEmpty(cfg.material) then
      local tmp = string.split(cfg.material, "|")
      resNeed = toInt(tmp[1] or 1000)
      buildAdd = toInt(tmp[2] or 1000)
      expAdd = toInt(tmp[3] or 1000)
    end
    local tipText = Localization:GetString("season_builders_alliance_tips_7", resNeed, buildAdd)
    local resCount = toInt(DataCenter.ItemData:GetItemCount(cfg.resource_item))
    UIUtil.ShowUserPrompt({
      title = Localization:GetString("100378"),
      desc = tipText,
      res = {
        iconPath = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.AllianceFarmerExpItem),
        countHas = resCount,
        countNeed = resNeed
      },
      todayNotShown = TodayNoSecondConfirmType.CityAttachmentBuildSecondConfirm,
      funConfirm = function()
        if resCount < resNeed then
          UIUtil.ShowTipsId(120021)
        else
          MarchUtil.LaunchScout(MarchTargetType.SEASON_FARMER_SEND_RES, pointId, uuid)
        end
      end,
      funCancel = function()
      end
    })
  elseif btnType == WorldPointBtnType.DestroyCityAttachment then
    if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
      UIUtil.ShowTipsId(803040)
      return
    end
    local param = {}
    param.tipText = Localization:GetString("season_builders_alliance_tips_14")
    param.btnNum = 2
    param.showToggle = false
    param.delayConfirm = {delayTime = 10}
    
    function param.sureAction()
      if DataCenter.AllianceBaseDataManager:IsR4orR5() then
        SFSNetwork.SendMessage(MsgDefines.DestroyCityAttachmentBuild, uuid)
      else
        UIUtil.ShowTipsId(803040)
      end
    end
    
    UIUtil.ShowSecondMessageByParam(param)
  elseif btnType == WorldPointBtnType.SeasonStoveCenterMove or btnType == WorldPointBtnType.SeasonMummyCenterMove then
    if LuaEntry.Player:IsInAlliance() == false then
      UIUtil.ShowTipsId(371059)
      return
    end
    if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
      UIUtil.ShowTipsId(803040)
      return
    end
    local theCarrier = DataCenter.AllianceMineManager:GetAllianceStoveCenterCarrier()
    local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
    if theStoveCenter == nil or theStoveCenter:Injuried() then
      UIUtil.ShowTipsId("season_s2_alliance_building_tips007")
      return
    end
    if pointInfo == nil or pointInfo.state == AllianceMineStatus.Ruin or pointInfo.state == AllianceMineStatus.Build then
      UIUtil.ShowTipsId("season_s2_alliance_building_tips008")
      return
    end
    if pointInfo and pointInfo.curHp < pointInfo.maxHp then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local deltaTime = curTime - pointInfo.lastHpTime
      local cur_hp = math.min(deltaTime / 1000 * pointInfo.coverSpeed + pointInfo.curHp, pointInfo.maxHp)
      if cur_hp < pointInfo.maxHp then
        UIUtil.ShowTipsId("season_s2_alliance_building_tips008")
        return
      end
    end
    if theStoveCenter and theCarrier then
      local srcUuid = theStoveCenter.uuid
      local tarUuid = theCarrier.uuid
      UIUtil.ShowMessage(Localization:GetString("season_s2_alliance_building_tips017"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.MoveAllianceMine, srcUuid, tarUuid)
      end, function()
      end)
    end
  elseif btnType == WorldPointBtnType.SeasonStoveCenterInfo then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonStoveCenter, {anim = true, hideTop = true})
  elseif btnType == WorldPointBtnType.SeasonMummyCenterInfo then
    local seasonType = SeasonUtil.GetSeasonType()
    if seasonType == SeasonMapType.Mummy then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonMilitaryCenter, {anim = true, hideTop = true})
    elseif seasonType == SeasonMapType.Darkness then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeason4Center, {anim = true, hideTop = true})
    end
  elseif btnType == WorldPointBtnType.EliminateVirus then
    if self.refuseTreadVirus then
      UIUtil.ShowTipsId("season_s1_add_virus_tips06")
      return
    else
      SFSNetwork.SendMessage(MsgDefines.GetNewUserInfo, self.view.ctrl.ownerUid)
      MarchUtil.LaunchScout(MarchTargetType.SCOUT_TREAT, pointId, self.view.ctrl.uuid)
    end
  elseif btnType == WorldPointBtnType.WorldSupplies then
    self:WorldSupplies(self.view.ctrl.uuid, pointId)
  elseif btnType == WorldPointBtnType.ZoneMobilizationDonateSupplies then
    local detailData = DataCenter.WorldPointDetailManager:GetWorldSuppliesPointDetailData(self.view.ctrl.uuid)
    if detailData then
      local maxFlag = false
      local info = CS.SceneManager.World:GetPointInfo(self.param.pointId)
      cast(info, typeof(CS.WorldSuppliesPoint))
      if info then
        local config = LocalController:instance():getLine(TableName.LWIceSupplies, info.configId)
        local maxCount = tonumber(config.total_limit)
        local listCount = 0
        local limit = tonumber(config.limit)
        local count = 0
        if info.uidList then
          listCount = info.uidList.Count
          for i = 0, listCount - 1 do
            if info.uidList[i] == LuaEntry.Player:GetUid() then
              count = count + 1
            end
          end
        end
        if maxCount <= listCount then
          UIUtil.ShowSingleTip(Localization:GetString("zone_mobilization_reward_limit_tips"))
        elseif limit <= count then
          UIUtil.ShowSingleTip(Localization:GetString("season_s2_ice_supplies_1"))
        else
          local curNum, maxNum = 0, 0
          if config.type == WorldSuppliesType.ZoneMobilizationType then
            maxNum = DataCenter.LWZoneMobilizationManager.allianceMax
            curNum = detailData.suppliesRewardTimes
          elseif config.type == WorldSuppliesType.ZoneMobilizationSmallType then
            maxNum = DataCenter.LWZoneMobilizationManager.personalMax
            curNum = detailData.playerSuppliesRewardTimes
          end
          if maxNum <= curNum then
            UIUtil.ShowSingleTip(Localization:GetString("zone_mobilization_supplies_get_full"))
          else
            maxFlag = true
          end
        end
        if maxFlag then
          local flag, notice = detailData:CheckBtnState()
          if flag then
            if info.createTime and 0 < info.createTime then
              local lock = false
              if string.IsNullOrEmpty(info.discovererAllianceId) then
                lock = info.discovererUid ~= LuaEntry.Player.uid
              else
                lock = info.discovererAllianceId ~= LuaEntry.Player.allianceId
              end
              if lock then
                local curTime = UITimeManager:GetInstance():GetServerTime()
                local time = info.createTime + DataCenter.WorldPointProtectionManager.protectionTime * 1000
                if curTime < time then
                  UIUtil.ShowSingleTip(Localization:GetString("zone_mobilization_shield_alliance"))
                  return
                end
              end
            end
            MarchUtil.LaunchScout(MarchTargetType.SCOUT_SUPPLIES, self.view.ctrl.pointId, self.view.ctrl.uuid)
          else
            UIUtil.ShowSingleTip(notice)
          end
        end
      end
    end
  elseif btnType == WorldPointBtnType.Charge then
    local detailData = DataCenter.WorldPointDetailManager:GetWorldSuppliesPointDetailData(self.view.ctrl.uuid)
    if detailData and detailData.chargeData then
      local uid = self.view.ctrl.uuid
      local percent = detailData.chargeData:GetPercent()
      if percent and 1 <= percent then
        self:WorldSupplies(uid, pointId)
        return
      end
      if detailData.type == WorldSuppliesType.DarknessSeasonSmallType then
        MarchUtil.LaunchPowerHelp(MarchTargetType.CHARGE_SUPPLIES, pointId, uid)
      else
        do
          local use = detailData and detailData.rewardCount or 0
          local max = detailData and detailData.rewardMax or 0
          if use >= max then
            local tips = detailData and detailData.rewardLeftCount and Localization:GetString("season4_supplies_UI_30") or Localization:GetString("season4_supplies_tips_5", max)
            UIUtil.ShowSecondMessage("", tips, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
              MarchUtil.LaunchPowerHelp(MarchTargetType.CHARGE_SUPPLIES, pointId, uid)
            end, nil, nil, nil, nil, nil, nil, nil, nil, false)
          else
            MarchUtil.LaunchPowerHelp(MarchTargetType.CHARGE_SUPPLIES, pointId, uid)
          end
        end
      end
    end
  elseif btnType == WorldPointBtnType.ChargeBack then
    local detailData = DataCenter.WorldPointDetailManager:GetWorldSuppliesPointDetailData(self.view.ctrl.uuid)
    if detailData and detailData.chargeData then
      local workerData = DataCenter.SeasonPowerWorkerManager:GetPowerWorkerByPointId(self.view.ctrl.pointId)
      if workerData and workerData.uuid then
        SFSNetwork.SendMessage(MsgDefines.CallbackMyPowerWorker, workerData.uuid)
      else
        UIUtil.ShowTipsId("120632")
      end
    end
  elseif self.param.btnType == WorldPointBtnType.AttackAllianceActMine then
    if LuaEntry.Player:IsInAlliance() == false then
      UIUtil.ShowTipsId(371059)
      return
    end
    local oneData = self.param.info
    if 0 < oneData.coverSpeed and oneData.state == AllianceMineStatus.Build and oneData.curHp and oneData.maxHp and oneData.curHp ~= oneData.curHp then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local deltaTime = curTime - oneData.lastHpTime
      local cur_hp = math.min(deltaTime / 1000 * oneData.coverSpeed + oneData.curHp, oneData.maxHp)
      if cur_hp < oneData.maxHp then
        UIUtil.ShowTipsId("season_tiles_popui_info003")
        return
      end
    end
    local curValue = DataCenter.AllianceMineManager:GetActMineResNum()
    local maxValue = LuaEntry.DataConfig:TryGetNum("act_alliance_mine", "k4")
    if curValue >= maxValue then
      UIUtil.ShowMessage(Localization:GetString("374029"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_ACT_ALLIANCE_MINE, pointId, uuid, -1, 0)
      end, function()
      end)
    else
      MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_ACT_ALLIANCE_MINE, pointId, uuid, -1, 0)
    end
  elseif self.param.btnType == WorldPointBtnType.RallyAllianceActMine then
    if LuaEntry.Player:IsInAlliance() == false then
      UIUtil.ShowTipsId(371059)
      return
    end
    local oneData = self.param.info
    if oneData.coverSpeed > 0 and oneData.state == AllianceMineStatus.Build and oneData.curHp and oneData.maxHp and oneData.curHp ~= oneData.curHp then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      local deltaTime = curTime - oneData.lastHpTime
      local cur_hp = math.min(deltaTime / 1000 * oneData.coverSpeed + oneData.curHp, oneData.maxHp)
      if cur_hp < oneData.maxHp then
        UIUtil.ShowTipsId("season_tiles_popui_info003")
        return
      end
    end
    if not DataCenter.BuildManager:IsExistBuildByTypeLv(BuildingTypes.FUN_BUILD_SMITHY, 1) then
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_SMITHY, WorldTileBtnType.City_Upgrade)
      return
    else
      local allianceuid = LuaEntry.Player.allianceId
      if allianceuid == "" then
        UIUtil.ShowTipsId(390172)
      elseif 1 >= LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ALLIANCE_TEAM_MAX_ARMY) then
        local building = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_SMITHY)
        if building ~= nil then
          local name = Localization:GetString(building.name)
          UIUtil.ShowTips(Localization:GetString("390812", name))
        end
      else
        local curValue = DataCenter.AllianceMineManager:GetActMineResNum()
        local maxValue = LuaEntry.DataConfig:TryGetNum("act_alliance_mine", "k4")
        if curValue >= maxValue then
          UIUtil.ShowMessage(Localization:GetString("374029"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            MarchUtil.OnClickStartMarch(MarchTargetType.RALLY_FOR_ACT_ALLIANCE_MINE, pointId, uuid, -1, 1)
          end, function()
          end)
        else
          local selfMarchList = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
          for i, march in pairs(selfMarchList) do
            if march:GetMarchTargetType() == MarchTargetType.RALLY_FOR_ACT_ALLIANCE_MINE and march.targetUuid == self.view.ctrl.uuid then
              UIUtil.ShowTipsId("season_tips252")
              return
            end
          end
          MarchUtil.OnClickStartMarch(MarchTargetType.RALLY_FOR_ACT_ALLIANCE_MINE, pointId, uuid, -1, 1)
        end
      end
    end
  elseif self.param.btnType == WorldPointBtnType.AllianceMineCallback then
    local hasMarch, marchInfo = DataCenter.AllianceMineManager:CheckIfHasMarch(self.param.info.pointId)
    if hasMarch == true and marchInfo ~= nil then
      MarchUtil.OnBackHome(marchInfo.uuid)
    end
  elseif self.param.btnType == WorldPointBtnType.AllianceMineDetail then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceBuildingCollect, self.param.info.pointId, self.param.info.uuid)
  elseif self.param.btnType == WorldPointBtnType.AllianceActMineDetail then
    if self.param.info ~= nil and self.param.info.state == AllianceMineStatus.Ruin then
      UIUtil.ShowTipsId(374022)
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceBuildingCollect, self.param.info.pointId, self.param.info.uuid)
  elseif self.param.btnType == WorldPointBtnType.ReBuildAllianceRuin then
    if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
      UIUtil.ShowTipsId(803040)
      return
    end
    local theUuid = self.param.info.uuid
    UIUtil.ShowMessage(Localization:GetString("season_rebuild_tips003"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.WorldFixAllianceBuilding, theUuid)
    end)
  elseif self.param.btnType == WorldPointBtnType.AllianceMine_Construct then
    if not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_TRAINFIELD_1) and not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_TRAINFIELD_2) and not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_TRAINFIELD_3) and not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_TRAINFIELD_4) then
      UIUtil.ShowTipsId(129042)
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_TRAINFIELD_1)
      return
    else
      local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
      for _, march in pairs(selfMarch) do
        if march:GetMarchTargetType() == MarchTargetType.BUILD_ALLIANCE_BUILDING then
          local info = CS.SceneManager.World:GetPointInfoByUuid(march.targetUuid)
          if info ~= nil then
            self.isHaveOwnerMarche = true
          end
        end
      end
      if self.isHaveOwnerMarche then
        UIUtil.ShowTipsId(300789)
      else
        local alMineMax = DataCenter.AllianceMineManager:GetAllianceMineSlotCountForConstruct(self.param.info.uuid)
        if alMineMax <= 0 then
          UIUtil.ShowTipsId(300791)
        else
          MarchUtil.OnClickStartMarch(MarchTargetType.BUILD_ALLIANCE_BUILDING, self.param.info.pointId, self.param.info.uuid)
        end
      end
    end
  elseif self.param.btnType == WorldPointBtnType.AllianceMine_Collect then
    if not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_TRAINFIELD_1) and not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_TRAINFIELD_2) and not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_TRAINFIELD_3) and not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_TRAINFIELD_4) then
      UIUtil.ShowTipsId(129042)
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_TRAINFIELD_1)
      return
    else
      local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
      for _, march in pairs(selfMarch) do
        if march:GetMarchTargetType() == MarchTargetType.COLLECT_ALLIANCE_BUILD_RESOURCE then
          local info = CS.SceneManager.World:GetPointInfoByUuid(march.targetUuid)
          if info ~= nil then
            self.isHaveOwnerMarche = true
          end
        end
      end
      if self.isHaveOwnerMarche then
        UIUtil.ShowTipsId(129004)
      else
        MarchUtil.OnClickStartMarch(MarchTargetType.COLLECT_ALLIANCE_BUILD_RESOURCE, self.param.info.pointId, self.param.info.uuid)
      end
    end
  elseif self.param.btnType == WorldPointBtnType.AllianceActMine_Collect then
    if not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_TRAINFIELD_1) and not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_TRAINFIELD_2) and not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_TRAINFIELD_3) and not DataCenter.BuildManager:HasBuilding(BuildingTypes.FUN_BUILD_TRAINFIELD_4) then
      UIUtil.ShowTipsId(129042)
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_TRAINFIELD_1)
      return
    else
      local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
      for _, march in pairs(selfMarch) do
        if march:GetMarchTargetType() == MarchTargetType.ASSISTANCE_COLLECT_ACT_ALLIANCE_MINE then
          local info = CS.SceneManager.World:GetPointInfoByUuid(march.targetUuid)
          if info ~= nil then
            self.isHaveOwnerMarche = true
          end
        end
      end
      if self.isHaveOwnerMarche then
        UIUtil.ShowTipsId(129004)
      else
        MarchUtil.OnClickStartMarch(MarchTargetType.ASSISTANCE_COLLECT_ACT_ALLIANCE_MINE, self.param.info.pointId, self.param.info.uuid)
      end
    end
  elseif self.param.btnType == WorldPointBtnType.ScoutAllianceActMine then
    if LuaEntry.Player:IsInAlliance() == false then
      UIUtil.ShowTipsId(371059)
      return
    end
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_RADAR_CENTER)
    if not buildData then
      UIUtil.ShowTipsId(300608)
      self.view.ctrl:CloseSelf(true)
      return
    end
    MarchUtil.LaunchScout(MarchTargetType.SCOUT_ACT_ALLIANCE_MINE, self.view.ctrl.pointId, self.view.ctrl.uuid)
  elseif self.param.btnType == WorldPointBtnType.PutAresMissile then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceGovernmentSkill, {anim = true, hideTop = true}, LWAlMemberOffcialType.Deputy_Al_Leader)
  elseif self.param.btnType == WorldPointBtnType.GoddessMummy then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceGovernmentSkill, {anim = true, hideTop = true}, LWAlMemberOffcialType.War_Commander)
  elseif self.param.btnType == WorldPointBtnType.RallyAllianceBuild then
    if self.param.info and self.param.info.state == AllianceMineStatus.Build and SeasonUtil.GetSeasonType() ~= SeasonMapType.Snow and self.param.info.canAttackIt ~= true then
      UIUtil.ShowTipsId("season_tips181")
      return
    end
    if isCrossServer and LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
      UIUtil.ShowTipsId(111264)
      return
    end
    if SeasonUtil.IsInSeasonDesertMode() and isCrossServer then
      local state, dialog = CrossServerUtil.CheckCanUseInDeclareWarTarget(MarchTargetType.RALLY_ALLIANCE_BUILDING)
      if state == false then
        UIUtil.ShowTipsId(dialog)
        return
      end
    end
    if not DataCenter.BuildManager:IsExistBuildByTypeLv(BuildingTypes.FUN_BUILD_SMITHY, 1) then
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_SMITHY, WorldTileBtnType.City_Upgrade)
      return
    else
      local seasonType = SeasonUtil.GetSeasonType()
      local allianceuid = LuaEntry.Player.allianceId
      if allianceuid == "" then
        UIUtil.ShowTipsId(390172)
      elseif LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ALLIANCE_TEAM_MAX_ARMY) <= 1 then
        local building = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_SMITHY)
        if building ~= nil then
          local name = Localization:GetString(building.name)
          UIUtil.ShowTips(Localization:GetString("390812", name))
        end
      else
        local inProtect, alreadyExitOccupy = SeasonUtil.CanAttackAllianceBuild(self.view.ctrl.pointId)
        if SeasonUtil.SeasonHasMilitaryCenter(seasonType) then
          inProtect = false
          alreadyExitOccupy = true
        end
        if inProtect == true then
          UIUtil.ShowTipsId(110242)
        elseif alreadyExitOccupy == false then
          UIUtil.ShowTipsId("season_city_battle_tips001")
          WorldDesertSelectEffectManager:GetInstance():ShowWarnPos(self.view.ctrl.pointId, 3, 2)
        else
          local selfMarchList = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
          for i, march in pairs(selfMarchList) do
            if march:GetMarchTargetType() == MarchTargetType.RALLY_ALLIANCE_BUILDING and march.targetUuid == self.view.ctrl.uuid then
              UIUtil.ShowTipsId("season_tips252")
              return
            end
          end
          local tipMsg, tipType = self:NeedTipMessageWhenClick()
          if tipMsg ~= nil and tipMsg ~= "" and tipType ~= nil then
            UIUtil.TryShowConfirm(tipType, tipMsg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
              MarchUtil.OnClickStartMarch(MarchTargetType.RALLY_ALLIANCE_BUILDING, pointId, uuid, -1, 1)
            end, function()
            end, nil, nil, false, nil, nil)
          else
            MarchUtil.OnClickStartMarch(MarchTargetType.RALLY_ALLIANCE_BUILDING, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 1)
          end
        end
      end
    end
  elseif self.param.btnType == WorldPointBtnType.AttackAllianceBuild then
    if self.param.info and self.param.info.state == AllianceMineStatus.Build and self.param.info.canAttackIt ~= true then
      UIUtil.ShowTipsId("season_tips181")
      return
    end
    if SeasonUtil.IsInSeasonDesertMode() and isCrossServer then
      local state, dialog = CrossServerUtil.CheckCanUseInDeclareWarTarget(MarchTargetType.ATTACK_ALLIANCE_BUILDING)
      if state == false then
        UIUtil.ShowTipsId(dialog)
        return
      end
    end
    if not LuaEntry.Player:IsInAlliance() then
      UIUtil.ShowTipsId(371059)
      self.view.ctrl:CloseSelf(true)
      return
    end
    local inProtect, alreadyExitOccupy = SeasonUtil.CanAttackAllianceBuild(self.view.ctrl.pointId)
    if inProtect == true then
      UIUtil.ShowTipsId(110242)
    elseif alreadyExitOccupy == false then
      UIUtil.ShowTipsId("season_city_battle_tips001")
      WorldDesertSelectEffectManager:GetInstance():ShowWarnPos(self.view.ctrl.pointId, 3, 2)
    else
      local tipMsg, tipType = self:NeedTipMessageWhenClick()
      if tipMsg ~= nil and tipMsg ~= "" and tipType ~= nil then
        UIUtil.TryShowConfirm(tipType, tipMsg, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_ALLIANCE_BUILDING, pointId, uuid, -1, 0)
        end, function()
        end, nil, nil, false, nil, nil)
      else
        MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_ALLIANCE_BUILDING, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 0)
      end
    end
  elseif self.param.btnType == WorldPointBtnType.AssistanceAllianceBuild then
    if isCrossServer and LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
      UIUtil.ShowTipsId(111264)
      return
    end
    if SeasonUtil.IsInSeasonDesertMode() and isCrossServer then
      local state, dialog = CrossServerUtil.CheckCanUseInDeclareWarTarget(MarchTargetType.ASSISTANCE_ALLIANCE_BUILDING)
      if state == false then
        UIUtil.ShowTipsId(dialog)
        return
      end
    end
    local allianceuid = LuaEntry.Player.allianceId
    if allianceuid == "" then
      UIUtil.ShowTipsId(390172)
    elseif WorldBattleUtil.EnableShowWorldAssistanceInfo() and not BattleFieldUtil.InBattleField() then
      WorldBattleUtil.TrySendAssistanceMarch({
        uuid = self.param.info.uuid,
        playerUid = "",
        pointId = self.param.info.pointId,
        asType = AssistanceType.AllianceBuild,
        isThroneCity = false,
        isCrossServerThrone = false
      })
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.param.info.uuid, "", self.param.info.pointId, AssistanceType.AllianceBuild)
    end
  elseif self.param.btnType == WorldPointBtnType.FoldUpAllianceBuild then
    local buildId = self.param.info.buildId
    local mineInfo = DataCenter.AllianceMineManager:GetAllianceFrontDataByBuildId(buildId)
    local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
    if template ~= nil then
      local maxNum = template.resDurable
      local curNum = 0
      if mineInfo ~= nil then
        curNum = mineInfo:GetAllianceFrontDurability()
      end
      if maxNum > curNum then
        UIUtil.ShowTipsId(302737)
        return
      end
    end
    UIUtil.ShowMessage(Localization:GetString("302874"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      SFSNetwork.SendMessage(MsgDefines.WorldFoldUpAllianceBuilding, uuid)
    end)
  elseif self.param.btnType == WorldPointBtnType.ScoutAllianceBuild then
    if isCrossServer and LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
      UIUtil.ShowTipsId(111264)
      return
    end
    if SeasonUtil.IsInSeasonDesertMode() and isCrossServer then
      local state, dialog = CrossServerUtil.CheckCanUseInDeclareWarTarget(MarchTargetType.SCOUT_ALLIANCE_BUILDING)
      if state == false then
        UIUtil.ShowTipsId(dialog)
        return
      end
    end
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_RADAR_CENTER)
    if not buildData then
      UIUtil.ShowTipsId(300608)
      self.view.ctrl:CloseSelf(true)
      return
    end
    if not LuaEntry.Player:IsInAlliance() then
      UIUtil.ShowTipsId(371059)
      self.view.ctrl:CloseSelf(true)
      return
    end
    local needConfirm, status, title, content, needBreakProtect = DataCenter.StatusManager:ShowTipForWarFever()
    if needBreakProtect == true then
      UIUtil.ShowShieldBreakTip(content, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        MarchUtil.LaunchScout(MarchTargetType.SCOUT_ALLIANCE_BUILDING, pointId, uuid)
      end, function()
      end)
    else
      MarchUtil.LaunchScout(MarchTargetType.SCOUT_ALLIANCE_BUILDING, self.view.ctrl.pointId, self.view.ctrl.uuid)
    end
  elseif self.param.btnType == WorldPointBtnType.AttackMonster then
    local special = self.param.info.special
    if special == WorldMonsterSpecialType.CityGhostBoss then
      if not LuaEntry.Player:AtHomeNow() then
        UIUtil.ShowTipsId("season_s4_ghostKing_tips_1")
        self.view.ctrl:CloseSelf(true)
        return
      end
      if not self.param.info.canAttack then
        UIUtil.ShowTipsId("season_s4_ghostKing_tips_3")
        self.view.ctrl:CloseSelf(true)
        return
      end
    elseif special == WorldMonsterSpecialType.CityStrongholdPVP then
      if self.param.info.belongSelf then
        UIUtil.ShowTipsId("season_tips204")
        self.view.ctrl:CloseSelf(true)
        return
      end
      if self.param.info.canAttack == 2 then
        UIUtil.ShowTipsId("season_tips226")
        self.view.ctrl:CloseSelf(true)
        return
      end
    elseif special == WorldMonsterSpecialType.CityStrongholdPVE then
    elseif special == WorldMonsterSpecialType.S1RestCityDefendMonster and DataCenter.OffSeason1RecaptureManager:GetAtkTime() <= 0 then
      UIUtil.ShowTipsId("activity_hunter_alert7")
      return
    end
    local targetType = MarchTargetType.ATTACK_MONSTER
    if self.param.info.marchType == NewMarchType.BEHEMOTH_BOSS then
      local count = 0
      local list = DataCenter.WorldMarchDataManager:GetOwnerMarches()
      local num = 0
      if list ~= nil then
        for k, v in pairs(list) do
          if v:GetMarchTargetType() == MarchTargetType.ATTACK_BEHEMOTH and v.targetUuid == self.view.ctrl.uuid then
            num = num + 1
          end
        end
      end
      count = num
      local attackTime = DataCenter.SeasonNuclearPowerPlantDataManager:GetDailyAttackOrBuildTime(self.view.ctrl.uuid)
      local maxCount = DataCenter.SeasonNuclearPowerPlantDataManager:GetAttackBossMaxTime()
      if count >= maxCount - attackTime then
        UIUtil.ShowTipsId("801110")
        self.view.ctrl:CloseSelf(true)
        return
      else
        targetType = MarchTargetType.ATTACK_BEHEMOTH
      end
    end
    MarchUtil.OnClickStartMarch(targetType, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, MarchAutoBackType.Back, nil, serverId, nil, special)
  elseif self.param.btnType == WorldPointBtnType.WhistleMonster then
    MarchUtil.OnClickStartMarch(MarchTargetType.WHISTLE_MONSTER, pointId, uuid, -1, MarchAutoBackType.Back)
  elseif self.param.btnType == WorldPointBtnType.GoBackToCity then
    SceneUtils.ChangeToCity(function()
    end)
  elseif self.param.btnType == WorldPointBtnType.MapSticker then
    if self.view ~= nil and self.view.ctrl ~= nil then
      self.view:ShowStickerPlane(true)
      return
    end
  elseif self.param.btnType == WorldPointBtnType.CityShield then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWCityShield, {anim = true})
  elseif self.param.btnType == WorldPointBtnType.Wall_Deployment then
    local ret, count, max = CS.SceneManager.World.PointManager:TryGetAssistanceCountByPointIndex(LuaEntry.Player:GetCurServerId(), pointId)
    if ret and count > 0 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.view.ctrl.uuid, LuaEntry.Player.uid, self.view.ctrl.pointId, AssistanceType.MainCity)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWCityDefence)
    end
  elseif self.param.btnType == WorldPointBtnType.AttackActBoss then
    local mainLv = DataCenter.BuildManager.MainLv
    if self.param.info and mainLv < self.param.info.attackLimitLv then
      local tips = Localization:GetString("143575", self.param.info.attackLimitLv)
      UIUtil.ShowTips(tips)
      return
    end
    MarchUtil.OnClickStartMarch(MarchTargetType.DIRECT_ATTACK_ACT_BOSS, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 1)
  elseif self.param.btnType == WorldPointBtnType.CheckActBossRank then
    if self.param.info and self.param.info.activityId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIWorldBossRank, {anim = true}, self.param.info.activityId)
    else
      UIUtil.ShowTipsId(458272)
    end
  elseif self.param.btnType == WorldPointBtnType.AttackPuzzleBoss then
    local worldMarch = CS.SceneManager.World:GetMarch(self.view.ctrl.uuid)
    if worldMarch ~= nil then
      local flag = false
      if string.IsNullOrEmpty(worldMarch.allianceUid) or string.IsNullOrEmpty(LuaEntry.Player.allianceId) then
        if worldMarch.bossOwnerUid == nil then
          flag = true
        elseif worldMarch.bossOwnerUid == LuaEntry.Player.uid then
          flag = true
        end
      elseif worldMarch.allianceUid == LuaEntry.Player.allianceId then
        flag = true
      end
      if flag == true then
        MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_MONSTER, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 1)
      else
        UIUtil.ShowTipsId(372272)
      end
    end
  elseif self.param.btnType == WorldPointBtnType.CheckPuzzleBossRank then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.param.info.startTime and curTime <= self.param.info.endTime then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIPuzzleMonsterRank, self.view.ctrl.uuid)
    else
      UIUtil.ShowTipsId(302190)
    end
  elseif self.param.btnType == WorldPointBtnType.RallyBoss or self.param.btnType == WorldPointBtnType.S0AllianceBossBuildingRally then
    if CS.SceneManager:IsInCity() == false then
      if not DataCenter.BuildManager:IsExistBuildByTypeLv(BuildingTypes.LW_BUILD_ALLIANCE_CENTER, 1) then
        GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_ALLIANCE_CENTER, WorldTileBtnType.City_Upgrade)
        return
      else
        local allianceuid = LuaEntry.Player.allianceId
        if allianceuid == "" then
          UIUtil.ShowTipsId(390172)
          if LuaEntry.Player:IsFirstJoinAlliance() == true then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
          else
            UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
          end
        else
          local point = self.view.ctrl.pointId
          local special = self.param.info.special
          if special == WorldMonsterSpecialType.CityGhostBoss and not self.param.info.canAttack then
            UIUtil.ShowTipsId("season_s4_ghostKing_tips_3")
            self.view.ctrl:CloseSelf(true)
            return
          end
          if special == WorldMonsterSpecialType.CityStrongholdBOSS and self.param.info.canAttack == 2 then
            UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint, {
              anim = true,
              playEffect = false,
              UIMainAnim = UIMainAnimType.ChangeAllShow
            })
            UIUtil.TryShowConfirm(TodayNoSecondConfirmType.AttackCityStronghold, Localization:GetString("season_tips225"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
              MarchUtil.OnClickStartMarch(MarchTargetType.RALLY_FOR_BOSS, point, uuid, -1, 1)
            end, function()
            end, nil, nil, false, nil, nil)
            return
          elseif special == WorldMonsterSpecialType.CityStrongholdBOSS then
            local strongholdCount, strongholdMax = SeasonUtil.GetOccupyStrongholdInfo(curServerId)
            if strongholdMax <= strongholdCount then
              UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint, {
                anim = true,
                playEffect = false,
                UIMainAnim = UIMainAnimType.ChangeAllShow
              })
              UIUtil.TryShowConfirm(TodayNoSecondConfirmType.AttackCityStrongholdBoss, Localization:GetString("season_city_tips_1"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                MarchUtil.OnClickStartMarch(MarchTargetType.RALLY_FOR_BOSS, point, uuid, -1, 1)
              end, function()
              end, nil, nil, false, nil, nil)
              return
            end
          elseif special == WorldMonsterSpecialType.ALLIANCE_BOSS_S0 then
            local showConfirm = DataCenter.S0AllianceBossDataManager:CheckAlliancePersonalDmgFull()
            if showConfirm then
              UIManager.Instance:DestroyWindow(UIWindowNames.UIWorldPoint, {
                anim = true,
                playEffect = false,
                UIMainAnim = UIMainAnimType.ChangeAllShow
              })
              local param = {
                contentText = CS.GameEntry.Localization:GetString("s0_alliance_boss_attack_check"),
                btnNum = 2,
                showToggle = true,
                confirmBtnParam = {
                  action = function()
                    MarchUtil.OnClickStartMarch(MarchTargetType.RALLY_FOR_BOSS, point, uuid, -1, 1)
                  end
                }
              }
              UIUtil.TryShowConfirmNew(TodayNoSecondConfirmType.S0AllianceBossWeaknessAttackRemind, param)
              return
            end
          end
          if self.param.info.marchType == NewMarchType.RUNNING_BOSS or self.param.info.marchType == NewMarchType.ZONE_MOBILIZATION_BOSS then
            SeasonUtil.TryShowConfirmWhenAttackBoss(function()
              MarchUtil.OnClickStartMarch(MarchTargetType.RALLY_FOR_BOSS, point, uuid, -1, 1)
            end, self.param.info.marchType, self.param.info.special)
          elseif self.param.info.marchType == NewMarchType.RUNNING_MUMMY then
            MarchUtil.OnClickStartMarch(MarchTargetType.RALLY_MUMMY, point, uuid, -1, 1)
          else
            if SeasonUtil.IsOpenAttackMonsterByLevel(self.param.info.monsterType, self.param.info.special) then
              local maxlv = DataCenter.SeasonDataManager:GetMonsterMaxLevel(self.param.info.monsterType)
              if maxlv < self.param.info.level then
                UIUtil.ShowTips(Localization:GetString("season_tips199", maxlv))
                return
              end
            elseif self.param.info.limit and DataCenter.BuildManager.MainLv < self.param.info.limit then
              UIUtil.ShowTips(Localization:GetString("143575", self.param.info.limit, self.param.info.level))
              return
            end
            if special == WorldMonsterSpecialType.Crocodile and self.param.info.allianceUid and self.param.info.allianceUid ~= LuaEntry.Player.allianceId then
              UIUtil.ShowTipsId("season6_fish_rally_limit_tips")
              return
            end
            if special == WorldMonsterSpecialType.MonsterInvasionBoss then
              local protectionEndTime = DataCenter.MonsterProtectionManager:GetMonsterProtectionEndTime(self.param.info.uuid)
              local diff = protectionEndTime - UITimeManager:GetInstance():GetServerTime()
              if diff > 0 then
                UIUtil.ShowTipsId("invasion_shield_alliance_tips")
                return
              end
            end
            do
              local marchTargetType = special == WorldMonsterSpecialType.BigSandWorm and MarchTargetType.RALLY_SANDWORM or MarchTargetType.RALLY_FOR_BOSS
              if not DataCenter.AllianceBaseDataManager:CheckIfNeedCheckRallyDistance() then
                MarchUtil.OnClickStartMarch(marchTargetType, point, uuid, -1, 1)
              else
                DataCenter.AllianceBaseDataManager:TryCheckRallyDist({
                  targetPoint = point,
                  callback = function()
                    MarchUtil.OnClickStartMarch(marchTargetType, point, uuid, -1, 1)
                  end
                })
              end
            end
          end
        end
      end
    end
  elseif self.param.btnType == WorldPointBtnType.AttackCity then
    if not self:HasShield(120899) then
      local attackType = MarchTargetType.ATTACK_CITY
      if BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
        attackType = MarchTargetType.ATTACK_WINTER_STORM_CITY
      elseif BattleFieldUtil.InBattleField(BattleFieldType.DsbDuel) then
        attackType = MarchTargetType.ATTACK_EPIDEMIC_CITY
      elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
        local bInSafeArea = DataCenter.ActEpidemicZoneManager:CheckTargetInSafeArea(self.view.ctrl.pointId)
        if bInSafeArea then
          UIUtil.ShowTipsId(458142)
          self.view.ctrl:CloseSelf(true)
          return
        end
        attackType = MarchTargetType.ATTACK_EPIDEMIC_CITY
      end
      MarchUtil.OnClickStartMarch(attackType, pointId, uuid, -1, 1, nil, curServerId)
      local pointInfo = CS.SceneManager.World:GetPointInfoByUuid(uuid)
      if pointInfo then
        cast(pointInfo, typeof(CS.BuildPointInfo))
        if pointInfo.specialType == CS.Protobuf.SpecialType.DetectEvent then
          local uuid = pointInfo.uuid
          local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(uuid)
          local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
          if template ~= nil and template.type == DetectEventType.FAKE_PLAYER then
            local simplayer = template.para
            local playerConfig = LocalController:instance():getLine(TableName.LW_SIMPLAYER, simplayer)
            local plotId = playerConfig.choose_plot_id
            local playerInfo = DataCenter.WorldPointDetailManager:GetDetailByPointId(self.param.pointId)
            if playerInfo then
              local playerInfo = {
                uid = playerInfo.uid,
                pic = playerInfo.pic,
                picVer = playerInfo.picVer
              }
              local bubbleParams = {}
              bubbleParams.plotId = plotId
              local targetPos = SceneUtils.TileIndexToWorld(self.param.pointId)
              bubbleParams.anchor = Vector3.New(targetPos.x, targetPos.y + 3.7, targetPos.z)
              bubbleParams.mode = "3D"
              bubbleParams.playerInfo = playerInfo
              EventManager:GetInstance():Broadcast(EventId.PlayPlotBubble, bubbleParams)
            end
          end
        end
      end
    end
  elseif self.param.btnType == WorldPointBtnType.DigIceAlly then
    MarchUtil.OnClickStartMarch(MarchTargetType.DIG_ICE_ALLY, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 1)
  elseif self.param.btnType == WorldPointBtnType.DigIceEnemy then
    if not self:HasShield("temperature_tips_3") then
      MarchUtil.OnClickStartMarch(MarchTargetType.DIG_ICE_ENEMY, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 1)
    end
  elseif self.param.btnType == WorldPointBtnType.RallySandworm then
    MarchUtil.OnClickStartMarch(MarchTargetType.RALLY_SANDWORM, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 0)
  elseif self.param.btnType == WorldPointBtnType.AttackSandworm then
    MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_SANDWORM, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 0)
  elseif self.param.btnType == WorldPointBtnType.RallyCity then
    if self:HasShield(120899) then
    elseif not DataCenter.BuildManager:IsExistBuildByTypeLv(BuildingTypes.FUN_BUILD_SMITHY, 1) then
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_SMITHY, WorldTileBtnType.City_Upgrade)
      return
    else
      local allianceuid = LuaEntry.Player.allianceId
      if allianceuid == "" then
        UIUtil.ShowTipsId(390172)
        if LuaEntry.Player:IsFirstJoinAlliance() == true then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAllianceFirstJoin, {anim = true})
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UILWAlCreateJoin, {anim = true}, {guide = false})
        end
      elseif LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ALLIANCE_TEAM_MAX_ARMY) <= 1 then
        local building = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_SMITHY)
        if building ~= nil then
          local name = Localization:GetString(building.name)
          UIUtil.ShowTips(Localization:GetString("390812", name))
        end
      else
        local marchTargetType = MarchTargetType.RALLY_FOR_CITY
        if BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
          local bInSafeArea = DataCenter.ActEpidemicZoneManager:CheckTargetInSafeArea(self.view.ctrl.pointId)
          if bInSafeArea then
            UIUtil.ShowTipsId(458142)
            self.view.ctrl:CloseSelf(true)
            return
          end
          marchTargetType = MarchTargetType.RALLY_EPIDEMIC_CITY
        elseif BattleFieldUtil.InBattleField(BattleFieldType.DsbDuel) then
          local bInSafeArea = DataCenter.BattlefieldDsbDuelManager:CheckTargetInSafeArea(self.view.ctrl.pointId)
          if bInSafeArea then
            UIUtil.ShowTipsId(458142)
            self.view.ctrl:CloseSelf(true)
            return
          end
          marchTargetType = MarchTargetType.RALLY_EPIDEMIC_CITY
        end
        MarchUtil.OnClickStartMarch(marchTargetType, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 0)
      end
    end
  elseif self.param.btnType == WorldPointBtnType.AssistanceCity then
    if WorldBattleUtil.EnableShowWorldAssistanceInfo() then
      WorldBattleUtil.TrySendAssistanceMarch({
        uuid = self.view.ctrl.uuid,
        playerUid = self.view.ctrl.ownerUid,
        pointId = self.view.ctrl.pointId,
        asType = AssistanceType.MainCity,
        isThroneCity = false,
        isCrossServerThrone = false
      })
    else
      local mainLv = DataCenter.BuildManager.MainLv
      local needMainLv = LuaEntry.DataConfig:TryGetNum("assistance_open", "k1")
      if mainLv >= needMainLv then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.view.ctrl.uuid, self.view.ctrl.ownerUid, self.view.ctrl.pointId, AssistanceType.MainCity)
      else
        UIUtil.ShowTips(Localization:GetString("121005", needMainLv))
      end
    end
  elseif self.param.btnType == WorldPointBtnType.ResourceHelp then
    local serverData = self.view.ctrl:GetPlayerData(self.view.ctrl.pointId)
    if serverData ~= nil then
      local uid = self.view.ctrl.ownerUid
      local userinfo = ChatInterface.getUserData(uid, true)
      if userinfo ~= nil then
        local userPic = userinfo.headPic or ""
        local userPicVec = userinfo.headPicVer or 0
        local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUND_BUILD_ALLIANCE_CENTER)
        if buildList == nil or table.count(buildList) == 0 or buildList[1] == nil then
          UIUtil.ShowTipsId(390836)
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIResSupport, uid, userPic, userPicVec, serverData.playerData.name, self.view.ctrl.pointId)
      end
    end
  elseif self.param.btnType == WorldPointBtnType.SendCoal then
    local type, count, addNum = DataCenter.TemperatureManager:GetSendCoalConfig()
    local tipText = Localization:GetString("season_s2_temperature_ui_tips08", count, addNum)
    local pointId, uuid = self.view.ctrl.pointId, self.view.ctrl.uuid
    UIUtil.TryShowConfirm(TodayNoSecondConfirmType.SendCoalSecondConfirm, tipText, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      MarchUtil.LaunchScout(MarchTargetType.SEND_COAL, pointId, uuid)
    end, function()
    end, nil, nil, false, nil, nil)
  elseif self.param.btnType == WorldPointBtnType.ReinforceWall then
    if pointInfo and pointInfo.wallBarInfo and pointInfo.wallBarInfo.shieldValue == pointInfo.wallBarInfo.shieldMaxValue then
      UIUtil.ShowTipsId("season_mastery_s6_tips_3")
      return
    end
    local skillTemplate = DataCenter.MasteryManager:GetUnlockedSkillTemplateByType(MasterySkill.ReinforceWall)
    if not skillTemplate then
      UIUtil.ShowTipsId("season_mastery_s6_tips_2")
      return
    end
    local count = DataCenter.MasteryManager:GetStorageSkillCountByType(MasterySkill.ReinforceWall)
    if count <= 0 then
      UIUtil.ShowTipsId("season_mastery_tips_8")
      return
    end
    local fortifyData = DataCenter.MasteryManager:GetFortifyDailyCount(self.param.info.ownerUid)
    if fortifyData and fortifyData.usedCount >= fortifyData.dailyLimit then
      UIUtil.ShowTipsId("season_mastery_s6_tips_4")
      return
    end
    DataCenter.MasteryManager:UseSkill(skillTemplate.id, self.view.ctrl.pointId, nil, self.view.ctrl.serverId)
    return
  elseif self.param.btnType == WorldPointBtnType.SendPowerHelper then
    DataCenter.SeasonPowerWorkerManager:SendElectricianToAlly(self.view.ctrl.ownerUid, self.view.ctrl.pointId, self.view.ctrl.uuid)
  elseif self.param.btnType == WorldPointBtnType.ScoutCity then
    local readyTs = DataCenter.ArmyFormationDataManager:GetScoutCD(self.param.info.uuid)
    local now = UITimeManager:GetInstance():GetServerSeconds()
    if readyTs > now then
      local countDown = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(readyTs - now)
      UIUtil.ShowTips(Localization:GetString("Investigate_cd_tips_01", countDown))
      return
    end
    local canMarch = DataCenter.LWRefundPunishManager:GetCanMarch()
    if not canMarch then
      return
    end
    if not self:HasShield(110225) then
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_RADAR)
      if not buildData then
        UIUtil.ShowTipsId(300608)
        self.view.ctrl:CloseSelf(true)
        return
      end
      local needConfirm, status, title, content, needBreakProtect = DataCenter.StatusManager:ShowTipForWarFever()
      local scoutType = MarchTargetType.SCOUT_CITY
      if BattleFieldUtil.InBattleField(BattleFieldType.WinterStorm) then
        scoutType = MarchTargetType.SCOUT_WINTER_STORM_CITY
      elseif BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
        local bInSafeArea = DataCenter.ActEpidemicZoneManager:CheckTargetInSafeArea(self.view.ctrl.pointId)
        if bInSafeArea then
          UIUtil.ShowTipsId(458142)
          self.view.ctrl:CloseSelf(true)
          return
        end
        scoutType = MarchTargetType.SCOUT_EPIDEMIC_CITY
      elseif BattleFieldUtil.InBattleField(BattleFieldType.DsbDuel) then
        local bInSafeArea = DataCenter.BattlefieldDsbDuelManager:CheckTargetInSafeArea(self.view.ctrl.pointId)
        if bInSafeArea then
          UIUtil.ShowTipsId(458142)
          self.view.ctrl:CloseSelf(true)
          return
        end
        scoutType = MarchTargetType.SCOUT_EPIDEMIC_CITY
      end
      if needConfirm then
        if status ~= nil and title ~= nil then
          local tempUuid = self.view.ctrl.uuid
          local tempPointId = self.view.ctrl.pointId
          UIUtil.ShowSecondMessage(title, content, 2, "", "", function()
            MarchUtil.LaunchScout(scoutType, tempPointId, tempUuid)
          end, function(needSellConfirm)
            DataCenter.StatusManager:SetWarFeverConfirmFlag(needSellConfirm)
          end)
        else
          MarchUtil.LaunchScout(scoutType, self.view.ctrl.pointId, self.view.ctrl.uuid)
        end
      elseif needBreakProtect == true then
        local tempUuid = self.view.ctrl.uuid
        local tempPointId = self.view.ctrl.pointId
        UIUtil.ShowShieldBreakTip(content, 2, GameDialogDefine.CANCEL, GameDialogDefine.CONFIRM, function()
        end, function()
          MarchUtil.LaunchScout(scoutType, tempPointId, tempUuid)
        end, nil, nil, nil, nil, nil, nil, nil, nil, nil, nil, UIUtil.BtnColorSpriteName.Blue, UIUtil.BtnColorSpriteName.Red)
      else
        MarchUtil.LaunchScout(scoutType, self.view.ctrl.pointId, self.view.ctrl.uuid)
      end
    end
  elseif self.param.btnType == WorldPointBtnType.AttackBuild then
    local pointId = self.view.ctrl.pointId
    if self.view.info.isSeasonPlayerBuilding and SeasonUtil.GetSeasonType() == SeasonMapType.Desert then
      local alreadyExitOccupy = SeasonUtil.CheckDesertConnect(pointId, 1, true)
      if alreadyExitOccupy then
        MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_BUILDING, pointId, self.view.ctrl.uuid, -1, 1)
      end
    else
      MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_BUILDING, pointId, self.view.ctrl.uuid, -1, 0)
    end
  elseif self.param.btnType == WorldPointBtnType.RallyBuild then
    local pointId = self.view.ctrl.pointId
    if self.view.info.isSeasonPlayerBuilding and SeasonUtil.GetSeasonType() == SeasonMapType.Desert then
      local alreadyExitOccupy = SeasonUtil.CheckDesertConnect(pointId, 1, true)
      if not alreadyExitOccupy then
        self.view.ctrl:CloseSelf(true)
        return
      end
    end
    if not DataCenter.BuildManager:IsExistBuildByTypeLv(BuildingTypes.FUN_BUILD_SMITHY, 1) then
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_SMITHY, WorldTileBtnType.City_Upgrade)
      self.view.ctrl:CloseSelf(true)
      return
    elseif not LuaEntry.Player:IsInAlliance() then
      UIUtil.ShowTipsId(390172)
    elseif LuaEntry.Effect:GetGameEffect(EffectDefine.APS_ALLIANCE_TEAM_MAX_ARMY) <= 1 then
      local building = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_SMITHY)
      if building ~= nil then
        local name = Localization:GetString(building.name)
        UIUtil.ShowTips(Localization:GetString("390812", name))
      end
    else
      MarchUtil.OnClickStartMarch(MarchTargetType.RALLY_FOR_BUILDING, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 1)
    end
  elseif self.param.btnType == WorldPointBtnType.AssistanceBuild then
    local mainLv = DataCenter.BuildManager.MainLv
    local needMainLv = LuaEntry.DataConfig:TryGetNum("assistance_open", "k1")
    if mainLv >= needMainLv then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.view.ctrl.uuid, self.view.ctrl.ownerUid, self.view.ctrl.pointId, AssistanceType.Build)
    else
      UIUtil.ShowTips(Localization:GetString("121005", needMainLv))
    end
  elseif self.param.btnType == WorldPointBtnType.MoveCity then
    MoveCityUtil.TryMoveCity(self.view.ctrl.pointId)
  elseif self.param.btnType == WorldPointBtnType.PutAlliancePoint then
    TileBubbleManager.TrySetRally(pointId, serverId)
  elseif self.param.btnType == WorldPointBtnType.BuildAllianceCenter then
    if not DataCenter.AllianceBaseDataManager:IsR4orR5() then
      UIUtil.ShowTipsId(803040)
      self.view.ctrl:CloseSelf(true)
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWSeasonCity)
  elseif self.param.btnType == WorldPointBtnType.DesertBuildList then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildList, nil, nil, nil, 1, self.view.ctrl.pointId)
  elseif self.param.btnType == WorldPointBtnType.AssistanceDesert then
    local mainLv = DataCenter.BuildManager.MainLv
    local needMainLv = LuaEntry.DataConfig:TryGetNum("assistance_open", "k1")
    if mainLv >= needMainLv then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.view.ctrl.uuid, self.view.ctrl.ownerUid, self.view.ctrl.pointId, AssistanceType.Desert)
    else
      UIUtil.ShowTips(Localization:GetString("121005", needMainLv))
    end
  elseif self.param.btnType == WorldPointBtnType.ScoutBuild then
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_RADAR_CENTER)
    if not buildData then
      UIUtil.ShowTipsId(300608)
      self.view.ctrl:CloseSelf(true)
      return
    end
    local needConfirm, status, title, content, needBreakProtect = DataCenter.StatusManager:ShowTipForWarFever()
    if needConfirm then
      if status ~= nil and title ~= nil then
        local pointId = self.view.ctrl.pointId
        local uuid = self.view.ctrl.uuid
        UIUtil.ShowSecondMessage(title, content, 2, "", "", function()
          MarchUtil.LaunchScout(MarchTargetType.SCOUT_BUILDING, pointId, uuid)
        end, function(needSellConfirm)
          DataCenter.StatusManager:SetWarFeverConfirmFlag(needSellConfirm)
        end)
      else
        MarchUtil.LaunchScout(MarchTargetType.SCOUT_BUILDING, self.view.ctrl.pointId, self.view.ctrl.uuid)
      end
    elseif needBreakProtect == true then
      local pointId = self.view.ctrl.pointId
      local uuid = self.view.ctrl.uuid
      UIUtil.ShowMessage(content, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        MarchUtil.LaunchScout(MarchTargetType.SCOUT_BUILDING, pointId, uuid)
      end, function()
      end)
    else
      MarchUtil.LaunchScout(MarchTargetType.SCOUT_BUILDING, self.view.ctrl.pointId, self.view.ctrl.uuid)
    end
  elseif self.param.btnType == WorldPointBtnType.AttackRoad then
    MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_ROAD, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 0)
  elseif self.param.btnType == WorldPointBtnType.AttackDesert then
    local theParam = self.param
    local thePointId = self.view.ctrl.pointId
    local thePointUuid = self.view.ctrl.uuid
    local desert_level = 0
    local maxLevel = DataCenter.SeasonDataManager:GetDesertMaxLevel()
    if theParam and theParam.info then
      desert_level = toInt(theParam.info.level)
    end
    if maxLevel and maxLevel >= 0 and desert_level > maxLevel + 1 then
      self.view.ctrl:CloseSelf(true)
      UIUtil.ShowTips(Localization:GetString("season_tips114", maxLevel + 1))
      return
    end
    local info = self.param.info
    SeasonUtil.CheckDesertConnect(thePointId, 1, true, true, function()
      if 0 < desert_level and info and info.selfPercent and info.selfPercent < -0.3 then
        UIUtil.TryShowConfirm(TodayNoSecondConfirmType.ResistanceLack, Localization:GetString("season_tips117"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          SeasonUtil.AttackDesert(theParam, thePointId, thePointUuid, desert_level)
        end, function()
        end, nil, nil, false, nil, nil)
      else
        SeasonUtil.AttackDesert(theParam, thePointId, thePointUuid, desert_level)
      end
    end)
  elseif self.param.btnType == WorldPointBtnType.ScoutDesert then
    MarchUtil.LaunchScout(MarchTargetType.SCOUT_DESERT, self.view.ctrl.pointId, self.view.ctrl.pointId)
  elseif self.param.btnType == WorldPointBtnType.GiveUpDesert then
  elseif self.param.btnType == WorldPointBtnType.CancelGiveUpDesert then
  elseif self.param.btnType == WorldPointBtnType.CollectMeteorite then
    local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
    for _, v in pairs(selfMarch) do
      if v:GetMarchTargetType() == MarchTargetType.COLLECT then
        local info = CS.SceneManager.World:GetResourcePointInfoByIndex(v.targetPos)
        if info ~= nil and info.id == self.view.ctrl.pointId then
          self.isHaveOwnerMarche = true
        end
      end
    end
    if self.isHaveOwnerMarche then
      UIUtil.ShowTipsId(129004)
    else
      local info = CS.SceneManager.World:GetPointInfo(self.param.info.pointId)
      if info ~= nil then
        local ok, conditions = DataCenter.ActMeteoriteBattleManager:CheckCanCollect(info.buildId)
        if not ok then
          if conditions then
            UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMeteoriteConditionNotice, {anim = true}, {conditions = conditions})
            return
          else
          end
          return
        end
        if info.gatherUUID <= 0 then
          local targetPointId = self.param.info.pointId
          MarchUtil.OnClickStartMarch(MarchTargetType.COLLECT_METEORITE, targetPointId)
        else
          UIUtil.ShowTipsId("world_tip10006")
        end
      end
    end
  elseif self.param.btnType == WorldPointBtnType.ScoutArmyMeteoriteCollect then
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_RADAR_CENTER)
    if not buildData then
      UIUtil.ShowTipsId(300608)
      self.view.ctrl:CloseSelf(true)
      return
    end
    local needConfirm, status, title, content, needBreakProtect = DataCenter.StatusManager:ShowTipForWarFever()
    if needConfirm then
      if status ~= nil and title ~= nil then
        UIUtil.ShowSecondMessage(title, content, 2, "", "", function()
          MarchUtil.LaunchScout(MarchTargetType.SCOUT_METEORITE, self.view.ctrl.pointId, self.view.ctrl.uuid)
        end, function(needSellConfirm)
          DataCenter.StatusManager:SetWarFeverConfirmFlag(needSellConfirm)
        end)
      else
        MarchUtil.LaunchScout(MarchTargetType.SCOUT_METEORITE, self.view.ctrl.pointId, self.view.ctrl.uuid)
      end
    elseif needBreakProtect == true then
      local pointId = self.view.ctrl.pointId
      local uuid = self.view.ctrl.uuid
      UIUtil.ShowMessage(content, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        MarchUtil.LaunchScout(MarchTargetType.SCOUT_METEORITE, pointId, uuid)
      end, function()
      end)
    else
      MarchUtil.LaunchScout(MarchTargetType.SCOUT_METEORITE, self.view.ctrl.pointId, self.view.ctrl.uuid)
    end
  elseif self.param.btnType == WorldPointBtnType.AttackArmyMeteoriteCollect then
    MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_METEORITE, self.view.ctrl.pointId, self.view.ctrl.uuid)
  elseif self.param.btnType == WorldPointBtnType.Collect or self.param.btnType == WorldPointBtnType.AllianceCollect then
    if self.param.btnType == WorldPointBtnType.Collect and self.param.info and self.param.info.special == 6 and self.param.info.ownerCampId ~= nil then
      local myCampId = DataCenter.SeasonFactionWarDataManager.myCampId
      if myCampId ~= nil and myCampId ~= 0 and myCampId ~= self.param.info.ownerCampId then
        UIUtil.ShowTipsId(801611)
        return
      end
    end
    if not DataCenter.BuildManager:HasBuilding(BuildingTypes.LW_BUILD_PARKINGLOT) then
      UIUtil.ShowTipsId(430764)
      GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_PARKINGLOT)
      return
    else
      local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
      for _, v in pairs(selfMarch) do
        if v:GetMarchTargetType() == MarchTargetType.COLLECT then
          local info = CS.SceneManager.World:GetResourcePointInfoByIndex(v.targetPos)
          if info ~= nil and info.id == self.view.ctrl.pointId then
            self.isHaveOwnerMarche = true
          end
        end
      end
      if self.isHaveOwnerMarche then
        UIUtil.ShowTipsId(129004)
      else
        local info = CS.SceneManager.World:GetResourcePointInfoByIndex(self.param.info.pointId)
        if info ~= nil then
          if info.gatherMarchUuid == 0 then
            if false then
              local scienceId = GetTableData(TableName.GatherResource, self.param.info.id, "unlock_science")
              if scienceId ~= "" and not DataCenter.ScienceManager:HasScienceByIdAndLevel(scienceId, 1) then
                do
                  local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(scienceId, 1)
                  UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldCollectMessageTip, Localization:GetString("129055", Localization:GetString(template.name), Localization:GetString(GetTableData(TableName.GatherResource, info.id, "name"))), 1, GameDialogDefine.GOTO, nil, function()
                    GoToUtil.GotoScience(scienceId)
                  end, nil)
                end
              end
            else
              local targetPointId = self.param.info.pointId
              local inBlackArea = SceneUtils.IsInBlackRange(targetPointId)
              if not inBlackArea and SeasonUtil.IsInSeasonOrHalt(curServerId) and DataCenter.BirthPointTemplateManager:IsInAllianceCityField(targetPointId, serverId) then
                inBlackArea = true
              end
              if not inBlackArea then
                local overTime = DataCenter.AllianceSkillManager:GetBlackAreaOverTime(targetPointId)
                if 1000 < overTime then
                  inBlackArea = true
                end
              end
              if inBlackArea then
                local message = Localization:GetString("world_tip10004")
                UIUtil.TryShowConfirm(TodayNoSecondConfirmType.CollectInBlackRange, message, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                  MarchUtil.OnClickStartMarch(MarchTargetType.COLLECT, targetPointId, nil, nil, nil, nil, serverId)
                end, function()
                end, nil, nil, false, nil, nil)
              else
                MarchUtil.OnClickStartMarch(MarchTargetType.COLLECT, targetPointId, nil, nil, nil, nil, serverId)
              end
            end
          else
            UIUtil.ShowTipsId("world_tip10006")
          end
        end
      end
    end
  elseif self.param.btnType == WorldPointBtnType.WorldAllianceResourceCollect then
    local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
    local canMarch = true
    for index, march in pairs(selfMarch) do
      if march.targetPos == self.param.info.pointId and march:GetMarchTargetType() == MarchTargetType.ALLIANCE_RESOURCE_COLLECT then
        canMarch = false
        UIUtil.ShowTips(Localization:GetString("season_tips212"))
        break
      end
    end
    local info = CS.SceneManager.World:GetPointInfo(self.param.info.pointId)
    if info and info.configId then
      local configId = info.configId
      local config = LocalController:instance():getLine(TableName.AllianceMine, configId)
      local maxNum = config.guard_num
      local detailData = DataCenter.WorldPointDetailManager:GetAllianceResourceData(info.uuid)
      if detailData and detailData.playerInfoLiset and maxNum <= #detailData.playerInfoLiset then
        canMarch = false
        UIUtil.ShowTips(Localization:GetString("season_alliance_resource_maxtips"))
      end
    end
    if canMarch then
      MarchUtil.OnClickStartMarch(MarchTargetType.ALLIANCE_RESOURCE_COLLECT, self.param.info.pointId, self.view.ctrl.uuid)
    end
  elseif self.param.btnType == WorldPointBtnType.AttackArmyCollect then
    MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_ARMY_COLLECT, self.view.ctrl.pointId, self.view.ctrl.uuid)
  elseif self.param.btnType == WorldPointBtnType.ScoutArmyCollect then
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_RADAR_CENTER)
    if not buildData then
      UIUtil.ShowTipsId(300608)
      self.view.ctrl:CloseSelf(true)
      return
    end
    local needConfirm, status, title, content, needBreakProtect = DataCenter.StatusManager:ShowTipForWarFever()
    if needConfirm then
      if status ~= nil and title ~= nil then
        UIUtil.ShowSecondMessage(title, content, 2, "", "", function()
          MarchUtil.LaunchScout(MarchTargetType.SCOUT_ARMY_COLLECT, self.view.ctrl.pointId, self.view.ctrl.uuid)
        end, function(needSellConfirm)
          DataCenter.StatusManager:SetWarFeverConfirmFlag(needSellConfirm)
        end)
      else
        MarchUtil.LaunchScout(MarchTargetType.SCOUT_ARMY_COLLECT, self.view.ctrl.pointId, self.view.ctrl.uuid)
      end
    elseif needBreakProtect == true then
      local pointId = self.view.ctrl.pointId
      local uuid = self.view.ctrl.uuid
      UIUtil.ShowMessage(content, 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        MarchUtil.LaunchScout(MarchTargetType.SCOUT_ARMY_COLLECT, pointId, uuid)
      end, function()
      end)
    else
      MarchUtil.LaunchScout(MarchTargetType.SCOUT_ARMY_COLLECT, self.view.ctrl.pointId, self.view.ctrl.uuid)
    end
  elseif self.param.btnType == WorldPointBtnType.Search then
    local monster_special_id = self.param.info and self.param.info.special
    local attackMaxLevel = DataCenter.MonsterManager:GetCurCanAttackMaxLevel()
    local worldSearchType = UISearchType.Monster
    if monster_special_id and DataCenter.LWActivityLockhartManager:IsLockHartBoss(monster_special_id) then
      attackMaxLevel = DataCenter.LWActivityLockhartManager:GetMaxLockHartUnlockLevel()
      worldSearchType = UISearchType.Boss
    end
    if bigMapMode and srcSameGroup then
      GoToUtil.GotoOpenView(UIWindowNames.UISearch, worldSearchType, attackMaxLevel)
    elseif isCrossServer then
      local str = Localization:GetString(128008, attackMaxLevel)
      UIUtil.ShowTips(str)
    else
      GoToUtil.GotoOpenView(UIWindowNames.UISearch, worldSearchType, attackMaxLevel)
    end
    return
  elseif self.param.btnType == WorldPointBtnType.CallBack then
    if self.view.ctrl.type == WorldPointUIType.Treasure or self.view.ctrl.type == WorldPointUIType.WorldAllianceResourceCollect then
      local buildUuid = self.view.ctrl.uuid
      local marchUuid
      local selfMarch = DataCenter.WorldMarchDataManager:GetOwnerMarches(LuaEntry.Player.uid, LuaEntry.Player.allianceId)
      for _, march in pairs(selfMarch) do
        if march.targetUuid == buildUuid then
          marchUuid = march.uuid
          break
        end
      end
      if marchUuid ~= nil then
        MarchUtil.OnBackHome(marchUuid)
      end
    elseif self.view.ctrl.type == WorldPointUIType.EpidemicBuild or self.view.ctrl.type == WorldPointUIType.WinterEntity then
      local pointId = self.view.ctrl.pointId
      local assistanceCount = CS.SceneManager.World:GetMyAssistanceCount(pointId)
      if assistanceCount > 1 then
        local assistanceType = AssistanceType.WinterEntity
        if self.view.ctrl.type == WorldPointUIType.EpidemicBuild then
          assistanceType = AssistanceType.EpidemicBuild
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.view.ctrl.uuid, self.view.ctrl.ownerUid, self.view.ctrl.pointId, assistanceType)
      else
        local marchUuid = self.view.info.pointData.marchUUID
        if marchUuid ~= nil and marchUuid ~= 0 then
          MarchUtil.OnBackHome(marchUuid)
        else
          local _uuid = DataCenter.WorldMarchDataProxy:GetFirstMyAssistanceMarchUuid(self.view.ctrl.pointId)
          if _uuid ~= 0 then
            MarchUtil.OnBackHome(_uuid)
          end
        end
      end
    elseif self.view.ctrl.type == WorldPointUIType.City or self.view.ctrl.type == WorldPointUIType.AllianceBuild or self.view.ctrl.type == WorldPointUIType.DragonBuild then
      local _uuid = DataCenter.WorldMarchDataProxy:GetFirstMyAssistanceMarchUuid(self.view.ctrl.pointId)
      if _uuid ~= 0 then
        MarchUtil.OnBackHome(_uuid)
      end
    else
      MarchUtil.OnBackHome(self.view.ctrl.uuid)
    end
  elseif self.param.btnType == WorldPointBtnType.Detail then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.Marching, self.param.info.formationUuid)
  elseif self.param.btnType == WorldPointBtnType.Explore then
    local detectEventData = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.param.info.uuid)
    if detectEventData ~= nil then
      local config = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(detectEventData.eventId)
      if config ~= nil and (not (config.type ~= DetectEventType.SPECIAL_OPS or string.IsNullOrEmpty(config.para2)) or (config.type == DetectEventType.DetectEventPVE or config.type == DetectEventType.HeroTrial) and not string.IsNullOrEmpty(config.para2)) then
        local k9 = LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k9")
        local own = LuaEntry.Player:GetCurStamina()
        if k9 > own then
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAddStamina)
        else
          local param = {}
          param.pveEntrance = PveEntrance.DetectEventPve
          if config.type == DetectEventType.SPECIAL_OPS then
            param.levelId = toInt(config.para2)
          else
            param.levelId = toInt(config.para2)
          end
          param.uid = self.param.info.uuid
          param.isBackToWorld = CS.SceneManager:IsInWorld()
          self.view.ctrl:CloseSelf(false)
          Logger.Log("UIWorldPointBtn StartPve|", param.levelId)
          DataCenter.BattleLevel:Enter(param)
        end
        return
      end
    end
    MarchUtil.OnClickStartMarch(MarchTargetType.EXPLORE, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 1)
  elseif self.param.btnType == WorldPointBtnType.Sample then
    local detectEventData = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.param.info.uuid)
    if detectEventData ~= nil then
      local config = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(detectEventData.eventId)
      if config ~= nil and (config.type == DetectEventType.DetectEventPickGarbage or config.type == DetectEventType.DOMINATOR_CURE or config.type == DetectEventType.SEASON_VISITOR) then
        DataCenter.FakeCollectGarbageMarchManager:AddMarchIndex(self.view.ctrl.pointId, detectEventData.eventId)
        self.view.ctrl:CloseSelf(false)
        return
      end
    end
    MarchUtil.OnClickStartMarch(MarchTargetType.SAMPLE, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 1)
  elseif self.param.btnType == WorldPointBtnType.Rescue then
    local detectEventData = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.param.info.uuid)
    if detectEventData ~= nil then
      local config = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(detectEventData.eventId)
      if config ~= nil and config.type == DetectEventType.RESCUE then
        DataCenter.FakeRescueMarchManager:PlaySound()
        DataCenter.FakeRescueMarchManager:AddMarchIndex(self.view.ctrl.pointId)
        self.view.ctrl:CloseSelf(false)
        return
      end
    end
  elseif self.param.btnType == WorldPointBtnType.PickGarbage then
    if self.view:CheckResourceItemIsFull() == true then
      GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
      return
    end
    local k8 = LuaEntry.DataConfig:TryGetNum("car_action_stamina", "k8")
    local own = LuaEntry.Player:GetCurStamina()
    if k8 > own then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAddStamina)
    else
      DataCenter.FakeCollectGarbageMarchManager:AddMarchIndex(self.view.ctrl.pointId)
      self.view.ctrl:CloseSelf(false)
    end
    return
  elseif self.param.btnType == WorldPointBtnType.SingleMapGarbage then
    if CS.SceneManager:IsInCity() then
      if self.view:CheckResourceItemIsFull() == true then
        GoToUtil.GotoOpenView(UIWindowNames.UICapacityFull)
        return
      end
      DataCenter.GuideCityManager:StartMoveCityTroop(self.view.ctrl.pointId)
      self.view.ctrl:CloseSelf(false)
      return
    end
  elseif self.param.btnType == WorldPointBtnType.GetReward then
    EventManager:GetInstance():Broadcast(EventId.ShowCapacity)
    local data
    if CS.SceneManager:IsInCity() then
      data = self.view.ctrl:GetMonsterRewardDataInCity(self.view.ctrl.uuid)
    else
      data = self.view.ctrl:GetMonsterRewardData(self.view.ctrl.uuid)
    end
    if data ~= nil then
      DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.MonsterGetReward, tostring(data.monsterId))
    end
  elseif self.param.btnType == WorldPointBtnType.StorageShop then
    local sData = self.view.ctrl:GetPlayerData(self.view.ctrl.pointId)
    if sData then
      local pName = sData.playerData.name
      DataCenter.StorageShopManager:SetOtherShopBase(self.view.ctrl.ownerUid, pName, LuaEntry.Player.serverId)
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopMain, self.view.ctrl.ownerUid)
    end
  elseif self.param.btnType == WorldPointBtnType.MonsterLockAttack then
    local data = DataCenter.MonsterLockDataManager:GetMonsterDataByPointIndex(self.view.ctrl.pointId)
    if data ~= nil then
      DataCenter.MonsterLockDataManager:EnterLandLockById(data.monsterId)
    end
  elseif self.param.btnType == WorldPointBtnType.AttackActChallenge then
    if self.param.info.bossOwnerUid == LuaEntry.Player.uid then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime > self.param.info.refreshTime then
        UIUtil.ShowTipsId(390843)
      else
        MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_MONSTER, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 1)
      end
    elseif self.param.info.allianceUid == LuaEntry.Player.allianceId then
      if self.param.info.callHelp == 1 then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if curTime > self.param.info.refreshTime then
          UIUtil.ShowTipsId(390843)
        else
          MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_MONSTER, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 1)
        end
      else
        UIUtil.ShowTipsId(372436)
      end
    else
      UIUtil.ShowTipsId(372436)
    end
  elseif self.param.btnType == WorldPointBtnType.ChallengeHelp then
    if self.param.info.bossOwnerUid == LuaEntry.Player.uid then
      if LuaEntry.Player.allianceId == "" then
        return UIUtil.ShowTipsId(390536)
      end
    else
      UIUtil.ShowTipsId(372436)
      return
    end
    local actList = DataCenter.ActMonsterTowerData:GetInfoActAll()
    local actInfo
    if actList then
      for i, v in pairs(actList) do
        if v.challengeBoss.pointId == self.param.info.point then
          actInfo = v
          break
        end
      end
    end
    if actInfo then
      if actInfo.challengeBoss.callHelp == 1 then
        UIUtil.ShowTipsId(372434)
        return
      end
      do
        local template = DataCenter.ActMonsterTowerData:GetTemplateByIndex(actInfo.challengeInfo.difficulty)
        if template then
          local num = template.help_time - actInfo.challengeInfo.callHelpCount
          if num >= 1 then
            UIUtil.ShowMessage(Localization:GetString("372432", num), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
              SFSNetwork.SendMessage(MsgDefines.CallChallengeActHelp, actInfo.activityId)
            end, function()
            end)
          else
            UIUtil.ShowTipsId(372433)
          end
        end
      end
    end
  elseif self.param.btnType == WorldPointBtnType.DetectEventPVE then
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.param.info.uuid)
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
    local stageId = template.para
    DataCenter.ZombieBattleManager:Destroy()
    local param = {}
    param.type = PVEType.Barrage
    param.enterType = PVEEnterType.Radar
    param.levelId = stageId
    param.extraData = {}
    param.extraData.uuid = self.param.info.uuid
    DataCenter.ZombieBattleManager:Enter(param)
  elseif self.param.btnType == WorldPointBtnType.DetectEventFakePVP then
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.param.info.uuid)
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
    local battleMetaId = template.para
    DataCenter.LWBattleManager:Destroy()
    local param = {}
    param.type = PVEType.FakePVP
    param.enterType = PVEEnterType.Radar
    param.levelId = battleMetaId
    param.sceneId = 51
    param.extraData = {}
    param.extraData.uuid = self.param.info.uuid
    DataCenter.LWBattleManager:Enter(param)
  elseif self.param.btnType == WorldPointBtnType.AttackTrain then
    local trainData = self.view.ctrl and self.view.ctrl.trainData
    if trainData == nil then
      trainData = self.param.info
    end
    RailwayUtil.ClickAttackTrain(trainData)
  elseif self.param.btnType == WorldPointBtnType.AttackHSR then
    RailwayUtil.TryOpenHSRRob()
  elseif self.param.btnType == WorldPointBtnType.TradeHSR then
    RailwayUtil.TryOpenHSRMain()
  elseif self.param.btnType == WorldPointBtnType.FlowerTrainGiftPreview then
    UIUtil.ShowTipsId(120018)
  elseif self.param.btnType == WorldPointBtnType.FlowerTrainGetReward then
    local flowerTrainRewardData = self.view.ctrl and self.view.ctrl.flowerTrainRewardData
    if flowerTrainRewardData.info then
      UIUtil.GetDetectTreasureReward(flowerTrainRewardData.info.mainIndex)
    end
  elseif self.param.btnType == WorldPointBtnType.FlowerTrainConnect then
    local flowerTrainData = self.view.ctrl and self.view.ctrl.flowerTrainData
    if flowerTrainData and flowerTrainData:GetMarchUuid() then
      SFSNetwork.SendMessage(MsgDefines.FlowerTrainFollow, flowerTrainData:GetMarchUuid())
    end
  elseif self.param.btnType == WorldPointBtnType.HelpMe then
    print("Help Me!")
  elseif self.param.btnType == WorldPointBtnType.Decoration then
    EventManager:GetInstance():Broadcast(EventId.UIDecorationMainViewOpen)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDecorationMain, {anim = true})
  elseif self.param.btnType == WorldPointBtnType.Treasure then
    local uuid = self.view.ctrl.uuid
    local pointId = self.view.ctrl.pointId
    local Player = LuaEntry.Player
    local allianceId = Player.allianceId
    local myUid = Player.uid
    local allList = DataCenter.ArmyFormationDataManager:GetArmyFormationList()
    local isHaveMarch = false
    if allList ~= nil then
      for _, v in ipairs(allList) do
        if v.state == ArmyFormationState.March then
          local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(myUid, v.uuid, allianceId)
          if march ~= nil and march:GetMarchTargetType() ~= MarchTargetType.BACK_HOME and uuid == march.targetUuid then
            isHaveMarch = true
            break
          end
        end
      end
    end
    if not isHaveMarch then
      MarchUtil.OnClickStartMarch(MarchTargetType.DETECT_TREASURE, pointId, uuid)
    else
      local isActTreasure = false
      local info = CS.SceneManager.World:GetPointInfo(pointId)
      if info then
        cast(info, typeof(CS.TreasurePointInfo))
        if info then
          local worldTreasureType = info:GetWorldTreasureType()
          if worldTreasureType == WorldTreasureType.ActivityRadarTreasure then
            isActTreasure = true
          end
        end
      end
      if isActTreasure then
        UIUtil.ShowTipsId("activity_wajueji_27000_tips7")
      else
        UIUtil.ShowTipsId(801355)
      end
    end
  elseif self.param.btnType == WorldPointBtnType.HelperDetect then
    if self.param.info:GetAOSType() == AlOfficialSkillType.AresMissile then
      MarchUtil.LaunchScout(MarchTargetType.ALLIANCE_MONSTER_CHALLENGE_NEW_DONATE, self.view.ctrl.pointId, self.view.ctrl.uuid)
      self.view.ctrl:CloseSelf(false)
      return
    end
    local helpDetectData = DataCenter.RadarCenterDataManager:GetHelperEventDataByBuildUid(self.param.info.uuid)
    if helpDetectData ~= nil then
      if helpDetectData.cost == 1 then
        DataCenter.FakeHelperMarchManager:AddMarchIndex(self.view.ctrl.pointId, helpDetectData.serverId)
      else
        local CostNum = DataCenter.RadarCenterDataManager:GetDetectHelpTypeCostNum()
        local curNum = LuaEntry.Player:GetCurStamina()
        if CostNum <= curNum then
          DataCenter.FakeHelperMarchManager:AddMarchIndex(self.view.ctrl.pointId, helpDetectData.serverId)
        else
          LWResourceLackUtil:GotoSpecialResLack(ResLackContextType.Energy, nil, true)
        end
      end
      self.view.ctrl:CloseSelf(false)
    end
  elseif self.param.btnType == WorldPointBtnType.MasterySkill then
    DataCenter.MasteryManager:ClickWorldMasteryBtn(self.param, serverId)
  elseif self.param.btnType == WorldPointBtnType.DispatchTask or self.param.btnType == WorldPointBtnType.DispatchTaskHelp or self.param.btnType == WorldPointBtnType.DispatchTaskSteal then
    self:onDispatchTaskClick(self.param.btnType)
  elseif self.param.btnType == WorldPointBtnType.DesertWallDeployment then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWCityDefence)
  elseif self.param.btnType == WorldPointBtnType.BerserkBossRank then
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIBerserkBossRank, {anim = true}, LWUIBerserkBossRankTabType.Boss, self.view.ctrl.uuid)
  elseif self.param.btnType == WorldPointBtnType.KirovBossRank then
    UIManager:GetInstance():OpenWindow(UIWindowNames.KillZombieAlChallengeRank)
  elseif self.param.btnType == WorldPointBtnType.BerserkBossAttack then
    MarchUtil.OnClickStartMarch(MarchTargetType.DIRECT_ATTACK_ACT_BERSERK_BOSS, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 1)
  elseif self.param.btnType == WorldPointBtnType.AllyDrilMove then
    local alyDrillBase = DataCenter.AllyDrillBaseManager:GetDrillBase(self.param.info.uuid)
    if alyDrillBase then
      alyDrillBase:SetMoveState(true)
      WorldMoveMarchUtil.CreateMoveMarch(self.param.info.uuid)
    end
    self.view.ctrl:CloseSelf()
  elseif self.param.btnType == WorldPointBtnType.AllyDrilDonatel then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDrillDonate, {anim = true})
    self.view.ctrl:CloseSelf()
  elseif self.param.btnType == WorldPointBtnType.AllyDrilReward then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllyDrillRank, {anim = true})
    self.view.ctrl:CloseSelf()
  elseif self.param.btnType == WorldPointBtnType.AllyDrillDig then
    AllyDrillUtil.TryOpenDigWindow()
    self.view.ctrl:CloseSelf()
  elseif self.param.btnType == WorldPointBtnType.AllyDrilStart then
    local stage = DataCenter.AllyDrillDataManager:GetCurStageAndCountDown()
    if stage == AllyDrillStage.PrepareStage then
      UIUtil.ShowTipsId(2010381)
    elseif stage == AllyDrillStage.ReadyStage then
      if DataCenter.AllianceBaseDataManager:IsR4orR5() then
        DataCenter.AllyDrillDataManager:SendMsgAllianceBossStart()
      else
        UIUtil.ShowTipsId(2010355)
      end
    end
    self.view.ctrl:CloseSelf()
  elseif self.param.btnType == WorldPointBtnType.Firefighting then
    local targetUid = self.param.info.ownerUid
    if DataCenter.BuildHelpStopFireManager:IsFree() then
      SFSNetwork.SendMessage(MsgDefines.HelpStopCityFire, targetUid, DataCenter.BuildHelpStopFireManager:IsFree() and 1 or 0)
    else
      UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.HelpStopFireConfirm, Localization:GetString("outfire_tips_03", LuaEntry.DataConfig:TryGetNum("city_wall", "k9")), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        SFSNetwork.SendMessage(MsgDefines.HelpStopCityFire, targetUid, DataCenter.BuildHelpStopFireManager:IsFree() and 1 or 0)
      end, function()
      end)
    end
  elseif self.param.btnType == WorldPointBtnType.GhostreconTaskSteal then
    SFSNetwork.SendMessage(MsgDefines.GhostReconSteal, self.param.info.uuid, self.param.info.ownerServer)
  elseif self.param.btnType == WorldPointBtnType.WorldDetectSaveSurvivor then
    DataCenter.RadarCenterDataManager:SetPlotFinishData({
      groupId = self.view.info.pointData.plotId,
      uuid = self.view.ctrl.uuid
    })
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
      plotGroupId = self.view.info.pointData.plotId,
      hideMainUI = false
    })
    SFSNetwork.SendMessage(MsgDefines.StartDetectEventTalk, self.view.ctrl.uuid)
  elseif self.param.btnType == WorldPointBtnType.DetectEventCaveExploration then
    local template = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(self.param.info.eventId)
    local worldPos = SceneUtils.TileIndexToWorld(self.view.ctrl.pointId, ForceChangeScene.World)
    if template:IsRollTreasure() then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIRollTreasure, self.param.info.uuid, worldPos)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectCaveExploration, self.param.info.uuid, worldPos)
    end
  elseif self.param.btnType == WorldPointBtnType.AttackAisilla then
    MarchUtil.OnClickStartMarch(MarchTargetType.MONSTER_INVASION_BOSS, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, MarchAutoBackType.Back)
  elseif self.param.btnType == WorldPointBtnType.AssistanceWinterEntity then
    if DataCenter.ActWinterStormManager:BuildOpenCheck(self.param.info) then
      if WorldBattleUtil.EnableShowWorldAssistanceInfo() then
        WorldBattleUtil.TrySendAssistanceMarch({
          uuid = self.view.ctrl.uuid,
          playerUid = self.view.ctrl.ownerUid,
          pointId = self.view.ctrl.pointId,
          asType = AssistanceType.WinterEntity,
          isThroneCity = false,
          isCrossServerThrone = false
        }, BattleFieldUtil.CanMultiAssistance(BattleFieldType.WinterStorm))
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.view.ctrl.uuid, self.view.ctrl.ownerUid, self.view.ctrl.pointId, AssistanceType.WinterEntity)
      end
    end
  elseif self.param.btnType == WorldPointBtnType.AttackWinterEntity then
    if DataCenter.ActWinterStormManager:BuildOpenCheck(self.param.info) then
      MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_WINTER_ENTITY, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 1)
    end
  elseif self.param.btnType == WorldPointBtnType.ScoutWinterEntity then
    if DataCenter.ActWinterStormManager:BuildOpenCheck(self.param.info) then
      UIUtil.ClickUICloseWorldUI()
      MarchUtil.LaunchScout(MarchTargetType.SCOUT_WINTER_ENTITY, self.view.ctrl.pointId, self.view.ctrl.uuid)
    end
  elseif self.param.btnType == WorldPointBtnType.StealWinterEntity then
    if DataCenter.ActWinterStormManager:BuildOpenCheck(self.param.info) then
      UIUtil.ClickUICloseWorldUI()
      MarchUtil.LaunchScout(MarchTargetType.SCOUT_WINTER_ENTITY, self.view.ctrl.pointId, self.view.ctrl.uuid)
    end
  elseif self.param.btnType == WorldPointBtnType.AssistanceDragonBuild then
    if DataCenter.ActDragonManager:BuildOpenCheck(self.param.info) then
      if WorldBattleUtil.EnableShowWorldAssistanceInfo() then
        WorldBattleUtil.TrySendAssistanceMarch({
          uuid = self.view.ctrl.uuid,
          playerUid = self.view.ctrl.ownerUid,
          pointId = self.view.ctrl.pointId,
          asType = AssistanceType.DragonBuild,
          isThroneCity = false,
          isCrossServerThrone = false
        })
      else
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.view.ctrl.uuid, self.view.ctrl.ownerUid, self.view.ctrl.pointId, AssistanceType.DragonBuild)
      end
    end
  elseif self.param.btnType == WorldPointBtnType.AttackDragonBuild then
    if DataCenter.ActDragonManager:BuildOpenCheck(self.param.info) then
      MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_DRAGON_BUILDING, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 1)
    end
  elseif self.param.btnType == WorldPointBtnType.ScoutDragonBuild then
    if DataCenter.ActDragonManager:BuildOpenCheck(self.param.info) then
      if DataCenter.ArmyFormationDataManager:GetFreeScoutFormation() then
        MarchUtil.LaunchScout(MarchTargetType.SCOUT_DRAGON_BUILDING, self.view.ctrl.pointId, self.view.ctrl.uuid)
        self.view.ctrl:CloseSelf()
      else
        UIUtil.ShowTipsId("300607")
      end
    end
  elseif self.param.btnType == WorldPointBtnType.PickDragonBuild then
    if DataCenter.ArmyFormationDataManager:GetFreeScoutFormation() then
      MarchUtil.LaunchScout(MarchTargetType.SCOUT_DRAGON_SCORE, self.view.ctrl.pointId, self.view.ctrl.uuid)
      self.view.ctrl:CloseSelf()
    else
      UIUtil.ShowTipsId("300607")
    end
  elseif self.param.btnType == WorldPointBtnType.RallyDragonBuild then
    if DataCenter.ActDragonManager:BuildOpenCheck(self.param.info) then
      MarchUtil.OnClickStartMarch(MarchTargetType.RALLY_DRAGON_BUILDING, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 0)
    end
  elseif self.param.btnType == WorldPointBtnType.StatusDragonBuild then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDesertBuildStatus, {anim = true}, self.param.info, {
      uuid = self.view.ctrl.uuid,
      ownerUid = self.view.ctrl.ownerUid,
      pointId = self.view.ctrl.pointId
    })
  elseif self.param.btnType == WorldPointBtnType.StatusBattlefieldBuild then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBFDsbDuelBattleBuildState, {anim = true}, self.param.info, {
      uuid = self.view.ctrl.uuid,
      ownerUid = self.view.ctrl.ownerUid,
      pointId = self.view.ctrl.pointId
    })
  elseif self.param.btnType == WorldPointBtnType.DragonCommandOrder then
    if DataCenter.ActDragonManager:IsSelfCommander() then
      local btnList = {}
      if DataCenter.ActDragonManager:CheckPointHaveOrder(self.view.ctrl.pointId) > 0 then
        table.insert(btnList, WorldPointBtnType.DragonCommandOrderDelete)
      end
      table.insert(btnList, WorldPointBtnType.DragonCommandOrderTypePick)
      table.insert(btnList, WorldPointBtnType.DragonCommandOrderTypeAssist)
      table.insert(btnList, WorldPointBtnType.DragonCommandOrderTypeAtk)
      self.view.info.btnList = btnList
      self.view:ShowBtn()
      return
    else
      UIUtil.ShowTipsId("Desert_strom_commander_1027")
    end
  elseif self.param.btnType == WorldPointBtnType.DragonCommandOrderTypeAssist or self.param.btnType == WorldPointBtnType.DragonCommandOrderTypeAtk or self.param.btnType == WorldPointBtnType.DragonCommandOrderTypePick then
    local sendInfo = {
      type = self.param.btnType,
      point = self.view.ctrl.pointId
    }
    local extra = {}
    local ctrlType = self.view.ctrl.type
    local info = CS.SceneManager.World:GetPointInfo(self.view.ctrl.pointId)
    if ctrlType == WorldPointUIType.DragonBuild then
      extra.buildId = self.param.info.buildId
    elseif ctrlType == WorldPointUIType.City then
      local cityList = CS.SceneManager.World:GetAllMainBaseList()
      if cityList ~= nil then
        for _, v in pairs(cityList) do
          if v.ownerUid == info.ownerUid then
            extra.skinId = v.skinId > 0 and v.skinId or 10001
            break
          end
        end
      end
    elseif ctrlType == WorldPointUIType.CollectPoint or ctrlType == WorldPointUIType.CollectArmy then
      extra.buildId = 10120
    end
    sendInfo.extra = rapidjson.encode(extra)
    DataCenter.ActDragonManager:TrySendCommandOrder(sendInfo)
  elseif self.param.btnType == WorldPointBtnType.DragonCommandOrderDelete then
    local idx = DataCenter.ActDragonManager:CheckPointHaveOrder(self.view.ctrl.pointId)
    if idx > 0 then
      DataCenter.ActDragonManager:SendCommandOrderDel(idx)
    end
  elseif self.param.btnType == WorldPointBtnType.DominatorGuide then
    DataCenter.DominatorGuideManager:SendSetGuideProgressMessage(1)
    DataCenter.RadarCenterDataManager:SetPlotFinishData({
      groupId = self.view.info.pointData.plotId,
      uuid = self.view.ctrl.uuid
    })
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
      plotGroupId = self.view.info.pointData.plotId,
      hideMainUI = false
    })
    SFSNetwork.SendMessage(MsgDefines.StartDetectEventTalk, self.view.ctrl.uuid)
  elseif self.param.btnType == WorldPointBtnType.ZoneMobilizationDonate then
    DataCenter.LWZoneMobilizationManager:OpenDonateWindow(self.view.ctrl.pointId)
  elseif self.param.btnType == WorldPointBtnType.AllianceCityRally then
    DataCenter.AllianceBaseDataManager:TrySetRally(self.view.ctrl.pointId, self.view.ctrl.serverId)
  elseif self.param.btnType == WorldPointBtnType.AttackPlayerRuinBuilding then
    local masteryData = DataCenter.MasteryManager:GetData()
    local id = masteryData and masteryData.home_id or 0
    if not LuaEntry.Player:IsInAlliance() then
      UIUtil.ShowTipsId(390536)
    elseif id ~= MasteryHome.Gather then
      UIUtil.ShowTipsId("Teleport_Territory_tips_2")
    else
      MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_PLAYER_RUIN_BUILDING, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 1)
    end
  elseif self.param.btnType == WorldPointBtnType.AssistanceEpidemic then
    local mgr = BattleFieldUtil.GetMgrActive()
    if mgr then
      local canAttack = mgr:BuildOpenCheck(self.param.info)
      if canAttack then
        if WorldBattleUtil.EnableShowWorldAssistanceInfo() then
          WorldBattleUtil.TrySendAssistanceMarch({
            uuid = self.view.ctrl.uuid,
            playerUid = self.view.ctrl.ownerUid,
            pointId = self.view.ctrl.pointId,
            asType = AssistanceType.EpidemicBuild,
            isThroneCity = false,
            isCrossServerThrone = false
          }, mgr:CanMultiAssistance())
        else
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAssistance, self.view.ctrl.uuid, self.view.ctrl.ownerUid, self.view.ctrl.pointId, AssistanceType.EpidemicBuild)
        end
      end
    end
  elseif self.param.btnType == WorldPointBtnType.AttackEpidemic then
    local mgr = BattleFieldUtil.GetMgrActive()
    if mgr then
      if not mgr:CheckBattleStart() then
        UIUtil.ShowTipsId(458254)
        return
      end
      local canAttack = mgr:BuildOpenCheck(self.param.info)
      if canAttack then
        MarchUtil.OnClickStartMarch(MarchTargetType.ATTACK_EPIDEMIC_BUILDING, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 1)
      end
    end
  elseif self.param.btnType == WorldPointBtnType.ScoutEpidemic then
    local mgr = BattleFieldUtil.GetMgrActive()
    if mgr then
      if not mgr:CheckBattleStart() then
        UIUtil.ShowTipsId(458254)
        return
      end
      local canAttack = mgr:BuildOpenCheck(self.param.info)
      if canAttack then
        if DataCenter.ArmyFormationDataManager:GetFreeScoutFormation() then
          MarchUtil.LaunchScout(MarchTargetType.SCOUT_EPIDEMIC_BUILDING, self.view.ctrl.pointId, self.view.ctrl.uuid)
          self.view.ctrl:CloseSelf()
        else
          UIUtil.ShowTipsId("300607")
        end
      end
    end
  elseif self.param.btnType == WorldPointBtnType.PickEpidemic then
    local mgr = BattleFieldUtil.GetMgrActive()
    if mgr then
      if not mgr:CheckBattleStart() then
        UIUtil.ShowTipsId(458254)
        return
      end
      local canAttack = mgr:BuildOpenCheck(self.param.info)
      if canAttack then
        if DataCenter.ArmyFormationDataManager:GetFreeScoutFormation() then
          MarchUtil.LaunchScout(MarchTargetType.PIC_EPIDEMIC_SCORE, self.view.ctrl.pointId, self.view.ctrl.uuid)
          self.view.ctrl:CloseSelf()
        else
          UIUtil.ShowTipsId("300607")
        end
      end
    end
  elseif self.param.btnType == WorldPointBtnType.RallyEpidemic then
    local mgr = BattleFieldUtil.GetMgrActive()
    if mgr then
      if not mgr:CheckBattleStart() then
        UIUtil.ShowTipsId(458254)
        return
      end
      local canAttack = mgr:BuildOpenCheck(self.param.info)
      if canAttack then
        MarchUtil.OnClickStartMarch(MarchTargetType.RALLY_EPIDEMIC_BUILDING, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 0)
      end
    end
  elseif self.param.btnType == WorldPointBtnType.CollectEpidemic then
    local mgr = BattleFieldUtil.GetMgrActive()
    if mgr then
      if not mgr:CheckBattleStart() then
        UIUtil.ShowTipsId(458254)
        return
      end
      local canAttack = mgr:BuildOpenCheck(self.param.info)
      if canAttack then
        MarchUtil.OnClickStartMarch(MarchTargetType.COLLECT_EPIDEMIC_RES, self.view.ctrl.pointId, self.view.ctrl.uuid, -1, 1)
      else
        UIUtil.ShowTipsId("world_tip10006")
      end
    end
  elseif self.param.btnType == WorldPointBtnType.AttackDetectZombieBusTrain then
    local zombieBusEvent = DataCenter.RadarCenterDataManager:GetZombieBusTrainEvent()
    if zombieBusEvent then
      local marchUuid = zombieBusEvent.marchUuid
      local info = CS.SceneManager.World:GetMarch(marchUuid)
      local busList = zombieBusEvent.busList
      local nextBusData, index = DataCenter.RadarCenterDataManager:GetOneCanAttackZombieBusData(busList)
      local rotation = Quaternion.LookRotation(Vector3.New(info.MoveDir.x, info.MoveDir.y, info.MoveDir.z))
      local euler = rotation:ToEulerAngles()
      DataCenter.RadarCenterDataManager:ClickAttackWorldZombieBus(nextBusData, index, zombieBusEvent.uuid, info.position, euler)
    end
  elseif self.param.btnType == WorldPointBtnType.ClickWorldTreasure then
    if mySourceServerId ~= curServerId then
      UIUtil.ShowTipsId("activity_99144_22")
    else
      local info = CS.SceneManager.World:GetPointInfo(self.view.ctrl.pointId)
      cast(info, typeof(CS.WorldActivityTreasureInfo))
      if info then
        local configId = info.cfgId
        local config = LocalController:instance():getLine(TableName.ActivityWorldTreasure, configId)
        if config and config.type == ActivityWorldTreasureType.ActEasterEgg then
          DataCenter.ActEasterEggManager:RecordHasSeenEgg(self.view.ctrl.pointId)
          DataCenter.ActEasterEggManager:OpenWorldEgg(info.uuid)
        end
      end
    end
  elseif self.param.btnType == WorldPointBtnType.KillZombieKirovBox then
    DataCenter.ActivityKillZombieManager:TryShowBoxView(self.view.ctrl.pointId)
  elseif self.param.btnType == WorldPointBtnType.TacticalCardSkill then
    local pointId = self.view.ctrl.pointId
    UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMasterySkillUseInWorld, {anim = true}, MasterySkillUsePosType.Field, pointId, SkillUseInWorldType.TCCardSkill)
  elseif self.param.btnType == WorldPointBtnType.GoldTreeCharge then
    UIUtil.ShowTipsId("GoldTreeCharge")
  elseif self.param.btnType == WorldPointBtnType.GoldTreeBless then
    UIUtil.ShowTipsId("GoldTreeBless")
  elseif self.param.btnType == WorldPointBtnType.DetectRetryRescue or self.param.btnType == WorldPointBtnType.DetectRetryResource then
    self:OnRetryDetectClick()
  elseif self.param.btnType == WorldPointBtnType.DetectEventAttackCityS0BattleRadar then
    self:OnAttackCityS0RadarClick()
  elseif self.param.btnType == WorldPointBtnType.DetectEventDigGame then
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.param.info.detectUuid)
    if data and data.digGameInfo then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIDetectDigTreasure, {anim = true}, data)
    end
  elseif self.param.btnType == WorldPointBtnType.DetectEventLastStand then
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.param.info.detectUuid)
    if data and data.lastStandStageId then
      DataCenter.LastStandManager:EnterLevel(data.lastStandStageId, self.param.info.detectUuid)
    end
  elseif self.param.btnType == WorldPointBtnType.TreasureChest then
    local pointData = self.param.info
    local ownerUid = pointData.ownerUid
    if ownerUid == LuaEntry.Player.uid then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UITreasureChest, {anim = false}, pointData.treasureChestId, pointData.eventUuid)
    end
  elseif self.param.btnType == WorldPointBtnType.SkyBattle then
    local pointData = self.param.info
    local ownerUid = pointData.ownerUid
    if ownerUid == LuaEntry.Player.uid then
      local detectData = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.param.info.uuid)
      if detectData and detectData.skyBattleStage then
        local param = {}
        param.type = PVEType.SkyBattle
        param.enterType = PVEEnterType.Radar
        param.detectUuid = self.param.info.uuid
        param.levelId = tonumber(detectData.skyBattleStage.stageId)
        DataCenter.LWBattleManager:Enter(param)
      end
    end
  elseif self.param.btnType == WorldPointBtnType.DetectEventSuppliesSearch then
    local data = DataCenter.RadarCenterDataManager:GetDetectEventInfo(self.param.info.detectUuid)
    if data then
      DataCenter.SuppliesSearchManager:OpenSuppliesSearchWindow(SuppliesSearchType.Detect, self.param.info.detectUuid)
    end
  elseif self.param.btnType == WorldPointBtnType.DominatorCockatriceUnlock_1 then
    DataCenter.RadarCenterDataManager:SetPlotFinishData({
      groupId = self.view.info.pointData.plotId,
      uuid = self.view.ctrl.uuid
    })
    EventManager:GetInstance():Broadcast(EventId.PlayPlotGroup, {
      plotGroupId = self.view.info.pointData.plotId,
      hideMainUI = false
    })
    SFSNetwork.SendMessage(MsgDefines.StartDetectEventTalk, self.view.ctrl.uuid)
  elseif self.param.btnType == WorldPointBtnType.DominatorCockatriceUnlock_2 then
    DataCenter.DominatorCockatriceUnlockManager:DoFinalTimeline(self.view.ctrl.pointId, self.view.ctrl.uuid)
  elseif self.param.btnType == WorldPointBtnType.KirovBossPlanTime then
    local configId = self.param.info.allianceChallengeId
    if configId then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceKirovPlanTime, {anim = true}, configId)
    end
  elseif self.param.btnType == WorldPointBtnType.AisillaPlanTime then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMonsterInvasionPlanTime, {anim = true}, true)
  elseif self.param.btnType == WorldPointBtnType.BFCommandOrder then
    BattleFieldUtil.OpenPingSign(self.view.ctrl.pointId, true)
  elseif self.param.btnType == WorldPointBtnType.S0AllianceBossBuildingMove then
    DataCenter.S0AllianceBossDataManager:CreateBuildingMovingModel(pointId, uuid)
  elseif self.param.btnType == WorldPointBtnType.S0AllianceBossBossMove then
    DataCenter.S0AllianceBossDataManager:CreateBossMovingModel(pointId, uuid)
  elseif self.param.btnType == WorldPointBtnType.S0AllianceBossBuildingDonate then
    DataCenter.S0AllianceBossDataManager:GoToDonatePanel()
  elseif self.param.btnType == WorldPointBtnType.S0AllianceBossBuildingSetting then
    DataCenter.S0AllianceBossDataManager:GoToSelectLevePanel()
  elseif self.param.btnType == WorldPointBtnType.S0AllianceBossBuildingGift then
    DataCenter.S0AllianceBossDataManager:GoToRewardPreviewPanel()
  elseif self.param.btnType == WorldPointBtnType.S0AllianceBossBuildingRank then
    DataCenter.S0AllianceBossDataManager:GoToRewardRankPanel()
  end
  if self.view ~= nil and self.view.ctrl ~= nil then
    self.view.ctrl:CloseSelf(true)
  end
end

local function HasShield(self, lang)
  return WorldBuildUtil.HasShield(self.view.ctrl.pointId, lang)
end

function UIWorldPointBtn:NeedTipMessageWhenClick()
  local isDragonWorld = BattleFieldUtil.InBattleField()
  if isDragonWorld then
    return nil
  end
  local tipMsg, tipType
  local btnType = self.param.btnType
  local pointInfo = self.param.info
  local buildId = self.param.info.buildId
  local pointId = self.view.ctrl.pointId
  local seasonType = SeasonUtil.GetSeasonType()
  local mainBuildId, carrierBuildId = SeasonUtil.GetSeasonMilitaryCenterId(seasonType)
  if (btnType == WorldPointBtnType.AttackAllianceBuild or btnType == WorldPointBtnType.RallyAllianceBuild) and buildId == mainBuildId and SeasonUtil.SeasonHasMilitaryCenterAttachment(seasonType) and pointInfo and pointInfo.curHp < pointInfo.maxHp * 0.5 then
    local World = CS.SceneManager.World
    local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
    if meta and World ~= nil then
      local maxLevel = meta.max_level
      local vecPos = SceneUtils.IndexToTilePos(pointId, ForceChangeScene.World)
      for level = 1, maxLevel do
        meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(level + buildId)
        if meta and meta.active_building_id and meta.active_building_pos_x and meta.active_building_pos_y then
          local posX = vecPos.x + meta.active_building_pos_x
          local posY = vecPos.y + meta.active_building_pos_y
          local newIndex = SceneUtils.TileXYToIndex(posX, posY, ForceChangeScene.World)
          local info = World:GetPointInfo(newIndex)
          if info ~= nil then
            local detailInfo = PBController.ParsePbFromBytes(info.extraInfo, "protobuf.AllianceBuildingPointInfo")
            if detailInfo then
              local curHp = toInt(detailInfo.durability or 0)
              local state = toInt(detailInfo.state or 0)
              if 0 < curHp and state ~= AllianceMineStatus.Ruin then
                tipMsg = Localization:GetString("season_s3_alliance_battle_tips02")
                tipType = TodayNoSecondConfirmType.AllianceCenterAttackS3
                break
              end
            end
          end
        end
      end
    end
  end
  return tipMsg, tipType
end

function UIWorldPointBtn:onDispatchTaskClick(btnType)
  local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.DispatchTask.Type)
  local actInfo = 0 < #actList and actList[1] or nil
  if actInfo == nil then
    UIUtil.ShowTipsId(456253)
    return
  end
  if actInfo.needMainCityLevel and actInfo.needMainCityLevel > DataCenter.BuildManager.MainLv then
    UIUtil.ShowTipsId(456253)
    return
  end
  local uuid = self.view.ctrl.uuid
  local pointId = self.view.ctrl.pointId
  local serverId = self.view.ctrl.serverId
  local curServerId = serverId or LuaEntry.Player:GetCurServerId()
  local info = CS.SceneManager.World:GetPointInfoByUuid(uuid)
  if info ~= nil then
    local mgr = DataCenter.ActDispatchTaskDataManager
    local player = LuaEntry.Player
    local selfUid = player:GetUid()
    local now = UITimeManager:GetInstance():GetServerTime()
    local canAward = 0 < info.completionTime and now >= info.completionTime and info.rewarded == 0
    if canAward then
      if selfUid == info.ownerUid then
        SFSNetwork.SendMessage(MsgDefines.DispatchReward, info.uuid)
      elseif player:IsInAlliance() and player.allianceId == info.allianceId then
        local todayAssistNum = mgr:GetTodayAssistNum()
        local assistMax = toInt(mgr:GetDispatchSetting("aid_count"))
        if todayAssistNum < assistMax then
          SFSNetwork.SendMessage(MsgDefines.DispatchAssist, info.uuid, LuaEntry.Player:GetCurServerId())
        else
          UIUtil.ShowTipsId(456225)
        end
      else
        local protectTime = tonumber(GetTableData(TableName.LwDispatchTask, info.cfgId, "protect_times")) * 60000
        if now >= info.completionTime + protectTime then
          if not info.stealList:Contains(selfUid) then
            local todayStealNum = mgr:GetTodayStealNum()
            local steal_count = mgr:GetDispatchSetting("steal_count")
            if todayStealNum < steal_count then
              local stealedMax = tonumber(GetTableData(TableName.LwDispatchTask, info.cfgId, "steal_maxtimes"))
              if stealedMax > info.stealList.Count then
                if DataCenter.ActDispatchTaskDataManager:IsOpenCrossSteal() or not CrossServerUtil:NeedIntercept(500019) then
                  SFSNetwork.SendMessage(MsgDefines.DispatchSteal, info.uuid, curServerId)
                end
              else
                UIUtil.ShowTipsId(456227)
              end
            else
              UIUtil.ShowTipsId(456226)
            end
          else
            UIUtil.ShowTipsId(456235)
          end
        else
          UIUtil.ShowTipsId(456223)
        end
      end
    elseif selfUid == info.ownerUid and info.completionTime == 0 then
      local maxMarch = DataCenter.ActDispatchTaskDataManager:GetMaxMarch()
      if maxMarch <= mgr:GetSingleTaskIngCount() then
        DataCenter.ActDispatchTaskDataManager:ShowMarchLimitTip()
      else
        local uuid = info.uuid
        GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(info.pointIndex, ForceChangeScene.World), CS.SceneManager.World.InitZoom, LookAtFocusTime, function()
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationDispatchTask, uuid)
        end, serverId)
      end
    else
      UIUtil.ShowTipsId(456255)
    end
  end
end

local function PlayAnim(self, name)
  if self.anim then
    self.anim:Play(name, 0, 0)
  end
end

local function GetPosition(self)
  return self.btnImage.transform.position
end

function UIWorldPointBtn:Update1000MS()
  self:RefreshScout()
end

function UIWorldPointBtn:RefreshScout()
  local readyTs
  local grayCanClick = false
  if self.param then
    if self.param.btnType == WorldPointBtnType.ScoutCity then
      readyTs = DataCenter.ArmyFormationDataManager:GetScoutCD(self.param.info.uuid)
      grayCanClick = true
    elseif self.param.btnType == WorldPointBtnType.AllyDrilMove then
      readyTs = DataCenter.AllyDrillDataManager:GetMoveCD()
      grayCanClick = false
    elseif self.param.btnType == WorldPointBtnType.S0AllianceBossBuildingMove or self.param.btnType == WorldPointBtnType.S0AllianceBossBossMove then
      readyTs = DataCenter.S0AllianceBossDataManager:GetMoveCD()
      grayCanClick = false
    end
  end
  if readyTs then
    local now = UITimeManager:GetInstance():GetServerSeconds()
    if readyTs > now then
      local countDown = UITimeManager:GetInstance():SecondToFmtStringWithoutHour(readyTs - now)
      self.btnText:SetText(countDown)
      self.btnText:SetActive(true)
      CS.UIGray.SetGray(self.btnImage.transform, true, grayCanClick)
    else
      self.btnText:SetActive(false)
      CS.UIGray.SetGray(self.btnImage.transform, false, true)
    end
  end
end

function UIWorldPointBtn:WorldSupplies(uuid, pointId)
  local detailData = DataCenter.WorldPointDetailManager:GetWorldSuppliesPointDetailData(uuid)
  if not detailData then
    return
  end
  if detailData.rewardCount < detailData.rewardMax then
    local flag, notice = detailData:CheckBtnState()
    if flag then
      MarchUtil.LaunchScout(MarchTargetType.SCOUT_SUPPLIES, pointId, uuid)
    else
      UIUtil.ShowSingleTip(notice)
    end
    return
  end
  if detailData.rewardLeftCount then
    UIUtil.ShowSingleTip(Localization:GetString("season4_supplies_UI_29"))
  else
    UIUtil.ShowSingleTip(Localization:GetString("season_s2_ice_supplies_10", detailData.rewardMax))
  end
end

local function OnRetryDetectClick(self)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local data = CS.SceneManager.World:GetDetectRetryTaskPointInfo(self.view.ctrl.pointId)
  local detectData = DataCenter.RadarCenterDataManager:GetDetectEventInfo(data.uuid)
  if detectData and detectData.endTime >= curTime + 30000 then
    local soldierItemNum = 0
    if self.param.btnType == WorldPointBtnType.DetectRetryRescue then
      local line = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_Stage_Feature), data.featureConfigId)
      local collect_type = line:getValue("collect_type")
      local collectRewardNum = 0
      if not string.IsNullOrEmpty(collect_type) then
        local split = string.split(collect_type, "|")
        collectRewardNum = tonumber(split[2])
      end
      soldierItemNum = collectRewardNum
    end
    local config = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
    local param = {}
    param.uuid = data.uuid
    param.eventType = config.type
    param.featureConfigId = data.featureConfigId
    param.pointId = self.view.ctrl.pointId
    param.prefabPath = config:GetDetectRetryTaskObjectPath()
    param.endTime = detectData.endTime
    if 0 < soldierItemNum then
      local number = math.modf(LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SOLDIER_MAX_STOCK))
      local playerNumber = DataCenter.SoldierDataManager:GetPlayerSoldiersTotalNum()
      local maxCount = number - playerNumber
      if soldierItemNum > maxCount then
        UIUtil.TryShowConfirm(TodayNoSecondConfirmType.DetectRescueSodlierFull, Localization:GetString("new_detect_tips_32"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
          SFSNetwork.SendMessage(MsgDefines.DetectEventTaskRetryStart, param)
        end, function()
        end, nil, nil, false, nil, nil)
      else
        SFSNetwork.SendMessage(MsgDefines.DetectEventTaskRetryStart, param)
      end
    else
      SFSNetwork.SendMessage(MsgDefines.DetectEventTaskRetryStart, param)
    end
  else
    UIUtil.ShowTipsId("new_detect_tips_7")
  end
end

function UIWorldPointBtn:OnAttackCityS0RadarClick()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local data = DataCenter.AttackCityS0DataManager:GetOneEventDataByPointId(self.view.ctrl.pointId)
  if data and data.uuid then
    local detectData = DataCenter.RadarCenterDataManager:GetDetectEventInfo(data.uuid)
    if detectData and detectData.endTime >= curTime + 60000 then
      local config = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(data.eventId)
      local param = {}
      param.uuid = data.uuid
      param.eventType = config.type
      param.featureConfigId = data.configIdS0
      param.pointId = self.view.ctrl.pointId
      param.prefabPath = config:GetDetectRetryTaskObjectPath()
      param.endTime = data.endTime
      SFSNetwork.SendMessage(MsgDefines.DetectEventCityCompetitionS0Start, param)
    else
      UIUtil.ShowTipsId("new_detect_tips_7")
    end
  end
end

UIWorldPointBtn.OnCreate = OnCreate
UIWorldPointBtn.OnDestroy = OnDestroy
UIWorldPointBtn.OnEnable = OnEnable
UIWorldPointBtn.OnDisable = OnDisable
UIWorldPointBtn.ComponentDefine = ComponentDefine
UIWorldPointBtn.ComponentDestroy = ComponentDestroy
UIWorldPointBtn.DataDefine = DataDefine
UIWorldPointBtn.DataDestroy = DataDestroy
UIWorldPointBtn.ReInit = ReInit
UIWorldPointBtn.OnBtnClick = OnBtnClick
UIWorldPointBtn.PlayAnim = PlayAnim
UIWorldPointBtn.GetPosition = GetPosition
UIWorldPointBtn.HasShield = HasShield
UIWorldPointBtn.OnRetryDetectClick = OnRetryDetectClick
return UIWorldPointBtn
