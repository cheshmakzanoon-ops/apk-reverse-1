local UIPlaceBuildView = BaseClass("UIPlaceBuildView", UIBaseView)
local base = UIBaseView
local WorldGotoItem = require("UI.UISearch.Component.WorldGotoItem")
local Localization = CS.GameEntry.Localization
local PlaceBuildGridManager = require("Scene.PlaceBuildGrid.PlaceBuildGridManager")
local confirm_btn_path = "BtnGo/common_btn_confirm"
local cancel_btn_path = "BtnGo/common_btn_cancel"
local reason_text_path = "common_bg3/reason_text"
local reason_red_text_path = "common_bg3/reason_red_text"
local btn_go_path = "BtnGo"
local build_icon_path = "common_bg3/build_icon"
local build_name_path = "common_bg3/build_name"
local build_des_path = "common_bg3/build_des"
local back_btn_path = "common_bg3/back_btn"
local wormHoleTips_img_path = "Img_WormHole"
local wormHoleTips_txt_path = "Img_WormHole/Txt_WormHoleTips"
local ShowTipDuringTime = 1000
local xy_path = "common_bg3/Goto"

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
  self.xy = self:AddComponent(WorldGotoItem, xy_path)
  self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirm_img = self:AddComponent(UIImage, confirm_btn_path)
  self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
  self.reason_text = self:AddComponent(UIText, reason_text_path)
  self.build_icon = self:AddComponent(UIImage, build_icon_path)
  self.build_name = self:AddComponent(UIText, build_name_path)
  self.build_des = self:AddComponent(UIText, build_des_path)
  self.back_btn = self:AddComponent(UIButton, back_btn_path)
  self.reason_red_text = self:AddComponent(UIText, reason_red_text_path)
  self.AutoAdjustScreenPos = self.transform:Find(btn_go_path):GetComponent(typeof(CS.AutoAdjustScreenPos))
  self.confirm_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnConfirmBtnClick()
  end)
  self.cancel_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCancelBtnClick()
  end)
  self.back_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBackClick()
  end)
  self._wormHoleTips_img = self:AddComponent(UIBaseContainer, wormHoleTips_img_path)
  self._wormHoleTips_txt = self:AddComponent(UIText, wormHoleTips_txt_path)
  self.xy:SetActive(not BattleFieldUtil.InBattleField())
end

local function ComponentDestroy(self)
  self.xy:SetActive(false)
  PlaceBuildGridManager:GetInstance():ResetGridData()
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

local function DataDefine(self)
  self.param = nil
  self.isInGuide = false
  self.needMoveNewPos = false
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
  self.isSeasonBuild = false
  self.showReasonTime = 0
  self.reasonStr = ""
end

local function DataDestroy(self)
  self:HideCityZoneEffect()
  self:RemoveResourceZoneEffect()
  if self.param and self.param.buildUuid ~= 0 then
    DataCenter.BuildTimeManager:RefreshActive(self.param.buildUuid, true)
  end
  DataCenter.BuildZoneManager:RemoveAll()
  DataCenter.BuildManager:SetShowPutBuildFromPanel(nil)
  self.allPoint = nil
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
  self.sendCount = nil
  self.isSeasonBuild = false
  self.showReasonTime = 0
  self.reasonStr = ""
  if self.delay ~= nil then
    self.delay:Stop()
    self.delay = nil
  end
  if self.showRadarCenterGuide then
    DataCenter.ArrowManager:RemoveArrow()
  end
end

local function OnEnable(self)
  base.OnEnable(self)
  self:RefreshCameraPoint()
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function Update(self)
  if self.isSeasonBuild or self.param == nil or self.param.buildId == nil then
    return
  end
  if self.allPoint == nil then
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.buildId)
    if buildTemplate ~= nil then
      self.allPoint = DataCenter.CityZoneManager:GetGridEffectPointIndex(buildTemplate)
    end
  end
  if self.allPoint ~= nil then
    PlaceBuildGridManager:GetInstance():RedrawGrid(self.allPoint)
  end
end

