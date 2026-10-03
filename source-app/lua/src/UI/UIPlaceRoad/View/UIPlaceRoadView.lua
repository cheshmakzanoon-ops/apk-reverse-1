local UIPlaceRoadView = BaseClass("UIPlaceRoadView", UIBaseView)
local base = UIBaseView
local Screen = CS.UnityEngine.Screen
local Localization = CS.GameEntry.Localization
local PlaceBuildGridManager = require("Scene.PlaceBuildGrid.PlaceBuildGridManager")
local confirm_btn_path = "BtnGo/common_btn_confirm"
local cancel_btn_path = "BtnGo/common_btn_cancel"
local use_count_text_path = "common_bg3/UIMainTopResourceCell/root/resourceNum"
local btn_go_path = "BtnGo"
local select_go_path = "common_bg3/SelectImg"
local build_btn_path = "common_bg3/BuildRoadBtn"
local remove_btn_path = "common_bg3/RemoveBtn"
local exit_btn_path = "common_bg3 (1)/back_btn"
local tip_text_path = "common_bg3 (1)/build_name"
local touch_direction_path = "TouchDirection"
local touch_select_path = "TouchDirection/TouchSelect"
local touch_arrow_go_path = "TouchDirection/TouchArrowGo"
local guide_go_path = "VFX_yanshi"
local PosDelta = Vector3.New(0, 0.1, 0)
local ShowTipDuringTime = 1000
local InputRange = {
  left = 0,
  right = 0,
  top = 0,
  bottom = 0
}
local AutoMoveDelta = 0.5
local TouchSelectRange = 76
local GuideState = {
  None = 0,
  ShowAnim = 1,
  HideAnim = 2,
  WaitBuildRoad = 3,
  Done = 4
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
  self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
  self.use_count_text = self:AddComponent(UIText, use_count_text_path)
  self.select_go = self:AddComponent(UIBaseContainer, select_go_path)
  self.build_btn = self:AddComponent(UIButton, build_btn_path)
  self.remove_btn = self:AddComponent(UIButton, remove_btn_path)
  self.exit_btn = self:AddComponent(UIButton, exit_btn_path)
  self.btn_go = self:AddComponent(UIBaseContainer, btn_go_path)
  self.tip_text = self:AddComponent(UIText, tip_text_path)
  self.AutoAdjustScreenPos = self.transform:Find(btn_go_path):GetComponent(typeof(CS.AutoAdjustScreenPos))
  self.guide_go = self:AddComponent(UIBaseContainer, guide_go_path)
  self.confirm_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnConfirmBtnClick()
  end)
  self.cancel_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnCancelBtnClick()
  end)
  self.build_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBuildRoadBtnClick()
  end)
  self.remove_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnRemoveRoadBtnClick()
  end)
  self.exit_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnExitBtnClick()
  end)
  self.touch_direction = self:AddComponent(UIEventTrigger, touch_direction_path)
  self.touch_direction:OnDrag(function(eventData)
    self:OnDrag(eventData)
  end)
  self.touch_direction:OnPointerDown(function(eventData)
    self:OnPointerDown(eventData)
  end)
  self.touch_direction:OnPointerUp(function(eventData)
    self:OnPointerUp(eventData)
  end)
  self.touch_select = self:AddComponent(UIBaseContainer, touch_select_path)
  self.touch_arrow_go = self:AddComponent(UIBaseContainer, touch_arrow_go_path)
end

local function ComponentDestroy(self)
  self:RemoveMainCanNotPutRoadEffect()
  PlaceBuildGridManager:GetInstance():ResetGridData()
  self.confirm_btn = nil
  self.cancel_btn = nil
  self.use_count_text = nil
  self.select_go = nil
  self.build_btn = nil
  self.remove_btn = nil
  self.exit_btn = nil
  self.btn_go = nil
  self.AutoAdjustScreenPos = nil
  self.tip_text = nil
  self.touch_direction = nil
  self.touch_select = nil
  self.touch_arrow_go = nil
  self.guide_go = nil
  self.guideState = nil
end

local function DataDefine(self)
  self.state = nil
  self.allPoint = nil
  self.guideNeedRoad = {}
  self.curIndex = 0
  self.freeRedBlock = {}
  self.redBlock = {}
  self.maxCanBuildNum = 0
  self.flag = {}
  self.flagState = PlaceRoadFlagState.None
  self.clickPoint = {}
  self.showReasonTime = 0
  self.guideBlock = {}
  self.putState = nil
  self.ScreenY = Screen.height
  self.ScreenX = Screen.width
  local x, y = self.transform:Get_lossyScale()
  self.leftRange = InputRange.left * y
  self.rightRange = InputRange.right * y
  self.topRange = InputRange.top * y
  self.bottomRange = InputRange.bottom * y
  self.originalTouchX = 0
  self.originalTouchY = 0
  self.perX = 0
  self.perY = 0
  self.move = false
  self.guideState = GuideState.None
  self.perBuildTime = 1000
end

