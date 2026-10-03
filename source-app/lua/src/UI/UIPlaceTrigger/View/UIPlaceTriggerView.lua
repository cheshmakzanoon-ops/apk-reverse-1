local UIPlaceTriggerView = BaseClass("UIPlaceTriggerView", UIBaseView)
local base = UIBaseView
local WorldPlaceItem = require("UI.UISearch.Component.WorldPlaceItem")
local WorldTriggerUtil = require("Util.WorldTriggerUtil")
local confirm_btn_path = "BtnGo/common_btn_confirm"
local cancel_btn_path = "BtnGo/common_btn_cancel"
local btn_go_path = "BtnGo"
local xy_path = "common_bg3/WorldPlaceItem"
local reason_text_path = "common_bg3/reason_text"
local reason_red_text_path = "common_bg3/reason_red_text"
local des_bg_path = "common_bg3"
local build_icon_path = "common_bg3/build_icon"
local build_name_path = "common_bg3/build_name"
local build_des_path = "common_bg3/build_des"
local back_btn_path = "common_bg3/back_btn"
local Localization = CS.GameEntry.Localization
local TilePosDelta = {
  Vector3.New(0, 0, 0),
  Vector3.New(-0.5, 0, -0.5),
  Vector3.New(0, 0, -0.1)
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

local function OnDestroy(self)
  self:ClosePanel()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_img = self:AddComponent(UIImage, confirm_btn_path)
  self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
  self.AutoAdjustScreenPos = self.transform:Find(btn_go_path):GetComponent(typeof(CS.AutoAdjustScreenPos))
  self.confirm_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnConfirmBtnClick()
  end)
  self.cancel_btn:SetOnClick(function()
    self:OnCancelBtnClick()
  end)
  self.des_bg = self:AddComponent(UIButton, des_bg_path)
  self.build_icon = self:AddComponent(UIImage, build_icon_path)
  self.build_name = self:AddComponent(UIText, build_name_path)
  self.build_des = self:AddComponent(UIText, build_des_path)
  self.reason_text = self:AddComponent(UIText, reason_text_path)
  self.reason_red_text = self:AddComponent(UIText, reason_red_text_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.back_btn:SetOnClick(function()
    self:OnCancelBtnClick()
  end)
  self.xy = self:AddComponent(WorldPlaceItem, xy_path)
  self.xy:SetActive(not BattleFieldUtil.InBattleField())
end

local function ComponentDestroy(self)
  self.xy:SetActive(false)
  self.confirm_btn = nil
  self.confirm_img = nil
  self.cancel_btn = nil
  self.AutoAdjustScreenPos = nil
end

local function DataDefine(self)
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
  self.curIndex = 0
  self.putState = BuildPutState.None
end

local function DataDestroy(self)
  self.curIndex = nil
  self.putState = nil
  self.tile = nil
  self.marchInfo = nil
  self.startIndex = nil
  self.isInit = nil
  self.size = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMain) then
    EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
  else
    DataCenter.GuideManager:SetNoShowUIMain(true)
  end
  local cfgId, point, size, skillId, theServerId = self:GetUserData()
  self.cfgId = cfgId
  self.landmineMeta = DataCenter.WorldTriggerTemplateManager:GetMeta(cfgId)
  self.size = size
  self.tile = size
  self.skillId = skillId
  self.curServerId = theServerId or self.curServerId
  if self.landmineMeta then
    self.startIndex = point
    CS.SceneManager.World:SetUseInput(false)
    if point == nil or point == "" or point == 0 then
      point = TileBubbleManager:GetInstance():GetPoint()
    end
    local willPos = SceneUtils.TileIndexToWorld(point, ForceChangeScene.World, self.curServerId)
    self:ChangeIndex(point)
    local temp = willPos + TilePosDelta[self.tile]
    local CameraHeight = MoveCityCameraHeight
    local data = CrossServerUtil.GetLastJumpToParam()
    if data and data.mode == JumpServerMode.CrossServerMoveCity then
      CameraHeight = SeasonCrossCameraHeight
    end
    CS.SceneManager.World:AutoLookat(temp, CameraHeight, LookAtFocusTime, function()
    end)
    DataCenter.BuildBubbleManager:HideBubbleNode()
    self:LoadBuildSelect()
    self:ChangeSelectMarch()
    self.isInit = true
  else
    self.isInit = false
    self.ctrl:CloseSelf()
  end
  self:SetBuildInfo()
end

function UIPlaceTriggerView:SetBuildInfo()
  if self.landmineMeta then
    self.build_icon:LoadSprite(self.landmineMeta.icon)
    self.build_name:SetText(self.landmineMeta:GetName())
    self.build_des:SetLocalText(self.landmineMeta.desc)
    self.des_bg:SetActive(true)
  else
    self.des_bg:SetActive(false)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  if self.isInit then
    self:AddUIListener(EventId.UIPlaceTriggerChangePos, self.UIPlaceTriggerChangePosSignal)
  end
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  if self.isInit then
    self:RemoveUIListener(EventId.UIPlaceTriggerChangePos, self.UIPlaceTriggerChangePosSignal)
  end
end

local function ClosePanel(self)
  if CS.SceneManager.World ~= nil then
    DataCenter.BuildBubbleManager:ShowBubbleNode()
    CS.SceneManager.World:SetUseInput(true)
    CS.SceneManager.World:SetTouchInputControllerEnable(true)
    CS.SceneManager.World.touchPickablePos:Clear()
    CS.SceneManager.World.SelectBuild = nil
    CS.SceneManager.World:UIDestroyPreCreateTrigger()
  end
end

