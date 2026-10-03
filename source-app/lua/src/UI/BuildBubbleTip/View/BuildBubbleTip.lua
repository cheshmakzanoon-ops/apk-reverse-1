local BuildBubbleTip = BaseClass("BuildBubbleTip")
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local bg_path = "Go/Bg"
local trigger_path = "Go/Trigger"
local icon_path = "Go/Bg/Icon"
local icon_go_path = "Go"
local upgrade_effect_path = "Go/UpgradeEffect"
local obj_path = ""
local time_path = "Go/Bg/time"
local progress_path = "Go/Bg/Progress"
local reminds_path = "Go/RemindsTxt"
local num_path = "Go/Bg/num"
local check_path = "Go/Bg/check"
local PositionDelta2 = Vector3.New(-1, 0, -1)
local PositionDelta4 = Vector3.New(0.3, 0, -0.8)
local PositionDelta7 = Vector3.New(-0.5, 0, -1)
local FixNormalAnimTime = 0.1
local ClickDuringTime = 0.5
local fullEffectPath = "Assets/_Art/Effect/prefab/ui/VFX_ziyuanshouqu_glow_loop.prefab"
local AnimName = {
  Enter = "EnterBubble",
  Hide = "HideBubble",
  Normal = "NormalBubble",
  ResourceItem = "goodsBubble",
  Default = "Default"
}

