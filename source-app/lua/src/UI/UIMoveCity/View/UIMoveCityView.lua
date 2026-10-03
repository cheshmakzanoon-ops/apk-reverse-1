local UIMoveCityView = BaseClass("UIMoveCityView", UIBaseView)
local base = UIBaseView
local WorldPlaceItem = require("UI.UIMoveCity.Component.MoveCityPlaceItem")
local WorldMiniMapComp = require("UI.UIMainMiniMap.Component.WorldMiniMapComp")
local Localization = CS.GameEntry.Localization
local confirm_btn_path = "safeArea/BtnGo/common_btn_confirm"
local cancel_btn_path = "safeArea/BtnGo/common_btn_cancel"
local common_bg3_path = "safeArea/common_bg3"
local reason_text_path = "safeArea/common_bg3/reason_text"
local reason_red_text_path = "safeArea/common_bg3/reason_red_text"
local icon_path = "safeArea/common_bg3/build_name/icon"
local btn_go_path = "safeArea/BtnGo"
local build_icon_path = "safeArea/common_bg3/build_icon"
local build_name_path = "safeArea/common_bg3/build_name"
local build_des_path = "safeArea/common_bg3/build_des"
local back_btn_path = "safeArea/common_bg3/back_btn"
local wormHoleTips_img_path = "safeArea/Img_WormHole"
local wormHoleTips_txt_path = "safeArea/Img_WormHole/Txt_WormHoleTips"
local xy_path = "safeArea/common_bg3/WorldPlaceItem"
local top_float_comp_path = "safeArea/common_bg3/topFloatComp"
local tmp_float_notice_path = "safeArea/common_bg3/topFloatComp/tmpFloatNotice"
local mini_map_path = "safeArea/topRight/miniMap"
local cd_tip_path = "safeArea/common_bg3/cd_tip"
local cd_icon_path = "safeArea/common_bg3/cd_tip/cd_icon"
local cd_txt_path = "safeArea/common_bg3/cd_tip/txt"
local cd_time_path = "safeArea/common_bg3/cd_tip/cd_time"
local TilePosDelta = {
  Vector3.New(0, 0, 0),
  Vector3.New(-0.5, 0, -0.5),
  Vector3.New(0, 0, -0.1)
}
local CostType = {
  FreeCrossServerWithCD = 0,
  Item = 1,
  BlackLandFreeMoveSkill = 2,
  FreeMoveSkill = 3,
  WerewolfFreeMoveSkill = 4,
  SeniorFreeMoveSkill = 5,
  LandlordFreeMoveWithCD = 6
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
  if self:BEpidemicSkill() then
    local theWorld = CS.SceneManager.World
    if theWorld ~= nil then
      theWorld:UICreateFakeEpidemicSkill()
    end
  end
  if self:BAllianceSkill() then
    local theWorld = CS.SceneManager.World
    if theWorld ~= nil then
      theWorld:UICreateFakeAllianceSkill()
    end
  end
  CrossServerUtil.TryGetCrossEnableServerList(true)
end

local function OnDestroy(self)
  local theWorld = CS.SceneManager.World
  if theWorld then
    CS.SceneManager.World:SetCameraLodRange(false, 1, 7)
  end
  self:ClosePanel()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_img = self:AddComponent(UIImage, confirm_btn_path)
  self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
  self.common_bg3 = self:AddComponent(UIBaseContainer, common_bg3_path)
  self.reason_text = self:AddComponent(UIText, reason_text_path)
  self.build_icon = self:AddComponent(UIImage, build_icon_path)
  self.build_name = self:AddComponent(UIText, build_name_path)
  self.build_des = self:AddComponent(UIText, build_des_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.reason_red_text = self:AddComponent(UIText, reason_red_text_path)
  self.AutoAdjustScreenPos = self.transform:Find(btn_go_path):GetComponent(typeof(CS.AutoAdjustScreenPos))
  self.topFloatNoticeNode = self.transform:Find(top_float_comp_path).gameObject
  self.tmp_float_notice = self:AddComponent(UITextMeshProUGUIEx, tmp_float_notice_path)
  self.confirm_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnConfirmBtnClick()
  end)
  self.cancel_btn:SetOnClick(function()
    self:OnCancelBtnClick()
  end)
  self.back_btn:SetOnClick(function()
    self:OnBackClick()
  end)
  local inBattleField = BattleFieldUtil.InBattleField()
  if inBattleField then
    self.miniMap = self:AddComponent(UIBaseContainer, mini_map_path)
  else
    local bigMapMode = SeasonUtil.InSeasonBigMapMode(LuaEntry.Player:GetCurServerId())
    local isInSingleServerMode = SeasonUtil.IsSeasonInSingleServerMode(LuaEntry.Player:GetCurServerId())
    if bigMapMode and not isInSingleServerMode then
      local WorldMiniMapCompS5 = require("UI.UIMainMiniMap.Component.WorldMiniMapCompS5")
      self.miniMap = self:AddComponent(WorldMiniMapCompS5, mini_map_path)
    else
      self.miniMap = self:AddComponent(WorldMiniMapComp, mini_map_path)
    end
  end
  self.miniMap:SetActive(false)
  self._wormHoleTips_img = self:AddComponent(UIBaseContainer, wormHoleTips_img_path)
  self._wormHoleTips_txt = self:AddComponent(UIText, wormHoleTips_txt_path)
  self.crossServerTip = self:AddComponent(UIBaseComponent, "safeArea/tipBg")
  self.crossServerTipText = self:AddComponent(UIText, "safeArea/tipBg/tipText")
  self.crossServerTip:SetActive(false)
  self.xy = self:AddComponent(WorldPlaceItem, xy_path)
  self.xy:SetActive(not BattleFieldUtil.InBattleField())
  self:SetFloatNotice(nil)
  local theWorld = CS.SceneManager.World
  if theWorld then
    CS.SceneManager.World:SetCameraLodRange(true, 1, 5)
  end
  self.cd_tip = self:AddComponent(UIImage, cd_tip_path)
  self.cd_icon = self:AddComponent(UIImage, cd_icon_path)
  self.cd_txt = self:AddComponent(UIText, cd_txt_path)
  self.cd_time = self:AddComponent(UITextMeshProUGUIEx, cd_time_path)
  self:OnLodChange()
end

local function ComponentDestroy(self)
  if self.delayMove then
    self.delayMove:Stop()
    self.delayMove = nil
  end
  if self.epidemicSkillSelect then
    self.epidemicSkillSelect:CleanCloneRange()
  end
  self.xy:SetActive(false)
  self.confirm_btn = nil
  self.cancel_btn = nil
  self.common_bg3 = nil
  self.reason_text = nil
  self.AutoAdjustScreenPos = nil
  self.confirm_img = nil
  self.build_icon = nil
  self.build_name = nil
  self.build_des = nil
  self.back_btn = nil
  self.reason_red_text = nil
  self.epidemic_skill = nil
  self.alliance_skill = nil
  self.cd_tip = nil
  self.cd_icon = nil
  self.cd_txt = nil
  self.cd_time = nil
end

local function DataDefine(self)
  self.param = nil
  self.isInGuide = false
  self.needMoveNewPos = false
  self.curServerId = 0
  self.curIndex = 0
  self.noPutPoint = {}
  self.useMainBuildGreen = {}
  self.freeMainBuildGreen = {}
  self.putState = BuildPutState.None
  self.buildTemplate = nil
  self.needPosFree = {}
  self.needDoCancelFunction = true
  self.costType = CostType.Item
  self.epidemicSkillRangePoints = {}
  self.epidemicEff = {}
  self.epidemicEffHandle = {}
  self.mainRange = BattleFieldUtil.GetMainRange()
  self.allianceEff = {}
  self.allianceEffHandle = {}
end

local function DataDestroy(self)
  if self.skillLeftDelay then
    self.skillLeftDelay:Stop()
    self.skillLeftDelay = nil
  end
  if self.electricityEffect ~= nil then
    self.electricityEffect:Delete()
    self.electricityEffect = nil
  end
  if self.param and self.param.buildUuid ~= 0 then
    DataCenter.BuildTimeManager:RefreshActive(self.param.buildUuid, true)
  end
  DataCenter.BuildManager:SetShowPutBuildFromPanel(nil)
  self.param = nil
  self.isInGuide = nil
  self.needMoveNewPos = nil
  self.curIndex = nil
  self.noPutPoint = nil
  self.useMainBuildGreen = nil
  self.freeMainBuildGreen = nil
  self.putState = nil
  self.buildTemplate = nil
  self.needPosFree = nil
  self.needDoCancelFunction = false
  self.moveToMeteoriteAct = nil
  self.epidemicSkillRangePoints = nil
  self.epidemicEff = nil
  if self.epidemicEffHandle ~= nil then
    for _, v in pairs(self.epidemicEffHandle) do
      v:Destroy()
    end
    self.epidemicEffHandle = nil
  end
  self.allianceEff = nil
  if self.allianceEffHandle ~= nil then
    for _, v in pairs(self.allianceEffHandle) do
      v:Destroy()
    end
    self.allianceEffHandle = nil
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  if self.curServerId then
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    if loginServerId ~= self.curServerId then
      local mySourceServerId = LuaEntry.Player:GetSourceServerId()
      if mySourceServerId ~= self.curServerId then
        local needCheckCD = true
        local isBigMapMode, curSame, srcSame, loginSame = SeasonUtil.InSeasonBigMapMode(self.curServerId)
        if isBigMapMode then
          local seasonInfo = SeasonUtil.GetSeasonInfo(self.curServerId)
          if loginSame and seasonInfo and seasonInfo:InNormalMode() then
            needCheckCD = false
          end
        end
        if needCheckCD then
          CrossServerUtil.IsCrossMoveCD(true, self.curServerId)
        end
      end
    end
    CrossServerUtil.UpdateLastMoveCityServer(self.curServerId)
  end
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  CS.SceneManager.World:HideTouchEffect()
  self.needDoCancelFunction = true
  self.icon:SetActive(false)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMain) then
    EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
  else
    DataCenter.GuideManager:SetNoShowUIMain(true)
  end
  local curServerId = LuaEntry.Player:GetCurServerId()
  local buildId, buildUuid, point, topType, otherParam = self:GetUserData()
  self.param = {}
  if otherParam then
    if otherParam.mode ~= nil and otherParam.type ~= nil and otherParam.mode ~= JumpServerMode.NormalMoveCity then
      self.param.otherParam = otherParam
    end
    if otherParam.serverId then
      curServerId = otherParam.serverId
    end
  end
  if buildId ~= nil and buildId ~= "" then
    self.param.buildId = tonumber(buildId)
  else
    self.param.buildId = 0
  end
  if buildUuid ~= nil and buildUuid ~= "" then
    self.param.buildUuid = tonumber(buildUuid)
    DataCenter.BuildManager:SetOnMovingBuildUuid(self.param.buildUuid)
  else
    self.param.buildUuid = 0
  end
  if topType ~= nil and topType ~= "" then
    self.param.topType = tonumber(topType)
  else
    self.param.topType = PlaceBuildType.None
  end
  if self.param.topType == PlaceBuildType.AllianceSkill then
    self.param.allianceSkillFlag = otherParam.allianceSkillFlag
    self.param.allianceFakeBuildId = otherParam.allianceFakeBuildId
    self.param.allianceSkillId = otherParam.allianceSkillId
  end
  CS.SceneManager.World:SetUseInput(false)
  self.tile = 3
  self.inS5BigMap, self.srcSameGroup, self.loginSameGroup = SeasonUtil.InSeasonBigMapMode(curServerId)
  self.curServerId = curServerId
  self._wormHoleTips_img:SetActive(false)
  if point == nil or point == "" or point == 0 then
    point = TileBubbleManager:GetInstance():GetPoint()
  end
  local willPos = SceneUtils.TileIndexToWorld(point, ForceChangeScene.World, self.curServerId)
  self.xy:ShowServerInfo(self.inS5BigMap)
  self.cd_tip:SetActive(false)
  if self.inS5BigMap then
    self:UIPlaceBuildChangePosSignal(willPos)
  else
    self:ChangeIndex(point)
  end
  local temp = willPos + TilePosDelta[self.tile]
  local CameraHeight = -1
  if not BattleFieldUtil.InBattleField() then
    CameraHeight = MoveCityCameraHeight
    local data = CrossServerUtil.GetLastJumpToParam()
    if data and data.mode == JumpServerMode.CrossServerMoveCity then
      CameraHeight = SeasonCrossCameraHeight
    end
  end
  CS.SceneManager.World:AutoLookat(temp, CameraHeight, LookAtFocusTime, function()
  end)
  DataCenter.BuildBubbleManager:HideBubbleNode()
  if self.param.buildUuid ~= 0 then
    DataCenter.BuildTimeManager:RefreshActive(self.param.buildUuid, false)
  end
  self:LoadBuildSelect()
  self:ChangeSelectBuild()
  if self.skillLeftDelay then
    self.skillLeftDelay:Stop()
    self.skillLeftDelay = nil
  end
  if self:BEpidemicSkill() then
    self.common_bg3:SetActive(false)
    self:SetEpidemicShow(true)
    local leftTime = self:EpidemicSkillLeftTime()
    if 0 < leftTime then
      self.skillLeftDelay = TimerManager:GetInstance():DelayInvoke(function()
        self.skillLeftDelay = nil
        self:ReInit()
      end, leftTime / 1000 + 0.5)
    end
  elseif self:BAllianceSkill() then
    self.common_bg3:SetActive(false)
    self:SetAllianceSkillShow(true)
  else
    self.common_bg3:SetActive(true)
    self:SetEpidemicShow(false)
    self:SetBuildInfo()
  end
  if self.buildTemplate ~= nil and self.buildTemplate.build_type == BuildType.Normal then
    EventManager:GetInstance():Broadcast(EventId.ShowCanBuildEffect)
  end
  self:TryShowElectricityEffect()
