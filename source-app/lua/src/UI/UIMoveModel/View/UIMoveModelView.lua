local base = UIBaseView
local UIMoveModelView = BaseClass("UIMoveModelView", base)
local CS = _ENV.CS
local confirm_btn_path = "BtnGo/common_btn_confirm"
local cancel_btn_path = "BtnGo/common_btn_cancel"
local btn_go_path = "BtnGo"
local TilePosDelta = {
  [FakeMovingModelFlag.Aisilla] = Vector3.New(-1.2, 0, 0),
  [FakeMovingModelFlag.Airship] = Vector3.New(-0.8, 0, 2.2),
  [FakeMovingModelFlag.ZMBoss] = Vector3.New(-0.5, 0, 4),
  [FakeMovingModelFlag.KirovLaunchStation] = Vector3.New(-1.5, -4.7, 4),
  [FakeMovingModelFlag.S0AllianceBuilding] = Vector3.New(-0.2, 0, 1)
}
local BtnPosDelta = {
  [FakeMovingModelFlag.Aisilla] = Vector3.New(0, 0, 0),
  [FakeMovingModelFlag.Airship] = Vector3.New(0, 0, 0),
  [FakeMovingModelFlag.ZMBoss] = Vector3.New(0, 0, -6),
  [FakeMovingModelFlag.KirovLaunchStation] = Vector3.New(0, -2, 0),
  [FakeMovingModelFlag.S0AllianceBuilding] = Vector3.New(0, 0, -6)
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
  self.btnGo = self:AddComponent(UIBaseContainer, btn_go_path)
  self.AutoAdjustScreenPos = self.transform:Find(btn_go_path):GetComponent(typeof(CS.AutoAdjustScreenPos))
  self.confirm_btn:SetOnClick(BindCallback(self, self.OnConfirmBtnClick))
  self.cancel_btn:SetOnClick(BindCallback(self, self.OnCancelBtnClick))
end

local function ComponentDestroy(self)
  self.confirm_btn = nil
  self.confirm_img = nil
  self.cancel_btn = nil
  self.AutoAdjustScreenPos = nil
end

local function DataDefine(self)
  self.flag = 0
  self.curIndex = 0
  self.putState = BuildPutState.None
  self.greenSprite = nil
  self.graySprite = nil
end

local function DataDestroy(self)
  if self.flag == FakeMovingModelFlag.S0AllianceBuilding then
    DataCenter.S0AllianceBossDataManager:SetMovingModelState(false, true)
  end
  self.flag = nil
  self.curIndex = nil
  self.putState = nil
  self.startIndex = nil
  self.isInit = nil
  self.size = nil
  self.greenSprite = nil
  self.graySprite = nil
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
  local flag, pointId, size = self:GetUserData()
  if flag and pointId and size then
    self.flag = flag
    self.size = size
    self.startIndex = pointId
    CS.SceneManager.World:SetUseInput(false)
    if pointId == "" or pointId == 0 then
      pointId = TileBubbleManager:GetInstance():GetPoint()
    end
    local willPos = SceneUtils.TileIndexToWorld(pointId, ForceChangeScene.World, LuaEntry.Player:GetCurServerId())
    self:ChangeIndex(pointId)
    local temp = willPos + TilePosDelta[self.flag]
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
    self.btnGo:SetLocalPosition(BtnPosDelta[self.flag])
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  if self.isInit then
    self:AddUIListener(EventId.UIPlaceMarchChangePos, self.UIPlaceMarchChangePosSignal)
  end
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  if self.isInit then
    self:RemoveUIListener(EventId.UIPlaceMarchChangePos, self.UIPlaceMarchChangePosSignal)
  end
end

local function ClosePanel(self)
  if CS.SceneManager.World ~= nil then
    local world = CS.SceneManager.World
    world:SetUseInput(true)
    world:SetTouchInputControllerEnable(true)
    if world.touchPickablePos then
      world.touchPickablePos:Clear()
    end
    world.SelectBuild = nil
    world:UIDestroyRreCreateModel()
  end
  if self.flag == FakeMovingModelFlag.Aisilla then
    DataCenter.InvasionAisillaCtrlManager:RemoveMovingModel()
  elseif self.flag == FakeMovingModelFlag.Airship then
  elseif self.flag == FakeMovingModelFlag.ZMBoss then
    DataCenter.ZoneMobilizationCtrlManager:RemoveMovingModel()
  elseif self.flag == FakeMovingModelFlag.KirovLaunchStation then
    DataCenter.WorldMoveModelCtrlManager:RemoveMovingModel()
  elseif self.flag == FakeMovingModelFlag.S0AllianceBuilding then
    DataCenter.WorldMoveModelCtrlManager:RemoveMovingModel()
  end
end

local function OnConfirmBtnClick(self)
  if self.startIndex and self.curIndex and self.flag then
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    if self.flag == FakeMovingModelFlag.Airship then
      DataCenter.LWZoneMobilizationManager:RequestPutAirshipBuild(self.curIndex)
      self.ctrl:CloseSelf()
    elseif self.flag == FakeMovingModelFlag.Aisilla then
      DataCenter.ActivityMonsterInvasionDataManager:RequestPutAisilla(self.curIndex, function()
        if self and self.ctrl then
          self.ctrl:CloseSelf()
        end
      end)
    elseif self.flag == FakeMovingModelFlag.ZMBoss then
      DataCenter.LWZoneMobilizationManager:RequestPutBoss(self.curIndex)
      self:DoCancel()
    elseif self.flag == FakeMovingModelFlag.KirovLaunchStation then
      DataCenter.ActivityKillZombieManager:RequestPutKirov(self.curIndex, function()
        if self and self.ctrl then
          self.ctrl:CloseSelf()
        end
      end)
    elseif self.flag == FakeMovingModelFlag.S0AllianceBuilding then
      DataCenter.S0AllianceBossDataManager:RequestMoveBuilding(self.curIndex)
      if self and self.ctrl then
        self.ctrl:CloseSelf()
      end
    end
  else
    self:DoCancel()
  end
end

local function OnCancelBtnClick(self)
  self:DoCancel()
end

local function DoCancel(self)
  self.ctrl:CloseSelf()
end

local function LoadBuildSelect(self)
  self:GameObjectInstantiateAsync(string.format(UIAssets.BuildSelect, self.size, self.size), function(request)
    if request.isError then
      return
    end
    local go = request.gameObject
    if go ~= nil then
      go:SetActive(true)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self.buildSelect = go:GetComponent(typeof(CS.BuildSelect))
      self:RefreshModelSelect()
    end
  end)
end

local function RefreshModelSelect(self)
  if self.buildSelect ~= nil then
    local v = SceneUtils.TileIndexToWorld(self.curIndex, ForceChangeScene.World, LuaEntry.Player:GetCurServerId()) + BlockPos + TilePosDelta[self.flag]
    local halfSize = math.floor(self.size / 2)
    self.buildSelect.transform:Set_position(v.x + halfSize + 1.2, v.y, v.z + halfSize)
    self.buildSelect:ChangeColor(self.putState == BuildPutState.Ok)
  end
end

local function ChangeIndex(self, index)
  self.curIndex = index
  local lastPutState = self.putState
  self.putState = WorldMoveMarchUtil.IsCanPutDownBySize(self.size, index)
  self:RefreshNoReason(lastPutState == BuildPutState.None or lastPutState == BuildPutState.Ok ~= (self.putState == BuildPutState.Ok))
  self:RefreshModelSelect()
end

local function UIPlaceMarchChangePosSignal(self, data)
  if data ~= nil and data ~= "" then
    local pointId = tonumber(data)
    if self.curIndex ~= pointId then
      self:ChangeIndex(pointId)
    end
  end
end

local function RefreshNoReason(self, isChangeOk)
  if isChangeOk then
    if self.putState == BuildPutState.Ok then
      self.confirm_btn:SetInteractable(true)
      if self.greenSprite == nil then
        self.confirm_img:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm")
        self.greenSprite = self.confirm_img:GetImage()
      else
        self.confirm_img:SetImage(self.greenSprite)
      end
    else
      self.confirm_btn:SetInteractable(false)
      if self.graySprite == nil then
        self.confirm_img:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm_gray")
        self.graySprite = self.confirm_img:GetImage()
      else
        self.confirm_img:SetImage(self.graySprite)
      end
    end
  end
end

local function ChangeSelectMarch(self)
  if CS.SceneManager.World ~= nil and CS.SceneManager.World.SelectBuild ~= nil then
    self.AutoAdjustScreenPos:Init(CS.SceneManager.World.SelectBuild.transform, TilePosDelta[self.flag] + BtnPosDelta[self.flag])
  end
end

UIMoveModelView.OnCreate = OnCreate
UIMoveModelView.OnDestroy = OnDestroy
UIMoveModelView.OnEnable = OnEnable
UIMoveModelView.OnDisable = OnDisable
UIMoveModelView.OnAddListener = OnAddListener
UIMoveModelView.OnRemoveListener = OnRemoveListener
UIMoveModelView.ComponentDefine = ComponentDefine
UIMoveModelView.ComponentDestroy = ComponentDestroy
UIMoveModelView.DataDefine = DataDefine
UIMoveModelView.DataDestroy = DataDestroy
UIMoveModelView.ReInit = ReInit
UIMoveModelView.ClosePanel = ClosePanel
UIMoveModelView.OnConfirmBtnClick = OnConfirmBtnClick
UIMoveModelView.OnCancelBtnClick = OnCancelBtnClick
UIMoveModelView.RefreshModelSelect = RefreshModelSelect
UIMoveModelView.LoadBuildSelect = LoadBuildSelect
UIMoveModelView.UIPlaceMarchChangePosSignal = UIPlaceMarchChangePosSignal
UIMoveModelView.ChangeIndex = ChangeIndex
UIMoveModelView.RefreshNoReason = RefreshNoReason
UIMoveModelView.ChangeSelectMarch = ChangeSelectMarch
UIMoveModelView.DoCancel = DoCancel
return UIMoveModelView
