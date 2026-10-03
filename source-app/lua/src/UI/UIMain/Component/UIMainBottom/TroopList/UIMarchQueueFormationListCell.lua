local UIMarchQueueFormationListCell = BaseClass("UIMarchQueueFormationListCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local focus_img_path = "Mask/Root/unLockObj/selectImg"
local unlock_obj_path = "Mask/Root/unLockObj"
local btn_path = "Mask/Root"
local empty_obj_path = "Mask/Root/lockObj/emptyObj"
local empty_add_text_path = "Mask/Root/lockObj/emptyObj/AddText"
local non_empty_obj_path = "Mask/Root/unLockObj/nonEmptyObj"
local non_empty_anim_path = "Mask/Root/unLockObj/nonEmptyObj"
local name_txt_path = "Mask/Root/nameNum"
local num_txt_path = "Mask/Root/unLockObj/nonEmptyObj/TimeProgressContent/TimeText"
local lock_obj_path = "Mask/Root/lockObj"
local march_obj_path = "Mask/Root/unLockObj/nonEmptyObj/marchObj"
local state_icon_path = "Mask/Root/unLockObj/nonEmptyObj/marchObj/stateIcon"
local attack_effect_path = "Mask/Root/unLockObj/nonEmptyObj/marchObj/stateIcon/MarchAttackStateIcon"
local blood_slider_path = "Mask/Root/unLockObj/nonEmptyObj/marchObj/mask/bloodSlider"
local blood_img_path = "Mask/Root/unLockObj/nonEmptyObj/marchObj/mask/bloodSlider/FillArea/Fill"
local level_path = "Mask/Root/unLockObj/Level"
local img_bg_path = "Mask/Root/ImageBg"
local img_path = "Mask/Root/unLockObj/nonEmptyObj/marchObj/mask/che"
local quality_img_path = "Mask/Root/unLockObj/nonEmptyObj/marchObj/mask/QualityBgIcon"
local lock_month_path = "Mask/Root/lockObj/lockMonth"
local march_state_text_path = "Mask/Root/unLockObj/nonEmptyObj/Rect/ViewPort/NameText"
local assistance_text_path = "Mask/Root/unLockObj/nonEmptyObj/Rect/ViewPort/AssistanceText"
local time_slider_path = "Mask/Root/unLockObj/nonEmptyObj/TimeProgressContent/Slider"
local march_btn_path = "Mask/Root/unLockObj/nonEmptyObj/Btn"
local march_btn_img_path = "Mask/Root/unLockObj/nonEmptyObj/Btn/Img"
local died_mask_img_path = "Mask/Root/unLockObj/nonEmptyObj/marchObj/mask/DieMask"
local multi_kill_path = "multiKillRoot"
local MultiKillEff = require("UI.UIMain.Component.UIMainBottom.TroopList.MultiKillEff")
local meteorite_root_path = "meteoriteRoot"
local MeteoriteNode = require("UI.UIMain.Component.UIMainBottom.TroopList.UIMarchQueueFormationListCellMeteoriteNode")
local img_red_path = "Mask/Root/ImageBg/imgRed"
local img_light_path = "Mask/Root/imgLight"
local root_path = "Mask/Root"
local second_btn_path = "Mask/Root/unLockObj/secondBtnBg/secondBtn"
local second_btn_img_path = "Mask/Root/unLockObj/secondBtnBg/secondBtn/secondBtnImg"
local WAIT_RALLY = MarchStatus.WAIT_RALLY
local COLLECTING = MarchStatus.COLLECTING
local IN_TEAM = MarchStatus.IN_TEAM
local ASSISTANCE = MarchStatus.ASSISTANCE
local QUEST_ENTRY_WIDTH_LIMIT = 144
local QUEST_ENTRY_ROLLING_SPD = 60
local QUEST_ENTRY_ROLLING_DELAY = 2
local QUEST_ENTRY_ROLLING_HOLD = 2
local DRAG_LENGTH_THRESHOLD = 5
local SECOND_BTN_WIDTH = 62
local DRAG_MOVE_TIME = 0.2
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self.focus_img = self:AddComponent(UIImage, focus_img_path)
  self.img_bg = self:AddComponent(UIImage, img_bg_path)
  self.quality_img = self:AddComponent(UIImage, quality_img_path)
  self.onDrag = false
  self.march_btn = self:AddComponent(UIButton, march_btn_path)
  self.march_btn_img = self:AddComponent(UIImage, march_btn_img_path)
  self.died_mask_img = self:AddComponent(UIImage, died_mask_img_path)
  self.march_btn:SetOnClick(function()
    self:OnMarchBtnClick()
  end)
  self.empty_obj = self:AddComponent(UIBaseContainer, empty_obj_path)
  self.non_empty_obj = self:AddComponent(UICanvasGroup, non_empty_obj_path)
  self.non_empty_obj:SetAlpha(1)
  self.march_obj = self:AddComponent(UIBaseContainer, march_obj_path)
  self.unlock_obj = self:AddComponent(UIBaseContainer, unlock_obj_path)
  self.lock_obj = self:AddComponent(UIBaseContainer, lock_obj_path)
  self.lock_month = self:AddComponent(UIImage, lock_month_path)
  self.name_txt = self:AddComponent(UIText, name_txt_path)
  self.time_txt = self:AddComponent(UIText, num_txt_path)
  self.state_icon = self:AddComponent(UIImage, state_icon_path)
  self.img = self:AddComponent(UIImage, img_path)
  self.attack_effect = self:AddComponent(UIBaseContainer, attack_effect_path)
  self.blood_slider = self:AddComponent(UISlider, blood_slider_path)
  self.blood_img = self:AddComponent(UIImage, blood_img_path)
  self.march_state_text = self:AddComponent(UIText, march_state_text_path)
  self.assistance_text = self:AddComponent(UIText, assistance_text_path)
  self.assistance_text:SetActive(false)
  self.empty_add_text = self:AddComponent(UIText, empty_add_text_path)
  self.empty_add_text:SetText(Localization:GetString(458190))
  self.time_slider = self:AddComponent(UISlider, time_slider_path)
  self.model = {}
  self.level_text = self:AddComponent(UIText, level_path)
  self.isUpdate = false
  self.startTime = 0
  self.endTime = 0
  self.canClick = true
  self.multi_kill_root = self:AddComponent(UIBaseContainer, multi_kill_path)
  self.meteoriteRoot = self:AddComponent(UIBaseContainer, meteorite_root_path)
  self.img_light = self:TryAddComponent(UIImage, img_light_path)
  self.root_event_trigger = self:AddComponent(UIEventTrigger, root_path)
  self.root_event_trigger:OnBeginDrag(function(eventData)
    self.onDrag = true
    self:OnBeginDrag(eventData)
  end)
  self.root_event_trigger:OnEndDrag(function(eventData)
    self:OnEndDrag(eventData)
    self.onDrag = false
  end)
  self.root_event_trigger:OnPointerClick(function(eventData)
    if self.onDrag then
      return
    end
    self:OnAtkClick(true)
  end)
  self.second_btn = self:AddComponent(UIButton, second_btn_path)
  self.second_btn:SetOnClick(function()
    self:OnSecondBtnClick()
  end)
  self.second_btn_img = self:AddComponent(UIImage, second_btn_img_path)
  self.secondBtnFunctionOpenFlag = LuaEntry.DataConfig:CheckSwitch("slide_left_return")
  self:ClearDragAnim()
  local curY = self.root_event_trigger:GetAnchoredPositionY()
  self.root_event_trigger:SetAnchoredPositionXY(0, curY)
end

local function OnDestroy(self)
  if self.txtTweenSeq then
    self.txtTweenSeq:Kill()
    self.txtTweenSeq = nil
  end
  self.img_light = nil
  if self.multiKillEffReq then
    self.multiKillEff = nil
    self.multi_kill_root:RemoveComponents(MultiKillEff)
    self:GameObjectDestroy(self.multiKillEffReq)
    self.multiKillEffReq = nil
  end
  self:ClearMeteoriteNode(true)
  self:ClearMeteoriteUnderAttackAlarm()
  self.onDrag = nil
  self.isScoutMarch = nil
  self.secondBtnCanShow = nil
  self.secondBtnKey = nil
  self.secondBtnImgPath = nil
  self.secondBtnClickCb = nil
  self:DeleteDelayGuideTimer()
  self:ClearDragAnim()
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.state_icon = nil
  self.attack_effect = nil
  self.blood_slider = nil
  self.blood_img = nil
  self.lock_obj = nil
  self.unlock_obj = nil
  self.empty_obj = nil
  self.non_empty_obj = nil
  self.name_txt = nil
  self.time_txt = nil
  self.march_obj = nil
  self.level_text = nil
  self.focus_img = nil
  self.img_bg = nil
  self.march_btn = nil
  self.march_btn_img = nil
  self.died_mask_img = nil
  self.lock_month = nil
  self.img = nil
  self.march_state_text = nil
  self.assistance_text = nil
  self.empty_add_text = nil
  self.time_slider = nil
  self.second_btn = nil
  self.second_btn_img = nil
  self.secondBtnFunctionOpenFlag = nil
  base.OnDestroy(self)
end

local function RefreshCaptain(self, formation)
  local qualityBg = HeroUtils.GetFormationBgByQuality()
  if formation then
    local captain = formation:GetHighestQualityHero()
    if captain then
      qualityBg = HeroUtils.GetFormationBgByQuality(captain.quality)
      local iconPath = HeroUtils.GetHeroIconPath(captain.modelId, HeroIconType.small_icon, captain:GetSkinId())
      self.img:LoadSpriteAuto(iconPath)
      self.quality_img:LoadSpriteAuto(HeroUtils.GetQualityIconPath(captain.quality, false))
    end
  end
  self.img_bg:SetColorRGBA(0, 0, 0, 1)
end

local function RefreshData(self, show)
  self.isUpdate = false
  self.startTime = 0
  self.endTime = 0
  self.canClick = true
  self.time_txt:SetText("")
  if self.uuid ~= nil then
    self.unlock_obj:SetActive(true)
    self.lock_obj:SetActive(false)
    local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.uuid)
    if formation and formation.state == ArmyFormationState.Free then
      if self.view.ctrl.targetType == MarchTargetType.COLLECT then
        local collectPoint = CS.SceneManager.World:GetResourcePointInfoByIndex(self.view.ctrl.targetPoint)
        if collectPoint then
          local type = GetTableData(TableName.GatherResource, collectPoint.id, "resource_type")
          DataCenter.ArmyFormationDataManager:AutoInitFormationDataForCollect(self.uuid, tonumber(type))
        else
          DataCenter.ArmyFormationDataManager:AutoInitFormationData(self.uuid)
        end
      else
        DataCenter.ArmyFormationDataManager:AutoInitFormationData(self.uuid)
      end
    end
    self:RefreshCaptain(formation)
    self:RefreshMarch()
    self:RefreshSecondBtnData()
  elseif self.disguiseMarchUuid ~= nil then
    self.unlock_obj:SetActive(true)
    self.lock_obj:SetActive(false)
    local marchData = DataCenter.WorldMarchDataManager:GetMarch(self.disguiseMarchUuid)
    if marchData then
      local hero = marchData:GetLeaderHero()
      if hero and hero.heroQuality and 0 < hero.heroQuality then
        self.quality_img:LoadSprite(HeroUtils.GetQualityIconPath(hero.heroQuality, false))
      end
    end
    local skillTemplate = DataCenter.MasteryManager:GetUnlockedSkillTemplateByType(MasterySkill.CreateFakeMarch)
    if skillTemplate then
      self.img:LoadSpriteAuto(skillTemplate:GetIconFullPath())
    end
    self:RefreshMarch()
  else
    self.img_bg:SetColorRGBA(0, 0, 0, 1)
    if self.img_light then
      self.img_light:SetColorRGBA(0, 0, 0, 0)
    end
    self.unlock_obj:SetActive(false)
    self.lock_obj:SetActive(true)
    if self.lock_month ~= nil then
      self.lock_month:SetActive(false)
      local isOpen = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
      if not isOpen then
        self.empty_obj:SetActive(true)
      else
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR)
        if buildData and buildData.level == 0 then
          self.empty_obj:SetActive(true)
        end
      end
    end
  end
  if type(show) == "number" and show == self.index then
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
      local param = {}
      param.position = self.transform.position
      param.positionType = PositionType.Screen
      if param.position ~= nil then
        DataCenter.ArrowManager:ShowArrow(param)
      end
    end, 0.4)
  end