local function OnConfirmBtnClick(self)
  local skillTemp = DataCenter.MasteryManager:GetSkillTemplate(self.skillId)
  DataCenter.MasteryManager:SendUseSkillMsg(skillTemp, {
    pointId = self.curIndex
  })
  self.ctrl:CloseSelf()
end

local function OnCancelBtnClick(self)
  self.ctrl:CloseSelf()
end

local function LoadBuildSelect(self)
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

local function RefreshBuildSelect(self)
  if self.buildSelect ~= nil then
    local v = SceneUtils.TileIndexToWorld(self.curIndex, ForceChangeScene.World, self.curServerId) + BlockPos
    local halfSize = self.tile - 1
    self.buildSelect.transform:Set_position(v.x + halfSize, v.y, v.z + halfSize)
    self.buildSelect:ChangeColor(self.putState == BuildPutState.Ok)
  end
end

local function ChangeIndex(self, index, putState)
  local lastPutState = self.putState
  self.curIndex = index
  if self.curServerId ~= LuaEntry.Player:GetSourceServerId() then
    self.putState = BuildPutState.UnavailableServer
  else
    self.putState = putState or WorldTriggerUtil.IsCanPutDownBySize(self.size, index, self.curServerId)
  end
  self:RefreshNoReason(lastPutState ~= self.putState, lastPutState == BuildPutState.None or lastPutState == BuildPutState.Ok ~= (self.putState == BuildPutState.Ok))
  self:RefreshBuildSelect()
  local pos = SceneUtils.IndexToTilePos(index, ForceChangeScene.World)
  self.xy:InitState(pos.x, pos.y, self.curServerId)
end

local function UIPlaceTriggerChangePosSignal(self, data)
  if data ~= nil and data ~= "" then
    local theType = type(data)
    if theType == "number" then
      local pointId = tonumber(data)
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
        ProfilerUtil.BeginSample("UIPlaceTriggerView.ChangeIndex")
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
      self.confirm_btn:SetInteractable(false)
      self.confirm_img:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm_gray")
    end
  end
  if not isChangeReason then
    return
  end
  local str = ""
  if self.putState == BuildPutState.Ok then
    str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.CAN_PUT)
  elseif self.putState == BuildPutState.Building then
    str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.INCLUDE_BUILDING)
  elseif self.putState == BuildPutState.OnGhostrecon then
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
  elseif self.putState == BuildPutState.OutBuildZone then
    str = Localization:GetString(GameDialogDefine.NEED_PUT_IN, DataCenter.CityZoneManager:GetZoneName(self.buildTemplate.zoneType))
  elseif self.putState == BuildPutState.InBlackLandRange then
    str = Localization:GetString("season_tips101")
  elseif self.putState == BuildPutState.NotConnectDesert then
    str = Localization:GetString("season_tips100")
  elseif self.putState == BuildPutState.MoveCityNotInUnLockRange then
    str = Localization:GetString("111065")
  elseif self.putState == BuildPutState.CanNotPlaceEdenSubway then
    str = Localization:GetString("803042")
  elseif self.putState == BuildPutState.AllianceBuildNotInBirthRange then
    str = Localization:GetString("111078")
  elseif self.putState == BuildPutState.AllianceMineNotInBirthRange then
    str = Localization:GetString("111069")
  elseif self.putState == BuildPutState.NoInAllianceCenterRange then
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
  elseif self.putState == BuildPutState.ZoneLevelNotEnough then
    str = Localization:GetString("803042")
  elseif self.putState == BuildPutState.ZoneTypeOrLevelNotMatch then
    str = Localization:GetString("803042")
  else
    str = Localization:GetString("803042")
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

local function ChangeSelectMarch(self)
  if CS.SceneManager.World.SelectBuild ~= nil then
    self.AutoAdjustScreenPos:Init(CS.SceneManager.World.SelectBuild.transform, TilePosDelta[self.tile])
  end
end

local function RefreshCameraPoint(self)
  if SceneUtils.GetIsInWorld() then
    self.xy:InitState()
  end
end

UIPlaceTriggerView.OnCreate = OnCreate
UIPlaceTriggerView.OnDestroy = OnDestroy
UIPlaceTriggerView.OnEnable = OnEnable
UIPlaceTriggerView.OnDisable = OnDisable
UIPlaceTriggerView.OnAddListener = OnAddListener
UIPlaceTriggerView.OnRemoveListener = OnRemoveListener
UIPlaceTriggerView.ComponentDefine = ComponentDefine
UIPlaceTriggerView.ComponentDestroy = ComponentDestroy
UIPlaceTriggerView.DataDefine = DataDefine
UIPlaceTriggerView.DataDestroy = DataDestroy
UIPlaceTriggerView.ReInit = ReInit
UIPlaceTriggerView.ClosePanel = ClosePanel
UIPlaceTriggerView.OnConfirmBtnClick = OnConfirmBtnClick
UIPlaceTriggerView.OnCancelBtnClick = OnCancelBtnClick
UIPlaceTriggerView.RefreshBuildSelect = RefreshBuildSelect
UIPlaceTriggerView.LoadBuildSelect = LoadBuildSelect
UIPlaceTriggerView.UIPlaceTriggerChangePosSignal = UIPlaceTriggerChangePosSignal
UIPlaceTriggerView.ChangeIndex = ChangeIndex
UIPlaceTriggerView.RefreshNoReason = RefreshNoReason
UIPlaceTriggerView.ChangeSelectMarch = ChangeSelectMarch
UIPlaceTriggerView.RefreshCameraPoint = RefreshCameraPoint
return UIPlaceTriggerView