local function ReInit(self)
  self.showRadarCenterGuide = false
  self.sendCount = 0
  self.needDoCancelFunction = true
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMain) then
    EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
  else
    DataCenter.GuideManager:SetNoShowUIMain(true)
  end
  local buildId, buildUuid, point, topType = self:GetUserData()
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
  self.isSeasonBuild = false
  self.buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
  if self.buildTemplate ~= nil then
    self.tileX = self.buildTemplate.tileX
    self.tileY = self.buildTemplate.tileY
    self.isSeasonBuild = true
  end
  if buildId == BuildingTypes.WORM_HOLE_CROSS or buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB then
    self._wormHoleTips_img:SetActive(true)
    local str = Localization:GetString("110213", Localization:GetString(self.buildTemplate.name))
    self._wormHoleTips_txt:SetText(str)
  else
    self._wormHoleTips_img:SetActive(false)
  end
  if buildId == BuildingTypes.FUN_BUILD_MAIN then
    self:ShowMainBase()
  else
    local willPos
    if point ~= nil and 0 < point then
      willPos = SceneUtils.TileIndexToWorld(point)
    else
      willPos = CS.SceneManager.World.CurTarget
    end
    self:ChangeIndex(SceneUtils.WorldToTileIndex(willPos))
  end
  DataCenter.BuildBubbleManager:HideBubbleNode()
  if self.param.buildUuid ~= 0 then
    DataCenter.BuildTimeManager:RefreshActive(self.param.buildUuid, false)
  end
  self:LoadBuildSelect()
  self:ChangeSelectBuild()
  self:CheckInGuide()
  self:SetBuildInfo()
  if self.buildTemplate == nil or self.buildTemplate.build_type == BuildType.Normal then
  end
  if buildId ~= BuildingTypes.FUN_BUILD_MAIN and buildId ~= BuildingTypes.APS_BUILD_WORMHOLE_SUB and buildId ~= BuildingTypes.WORM_HOLE_CROSS then
    self:ShowCityZoneEffect()
  end
  if buildId == BuildingTypes.FUN_BUILD_OUT_WOOD or buildId == BuildingTypes.FUN_BUILD_OUT_STONE then
    self:ShowResourceZoneEffect()
  end
  EventManager:GetInstance():Broadcast(EventId.ShowBuildTopUI, self.param.buildUuid)
  if self.param.topType == PlaceBuildType.Build and buildId ~= nil and 0 < buildId then
    DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.UIPlaceBuild, buildId .. ";" .. DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(buildId) + 1)
  end
  self:ShowPlaceGuide()
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.REGET_MAIN_POSITION, self.ReMainPosition)
  self:AddUIListener(EventId.UIPlaceBuildChangePos, self.UIPlaceBuildChangePosSignal)
  self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.UpdatePointDataSignal)
  self:AddUIListener(EventId.UICreateFakePlaceBuild, self.UICreateFakePlaceBuildSignal)
  self:AddUIListener(EventId.UIPlaceBuildSendMessageBack, self.UIPlaceBuildSendMessageBackSignal)
  self:AddUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
  self:AddUIListener(EventId.BuildMainZeroUpgradeSuccess, self.RefreshCameraPoint)
  self:AddUIListener(EventId.UpdateFakeBuildingPos, self.RefreshCameraPoint)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.REGET_MAIN_POSITION, self.ReMainPosition)
  self:RemoveUIListener(EventId.UIPlaceBuildChangePos, self.UIPlaceBuildChangePosSignal)
  self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.UpdatePointDataSignal)
  self:RemoveUIListener(EventId.UICreateFakePlaceBuild, self.UICreateFakePlaceBuildSignal)
  self:RemoveUIListener(EventId.UIPlaceBuildSendMessageBack, self.UIPlaceBuildSendMessageBackSignal)
  self:RemoveUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.RefreshCameraPoint)
  self:RemoveUIListener(EventId.BuildMainZeroUpgradeSuccess, self.RefreshCameraPoint)
  self:RemoveUIListener(EventId.UpdateFakeBuildingPos, self.RefreshCameraPoint)
end

local function SetBuildInfo(self)
  local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.buildId)
  local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.buildUuid)
  if buildTemplate ~= nil then
    local level = 1
    if buildData ~= nil then
      level = buildData.level
    end
    self.build_icon:LoadSpriteAuto(DataCenter.BuildManager:GetBuildIconPath(self.param.buildId, level))
    self.build_name:SetLocalText(buildTemplate.name)
    self.build_des:SetLocalText(buildTemplate.des)
  end