end

local function RefreshMarchData(self)
  local curServerId = LuaEntry.Player:GetCurServerId()
  local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(curServerId)
  if self.formationIndex ~= nil and isBigMapMode and loginSameGroup then
    return
  end
  self.isUpdate = false
  self.startTime = 0
  self.endTime = 0
  self.time_txt:SetText("")
  self.canClick = true
  if self.uuid ~= nil then
    local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.uuid)
    if formation and formation.state == ArmyFormationState.March then
      self:RefreshMarch()
      self:RefreshSecondBtnData()
    else
      self:RefreshData()
    end
  elseif self.disguiseMarchUuid then
    self:RefreshMarch()
  end
end

local function RefreshMarch(self)
  if self.disguiseMarchUuid then
    self.dataInfo = self.view.ctrl:GetDisguiseFormationItemData(self.disguiseMarchUuid)
  else
    self.dataInfo = self.view.ctrl:GetFormationItemData(self.uuid)
  end
  if self.dataInfo and toInt(self.dataInfo.ownerLightUuid) > 0 then
    self.img_bg:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_chuzheng_di.png")
    self.img_bg:SetColorRGBA(1, 1, 1, 1)
    if self.img_light then
      self.img_light:LoadSprite("Assets/Main/SeasonRes/S4/Sprites/UI/PowerHouseS4/ljq_saijis4_diandeng_dengpao_03.png")
      self.img_light:SetColorRGBA(1, 1, 1, 1)
    end
  else
    self.img_bg:SetColorRGBA(0, 0, 0, 1)
    if self.img_light then
      self.img_light:SetColorRGBA(0, 0, 0, 0)
    end
  end
  if table.IsNullOrEmpty(self.dataInfo) then
    return
  end
  local serverId = self.dataInfo.serverId
  if serverId == nil or serverId <= 0 then
    serverId = LuaEntry.Player:GetSelfServerId()
  end
  if self.view.ctrl.targetType ~= MarchTargetType.CROSS_SERVER_WORM then
    if serverId ~= LuaEntry.Player:GetCurServerId() and 0 < self.dataInfo.isMarch then
      self.canClick = false
    end
  elseif serverId ~= LuaEntry.Player:GetSelfServerId() and 0 < self.dataInfo.isMarch then
    self.canClick = false
  end
  if not self.canClick then
    local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(serverId)
    if isBigMapMode and loginSameGroup then
      self.canClick = true
    end
  end
  UIGray.SetGray(self.img.transform, self.canClick == false, true)
  if 0 < self.dataInfo.isMarch then
    self.attack_effect:SetActive(self.dataInfo.isBattle)
    self:RefreshTextAndBtnImg()
    self.blood_slider:SetActive(true)
    self:RefreshSlider(self.dataInfo.marchUuid, self.dataInfo.hp, self.dataInfo.maxhp)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.dataInfo.endTime and not self.dataInfo.isAssistance then
      self.startTime = self.dataInfo.startTime
      self.endTime = self.dataInfo.endTime
      self.isUpdate = true
      self:UpdateTime()
    end
  else
    self.blood_slider:SetActive(false)
  end
  if self.view.ctrl.selectFormationUuid == self.uuid then
    self:OnAtkClick()
  end