local function DataDestroy(self)
  self.allPoint = nil
  self.state = nil
  self.guideNeedRoad = {}
  self.curIndex = nil
  self.freeRedBlock = nil
  self.redBlock = nil
  self.maxCanBuildNum = nil
  self.flag = nil
  self.flagState = nil
  self.clickPoint = nil
  self.showReasonTime = nil
  self.guideBlock = {}
  self.putState = nil
  self.ScreenY = nil
  self.ScreenX = nil
  self.leftRange = nil
  self.rightRange = nil
  self.topRange = nil
  self.bottomRange = nil
  self.perX = nil
  self.perY = nil
  self.originalTouchX = nil
  self.originalTouchY = nil
  self.move = nil
  self.guideState = nil
  self.perBuildTime = nil
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ReInit(self)
  EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
  local roadType, focusPointId = self:GetUserData()
  if roadType == PlaceRoadState.Build then
    self:ShowMainCanNotPutRoadEffect()
  end
  self.param = {}
  if roadType ~= nil and roadType ~= "" then
    roadType = tonumber(roadType)
  else
    roadType = PlaceRoadState.Build
  end
  if roadType == PlaceRoadState.Build then
    UIUtil.ShowTipsId(GameDialogDefine.HAS_ENTER_BUILD_ROAD)
  end
  self.guideState = GuideState.None
  self.move = false
  self.enterCameraPos = nil
  if focusPointId == nil or focusPointId <= 0 then
    self.enterCameraPos = CS.SceneManager.World.CurTarget
  else
    self.enterCameraPos = SceneUtils.TileIndexToWorld(focusPointId)
  end
  self.exit_btn:SetActive(true)
  self:ChangeState(roadType)
  CS.SceneManager.World:SetUseInput(false)
  DataCenter.BuildBubbleManager:EnterBuildRoad()
  self.maxCanBuildNum = DataCenter.BoardManager:GetBoardBuildMaxCount()
  self.perBuildTime = DataCenter.BoardManager:GetBoardBuildTime()
  self.guide_go:SetActive(false)
  self.hasBuildNum = DataCenter.BoardManager:GetBoardCount()
  self.tip_text:SetLocalText(GameDialogDefine.PLEASE_BUILD_ROAD_IN_TOP)
  self:LoadFlag(PlaceRoadFlagState.Start)
  self:LoadFlag(PlaceRoadFlagState.End)
  self:RefreshCount()
  self:ShowBtn()
  self:CheckInGuide()
  self.originalTouchX = self.touch_direction.transform.position.x
  self.originalTouchY = self.touch_direction.transform.position.y
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnWorldInputPointDrag, self.OnWorldInputPointDragSignal)
  self:AddUIListener(EventId.OnWorldInputPointClick, self.OnWorldInputPointClickSignal)
  self:AddUIListener(EventId.OnWorldInputPointDown, self.OnWorldInputPointDownSignal)
  self:AddUIListener(EventId.OnWorldInputPointUp, self.OnWorldInputPointUpSignal)
  self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnWorldInputPointDrag, self.OnWorldInputPointDragSignal)
  self:RemoveUIListener(EventId.OnWorldInputPointClick, self.OnWorldInputPointClickSignal)
  self:RemoveUIListener(EventId.OnWorldInputPointDown, self.OnWorldInputPointDownSignal)
  self:RemoveUIListener(EventId.OnWorldInputPointUp, self.OnWorldInputPointUpSignal)
  self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
end

local function ClosePanel(self)
  if CS.SceneManager.World ~= nil then
    CS.SceneManager.World:SetUseInput(true)
    CS.SceneManager.World:SetTouchInputControllerEnable(true)
    DataCenter.BuildBubbleManager:ExitBuildRoad()
  end
  EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
end

local function OnConfirmBtnClick(self)
  if self.state == PlaceRoadState.Build then
    local list = self:GetSendList()
    local count = table.count(list)
    if 0 < count then
      CS.SceneManager.World:UIChangeRoad()
      local needTime = (count - 1) * self.perBuildTime
      self.hasBuildNum = self.hasBuildNum + count
      SFSNetwork.SendMessage(MsgDefines.BuildRoadCreateNew, {arr = list, pathTime = needTime})
    end
    self:OnExitBtnClick()
  elseif self.state == PlaceRoadState.Remove then
    UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.IS_NEED_REMOVE_ROAD), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
      self.hasBuildNum = self.hasBuildNum - table.count(self.clickPoint)
      SFSNetwork.SendMessage(MsgDefines.BuildRoadDestroyNew, {
        arr = self.clickPoint
      })
      self:OnCancelBtnClick()
    end, function()
    end)
  end
end

local function OnCancelBtnClick(self)
  if self.state == PlaceRoadState.Build then
    local count = table.count(self.clickPoint)
    CS.SceneManager.World:UIHideBoard(count, true)
  elseif self.state == PlaceRoadState.Remove then
    for k, v in ipairs(self.clickPoint) do
      self:RemoveOneRed(v)
    end
  end
  self.clickPoint = {}
  self:RefreshCount()
  self:ShowBtn()
  self:RefreshFlags()
end

local function OnBuildRoadBtnClick(self)
  if self:ChangeState(PlaceRoadState.Build) then
    UIUtil.ShowTipsId(GameDialogDefine.CUR_CHANGE_BUILD_ROAD)
  end
end

local function OnRemoveRoadBtnClick(self)
  if self.guideState == GuideState.None and self:ChangeState(PlaceRoadState.Remove) then
    UIUtil.ShowTipsId(GameDialogDefine.CUR_CHANGE_REMOVE_ROAD)
  end
end

local function OnExitBtnClick(self)
  self:OnCancelBtnClick()
  self.ctrl:CloseSelf()
end

local function ChangeState(self, state)
  if self.state ~= state then
    self:OnCancelBtnClick()
    self.state = state
    if state == PlaceRoadState.Build then
      self.select_go.transform.position = self.build_btn.transform.position
    elseif state == PlaceRoadState.Remove then
      self.select_go.transform.position = self.remove_btn.transform.position
    end
    return true
  end
  return false
end

local function LoadFlag(self, flagState)
  self.flag[flagState] = {}
  self.flag[flagState].isActive = false
  self:GameObjectInstantiateAsync(UIAssets.RoadFlag, function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    if go ~= nil then
      self.flag[flagState].go = go
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local isActive = self.flag[flagState].isActive
      self.flag[flagState].isActive = nil
      local index = self.flag[flagState].index
      self.flag[flagState].index = nil
      self:RefreshFlag(flagState, isActive, index)
    end
  end)
end

local function RefreshFlag(self, flagState, isActive, index)
  local param = self.flag[flagState]
  if param ~= nil then
    if param.go == nil then
      param.isActive = isActive
      param.index = index
    else
      if param.isActive ~= isActive then
        param.isActive = isActive
        param.go:SetActive(isActive)
      end
      if isActive and param.index ~= index then
        param.index = index
        param.go.transform.position = SceneUtils.TileIndexToWorld(index) + BlockPos + PosDelta
      end
    end
  end
end

