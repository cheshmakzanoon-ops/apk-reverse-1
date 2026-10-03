local UIPlaceWorldBuildView = BaseClass("UIPlaceWorldBuildView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local WorldPlaceItem = require("UI.UISearch.Component.WorldPlaceItem")
local confirm_btn_path = "BtnGo/common_btn_confirm"
local cancel_btn_path = "BtnGo/common_btn_cancel"
local reason_text_path = "common_bg3/reason_text"
local reason_red_text_path = "common_bg3/reason_red_text"
local des_bg_path = "common_bg3"
local btn_go_path = "BtnGo"
local build_icon_path = "common_bg3/build_icon"
local build_name_path = "common_bg3/build_name"
local build_des_path = "common_bg3/build_des"
local back_btn_path = "common_bg3/back_btn"
local wormHoleTips_img_path = "Img_WormHole"
local wormHoleTips_txt_path = "Img_WormHole/Txt_WormHoleTips"
local xy_path = "common_bg3/WorldPlaceItem"

function UIPlaceWorldBuildView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIPlaceWorldBuildView:OnDestroy()
  if self.param ~= nil and (self.param.buildId == BuildingTypes.CAMP_SEASON_MISSILE or self.param.buildId == BuildingTypes.CAMP_TeslaCoil or self.param.buildId == BuildingTypes.CAMP_Reinforcement) then
    local theWorld = CS.SceneManager.World
    if theWorld then
      CS.SceneManager.World:SetCameraLodRange(false, 1, 7)
    end
  end
  self:ClosePanel()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIPlaceWorldBuildView:ComponentDefine()
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_img = self:AddComponent(UIImage, confirm_btn_path)
  self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
  self.reason_text = self:AddComponent(UIText, reason_text_path)
  self.build_icon = self:AddComponent(UIImage, build_icon_path)
  self.build_name = self:AddComponent(UIText, build_name_path)
  self.build_des = self:AddComponent(UIText, build_des_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.des_bg = self.transform:Find(des_bg_path).gameObject
  self.reason_red_text = self:AddComponent(UIText, reason_red_text_path)
  self.AutoAdjustScreenPos = self.transform:Find(btn_go_path):GetComponent(typeof(CS.AutoAdjustScreenPos))
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
  self._wormHoleTips_img = self:AddComponent(UIBaseContainer, wormHoleTips_img_path)
  self._wormHoleTips_txt = self:AddComponent(UIText, wormHoleTips_txt_path)
  self.xy = self:AddComponent(WorldPlaceItem, xy_path)
  self.xy:SetActive(not BattleFieldUtil.InBattleField())
end

function UIPlaceWorldBuildView:ComponentDestroy()
  self.xy:SetActive(false)
  self.confirm_btn = nil
  self.cancel_btn = nil
  self.reason_text = nil
  self.AutoAdjustScreenPos = nil
  self.confirm_img = nil
  self.build_icon = nil
  self.build_name = nil
  self.build_des = nil
  self.back_btn = nil
  self.reason_red_text = nil
end

function UIPlaceWorldBuildView:DataDefine()
  self.param = nil
  self.isInGuide = false
  self.curIndex = 0
  self.noPutPoint = {}
  self.useMainBuildGreen = {}
  self.freeMainBuildGreen = {}
  self.putState = BuildPutState.None
  self.buildTemplate = nil
  self.needPosFree = {}
  self.needDoCancelFunction = true
  self.sendCount = 0
  self.allPoint = nil
end

function UIPlaceWorldBuildView:DataDestroy()
  WorldAlCenterSelectEffectManager:GetInstance():HidePos()
  PlaceAllianceCenterEffectManager:GetInstance():QuitPlaceAllianceCenterMode()
  DataCenter.BuildZoneManager:RemoveAll()
  DataCenter.BuildManager:SetShowPutBuildFromPanel(nil)
  self.allPoint = nil
  self.param = nil
  self.isInGuide = nil
  self.curIndex = nil
  self.noPutPoint = nil
  self.useMainBuildGreen = nil
  self.freeMainBuildGreen = nil
  self.putState = nil
  self.buildTemplate = nil
  self.needPosFree = nil
  self.needDoCancelFunction = false
  self.sendCount = nil
end

function UIPlaceWorldBuildView:OnEnable()
  base.OnEnable(self)
end

function UIPlaceWorldBuildView:OnDisable()
  base.OnDisable(self)
end

function UIPlaceWorldBuildView:ReInit()
  local curServerId = LuaEntry.Player:GetCurServerId()
  local worldPos = CS.SceneManager.World.curTouchPoint
  local seasonInfo = SeasonUtil.GetSeasonInfo(curServerId)
  if seasonInfo ~= nil and seasonInfo:GetServerType(false) == SeasonMapType.NineNation then
    local mapIndex = seasonInfo:GetNinePalacesIndexByWorldPos(worldPos)
    self.curServerId = seasonInfo:GetNinePalacesServer(mapIndex)
    self.inS5BigMap = SeasonUtil.InSeasonBigMapMode(self.curServerId)
  else
    self.curServerId = curServerId
    self.inS5BigMap = false
  end
  self.sendCount = 0
  self.needDoCancelFunction = true
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMain) then
    EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
  else
    DataCenter.GuideManager:SetNoShowUIMain(true)
  end
  local buildId, buildUuid, point, topType, serverId = self:GetUserData()
  if serverId ~= 0 and serverId ~= nil then
    self.curServerId = serverId
  end
  self.param = {}
  if buildId ~= nil and buildId ~= "" then
    self.param.buildId = tonumber(buildId)
  else
    self.param.buildId = 0
  end
  if buildUuid ~= nil and buildUuid ~= "" then
    self.param.buildUuid = tonumber(buildUuid)
  else
    self.param.buildUuid = 0
  end
  if point ~= nil and point ~= "" then
    self.param.point = tonumber(point)
  else
    self.param.point = 0
  end
  if topType ~= nil and topType ~= "" then
    self.param.topType = tonumber(topType)
  else
    self.param.topType = 0
  end
  CS.SceneManager.World:SetUseInput(false)
  if self.param.topType == PlaceBuildType.CityAttachment then
    self.allianceBuildTemplate = DataCenter.SeasonFarmerTemplateManager:GetBuildTemplateById(buildId)
  else
    self.allianceBuildTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
  end
  if self.allianceBuildTemplate then
    self.tile = self.allianceBuildTemplate.size or self.allianceBuildTemplate.resSize or 1
  end
  local mainBuildId, carrierBuildId = SeasonUtil.GetSeasonMilitaryCenterId()
  if self.param.topType == PlaceBuildType.CityAttachment then
    self._wormHoleTips_img:SetActive(false)
    self._wormHoleTips_txt:SetText("")
  elseif (buildId == mainBuildId or buildId == carrierBuildId or WorldAllianceBuildUtil.IsAllianceCenterFlag(buildId) or WorldAllianceBuildUtil.IsAllianceFrontGroup(buildId)) and self.allianceBuildTemplate ~= nil then
    self._wormHoleTips_img:SetActive(true)
    if SeasonUtil.IsInSeason() then
      local str = Localization:GetString("season_tips221", self.allianceBuildTemplate.level)
      if buildId == mainBuildId or buildId == carrierBuildId then
        str = Localization:GetString("season_s2_tips001", self.allianceBuildTemplate.level)
      end
      self._wormHoleTips_txt:SetText(str)
    else
      local str = Localization:GetString("803038", self.allianceBuildTemplate.level)
      self._wormHoleTips_txt:SetText(str)
    end
  elseif WorldAllianceBuildUtil.IsAllianceCenterGroup(buildId) and self.allianceBuildTemplate ~= nil then
    self._wormHoleTips_img:SetActive(true)
    local str = Localization:GetString("803038", self.allianceBuildTemplate.level)
    self._wormHoleTips_txt:SetText(str)
  else
    self._wormHoleTips_img:SetActive(false)
    self._wormHoleTips_txt:SetText("")
  end
  local willPos
  if point ~= nil and 0 < point then
    willPos = SceneUtils.TileIndexToWorld(point, ForceChangeScene.World, self.curServerId)
  else
    willPos = CS.SceneManager.World.CurTarget
  end
  self:ChangeIndex(SceneUtils.WorldToTileIndex(willPos))
  if buildId == BuildingTypes.CAMP_SEASON_MISSILE or self.param.buildId == BuildingTypes.CAMP_TeslaCoil or self.param.buildId == BuildingTypes.CAMP_Reinforcement then
    local theWorld = CS.SceneManager.World
    if theWorld then
      CS.SceneManager.World:SetCameraLodRange(true, 1, 5)
    end
  end
  if buildId == BuildingTypes.SEASON_ARES_MISSILE or buildId == BuildingTypes.SEASON_ARES_MISSILE_GLOBAL or buildId == BuildingTypes.SEASON_ARES_MISSILE_S4 or buildId == BuildingTypes.CAMP_SEASON_MISSILE or buildId == BuildingTypes.GODDESS_MUMMY_TARGET or buildId == BuildingTypes.CAMP_GODDESS_MUMMY_TARGET then
    GoToUtil.GotoWorldPos(willPos, 500, LookAtFocusTime, function()
    end, self.curServerId)
  elseif buildId == BuildingTypes.CAMP_Reinforcement then
    GoToUtil.GotoWorldPos(willPos, TeslaCoilSkillCameraHeight, LookAtFocusTime, function()
    end, self.curServerId)
  elseif self.param.topType ~= PlaceBuildType.CityAttachment then
    GoToUtil.GotoWorldPos(willPos, 105, LookAtFocusTime, function()
    end, self.curServerId)
  end
  if self.param.topType == PlaceBuildType.CityAttachment then
    GoToUtil.GotoWorldPos(willPos, 300, LookAtFocusTime, function()
    end, self.curServerId)
  else
    if WorldAllianceBuildUtil.IsAllianceCenterGroup(buildId) and self.allianceBuildTemplate ~= nil then
      local showEmpty = buildId == BuildingTypes.ALLIANCE_CENTER_1
      local list = self.allianceBuildTemplate.place_ruin_dic
      PlaceAllianceCenterEffectManager:GetInstance():EnterPlaceAllianceCenterMode(list, showEmpty)
    end
    self:LoadBuildSelect()
  end
  self:ChangeSelectBuild()
  self:SetBuildInfo()
end

function UIPlaceWorldBuildView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.UpdatePointDataSignal)
  self:AddUIListener(EventId.UICreateFakePlaceAllianceBuild, self.UICreateFakePlaceBuildSignal)
  self:AddUIListener(EventId.UIPlaceAllianceBuildChangePos, self.UIPlaceBuildChangePosSignal)