end

local function RefreshTextAndBtnImg(self)
  if self.dataInfo == nil then
    return
  end
  self.march_state_text:SetText(self.dataInfo.stateTxt)
  self.died_mask_img:SetActive(false)
  local player = LuaEntry.Player
  if self.dataInfo.btnImg ~= nil then
    self.march_btn_img:SetActive(true)
    self.march_btn_img:LoadSprite(self.dataInfo.btnImg)
    local showMarchBtnEff = false
    if BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
      local battleInfo = DataCenter.ActEpidemicZoneManager:GetBattleInfo()
      local cur = battleInfo.speedCount or 0
      local marchInfo = self:GetMarchInfo()
      if 0 < cur and marchInfo then
        local marchStatus = marchInfo:GetMarchStatus()
        if marchInfo:GetMarchTargetType() == MarchTargetType.BACK_HOME or marchStatus == MarchStatus.MOVING or marchStatus == MarchStatus.CHASING then
          showMarchBtnEff = true
        end
      end
    end
    if self.march_btn_eff then
      self.march_btn_eff:SetActive(showMarchBtnEff)
    elseif showMarchBtnEff then
      self.march_btn_eff = self:LoadComponentAsync(UIAsyncContainer, UIAssets.UIMainFormationSelectListCellFreeSpeed, self.march_btn_img)
    end
  else
    self.march_btn_img:SetActive(false)
  end
  local march
  if self.dataInfo.marchUuid then
    march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(player.uid, self.dataInfo.uuid, player.allianceId)
    self.died_mask_img:SetActive(march:GetIsBroken() == true)
  end
  self.time_slider:SetActive(not self.dataInfo.isAssistance)
  self.assistance_text:SetActive(self.dataInfo.isAssistance)
  if self.assistance_text:GetActive() then
    local tmpStr = player:GetFullName()
    local targetUuid = self.dataInfo.targetUuid
    if targetUuid ~= nil and 0 < targetUuid then
      local info = self.dataInfo.pointInfo
      if info == nil then
        local world = CS.SceneManager.World
        info = world and world:GetPointInfoByUuid(targetUuid) or nil
      end
      if info ~= nil then
        if info.PointType == WorldPointType.PlayerBuilding then
          cast(info, typeof(CS.BuildPointInfo))
          tmpStr = UIUtil.FormatAllianceAndName(info.alAbbr, info.playerName)
        else
          local worldType = self.dataInfo.worldType
          if worldType and 0 < worldType and info.detail ~= nil then
            local config = BattleFieldUtil.GetBuildTemplate(info.detail.BuildId, worldType)
            if config ~= nil then
              tmpStr = Localization:GetString(config.name)
            end
          else
            local nameStr = WorldBuildUtil.GetBuildName(info)
            if not string.IsNullOrEmpty(nameStr) then
              tmpStr = nameStr
            end
          end
        end
      end
    end
    self.assistance_text:SetText(tmpStr)
    local rawWidth = self.assistance_text:GetWidth()
    if rawWidth > QUEST_ENTRY_WIDTH_LIMIT then
      if self.txtTweenSeq then
        self.txtTweenSeq:Kill()
      end
      self.txtTweenSeq = UIUtil.SetTMPHorseRaceLamp(self.assistance_text, QUEST_ENTRY_WIDTH_LIMIT, QUEST_ENTRY_ROLLING_DELAY, QUEST_ENTRY_ROLLING_SPD, QUEST_ENTRY_ROLLING_HOLD, self.assistance_text.transform)
    end
  end
  if not DataCenter.ActMeteoriteBattleManager:IsInMeteoriteBattle() then
    self:ClearMeteoriteNode(true)
  else
    self:RefreshMeteoriteInfo(march)
  end
  self:RefreshMeteoriteUnderAttackAlarm()
end

function UIMarchQueueFormationListCell:RefreshMeteoriteInfo(march)
  if not self.dataInfo then
    self:ClearMeteoriteNode(true)
    return
  end
  march = march or DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, self.dataInfo.uuid, LuaEntry.Player.allianceId)
  if not march then
    self:ClearMeteoriteNode(true)
    return
  end
  local crystal = march.crystal or 0
  local nucleus = march.nucleus or 0
  if crystal <= 0 and nucleus <= 0 then
    self:ClearMeteoriteNode(false)
    return
  end
  if self.delayDestroy and 0 < self.delayDestroy then
    self:ClearMeteoriteNode(false)
    return
  end
  if self.meteoriteNodeReq == nil then
    self.meteoriteNodeReq = self:GameObjectInstantiateAsync(UIAssets.UIMainFormationSelectCellMeteoriteNode, function(request)
      local go = request.gameObject
      if IsNull(go) then
        return
      end
      go.name = "meteoriteInfo"
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.meteoriteRoot.transform)
      go.transform:Set_localPosition(0, 0, 0)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.meteoriteNode = self.meteoriteRoot:AddComponent(MeteoriteNode, go)
      self:RefreshMeteoriteInfo()
    end)
    return
  end
  if self.meteoriteNode then
    self.meteoriteNode:SetActive(true)
    self.meteoriteNode:SetCount(crystal, nucleus)
  end
end