function BuildBubbleTip:OnCreate(go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  
  function self.timer_action(temp)
    self:TimerAction()
  end
  
  self:DataDefine()
end

function BuildBubbleTip:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
end

function BuildBubbleTip:ComponentDefine()
  if not self.defend then
    if self.param.model == UIAssets.BuildStateIcon then
      self.upgrade_effect_go = self.transform:Find(upgrade_effect_path).gameObject
      self.time_text = self.transform:Find(time_path):GetComponent(typeof(CS.TextMeshProEx))
    elseif self.param.model == UIAssets.BuildStateIcon4 then
      self.icon_Circle = self.transform:Find(icon_go_path):GetComponent(typeof(CS.ChangeSceneCircleSlider))
      self.time_text = self.transform:Find(time_path):GetComponent(typeof(CS.TextMeshProEx))
    elseif self.param.model == UIAssets.BuildStateIcon8 then
      self.icon_Circle = self.transform:Find(icon_go_path):GetComponent(typeof(CS.ChangeSceneCircleSlider))
      self.time_text = self.transform:Find(time_path):GetComponent(typeof(CS.TextMeshProEx))
      if type(self.icon_Circle.GetSpriteRenderer) == "function" then
        self.icon_CircleSprite = self.icon_Circle:GetSpriteRenderer()
        if self.icon_CircleSprite then
          self.icon_CircleSprite:LoadSprite("Assets/Main/Sprites/UI/UIBuildBubble/cfm_zhujiemian_qipao_1_1.png")
        end
      end
    elseif self.param.model == UIAssets.BuildStateIcon5 then
      self.time_text = self.transform:Find(time_path):GetComponent(typeof(CS.TextMeshProEx))
      self.newBg = self.transform:Find("Go/Bg/NewBg"):GetComponent(typeof(CS.SpriteMeshRenderer))
      self.newText = self.transform:Find("Go/Bg/NewText"):GetComponent(typeof(CS.TextMeshProEx))
    elseif self.param.model == UIAssets.BuildStateIcon6 then
      self.time_text = self.transform:Find(time_path):GetComponent(typeof(CS.TextMeshProEx))
    elseif self.param.model == UIAssets.BuildStateIcon7 then
      self.progress_text = self.transform:Find(progress_path):GetComponent(typeof(CS.TextMeshProEx))
    elseif self.param.model == UIAssets.BuildStateIcon9 then
      self.reminds_text = self.transform:Find(reminds_path):GetComponent(typeof(CS.TextMeshProEx))
    elseif self.param.model == UIAssets.BuildStateIcon10 then
      self.progress_text = self.transform:Find(progress_path):GetComponent(typeof(CS.TextMeshProEx))
    elseif self.param.model == UIAssets.BuildBubbleUpgradeItem then
      self.num_text = self.transform:Find(num_path):GetComponent(typeof(CS.SuperTextMesh))
      self.check_go = self.transform:Find(check_path).gameObject
    elseif self.param.model == UIAssets.FirstPayFixing then
      self.time_text = self.transform:Find(time_path):GetComponent(typeof(CS.SuperTextMesh))
    elseif self.param.model == UIAssets.PVPArenaBubble then
      self.icon_head = self.transform:Find("Go/Bg/head").gameObject:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
      self.playerHeadComp = self.icon_head.gameObject:GetComponent(typeof(CS.UIPlayerHead))
      self.border_head = self.transform:Find("Go/Bg/border").gameObject
      self.txt_time = self.transform:Find("Go/txtTime"):GetComponent(typeof(CS.SuperTextMesh))
      local bgTime = self.transform:Find("Go/bgTime")
      if not IsNull(bgTime) then
        self.bg_time = bgTime.gameObject
      end
    elseif self.param.model == UIAssets.PVPArenaChampionDuelBubble then
      self.time_text = self.transform:Find(time_path):GetComponent(typeof(CS.SuperTextMesh))
    elseif self.param.model == UIAssets.DecorationPlaySoundBubble then
      self.time_text = self.transform:Find("Go/txtTime"):GetComponent(typeof(CS.TextMeshProEx))
    elseif self.param.model == UIAssets.HeroEventFinishBubble then
      self.icon_head = self.transform:Find("Go/Bg/head").gameObject:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    elseif self.param.buildBubbleType == BuildBubbleType.BuildSeasonLightHouse then
      self.time_text = self.transform:Find("Go/Bg/time"):GetComponent(typeof(CS.SuperTextMesh))
      if self.time_text ~= nil then
        self.time_text.gameObject.transform:Set_localScale(2, 2, 2)
        self.time_text.gameObject.transform:Set_localPosition(0, -1.5, 0)
      end
    elseif self.param.model == UIAssets.MoFieBuildIconBubble then
      self.bg_2 = self.transform:Find("Go/Bg/Bg_2").gameObject:GetComponent(typeof(CS.SpriteMeshRenderer))
      self.text_moFie = self.transform:Find("Go/Bg/Bg_2/text").gameObject:GetComponent(typeof(CS.TextMeshProEx))
    elseif self.param.model == UIAssets.MysteryTreasureBubble then
      self.progressBgSprite = self.transform:Find("Go/Bg/progressBg")
      self.progressSprite = self.transform:Find("Go/Bg/progress"):GetComponent(typeof(CS.UnityEngine.MeshRenderer))
      self.progressSprite.material:SetFloat("_Angle", 90)
    elseif self.param.model == UIAssets.RaceEntranceBubble or self.param.model == UIAssets.RaceEntranceBigBubble then
      self.time_text = self.transform:Find(time_path):GetComponent(typeof(CS.SuperTextMesh))
    end
    self.icon_go = self.transform:Find(icon_go_path):GetComponent(typeof(CS.SimpleAnimation))
    self.icon_sprite = self.transform:Find(icon_path):GetComponent(typeof(CS.SpriteMeshRenderer))
    self.bg_color = self.transform:Find(bg_path):GetComponent(typeof(CS.SpriteMeshRenderer))
    self.bg = self.transform:Find(trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
    self.bg_color:Set_color_a(1.0)
    self.icon_sprite:Set_color_a(1.0)
    self.obj = self.transform:Find(obj_path):GetComponent(typeof(typeof(CS.UnityEngine.Transform)))
    
    function self.bg.onPointerClick()
      self:OnClick()
    end
    
    function self.bg.onPointerDoubleClick()
      self:OnDoubleClick()
    end
    
    function self.bg.onPointerDown()
      self:OnPointerDown()
    end
    
    function self.bg.onPointerUp()
      self:OnPointerUp()
    end
    
    self.defend = true
  end
end

function BuildBubbleTip:ComponentDestroy()
  self.tweenAnimations = nil
  if not IsNull(self.bg) then
    self.bg.onPointerClick = nil
    self.bg.onPointerDoubleClick = nil
    self.bg.onPointerDown = nil
    self.bg.onPointerUp = nil
    self.bg = nil
  end
  self.icon_sprite = nil
  self.gameObject = nil
  self.transform = nil
  self.model_go = nil
  self.bg_color = nil
  self.icon_go = nil
  self.obj = nil
  if self.delayTimer then
    self.delayTimer:Stop()
    self.delayTimer = nil
  end
  self.progressBgSprite = nil
  self.progressSprite = nil
end

function BuildBubbleTip:DataDefine()
  self.param = nil
  self.defend = nil
  self.animationAlreadyShow = false
  self.isShow = false
  self.isHide = false
  self.cdTimer = nil
  self.oldParam = nil
  self.tween = nil
  
  function self.fix_bug_timer_action(temp)
    self:FixBugTimeCallBack()
  end
  
  function self.click_cd_timer_callback(temp)
    self:ClickCdTimerCallBack()
  end
  
  self.heightDeltaPos = Vector3.New(0, 0, 0)
  self.state = nil
end

function BuildBubbleTip:DataDestroy()
  if self.icon_Circle then
    self.icon_Circle:ClearData()
  end
  self:DeleteTimer()
  self:ClearAllEffectAndTimer()
  self.isShow = nil
  self.param = nil
  self.defend = nil
  self.animationAlreadyShow = nil
  self.cdTimer = nil
  self.oldParam = nil
  self.fix_bug_timer_action = nil
  self.tween = nil
  self.state = nil
  self.buildData = nil
  self.queueData = nil
  self.isHide = nil
  if self.delayAnim then
    self.delayAnim:Stop()
    self.delayAnim = nil
  end
end

function BuildBubbleTip:ReInit(param)
  self.oldParam = self.param
  self.param = param
  self.buildData = nil
  self:ComponentDefine()
  self:ShowPanel()
  self:ShowResFullEffect()
end

function BuildBubbleTip:ShowResFullEffect()
  if self.param.resourceType ~= nil then
    local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.uuid)
    local percent = buildingData:GetResourcePercent()
    if 1 <= percent then
      self:ShowFullEffect()
      EventManager:GetInstance():Broadcast(EventId.ResourceFull, self.param.resourceType)
    else
      self:ClearFullEffect()
    end
  elseif self.param.buildBubbleType == BuildBubbleType.HeroFreeScienceAddTime or self.param.buildBubbleType == BuildBubbleType.HeroFreeBuildAddTime then
    self:ShowFullEffect()
  else
    self:ClearFullEffect()
  end
end

function BuildBubbleTip:ShowPanel()
  local theBuildBubbleType = -1
  self.state = nil
  if self.progressTimer then
    self.progressTimer:Stop()
    self.progressTimer = nil
  end
  if self.param.model == UIAssets.BuildStateIcon then
    self.upgrade_effect_go:SetActive(false)
  end
  if self.param ~= nil then
    theBuildBubbleType = self.param.buildBubbleType
  end
  if self.oldParam == nil or self.param.bgName ~= self.oldParam.bgName then
    if self.param.bgName ~= nil then
      self.bg_color.gameObject:SetActive(true)
      if self.param.bgName ~= "" then
        self.bg_color:LoadSprite(self.param.bgName)
      end
    else
      self.bg_color.gameObject:SetActive(false)
    end
  end
  if self.time_text ~= nil then
    self.time_text.text = ""
  end
  if self.oldParam == nil or self.param.iconName ~= self.oldParam.iconName then
    if self.param.iconName ~= nil and self.param.iconName:sub(-1) ~= "/" then
      self.icon_sprite.gameObject:SetActive(true)
      local async = self.param.buildBubbleType == BuildBubbleType.RaceEntrance or self.param.buildBubbleType == BuildBubbleType.BuildMummyYard
      self.icon_sprite:LoadSprite(self.param.iconName, nil, async)
    else
      self.icon_sprite.gameObject:SetActive(false)
    end
  end
  if (self.oldParam == nil or self.param.bgScale ~= self.oldParam.bgScale) and self.param.bgScale ~= nil and self.bg_color ~= nil then
    local v = self.param.bgScale
    self.bg_color.transform:Set_localScale(v.x, v.y, v.z)
  end
  if (self.oldParam == nil or self.param.iconScale ~= self.oldParam.iconScale) and self.param.iconScale ~= nil and self.icon_sprite ~= nil then
    local v = self.param.iconScale
    self.icon_sprite.transform:Set_localScale(v.x, v.y, v.z)
  end
  if (self.oldParam == nil or self.param.pos ~= self.oldParam.pos or self.oldParam.modelHeight ~= self.param.modelHeight) and self.param.pos ~= nil then
    self:UpdatePosition(self.param.pos)
  end
  if (self.oldParam == nil or self.param.iconLocalPos ~= self.oldParam.iconLocalPos) and self.icon_sprite then
    if self.param.iconLocalPos ~= nil then
      local pos = self.param.iconLocalPos
      self.icon_sprite.transform:Set_localPosition(pos.x, pos.y, pos.z)
    else
      self.icon_sprite.transform:Set_localPosition(0, 0.2, -0.11)
    end
  end
  if theBuildBubbleType == BuildBubbleType.HeroFreeScienceAddTime or theBuildBubbleType == BuildBubbleType.HeroFreeBuildAddTime then
    self.icon_sprite.gameObject:SetActive(true)
  elseif theBuildBubbleType == BuildBubbleType.BuildHeroCountdownReady then
    self.bg_color.gameObject:SetActive(true)
    self.icon_sprite.gameObject:SetActive(true)
  end
  if theBuildBubbleType == BuildBubbleType.BuildCanUpgrade then
    self.icon_sprite.gameObject:SetActive(false)
    self.upgrade_effect_go:SetActive(true)
  end
  if theBuildBubbleType == BuildBubbleType.BuildingLv0Ruins then
    self.icon_sprite.gameObject:SetActive(false)
    self.bg_color:LoadSprite(string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BuildingLv0RuinsYellow))
    local topAnim = self.transform:Find("Go/Bg/Top"):GetComponent(typeof(CS.UnityEngine.Animator))
    if topAnim ~= nil then
      topAnim:Play("V_chuizi_play", 0, 0)
    end
    self.bg_color.gameObject:SetActive(true)
  end
  if theBuildBubbleType == BuildBubbleType.ProductLineNormal then
    self.progressTimer = TimerManager:GetInstance():GetTimer(0.1, self.ProgressTimerAction, self, false, false, false)
    self.progressTimer:Start()
    self:ProgressTimerAction()
  end
  if theBuildBubbleType == BuildBubbleType.ProductLineFull then
    if self.icon_Circle then
      self.icon_Circle:Init(281474976710656, 281474976710657)
    end
    local res = DataCenter.ProductLineManager:GetBuildingCurrStorage(self.param.uuid)
    if self.time_text ~= nil then
      self.time_text.text = string.GetFormattedStr(res)
    end
  end
  if theBuildBubbleType == BuildBubbleType.MakingCoffee then
    self.time_text.text = string.GetFormattedStr(self.param.txtNum)
  end
  if theBuildBubbleType == BuildBubbleType.BuildingFunctioning and self.time_text ~= nil then
    if self.newBg ~= nil then
      self.newBg.gameObject:SetActive(false)
    end
    if self.newText ~= nil then
      self.newText.gameObject:SetActive(false)
    end
    self.progressTimer = TimerManager:GetInstance():GetTimer(1, self.TrainingTimerAction, self, false, false, false)
    self.progressTimer:Start()
    self:TrainingTimerAction()
  end
  if theBuildBubbleType == BuildBubbleType.BuildingFunctioningFinish and self.time_text ~= nil then
    if self.buildData == nil then
      self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.uuid)
    end
    local trainCount = BuildingUtils.GetBuildingCurrentProduceCount(self.buildData)
    self.time_text.text = tostring(trainCount)
  end
  if theBuildBubbleType == BuildBubbleType.BattleHangUpBattleJump then
    self.progressTimer = TimerManager:GetInstance():GetTimer(1, self.HangUpBattleJumpTimerAction, self, false, false, false)
    self.progressTimer:Start()
    self:HangUpBattleJumpTimerAction()
  end
  if theBuildBubbleType == BuildBubbleType.BattleHangUp then
    if self.newBg ~= nil then
      self.newBg.gameObject:SetActive(false)
    end
    if self.newText ~= nil then
      self.newText.gameObject:SetActive(false)
    end
    self.progressTimer = TimerManager:GetInstance():GetTimer(1, self.HangUpTimerAction, self, false, false, false)
    self.progressTimer:Start()
    self:HangUpTimerAction()
  end
  if theBuildBubbleType == BuildBubbleType.BuildSeasonLightHouse then
    if self.param.gotoFixBuildUI or self.param.hasWorkerButNoActive then
      if self.time_text ~= nil then
        self.time_text.text = ""
      end
    else
      local mgr = DataCenter.SeasonPowerWorkerManager
      local lightHouseStatus = mgr.lightHouseStatus
      if self.time_text ~= nil then
        if lightHouseStatus and lightHouseStatus.active then
          local brightnessLevel = toInt(lightHouseStatus.brightnessLevel)
          if 0 < brightnessLevel then
            self.time_text.text = "L" .. brightnessLevel
          else
            self.time_text.text = ""
          end
        else
          self.time_text.text = ""
        end
      end
      if lightHouseStatus and lightHouseStatus.active then
        local powerNow, powerMax, powerSpeed = mgr:GetBatteryPowerResourceInfo()
        if powerSpeed ~= nil and powerSpeed ~= 0 then
          self.lastPower = powerNow
          self:AddTimer()
        end
      end
      UIUtil.CheckEventTrigger(OpMode.ClickBtnFixLightHouse)
    end
  end
  if theBuildBubbleType == BuildBubbleType.BuildSeasonPowerStation or theBuildBubbleType == BuildBubbleType.BuildNormalTaskBubble then
    local theTaskInfo = self.param.taskInfo
    if theTaskInfo then
      local need, max = theTaskInfo:GetTaskProgress()
      self.time_text.text = string.format("%s/%s", need, max)
      if self.icon_Circle then
        if max == 0 or need == 0 then
          self.icon_Circle:ClearData()
        else
          self.icon_Circle:SetValue(need / max)
          if self.icon_CircleSprite then
            if max <= need then
              self.icon_CircleSprite:LoadSprite("Assets/Main/Sprites/UI/UIBuildBubble/cfm_zhujiemian_qipao_1_1.png")
            else
              self.icon_CircleSprite:LoadSprite("Assets/Main/Sprites/UI/UIBuildBubble/cfm_zhujiemian_qipao_1_2.png")
            end
          end
        end
      end
    else
      self.time_text.text = ""
      if self.icon_Circle then
        self.icon_Circle:ClearData()
      end
    end
  end
  if theBuildBubbleType == BuildBubbleType.BattleHangUpFinish then
    self.time_text.text = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutSecond(DataCenter.StageManager.hangUpMaxTime)
  end
  if theBuildBubbleType == BuildBubbleType.TruckTravelling then
    self.progressTimer = TimerManager:GetInstance():GetTimer(1, self.TrainTravelTimerAction, self, false, false, false)
    self.progressTimer:Start()
    self:TrainTravelTimerAction()
  end
  if theBuildBubbleType == BuildBubbleType.ZoneSpreadingBattle then
    self.progress_text.text = self.param.progress
  end
  if theBuildBubbleType == BuildBubbleType.AlWelcome then
    self.reminds_text.text = self.param.remindTxt
  end
  if theBuildBubbleType == BuildBubbleType.UpgradeItem then
    if self.param.txtNum ~= nil then
      self.num_text.text = self.param.txtNum
      self.num_text.gameObject:SetActive(true)
      self.check_go:SetActive(false)
    else
      self.num_text.gameObject:SetActive(false)
      self.check_go:SetActive(true)
    end
  end
  if theBuildBubbleType == BuildBubbleType.FirstPayFixing then
    if self.newBg ~= nil then
      self.newBg.gameObject:SetActive(false)
    end
    if self.newText ~= nil then
      self.newText.gameObject:SetActive(false)
    end
    self.progressTimer = TimerManager:GetInstance():GetTimer(1, self.RefreshFirstPayFixingAction, self, false, false, false)
    self.progressTimer:Start()
    self:RefreshFirstPayFixingAction()
  end
  if theBuildBubbleType == BuildBubbleType.ParkingLotState then
    self.progressTimer = TimerManager:GetInstance():GetTimer(1, self.RefreshParkingLotState, self, false, false, false)
    self.progressTimer:Start()
    self:RefreshParkingLotState()
  end
  if theBuildBubbleType == BuildBubbleType.PVPArena then
    self.progressTimer = TimerManager:GetInstance():GetTimer(1, self.RefreshPVPArenaState, self, false, false, false)
    self.progressTimer:Start()
    self:RefreshPVPArenaState()
  end
  if theBuildBubbleType == BuildBubbleType.PVPArenaNew then
    self.icon_sprite.transform:Set_localScale(3, 3, 1)
    self.progressTimer = TimerManager:GetInstance():GetTimer(1, self.ChampionDuelBeginCountDownTimerAction, self, false, false, false)
    self.progressTimer:Start()
    self:ChampionDuelBeginCountDownTimerAction()
  end
  if theBuildBubbleType == BuildBubbleType.QueueWorking and self.time_text ~= nil then
    if self.newBg ~= nil then
      self.newBg.gameObject:SetActive(false)
    end
    if self.newText ~= nil then
      self.newText.gameObject:SetActive(false)
    end
    self.progressTimer = TimerManager:GetInstance():GetTimer(1, self.QueueWorkingTimerAction, self, false, false, false)
    self.progressTimer:Start()
    self:QueueWorkingTimerAction()
  end
  if self.param.buildBubbleType == BuildBubbleType.T11Research and self.param.queueData and self.time_text ~= nil then
    if self.newBg ~= nil then
      self.newBg.gameObject:SetActive(false)
    end
    if self.newText ~= nil then
      self.newText.gameObject:SetActive(false)
    end
    self.progressTimer = TimerManager:GetInstance():GetTimer(1, self.QueueWorkingTimerAction, self, false, false, false)
    self.progressTimer:Start()
    self:QueueWorkingTimerAction()
  end
  if theBuildBubbleType == BuildBubbleType.CountBattleEntrance then
    local showCountBattleBubble = DataCenter.LWTrailTowerManager:CheckBubbleShowByTargetType(TrailTowerTabType.Common)
    local showTrailTowerBubble = DataCenter.LWTrailTowerManager:CheckBubbleShowByTargetType(TrailTowerTabType.TrailTower)
    local showStageFeatureChapterBubble = DataCenter.LWTrailTowerManager:CheckBubbleShowByTargetType(TrailTowerTabType.StageFeatureChapter)
    local showEasyStageFeatureChapterBubble = DataCenter.LWTrailTowerManager:CheckBubbleShowByTargetType(TrailTowerTabType.EasyStageFeatureChapter)
    local showStageFeatureIntegrateBubble = DataCenter.LWTrailTowerManager:CheckBubbleShowByTargetType(TrailTowerTabType.IntegratedStageFeatureChapter)
    if showTrailTowerBubble then
      self.param.trailTowerTabType = TrailTowerTabType.TrailTower
    elseif showStageFeatureIntegrateBubble then
      self.param.trailTowerTabType = TrailTowerTabType.IntegratedStageFeatureChapter
    elseif showStageFeatureChapterBubble then
      self.param.trailTowerTabType = TrailTowerTabType.StageFeatureChapter
    elseif showEasyStageFeatureChapterBubble then
      self.param.trailTowerTabType = TrailTowerTabType.EasyStageFeatureChapter
    elseif showCountBattleBubble then
      self.param.trailTowerTabType = TrailTowerTabType.Common
    end
  end
  if theBuildBubbleType == BuildBubbleType.AlertTowerEntrance then
    local showTrailTowerBubble = DataCenter.LWTrailTowerManager:ShowAlertTowerEntrance() and DataCenter.LWTrailTowerManager:GetTrailTowerShowBubbleData()
    if showTrailTowerBubble then
      self.param.trailTowerTabType = TrailTowerTabType.TrailTower
    end
  end
  if theBuildBubbleType == BuildBubbleType.CivilizationSparkEntrance then
    self.param.trailTowerTabType = TrailTowerTabType.IntegratedStageFeatureChapter
  end
  if theBuildBubbleType == BuildBubbleType.TWSkillChipUnlockCountDown then
    self.progressTimer = TimerManager:GetInstance():GetTimer(1, self.TWSkillChipUnlockCountDownTimerAction, self, false, false, false)
    self.progressTimer:Start()
    self:TWSkillChipUnlockCountDownTimerAction()
  end
  if theBuildBubbleType == BuildBubbleType.DecorationPlaySound then
    self.progressTimer = TimerManager:GetInstance():GetTimer(1, self.RefreshDecorationPlaySoundState, self, false, false, false)
    self.progressTimer:Start()
    self:RefreshDecorationPlaySoundState()
  end
  if theBuildBubbleType == BuildBubbleType.BuildMummyYard and self.time_text ~= nil then
    self.time_text.text = self.param.txtNum or ""
  end
  if theBuildBubbleType == BuildBubbleType.ChampionDuel then
    self.progressTimer = TimerManager:GetInstance():GetTimer(1, self.ChampionDuelBeginCountDownTimerAction, self, false, false, false)
    self.progressTimer:Start()
    self:ChampionDuelBeginCountDownTimerAction()
  end
  if (theBuildBubbleType == BuildBubbleType.T11IdleGame or theBuildBubbleType == BuildBubbleType.SeasonTower or theBuildBubbleType == BuildBubbleType.AlertTowerEntrance) and DataCenter.LWSeasonTowerManager:IsShowEntrance() then
    self.progressTimer = TimerManager:GetInstance():GetTimer(1, self.AlertTowerSwitchTimerAction, self, false, false, false)
    self.progressTimer:Start()
    self:AlertTowerSwitchTimerAction()
  end
  if theBuildBubbleType == BuildBubbleType.RaceEntrance then
    self.progressTimer = TimerManager:GetInstance():GetTimer(1, self.RaceEntranceTimerAction, self, false, false, false)
    self.progressTimer:Start()
    self:RaceEntranceTimerAction()
  end
  if theBuildBubbleType == BuildBubbleType.MoFieHeroBubble then
    self.progressTimer = TimerManager:GetInstance():GetTimer(1, self.MoFieBubbleState, self, false, false, false)
    self.progressTimer:Start()
    self:MoFieBubbleState()
  end
  if theBuildBubbleType == BuildBubbleType.MysteryTreasureChest then
    local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.uuid)
    if buildingData then
      local template = DataCenter.StageFeatureBuildingManager:GetStageFeatureBuildingTemplate(tonumber(buildingData.specialStageId))
      self.progressBgSprite.gameObject:SetActive(false)
      self.progressSprite.gameObject:SetActive(false)
      if 1 < #template.winType then
        if buildingData.specialStagePassedIds and 0 < #buildingData.specialStagePassedIds then
          self.progressBgSprite.gameObject:SetActive(true)
          self.progressSprite.gameObject:SetActive(true)
          local count = 0
          for i = 1, #template.stages do
            local stageId = template.stages[i]
            if table.indexof(buildingData.specialStagePassedIds, stageId) then
              count = count + 1
            end
          end
          self.progressSprite.material:SetFloat("_Progress", count * 0.33)
        else
          self.progressSprite.material:SetFloat("_Progress", 0)
        end
      end
    end
  end
  self:RefreshState()
  self:AddFixBugTimer()