end

function UIMoveCityView:TryShowElectricityEffect()
  if self.electricityEffect ~= nil or not LuaEntry.Player:AtHomeNow() then
    return
  end
  local theWorld = CS.SceneManager.World
  if theWorld == nil then
    return
  end
  local theStoveCenter = DataCenter.AllianceMineManager:GetAllianceStoveCenter()
  if theStoveCenter == nil or theStoveCenter.status == AllianceMineStatus.Build or theStoveCenter.status == AllianceMineStatus.Ruin then
    return
  end
  local worldPos = theStoveCenter:GetWorldPos()
  local infoPlayer = DataCenter.SeasonDataManager:GetUserSeasonInfo()
  if infoPlayer and infoPlayer:ServerInReady() and infoPlayer:InNormalMode() and infoPlayer:GetServerType(false) == SeasonMapType.Darkness then
    local effectPath = "Assets/Main/SeasonRes/S4/Prefabs/Effect/VFX_electricity_area.prefab"
    self.electricityEffect = UIAsyncNode.New("electricity_area", theWorld.DynamicObjNode.transform, effectPath, function(go)
      if IsNotNull(go) then
        go.transform:Set_localScale(1, 1, 1)
        go.transform:Set_localPosition(worldPos.x, worldPos.y, worldPos.z)
        go.transform:Set_localEulerAngles(0, 0, 0)
        go:SetActive(true)
      end
    end)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.UIPlaceBuildChangePos, self.UIPlaceBuildChangePosSignal)
  self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.UpdatePointDataSignal)
  self:AddUIListener(EventId.CheckBlankLandResult, self.OnCheckBlankLandResult)
  self:AddUIListener(EventId.AfterWorldCameraLodChanged, self.OnLodChange)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UIPlaceBuildChangePos, self.UIPlaceBuildChangePosSignal)
  self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.UpdatePointDataSignal)
  self:RemoveUIListener(EventId.CheckBlankLandResult, self.OnCheckBlankLandResult)
  self:RemoveUIListener(EventId.AfterWorldCameraLodChanged, self.OnLodChange)
end

local function SetBuildInfo(self)
  local tryMoveToServerId = self.curServerId
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.buildId)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.buildUuid)
  self:SetFloatNotice(nil)
  if buildTemplate ~= nil then
    local level = 1
    if buildData ~= nil then
      level = buildData.level
    end
    if self.costType == CostType.FreeCrossServerWithCD then
      self.cd_txt:SetLocalText("s5_cross_ui06")
      self.build_name:SetLocalText("s5_cross_ui05")
      self.build_des:SetLocalText("110231")
      self.build_icon:LoadSpriteAsync("Assets/Main/Sprites/UI/UIMastery/wxy_S3_mianfeiqiancheng.png")
      if tryMoveToServerId ~= mySourceServerId then
        self.theCrossMoveCD = DataCenter.LeagueMatchManager:GetCrossMoveCDEnd()
        local now = UITimeManager:GetInstance():GetServerTime()
        if self.theCrossMoveCD ~= nil and now >= self.theCrossMoveCD then
          self.theCrossMoveCD = nil
        end
        if self.theCrossMoveCD and self.theCrossMoveCD > 0 then
          self.cd_icon:LoadSpriteAsync("Assets/Main/Sprites/UI/UIMastery/wxy_S3_mianfeiqiancheng.png")
        else
          self.theCrossMoveCD = nil
        end
        if self.theCrossMoveCD then
          local HunterManager = DataCenter.SeasonHunterManager
          local in_bad_server = HunterManager:IsBanServer(loginServerId) or HunterManager:IsWarnServer(loginServerId)
          if in_bad_server then
            local to_bad_server = HunterManager:IsBanServer(tryMoveToServerId) or HunterManager:IsWarnServer(tryMoveToServerId)
            if not to_bad_server then
              self.theCrossMoveCD = nil
            end
          end
        end
      else
        self.theCrossMoveCD = nil
      end
      self:Update1000MS()
      if self.theCrossMoveCD ~= nil and self.theCrossMoveCD > 0 then
        self.build_name:SetLocalText("world_cross_teleport_tips_1005")
      else
        self:SetFloatNotice(Localization:GetString("alliance_duel_tips10031"))
      end
      return
    elseif self.inS5BigMap and self.costType == CostType.Item then
      if self.moveToMeteoriteAct then
        self:RefreshMeteoriteFree()
      else
        local itemCount = DataCenter.ItemData:GetItemCount(SpecialItemId.ITEM_MOVE_CITY)
        self.build_name:SetLocalText("110230", itemCount)
        self.build_des:SetLocalText("110231")
        self.build_icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.param.buildId, level))
        self.theCrossMoveCD = nil
        self:Update1000MS()
        return
      end
    end
    self.build_icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.param.buildId, level))
    if self.param.topType == PlaceBuildType.MoveCity or self.param.topType == PlaceBuildType.MoveCity_Al or self.param.topType == PlaceBuildType.MoveCity_Cmn then
      if self.costType == CostType.Item and self.item == nil then
        self:CheckItem()
      end
      if self.moveToMeteoriteAct then
        self:RefreshMeteoriteFree()
      elseif self.useFreeAlMove then
        local tempCount = self.item and self.item.count or 0
        self.build_name:SetText(Localization:GetString("110228", tempCount) .. "(" .. Localization:GetString("121059") .. ")")
        self.build_des:SetText(Localization:GetString("110229"))
      elseif self.costType == CostType.BlackLandFreeMoveSkill then
        local skillTemp = DataCenter.MasteryManager:GetSkillTemplateByType(MasterySkill.BlackLandMoveCity)
        self.build_name:SetText(string.format("%s: %s/%s", Localization:GetString(skillTemp.name), self.skill.cur, self.skill.max))
        self.build_des:SetLocalText("season_mastery_s4_tips_8")
        self.build_icon:LoadSpriteAuto(skillTemp:GetIconFullPath())
      elseif self.costType == CostType.WerewolfFreeMoveSkill then
        local isLearned = DataCenter.MasteryManager:GetUnlockedSkillTemplateByType(MasterySkill.WerewolfMoveCity)
        if not isLearned then
          self.build_name:SetText("")
        else
          self:Update1000MS()
        end
        self.build_des:SetText("")
        local skillTemp = DataCenter.MasteryManager:GetSkillTemplateByType(MasterySkill.WerewolfMoveCity)
        self.build_icon:LoadSpriteAuto(skillTemp:GetIconFullPath())
      elseif self.costType == CostType.SeniorFreeMoveSkill then
        local skillTemp = DataCenter.MasteryManager:GetSkillTemplateByType(MasterySkill.SeniorFreeMoveCity)
        self.build_name:SetText(string.format("%s: %s/%s", Localization:GetString(skillTemp.name), self.skill.cur, self.skill.max))
        self.build_des:SetLocalText(110231)
        self.build_icon:LoadSpriteAuto(skillTemp:GetIconFullPath())
      elseif self.costType == CostType.FreeMoveSkill then
        local skillTemp = DataCenter.MasteryManager:GetSkillTemplateByType(MasterySkill.FreeMoveCity)
        self.build_name:SetText(string.format("%s: %s/%s", Localization:GetString(skillTemp.name), self.skill.cur, self.skill.max))
        self.build_des:SetLocalText(110231)
        self.build_icon:LoadSpriteAuto(skillTemp:GetIconFullPath())
      elseif BattleFieldUtil.InBattleField() then
        self.build_name:SetText("")
        self.build_des:SetLocalText("110231")
      elseif self.costType == CostType.LandlordFreeMoveWithCD then
        if 0 < DataCenter.LandlordMgr:GetFreeMoveInfoEndTime() and tryMoveToServerId == DataCenter.LandlordMgr:GetCenterServerId() then
          self.theCrossMoveCD = DataCenter.LandlordMgr:GetFreeMoveInfoEndTime()
          self.cd_icon:LoadSpriteAsync("Assets/Main/Sprites/UI/UIMastery/wxy_S3_mianfeiqiancheng.png")
          local tempCount = DataCenter.ItemData:GetItemCount(SpecialItemId.ITEM_MOVE_CITY)
          local strName = Localization:GetString("110230", tempCount)
          self.build_name:SetText(strName)
          self.build_des:SetLocalText("")
          self.cd_txt:SetLocalText("zonewar_landlord_limit_1087")
        end
        self:Update1000MS()
      elseif self.item then
        local strName = Localization:GetString(buildTemplate.name)
        local strDesc = Localization:GetString(buildTemplate.des)
        if self.item.itemId == SpecialItemId.ITEM_MOVE_CITY then
          local tempCount = self.item.count or 0
          strName = Localization:GetString("110230", tempCount)
          strDesc = Localization:GetString("110231")
        elseif self.item.itemId == SpecialItemId.ITEM_ALLIANCE_CITY_MOVE then
          local tempCount = self.item.count or 0
          strName = Localization:GetString("110228", tempCount)
          strDesc = Localization:GetString("110229")
        end
        self.build_name:SetText(strName)
        self.build_des:SetText(strDesc)
      else
        local strName = Localization:GetString("110230", 0)
        local strDesc = Localization:GetString("110231")
        self.build_name:SetText(strName)
        self.build_des:SetText(strDesc)
      end
    else
      self.build_name:SetLocalText(buildTemplate.name)
      self.build_des:SetLocalText(buildTemplate.des)
    end
  end