end

local function ClosePanel(self)
  if self.needDoCancelFunction then
    self:OnCancelBtnClick()
  end
  if self.param and self.param.topType == PlaceBuildType.Move and CS.SceneManager.World ~= nil then
    local temp = CS.SceneManager.World:GetBuildingByPoint(self.param.point)
    if temp ~= nil then
      temp:refeshDate()
      local moveState = DataCenter.BuildManager:GetCurrentBuildMoveState()
      if SceneUtils.GetIsInCity() and moveState ~= BuildMoveState.Success then
        self.needMoveNewPos = false
      end
      if self.needMoveNewPos then
        temp.transform.position = SceneUtils.TileIndexToWorld(self.curIndex)
      end
    end
  end
  EventManager:GetInstance():Broadcast(EventId.FakeBuildingSelectLocation)
  EventManager:GetInstance():Broadcast(EventId.UpdateFakeBuildingPos)
  if self.param then
    EventManager:GetInstance():Broadcast(EventId.HideBuildTopUI, self.param.buildUuid)
  end
  if CS.SceneManager.World ~= nil then
    CS.SceneManager.World:SetUseInput(true)
    CS.SceneManager.World:SetTouchInputControllerEnable(true)
    DataCenter.BuildBubbleManager:ShowBubbleNode()
    CS.SceneManager.World.touchPickablePos:Clear()
    CS.SceneManager.World.SelectBuild = nil
  end
end