end

function BuildBubbleTip:MoFieBubbleState()
  local lotteryId = DataCenter.LotteryDataManager:GetBuildBubbleGotoLotteryId()
  local lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(lotteryId)
  if lotteryData then
    local conditionInfo = lotteryData:GetHundredBtnShowCondition()
    if not conditionInfo then
      self.bg_2.gameObject:SetActive(false)
      self.icon_sprite.gameObject:SetActive(true)
    end
    local itemId = conditionInfo.itemId
    local needCount = 10
    local haveNum = DataCenter.ItemData:GetItemCount(itemId)
    if needCount < haveNum then
      local pityCurProtectNum = lotteryData.pityCurProtectNum
      self.text_moFie.text = Localization:GetString("monopoly_event_tips_18", lotteryData.pityMaxProtectNum - pityCurProtectNum)
      self.icon_sprite.gameObject:SetActive(false)
      self.bg_2.gameObject:SetActive(true)
    else
      self.bg_2.gameObject:SetActive(false)
      self.icon_sprite.gameObject:SetActive(true)
    end
  else
    self.bg_2.gameObject:SetActive(false)
    self.icon_sprite.gameObject:SetActive(true)
  end
end

function BuildBubbleTip:RefreshPVPArenaState()
  self:ChampionDuelBeginCountDownTimerAction()
  local bubbleType, arenaType, firstInfo, targetTime = DataCenter.NewPeakArenaManager:GetBuildBuildingType()
  if bubbleType and bubbleType == ArenaBubbleType.ShowFirst and firstInfo then
    self.icon_head.gameObject:SetActive(true)
    self.border_head.gameObject:SetActive(true)
    self.icon_sprite.gameObject:SetActive(false)
    self.playerHeadComp:SetData(firstInfo.uid, firstInfo.pic, firstInfo.picver)
  else
    self.icon_head.gameObject:SetActive(false)
    self.border_head.gameObject:SetActive(false)
    self.icon_sprite.gameObject:SetActive(true)
  end
  if targetTime then
    local serverTime = UITimeManager:GetInstance():GetServerTime()
    self.txt_time.gameObject:SetActive(true)
    if not IsNull(self.bg_time) then
      self.bg_time:SetActive(true)
    end
    local remainTime = targetTime - serverTime
    if 0 < remainTime then
      self.hasArenaRemainTime = true
      self.txt_time.text = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
    else
      if self.hasArenaRemainTime then
        self.hasArenaRemainTime = nil
        SFSNetwork.SendMessage(MsgDefines.GetPVPArenaInfo)
      end
      self.txt_time.text = UITimeManager:GetInstance():MilliSecondToFmtString(0)
    end
  else
    self.txt_time.gameObject:SetActive(false)
    if not IsNull(self.bg_time) then
      self.bg_time:SetActive(false)
    end
  end