end

local function ClosePanel(self)
  DataCenter.BuildManager:SetOnMovingBuildUuid(0)
  if self.needDoCancelFunction then
    self:DoCancel()
  end
  EventManager:GetInstance():Broadcast(EventId.FakeBuildingSelectLocation)
  EventManager:GetInstance():Broadcast(EventId.UpdateFakeBuildingPos)
  if self.param then
    EventManager:GetInstance():Broadcast(EventId.HideBuildTopUI, self.param.buildUuid)
  end
  EventManager:GetInstance():Broadcast(EventId.HideCanBuildEffect)
  if CS.SceneManager.World ~= nil then
    CS.SceneManager.World:SetUseInput(true)
    CS.SceneManager.World:SetTouchInputControllerEnable(true)
    DataCenter.BuildBubbleManager:ShowBubbleNode()
    CS.SceneManager.World.touchPickablePos:Clear()
    if CS.SceneManager.World.SelectBuild ~= nil then
    end
    CS.SceneManager.World.SelectBuild = nil
    CS.SceneManager.World:UIDestroyRreCreateBuild()
    if self.param and (self.param.topType == PlaceBuildType.MoveCity or self.param.topType == PlaceBuildType.MoveCity_Al or self.param.topType == PlaceBuildType.MoveCity_Cmn or self:BEpidemicSkill() or self:BAllianceSkill()) and CS.SceneManager.World ~= nil then
      local temp = CS.SceneManager.World:GetWorldBuildingByUuid(self.param.buildUuid)
      if temp ~= nil then
        temp:SetMoveState(false)
      end
    end
  end
  if LuaEntry.Player:IsInSelfServer() then
    CrossServerUtil.SetLastJumpToParam(nil)
  end
end

function UIMoveCityView:DoCityMove()
  local param = {}
  if self.item ~= nil then
    param.itemUUid = self.item.uuid
  end
  param.pointId = self.curIndex
  param.freeAllianceMove = self.useFreeAlMove
  SFSNetwork.SendMessage(MsgDefines.WorldMv, param)
  self.needMoveNewPos = true
  self.needDoCancelFunction = false
  self.ctrl:CloseSelf()
end

local function ConfirmBtnClickFallback(self)
  if SeasonUtil.GetSeason() ~= 0 then
    local explodeEffect = LuaEntry.Effect:GetGameEffect(EffectDefine.SEASON_VIRUS_MAX_EXPLODE)
    if explodeEffect ~= 0 then
      local message = Localization:GetString("season_s1_add_virus_tips03")
      UIUtil.ShowMessage(message, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        Logger.Log("UIMoveCityView season_s1_add_virus_tips03")
        self:CheckSeasonStatus()
      end, function()
        self:DoCancel()
      end, function()
        self:DoCancel()
      end)
    elseif LuaEntry.Effect:HasStatus(SELF_EXPLOSION_STATUS_ID) then
      local message = Localization:GetString("season_mastery_tips_30")
      UIUtil.ShowMessage(message, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        Logger.Log("UIMoveCityView season_mastery_tips_30")
        self:CheckSeasonStatus()
      end, function()
        self:DoCancel()
      end, function()
        self:DoCancel()
      end)
    elseif SeasonUtil.GetSourceSeasonType() == SeasonMapType.Darkness and DataCenter.SeasonHunterManager:IsOverLapWolfShadow(self.curServerId, self.curIndex) then
      UIUtil.ShowSecondMessageByParam({
        tipText = Localization:GetString("season_s4_blood_hunter_shadow_error_desc"),
        btnNum = 2,
        showToggle = false,
        sureAction = function()
          self:CheckSeasonStatus()
        end,
        cancelAction = function()
          self:DoCancel()
        end,
        closeAction = function()
          self:DoCancel()
        end,
        delayConfirm = {delayTime = 3}
      })
    else
      self:CheckSeasonStatus()
    end
  else
    self:TryMoveCity(false)
  end
end

local function OnConfirmBtnClick(self)
  if self.putState == BuildPutState.ItemLack then
    self:DoCancel()
    LWResourceLackUtil:GotoGoodsItemLack(SpecialItemId.ITEM_MOVE_CITY, 1)
    return
  elseif self.putState ~= BuildPutState.Ok then
    if self.curServerId then
      CrossServerUtil.IsCrossMoveCD(true, self.curServerId)
    end
    return
  end
  EventManager:GetInstance():Broadcast(EventId.OnClickPlaceBuild)
  if self.param.topType == PlaceBuildType.EpidemicSkill then
    DataCenter.ActEpidemicZoneManager:ReqBattleUseSkill(self.curIndex)
    self.needMoveNewPos = true
    self.needDoCancelFunction = false
    self.ctrl:CloseSelf()
  elseif self.param.topType == PlaceBuildType.AllianceSkill then
    DataCenter.AllianceGovernmentCommonSkillManager:UseSkill(self.param.allianceSkillFlag, self.curIndex)
    self.ctrl:CloseSelf()
  elseif self.param.topType == PlaceBuildType.MoveCity or self.param.topType == PlaceBuildType.MoveCity_Al or self.param.topType == PlaceBuildType.MoveCity_Cmn then
    if BattleFieldUtil.InBattleField() then
      if self.curIndex == LuaEntry.Player:GetMainWorldPos() then
        self:DoCancel()
      else
        self:DoCityMove()
      end
    elseif DataCenter.ActMeteoriteBattleManager:IsInMeteoriteBattle() and DataCenter.ActMeteoriteBattleManager:IsInMeteoriteBattleServerGroup() or DataCenter.ActMeteoriteBattleManager:HaveMeteoriteMine() then
      if DataCenter.ActMeteoriteBattleManager:CheckMoveInHotArea(self.curIndex) then
        UIUtil.ShowTipsId("yuntieBattle_tips_1026")
        return
      end
      if DataCenter.ActMeteoriteBattleManager:NeedNoticeMoveCity(self.curIndex) then
        UIManager:GetInstance():OpenWindow(UIWindowNames.LWUIMeteoriteDropNoticeNotice, {anim = true}, {
          ok = function()
            self:ConfirmBtnClickFallback()
          end,
          cancel = function()
            self:OnCancelBtnClick()
          end,
          notice = "yuntieBattle_interface_1038",
          ignoreKey = SettingKeys.NO_METEORITE_DROP_PROMPT
        })
      else
        self:ConfirmBtnClickFallback()
      end
    else
      self:ConfirmBtnClickFallback()
    end
  end