local function RefreshNoReason(self, putState)
  do
    local str = ""
    if putState == BuildPutState.OutMyRange then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.DISTANCE_RANGE_FAR_NO_BUILD)
    elseif putState == BuildPutState.InOtherBaseRange then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.DISTANCE_RANGE_FAR_NO_BUILD)
    elseif putState == BuildPutState.OutUnlockRange then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.OUT_UNLOCK_RANGE_REASON)
    elseif putState == BuildPutState.StaticPoint then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.NO_PUT_ROAD)
    elseif putState == BuildPutState.Board then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.INCLUDE_MY_ROAD)
    elseif putState == BuildPutState.Collect then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.INCLUD_MINEPOINT)
    elseif putState == BuildPutState.UnConnectBoard then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.UNCONNECT_BOARD_REASON)
    elseif putState == BuildPutState.OnBaseExpansion then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.NOT_BUILD_ON_BASE_EXPANSION)
    elseif putState == BuildPutState.OnWorldResource then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.NOT_BUILD_ON_WORLD_RESOURCE)
    elseif putState == BuildPutState.CollectRange then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.INCLUDE_MINERANGE_POINT)
    elseif putState == BuildPutState.ReachBuildMax then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.ROAD_REACH_BUILD_MAX)
    elseif putState == BuildPutState.GuideBuildRoad then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.GUIDE_BUILD_ROAD)
    elseif putState == BuildPutState.WorldMonster then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.MONSTER)
    elseif putState == BuildPutState.MONSTER_REWARD then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.NO_PUT_MONSTER_REWARD)
    elseif putState == BuildPutState.OnGarbage then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.NO_PUT_GARBAGE)
    elseif putState == BuildPutState.NoBuildInMyInside then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.ROAD_NO_BUILD_IN_CITY)
    elseif putState == BuildPutState.NoRemoveInMyInside then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.ROAD_NO_REMOVE_IN_CITY)
    elseif putState == BuildPutState.Building then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.NO_PUT_ROAD)
    elseif putState == BuildPutState.OnGhostrecon then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.NO_PUT_ROAD)
    elseif putState == BuildPutState.OnLandLock then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.LOCK)
    elseif putState == BuildPutState.PveMonster then
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.BUILD_INCLUDE_PVE_MONSTER)
    else
      str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.NO_PUT_ROAD)
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime - self.showReasonTime > ShowTipDuringTime and str ~= "" then
      self.showReasonTime = curTime
      UIUtil.ShowTips(str)
    end
  end
end

local function CheckInGuide(self)
  if DataCenter.GuideManager:InGuide() then
    local guideTemplate = DataCenter.GuideManager:GetCurTemplate()
    if guideTemplate ~= nil then
      if guideTemplate.type == GuideType.BuildRoad then
        self.guideState = GuideState.WaitBuildRoad
        self.exit_btn:SetActive(false)
        if guideTemplate.para1 ~= nil and guideTemplate.para1 ~= "" then
          self.guideNeedRoad = {}
          local mainPosX = DataCenter.BuildManager.main_city_pos.x
          local mainPosY = DataCenter.BuildManager.main_city_pos.y
          local spl = string.split(guideTemplate.para1, ";")
          local lastPointX = 0
          local lastPointY = 0
          local curPointX = 0
          local curPointY = 0
          for k, v in ipairs(spl) do
            lastPointX = curPointX
            lastPointY = curPointY
            local spl1 = string.split(v, ",")
            if table.count(spl1) > 1 then
              curPointX = mainPosX + tonumber(spl1[1])
              curPointY = mainPosY + tonumber(spl1[2])
            end
            if lastPointX ~= 0 and lastPointY ~= 0 then
              if lastPointX ~= curPointX then
                while lastPointX ~= curPointX do
                  if lastPointX > curPointX then
                    lastPointX = lastPointX - 1
                  else
                    lastPointX = lastPointX + 1
                  end
                  self.guideNeedRoad[SceneUtils.TilePosToIndex({x = lastPointX, y = lastPointY})] = false
                end
              elseif lastPointY ~= curPointY then
                while lastPointY ~= curPointY do
                  if lastPointY > curPointY then
                    lastPointY = lastPointY - 1
                  else
                    lastPointY = lastPointY + 1
                  end
                  self.guideNeedRoad[SceneUtils.TilePosToIndex({x = lastPointX, y = lastPointY})] = false
                end
              end
            else
              self.guideNeedRoad[SceneUtils.TilePosToIndex({x = curPointX, y = curPointY})] = false
            end
          end
          for k1, v1 in pairs(self.guideNeedRoad) do
            local index = k1
            self:GameObjectInstantiateAsync(UIAssets.BuildBlock, function(request)
              if request.isError then
                return
              end
              local go = request.gameObject
              go:SetActive(true)
              go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
              go.transform.position = SceneUtils.TileIndexToWorld(index) + BlockPos
              self.guideBlock[index] = go
            end)
          end
          if guideTemplate.para2 ~= nil and guideTemplate.para2 ~= "" then
            local spl2 = string.split_ss_array(guideTemplate.para2, ",")
            if table.count(spl2) > 1 then
              local vec = {}
              vec.x = DataCenter.BuildManager.main_city_pos.x + tonumber(spl2[1])
              vec.y = DataCenter.BuildManager.main_city_pos.y + tonumber(spl2[2])
              self.enterCameraPos = SceneUtils.TileToWorld(vec)
            end
          end
        end
      elseif guideTemplate.type == GuideType.ShowBuildRoadAnim then
        self.guideState = GuideState.ShowAnim
        self.guide_go:SetActive(true)
        self.exit_btn:SetActive(false)
      end
    end
  else
    self.guideState = GuideState.None
    self.guide_go:SetActive(false)
    self.exit_btn:SetActive(true)
    for k, v in pairs(self.guideBlock) do
      v:SetActive(false)
    end
    self.guideBlock = {}
    self.guideNeedRoad = {}
  end
end

local function RefreshCount(self)
  self.use_count_text:SetText(self:GetLeftCount())
end

local function GetLeftCount(self)
  local result = 0
  if self.state == PlaceRoadState.Build then
    result = self.maxCanBuildNum - self.hasBuildNum - self:GetBuildCount()
  elseif self.state == PlaceRoadState.Remove then
    result = self.maxCanBuildNum - self.hasBuildNum + table.count(self.clickPoint)
  end
  return result
end

local function GetBuildCount(self)
  local count = 0
  local catch = {}
  for k, v in ipairs(self.clickPoint) do
    if not DataCenter.BoardManager:IsHasBoard(v) and catch[v] == nil then
      count = count + 1
      catch[v] = true
    end
  end
  return count