end

function UIPlaceWorldBuildView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.UpdatePointDataSignal)
  self:RemoveUIListener(EventId.UICreateFakePlaceAllianceBuild, self.UICreateFakePlaceBuildSignal)
  self:RemoveUIListener(EventId.UIPlaceAllianceBuildChangePos, self.UIPlaceBuildChangePosSignal)
end

function UIPlaceWorldBuildView:SetBuildInfo()
  if self.allianceBuildTemplate then
    local buildIcon = self.allianceBuildTemplate:GetIconPath(true)
    self.build_icon:LoadSpriteAuto(buildIcon)
    self.build_name:SetLocalText(self.allianceBuildTemplate.name)
    if self.param.topType == PlaceBuildType.CityAttachment then
      self.build_des:SetText(self.allianceBuildTemplate:GetDesc())
    else
      self.build_des:SetLocalText(self.allianceBuildTemplate.desc)
    end
    self.des_bg:SetActive(true)
  else
    self.des_bg:SetActive(false)
  end
end

function UIPlaceWorldBuildView:ClosePanel()
  EventManager:GetInstance():Broadcast(EventId.UpdateFakeBuildingPos)
  if CS.SceneManager.World ~= nil then
    CS.SceneManager.World:UIDestroyRreCreateAllianceBuild()
    CS.SceneManager.World:SetUseInput(true)
    CS.SceneManager.World:SetTouchInputControllerEnable(true)
    DataCenter.BuildBubbleManager:ShowBubbleNode()
    CS.SceneManager.World.touchPickablePos:Clear()
    CS.SceneManager.World.SelectBuild = nil
    CS.SceneManager.World:ResetCameraMaxHeight()
  end