end

function UIMoveCityView:CheckSeasonStatus()
  local inBadArea = false
  local tipMsgKey
  if DataCenter.BirthPointTemplateManager:IsInAllianceCityField(self.curIndex, self.curServerId) then
    tipMsgKey = "season_tips108"
    inBadArea = true
  else
    local overTime, blackMode = DataCenter.AllianceSkillManager:GetBlackAreaOverTime(self.curIndex)
    Logger.LogInfo(string.format("[CheckBlackAreaTips] overTime:%s, blackMode: %s", overTime, blackMode))
    if 1000 < overTime then
      if blackMode == AlAlertType.MissileFactory then
        tipMsgKey = "season_s2_government_skill_tips18"
      else
        tipMsgKey = "season_s2_government_skill_tips18"
      end
      inBadArea = true
    end
  end
  if inBadArea then
    local message = Localization:GetString(tipMsgKey)
    Logger.LogInfo(string.format("[CheckBlackAreaTips] isCanTodayShow:%s", DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.MoveCityInBlackArea)))
    UIUtil.TryShowConfirm(TodayNoSecondConfirmType.MoveCityInBlackArea, message, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      Logger.Log("UIMoveCityView " .. (tipMsgKey or "???"))
      local actList = DataCenter.ActivityListDataManager:GetActivityDataByType(EnumActivity.SeasonCrossAttackCityActivity.Type)
      if actList and 0 < #actList then
        local msg2 = Localization:GetString("season_tips224")
        UIUtil.ShowMessage(msg2, 2, "110106", "110006", function()
          self:DoCancel()
        end, function()
          Logger.Log("UIMoveCityView season_tips224")
          self:TryMoveCity(false)
        end, function()
          self:DoCancel()
        end, "100378")
      else
        self:TryMoveCity(false)
      end
    end, function()
      self:DoCancel()
    end, function()
      self:DoCancel()
    end, Localization:GetString("100378"))
  else
    self:TryMoveCity(true)
  end
end