function UIMarchQueueFormationListCell:ClearMeteoriteNode(destroy)
  if destroy then
    if self.meteoriteNodeReq then
      self.meteoriteNode = nil
      self.meteoriteRoot:RemoveComponents(MeteoriteNode)
      self:GameObjectDestroy(self.meteoriteNodeReq)
      self.meteoriteNodeReq = nil
    end
  elseif self.meteoriteNode then
    self.meteoriteNode:SetActive(false)
  end
end

function UIMarchQueueFormationListCell:RefreshMeteoriteUnderAttackAlarm()
  local showRed = false
  if not DataCenter.ActMeteoriteBattleManager:IsInMeteoriteBattle() then
    showRed = false
  elseif not self.dataInfo then
    showRed = false
  else
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, self.dataInfo.uuid, LuaEntry.Player.allianceId)
    if march and march:GetMarchTargetType() == MarchTargetType.COLLECT_METEORITE and DataCenter.WorldMarchDataProxy:CheckUuidIsMarchTarget(march.uuid, march.targetPos) then
      showRed = true
    end
  end
  if showRed then
    if not self.imgRed then
      local tran = self.transform:Find(img_red_path)
      if tran then
        self.imgRed = tran:GetComponent(typeof(CS.UnityEngine.UI.Image))
      end
    end
    if self.imgRed then
      if not self.redAlarmSeq then
        self.redAlarmSeq = TweenUtil.PlayImageFadeLoop(self.imgRed, 0, 1, 1, 0.5)
      end
      self.imgRed.gameObject:TryActive(true)
    end
  else
    self:ClearMeteoriteUnderAttackAlarm()
  end
end

function UIMarchQueueFormationListCell:ClearMeteoriteUnderAttackAlarm()
  if self.redAlarmSeq then
    self.redAlarmSeq:Kill()
    self.redAlarmSeq = nil
  end
  if self.imgRed then
    self.imgRed.gameObject:TryActive(false)
  end
end

local function SetUuidAndIndex(self, index, uuid)
  self.index = index
  self.name_txt:SetText(self.index)
  self.uuid = uuid
end

function UIMarchQueueFormationListCell:SetDisguiseMarchUuidAndIndex(marchUuid, index)
  self.index = index
  self.name_txt:SetText(self.index)
  self.disguiseMarchUuid = marchUuid
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function RefreshSlider(self, uuid, hp, maxhp)
  if uuid ~= nil and self.dataInfo ~= nil and self.dataInfo.marchUuid ~= nil and uuid == self.dataInfo.marchUuid then
    local percent = hp / math.max(maxhp, 1)
    if 1 < percent then
      percent = 1
    end
    if percent <= 1 and 0.7 < percent then
      self.blood_img:SetColor(Color.New(0.30196078431372547, 0.8666666666666667, 0.2980392156862745))
    elseif percent <= 0.7 and 0.4 < percent then
      self.blood_img:SetColor(Color.New(0.996078431372549, 0.7450980392156863, 0.0392156862745098))
    elseif percent <= 0.4 and 0.01 < percent then
      self.blood_img:SetColor(Color.New(0.9725490196078431, 0.28627450980392155, 0.29411764705882354))
    else
      self.blood_img:SetColor(Color.New(1, 1, 1, 0))
    end
    self.blood_slider:SetValue(percent)
  end
end

local function OnAtkClick(self, isInClick)
  if self.onDrag == true and isInClick == true then
    return
  end
  if isInClick == true and self.canClick == false then
    local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, self.uuid, LuaEntry.Player.allianceId)
    if march ~= nil then
      if march:GetMarchStatus() == MarchStatus.IN_WORM_HOLE or march:GetMarchStatus() == MarchStatus.CROSS_SERVER then
        UIUtil.ShowTipsId(142514)
        return
      elseif self.view.ctrl.targetType == MarchTargetType.CROSS_SERVER_WORM then
        UIUtil.ShowTips(Localization:GetString("121422", self.view.ctrl.targetServerId))
        return
      end
    end
    if self.view.ctrl.targetType >= 0 then
      UIUtil.ShowTipsId(GameDialogDefine.MARCH_IN_OTHER_SERVER)
      return
    end
  end
  if self.view.ctrl.targetType >= 0 then
    Logger.LogError("\232\175\183\230\163\128\230\159\165targetType\232\181\139\229\128\188\239\188\140self.view.ctrl.targetType==" .. self.view.ctrl.targetType)
  elseif self.canClick == false then
    if isInClick ~= nil and isInClick == true then
      if self.disguiseMarchUuid then
        self.dataInfo = self.view.ctrl:GetDisguiseFormationItemData(self.disguiseMarchUuid)
      else
        self.dataInfo = self.view.ctrl:GetFormationItemData(self.uuid)
      end
      local serverId = self.dataInfo.serverId
      local worldId = self.dataInfo.worldId
      local worldType = self.dataInfo.worldType
      if serverId == nil or serverId <= 0 then
        serverId = LuaEntry.Player:GetSelfServerId()
      end
      local str = Localization:GetString("110216", serverId)
      if worldId ~= nil and 0 < worldId then
        if worldType == BattleFieldType.Desert then
          str = Localization:GetString("458227", serverId)
        elseif worldType == BattleFieldType.WinterStorm then
          str = Localization:GetString("winter_battlefield_tips1006")
        elseif worldType == BattleFieldType.EpidemicZone then
          str = Localization:GetString("458227", serverId)
        end
      end
      UIUtil.ShowMessage(str, 2, "", "", function()
        self:OnJumpToFormationPos(isInClick)
      end)
    end
  else
    self:OnJumpToFormationPos(isInClick)
  end
  if self.disguiseMarchUuid == nil and self.uuid == nil and self.formationIndex == nil then
    local isOpen = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
    if not isOpen then
      UIManager:GetInstance():OpenWindow(UIWindowNames.LWBuyDiamond, {anim = true}, WelfareTagType.MonthCard)
      return
    else
      local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR)
      if buildData and buildData.level == 0 then
        GoToUtil.GotoCityByBuildId(BuildingTypes.LW_BUILD_PARKINGLOT_FOUR, WorldTileBtnType.GolloesCamp)
        return
      end
    end
  end
end