end

local function OnWorldInputPointDragSignal(self, data)
  if self.state == PlaceRoadState.Build and data ~= nil and self.guideState ~= GuideState.Done then
    local index = tonumber(data)
    if self:IsCanInput(index) then
      self:CheckBuildIndex(index)
    end
  end
end

local function CheckBuildIndex(self, index)
  if self.flagState ~= PlaceRoadFlagState.None then
    local reason = self:GetBuildRoadState(index)
    if reason == BuildPutState.Ok then
      self:RefreshFlags()
      self:RefreshCount()
      self:CheckGuideComplete()
    else
      self:RefreshNoReason(reason)
    end
    self.putState = reason
  end
end

local function OnWorldInputPointClickSignal(self, data)
  if self.state == PlaceRoadState.Remove and data ~= nil then
    local index = tonumber(data)
    if self:IsCanInput(index) then
      self:CheckRemoveIndex(index)
      self:ShowBtn()
    end
  end
end

local function CheckRemoveIndex(self, index)
  local list = self:GetRemoveList(index)
  if list ~= nil and table.count(list) > 0 then
    for k, v in ipairs(self.clickPoint) do
      self:RemoveOneRed(v)
    end
    self.clickPoint = list
    for k, v in ipairs(self.clickPoint) do
      self:ShowOneRedBlock(v)
    end
    self:RefreshCount()
  end
end

local function OnWorldInputPointUpSignal(self)
  if self.state == PlaceRoadState.Build then
    if self.flagState ~= PlaceRoadFlagState.None and self.guideState == GuideState.None then
      self:ShowBtn()
    end
    self.flagState = PlaceRoadFlagState.None
  end
end

local function ShowBtn(self)
  local count = table.count(self.clickPoint)
  if 0 < count then
    local index = 0
    if self.state == PlaceRoadState.Build then
      if self.flagState == PlaceRoadFlagState.Start then
        index = self.clickPoint[1]
      elseif self.flagState == PlaceRoadFlagState.End then
        index = self.clickPoint[count]
      end
    elseif self.state == PlaceRoadState.Remove then
      index = self.clickPoint[count]
    end
    self.btn_go:SetActive(true)
    local vec = SceneUtils.TileIndexToWorld(index)
    self.AutoAdjustScreenPos:Init(vec)
  else
    self.btn_go:SetActive(false)
  end
end

local function OnWorldInputPointDownSignal(self, data)
  if not CS.UIUtils.CheckGuiRaycastObjects() and data ~= nil then
    local index = tonumber(data)
    if self:IsCanInput(index) then
      CS.SceneManager.World.CanMoving = false
      if self.state == PlaceRoadState.Build then
        self:CheckStartFlag(index)
        if self.flagState ~= PlaceRoadFlagState.None then
          self.btn_go:SetActive(false)
        else
          self:RefreshNoReason(BuildPutState.StaticPoint)
        end
        self:CheckGuideComplete()
      end
    else
      CS.SceneManager.World.CanMoving = false
    end
  end
end

local function CheckStartFlag(self, index)
  if self.flagState == PlaceRoadFlagState.None then
    local count = table.count(self.clickPoint)
    if count == 0 then
      local reason = self:GetBuildRoadState(index)
      if reason == BuildPutState.Ok then
        self.flagState = PlaceRoadFlagState.End
      end
    elseif count == 1 then
      self.flagState = PlaceRoadFlagState.End
      self:GetBuildRoadState(index)
    else
      local posIndex = SceneUtils.IndexToTilePos(index)
      local startPos = SceneUtils.IndexToTilePos(self.clickPoint[1])
      local endPos = SceneUtils.IndexToTilePos(self.clickPoint[count])
      if (startPos.x - posIndex.x) * (startPos.x - posIndex.x) + (startPos.y - posIndex.y) * (startPos.y - posIndex.y) < (endPos.x - posIndex.x) * (endPos.x - posIndex.x) + (endPos.y - posIndex.y) * (endPos.y - posIndex.y) then
        self.flagState = PlaceRoadFlagState.Start
      else
        self.flagState = PlaceRoadFlagState.End
      end
      self:GetBuildRoadState(index)
    end
    self:RefreshFlags()
    self:RefreshCount()
  end
end

local function RefreshFlags(self)
  local count = table.count(self.clickPoint)
  if 0 < count then
    self:RefreshFlag(PlaceRoadFlagState.Start, true, self.clickPoint[1])
    self:RefreshFlag(PlaceRoadFlagState.End, true, self.clickPoint[count])
  else
    self:RefreshFlag(PlaceRoadFlagState.Start, false)
    self:RefreshFlag(PlaceRoadFlagState.End, false)
  end
end

local function RemoveOneRed(self, index)
  local go = self.redBlock[index]
  if go ~= nil then
    go.gameObject:SetActive(false)
    table.insert(self.freeRedBlock, go)
    self.redBlock[index] = nil
  end
end

local function ShowOneRedBlock(self, index)
  if table.count(self.freeRedBlock) > 0 then
    local go = table.remove(self.freeRedBlock)
    if go ~= nil then
      go:SetActive(true)
      go.transform.position = SceneUtils.TileIndexToWorld(index) + BlockPos + PosDelta
      self.redBlock[index] = go
    end
  else
    self:GameObjectInstantiateAsync(UIAssets.RoadBlockRed, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go:SetActive(true)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      go.transform.position = SceneUtils.TileIndexToWorld(index) + BlockPos + PosDelta
      self.redBlock[index] = go
    end)
  end
end

local function GetRemoveUseIndex(self, index)
  for k, v in ipairs(self.clickPoint) do
    if v == index then
      return k
    end
  end
end