end

function BuildBubbleTip:ProgressTimerAction()
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.uuid)
  local curRes = DataCenter.ProductLineManager:GetBuildingCurrStorage(self.param.uuid)
  local startTime = toInt(buildData.productTime)
  local endTime = toInt(DataCenter.ProductLineManager:GetNextCollectTime(self.param.uuid))
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local percent = toInt((curTime - startTime) / (endTime - startTime) * 100)
  percent = math.min(percent, 100)
  if self.icon_Circle then
    self.icon_Circle:Init(startTime, endTime)
  end
  if self.time_text ~= nil then
    self.time_text.text = string.GetFormattedStr(curRes)
  end
end

function BuildBubbleTip:TrainingTimerAction()
  if self.buildData == nil then
    self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.uuid)
  end
  local remainTime = BuildingUtils.GetBuildingFunctioningRemainTime(self.buildData)
  if self.time_text ~= nil then
    self.time_text.text = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
  end
  if remainTime <= 0 then
    DataCenter.BuildBubbleManager:CheckShowBubble(tonumber(self.param.uuid))
  end
end

function BuildBubbleTip:TrainTravelTimerAction()
  local state, ms = DataCenter.LWMyStationDataManager:GetTruckStationState(self.param.uuid)
  if state == TruckStationState.Travelling then
    self.time_text.text = UITimeManager:GetInstance():MilliSecondToFmtString(ms)
  else
    DataCenter.BuildBubbleManager:CheckShowBubble(self.param.uuid)
  end