local function OnConfirmBtnClick(self)
  EventManager:GetInstance():Broadcast(EventId.OnClickPlaceBuild)
  local guideContinue = true
  if self.isInGuide then
    local nextGuideType = DataCenter.GuideManager:GetNextGuideTemplateParam("type")
    if nextGuideType == GuideType.BuildPlace then
      DataCenter.GuideManager:DoNext()
    else
      guideContinue = false
    end
  end
  local needContinue = self.buildTemplate.build_type == BuildType.Second and guideContinue and (self.param.topType == PlaceBuildType.Build or self.param.topType == PlaceBuildType.Replace) and BuildingUtils.IsCanBuildNext(self.param.buildId, self.sendCount)
  if self.param.topType == PlaceBuildType.Build then
    if self.param.buildId == BuildingTypes.FUN_BUILD_MAIN then
      local now = UITimeManager:GetInstance():GetServerTime()
      CS.GameEntry.BuildAnimatorManager:AddOneBuild(self.curIndex, now, now + self.buildTemplate:GetBuildTime())
      SFSNetwork.SendMessage(MsgDefines.FreeBuildingPlaceMainBuilding, {
        pointId = self.curIndex
      })
      CS.SceneManager.World:UIChangeBuilding(self.curIndex)
    else
      local needPathTime = 0
      if self.buildTemplate.build_type ~= BuildType.Second and self.buildTemplate.scan == BuildScanAnim.Play then
        needPathTime = DataCenter.BuildManager:GetPathTimeFromDroneToBuildTarget(self.curIndex)
      end
      local now = UITimeManager:GetInstance():GetServerTime()
      local useTime = self.buildTemplate:GetBuildTime() + needPathTime
      CS.GameEntry.BuildAnimatorManager:AddOneBuild(self.curIndex, now, now + useTime)
      local param = {}
      param.buildingId = self.param.buildId
      param.pointId = self.curIndex
      param.itemUuid = ""
      param.pathTime = needPathTime
      param.robotUuid = 0
      param.targetServerId = LuaEntry.Player:GetCurServerId()
      if 0 < useTime then
        local index = DataCenter.BuildQueueManager:GetFreeQueueIndex(self.buildTemplate:IsSeasonBuild())
        if 0 < index then
          local robot = DataCenter.BuildQueueManager:GetQueueDataByIndex(index)
          if robot ~= nil then
            param.robotUuid = robot.uuid
          end
        end
      end
      local lackItem = false
      local needItem = self.buildTemplate:GetNeedItem()
      if needItem ~= nil then
        for k1, v1 in ipairs(needItem) do
          if lackItem == false then
            local itemData = DataCenter.ItemData:GetItemById(v1.itemId)
            if itemData == nil or itemData.count < v1.num then
              lackItem = true
            else
              param.itemUuid = itemData.uuid
            end
          end
        end
      end
      if lackItem == true then
        Logger.LogError("placeBuild no item" .. self.param.buildId)
        return
      end
      self.sendCount = self.sendCount + 1
      if not DataCenter.GuideManager:IsSendBuildPlace() then
        DataCenter.GuideCityAnimManager:SetBuildParam(param)
        DataCenter.GuideManager:SetCanShowBuild(false)
      end
      SFSNetwork.SendMessage(MsgDefines.FreeBuildingPlaceNew, param)
      EventManager:GetInstance():Broadcast(EventId.CreatedResidentOrder)
    end
    CS.SceneManager.World:UIChangeBuilding(self.curIndex)
  elseif self.param.topType == PlaceBuildType.Replace then
    local param = {}
    param.buildUuid = self.param.buildUuid
    param.pointId = self.curIndex
    self.sendCount = self.sendCount + 1
    SFSNetwork.SendMessage(MsgDefines.FreeBuildingReplaceNew, param)
    local tempBuild = CS.SceneManager.World.preCreateBuild
    CS.SceneManager.World:UIChangeBuilding(self.curIndex)
    if tempBuild ~= nil and tempBuild.city ~= nil then
      tempBuild.city:DoBuildPlaceAnim()
    end
  elseif self.param.topType == PlaceBuildType.Move then
    if self.curIndex == self.param.point then
      self:OnCancelBtnClick()
      return
    end
    if self.param.buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB or self.param.buildId == BuildingTypes.WORM_HOLE_CROSS then
      UIUtil.ShowTipsId(104275)
      self:OnCancelBtnClick()
      return
    elseif self.param.buildId == BuildingTypes.APS_BUILD_WORMHOLE_MAIN then
      local aNum = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(BuildingTypes.APS_BUILD_WORMHOLE_SUB)
      local bNum = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(BuildingTypes.WORM_HOLE_CROSS)
      if 0 < aNum or 0 < bNum then
        UIUtil.ShowTipsId(104275)
        self:OnCancelBtnClick()
        return
      end
    end
    local param = {}
    param.uuid = self.param.buildUuid
    param.pointId = self.curIndex
    param.lastIndex = self.param.point
    SFSNetwork.SendMessage(MsgDefines.BuildWorldMoveNew, param)
    self.needMoveNewPos = true
  end
  if needContinue then
    local point = 0
    local points = BuildingUtils.GetBuildTileIndex(self.param.buildId, self.curIndex)
    local noPintPoint = {}
    for k, v in ipairs(points) do
      noPintPoint[v] = true
    end
    if self.isInGuide then
      local para2 = DataCenter.GuideManager:GetGuideTemplateParam("para2")
      if para2 ~= nil and para2 ~= "" then
        local spl = string.split(para2, ",")
        if 1 < table.count(spl) then
          local mainPos = DataCenter.BuildManager.main_city_pos
          local vec2 = CS.UnityEngine.Vector2Int(mainPos.x + tonumber(spl[1]), mainPos.y + tonumber(spl[2]))
          point = SceneUtils.TilePosToIndex(vec2)
        end
      end
    else
      point = BuildingUtils.GetPointByBuildCanPut(self.param.buildId, self.curIndex, noPintPoint)
    end
    local foldList = DataCenter.BuildManager:GetFoldUpBuildByBuildId(self.param.buildId)
    local buildTopType = PlaceBuildType.Build
    local tempUuid = 0
    if foldList ~= nil and table.count(foldList) > self.sendCount then
      buildTopType = PlaceBuildType.Replace
      tempUuid = foldList[self.sendCount + 1].uuid
    end
    BuildingUtils.ShowPutBuild(self.param.buildId, buildTopType, tempUuid, point, noPintPoint)
    self.param.topType = buildTopType
    self.param.point = point
    self.param.buildUuid = tempUuid
    self:ChangeIndex(point)
  else
    self.needDoCancelFunction = false
    self.ctrl:CloseSelf()
  end
end

local function OnCancelBtnClick(self)
  if self.param.buildId == BuildingTypes.FUN_BUILD_MAIN then
    self.cancel_btn:SetInteractable(false)
    SFSNetwork.SendMessage(MsgDefines.FindMainBuildInitPosition)
  else
    if self.param.topType ~= PlaceBuildType.Move and CS.SceneManager.World then
      CS.SceneManager.World:UIDestroyRreCreateBuild()
    else
      self.needMoveNewPos = false
    end
    self.needDoCancelFunction = false
    self.ctrl:CloseSelf()
  end