local function GetBuildRoadState(self, index)
  local result = BuildPutState.None
  local usePos, lastIndex, circleIndex
  if self.guideState == GuideState.WaitBuildRoad and self.guideNeedRoad[index] == nil then
    return BuildPutState.GuideBuildRoad
  else
  end
  local count = table.count(self.clickPoint)
  if self.flagState == PlaceRoadFlagState.None or count == 0 then
    if 0 >= self:GetLeftCount() then
      return BuildPutState.ReachBuildMax
    else
      result = BuildingUtils.IsCanPutDownBoardByPoint(index)
      if result == BuildPutState.Ok then
        table.insert(self.clickPoint, index)
        CS.SceneManager.World:UICreateBoard(index, true)
        self:RefreshGuideBlockActive(index, false)
      end
    end
  elseif self.flagState == PlaceRoadFlagState.Start then
    usePos = self.clickPoint[1]
    if 2 <= count then
      lastIndex = self.clickPoint[2]
    end
    if 4 <= count then
      circleIndex = self.clickPoint[4]
    end
    local pos = SceneUtils.IndexToTilePos(index)
    local posEnd = SceneUtils.IndexToTilePos(usePos)
    local endDelta = {}
    endDelta.x = posEnd.x - pos.x
    endDelta.y = posEnd.y - pos.y
    local absEnd = math.abs(endDelta.x) + math.abs(endDelta.y)
    if absEnd <= 2 then
      if absEnd == 0 then
        return BuildPutState.Ok
      elseif absEnd == 1 then
        if lastIndex == index then
          if count == 2 then
            self:RefreshGuideBlockActive(self.clickPoint[2], true)
            table.remove(self.clickPoint, 2)
            self:RefreshGuideBlockActive(self.clickPoint[1], true)
            table.remove(self.clickPoint, 1)
            CS.SceneManager.World:UIHideBoard(2, false)
            return BuildPutState.Ok
          else
            self:RefreshGuideBlockActive(self.clickPoint[1], true)
            table.remove(self.clickPoint, 1)
            CS.SceneManager.World:UIHideBoard(1, false)
            return BuildPutState.Ok
          end
        elseif circleIndex == index then
          self:RefreshGuideBlockActive(self.clickPoint[4], true)
          self:RefreshGuideBlockActive(self.clickPoint[3], true)
          self:RefreshGuideBlockActive(self.clickPoint[2], true)
          self:RefreshGuideBlockActive(self.clickPoint[1], true)
          table.remove(self.clickPoint, 4)
          table.remove(self.clickPoint, 3)
          table.remove(self.clickPoint, 2)
          table.remove(self.clickPoint, 1)
          CS.SceneManager.World:UIHideBoard(4, false)
          return BuildPutState.Ok
        elseif 0 >= self:GetLeftCount() then
          return BuildPutState.ReachBuildMax
        else
          result = BuildingUtils.IsCanPutDownBoardByPoint(index)
          if result == BuildPutState.Ok then
            self:RefreshGuideBlockActive(index, false)
            table.insert(self.clickPoint, 1, index)
            CS.SceneManager.World:UICreateBoard(index, false)
          end
        end
      elseif absEnd == 2 then
        local thirdIndex = 0
        if 3 <= count then
          thirdIndex = self.clickPoint[3]
        end
        if thirdIndex == index then
          if count == 3 then
            self:RefreshGuideBlockActive(self.clickPoint[3], true)
            self:RefreshGuideBlockActive(self.clickPoint[2], true)
            self:RefreshGuideBlockActive(self.clickPoint[1], true)
            table.remove(self.clickPoint, 3)
            table.remove(self.clickPoint, 2)
            table.remove(self.clickPoint, 1)
            CS.SceneManager.World:UIHideBoard(3, false)
            return BuildPutState.Ok
          else
            self:RefreshGuideBlockActive(self.clickPoint[2], true)
            self:RefreshGuideBlockActive(self.clickPoint[1], true)
            table.remove(self.clickPoint, 2)
            table.remove(self.clickPoint, 1)
            CS.SceneManager.World:UIHideBoard(2, false)
            return BuildPutState.Ok
          end
        else
          local extraList = self:GetCanConnectIndex(index, endDelta.x, endDelta.y)
          for k, v in ipairs(extraList) do
            local leftCount = self:GetLeftCount()
            if leftCount <= 0 then
              return BuildPutState.ReachBuildMax
            elseif lastIndex == v then
              result = BuildingUtils.IsCanPutDownBoardByPoint(index)
              if result == BuildPutState.Ok then
                self:RefreshGuideBlockActive(self.clickPoint[1], true)
                table.remove(self.clickPoint, 1)
                CS.SceneManager.World:UIHideBoard(1, false)
                self:RefreshGuideBlockActive(index, false)
                table.insert(self.clickPoint, 1, index)
                CS.SceneManager.World:UICreateBoard(index, false)
                return result
              end
            elseif leftCount <= 1 then
              return BuildPutState.ReachBuildMax
            else
              result = BuildingUtils.IsCanPutDownBoardByPoint(v)
              if result == BuildPutState.Ok then
                self:RefreshGuideBlockActive(v, false)
                table.insert(self.clickPoint, 1, v)
                CS.SceneManager.World:UICreateBoard(v, false)
                result = BuildingUtils.IsCanPutDownBoardByPoint(index)
                if result == BuildPutState.Ok then
                  self:RefreshGuideBlockActive(index, false)
                  table.insert(self.clickPoint, 1, index)
                  CS.SceneManager.World:UICreateBoard(index, false)
                  return result
                end
                break
              end
            end
          end
        end
      end
    else
      local continueX = true
      local continueY = true
      local leftCount = self:GetLeftCount()
      local useX = 0
      local useY = 0
      local deltaX = pos.x - posEnd.x
      local deltaY = pos.y - posEnd.y
      local tempIndex = usePos
      while continueX or continueY do
        if continueX then
          if deltaX == 0 then
            continueX = false
          elseif 0 < deltaX then
            if useX >= deltaX then
              continueX = false
            else
              useX = useX + 1
            end
          elseif deltaX >= useX then
            continueX = false
          else
            useX = useX - 1
          end
          if continueX then
            tempIndex = SceneUtils.GetIndexByOffset(usePos, useX, useY)
            result = BuildingUtils.IsCanPutDownBoardByPoint(tempIndex)
            if result == BuildPutState.Ok then
              if 0 < leftCount then
                if not self:IsHasBoard(tempIndex) then
                  leftCount = leftCount - 1
                end
                self:RefreshGuideBlockActive(tempIndex, false)
                table.insert(self.clickPoint, 1, tempIndex)
                CS.SceneManager.World:UICreateBoard(tempIndex, false)
              else
                return BuildPutState.ReachBuildMax
              end
            else
              continueX = false
              return result
            end
          end
        end
        if continueY then
          if deltaY == 0 then
            continueY = false
          elseif 0 < deltaY then
            if useY >= deltaY then
              continueY = false
            else
              useY = useY + 1
            end
          elseif deltaY >= useY then
            continueY = false
          else
            useY = useY - 1
          end
          if continueY then
            tempIndex = SceneUtils.GetIndexByOffset(usePos, useX, useY)
            result = BuildingUtils.IsCanPutDownBoardByPoint(tempIndex)
            if result == BuildPutState.Ok then
              if 0 < leftCount then
                if not self:IsHasBoard(tempIndex) then
                  leftCount = leftCount - 1
                end
                self:RefreshGuideBlockActive(tempIndex, false)
                table.insert(self.clickPoint, 1, tempIndex)
                CS.SceneManager.World:UICreateBoard(tempIndex, false)
              else
                return BuildPutState.ReachBuildMax
              end
            else
              continueY = false
              return result
            end
          end
        end
      end
    end
  elseif self.flagState == PlaceRoadFlagState.End then
    usePos = self.clickPoint[count]
    if 1 < count then
      lastIndex = self.clickPoint[count - 1]
    end
    if 3 < count then
      circleIndex = self.clickPoint[count - 3]
    end
    local pos = SceneUtils.IndexToTilePos(index)
    local posEnd = SceneUtils.IndexToTilePos(usePos)
    local endDelta = {}
    endDelta.x = posEnd.x - pos.x
    endDelta.y = posEnd.y - pos.y
    local absEnd = math.abs(endDelta.x) + math.abs(endDelta.y)
    if absEnd <= 2 then
      if absEnd == 0 then
        return BuildPutState.Ok
      elseif absEnd == 1 then
        if lastIndex == index then
          if count == 2 then
            self:RefreshGuideBlockActive(self.clickPoint[2], true)
            self:RefreshGuideBlockActive(self.clickPoint[1], true)
            table.remove(self.clickPoint, 2)
            table.remove(self.clickPoint, 1)
            CS.SceneManager.World:UIHideBoard(2, true)
            return BuildPutState.Ok
          else
            table.remove(self.clickPoint)
            self:RefreshGuideBlockActive(self.clickPoint[1], true)
            CS.SceneManager.World:UIHideBoard(1, true)
            return BuildPutState.Ok
          end
        elseif circleIndex == index then
          self:RefreshGuideBlockActive(self.clickPoint[count], true)
          self:RefreshGuideBlockActive(self.clickPoint[count - 1], true)
          self:RefreshGuideBlockActive(self.clickPoint[count - 2], true)
          self:RefreshGuideBlockActive(self.clickPoint[count - 3], true)
          table.remove(self.clickPoint, count)
          table.remove(self.clickPoint, count - 1)
          table.remove(self.clickPoint, count - 2)
          table.remove(self.clickPoint, count - 3)
          CS.SceneManager.World:UIHideBoard(4, true)
          return BuildPutState.Ok
        elseif 0 >= self:GetLeftCount() then
          return BuildPutState.ReachBuildMax
        else
          result = BuildingUtils.IsCanPutDownBoardByPoint(index)
          if result == BuildPutState.Ok then
            self:RefreshGuideBlockActive(index, false)
            table.insert(self.clickPoint, index)
            CS.SceneManager.World:UICreateBoard(index, true)
          end
        end
      elseif absEnd == 2 then
        local thirdIndex = 0
        if 3 <= count then
          thirdIndex = self.clickPoint[count - 2]
        end
        if thirdIndex == index then
          if count == 3 then
            self:RefreshGuideBlockActive(self.clickPoint[3], true)
            self:RefreshGuideBlockActive(self.clickPoint[2], true)
            self:RefreshGuideBlockActive(self.clickPoint[1], true)
            table.remove(self.clickPoint, 3)
            table.remove(self.clickPoint, 2)
            table.remove(self.clickPoint, 1)
            CS.SceneManager.World:UIHideBoard(3, true)
            return BuildPutState.Ok
          else
            self:RefreshGuideBlockActive(self.clickPoint[count], true)
            self:RefreshGuideBlockActive(self.clickPoint[count - 1], true)
            table.remove(self.clickPoint, count)
            table.remove(self.clickPoint, count - 1)
            CS.SceneManager.World:UIHideBoard(2, true)
            return BuildPutState.Ok
          end
        else
          local extraList = self:GetCanConnectIndex(index, endDelta.x, endDelta.y)
          for k, v in ipairs(extraList) do
            local leftCount = self:GetLeftCount()
            if leftCount <= 0 then
              return BuildPutState.ReachBuildMax
            elseif lastIndex == v then
              result = BuildingUtils.IsCanPutDownBoardByPoint(index)
              if result == BuildPutState.Ok then
                self:RefreshGuideBlockActive(self.clickPoint[count], true)
                table.remove(self.clickPoint, count)
                CS.SceneManager.World:UIHideBoard(1, true)
                self:RefreshGuideBlockActive(index, false)
                table.insert(self.clickPoint, index)
                CS.SceneManager.World:UICreateBoard(index, true)
                return result
              end
            elseif leftCount <= 1 then
              return BuildPutState.ReachBuildMax
            else
              result = BuildingUtils.IsCanPutDownBoardByPoint(v)
              if result == BuildPutState.Ok then
                self:RefreshGuideBlockActive(v, false)
                table.insert(self.clickPoint, v)
                CS.SceneManager.World:UICreateBoard(v, true)
                result = BuildingUtils.IsCanPutDownBoardByPoint(index)
                if result == BuildPutState.Ok then
                  self:RefreshGuideBlockActive(index, false)
                  table.insert(self.clickPoint, index)
                  CS.SceneManager.World:UICreateBoard(index, true)
                  return result
                end
                break
              end
            end
          end
        end
      end
    else
      local continueX = true
      local continueY = true
      local leftCount = self:GetLeftCount()
      local useX = 0
      local useY = 0
      local deltaX = pos.x - posEnd.x
      local deltaY = pos.y - posEnd.y
      local tempIndex = usePos
      while continueX or continueY do
        if continueX then
          if deltaX == 0 then
            continueX = false
          elseif 0 < deltaX then
            if useX >= deltaX then
              continueX = false
            else
              useX = useX + 1
            end
          elseif deltaX >= useX then
            continueX = false
          else
            useX = useX - 1
          end
          if continueX then
            tempIndex = SceneUtils.GetIndexByOffset(usePos, useX, useY)
            result = BuildingUtils.IsCanPutDownBoardByPoint(tempIndex)
            if result == BuildPutState.Ok then
              if 0 < leftCount then
                if not self:IsHasBoard(tempIndex) then
                  leftCount = leftCount - 1
                end
                self:RefreshGuideBlockActive(tempIndex, false)
                table.insert(self.clickPoint, tempIndex)
                CS.SceneManager.World:UICreateBoard(tempIndex, true)
              else
                return BuildPutState.ReachBuildMax
              end
            else
              continueX = false
              return result
            end
          end
        end
        if continueY then
          if deltaY == 0 then
            continueY = false
          elseif 0 < deltaY then
            if useY >= deltaY then
              continueY = false
            else
              useY = useY + 1
            end
          elseif deltaY >= useY then
            continueY = false
          else
            useY = useY - 1
          end
          if continueY then
            tempIndex = SceneUtils.GetIndexByOffset(usePos, useX, useY)
            result = BuildingUtils.IsCanPutDownBoardByPoint(tempIndex)
            if result == BuildPutState.Ok then
              if 0 < leftCount then
                if not self:IsHasBoard(tempIndex) then
                  leftCount = leftCount - 1
                end
                self:RefreshGuideBlockActive(tempIndex, false)
                table.insert(self.clickPoint, tempIndex)
                CS.SceneManager.World:UICreateBoard(tempIndex, true)
              else
                return BuildPutState.ReachBuildMax
              end
            else
              continueY = false
              return result
            end
          end
        end
      end
    end
  end
  return result