local function DoMarchBtnClick(self, marchInfo, inSameServer)
  local currentStatus = marchInfo:GetMarchStatus()
  if marchInfo.target == MarchTargetType.BACK_HOME or currentStatus == MarchStatus.MOVING or currentStatus == MarchStatus.CHASING then
    local curServerId = LuaEntry.Player:GetCurServerId()
    local kingCityId, kingCityPosIndex = SeasonUtil.GetKingCityId(curServerId)
    if marchInfo.targetPos == kingCityPosIndex and currentStatus == MarchStatus.MOVING then
      UIUtil.ShowMessage(Localization:GetString("457092"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      end)
      return
    end
    if curServerId == DataCenter.LandlordMgr:GetCenterServerId() and DataCenter.LandlordMgr:GetActCurStage() == LLConst.LandlordStage.BATTLE and currentStatus == MarchStatus.MOVING then
      UIUtil.ShowMessage(Localization:GetString("457092"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      end)
      return
    end
    if currentStatus == MarchStatus.MOVING and LuaEntry.Player:IsInBlackRange() then
      UIUtil.ShowMessage(Localization:GetString("457092"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      end)
      return
    end
    if inSameServer and self.view ~= nil then
      self.view.ctrl:SetSelectFormationUuid(self.uuid)
      self.view:OnSelectClick(self.uuid)
    end
    GoToUtil.GotoMarchCurPos(marchInfo, nil, function()
      CS.SceneManager.World:TrackMarch(marchInfo.uuid)
      WorldMarchTileUIManager:GetInstance():ShowTroop(marchInfo.uuid)
      if inSameServer and self.view ~= nil then
        self.view:HideAllShowTip()
      end
      WorldMarchTileUIManager:GetInstance():OnBtnClick(WorldMarchTileBtnType.March_Rapid, marchInfo.uuid)
    end)
  elseif currentStatus == COLLECTING or currentStatus == ASSISTANCE then
    WorldMarchTileUIManager:GetInstance():OnBtnClick(WorldMarchTileBtnType.March_Callback, marchInfo.uuid)
  elseif currentStatus == WAIT_RALLY or currentStatus == IN_TEAM then
    DataCenter.AllianceWarDataManager:OpenALWarMain(true, AllianceWarTabType.Rally, marchInfo.teamUuid)
  elseif currentStatus == MarchStatus.CROSS_SERVER then
    WorldMarchTileUIManager:GetInstance():OnBtnClick(WorldMarchTileBtnType.March_Callback, marchInfo.uuid)
  end
end

local function GetMarchInfo(self)
  local marchInfo
  if self.uuid ~= nil then
    marchInfo = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, self.uuid, LuaEntry.Player.allianceId)
  elseif self.disguiseMarchUuid then
    marchInfo = DataCenter.WorldMarchDataManager:GetMarch(self.disguiseMarchUuid)
  end
  return marchInfo
end

local function OnMarchBtnClick(self)
  local marchInfo = self:GetMarchInfo()
  if marchInfo == nil then
    return
  end
  local serverId = marchInfo.serverId
  local worldId = marchInfo.worldId
  local worldIdNow = LuaEntry.Player:GetCurWorldId()
  local worldType = marchInfo:GetWorldType()
  if serverId == nil or serverId <= 0 then
    serverId = LuaEntry.Player:GetSelfServerId()
  end
  if 0 < worldIdNow and worldIdNow == worldId or worldIdNow <= 0 and (worldId == nil or worldId <= 0) then
    DoMarchBtnClick(self, marchInfo, true)
  else
    local pThis = self
    local str = Localization:GetString("110216", serverId)
    if worldId ~= nil and 0 < worldId then
      if worldType == BattleFieldType.Desert then
        str = Localization:GetString("458227", serverId)
      elseif worldType == BattleFieldType.WinterStorm then
        str = Localization:GetString("winter_battlefield_tips1006")
      elseif worldType == BattleFieldType.EpidemicZone then
        str = Localization:GetString("458227", serverId)
      end
    end
    UIUtil.ShowMessage(str, 2, "", "", function()
      GoToUtil.GotoMarchCurPos(marchInfo, nil, function()
        DoMarchBtnClick(pThis, marchInfo, false)
      end)
    end)
  end
end

local function OnJumpToFormationPos(self, isInClick)
  if not SceneUtils.GetIsInWorld() then
    return
  end
  local world = CS.SceneManager.World
  if not world then
    return
  end
  local curZoom = CS.SceneManager.World.Zoom or CS.SceneManager.World.InitZoom
  if curZoom <= 0 then
    return
  end
  local GotoWorldPos = GoToUtil.GotoWorldPos
  if self.uuid ~= nil then
    local marchInfo = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, self.uuid, LuaEntry.Player.allianceId)
    if marchInfo ~= nil then
      do
        local serverId = marchInfo.targetServer
        local worldId = marchInfo.worldId
        if 0 < worldId then
          GotoWorldPos = GoToUtil.GotoDragonPos
        end
        local theMarchStatus = marchInfo:GetMarchStatus()
        local worldPos = SceneUtils.TileIndexToWorld(marchInfo.targetPos, ForceChangeScene.World, serverId)
        if theMarchStatus == MarchStatus.IN_WORM_HOLE or theMarchStatus == MarchStatus.CROSS_SERVER then
          self.view.ctrl:SetSelectFormationUuid(self.uuid)
          self.view:OnSelectClick(self.uuid)
          self.view:HideAllShowTip()
          GoToUtil.GotoMarchCurPos(marchInfo, curZoom, function()
            if isInClick ~= nil and isInClick == true then
              CS.SceneManager.World:TrackMarch(marchInfo.uuid)
            end
            WorldMarchTileUIManager:GetInstance():ShowTroop(marchInfo.uuid)
          end)
        elseif marchInfo:GetMarchType() == NewMarchType.EXPLORE then
          local troop = CS.SceneManager.World:GetTroop(marchInfo.uuid)
          self.view:HideAllShowTip()
          if troop ~= nil then
            GotoWorldPos(troop:GetPosition(), curZoom, nil, nil, serverId, worldId, marchInfo:GetWorldType())
          else
            GoToUtil.GotoMarchCurPos(marchInfo, curZoom)
          end
        elseif theMarchStatus == COLLECTING then
          self.view:HideAllShowTip()
          GotoWorldPos(worldPos, curZoom, nil, nil, serverId, worldId, marchInfo:GetWorldType())
          WorldArrowManager:GetInstance():ShowArrowEffect(0, worldPos, ArrowType.Building)
        elseif theMarchStatus == ASSISTANCE then
          self.view:HideAllShowTip()
          GotoWorldPos(worldPos, curZoom, nil, nil, serverId, worldId, marchInfo:GetWorldType())
          local position = worldPos
          WorldArrowManager:GetInstance():ShowArrowEffect(0, position, ArrowType.Building)
        elseif theMarchStatus == WAIT_RALLY then
          self.view:HideAllShowTip()
          local useSId = marchInfo.srcServer
          if 0 < worldId then
            useSId = marchInfo.serverId
          end
          local position = SceneUtils.TileIndexToWorld(marchInfo.startPos, ForceChangeScene.World, useSId)
          GotoWorldPos(position, curZoom, nil, nil, useSId, worldId, marchInfo:GetWorldType())
          WorldArrowManager:GetInstance():ShowArrowEffect(0, position, ArrowType.Building)
        elseif theMarchStatus == IN_TEAM then
          self.view:HideAllShowTip()
          local teamMarch = DataCenter.WorldMarchDataManager:GetAllianceMarchesInTeam(LuaEntry.Player.allianceId, marchInfo.teamUuid)
          if teamMarch ~= nil and isInClick ~= nil and isInClick == true then
            if teamMarch:GetMarchStatus() == WAIT_RALLY then
              local useSId = teamMarch.srcServer
              if 0 < worldId then
                useSId = teamMarch.serverId
              end
              local position = SceneUtils.TileIndexToWorld(teamMarch.startPos, ForceChangeScene.World, useSId)
              GotoWorldPos(position, curZoom, nil, nil, useSId, worldId, marchInfo:GetWorldType())
              WorldArrowManager:GetInstance():ShowArrowEffect(0, position, ArrowType.Building)
            else
              self.view.ctrl:SetSelectFormationUuid(self.uuid)
              self.view:OnSelectClick(self.uuid)
              if serverId ~= LuaEntry.Player:GetCurServerId() then
                GoToUtil.GotoMarchCurPos(marchInfo, curZoom, function()
                  CS.SceneManager.World:TrackMarch(teamMarch.uuid)
                  WorldMarchTileUIManager:GetInstance():ShowTroop(teamMarch.uuid)
                end)
              else
                CS.SceneManager.World:TrackMarch(teamMarch.uuid)
                WorldMarchTileUIManager:GetInstance():ShowTroop(teamMarch.uuid)
              end
            end
          end
        else
          local troop = CS.SceneManager.World:GetTroop(marchInfo.uuid)
          if troop ~= nil then
            self.view.ctrl:SetSelectFormationUuid(self.uuid)
            self.view:OnSelectClick(self.uuid)
          end
          self.view:HideAllShowTip()
          GoToUtil.GotoMarchCurPos(marchInfo, curZoom, function()
            if isInClick ~= nil and isInClick == true then
              CS.SceneManager.World:TrackMarch(marchInfo.uuid)
            end
            WorldMarchTileUIManager:GetInstance():ShowTroop(marchInfo.uuid)
          end)
        end
      end
    end
  elseif self.disguiseMarchUuid then
    local marchInfo = DataCenter.WorldMarchDataManager:GetMarch(self.disguiseMarchUuid)
    if marchInfo then
      CS.SceneManager.World.marchUuid = self.disguiseMarchUuid
      self.view:HideAllShowTip()
      GoToUtil.GotoMarchCurPos(marchInfo, curZoom, function()
        if isInClick ~= nil and isInClick == true then
          CS.SceneManager.World:TrackMarch(marchInfo.uuid)
        end
        WorldMarchTileUIManager:GetInstance():ShowTroop(marchInfo.uuid)
      end)
    end
  elseif self.formationIndex then
    self.view:HideAllShowTip()
    local formationInfo = self.view.ctrl:GetInvesFormationInfoByIndex(self.formationIndex)
    GoToUtil.GotoMarchCurPos(formationInfo.MarchInfo, curZoom, function()
      if isInClick ~= nil and isInClick == true then
        CS.SceneManager.World:TrackMarch(formationInfo.MarchInfo.uuid)
      end
      WorldMarchTileUIManager:GetInstance():ShowTroop(formationInfo.MarchInfo.uuid)
    end)
  end
end

local function OnSelectClick(self, uuid)
  if self.uuid ~= nil and self.uuid == uuid then
    if self.dataInfo ~= nil and self.view.ctrl.targetType >= 0 then
      if self.dataInfo.marchUuid ~= nil then
        CS.SceneManager.World.marchUuid = self.dataInfo.marchUuid
      end
    elseif self.dataInfo ~= nil and self.dataInfo.marchUuid ~= nil then
      CS.SceneManager.World.marchUuid = self.dataInfo.marchUuid
    end
  elseif self.dataInfo ~= nil then
  end
end

local function ShowTroopActionArrow(self)
  if self.dataInfo == nil then
    return false
  end
  if self.dataInfo.isMarch > 0 or self.dataInfo.useForm == true then
    return false
  end
  local param = {
    arrowType = ArrowType.Normal,
    positionType = PositionType.Screen,
    position = Vector3.New(self.gameObject.transform.position.x, self.gameObject.transform.position.y, 0) + Vector3.New(0, 50, 0)
  }
  DataCenter.ArrowManager:ShowArrow(param)
  return true
end

local function UpdateTime(self)
  if self.isUpdate then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.endTime - curTime
    if 0 < deltaTime then
      local totalTime = self.endTime - self.startTime
      local deltaTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)
      self.time_slider:SetActive(true)
      self.time_slider:SetValue(1 - deltaTime / totalTime)
      self.time_txt:SetText(deltaTimeStr)
    else
      self.time_slider:SetActive(false)
      self.time_txt:SetText("")
      self.isUpdate = false
    end
    self.greenBarTime = 0
  elseif self.dataInfo and not self.dataInfo.isAssistance then
    if self.greenBarTime == nil then
      self.greenBarTime = 0
    end
    self.greenBarTime = self.greenBarTime + 1
    if self.greenBarTime > 5 then
      self.greenBarTime = 0
      DataCenter.WorldMarchDataManager:WorldGetMarchInfos()
      return
    end
  end