function UIMoveCityView:TryMoveCity(needCheckBlankLand)
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local serverId = self.curServerId
  if serverId == loginServerId then
    if self.curIndex == LuaEntry.Player:GetMainWorldPos() then
      self:DoCancel()
      return
    end
    if not self.moveToMeteoriteAct and self.costType == CostType.Item and (self.item == nil or self.item.count <= 0) then
      UIUtil.ShowTipsId(120021)
      self:DoCancel()
    elseif SceneUtils.IsInBlackRange(self.curIndex) or MeteoriteBattleUtils.IsInHighArea(self.curIndex) then
      local message = Localization:GetString(457079)
      UIUtil.TryShowConfirm(TodayNoSecondConfirmType.MoveCityInBlackTip, message, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:DoCityMove()
      end, function()
        self:DoCancel()
        Logger.Log("UIMoveCityView 457079")
      end, nil, Localization:GetString("100378"))
    elseif DataCenter.LWZombieRushManager:IsChallenging() then
      UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("zombieRush_tips_12"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:DoCityMove()
        Logger.Log("UIMoveCityView zombieRush_tips_12")
      end, function()
      end)
    elseif needCheckBlankLand then
      SFSNetwork.SendMessage(MsgDefines.CheckBlankLand, self.curIndex, serverId)
      self.confirm_btn:SetInteractable(false)
      self.confirm_img:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm_gray")
      self.delayMove = TimerManager:GetInstance():DelayInvoke(function()
        if self.delayMove then
          self.delayMove = nil
          self:DoCityMove()
        end
      end, 1.2)
    else
      self:DoCityMove()
    end
  else
    local SourceServerId = LuaEntry.Player:GetSourceServerId()
    local CurServerId = serverId
    if CurServerId ~= SourceServerId and not self.inS5BigMap and CrossServerUtil.IsCrossMoveCD(true, CurServerId) then
      CrossServerUtil.SetLastJumpToParam(nil)
      self.ctrl:CloseSelf()
      return
    end
    local jumpType = MoveCrossServerType.AllianceDuel
    if self.param and self.param.otherParam then
      local otherParam = self.param.otherParam
      if otherParam.mode == JumpServerMode.CrossServerMoveCity then
        jumpType = otherParam.type
        CrossServerUtil.SetLastJumpToParam(otherParam)
      elseif otherParam.mode == JumpServerMode.MeteoriteBattleMoveCity then
        jumpType = otherParam.type
        CrossServerUtil.SetLastJumpToParam(otherParam)
      end
    else
      local jumpToParam = CrossServerUtil.GetLastJumpToParam()
      if jumpToParam and jumpToParam.type and jumpToParam.mode == JumpServerMode.CrossServerMoveCity and jumpToParam.serverId == serverId then
        jumpType = jumpToParam.type
      else
        local moveType = MoveCityUtil.TryGetMoveCityType(CurServerId)
        if moveType then
          jumpType = moveType
        else
          UIUtil.ShowTipsId("104274")
          CrossServerUtil.SetLastJumpToParam(nil)
          self.ctrl:CloseSelf()
          return
        end
      end
    end
    local param = {}
    param.dstPoint = self.curIndex
    param.serverId = serverId
    param.type = jumpType
    if SceneUtils.IsInBlackRange(self.curIndex) or MeteoriteBattleUtils.IsInHighAreaServer(CurServerId, self.curIndex) then
      local message = Localization:GetString(457079)
      UIUtil.TryShowConfirm(TodayNoSecondConfirmType.MoveCityInBlackTip, message, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:TryCrossMoveCity(param)
      end, function()
        self:OnCancelBtnClick()
      end, nil, Localization:GetString("100378"))
    elseif DataCenter.LWZombieRushManager:IsChallenging() then
      UIUtil.ShowMessage(CS.GameEntry.Localization:GetString("zombieRush_tips_12"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        self:TryCrossMoveCity(param)
        Logger.Log("UIMoveCityView zombieRush_tips_12")
      end, function()
      end)
    elseif CurServerId ~= SourceServerId then
      local canShow = DataCenter.ActDragonManager:CanShowEnter()
      if canShow then
        local message = Localization:GetString("world_teleport_tips_10001")
        UIUtil.ShowMessage(message, 2, GameDialogDefine.CANCEL, GameDialogDefine.CONFIRM, function()
          self:DoCancel()
        end, function()
          DataCenter.ActDragonManager:ReqLevelDragonWorld()
          self:TryCrossMoveCity(param)
          Logger.Log("UIMoveCityView world_teleport_tips_10001")
        end)
      else
        local remainTime = DataCenter.ActWinterStormManager:GetInBattleWorldLeftTime()
        if 0 < remainTime then
          UIUtil.ShowTipsId("winter_battlefield_tips1025")
          self:DoCancel()
        else
          self:TryCrossMoveCity(param)
        end
      end
    elseif needCheckBlankLand then
      self.confirm_btn:SetInteractable(false)
      self.confirm_img:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm_gray")
      SFSNetwork.SendMessage(MsgDefines.CheckBlankLand, self.curIndex, CurServerId)
      self.delayMove = TimerManager:GetInstance():DelayInvoke(function()
        if self.delayMove then
          self.delayMove = nil
          self:TryCrossMoveCity(param)
        end
      end, 1.2)
    else
      self:TryCrossMoveCity(param)
    end
  end
end

function UIMoveCityView:TryCrossMoveCity(param)
  if self.inS5BigMap then
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    local mySourceServerId = LuaEntry.Player:GetSourceServerId()
    CrossServerUtil.SetLastJumpToParam(nil)
    if self.costType == CostType.Item or self.costType == CostType.FreeMoveSkill or self.costType == CostType.SeniorFreeMoveSkill or self.costType == CostType.LandlordFreeMoveWithCD or self.costType == CostType.BlackLandFreeMoveSkill then
      param.useCrossItem = true
      param.type = MoveCrossServerType.SeasonBattleDesert
    elseif self.costType == CostType.FreeCrossServerWithCD then
      if param.serverId == mySourceServerId then
        param.type = MoveCrossServerType.BackToSrcServer
      elseif param.serverId ~= loginServerId and param.type ~= MoveCrossServerType.AllianceDuel then
        param.type = MoveCrossServerType.SeasonBattleDesert
      end
    end
  end
  SFSNetwork.SendMessage(MsgDefines.MoveCrossServer, param)
  self.needMoveNewPos = true
  self.needDoCancelFunction = false
  self.ctrl:CloseSelf()
end

function UIMoveCityView:OnCheckBlankLandResult(t)
  if self.delayMove == nil or t == nil or self.curIndex ~= t.point then
    return
  end
  self.delayMove:Stop()
  self.delayMove = nil
  local isBlankLand = t.isBlankLand
  if isBlankLand then
    local msg = CS.GameEntry.Localization:GetString("season_s2_alliance_tips_04")
    UIUtil.ShowMessage(msg, 2, GameDialogDefine.CANCEL, GameDialogDefine.CONFIRM, function()
      self:OnCancelBtnClick()
    end, function()
      self:TryMoveCity(false)
      Logger.Log("UIMoveCityView season_s2_alliance_tips_04")
    end)
  else
    self:TryMoveCity(false)
  end
end

local function OnCancelBtnClick(self)
  if LuaEntry.Player:IsInSelfServer() or BattleFieldUtil.InBattleField() then
    self:DoCancel()
  elseif self.inS5BigMap then
    CrossServerUtil.SetLastJumpToParam(nil)
    self:DoCancel()
  else
    self:DoCancel()
  end
end

function UIMoveCityView:DoCancel()
  self.needMoveNewPos = false
  self.needDoCancelFunction = false
  local param = CrossServerUtil.GetLastJumpToParam()
  if param and (param.mode == JumpServerMode.CrossServerMoveCity or param.mode == JumpServerMode.MeteoriteBattleMoveCity) then
    CrossServerUtil.SetLastJumpToParam(nil)
  end
  self.ctrl:CloseSelf()
end

local function OnBackClick(self)
  if self.inS5BigMap then
    CrossServerUtil.SetLastJumpToParam(nil)
  end
  local buildId = self.param.buildId
  local backToWindow = DataCenter.BuildManager:GetShowPutBuildFromPanel()
  self:DoCancel()
  if backToWindow ~= nil and backToWindow ~= "" then
    UIManager:GetInstance():OpenWindow(backToWindow, buildId)
  end
end

local function ShowBlock(self)
  if self.buildTemplate ~= nil and self.buildTemplate.build_type == BuildType.Second and table.count(self.useMainBuildGreen) > 0 then
    return
  end
  local needAdd = {}
  local use = {}
  local list = BuildingUtils.GetAllCanPutPointsByBuildId(self.curIndex, self.param.buildId, self.param.buildUuid)
  if list ~= nil and 0 < #list then
    for k, v in pairs(list) do
      local index = v
      if self.useMainBuildGreen[index] == nil then
        table.insert(needAdd, index)
      else
        use[index] = self.useMainBuildGreen[index]
        self.useMainBuildGreen[index] = nil
      end
    end
    self.needPosFree = self.useMainBuildGreen
    self.useMainBuildGreen = use
    for k, v in ipairs(needAdd) do
      self:ShowOneBlock(v)
    end
    if 0 < table.count(self.needPosFree) then
      for k1, v1 in pairs(self.needPosFree) do
        v1:SetActive(false)
        table.insert(self.freeMainBuildGreen, v1)
      end
      self.needPosFree = {}
    end
  else
    for k, v in pairs(self.useMainBuildGreen) do
      v:SetActive(false)
      table.insert(self.freeMainBuildGreen, v)
    end
    self.useMainBuildGreen = {}
  end
end

local function ShowOneBlock(self, index)
  if table.count(self.needPosFree) > 0 then
    local go
    local useIndex = 0
    for k, v in pairs(self.needPosFree) do
      go = v
      useIndex = k
    end
    if go ~= nil then
      self.needPosFree[useIndex] = nil
      go.transform.position = SceneUtils.TileIndexToWorld(index, ForceChangeScene.World, self.curServerId) + BlockPos
      self.useMainBuildGreen[index] = go
    end
  elseif 0 < table.count(self.freeMainBuildGreen) then
    local go = table.remove(self.freeMainBuildGreen)
    if go ~= nil then
      go:SetActive(true)
      go.transform.position = SceneUtils.TileIndexToWorld(index, ForceChangeScene.World, self.curServerId) + BlockPos
      self.useMainBuildGreen[index] = go
    end
  else
    self:GameObjectInstantiateAsync(UIAssets.BuildBlock, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform.position = SceneUtils.TileIndexToWorld(index, ForceChangeScene.World, self.curServerId) + BlockPos
      self.useMainBuildGreen[index] = go
    end)
  end
end

local function LoadBuildSelect(self)
  self:LoadEpidemic()
  if self.buildSelect == nil then
    self:GameObjectInstantiateAsync(string.format(UIAssets.BuildSelect, self.tile, self.tile), function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      if go ~= nil then
        go:SetActive(true)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.buildSelect = go:GetComponent(typeof(CS.BuildSelect))
        self:RefreshBuildSelect()
      end
    end)
  end
end

local function RefreshBuildSelect(self)
  if self.buildSelect ~= nil then
    local halfSize = self.tile - 1
    if self.curWorldPos then
      self.buildSelect.transform:Set_position(self.curWorldPos.x + halfSize, BlockPos.y, self.curWorldPos.z + halfSize)
    elseif self.curIndex ~= 0 then
      local v = SceneUtils.TileIndexToWorld(self.curIndex, ForceChangeScene.World, self.curServerId) + BlockPos
      self.buildSelect.transform:Set_position(v.x + halfSize, v.y, v.z + halfSize)
    else
      self.buildSelect.transform:Set_position(halfSize, 0, halfSize)
    end
    self.buildSelect:ChangeColor(self.putState == BuildPutState.Ok)
  end
  if self.epidemicSkillSelect ~= nil then
    local halfSize = self.epidemicSkillRange - 1
    if self.curWorldPos then
      self.epidemicSkillSelect.transform:Set_position(self.curWorldPos.x + halfSize, BlockPos.y, self.curWorldPos.z + halfSize)
    elseif self.curIndex ~= 0 then
      local v = SceneUtils.TileIndexToWorld(self.curIndex, ForceChangeScene.World, self.curServerId) + BlockPos
      self.epidemicSkillSelect.transform:Set_position(v.x + halfSize, v.y, v.z + halfSize)
    else
      self.epidemicSkillSelect.transform:Set_position(halfSize, 0, halfSize)
    end
    self.epidemicSkillRangePoints = BattleFieldUtil.GetRangePoints(self.curIndex, halfSize / 2)
    self:RefreshMainBuildInSkillRange()
  end
  if self:BAllianceSkill() then
    self:RefreshAllianceInSkillRange()
  end
end

local function ChangeIndex(self, index, _putState)
  self.curIndex = index
  local lastPutState = self.putState
  self.moveToMeteoriteAct = DataCenter.ActMeteoriteBattleManager:TriggerFreeMoveCity(index, self.curServerId)
  local canMove, tempState = false, _putState
  if _putState == nil then
    ProfilerUtil.BeginSample("UIMoveCityView.TryChangeUseItem")
    canMove, tempState = self:TryChangeUseItem()
    canMove = canMove or self.moveToMeteoriteAct
    ProfilerUtil.EndSample()
  end
  if canMove then
    ProfilerUtil.BeginSample("BuildingUtils.IsCanPutDownByBuild")
    if self:BEpidemicSkill() and self.curIndex == LuaEntry.Player:GetMainWorldPos() then
      self.putState = BuildPutState.Ok
    elseif self:BAllianceSkill() then
      local curServerId = LuaEntry.Player:GetSelfServerId()
      local isSampGroup = SeasonUtil.IsInSameGroup(curServerId, ServerEnum.Source)
      if curServerId ~= self.curServerId or not isSampGroup then
        self.putState = BuildPutState.None
      elseif self.curIndex == LuaEntry.Player:GetMainWorldPos() then
        self.putState = BuildPutState.Ok
      else
        self.putState = BuildingUtils.IsCanPutDownByBuild(self.param.buildId, index, self.param.buildUuid, nil, self.curServerId)
      end
    else
      self.putState = BuildingUtils.IsCanPutDownByBuild(self.param.buildId, index, self.param.buildUuid, nil, self.curServerId)
    end
    ProfilerUtil.EndSample()
  else
    self.putState = tempState
  end
  self:RefreshNoReason(lastPutState ~= self.putState, lastPutState == BuildPutState.None or lastPutState == BuildPutState.Ok ~= (self.putState == BuildPutState.Ok))
  self:RefreshBuildSelect()
  self:RefreshCrossServerTip()
  self:ShowBlock()
  DataCenter.BuildZoneManager:ChangePos(self.curIndex)
  if index ~= 0 then
    local pos = SceneUtils.IndexToTilePos(index, ForceChangeScene.World)
    self.xy:InitState(pos.x, pos.y, self.curServerId)
  end
end

local function TryChangeUseItem(self)
  if self:BEpidemicSkill() or self:BAllianceSkill() then
    return true
  end
  local loginServerId = LuaEntry.Player:GetSelfServerId()
  local mySourceServerId = LuaEntry.Player:GetSourceServerId()
  local tryMoveToServerId = self.curServerId
  local seasonInfo = SeasonUtil.GetSeasonInfo(tryMoveToServerId)
  local isInSeason = false
  local seasonType = SeasonMapType.Nothing
  if seasonInfo ~= nil then
    isInSeason = seasonInfo:ServerInReady() and seasonInfo:InNormalMode()
    seasonType = seasonInfo:GetServerType(false)
  end
  local jumpToParam = CrossServerUtil.GetLastJumpToParam()
  if jumpToParam and jumpToParam.mode == JumpServerMode.CrossServerMoveCity and tryMoveToServerId ~= loginServerId then
    local isBigMapMode, curSameGroup, srcSameGroup, loginSameGroup = SeasonUtil.InSeasonBigMapMode(tryMoveToServerId)
    if isBigMapMode and loginSameGroup and isInSeason then
      if SceneUtils.IsInBlackOrYellowLand(self.curIndex, tryMoveToServerId) then
        local cur, max = DataCenter.MasteryManager:GetStorageSkillCountByType(MasterySkill.BlackLandMoveCity)
        if 0 < cur then
          self.costType = CostType.BlackLandFreeMoveSkill
          self.skill = {cur = cur, max = max}
          self:SetBuildInfo()
          return true
        end
      end
      local cur, max = DataCenter.MasteryManager:GetStorageSkillCountByType(MasterySkill.SeniorFreeMoveCity)
      if 0 < cur then
        self.costType = CostType.SeniorFreeMoveSkill
        self.item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_MOVE_CITY)
        self.skill = {cur = cur, max = max}
        self:SetBuildInfo()
        return true
      end
      cur, max = DataCenter.MasteryManager:GetStorageSkillCountByType(MasterySkill.FreeMoveCity)
      if 0 < cur then
        self.costType = CostType.FreeMoveSkill
        self.item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_MOVE_CITY)
        self.skill = {cur = cur, max = max}
        self:SetBuildInfo()
        return true
      end
      self.costType = CostType.Item
      self.skill = nil
      self.item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_MOVE_CITY)
      self:SetBuildInfo()
      local hasItem = self.item and 0 < self.item.count
      if hasItem then
        return true
      else
        return false, BuildPutState.ItemLack
      end
    end
    self.costType = CostType.FreeCrossServerWithCD
    self.item = nil
    self:SetBuildInfo()
    return self.theCrossMoveCD == nil
  elseif not BattleFieldUtil.InBattleField() and not LuaEntry.Player:IsInSelfServer() then
    return true
  end
  if self.param.topType ~= PlaceBuildType.MoveCity and self.param.topType ~= PlaceBuildType.MoveCity_Cmn and self.param.topType ~= PlaceBuildType.MoveCity_Al then
    return true
  end
  local isDragonWorld = BattleFieldUtil.InBattleField()
  if isDragonWorld then
    local data = BattleFieldUtil.CoolData() or {}
    local coolTime = tonumber(data.coolTime) or 0
    if coolTime <= UITimeManager:GetInstance():GetServerTime() then
      return true
    end
    return false, BuildPutState.OnDragonMoveCityCD
  end
  self.costType = CostType.Item
  self.useFreeAlMove = false
  local canMove, tempState = self:CheckItem()
  if not canMove then
    return canMove, tempState
  end
  if DataCenter.SeasonHunterManager:IsInBattle() then
    self.costType = CostType.WerewolfFreeMoveSkill
    local isLearned = DataCenter.MasteryManager:GetUnlockedSkillTemplateByType(MasterySkill.WerewolfMoveCity)
    if isLearned then
      local cur, max = DataCenter.MasteryManager:GetStorageSkillCountByType(MasterySkill.WerewolfMoveCity)
      if 0 < cur then
        self.skill = {cur = cur, max = max}
        self:SetBuildInfo()
        return true
      else
        return false, BuildPutState.WerewolfMCCD
      end
    else
      return false, BuildPutState.WerewolfCantUseMCItem
    end
  end
  if 0 < DataCenter.LandlordMgr:GetFreeMoveInfoEndTime() and DataCenter.LandlordMgr:GetFreeMoveInfoEndTime() < UITimeManager:GetInstance():GetServerTime() and tryMoveToServerId == DataCenter.LandlordMgr:GetCenterServerId() and DataCenter.LandlordMgr:IsInBattle() then
    self.costType = CostType.LandlordFreeMoveWithCD
    self:SetBuildInfo()
    return true
  end
  if SceneUtils.IsInBlackOrYellowLand(self.curIndex, tryMoveToServerId) then
    local cur, max = DataCenter.MasteryManager:GetStorageSkillCountByType(MasterySkill.BlackLandMoveCity)
    if 0 < cur then
      self.costType = CostType.BlackLandFreeMoveSkill
      self.skill = {cur = cur, max = max}
      self:SetBuildInfo()
      return true
    end
  end
  local cur, max = DataCenter.MasteryManager:GetStorageSkillCountByType(MasterySkill.SeniorFreeMoveCity)
  if 0 < cur then
    self.costType = CostType.SeniorFreeMoveSkill
    self.skill = {cur = cur, max = max}
    self:SetBuildInfo()
    return true
  end
  cur, max = DataCenter.MasteryManager:GetStorageSkillCountByType(MasterySkill.FreeMoveCity)
  if 0 < cur then
    self.costType = CostType.FreeMoveSkill
    self.skill = {cur = cur, max = max}
    self:SetBuildInfo()
    return true
  end
  self:SetBuildInfo()
  local hasItem = self.useFreeAlMove or self.item and 0 < self.item.count
  if hasItem then
    return true
  else
    return false, BuildPutState.ItemLack
  end