end

function BuildBubbleTip:HangUpTimerAction()
  if self.buildData == nil then
    self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.uuid)
  end
  local totalTime = BuildingUtils.GetBattleHangUpTime(self.buildData)
  if self.time_text ~= nil then
    self.time_text.text = UITimeManager:GetInstance():MilliSecondToFmtStringWithoutSecond(totalTime)
  end
  if totalTime >= DataCenter.StageManager.hangUpMaxTime then
    DataCenter.BuildBubbleManager:RefreshBubbleShow(BuildBubbleType.BattleHangUpBattleJump)
    DataCenter.BuildBubbleManager:RefreshBubbleShow(BuildBubbleType.BattleHangUp)
    DataCenter.BuildBubbleManager:RefreshBubbleShow(BuildBubbleType.BattleHangUpFinish)
  end
end

function BuildBubbleTip:HangUpBattleJumpTimerAction()
  if self.buildData == nil then
    self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.uuid)
  end
  local totalTime = BuildingUtils.GetBattleHangUpTime(self.buildData)
  self.progress_text.text = ""
  local minTime = LuaEntry.DataConfig:TryGetNum("stage_idle_reward", "k3") * 60 * 1000
  if totalTime >= minTime then
    DataCenter.BuildBubbleManager:RefreshBubbleShow(BuildBubbleType.BattleHangUpBattleJump)
    DataCenter.BuildBubbleManager:RefreshBubbleShow(BuildBubbleType.BattleHangUp)
    DataCenter.BuildBubbleManager:RefreshBubbleShow(BuildBubbleType.BattleHangUpFinish)
  end
end

function BuildBubbleTip:RefreshFirstPayFixingAction()
  local fixEndTime = DataCenter.FirstPayManager:GetFixEndTime()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = fixEndTime - curTime
  if not IsNull(self.time_text) then
    self.time_text.text = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
  end
  if remainTime <= 0 then
    DataCenter.BuildBubbleManager:RefreshBubbleShow(BuildBubbleType.FirstPayFixing)
  end
end

function BuildBubbleTip:RefreshParkingLotState()
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if self.param.endTime ~= nil and curTime < self.param.endTime then
    local timeDelta = self.param.endTime - curTime
    local timeShow = UITimeManager:GetInstance():MilliSecondToFmtString(timeDelta)
    self.progress_text.text = timeShow
  else
    self.progress_text.text = ""
  end
end

function BuildBubbleTip:QueueWorkingTimerAction()
  if self.param.queueData == nil then
    self.param.queueData = DataCenter.BuildManager:GetBuildQueueByUuid(self.param.uuid)
    if self.param.queueData == nil then
      return
    end
  end
  local curTime = UITimeManager:GetInstance():GetServerTime()
  local remainTime = self.param.queueData.endTime - curTime
  if remainTime < 0 then
    remainTime = 0
  end
  if self.time_text ~= nil then
    self.time_text.text = UITimeManager:GetInstance():MilliSecondToFmtString(remainTime)
  end
  if remainTime <= 0 then
    DataCenter.BuildBubbleManager:CheckShowBubble(tonumber(self.param.uuid))
  end
end