end

local function OnBackClick(self)
  local buildId = self.param.buildId
  local backToWindow = DataCenter.BuildManager:GetShowPutBuildFromPanel()
  self:OnCancelBtnClick()
  if backToWindow ~= nil and backToWindow ~= "" then
    UIManager:GetInstance():OpenWindow(backToWindow, buildId)
  end
end

local function ShowMainBase(self)
  local index = DataCenter.BuildManager.showPoint
  local vecPos = SceneUtils.TileIndexToWorld(index)
  local ve3 = vecPos + self:GetDeltaPosDelta(self.tileX, self.tileY)
  CS.SceneManager.World:AutoFocus(ve3, CS.LookAtFocusState.PlaceBuild, 0)
  if CS.SceneManager.World.SelectBuild ~= nil then
    CS.SceneManager.World.SelectBuild.transform.position = vecPos
  end
  self.cancel_btn:SetInteractable(true)
  CS.SceneManager.World:SetTouchInputControllerEnable(false)
  self.putState = BuildPutState.None
  self:ChangeIndex(index)
end

local function ReMainPosition(self)
  self:ShowMainBase()
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
      go.transform.position = SceneUtils.TileIndexToWorld(index) + BlockPos
      self.useMainBuildGreen[index] = go
    end
  elseif 0 < table.count(self.freeMainBuildGreen) then
    local go = table.remove(self.freeMainBuildGreen)
    if go ~= nil then
      go:SetActive(true)
      go.transform.position = SceneUtils.TileIndexToWorld(index) + BlockPos
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
      go.transform.position = SceneUtils.TileIndexToWorld(index) + BlockPos
      self.useMainBuildGreen[index] = go
    end)
  end
end

local function LoadBuildSelect(self)
  self:GameObjectInstantiateAsync(string.format(UIAssets.BuildSelect, self.tileX, self.tileY), function(request)
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
    local v = SceneUtils.TileIndexToWorld(self.curIndex) + BlockPos
    self.buildSelect.transform:Set_position(v.x, v.y, v.z)
    self.buildSelect:ChangeColor(self.putState == BuildPutState.Ok)
  end
end

local function ChangeIndex(self, index)
  if self.needDoCancelFunction then
    local lastPutState = self.putState
    self.curIndex = index
    self.putState = BuildingUtils.IsCanPutDownByBuild(self.param.buildId, index, self.param.buildUuid)
    self:RefreshNoReason(lastPutState ~= self.putState, lastPutState == BuildPutState.None or lastPutState == BuildPutState.Ok ~= (self.putState == BuildPutState.Ok))
    self:RefreshBuildSelect()
    self:ShowBlock()
    DataCenter.BuildZoneManager:ChangePos(self.curIndex)
    self:RefreshRadarCenterGuide()
  end
end

local function UIPlaceBuildChangePosSignal(self, data)
  if data ~= nil and data ~= "" and type(data) == "number" then
    local pointId = tonumber(data)
    if self.curIndex ~= pointId then
      self:ChangeIndex(pointId)
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
  if isChangeReason or self.isSeasonBuild then
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
      elseif self.putState == BuildPutState.MoveCityNotInUnLockRange then
        str = Localization:GetString("111065")
      elseif self.putState == BuildPutState.AllianceBuildNotInBirthRange then
        str = Localization:GetString("111078")
      elseif self.putState == BuildPutState.AllianceMineNotInBirthRange then
        str = Localization:GetString("111069")
      elseif self.putState == BuildPutState.OutBuildZone then
        str = Localization:GetString(GameDialogDefine.NEED_PUT_IN, DataCenter.CityZoneManager:GetZoneName(self.buildTemplate.zoneType))
      elseif self.putState == BuildPutState.AlCityBuilding then
        str = Localization:GetString("new_city_activity_battle_tips1057")
      elseif self.putState == BuildPutState.NotConnectDesert then
        str = Localization:GetString("season_tips100")
      elseif self.putState == BuildPutState.InBlackLandRange then
        str = Localization:GetString("season_tips101")
      elseif self.putState == BuildPutState.NoInAllianceCenterRange then
        str = Localization:GetString(GameDialogDefine.NO_PUT_RANGE)
        if self.buildTemplate ~= nil then
          local allianceCenterId = tonumber(self.buildTemplate.para1)
          if allianceCenterId ~= nil and 0 < allianceCenterId then
            local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceCenterId)
            if template ~= nil then
              local buildName = Localization:GetString(template.name)
              str = Localization:GetString("season_tips009", buildName)
            end
          end
        end
      elseif self.putState == BuildPutState.NotEmptyOrNotSelfAlliance then
        str = Localization:GetString("season_tips149")
      end
      self.reasonStr = str
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
    if self.isSeasonBuild and self.putState ~= BuildPutState.Ok then
      local curTime = UITimeManager:GetInstance():GetServerTime()
      if curTime - self.showReasonTime > ShowTipDuringTime and self.reasonStr ~= "" then
        self.showReasonTime = curTime
        UIUtil.ShowTips(self.reasonStr)
      end
    end
  end