end

function UIMoveCityView:CheckItem()
  local useItemId
  if self.param.topType == PlaceBuildType.MoveCity_Al then
    useItemId = SpecialItemId.ITEM_ALLIANCE_CITY_MOVE
  elseif self.param.topType == PlaceBuildType.MoveCity_Cmn then
    useItemId = SpecialItemId.ITEM_MOVE_CITY
  end
  local hasAlTerritory = DataCenter.WorldAllianceCityDataManager:CheckIfHasAlCity()
  local isAlTerritory = DataCenter.WorldAllianceCityDataManager:CheckIfIsAlTerritory(self.curIndex)
  if useItemId then
    self.item = DataCenter.ItemData:GetItemById(useItemId)
    if useItemId == SpecialItemId.ITEM_ALLIANCE_CITY_MOVE then
      if hasAlTerritory then
        if not isAlTerritory then
          self:SetBuildInfo()
          return false, BuildPutState.NotInAlArea
        end
      elseif not DataCenter.AllianceBaseDataManager:CheckIfCanAlMove(self.curIndex) then
        self:SetBuildInfo()
        return false, BuildPutState.NotInAlArea
      end
    end
  elseif hasAlTerritory and isAlTerritory then
    self.item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_ALLIANCE_CITY_MOVE)
    if not self.useFreeAlMove and (not self.item or self.item.count == 0) then
      self.item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_MOVE_CITY)
    end
  else
    self.item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_MOVE_CITY)
  end
  return true
end

local function UIPlaceBuildChangePosSignal(self, data, forceCheck)
  if data ~= nil and data ~= "" then
    local theType = type(data)
    if theType == "number" then
      local pointId = tonumber(data)
      if self.curIndex ~= pointId or forceCheck == true then
        ProfilerUtil.BeginSample("UIMoveCityView.ChangeIndex")
        self.curWorldPos = nil
        self:ChangeIndex(pointId)
        ProfilerUtil.EndSample()
      end
    elseif (theType == "userdata" or theType == "table") and data.x ~= nil and data.y ~= nil and data.z ~= nil then
      local seasonInfo = SeasonUtil.GetSeasonInfo(self.curServerId)
      local pointId = SceneUtils.WorldToTileIndex(data, ForceChangeScene.World)
      self.curWorldPos = data
      if seasonInfo and seasonInfo.isSingleServerMode then
        local mapIndex1 = seasonInfo:GetNinePalacesIndexByWorldPos(data)
        local mapIndex2 = seasonInfo:GetNinePalacesIndex(self.curServerId)
        if mapIndex1 ~= mapIndex2 then
          local tilePos = SceneUtils.WorldToTile(data)
          self:ChangeIndex(pointId, BuildPutState.StaticPoint)
          self.xy:InitState(tilePos.x, tilePos.y, "???")
          return
        end
      end
      if data.x <= 0 or data.z <= 0 or self.inS5BigMap and (data.x >= 6000 or data.z >= 6000) or not self.inS5BigMap and (data.x >= 2000 or data.z >= 2000) then
        if self.inS5BigMap then
          local mapIndex = seasonInfo:GetNinePalacesIndexByWorldPos(data)
          local serverId = seasonInfo:GetNinePalacesServer(mapIndex)
          self.curServerId = serverId
        end
        local tilePos = SceneUtils.WorldToTile(data)
        self:ChangeIndex(pointId, BuildPutState.StaticPoint)
        self.xy:InitState(tilePos.x, tilePos.y, self.curServerId)
        return
      end
      if self.curIndex ~= pointId or forceCheck == true then
        if self.inS5BigMap then
          local mySourceServerId = LuaEntry.Player:GetSourceServerId()
          local loginServerId = LuaEntry.Player:GetSelfServerId()
          local mapIndex = seasonInfo:GetNinePalacesIndexByWorldPos(data)
          local serverId = seasonInfo:GetNinePalacesServer(mapIndex)
          seasonInfo = SeasonUtil.GetSeasonInfo(serverId)
          if self.curServerId ~= serverId and self.inS5BigMap then
            CrossServerUtil.SetLastJumpToParam({
              mode = JumpServerMode.CrossServerMoveCity,
              type = MoveCrossServerType.BigMap3000,
              serverId = serverId
            })
          end
          self.curServerId = serverId
          local theCrossServerReason = CrossServerUtil.GetCrossEnableReason(serverId)
          if (self.srcSameGroup or self.loginSameGroup) and seasonInfo ~= nil and serverId ~= loginServerId and serverId ~= mySourceServerId and theCrossServerReason == CanCrossServerReason.Global then
            local curTime = UITimeManager:GetInstance():GetServerTime()
            local YES, timeOpen = seasonInfo:CanMoveCityTo(mapIndex)
            if not YES and timeOpen ~= nil and timeOpen ~= 0 and curTime < timeOpen then
              local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(timeOpen - curTime)
              UIUtil.ShowTips(Localization:GetString("s5_cross_tips01", timeStr))
              ProfilerUtil.BeginSample("UIMoveCityView.ChangeIndex")
              self:ChangeIndex(pointId, BuildPutState.OnLandLock)
              self.timeOpen = timeOpen
              ProfilerUtil.EndSample()
              return
            end
          end
        end
        ProfilerUtil.BeginSample("UIMoveCityView.ChangeIndex")
        self:ChangeIndex(pointId)
        ProfilerUtil.EndSample()
      end
    end
  end
end