function BuildBubbleTip:CountBattleEntranceTimerAction()
  local showIcon = BuildBubbleIconName.Beizengmen
  local showCountBattleBubble = not DataCenter.LWCountStageManager:IsAllDone()
  local showTrailTowerBubble = not DataCenter.LWTrailTowerManager:ShowAlertTowerEntrance() and DataCenter.LWTrailTowerManager:GetTrailTowerShowBubbleData()
  if self.param.trailTowerTabType == TrailTowerTabType.TrailTower then
    if showCountBattleBubble then
      self.param.trailTowerTabType = TrailTowerTabType.Common
    end
  elseif showTrailTowerBubble then
    self.param.trailTowerTabType = TrailTowerTabType.TrailTower
    showIcon = BuildBubbleIconName.TrailTowerBubble
  end
  if self.icon_sprite ~= nil then
    self.icon_sprite:LoadSprite(string.format(LoadPath.UIBuildBubble, showIcon))
  end
end

function BuildBubbleTip:TWSkillChipUnlockCountDownTimerAction()
  local remainTime = DataCenter.TWSkillChipManager:GetSkillChipUnlockRemainTime()
  if remainTime <= 0 then
    DataCenter.BuildBubbleManager:RefreshBubbleShow(BuildBubbleType.TWSkillChipUnlockCountDown)
  elseif self.time_text ~= nil then
    self.time_text.text = UITimeManager:GetInstance():SecondToFmtString(remainTime)
  end
end

function BuildBubbleTip:ChampionDuelBeginCountDownTimerAction()
  DataCenter.NewPeakArenaManager:OnUpdateBubbleState()
  if self.param.buildBubbleType == BuildBubbleType.ChampionDuel then
    local remainTime = DataCenter.ChampionDuelManager:GetChampionDuelPreviewRemainTime()
    if remainTime <= 0 then
      if self.time_text ~= nil then
        self.time_text.text = ""
      end
      if DataCenter.ChampionDuelManager.bubbleTipsTimeCountDown then
        self.icon_sprite.color = Color.New(1, 1, 1, 1)
        DataCenter.ChampionDuelManager:SetBubbleTipsTimeCountDownValue(false)
      end
    else
      if not DataCenter.ChampionDuelManager.bubbleTipsTimeCountDown then
        DataCenter.ChampionDuelManager:SetBubbleTipsTimeCountDownValue(true)
      end
      if self.time_text ~= nil then
        self.time_text.text = UITimeManager:GetInstance():SecondToFmtString(remainTime)
      end
    end
  end
end

function BuildBubbleTip:AlertTowerSwitchTimerAction()
  DataCenter.LWSeasonTowerManager:OnUpdateAlertTowerBubbleState()
end

function BuildBubbleTip:RaceEntranceTimerAction()
  if self.param.buildBubbleType ~= BuildBubbleType.RaceEntrance then
    return
  end
  local endTime = self.param.endTime
  if endTime == nil then
    if self.time_text ~= nil then
      self.time_text.gameObject:SetActive(false)
    end
    return
  end
  local curSec = UITimeManager:GetInstance():GetServerSeconds()
  local remainTime = endTime - curSec
  if remainTime <= 0 then
    if self.time_text ~= nil then
      self.time_text.gameObject:SetActive(false)
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshRaceEntrance)
    return
  end
  if self.time_text ~= nil then
    self.time_text.gameObject:SetActive(true)
    self.time_text.text = UITimeManager:GetInstance():SecondToFmtString(remainTime)
  end
end

function BuildBubbleTip:UpdatePosition(index)
  local theBuildBubbleType = -1
  if self.param ~= nil then
    theBuildBubbleType = self.param.buildBubbleType
  end
  self.heightDeltaPos.y = self.param.modelHeight
  if theBuildBubbleType == BuildBubbleType.ResidentOrder then
    self:SetPosition(SceneUtils.TileIndexToWorld(index) + PositionDelta2 + self.heightDeltaPos)
  elseif theBuildBubbleType == BuildBubbleType.PastureProduct then
    self:SetPosition(SceneUtils.TileIndexToWorld(index) + PositionDelta4 + self.heightDeltaPos)
  elseif theBuildBubbleType == BuildBubbleType.GetFoodProduct then
    self:SetPosition(SceneUtils.TileIndexToWorld(index) + PositionDelta7 + self.heightDeltaPos)
  elseif theBuildBubbleType == BuildBubbleType.FireExtinguisher then
    self:SetPosition(SceneUtils.TileIndexToWorld(index) + Vector3.New(-2, 6, 0))
  elseif theBuildBubbleType == BuildBubbleType.ParkingLotUnlock then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(-2, -3, 0))
  elseif theBuildBubbleType == BuildBubbleType.TrainCanRob or theBuildBubbleType == BuildBubbleType.TrainFirstReward then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(-15, 3.4, -20.4))
  elseif theBuildBubbleType == BuildBubbleType.SaveGirl then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(0, 5, 0))
  elseif theBuildBubbleType == BuildBubbleType.DispatchTask then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(3.92, 10.3, -3.28))
  elseif theBuildBubbleType == BuildBubbleType.BuildHammer and self.param.buildId and tonumber(self.param.buildId) == BuildingTypes.LW_BUILD_DISPATCH_TASK then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(3.92, 10.3, -3.28))
  elseif theBuildBubbleType == BuildBubbleType.NewFirstPay then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(-2, self.param.modelHeight, 0))
  elseif theBuildBubbleType == BuildBubbleType.LWMastery then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(0, 5, 0))
  elseif theBuildBubbleType == BuildBubbleType.AlertTowerEntrance then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(0, 6, 0))
  elseif theBuildBubbleType == BuildBubbleType.BuildMummyYard then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(0, 5, 9.3) + self.heightDeltaPos)
  elseif theBuildBubbleType == BuildBubbleType.BuildSeasonLightHouse then
    if self.param.buildId == BuildingTypes.LW_BUILD_SEASON4_LIGHTHOUSE then
      self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(-11.3, 0, 10))
    elseif self.param.gotoFixBuildUI then
      self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(-2, 0, 2.6))
    else
      self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(-3, 0, 3.5))
    end
  elseif theBuildBubbleType == BuildBubbleType.BuildSeasonPowerStation then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(-3, 0, 3.5))
  elseif theBuildBubbleType == BuildBubbleType.TreasureChest then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(-5, 0, 1.5))
  elseif theBuildBubbleType == BuildBubbleType.BuildNormalTaskBubble then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(-1, 0, 1))
  elseif theBuildBubbleType == BuildBubbleType.OpenSeasonBountyShop then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(-1, 0, 3))
  elseif theBuildBubbleType == BuildBubbleType.T11IdleGame then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + self.heightDeltaPos + Vector3.New(-0.5, 0, 0))
  elseif theBuildBubbleType == BuildBubbleType.CoffeeCanUnlocked or theBuildBubbleType == BuildBubbleType.MakingCoffee then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(0, 5, 0))
  elseif theBuildBubbleType == BuildBubbleType.CivilizationSparkSoldiers or theBuildBubbleType == BuildBubbleType.CivilizationSparkEntrance or theBuildBubbleType == BuildBubbleType.CivilizationSparkLvUp then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(0.6, 9, 0))
  elseif theBuildBubbleType == BuildBubbleType.SeasonEatFish then
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(0, 5, 0))
  elseif theBuildBubbleType == BuildBubbleType.SeasonBuildingLv0Ruins then
    if self.param.tileX == 2 then
      self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(0, 3, 0))
    else
      self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + Vector3.New(0, 5, 0))
    end
  elseif theBuildBubbleType == BuildBubbleType.CanFreeRecruitHero then
    local offset = DataCenter.LWCivilizationSparkExtend:BuildBubbleTip_getCanFreeRecruitHeroBubbleOffset()
    if offset then
      self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + offset)
    else
      self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY) + self.heightDeltaPos)
    end
  else
    local theType
    if self.param and self.param.buildId and SeasonUtil.IsSeasonPlayerBuilding(self.param.buildId) then
      theType = ForceChangeScene.World
    end
    self:SetPosition(BuildingUtils.GetBuildModelCenterVec(index, self.param.tileX, self.param.tileY, theType) + self.heightDeltaPos)
  end