end

function UIPlaceWorldBuildView:OnConfirmBtnClick()
  local buildId = self.param.buildId
  local thePointIndex = self.curIndex
  EventManager:GetInstance():Broadcast(EventId.OnClickPlaceBuild)
  if buildId == BuildingTypes.SEASON_ARES_MISSILE or buildId == BuildingTypes.SEASON_ARES_MISSILE_S4 then
    DataCenter.AllianceGovernmentSkillManager:UseSkill(AlOfficialSkillType.AresMissile, self.curIndex)
  elseif buildId == BuildingTypes.SEASON_ARES_MISSILE_GLOBAL then
    DataCenter.AllianceGovernmentSkillManager:UseSkill(AlOfficialSkillType.MissileFactory, self.curIndex)
  elseif buildId == BuildingTypes.CAMP_SEASON_MISSILE then
    DataCenter.AllianceGovernmentCommonSkillManager:UseSkill(AlOfficialSkillType.AresMissile, self.curIndex)
  elseif buildId == BuildingTypes.GODDESS_MUMMY_TARGET then
    DataCenter.AllianceGovernmentSkillManager:UseSkill(AlOfficialSkillType.GoddessMummy, self.curIndex)
  elseif buildId == BuildingTypes.CAMP_GODDESS_MUMMY_TARGET then
    DataCenter.AllianceGovernmentCommonSkillManager:UseSkill(AlOfficialSkillType.GoddessMummy, self.curIndex)
  elseif buildId == BuildingTypes.CAMP_Reinforcement then
    local vecPos2 = SceneUtils.IndexToTilePos(self.curIndex, ForceChangeScene.World, self.curServerId)
    local theWorld = CS.SceneManager.World
    local succ = false
    if theWorld ~= nil then
      local allianceCityList = theWorld:GetAllAllianceCityList()
      for index = 0, allianceCityList.Count - 1 do
        local pointInfo = allianceCityList[index]
        local isMyCamp = DataCenter.WorldAllianceCityDataManager:IsMyCamp(self.curServerId, pointInfo.CityInfo.CityId)
        local vecPos3 = SceneUtils.IndexToTilePos(pointInfo.mainIndex, ForceChangeScene.World, self.curServerId)
        if isMyCamp then
          local meta = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
          local offer_range = (meta.resSize - 1) / 2
          if offer_range > math.abs(vecPos2.x - vecPos3.x) and offer_range > math.abs(vecPos2.y - vecPos3.y) then
            DataCenter.AllianceGovernmentCommonSkillManager:UseSkill(AlOfficialSkillType.Reinforcement, pointInfo.mainIndex)
            succ = true
            break
          end
        end
      end
    end
    if not succ then
      UIUtil.ShowTipsId("season_s6_government_skill_error_tips07")
    end
  elseif WorldAllianceBuildUtil.IsAllianceCenterFlag(buildId) then
    local delayParam = {
      delayTime = 10,
      des1 = "season_alliance_reward_tips_1",
      des2 = "season_alliance_reward_tips_2"
    }
    UIUtil.ShowSecondMessage("", Localization:GetString("season_s1_build_tips001"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      local serverId = LuaEntry.Player:GetCurServerId()
      SFSNetwork.SendMessage(MsgDefines.BuildAllianceMine, thePointIndex, buildId, serverId)
      DataCenter.AllianceMineManager:SetBuildIdActive(buildId, 0)
    end, nil, nil, nil, nil, nil, nil, nil, nil, false, nil, delayParam)
  elseif self.param.topType == PlaceBuildType.Build then
    local serverId = LuaEntry.Player:GetCurServerId()
    SFSNetwork.SendMessage(MsgDefines.BuildAllianceMine, thePointIndex, buildId, serverId)
    DataCenter.AllianceMineManager:SetBuildIdActive(buildId, 0)
  elseif self.param.topType == PlaceBuildType.CityAttachment then
    local buildUuid = toInt(self.param.buildUuid)
    local cityId = toInt(buildUuid * 0.001)
    local slotIndex = buildUuid % 1000
    SFSNetwork.SendMessage(MsgDefines.CreateCityAttachmentBuild, cityId, slotIndex)
  end
  CS.SceneManager.World:UIDestroyRreCreateAllianceBuild()
  self.ctrl:CloseSelf()
end

function UIPlaceWorldBuildView:DoCancel()
  if self.param.topType ~= PlaceBuildType.Move and CS.SceneManager.World then
    CS.SceneManager.World:UIDestroyRreCreateAllianceBuild()
  end
  self.needDoCancelFunction = false
  self.ctrl:CloseSelf()
end

function UIPlaceWorldBuildView:OnCancelBtnClick()
  local buildId = self.param.buildId
  if self.param.topType == PlaceBuildType.CityAttachment then
    self:DoCancel()
  elseif buildId == BuildingTypes.SEASON_ARES_MISSILE or buildId == BuildingTypes.SEASON_ARES_MISSILE_GLOBAL or buildId == BuildingTypes.SEASON_ARES_MISSILE_S4 or buildId == BuildingTypes.CAMP_SEASON_MISSILE or buildId == BuildingTypes.GODDESS_MUMMY_TARGET or buildId == BuildingTypes.CAMP_GODDESS_MUMMY_TARGET then
    self:DoCancel()
  elseif SeasonUtil.GetSeasonType() ~= SeasonMapType.Snow and WorldAllianceBuildUtil.IsAllianceCenterFlag(buildId) == true then
    UIUtil.ShowMessage(Localization:GetString("season_tips128"), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self:DoCancel()
      local pointId = LuaEntry.Player:GetMainWorldPos()
      local position = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World)
      GoToUtil.GotoWorldPos(position, MoveCityCameraHeight, nil, function()
      end, LuaEntry.Player.serverId)
    end)
  else
    self:DoCancel()
  end
