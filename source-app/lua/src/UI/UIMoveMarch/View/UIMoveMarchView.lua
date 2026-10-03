local UIMoveMarchView = BaseClass("UIMoveMarchView", UIBaseView)
local base = UIBaseView
local WorldPlaceItem = require("UI.UISearch.Component.WorldPlaceItem")
local Localization = CS.GameEntry.Localization
local confirm_btn_path = "BtnGo/common_btn_confirm"
local cancel_btn_path = "BtnGo/common_btn_cancel"
local btn_go_path = "BtnGo"
local xy_path = "common_bg3/WorldPlaceItem"
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
  self.xy = self:AddComponent(WorldPlaceItem, xy_path)
end

local function ComponentDestroy(self)
  self.xy:SetActive(false)
  self.confirm_btn = nil
  self.confirm_img = nil
  self.cancel_btn = nil
  self.AutoAdjustScreenPos = nil
end

local function DataDefine(self)
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
  local uuid, point, size, worldPosition = self:GetUserData()
  self.worldPos = worldPosition
  self.uuid = uuid
  self.marchInfo = CS.SceneManager.World:GetMarch(uuid)
  self.size = size
  if self.marchInfo then
    self.startIndex = point
    CS.SceneManager.World:SetUseInput(false)
    self.tile = WorldMoveMarchUtil.GetMarchMonsterSize(uuid)
    if point == nil or point == "" or point == 0 then
      point = TileBubbleManager:GetInstance():GetPoint()
    end
    local willPos = SceneUtils.TileIndexToWorld(point, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
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
    self:DoCancel()
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  if self.isInit then
    self:AddUIListener(EventId.UIPlaceMarchChangeWorldPos, self.UIPlaceMarchChangePosSignal)
    self:AddUIListener(EventId.OnAllyDrillBaseCreate, self.OnAllyDrillBaseCreate)
    self:AddUIListener(EventId.OnAllyDrillBaseCreaterName, self.OnAllyDrillBaseCreaterName)
    self:AddUIListener(EventId.OnAllyDrillStageChange, self.OnAllyDrillStageChange)
  end
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  if self.isInit then
    self:RemoveUIListener(EventId.UIPlaceMarchChangeWorldPos, self.UIPlaceMarchChangePosSignal)
    self:RemoveUIListener(EventId.OnAllyDrillBaseCreate, self.OnAllyDrillBaseCreate)
    self:RemoveUIListener(EventId.OnAllyDrillBaseCreaterName, self.OnAllyDrillBaseCreaterName)
    self:RemoveUIListener(EventId.OnAllyDrillStageChange, self.OnAllyDrillStageChange)
  end
end

local function ClosePanel(self)
  if CS.SceneManager.World ~= nil then
    DataCenter.BuildBubbleManager:ShowBubbleNode()
    CS.SceneManager.World:SetUseInput(true)
    CS.SceneManager.World:SetTouchInputControllerEnable(true)
    CS.SceneManager.World.touchPickablePos:Clear()
    CS.SceneManager.World.SelectBuild = nil
    CS.SceneManager.World:UIDestroyRreCreateMarch()
  end
  if self.marchInfo and self.marchInfo:IsDrillBase() then
    local alyDrillBase = DataCenter.AllyDrillBaseManager:GetDrillBase(self.marchInfo.uuid)
    if alyDrillBase then
      alyDrillBase:SetMoveState(false)
    end
  end
end

local function DoMarchMove(self)
  if self.marchInfo and self.startIndex and self.curIndex then
    if self.marchInfo:IsDrillBase() then
      SFSNetwork.SendMessage(MsgDefines.MoveAllianceBoss, self.startIndex, self.curIndex)
    end
    self.ctrl:CloseSelf()
  else
    self:DoCancel()
  end
end

local function OnConfirmBtnClick(self)
  self:DoMarchMove()
end

local function OnCancelBtnClick(self)
  self:DoCancel()
end

local function DoCancel(self)
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
    local v = self.worldPos + BlockPos
    local halfSize = self.tile - 1
    self.buildSelect.transform:Set_position(v.x + halfSize, v.y, v.z + halfSize)
    self.buildSelect:ChangeColor(self.putState == BuildPutState.Ok)
  end
end

local function ChangeIndex(self, index)
  self.curIndex = index
  local lastPutState = self.putState
  self.putState = WorldMoveMarchUtil.IsCanPutDownBySize(self.size, index)
  if self.worldPos and SeasonUtil.InSeasonBigMapMode(LuaEntry.Player:GetCurServerId()) then
    local serverId = DataCenter.SeasonDataManager:GetNinePalacesServerByWorldPos(self.worldPos, ServerEnum.Source)
    if serverId ~= LuaEntry.Player:GetSourceServerId() then
      self.putState = BuildPutState.UnavailableServer
    end
  end
  self:RefreshNoReason(lastPutState == BuildPutState.None or lastPutState == BuildPutState.Ok ~= (self.putState == BuildPutState.Ok))
  self:RefreshBuildSelect()
  local pos = SceneUtils.IndexToTilePos(index, ForceChangeScene.World)
  self.xy:InitState(pos.x, pos.y)
end

local function UIPlaceMarchChangePosSignal(self, worldPos)
  if worldPos then
    local pointId = SceneUtils.WorldToTileIndex(worldPos)
    if self.curIndex ~= pointId then
      self.worldPos = worldPos
      self:ChangeIndex(pointId)
    end
  end
end

local function RefreshNoReason(self, isChangeOk)
  if isChangeOk then
    if self.putState == BuildPutState.Ok then
      self.confirm_btn:SetInteractable(true)
      self.confirm_img:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm")
    else
      self.confirm_btn:SetInteractable(false)
      self.confirm_img:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm_gray")
    end
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

local function HideBg(self)
end

local function OnAllyDrillBaseCreate(self, uuid)
  if self.marchInfo and self.marchInfo:IsDrillBase() then
    self:DoCancel()
  end
end

local function OnAllyDrillStageChange(self, stage)
  if self.marchInfo and self.marchInfo:IsDrillBase() then
    self:DoCancel()
  end
end

local function OnAllyDrillBaseCreaterName(self, name)
  if self.marchInfo and self.marchInfo:IsDrillBase() then
    if not string.IsNullOrEmpty(name) then
      UIUtil.ShowTips(Localization:GetString("allyDrill_tips_001", name))
    end
    self:DoCancel()
  end
end

UIMoveMarchView.OnCreate = OnCreate
UIMoveMarchView.OnDestroy = OnDestroy
UIMoveMarchView.OnEnable = OnEnable
UIMoveMarchView.OnDisable = OnDisable
UIMoveMarchView.OnAddListener = OnAddListener
UIMoveMarchView.OnRemoveListener = OnRemoveListener
UIMoveMarchView.ComponentDefine = ComponentDefine
UIMoveMarchView.ComponentDestroy = ComponentDestroy
UIMoveMarchView.DataDefine = DataDefine
UIMoveMarchView.DataDestroy = DataDestroy
UIMoveMarchView.ReInit = ReInit
UIMoveMarchView.ClosePanel = ClosePanel
UIMoveMarchView.OnConfirmBtnClick = OnConfirmBtnClick
UIMoveMarchView.OnCancelBtnClick = OnCancelBtnClick
UIMoveMarchView.RefreshBuildSelect = RefreshBuildSelect
UIMoveMarchView.LoadBuildSelect = LoadBuildSelect
UIMoveMarchView.UIPlaceMarchChangePosSignal = UIPlaceMarchChangePosSignal
UIMoveMarchView.ChangeIndex = ChangeIndex
UIMoveMarchView.RefreshNoReason = RefreshNoReason
UIMoveMarchView.ChangeSelectMarch = ChangeSelectMarch
UIMoveMarchView.RefreshCameraPoint = RefreshCameraPoint
UIMoveMarchView.DoMarchMove = DoMarchMove
UIMoveMarchView.DoCancel = DoCancel
UIMoveMarchView.HideBg = HideBg
UIMoveMarchView.OnAllyDrillBaseCreate = OnAllyDrillBaseCreate
UIMoveMarchView.OnAllyDrillStageChange = OnAllyDrillStageChange
UIMoveMarchView.OnAllyDrillBaseCreaterName = OnAllyDrillBaseCreaterName
return UIMoveMarchView