end

local function UpdatePointDataSignal(self)
  ProfilerUtil.BeginSample("UIPlaceBuildView:UpdatePointDataSignal")
  self:ChangeIndex(self.curIndex)
  ProfilerUtil.EndSample()
end

local function CheckInGuide(self)
  self.isInGuide = false
  if DataCenter.GuideManager:InGuide() then
    local guideTemplate = DataCenter.GuideManager:GetCurTemplate()
    if guideTemplate ~= nil then
      if guideTemplate.type == GuideType.BuildPlace then
        self.isInGuide = true
        if guideTemplate.para2 ~= nil and guideTemplate.para2 ~= "" then
          CS.SceneManager.World:SetTouchInputControllerEnable(false)
        else
          CS.SceneManager.World:SetTouchInputControllerEnable(true)
        end
      elseif guideTemplate.type == GuideType.ClickButton and guideTemplate.para2 ~= nil and guideTemplate.para2 ~= "" and string.contains(guideTemplate.para2, UIWindowNames.UIPlaceBuild) then
        self.isInGuide = true
        if guideTemplate.forcetype == GuideForceType.Force then
          CS.SceneManager.World:SetTouchInputControllerEnable(false)
        else
          CS.SceneManager.World:SetTouchInputControllerEnable(true)
        end
      end
    end
  end
end

local function UICreateFakePlaceBuildSignal(self)
  self:ChangeSelectBuild()
end

local function ChangeSelectBuild(self)
  if CS.SceneManager.World.SelectBuild ~= nil then
    self.AutoAdjustScreenPos:Init(CS.SceneManager.World.SelectBuild.transform, self:GetDeltaPosDelta(self.tileX, self.tileY))
    if self.param then
      if self.param.topType == PlaceBuildType.Move then
        DataCenter.BuildZoneManager:ShowZoneEffect(self.param.buildUuid, self.param.buildId, self.curIndex)
      elseif self.param.topType == PlaceBuildType.Build or self.param.topType == PlaceBuildType.Replace then
        DataCenter.BuildZoneManager:ShowZoneEffect(FakeBuildUuid, self.param.buildId, self.curIndex)
      end
      GoToUtil.GotoPos(CS.SceneManager.World.SelectBuild.transform.position, -1, nil, nil, LuaEntry.Player:GetCurServerId())
    end
  end
end

local function UIPlaceBuildSendMessageBackSignal(self)
  self.sendCount = self.sendCount - 1
  if self.sendCount < 0 then
    self.sendCount = 0
  end
end

local function ShowCityZoneEffect(self)
  DataCenter.CityZoneManager:ShowZoneEffect(self.buildTemplate)
end

local function HideCityZoneEffect(self)
  DataCenter.CityZoneManager:HideZoneEffect()
end

local function GetDeltaPosDelta(self, tileX, tileY)
  return Vector3.New(-(tileX - 1) / 2, 0, -(tileY - 1) / 2)
end

local function ShowResourceZoneEffect(self)
  if self.curIndex == nil then
    return
  end
  DataCenter.MineRootPlaceEffectManager:AddPlaceEffectsAround(self.curIndex, self.param.buildId, self.param.buildUuid)
end

local function RemoveResourceZoneEffect(self)
  DataCenter.MineRootPlaceEffectManager:RemoveAllEffects()
end