end

function UIPlaceWorldBuildView:OnBackClick()
  local buildId = self.param.buildId
  local backToWindow = DataCenter.BuildManager:GetShowPutBuildFromPanel()
  self:OnCancelBtnClick()
  if backToWindow ~= nil and backToWindow ~= "" then
    UIManager:GetInstance():OpenWindow(backToWindow, buildId)
  end
end

function UIPlaceWorldBuildView:LoadBuildSelect()
  if self.param.topType == PlaceBuildType.CityAttachment then
    return
  end
  local buildId = self.param.buildId
  if buildId == BuildingTypes.SEASON_ARES_MISSILE or buildId == BuildingTypes.SEASON_ARES_MISSILE_GLOBAL or buildId == BuildingTypes.SEASON_ARES_MISSILE_S4 or buildId == BuildingTypes.CAMP_SEASON_MISSILE or buildId == BuildingTypes.GODDESS_MUMMY_TARGET or buildId == BuildingTypes.CAMP_GODDESS_MUMMY_TARGET or buildId == BuildingTypes.CAMP_Reinforcement then
    local effect_scope = toInt(self.param.buildUuid)
    local tempBuild = CS.SceneManager.World.FakeModelManager.preCreateAllianceBuild
    if effect_scope == 0 then
      effect_scope = 18
    end
    local cell_count = 2 * effect_scope + 1
    if tempBuild ~= nil and tempBuild.allianceBuild ~= nil then
      local bg = tempBuild.allianceBuild.transform:Find("ModelGo/xuanqu_9")
      if bg then
        local scale = 0.68 * cell_count
        bg:Set_localScale(scale, 1, scale)
        self.buildSelect = bg:GetComponent(typeof(CS.BuildSelect))
      end
      local line = tempBuild.allianceBuild.transform:Find("ModelGo/fanwei/root/line")
      if line then
        local effect_scale = cell_count / 3
        line:Set_localScale(effect_scale, effect_scale, 1)
      end
    end
    return
  end
  local modelPath
  if self.tile == 9 then
    modelPath = "Assets/Main/SeasonRes/Shared/Prefabs/Effect/BuildSelect9x9.prefab"
  elseif self.tile ~= nil then
    modelPath = string.format(UIAssets.BuildSelect, self.tile, self.tile)
  elseif WorldAllianceBuildUtil.IsAllianceCenterGroup(buildId) == true then
    modelPath = "Assets/Main/Prefabs/Building/BuildSelectAllianceCity.prefab"
  end
  if modelPath ~= nil and CS.GameEntry.Resource:HasAsset(modelPath) then
    self:GameObjectInstantiateAsync(modelPath, function(request)
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

function UIPlaceWorldBuildView:RefreshBuildSelect()
  if self.param.topType == PlaceBuildType.CityAttachment then
    return
  end
  local buildId = self.param.buildId
  if self.buildSelect ~= nil then
    if buildId == BuildingTypes.SEASON_ARES_MISSILE or buildId == BuildingTypes.SEASON_ARES_MISSILE_GLOBAL or buildId == BuildingTypes.SEASON_ARES_MISSILE_S4 or buildId == BuildingTypes.CAMP_SEASON_MISSILE or buildId == BuildingTypes.GODDESS_MUMMY_TARGET or buildId == BuildingTypes.CAMP_GODDESS_MUMMY_TARGET or buildId == BuildingTypes.CAMP_Reinforcement then
    else
      local v = SceneUtils.TileIndexToWorld(self.curIndex, ForceChangeScene.World, self.curServerId) + BlockPos
      self.buildSelect.transform:Set_position(v.x + TileSize, v.y, v.z + TileSize)
    end
    self.buildSelect:ChangeColor(self.putState == BuildPutState.Ok)
  end
  if WorldAllianceBuildUtil.IsAllianceCenterGroup(buildId) == true then
    WorldAlCenterSelectEffectManager:GetInstance():ShowPos(self.curIndex, self.putState, self.curServerId)
  end
end

function UIPlaceWorldBuildView:ChangeIndex(index, putState)
  if index ~= nil and index ~= 0 then
    local pos = SceneUtils.IndexToTilePos(index, ForceChangeScene.World)
    if CS.CommonUtils.IsDebug() then
      Logger.Log(string.format("ClickWorld.PlaceWorldBuild (%s, %s)", pos.x, pos.y))
    end
    self.curIndex = SceneUtils.TileXYToIndex(pos.x, pos.y, ForceChangeScene.World)
    self.xy:InitState(pos.x, pos.y, self.curServerId)
  end
  if self.param.topType == PlaceBuildType.CityAttachment then
    self.putState = BuildPutState.Ok
    self.confirm_btn:SetInteractable(true)
    self.confirm_img:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm")
    return
  end
  local lastPutState = self.putState
  self.putState = putState or WorldAllianceBuildUtil.IsCanPutDownByAllianceBuild(self.param.buildId, self.curIndex, self.curServerId)
  self:RefreshNoReason(lastPutState ~= self.putState, lastPutState == BuildPutState.None or lastPutState == BuildPutState.Ok ~= (self.putState == BuildPutState.Ok))
  self:RefreshBuildSelect()
end

function UIPlaceWorldBuildView:UIPlaceBuildChangePosSignal(data)
  if data ~= nil and data ~= "" then
    local theType = type(data)
    if theType == "number" then
      local pointId = toInt(data)
      if self.curIndex ~= pointId then
        self:ChangeIndex(pointId)
      end
    elseif theType == "userdata" and data.x ~= nil and data.y ~= nil and data.z ~= nil then
      local seasonInfo = SeasonUtil.GetSeasonInfo(self.curServerId)
      local pointId = SceneUtils.WorldToTileIndex(data, ForceChangeScene.World)
      self.curWorldPos = data
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
      if self.curIndex ~= pointId then
        if self.inS5BigMap then
          local mapIndex = seasonInfo:GetNinePalacesIndexByWorldPos(data)
          local serverId = seasonInfo:GetNinePalacesServer(mapIndex)
          self.curServerId = serverId
        end
        ProfilerUtil.BeginSample("UIPlaceWorldBuildView.ChangeIndex")
        self:ChangeIndex(pointId)
        ProfilerUtil.EndSample()
      end
    end
  end
end

function UIPlaceWorldBuildView:RefreshNoReason(isChangeReason, isChangeOk)
  if isChangeOk then
    if self.putState == BuildPutState.Ok then
      self.confirm_btn:SetInteractable(true)
      self.confirm_img:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm")
    else
      self.confirm_btn:SetInteractable(false)
      self.confirm_img:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm_gray")
    end
  end
  if isChangeReason then
    local str = ""
    if self.putState == BuildPutState.Ok then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.CAN_PUT)
    elseif self.putState == BuildPutState.Building then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.INCLUDE_BUILDING)
    elseif self.putState == BuildPutState.WorldBoss then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.MONSTER)
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
    elseif self.putState == BuildPutState.NotNearAlRuin then
      str = Localization:GetString(GameDialogDefine.NO_PUT_RANGE)
    elseif self.putState == BuildPutState.AlResNotEnough then
      str = Localization:GetString(GameDialogDefine.NO_PUT_RANGE)
    elseif self.putState == BuildPutState.OnGhostrecon then
      str = Localization:GetString(GameDialogDefine.NO_PUT_RANGE)
    elseif self.putState == BuildPutState.OutBuildZone then
      if self.param.buildId == BuildingTypes.SEASON_ARES_MISSILE_GLOBAL then
        str = Localization:GetString("season_activity_1000086_tips15")
      elseif self.buildTemplate then
        str = Localization:GetString(GameDialogDefine.NEED_PUT_IN, DataCenter.CityZoneManager:GetZoneName(self.buildTemplate.zoneType))
      elseif self.param.buildId == BuildingTypes.SEASON_ARES_MISSILE or self.param.buildId == BuildingTypes.SEASON_ARES_MISSILE_S4 then
        str = Localization:GetString("season_alliance_government_skill_25")
      elseif self.param.buildId == BuildingTypes.CAMP_SEASON_MISSILE then
        str = Localization:GetString("season_s6_government_skill_error_tips06")
      end
    elseif self.putState == BuildPutState.InBlackLandRange then
      str = Localization:GetString("season_tips101")
    elseif self.putState == BuildPutState.NotConnectDesert then
      str = Localization:GetString("season_tips100")
    elseif self.putState == BuildPutState.MoveCityNotInUnLockRange then
      str = Localization:GetString("111065")
    elseif self.putState == BuildPutState.CanNotPlaceEdenSubway then
      local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.buildId)
      if buildTemplate ~= nil then
        str = Localization:GetString("111067", Localization:GetString(buildTemplate.name))
      end
    elseif self.putState == BuildPutState.AllianceBuildNotInBirthRange then
      str = Localization:GetString("111078")
    elseif self.putState == BuildPutState.AllianceMineNotInBirthRange then
      str = Localization:GetString("111069")
    elseif self.putState == BuildPutState.NoInAllianceCenterRange then
      if self.param.buildId == BuildingTypes.SEASON_ARES_MISSILE or self.param.buildId == BuildingTypes.SEASON_ARES_MISSILE_S4 then
        str = Localization:GetString("season_alliance_government_skill_35")
      else
        str = Localization:GetString(GameDialogDefine.NO_PUT_RANGE)
        if self.buildTemplate ~= nil then
          local allianceCenterId = tonumber(self.buildTemplate.para1)
          if allianceCenterId ~= nil and 0 < allianceCenterId then
            local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceCenterId)
            if template ~= nil then
              local buildName = Localization:GetString(template.name)
              str = Localization:GetString("302740", buildName)
            end
          end
        end
      end
    elseif self.putState == BuildPutState.ZoneLevelNotEnough then
      local tempTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.param.buildId)
      if tempTemplate ~= nil then
        str = Localization:GetString("803038", tempTemplate.level)
      else
        str = Localization:GetString("803042")
      end
    elseif self.putState == BuildPutState.ZoneTypeOrLevelNotMatch then
      local tempTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(self.param.buildId)
      if tempTemplate ~= nil then
        if tempTemplate.type == AllianceBuildType.StoveCenter or tempTemplate.type == AllianceBuildType.MilitaryCenter or tempTemplate.type == AllianceBuildType.Carrier then
          str = Localization:GetString("season_s2_tips001", tempTemplate.level)
        else
          str = Localization:GetString("season_tips221", tempTemplate.level)
        end
      else
        str = Localization:GetString("803042")
      end
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

function UIPlaceWorldBuildView:UpdatePointDataSignal()
  ProfilerUtil.BeginSample("UIPlaceWorldBuildView:UpdatePointDataSignal")
  self:ChangeIndex(0)
  ProfilerUtil.EndSample()
end

function UIPlaceWorldBuildView:UICreateFakePlaceBuildSignal()
  self:ChangeSelectBuild()
end

function UIPlaceWorldBuildView:ChangeSelectBuild()
  if CS.SceneManager.World.SelectBuild ~= nil then
    self.AutoAdjustScreenPos:Init(CS.SceneManager.World.SelectBuild.transform, Vector3.New(0, 0, 0))
  end
end

function UIPlaceWorldBuildView:GetDeltaPosDelta(tile)
  local tempX = (tile - 1) / 2
  local tempZ = (tile - 1) / 2
  return Vector3.New(-tempX - 1, 0, -tempZ)
end

function UIPlaceWorldBuildView:RefreshCameraPoint()
end

function UIPlaceWorldBuildView:HideBg()
end

return UIPlaceWorldBuildView