end

local function GetSendList(self)
  local list = {}
  local catch = {}
  for k, v in ipairs(self.clickPoint) do
    if not DataCenter.BoardManager:IsHasBoard(v) and catch[v] == nil then
      table.insert(list, v)
      catch[v] = true
    end
  end
  return list
end

local function GetCanConnectIndex(self, index, deltaX, deltaY)
  local result = {}
  if 1 < deltaX or deltaX < -1 then
    table.insert(result, SceneUtils.GetIndexByOffset(index, deltaX / 2, 0))
  elseif 1 < deltaY or deltaY < -1 then
    table.insert(result, SceneUtils.GetIndexByOffset(index, 0, deltaY / 2))
  else
    table.insert(result, SceneUtils.GetIndexByOffset(index, 0, deltaY))
    table.insert(result, SceneUtils.GetIndexByOffset(index, deltaX, 0))
  end
  return result
end

local function IsCanInput(self, pointId)
  if not DataCenter.CityDomeManager:IsInDomeByPoint(pointId) then
    return false
  end
  local screen = CS.SceneManager.World:WorldToScreenPoint(SceneUtils.TileIndexToWorld(pointId))
  local screenX = screen.x
  local screenY = screen.y
  return screenX > self.leftRange and screenX < self.ScreenX - self.rightRange and screenY > self.bottomRange and screenY < self.ScreenY - self.topRange