end

local function RefreshScoutUI(self, formationIndex)
  self.formationIndex = formationIndex
  self.isScoutMarch = true
  local unlockCount = DataCenter.ArmyFormationDataManager:GetMaxInvesFormationCount()
  local formationInfo = self.view.ctrl:GetInvesFormationInfoByIndex(formationIndex)
  if formationIndex > unlockCount then
    self.unlock_obj:SetActive(false)
    self.lock_obj:SetActive(true)
  else
    self.unlock_obj:SetActive(true)
    self.lock_obj:SetActive(false)
    self:SetScoutState(formationInfo.MarchInfo)
  end
  self:RefreshSecondBtnData()
end

local function SetScoutState(self, march)
  local states = march and march:GetMarchStatus() or MarchStatus.STATION
  self.march_btn:SetActive(false)
  self.march_state_text:SetText(MarchUtil.GetMarchStateTextByType(march))
  self.quality_img:LoadSprite(HeroUtils.GetQualityIconPath(1, false))
  if states == MarchStatus.STATION then
    self.img:LoadSpriteAuto("Assets/Main/Sprites/HeroIconsBig/spy_mach_icon.png")
    self.time_txt:SetText("")
    self.time_slider:SetActive(false)
  else
    local theType = march and march:GetMarchTargetType() or MarchTargetType.SCOUT_TROOP
    if theType == MarchTargetType.BACK_HOME and march.startPos then
      local info = CS.SceneManager.World:GetPointInfo(march.startPos)
      if info ~= nil and info.PointType == WorldPointType.CITY_ATTACHMENT_BUILD then
        theType = MarchTargetType.SEASON_FARMER_SEND_RES
      end
    end
    if theType == MarchTargetType.SEASON_FARMER_SEND_RES then
      self.img:LoadSpriteAuto(string.format(LoadPath.UISeasonPath, "zyf_lianmengjianshezhe_rukou_icon"))
    elseif theType == MarchTargetType.GREEN then
      self.img:LoadSpriteAuto(string.format(LoadPath.UISeason3CommonPath, "mjc_S3_zhencha_lvhua_icon"))
    else
      self.img:LoadSpriteAuto(string.format(LoadPath.CommonPath, "zyf_gongcheng_zhencha"))
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < march.endTime then
      self.startTime = march.startTime
      self.endTime = march.endTime
      self.isUpdate = true
      self:UpdateTime()
    end
  end
end