local function RefreshNoReason(self, isChangeReason, isChangeOk)
  if isChangeOk then
    if self.putState == BuildPutState.Ok then
      self.confirm_btn:SetInteractable(true)
      self.confirm_img:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm")
    else
      self.confirm_btn:SetInteractable(true)
      self.confirm_img:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm_gray")
    end
  end
  if isChangeReason then
    local str = ""
    if self.putState == BuildPutState.Ok then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.CAN_PUT)
    elseif self.putState == BuildPutState.Building then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.INCLUDE_BUILDING)
    elseif self.putState == BuildPutState.OnGhostrecon then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.INCLUDE_BUILDING)
    elseif self.putState == BuildPutState.WorldBoss then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.MONSTER)
    elseif self.putState == BuildPutState.HasCityStrongholdMonster then
      str = Localization:GetString("120893")
    elseif self.putState == BuildPutState.WorldMonster then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.MONSTER)
    elseif self.putState == BuildPutState.Collect then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.INCLUD_MINEPOINT)
    elseif self.putState == BuildPutState.CollectRange then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.INCLUDE_MINERANGE_POINT)
    elseif self.putState == BuildPutState.OtherCollectRange then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.INCLUDE_OTHER_MINERANGE_POINT)
    elseif self.putState == BuildPutState.NoCollectRange then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.RESOURCE_BUILD_PUT_MINERANGE_POINT)
    elseif self.putState == BuildPutState.StaticPoint then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.NO_PUT_RANGE)
    elseif self.putState == BuildPutState.Board then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.INCLUDE_MY_ROAD)
    elseif self.putState == BuildPutState.OutMyRange then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.OUT_MYBASE_RANGE)
    elseif self.putState == BuildPutState.InOtherBaseRange then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.IN_OTHERBASE_RANGE)
    elseif self.putState == BuildPutState.OutUnlockRange then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.OUT_UNLOCK_RANGE_REASON)
    elseif self.putState == BuildPutState.CollectTimeOver then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.COLLECT_RESOURCE_DESTROY)
    elseif self.putState == BuildPutState.OutMyInside then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.ONLY_IN_INSIDE)
    elseif self.putState == BuildPutState.OutMainSubRange then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.ONLY_IN_MAIN_INSIDE)
    elseif self.putState == BuildPutState.OnBaseExpansion then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.NOT_BUILD_ON_BASE_EXPANSION)
    elseif self.putState == BuildPutState.OnWorldResource then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.NOT_BUILD_ON_WORLD_RESOURCE)
    elseif self.putState == BuildPutState.OnlyBuildRoad then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.ONLY_BUILD_ROAD)
    elseif self.putState == BuildPutState.MONSTER_REWARD then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.NO_PUT_MONSTER_REWARD)
    elseif self.putState == BuildPutState.OnGarbage then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.NO_PUT_GARBAGE)
    elseif self.putState == BuildPutState.InMyInside then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.ONLY_OUT_INSIDE)
    elseif self.putState == BuildPutState.OnLandLock then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.LOCK)
    elseif self.putState == BuildPutState.PveMonster then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.BUILD_INCLUDE_PVE_MONSTER)
    elseif self.putState == BuildPutState.OutBuildZone then
      str = Localization:GetString(GameDialogDefine.NEED_PUT_IN, DataCenter.CityZoneManager:GetZoneName(self.buildTemplate.zoneType))
    elseif self.putState == BuildPutState.ItemLack then
      str = Localization:GetString("120021")
    elseif self.putState == BuildPutState.WerewolfCantUseMCItem then
      str = Localization:GetString("season_mastery_s4_tips_11")
    elseif self.putState == BuildPutState.WerewolfMCCD then
      str = Localization:GetString("season_mastery_s4_tips_17")
    elseif self.putState == BuildPutState.NotInAlArea then
      str = Localization:GetString("120294")
    elseif self.putState == BuildPutState.OnDragonMoveCityCD then
      str = Localization:GetString("458289")
    elseif self.putState == BuildPutState.NotEmptyDesert then
      str = Localization:GetString("season_tips150")
    end
    if self.putState == BuildPutState.Ok then
      self.reason_text:SetText(str)
      self.reason_text:SetActive(true)
      self.reason_red_text:SetActive(false)
    else
      self.reason_red_text:SetText(str)
      self.reason_text:SetActive(false)
      self.reason_red_text:SetActive(true)
    end
  end
end

local function UpdatePointDataSignal(self)
  ProfilerUtil.BeginSample("UIMoveCityView:UpdatePointDataSignal")
  if self.inS5BigMap and self.curServerId then
    if self.curWorldPos then
      self:UIPlaceBuildChangePosSignal(self.curWorldPos, true)
    else
      local willPos = SceneUtils.TileIndexToWorld(self.curIndex, ForceChangeScene.World, self.curServerId)
      self:UIPlaceBuildChangePosSignal(willPos, true)
    end
  else
    self:ChangeIndex(self.curIndex)
  end
  ProfilerUtil.EndSample()
end

local function ChangeSelectBuild(self)
  if CS.SceneManager.World.SelectBuild ~= nil then
    self.AutoAdjustScreenPos:Init(CS.SceneManager.World.SelectBuild.transform, TilePosDelta[self.tile])
    if self.param then
      if self.param.topType == PlaceBuildType.Move then
        DataCenter.BuildZoneManager:ShowZoneEffect(self.param.buildUuid, self.param.buildId, self.curIndex)
      elseif self.param.topType == PlaceBuildType.Build or self.param.topType == PlaceBuildType.Replace then
        DataCenter.BuildZoneManager:ShowZoneEffect(FakeBuildUuid, self.param.buildId, self.curIndex)
      end
    end
  end
end

local function RefreshCrossServerTip(self)
  if SceneUtils.GetIsInWorld() then
    if self.inS5BigMap or not LuaEntry.Player:AtHomeNow() then
      self.crossServerTip:SetActive(true)
      self.crossServerTipText:SetLocalText(500003, self.curServerId)
    else
      self.crossServerTip:SetActive(false)
    end
  else
    self.crossServerTip:SetActive(false)
  end
end

function UIMoveCityView:RefreshCameraPoint()
end

function UIMoveCityView:SetFloatNotice(label)
  if IsNull(self.topFloatNoticeNode) then
    return
  end
  if label then
    self.tmp_float_notice:SetText(label)
    self.topFloatNoticeNode:SetActive(true)
  else
    self.topFloatNoticeNode:SetActive(false)
  end
end

function UIMoveCityView:HideBg()
end

function UIMoveCityView:Update1000MS()
  if self.timeOpen then
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime >= self.timeOpen then
      self.timeOpen = nil
      self:UpdatePointDataSignal()
    end
  end
  if self.lock then
    return
  end
  self.lock = true
  if self.costType == CostType.WerewolfFreeMoveSkill then
    local skillTemp = DataCenter.MasteryManager:GetUnlockedSkillTemplateByType(MasterySkill.WerewolfMoveCity)
    if skillTemp then
      local cur, max, ts = DataCenter.MasteryManager:GetStorageSkillCount(skillTemp.id)
      local now = UITimeManager:GetInstance():GetServerTime()
      local countdown = 0
      if ts then
        countdown = math.max(0, math.ceil((ts - now) / 1000))
      end
      self.build_name:SetLocalText("season_mastery_s4_tips_15", cur, max, countdown)
      if 0 < cur and self.oldCur and 0 >= self.oldCur then
        self:UpdatePointDataSignal()
      end
      self.oldCur = cur
    end
  end
  self.moveToMeteoriteAct = DataCenter.ActMeteoriteBattleManager:TriggerFreeMoveCity(self.curIndex, self.curServerId)
  if self.theCrossMoveCD and 0 < self.theCrossMoveCD then
    self.cd_tip:SetActive(true)
    self.topFloatNoticeNode:SetActive(false)
    local msg = Localization:GetString("battle_card_cd_type1")
    local now = UITimeManager:GetInstance():GetServerTime()
    if now < self.theCrossMoveCD then
      self.cd_time:SetText(msg .. "\n" .. UITimeManager:GetInstance():MilliSecondToFmtString(self.theCrossMoveCD - now))
    else
      self.theCrossMoveCD = nil
      self.cd_tip:SetActive(false)
      if self.costType == CostType.LandlordFreeMoveWithCD then
        self:SetFloatNotice(Localization:GetString("zonewar_landlord_guide_desc_10015"))
        self.build_name:SetLocalText("121059")
      else
        self:SetFloatNotice(Localization:GetString("alliance_duel_tips10031"))
        self.build_name:SetLocalText("s5_cross_ui05")
      end
      self:ChangeIndex(self.curIndex, self.putState)
    end
  elseif self.moveToMeteoriteAct then
    self:RefreshMeteoriteFree()
  else
    self.cd_tip:SetActive(false)
  end
  self.lock = false
end

function UIMoveCityView:RefreshMeteoriteFree()
  local moveCityItemCount = DataCenter.ItemData:GetItemCount(SpecialItemId.ITEM_MOVE_CITY)
  local strName = Localization:GetString("110230", moveCityItemCount)
  local strDesc = Localization:GetString("110231")
  self.build_name:SetText(strName)
  self.build_des:SetText(strDesc)
  self:SetFloatNotice(Localization:GetString("yuntieBattle_interface_1044"))
end

function UIMoveCityView:LoadEpidemic()
  if self:BEpidemicSkill() then
    if self.epidemicSkillSelect == nil then
      local actMgr = DataCenter.ActEpidemicZoneManager
      local skillId = actMgr:GetCurSkillId()
      local template = actMgr:GetTemplateSkillById(skillId)
      local range = 0
      if template then
        range = template.range or 0
      end
      if 0 < range then
        self.epidemicSkillRange = range * 2 + 1
        do
          local path = UIAssets.EpidemicSkillRangeBlue
          self:GameObjectInstantiateAsync(path, function(request)
            if request.isError then
              return
            end
            local go = request.gameObject
            if go ~= nil then
              go:SetActive(true)
              go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
              self.epidemicSkillSelect = go:GetComponent(typeof(CS.BuildSelect))
              self.epidemicSkillSelect:SetCloneRange(range * 2 + 1)
              self.epidemicSkillSelect:ChangeColor(true)
              self.epidemicSkillSelect:ChangeColor(false)
              self:RefreshBuildSelect()
            end
          end)
        end
      end
    end
  elseif self.epidemicSkillSelect then
    self.epidemicSkillSelect.gameObject:SetActive(false)
  end
end

function UIMoveCityView:BEpidemicSkill()
  if not BattleFieldUtil.InBattleField(BattleFieldType.EpidemicZone) then
    return false
  end
  if self.param.topType == PlaceBuildType.EpidemicSkill then
    return true
  end
  local leftTime = self:EpidemicSkillLeftTime()
  return 0 < leftTime
end

function UIMoveCityView:EpidemicSkillLeftTime()
  return DataCenter.ActEpidemicZoneManager:EpidemicSkillLeftTime()
end

local _PREFAB_EPIDEMIC_SKILL = "Assets/Main/Prefabs/UI/BF_Epidemic/Common/UIMoveCityEpidemicSkill.prefab"