end

local function GetRemoveList(self, pointId)
  if self:GetRemoveUseIndex(pointId) == nil then
    local road = DataCenter.BoardManager:GetBoardDataByPointId(pointId)
    if road ~= nil and not road:IsMainRoad() then
      local result = {}
      self:GetCanRemoveList(pointId, true, result)
      if table.count(result) == 0 then
        self:GetCanRemoveList(pointId, false, result)
      end
      table.insert(result, pointId)
      return result
    end
  end
end

local function HasRoad(self, pointId, useTop)
  if DataCenter.BoardManager:IsHasBoard(pointId) then
    local road = DataCenter.BoardManager:GetBoardDataByPointId(pointId)
    if useTop then
      if not DataCenter.BoardManager:IsHasBoard(SceneUtils.GetIndexByOffset(pointId, 1, 0)) and not DataCenter.BoardManager:IsHasBoard(SceneUtils.GetIndexByOffset(pointId, -1, 0)) then
        return true
      end
    elseif not DataCenter.BoardManager:IsHasBoard(SceneUtils.GetIndexByOffset(pointId, 0, 1)) and not DataCenter.BoardManager:IsHasBoard(SceneUtils.GetIndexByOffset(pointId, 0, -1)) then
      return true
    end
  end
  return false
end

local function GetCanRemoveList(self, pointId, isTop, result)
  local x = 0
  local y = 0
  local canTopLeft = true
  local canDownRight = true
  local useIndex = 0
  while canTopLeft or canDownRight do
    if isTop then
      y = y + 1
    else
      x = x + 1
    end
    if canTopLeft then
      useIndex = SceneUtils.GetIndexByOffset(pointId, x, y)
      if self:HasRoad(useIndex, isTop) then
        table.insert(result, useIndex)
      else
        canTopLeft = false
      end
    end
    if canDownRight then
      useIndex = SceneUtils.GetIndexByOffset(pointId, -x, -y)
      if self:HasRoad(useIndex, isTop) then
        table.insert(result, useIndex)
      else
        canDownRight = false
      end
    end
  end
end

local function CheckGuideComplete(self)
  if self.guideState == GuideState.WaitBuildRoad then
    local allDone = true
    for k, v in pairs(self.guideNeedRoad) do
      if not v then
        allDone = false
        break
      end
    end
    if allDone then
      self.guideState = GuideState.Done
      self:ShowBtn()
      DataCenter.GuideManager:DoNext()
    end
  end
end

local function OnDrag(self, eventData)
  if self.guideState == GuideState.ShowAnim then
    self.guide_go:SetActive(false)
    self.guideState = GuideState.HideAnim
  end
  self:SetMovePosition(eventData.position)
end

local function OnPointerDown(self, eventData)
  self.touch_arrow_go:SetActive(true)
  self:SetMovePosition(eventData.position)
  if self.guideState ~= GuideState.WaitBuildRoad then
    self.move = true
  end
end