local function SetSelected(self, isSelected)
  if isSelected then
    local posX = self.transform.position.x
    local posY = self.transform.position.y
    self.view:ResetScoutSelectTipPosition(posX, posY)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.SingleMarchStateUpdate, self.OnSingleMarchStateUpdate)
  self:AddUIListener(EventId.ShowCrossServerTip, self.RefreshMarchData)
  self:AddUIListener(EventId.MyMarchMultiKillPVEAdd, self.OnMyMarchMultiKillPVEAdd)
  self:AddUIListener(EventId.MyMarchMultiKillPVPAdd, self.OnMyMarchMultiKillPVPAdd)
  self:AddUIListener(EventId.EpidemicBattleSpeedUpdate, self.RefreshTextAndBtnImg)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.SingleMarchStateUpdate, self.OnSingleMarchStateUpdate)
  self:RemoveUIListener(EventId.ShowCrossServerTip, self.RefreshMarchData)
  self:RemoveUIListener(EventId.MyMarchMultiKillPVEAdd, self.OnMyMarchMultiKillPVEAdd)
  self:RemoveUIListener(EventId.MyMarchMultiKillPVPAdd, self.OnMyMarchMultiKillPVPAdd)
  self:RemoveUIListener(EventId.EpidemicBattleSpeedUpdate, self.RefreshTextAndBtnImg)
end

function UIMarchQueueFormationListCell:OnMyMarchMultiKillPVEAdd(uuid)
  if self.dataInfo and self.dataInfo.marchUuid == uuid then
    local info = DataCenter.WorldMarchDataManager:GetMarch(uuid)
    if info then
      self:ShowMultiKillEff(info.pveNum, true)
    end
  end
end

function UIMarchQueueFormationListCell:OnMyMarchMultiKillPVPAdd(uuid)
  if self.dataInfo and self.dataInfo.marchUuid == uuid then
    local info = DataCenter.WorldMarchDataManager:GetMarch(uuid)
    if info then
      self:ShowMultiKillEff(info.pvpNum, false)
    end
  end
end

function UIMarchQueueFormationListCell:ShowMultiKillEff(num, isPve)
  if not num or num <= 0 then
    return
  end
  if not self.multiKillEffReq then
    self.multiKillEffReq = self:GameObjectInstantiateAsync("Assets/Main/Prefabs/UI/UIMain/MultiKillEff.prefab", function(req)
      local go = req.gameObject
      go:SetActive(true)
      go.transform:SetParent(self.multi_kill_root.transform)
      go.transform:Set_localScale(1, 1, 1)
      if CommonUtil.IsArabicAutoMirrorOpen() then
        go.transform:Set_localPosition(-460, 0, 0)
      else
        go.transform:Set_localPosition(0, 0, 0)
      end
      self.multiKillEff = self.multi_kill_root:AddComponent(MultiKillEff, go.name)
      self.multiKillEff:SetData(num, isPve)
    end)
  elseif self.multiKillEff then
    self.multiKillEff:ResetData(num, isPve)
  end
  self:ClearMeteoriteNode(false)
  self.delayDestroy = isPve and LuaEntry.DataConfig:TryGetNum("killstreak_report_UI", "k4", 5) or LuaEntry.DataConfig:TryGetNum("killstreak_report_UI", "k2", 5)
end

function UIMarchQueueFormationListCell:Update1000MS()
  if not self.delayDestroy then
    return
  end
  self.delayDestroy = self.delayDestroy - 1
  if self.delayDestroy <= 0 then
    if self.multiKillEffReq then
      self.multiKillEff = nil
      self.multi_kill_root:RemoveComponents(MultiKillEff)
      self:GameObjectDestroy(self.multiKillEffReq)
      self.multiKillEffReq = nil
    end
    self.delayDestroy = nil
    self:RefreshMeteoriteInfo()
  end
end

local function OnSingleMarchStateUpdate(self, marchUuid)
  local marchInfo = self:GetMarchInfo()
  if marchInfo and marchInfo.uuid == marchUuid then
    if self.sequence then
      self.sequence:Kill()
      self.sequence = nil
    end
    self.sequence = CS.DG.Tweening.DOTween.Sequence()
    self.sequence:Append(self.non_empty_obj:FadeOut(0.3))
    self.sequence:Append(self.non_empty_obj:FadeIn(0.3))
    self:RefreshMarchData()
  end
end

local function OnBeginDrag(self, eventData)
  if self.unlock_obj:GetActive() and self.secondBtnFunctionOpenFlag then
    self.beginDragX = eventData.position.x
  end
end

local function OnEndDrag(self, eventData)
  if (self.uuid or self.isScoutMarch) and self.secondBtnFunctionOpenFlag and self.unlock_obj:GetActive() then
    local IsArabicAutoMirrorOpen = CommonUtil.IsArabicAutoMirrorOpen()
    local endX = eventData.position.x
    if IsArabicAutoMirrorOpen then
      if endX - self.beginDragX > DRAG_LENGTH_THRESHOLD then
        self:PlayDragAnim(not self.secondBtnCanShow)
        if self.secondBtnCanShow then
          CommonUtil.PlayerPrefsSetBool(SettingKeys.SHOW_MARCH_SECOND_BTN_TIPS, true)
        end
        if not self.secondBtnCanShow and self.secondBtnKey then
          UIUtil.ShowTips(self.secondBtnKey)
        end
      elseif self.beginDragX - endX > DRAG_LENGTH_THRESHOLD then
        self:PlayDragAnim(true)
      end
    elseif endX - self.beginDragX > DRAG_LENGTH_THRESHOLD then
      self:PlayDragAnim(false)
    elseif self.beginDragX - endX > DRAG_LENGTH_THRESHOLD then
      self:PlayDragAnim(self.secondBtnCanShow)
      if self.secondBtnCanShow then
        CommonUtil.PlayerPrefsSetBool(SettingKeys.SHOW_MARCH_SECOND_BTN_TIPS, true)
      end
      if not self.secondBtnCanShow and self.secondBtnKey then
        UIUtil.ShowTips(self.secondBtnKey)
      end
    end
  end
end

local function ClearDragAnim(self)
  if self.dragSequence then
    self.dragSequence:Kill()
    self.dragSequence = nil
  end
end