function UIMoveCityView:SetEpidemicShow(bShow)
  local curCell = self.epidemic_skill
  local miniMap = self.epidemic_miniMap
  if not bShow then
    if curCell and curCell:AsyncLoadDone() then
      curCell:SetActive(false)
    end
    if miniMap and miniMap:AsyncLoadDone() then
      miniMap:SetActive(false)
    end
    return
  end
  if curCell then
    if curCell:AsyncLoadDone() then
      curCell:SetActive(true)
      curCell:RefreshView()
      curCell:SetTipText(self.curEpidemicTargetCnt and self.curEpidemicTargetCnt > 0)
    end
    if miniMap and miniMap:AsyncLoadDone() then
      miniMap:SetActive(true)
    end
    return
  end
  local cls = require("UI.UIMoveCity.Component.MoveCityEpidemicSkill")
  local height = self.rectTransform.rect.height
  self.epidemic_skill = self:LoadComponentAsync(cls, _PREFAB_EPIDEMIC_SKILL, self, function(_, go)
    local rectTF = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTF ~= nil then
      rectTF:Set_localPosition(0, -height * 0.5 + 10, 0)
    end
    if self:BEpidemicSkill() then
      self.epidemic_skill:SetTipText(self.curEpidemicTargetCnt and 0 < self.curEpidemicTargetCnt)
    else
      self:ReInit()
    end
  end)
  self.epidemic_miniMap = BattleFieldUtil.CreateMiniMap(BattleFieldType.EpidemicZone, self, self, function()
    if not self:BEpidemicSkill() then
      self:ReInit()
    end
  end)
end

local PREFAB_EPIDEMIC_SKILL_TIP = "Assets/Main/Prefabs/World/BF_Epidemic/BattleFieldEpidemicSkillTip.prefab"

function UIMoveCityView:ShowEpidemicEff(uid, pointId)
  local skillId = DataCenter.ActEpidemicZoneManager:GetCurSkillId()
  local eff = self.epidemicEff[uid]
  if eff then
    eff:SetShow(skillId, pointId, self.curIndex)
    return
  end
  if self.epidemicEffHandle[uid] then
    return
  end
  local handle = CS.GameEntry.Resource:InstantiateAsync(PREFAB_EPIDEMIC_SKILL_TIP)
  self.epidemicEffHandle[uid] = handle
  handle:completed("+", function(req)
    if req.isError then
      return
    end
    if not SceneUtils.GetIsInWorld() then
      req:Destroy()
      return
    end
    local go = req.gameObject
    local tf = go.transform
    go.name = "SKILL_TIP_" .. uid
    local parent = CS.SceneManager.World.DynamicObjNode
    tf:SetParent(parent)
    local cls = require("UI.UIMoveCity.Component.MoveCityEpidemicSkillEff")
    eff = cls.New()
    self.epidemicEff[uid] = eff
    eff:OnCreate(go)
    local bShow = BattleFieldUtil.CheckBuildInSkillRange(pointId, self.mainRange, self.epidemicSkillRangePoints)
    if bShow then
      eff:SetShow(skillId, pointId, self.curIndex)
    else
      eff:HideSelf()
    end
  end)
end

function UIMoveCityView:OnLodChange()
  if BattleFieldUtil.InBattleField() then
    return
  end
  local curLod = DisplaySettings.currentLod
  if self.miniMap then
    self.miniMap:SetActive(2 < curLod)
  end
end

function UIMoveCityView:RefreshMainBuildInSkillRange()
  local cnt, points = DataCenter.ActEpidemicZoneManager:CheckCntInSkillRange(self.curIndex, self.mainRange, self.epidemicSkillRangePoints)
  self.curEpidemicTargetCnt = cnt
  if self.epidemic_skill and self.epidemic_skill:AsyncLoadDone() then
    self.epidemic_skill:SetTipText(self.curEpidemicTargetCnt > 0)
  end
  if 0 < cnt then
    for uid, index in pairs(points) do
      self:ShowEpidemicEff(uid, index)
    end
  end
  for uid, v in pairs(self.epidemicEff) do
    if not points[uid] then
      v:HideSelf()
    end
  end
end

function UIMoveCityView:BAllianceSkill()
  if self.param == nil then
    return false
  end
  if self.param.allianceSkillId == nil then
    return false
  end
  return DataCenter.AllianceGovernmentCommonSkillManager:IsGovernmentCommonSkill(self.param.allianceSkillId, true)
end

function UIMoveCityView:SetAllianceSkillShow(bShow)
  local curCell = self.alliance_skill
  if not bShow then
    if curCell and curCell:AsyncLoadDone() then
      curCell:SetActive(false)
    end
    return
  end
  if curCell then
    if curCell:AsyncLoadDone() then
      curCell:SetActive(true)
      curCell:RefreshView()
    end
    return
  end
  local height = self.rectTransform.rect.height
  local prefabAllianceSkill = "Assets/Main/SeasonRes/Shared/Prefabs/UI/AllianceSkill/UIMoveCityAllianceSkill.prefab"
  local prefabCls = require("UI.LWSeasonShared.UIAllianceCommonSkill.Component.UIMoveCityAllianceSkill")
  self.alliance_skill = self:LoadComponentAsync(prefabCls, prefabAllianceSkill, self, function(_, go)
    local rectTF = go:GetComponent(typeof(CS.UnityEngine.RectTransform))
    if rectTF ~= nil then
      rectTF:Set_localPosition(0, -height * 0.5 + 10, 0)
    end
    if self:BAllianceSkill() then
      self.alliance_skill:SetTipText(self.curAllianceSkillTargetCnt and 0 < self.curAllianceSkillTargetCnt)
    else
      self:ReInit()
    end
  end)
end

function UIMoveCityView:RefreshAllianceInSkillRange()
  local skillConfig = DataCenter.AllianceGovernmentSkillManager:GetTemplatesById(self.param.allianceSkillId)
  if not skillConfig then
    return
  end
  if self.param and self.param.allianceSkillId then
    local effectScope = skillConfig.effect_scope
    local cnt, points = DataCenter.AllianceGovernmentCommonSkillManager:CheckCntInSkillRange(self.curIndex, self.curServerId, effectScope, self.mainRange)
    self.curAllianceSkillTargetCnt = cnt
    if self.alliance_skill and self.alliance_skill:AsyncLoadDone() then
      self.alliance_skill:SetTipText(self.curAllianceSkillTargetCnt > 0)
    end
    if 0 < cnt then
      local unityConfig = DataCenter.AllianceSkillManager:GetAllianceUnityConfigBySkillId(self.param.allianceSkillId)
      for uid, pointInfo in pairs(points) do
        if unityConfig then
          self:ShowAllianceEff(uid, pointInfo, skillConfig, unityConfig:GetLuaData())
        end
      end
    end
    for uid, v in pairs(self.allianceEff) do
      if not points[uid] then
        v:HideSelf()
      end
    end
  end
end

function UIMoveCityView:ShowAllianceEff(uid, pointInfo, config, luaData)
  local eff = self.allianceEff[uid]
  if eff then
    eff:SetShow(pointInfo, self.curIndex, self.curServerId)
    return
  end
  if self.allianceEffHandle[uid] then
    return
  end
  local handle = CS.GameEntry.Resource:InstantiateAsync(luaData.PrefabAlliancePreEffect)
  self.allianceEffHandle[uid] = handle
  handle:completed("+", function(req)
    if req.isError then
      return
    end
    if not SceneUtils.GetIsInWorld() then
      req:Destroy()
      return
    end
    local go = req.gameObject
    local tf = go.transform
    go.name = "SKILL_TIP_" .. uid
    local parent = CS.SceneManager.World.DynamicObjNode
    tf:SetParent(parent)
    local cls = require(luaData.PrefabAlliancePreEffectCls)
    eff = cls.New()
    self.allianceEff[uid] = eff
    eff:OnCreate(go)
    local effectScope = config.effect_scope
    local bShow = DataCenter.AllianceGovernmentCommonSkillManager:CheckDistanceInEffectScope(self.curIndex, pointInfo.pointId, pointInfo.serverId, effectScope, self.curServerId)
    if bShow then
      eff:SetShow(pointInfo, self.curIndex, self.curServerId)
    else
      eff:HideSelf()
    end
  end)
end

UIMoveCityView.RefreshCrossServerTip = RefreshCrossServerTip
UIMoveCityView.OnCreate = OnCreate
UIMoveCityView.OnDestroy = OnDestroy
UIMoveCityView.OnEnable = OnEnable
UIMoveCityView.OnDisable = OnDisable
UIMoveCityView.OnAddListener = OnAddListener
UIMoveCityView.OnRemoveListener = OnRemoveListener
UIMoveCityView.ComponentDefine = ComponentDefine
UIMoveCityView.ComponentDestroy = ComponentDestroy
UIMoveCityView.DataDefine = DataDefine
UIMoveCityView.DataDestroy = DataDestroy
UIMoveCityView.ReInit = ReInit
UIMoveCityView.ClosePanel = ClosePanel
UIMoveCityView.OnConfirmBtnClick = OnConfirmBtnClick
UIMoveCityView.OnCancelBtnClick = OnCancelBtnClick
UIMoveCityView.ShowBlock = ShowBlock
UIMoveCityView.RefreshBuildSelect = RefreshBuildSelect
UIMoveCityView.LoadBuildSelect = LoadBuildSelect
UIMoveCityView.UIPlaceBuildChangePosSignal = UIPlaceBuildChangePosSignal
UIMoveCityView.ChangeIndex = ChangeIndex
UIMoveCityView.TryChangeUseItem = TryChangeUseItem
UIMoveCityView.RefreshNoReason = RefreshNoReason
UIMoveCityView.UpdatePointDataSignal = UpdatePointDataSignal
UIMoveCityView.ShowOneBlock = ShowOneBlock
UIMoveCityView.ChangeSelectBuild = ChangeSelectBuild
UIMoveCityView.SetBuildInfo = SetBuildInfo
UIMoveCityView.ConfirmBtnClickFallback = ConfirmBtnClickFallback
UIMoveCityView.OnBackClick = OnBackClick
return UIMoveCityView