function UIPlaceBuildView:RefreshCameraPoint()
  if SceneUtils.GetIsInWorld() then
    self.xy:InitState()
    self.xy:InputCoordinate(false)
  end
end

function UIPlaceBuildView:HideBg()
end

function UIPlaceBuildView:ShowPlaceGuide()
  if not LuaEntry.DataConfig:CheckSwitch("ABtest_chapter_1") or LuaEntry.Player.abTest == ABTestType.A then
    return
  end
  if not self.param.buildId or self.param.buildId ~= BuildingTypes.FUN_BUILD_RADAR_CENTER then
    return
  end
  local guideFinish = CS.GameEntry.Setting:PlayerPrefsGetInt("RadarCenterPlaceGuide", 0)
  if guideFinish ~= 0 then
    return
  end
  CS.GameEntry.Setting:PlayerPrefsSetInt("RadarCenterPlaceGuide", 1)
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    DataCenter.ArrowManager:RemoveArrow()
    local param = {}
    param.position = self.confirm_btn:GetPosition()
    param.arrowType = ArrowType.Building
    param.positionType = PositionType.Screen
    param.isPanel = false
    if not DataCenter.GuideManager:InGuide() and param.position ~= nil then
      DataCenter.ArrowManager:ShowArrow(param)
    end
    self.showRadarCenterGuide = true
  end, 1)
end

function UIPlaceBuildView:RefreshRadarCenterGuide()
  if not self.showRadarCenterGuide then
    return
  end
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  DataCenter.ArrowManager:RemoveArrow()
end

UIPlaceBuildView.OnCreate = OnCreate
UIPlaceBuildView.OnDestroy = OnDestroy
UIPlaceBuildView.OnEnable = OnEnable
UIPlaceBuildView.OnDisable = OnDisable
UIPlaceBuildView.OnAddListener = OnAddListener
UIPlaceBuildView.OnRemoveListener = OnRemoveListener
UIPlaceBuildView.ComponentDefine = ComponentDefine
UIPlaceBuildView.ComponentDestroy = ComponentDestroy
UIPlaceBuildView.DataDefine = DataDefine
UIPlaceBuildView.DataDestroy = DataDestroy
UIPlaceBuildView.ReInit = ReInit
UIPlaceBuildView.ClosePanel = ClosePanel
UIPlaceBuildView.OnConfirmBtnClick = OnConfirmBtnClick
UIPlaceBuildView.OnCancelBtnClick = OnCancelBtnClick
UIPlaceBuildView.ShowMainBase = ShowMainBase
UIPlaceBuildView.ReMainPosition = ReMainPosition
UIPlaceBuildView.ShowBlock = ShowBlock
UIPlaceBuildView.RefreshBuildSelect = RefreshBuildSelect
UIPlaceBuildView.LoadBuildSelect = LoadBuildSelect
UIPlaceBuildView.UIPlaceBuildChangePosSignal = UIPlaceBuildChangePosSignal
UIPlaceBuildView.ChangeIndex = ChangeIndex
UIPlaceBuildView.RefreshNoReason = RefreshNoReason
UIPlaceBuildView.UpdatePointDataSignal = UpdatePointDataSignal
UIPlaceBuildView.CheckInGuide = CheckInGuide
UIPlaceBuildView.ShowOneBlock = ShowOneBlock
UIPlaceBuildView.UICreateFakePlaceBuildSignal = UICreateFakePlaceBuildSignal
UIPlaceBuildView.ChangeSelectBuild = ChangeSelectBuild
UIPlaceBuildView.UIPlaceBuildSendMessageBackSignal = UIPlaceBuildSendMessageBackSignal
UIPlaceBuildView.SetBuildInfo = SetBuildInfo
UIPlaceBuildView.OnBackClick = OnBackClick
UIPlaceBuildView.ShowCityZoneEffect = ShowCityZoneEffect
UIPlaceBuildView.HideCityZoneEffect = HideCityZoneEffect
UIPlaceBuildView.GetDeltaPosDelta = GetDeltaPosDelta
UIPlaceBuildView.ShowResourceZoneEffect = ShowResourceZoneEffect
UIPlaceBuildView.RemoveResourceZoneEffect = RemoveResourceZoneEffect
UIPlaceBuildView.Update = Update
return UIPlaceBuildView