local function OnPointerUp(self, eventData)
  self.touch_select.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
  self.touch_arrow_go:SetActive(false)
  self.move = false
  if self.guideState == GuideState.HideAnim then
    DataCenter.GuideManager:DoNext()
  end
end

local function Update(self)
  if self.move then
    local curPos = CS.SceneManager.World.CurTarget
    curPos.x = curPos.x + self.perX * AutoMoveDelta
    curPos.z = curPos.z + self.perY * AutoMoveDelta
    CS.SceneManager.World:Lookat(curPos)
  end
  local roadType = self:GetUserData()
  if self.allPoint == nil then
    self.allPoint = DataCenter.CityZoneManager:GetAllUnlockPoint()
  end
  PlaceBuildGridManager:GetInstance():RedrawGrid(self.allPoint)
end

local function SetMovePosition(self, pos)
  local x = pos.x - self.originalTouchX
  local y = pos.y - self.originalTouchY
  local per = math.sqrt(x * x + y * y)
  self.perX = x / per
  self.perY = y / per
  local useRange = TouchSelectRange
  if per < TouchSelectRange then
    useRange = per
  end
  self.touch_select.transform:Set_localPosition(self.perX * useRange, self.perY * useRange, ResetPosition.z)
  local angle = math.atan(y, x) * 180 / math.pi
  self.touch_arrow_go:SetEulerAnglesXYZ(0, 0, angle)
end

local function IsHasBoard(self, pointId)
  for k, v in ipairs(self.clickPoint) do
    if v == pointId then
      return true
    end
  end
  return DataCenter.BoardManager:IsHasBoard(pointId)
end

local function RefreshGuideSignal(self)
  self:CheckInGuide()
end

local function RefreshGuideBlockActive(self, index, isActive)
  if self.guideBlock[index] ~= nil then
    self.guideBlock[index]:SetActive(isActive)
    self.guideNeedRoad[index] = not isActive
  end
end

local function ShowMainCanNotPutRoadEffect(self)
  DataCenter.MineCanNotPutRoadEffectManager:AddEffects()
end

local function RemoveMainCanNotPutRoadEffect(self)
  DataCenter.MineCanNotPutRoadEffectManager:RemoveAllEffects()
end

UIPlaceRoadView.OnCreate = OnCreate
UIPlaceRoadView.OnDestroy = OnDestroy
UIPlaceRoadView.OnEnable = OnEnable
UIPlaceRoadView.OnDisable = OnDisable
UIPlaceRoadView.OnAddListener = OnAddListener
UIPlaceRoadView.OnRemoveListener = OnRemoveListener
UIPlaceRoadView.ComponentDefine = ComponentDefine
UIPlaceRoadView.ComponentDestroy = ComponentDestroy
UIPlaceRoadView.DataDefine = DataDefine
UIPlaceRoadView.DataDestroy = DataDestroy
UIPlaceRoadView.ReInit = ReInit
UIPlaceRoadView.ClosePanel = ClosePanel
UIPlaceRoadView.OnConfirmBtnClick = OnConfirmBtnClick
UIPlaceRoadView.OnCancelBtnClick = OnCancelBtnClick
UIPlaceRoadView.RefreshNoReason = RefreshNoReason
UIPlaceRoadView.CheckInGuide = CheckInGuide
UIPlaceRoadView.LoadFlag = LoadFlag
UIPlaceRoadView.RefreshFlag = RefreshFlag
UIPlaceRoadView.RefreshCount = RefreshCount
UIPlaceRoadView.GetLeftCount = GetLeftCount
UIPlaceRoadView.GetBuildCount = GetBuildCount
UIPlaceRoadView.OnBuildRoadBtnClick = OnBuildRoadBtnClick
UIPlaceRoadView.OnRemoveRoadBtnClick = OnRemoveRoadBtnClick
UIPlaceRoadView.OnExitBtnClick = OnExitBtnClick
UIPlaceRoadView.ChangeState = ChangeState
UIPlaceRoadView.OnWorldInputPointDragSignal = OnWorldInputPointDragSignal
UIPlaceRoadView.OnWorldInputPointClickSignal = OnWorldInputPointClickSignal
UIPlaceRoadView.CheckBuildIndex = CheckBuildIndex
UIPlaceRoadView.CheckRemoveIndex = CheckRemoveIndex
UIPlaceRoadView.OnWorldInputPointUpSignal = OnWorldInputPointUpSignal
UIPlaceRoadView.ShowBtn = ShowBtn
UIPlaceRoadView.OnWorldInputPointDownSignal = OnWorldInputPointDownSignal
UIPlaceRoadView.RemoveOneRed = RemoveOneRed
UIPlaceRoadView.ShowOneRedBlock = ShowOneRedBlock
UIPlaceRoadView.GetRemoveUseIndex = GetRemoveUseIndex
UIPlaceRoadView.RefreshFlags = RefreshFlags
UIPlaceRoadView.CheckStartFlag = CheckStartFlag
UIPlaceRoadView.GetBuildRoadState = GetBuildRoadState
UIPlaceRoadView.GetSendList = GetSendList
UIPlaceRoadView.GetCanConnectIndex = GetCanConnectIndex
UIPlaceRoadView.IsCanInput = IsCanInput
UIPlaceRoadView.GetRemoveList = GetRemoveList
UIPlaceRoadView.HasRoad = HasRoad
UIPlaceRoadView.GetCanRemoveList = GetCanRemoveList
UIPlaceRoadView.CheckGuideComplete = CheckGuideComplete
UIPlaceRoadView.OnDrag = OnDrag
UIPlaceRoadView.OnPointerDown = OnPointerDown
UIPlaceRoadView.Update = Update
UIPlaceRoadView.SetMovePosition = SetMovePosition
UIPlaceRoadView.OnPointerUp = OnPointerUp
UIPlaceRoadView.IsHasBoard = IsHasBoard
UIPlaceRoadView.RefreshGuideSignal = RefreshGuideSignal
UIPlaceRoadView.RefreshGuideBlockActive = RefreshGuideBlockActive
UIPlaceRoadView.ShowMainCanNotPutRoadEffect = ShowMainCanNotPutRoadEffect
UIPlaceRoadView.RemoveMainCanNotPutRoadEffect = RemoveMainCanNotPutRoadEffect
return UIPlaceRoadView