end

function BuildBubbleTip:SetPosition(value)
  self.transform:Set_position(value.x, value.y, value.z)
end

function BuildBubbleTip:OnClick()
  if self.param.buildBubbleType == BuildBubbleType.TrainVIP then
    self.param.callBack(self.param)
    return
  end
  if self.cdTimer ~= nil then
    return
  end
  if not CS.SceneManager.World:CanUseInput() then
    return
  end
  if self.param and self.param.callBack ~= nil then
    if self.param.buildBubbleType == BuildBubbleType.FireExtinguisher then
      local blueFire = EffectDefine.SEASON_MUMMY_Status_Id_CURSE1
      if LuaEntry.Effect:HasStatus(blueFire) and LuaEntry.Effect:GetStatusLayer(blueFire) > 0 then
        UIUtil.ShowTipsId("season_s3_Mummy_skill_703050_tips")
        return
      end
    end
    local ui_pos = CS.CSUtils.WorldPositionToUISpacePosition(self.transform.position)
    DataCenter.BuildBubbleManager.lastClickBuildBubbleTipPos = ui_pos
    DataCenter.BuildBubbleManager.lastClickBuildBubbleTipType = self.param.buildBubbleType
    if not self.param.allowContinuousClick then
      self:AddClickCdTimer()
    end
    self.param.callBack(self.param)
  end
end

function BuildBubbleTip:OnDoubleClick()
  if self.param.allowContinuousClick then
    self:OnClick()
  end
end

function BuildBubbleTip:OnPointerDown()
  if self.tween ~= nil then
    self.tween:Kill()
  end
  self.tween = self.transform:DOScale(ResetScale * 0.8, 0.1)
end

function BuildBubbleTip:OnPointerUp()
  if self.tween ~= nil then
    self.tween:Kill()
  end
  self.tween = self.transform:DOScale(ResetScale, 0.1)
end

function BuildBubbleTip:RefreshState()
  if self.oldParam == nil or self.param.state ~= self.oldParam.state then
    if self.param.buildBubbleType == BuildBubbleType.ResidentOrder then
      if self.param.state == BusinessBubbleState.Yes then
        self.param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgCircle)
        self.bg_color:LoadSprite(string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgCircle))
        self.icon_sprite:LoadSprite(string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Mars))
      elseif self.param.state == BusinessBubbleState.NoSubmit then
        self.param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
        self.bg_color:LoadSprite(string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect))
        self.icon_sprite:LoadSprite(string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.Business))
      end
    elseif self.param.buildBubbleType == BuildBubbleType.GetResource and self.state ~= self.param.state then
      self.state = self.param.state
      if self.param.state == BuildGetResourceState.Full then
        self.bg_color.gameObject:SetActive(true)
        self.param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect)
        self.bg_color:LoadSprite(string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgSelect))
      elseif self.param.state == BuildGetResourceState.Add then
        self.bg_color.gameObject:SetActive(true)
        self.param.bgName = string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect)
        self.bg_color:LoadSprite(string.format(LoadPath.UIBuildBubble, BuildBubbleIconName.BgUnSelect))
      end
    end
  end
  if self.param.buildBubbleType == BuildBubbleType.GetFoodProduct then
    self:AddFoodFactoryEffect()
  end
end

function BuildBubbleTip:GetBubblePosition()
  if self.icon_sprite ~= nil then
    return self.icon_sprite.transform.position
  elseif self.bg ~= nil then
    return self.bg.transform.position
  end
  return ResetPosition
end

function BuildBubbleTip:GetBubbleObj(isIgnore)
  if isIgnore then
    return self.obj
  end
  if self.bg ~= nil then
    return self.bg
  elseif self.icon_sprite ~= nil then
    return self.icon_sprite
  end
  return self.icon_go
end

function BuildBubbleTip:ShowFullEffect()
  if self.fullEffect == nil then
    self.fullEffect = ResourceManager:InstantiateAsync(fullEffectPath)
    self.fullEffect:completed("+", function()
      if self.fullEffect.isError then
        return
      end
      self.fullEffect.gameObject:SetActive(true)
      local go_rt = self.fullEffect.gameObject.transform
      go_rt:SetParent(self.bg_color.gameObject.transform, false)
      go_rt:Set_localScale(1.5, 1.5, 1.5)
      go_rt:Set_localPosition(0, 0, 0)
    end)
  end
end

function BuildBubbleTip:ClearFullEffect()
  if self.fullEffect ~= nil then
    self.fullEffect:Destroy()
    self.fullEffect = nil
  end
end

function BuildBubbleTip:Show()
  if self.icon_go ~= nil then
    self.isHide = false
    if self.isShow == true then
      if self.param.buildBubbleType == BuildBubbleType.GetFoodProduct then
        self.icon_go:Play(AnimName.ResourceItem)
      elseif self.param.dontShake then
        self.icon_go:SampleAnimationAtTime(AnimName.Enter, 1)
        self.icon_go:Play(AnimName.Enter)
      else
        self.icon_go:Play(AnimName.Normal)
      end
    else
      self.icon_go:Play(AnimName.Enter)
      if self.param.buildBubbleType == BuildBubbleType.GetFoodProduct then
        self.icon_go:PlayQueued(AnimName.ResourceItem)
      elseif self.param.dontShake then
        self.icon_go:SampleAnimationAtTime(AnimName.Enter, 1)
        self.icon_go:Play(AnimName.Enter)
      else
        self.icon_go:PlayQueued(AnimName.Normal)
      end
      self.isShow = true
    end
  end
end

function BuildBubbleTip:Hide()
  if self.isShow == false then
    return
  end
  if self.delayAnim then
    self.delayAnim:Stop()
    self.delayAnim = nil
  end
  if self.icon_go ~= nil then
    self.icon_go:Play(AnimName.Hide)
  end
  self.isShow = false
end

function BuildBubbleTip:ToFree()
  if self.icon_go ~= nil then
    self.icon_go:Play(AnimName.Default)
  end
  self.oldParam = self.param
  self.animationAlreadyShow = false
  self:ClearAllEffectAndTimer()
end

function BuildBubbleTip:ClearFoodFactoryEffect()
  if self.foodShouquFx ~= nil then
    self.foodShouquFx:Destroy()
    self.foodShouquFx = nil
  end
end