local function PlayDragAnim(self, isMoveLeft)
  ClearDragAnim(self)
  self.dragSequence = CS.DG.Tweening.DOTween.Sequence()
  local curX = self.root_event_trigger:GetAnchoredPositionX()
  local curY = self.root_event_trigger:GetAnchoredPositionY()
  if CommonUtil.IsArabicAutoMirrorOpen() then
    if isMoveLeft then
      if curX < 0 then
        self.root_event_trigger:SetAnchoredPositionXY(-SECOND_BTN_WIDTH, curY)
        self.dragSequence:Append(self.root_event_trigger.transform:DOAnchorPosX(0, DRAG_MOVE_TIME))
        self.dragSequence:OnComplete(function()
          self.dragSequence = nil
        end)
      end
    elseif 0 <= curX then
      self.root_event_trigger:SetAnchoredPositionXY(0, curY)
      self.dragSequence:Append(self.root_event_trigger.transform:DOAnchorPosX(SECOND_BTN_WIDTH, DRAG_MOVE_TIME))
      self.dragSequence:OnComplete(function()
        self.dragSequence = nil
      end)
    end
  elseif isMoveLeft then
    if 0 <= curX then
      self.root_event_trigger:SetAnchoredPositionXY(0, curY)
      self.dragSequence:Append(self.root_event_trigger.transform:DOAnchorPosX(-SECOND_BTN_WIDTH, DRAG_MOVE_TIME))
      self.dragSequence:OnComplete(function()
        self.dragSequence = nil
      end)
    end
  elseif curX < 0 then
    self.root_event_trigger:SetAnchoredPositionXY(-SECOND_BTN_WIDTH, curY)
    self.dragSequence:Append(self.root_event_trigger.transform:DOAnchorPosX(0, DRAG_MOVE_TIME))
    self.dragSequence:OnComplete(function()
      self.dragSequence = nil
    end)
  end
end

local function OnSecondBtnClick(self)
  if self.secondBtnClickCb then
    CommonUtil.ProtectCall(function()
      self:secondBtnClickCb()
    end)
  end
end

local function RefreshSecondBtnData(self)
  local marchInfo
  if self.isScoutMarch then
    local formation = DataCenter.ArmyFormationDataManager:GetInvestigateFormationInfoByIndex(self.formationIndex)
    if formation then
      marchInfo = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, formation.uuid, LuaEntry.Player.allianceId)
    end
  else
    marchInfo = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, self.uuid, LuaEntry.Player.allianceId)
  end
  self.secondBtnCanShow, self.secondBtnKey, self.secondBtnImgPath, self.secondBtnClickCb = MarchUtil.CheckShowSecondBtnStatus(marchInfo)
  if not string.IsNullOrEmpty(self.secondBtnImgPath) then
    self.second_btn_img:LoadSprite(self.secondBtnImgPath)
  end
  self:ShowSecondBtnGuideTip(marchInfo)
  if not self.secondBtnCanShow then
    self:PlayDragAnim(CommonUtil.IsArabicAutoMirrorOpen())
  end
end

local function ShowSecondBtnGuideTip(self, marchInfo)
  local hasShownTip = CommonUtil.PlayerPrefsGetBool(SettingKeys.SHOW_MARCH_SECOND_BTN_TIPS, false)
  if not hasShownTip and marchInfo and SceneUtils.GetIsInWorld() and self.secondBtnFunctionOpenFlag then
    local openServerDaysMeet = UITimeManager:GetInstance():GetOpenServerDay() >= 7
    local mainLvMeet = DataCenter.BuildManager.MainLv >= 15
    local marchTargetType = marchInfo:GetMarchTargetType()
    local marchType = marchInfo:GetMarchType()
    local marchStatus = marchInfo:GetMarchStatus()
    local monsterMarchMeet = marchType == NewMarchType.NORMAL and marchTargetType == MarchTargetType.ATTACK_MONSTER
    local _, imLeader
    _, imLeader = DataCenter.AllianceWarDataManager:CheckJoinAllianceWar(marchInfo.teamUuid)
    local rallyBossMarchMeet = marchType == NewMarchType.ASSEMBLY_MARCH and marchStatus == MarchStatus.WAIT_RALLY and imLeader
    local timeMeet = (marchInfo.endTime - marchInfo.startTime) / 1000 >= 10
    if openServerDaysMeet and mainLvMeet and (monsterMarchMeet and timeMeet or rallyBossMarchMeet) and self.secondBtnCanShow then
      self:DeleteDelayGuideTimer()
      self.delayGuideTimer = TimerManager:GetInstance():DelayInvoke(function()
        if self.root_event_trigger then
          local param = {
            alignObject = self.root_event_trigger,
            content = "world_tip10015",
            widthAdapter = true,
            preferTop = true,
            xPosFix = 300,
            yPosFix = 30,
            countDown = 3,
            hidePanel = true
          }
          UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonSimpleTipView, {anim = false}, param)
          CommonUtil.PlayerPrefsSetBool(SettingKeys.SHOW_MARCH_SECOND_BTN_TIPS, true)
        end
      end, 0.5)
    end
  end
end

local function DeleteDelayGuideTimer(self)
  if self.delayGuideTimer then
    self.delayGuideTimer:Stop()
    self.delayGuideTimer = nil
  end
end

UIMarchQueueFormationListCell.OnCreate = OnCreate
UIMarchQueueFormationListCell.OnDestroy = OnDestroy
UIMarchQueueFormationListCell.OnEnable = OnEnable
UIMarchQueueFormationListCell.OnDisable = OnDisable
UIMarchQueueFormationListCell.RefreshData = RefreshData
UIMarchQueueFormationListCell.SetUuidAndIndex = SetUuidAndIndex
UIMarchQueueFormationListCell.OnAtkClick = OnAtkClick
UIMarchQueueFormationListCell.GetMarchInfo = GetMarchInfo
UIMarchQueueFormationListCell.OnMarchBtnClick = OnMarchBtnClick
UIMarchQueueFormationListCell.OnSelectClick = OnSelectClick
UIMarchQueueFormationListCell.RefreshSlider = RefreshSlider
UIMarchQueueFormationListCell.OnBeginDrag = OnBeginDrag
UIMarchQueueFormationListCell.OnEndDrag = OnEndDrag
UIMarchQueueFormationListCell.RefreshMarchData = RefreshMarchData
UIMarchQueueFormationListCell.RefreshMarch = RefreshMarch
UIMarchQueueFormationListCell.ShowTroopActionArrow = ShowTroopActionArrow
UIMarchQueueFormationListCell.UpdateTime = UpdateTime
UIMarchQueueFormationListCell.OnJumpToFormationPos = OnJumpToFormationPos
UIMarchQueueFormationListCell.RefreshCaptain = RefreshCaptain
UIMarchQueueFormationListCell.RefreshTextAndBtnImg = RefreshTextAndBtnImg
UIMarchQueueFormationListCell.RefreshScoutUI = RefreshScoutUI
UIMarchQueueFormationListCell.SetSelected = SetSelected
UIMarchQueueFormationListCell.SetScoutState = SetScoutState
UIMarchQueueFormationListCell.OnAddListener = OnAddListener
UIMarchQueueFormationListCell.OnRemoveListener = OnRemoveListener
UIMarchQueueFormationListCell.OnSingleMarchStateUpdate = OnSingleMarchStateUpdate
UIMarchQueueFormationListCell.PlayDragAnim = PlayDragAnim
UIMarchQueueFormationListCell.ClearDragAnim = ClearDragAnim
UIMarchQueueFormationListCell.OnSecondBtnClick = OnSecondBtnClick
UIMarchQueueFormationListCell.RefreshSecondBtnData = RefreshSecondBtnData
UIMarchQueueFormationListCell.ShowSecondBtnGuideTip = ShowSecondBtnGuideTip
UIMarchQueueFormationListCell.DeleteDelayGuideTimer = DeleteDelayGuideTimer
return UIMarchQueueFormationListCell