function BuildBubbleTip:AddFoodFactoryEffect()
  if self.foodShouquFx == nil then
    self.foodShouquFx = ResourceManager:InstantiateAsync(UIAssets.FoodShouqu)
    self.foodShouquFx:completed("+", function()
      if self.foodShouquFx.isError then
        return
      end
      local go = self.foodShouquFx.gameObject
      if go ~= nil then
        go:SetActive(true)
        local trans = go.transform
        trans:SetParent(self.bg_color.gameObject.transform, false)
        trans:Set_localScale(0.02, 0.02, 0.02)
        trans:Set_localPosition(0, 0, 0)
      end
    end)
  end
end

function BuildBubbleTip:AddFixBugTimer()
  if self.fixBugTimer == nil then
    self.fixBugTimer = TimerManager:GetInstance():GetTimer(FixNormalAnimTime, self.fix_bug_timer_action, self, true, false, false)
  end
  self.fixBugTimer:Start()
end

function BuildBubbleTip:DeleteFixBugTimer()
  if self.fixBugTimer ~= nil then
    self.fixBugTimer:Stop()
    self.fixBugTimer = nil
  end
end

function BuildBubbleTip:FixBugTimeCallBack()
  self:DeleteFixBugTimer()
  self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
  if self.icon_go ~= nil then
    if self.param.model ~= UIAssets.AllianceBubble then
      if self.animationAlreadyShow == false and not self.param.dontShake then
        self.animationAlreadyShow = true
        self.icon_go:Play(AnimName.Enter)
        if self.param.buildBubbleType == BuildBubbleType.GetFoodProduct then
          self.icon_go:PlayQueued(AnimName.ResourceItem)
        else
          self.icon_go:PlayQueued(AnimName.Normal)
        end
      elseif self.param.dontShake then
        self.icon_go:Play(AnimName.Enter)
        if self.animationAlreadyShow then
          self.icon_go:Stop()
        end
        self.animationAlreadyShow = false
      end
    elseif self.animationAlreadyShow == false and not self.param.dontShake then
      self.animationAlreadyShow = true
      self.icon_go.transform.parent.gameObject:SetActive(false)
      if self.delayAnim then
        self.delayAnim:Stop()
        self.delayAnim = nil
      end
      self.delayAnim = TimerManager:GetInstance():DelayInvoke(function()
        self.icon_go.transform.parent.gameObject:SetActive(true)
        self.icon_go:Play(AnimName.Enter)
        if self.param.buildBubbleType == BuildBubbleType.GetFoodProduct then
          self.icon_go:PlayQueued(AnimName.ResourceItem)
        else
          self.icon_go:PlayQueued(AnimName.Normal)
        end
        self.delayAnim = nil
      end, 0.618)
    elseif self.param.dontShake then
      self.icon_go.transform.parent.gameObject:SetActive(false)
      if self.delayAnim then
        self.delayAnim:Stop()
        self.delayAnim = nil
      end
      self.delayAnim = TimerManager:GetInstance():DelayInvoke(function()
        self.icon_go.transform.parent.gameObject:SetActive(true)
        self.icon_go:Play(AnimName.Enter)
        if self.animationAlreadyShow then
          self.icon_go:Stop()
        end
        self.delayAnim = nil
      end, 0.618)
      self.animationAlreadyShow = false
    end
  end
end

function BuildBubbleTip:AddClickCdTimer()
  if self.cdTimer == nil then
    self.cdTimer = TimerManager:GetInstance():GetTimer(ClickDuringTime, self.click_cd_timer_callback, self, true, false, false)
  end
  self.cdTimer:Start()
end

function BuildBubbleTip:DeleteClickCdTimer()
  if self.cdTimer ~= nil then
    self.cdTimer:Stop()
    self.cdTimer = nil
  end
end

function BuildBubbleTip:ClickCdTimerCallBack()
  self:DeleteClickCdTimer()
end

function BuildBubbleTip:ClearAllEffectAndTimer()
  self:DeleteClickCdTimer()
  self:DeleteFixBugTimer()
  self:ClearFullEffect()
  self:ClearFoodFactoryEffect()
  if self.progressTimer then
    self.progressTimer:Stop()
    self.progressTimer = nil
  end
end

function BuildBubbleTip:RefreshDecorationPlaySoundState()
  if self.param == nil or self.param.buildId == nil then
    return
  end
  local remainTime = DataCenter.DecorationBGMManager:GetMusicLeftTimeByBuildId(self.param.buildId)
  if remainTime <= 0 then
    DataCenter.BuildBubbleManager:RefreshBubbleShow(BuildBubbleType.DecorationPlaySound)
  elseif self.time_text ~= nil then
    local countDownTimeStr = math.floor(remainTime)
    self.time_text.text = CS.GameEntry.Localization:GetString("decoration_skill_desc6", countDownTimeStr)
  end
end

function BuildBubbleTip:AddTimer()
  self:DeleteTimer()
  self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false, false, false)
  self.timer:Start()
end

function BuildBubbleTip:TimerAction()
  if self.param ~= nil and self.param.buildBubbleType == BuildBubbleType.BuildSeasonLightHouse then
    local powerNow, powerMax, powerSpeed = DataCenter.SeasonPowerWorkerManager:GetBatteryPowerResourceInfo()
    if self.lastPower == powerNow then
      return
    end
    local delta = powerNow - toInt(self.lastPower)
    if delta == 0 then
      return
    end
    self.lastPower = powerNow
    if self.theFlyItem == nil then
      self.theFlyItem = self.transform:Find("Go/Tips").gameObject
      self.theFlyItem:GameObjectCreatePool()
    end
    if self.theFlyItem ~= nil then
      if self.anim_tween ~= nil then
        self.anim_tween:Kill()
        self.anim_tween = nil
      end
      local goItem = self.theFlyItem:GameObjectSpawn(self.transform)
      goItem:SetActive(true)
      goItem.transform:Set_localPosition(0, 3, 0)
      goItem.transform:Set_localScale(2, 2, 2)
      local theTextMesh = goItem.transform:Find("deltaCount"):GetComponent(typeof(CS.SuperTextMesh))
      local sequence = DOTween.Sequence()
      self.anim_tween = sequence
      if 0 < delta then
        theTextMesh.text = string.format("+%s", delta)
        theTextMesh.color32 = UIUtil.HexToColor32("00FF08")
      else
        theTextMesh.text = string.format("%s", delta)
        theTextMesh.color32 = UIUtil.HexToColor32("FF0003")
      end
      sequence:Append(goItem.transform:DOLocalMove(Vector3.New(0, 5.5, 0), 0.7))
      sequence:AppendInterval(0.1)
      sequence:AppendCallback(function()
        self.anim_tween = nil
        goItem:GameObjectRecycle()
      end)
    end
  end
end

function BuildBubbleTip:DeleteTimer()
  if self.theFlyItem ~= nil then
    self.theFlyItem:GameObjectRecycleAll()
  end
  if self.anim_tween ~= nil then
    self.anim_tween:Kill()
    self.anim_tween = nil
  end
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function BuildBubbleTip:HideWithoutShowAndReturnResult()
  if self.isHide then
    return true
  end
  if self.icon_go ~= nil then
    self.icon_go:Play(AnimName.Hide)
    self.isHide = true
    return true
  end
  self.isShow = false
  return false
end

return BuildBubbleTip
