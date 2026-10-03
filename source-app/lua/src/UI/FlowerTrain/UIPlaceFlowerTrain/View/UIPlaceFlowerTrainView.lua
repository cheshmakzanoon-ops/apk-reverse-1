local UIPlaceFlowerTrainView = BaseClass("UIPlaceFlowerTrainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local WorldPlaceItem = require("UI.UISearch.Component.WorldPlaceItem")
local WorldTriggerUtil = require("Util.WorldTriggerUtil")
local btn_go_path = "BtnGo"
local TilePosDelta = Vector3.New(0, 0, 0)

function UIPlaceFlowerTrainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit()
end

function UIPlaceFlowerTrainView:OnDestroy()
  self:ClosePanel()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPlaceFlowerTrainView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnCommonConfirm = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnCommonConfirm:SetOnClick(function()
    self:OnConfirmBtnClick()
  end)
  self.btnCommonCancel = self.viewSkin:AddComponent(self, UIButton, 2)
  self.btnCommonCancel:SetOnClick(function()
    self:OnCancelBtnClick()
  end)
  self.compWorldPlaceItem = self.viewSkin:AddComponent(self, WorldPlaceItem, 3)
  self.textReason = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.textReasonRed = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.imgBuildIcon = self.viewSkin:AddComponent(self, UIImage, 6)
  self.textBuildName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.textBuildDes = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 8)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 9)
  self.btnBack:SetOnClick(function()
    self:OnCancelBtnClick()
  end)
  self.imgCommonBtnCancel = self.viewSkin:AddComponent(self, UIImage, 10)
  self.imgCommonBtnConfirm = self.viewSkin:AddComponent(self, UIImage, 11)
  self.compWorldPlaceItem:SetActive(not BattleFieldUtil.InBattleField())
  self.AutoAdjustScreenPos = self.transform:Find(btn_go_path):GetComponent(typeof(CS.AutoAdjustScreenPos))
end

function UIPlaceFlowerTrainView:ComponentDestroy()
  self.viewSkin = nil
  self.btnCommonConfirm = nil
  self.btnCommonCancel = nil
  self.compWorldPlaceItem = nil
  self.textReason = nil
  self.textReasonRed = nil
  self.imgBuildIcon = nil
  self.textBuildName = nil
  self.textBuildDes = nil
  self.btnBack = nil
  self.imgCommonBtnCancel = nil
  self.imgCommonBtnConfirm = nil
end

function UIPlaceFlowerTrainView:DataDefine()
  self.putState = BuildPutState.None
end

function UIPlaceFlowerTrainView:DataDestroy()
  self.putState = nil
end

function UIPlaceFlowerTrainView:OnAddListener()
  base.OnAddListener(self)
  if self.isInit then
    self:AddUIListener(EventId.UIPlaceFlowerTrainChangePos, self.UIPlaceFlowerTrainChangePosSignal)
  end
end

function UIPlaceFlowerTrainView:OnRemoveListener()
  base.OnRemoveListener(self)
  if self.isInit then
    self:RemoveUIListener(EventId.UIPlaceFlowerTrainChangePos, self.UIPlaceFlowerTrainChangePosSignal)
  end
end

local function ReInit(self)
  if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMain) then
    EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, false)
  else
    DataCenter.GuideManager:SetNoShowUIMain(true)
  end
  self.point, self.goodsId = self:GetUserData()
  local flowerTrainConfigMeta = FlowerTrainUtils.GetFlowerTrainConfigMetaByGoodsId(self.goodsId)
  local flowerTrainDisplayMeta = FlowerTrainUtils.GetFlowerTrainDisplayMetaByGoodsId(self.goodsId)
  if flowerTrainConfigMeta and flowerTrainDisplayMeta then
    if flowerTrainConfigMeta.para7 and #flowerTrainConfigMeta.para7 >= 1 then
      self.size = toInt(flowerTrainConfigMeta.para7[1]) or 5
      self.tile = self.size
    end
    self.startIndex = self.point
    CS.SceneManager.World:SetUseInput(false)
    if self.point == nil or self.point == "" or self.point == 0 then
      self.point = TileBubbleManager:GetInstance():GetPoint()
    end
    local willPos = SceneUtils.TileIndexToWorld(self.point, ForceChangeScene.World, LuaEntry.Player:GetSourceServerId())
    self:ChangeIndex(self.point)
    local temp = willPos + TilePosDelta
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
    self.limitCount = flowerTrainConfigMeta.para1 and toInt(flowerTrainConfigMeta.para1) or IntMaxValue
  else
    self.isInit = false
    self.ctrl:CloseSelf()
  end
  self:SetFlowerTrainInfo(flowerTrainDisplayMeta)
end

function UIPlaceFlowerTrainView:SetFlowerTrainInfo(flowerTrainDisplayMeta)
  if flowerTrainDisplayMeta then
    local iconPath = flowerTrainDisplayMeta.pic5
    self.imgBuildIcon:LoadSpriteAsyncWithCallback(iconPath, function(texture)
      self.imgBuildIcon:SetNativeSize()
    end)
    self.textBuildName:SetLocalText(flowerTrainDisplayMeta.name)
    self.textBuildDes:SetLocalText(flowerTrainDisplayMeta.desc)
  else
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.textBuildDes.transform)
  if self.textBuildDes.transform.rect.height > 100 then
    self.textBuildDes:SetFontSize(25)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  if self.isInit then
    self:AddUIListener(EventId.UIPlaceFlowerTrainChangePos, self.UIPlaceFlowerTrainChangePosSignal)
  end
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  if self.isInit then
    self:RemoveUIListener(EventId.UIPlaceFlowerTrainChangePos, self.UIPlaceFlowerTrainChangePosSignal)
  end
end

local function ClosePanel(self)
  if CS.SceneManager.World ~= nil then
    DataCenter.BuildBubbleManager:ShowBubbleNode()
    CS.SceneManager.World:SetUseInput(true)
    CS.SceneManager.World:SetTouchInputControllerEnable(true)
    CS.SceneManager.World.touchPickablePos:Clear()
    CS.SceneManager.World.SelectBuild = nil
    CS.SceneManager.World:UIDestroyPreCreateFlowerTrain()
  end
  EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE, true)
end

local function OnConfirmBtnClick(self)
  if CrossServerUtil:NeedIntercept() then
    UIUtil.ShowTipsId(500019)
    return
  end
  if not self.point or not self.goodsId then
    Logger.LogError("UIPlaceFlowerTrainView:OnConfirmBtnClick pointId or goodsId is nil")
    return
  end
  if self.putState ~= BuildPutState.Ok then
    if self.putState == BuildPutState.InBlackLandRange then
      UIUtil.ShowTipsId("activity_wajueji_27000_tips10")
    else
      UIUtil.ShowTipsId("halloween_treasure_use_alert4")
    end
    return
  end
  local curFlowerTrainCount = FlowerTrainUtils.GetPlayerAllRunningFlowerTrainCount()
  local isMaxLimit = curFlowerTrainCount >= self.limitCount
  if isMaxLimit then
    local str = Localization:GetString("activity_treasure_error_alert3", self.limitCount)
    UIUtil.ShowTips(str)
    return
  end
  SFSNetwork.SendMessage(MsgDefines.FlowerTrainSend, self.curIndex, self.goodsId)
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
    local v = SceneUtils.TileIndexToWorld(self.curIndex, ForceChangeScene.World, LuaEntry.Player:GetCurServerId()) + BlockPos
    local halfSize = math.floor(self.size / 2)
    self.buildSelect.transform:Set_position(v.x + halfSize, v.y, v.z + halfSize)
    self.buildSelect:ChangeColor(self.putState == BuildPutState.Ok)
  end
end

local function ChangeIndex(self, index)
  self.curIndex = index
  local lastPutState = self.putState
  local lastCross = self.isCross
  self.isCross = CrossServerUtil:NeedIntercept()
  self.putState = FlowerTrainUtils.IsCanPutDownBySize(self.size, index)
  local isChangeState = lastPutState ~= self.putState or lastCross ~= self.isCross
  self:RefreshNoReason(isChangeState, lastPutState == BuildPutState.None or lastPutState == BuildPutState.Ok ~= (self.putState == BuildPutState.Ok))
  self:RefreshBuildSelect()
  local pos = SceneUtils.IndexToTilePos(index, ForceChangeScene.World)
  self.compWorldPlaceItem:InitState(pos.x, pos.y)
end

local function UIPlaceFlowerTrainChangePosSignal(self, data)
  if data ~= nil and data ~= "" then
    local pointId = tonumber(data)
    if self.curIndex ~= pointId then
      self:ChangeIndex(pointId)
    end
  end
end

local function RefreshNoReason(self, isChangeReason, isChangeOk)
  if isChangeReason and CrossServerUtil:NeedIntercept() then
    self.imgCommonBtnConfirm:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm_gray")
    local str = Localization:GetString(458585)
    self.textReasonRed:SetText(str)
    self.textReason:SetActive(false)
    self.textReasonRed:SetActive(true)
    return
  end
  if isChangeOk then
    if self.putState == BuildPutState.Ok then
      self.imgCommonBtnConfirm:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm")
    else
      self.imgCommonBtnConfirm:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm_gray")
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
    str = Localization:GetString("activity_wajueji_27000_tips10")
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
    self.textReason:SetText(str)
    self.textReason:SetActive(true)
    self.textReasonRed:SetActive(false)
  else
    self.textReasonRed:SetText(str)
    self.textReason:SetActive(false)
    self.textReasonRed:SetActive(true)
  end
end

local function ChangeSelectMarch(self)
  if CS.SceneManager.World.SelectBuild ~= nil then
    self.AutoAdjustScreenPos:Init(CS.SceneManager.World.SelectBuild.transform, TilePosDelta)
  end
end

local function RefreshCameraPoint(self)
  if SceneUtils.GetIsInWorld() then
    self.compWorldPlaceItem:InitState()
  end
end

UIPlaceFlowerTrainView.ReInit = ReInit
UIPlaceFlowerTrainView.ClosePanel = ClosePanel
UIPlaceFlowerTrainView.OnConfirmBtnClick = OnConfirmBtnClick
UIPlaceFlowerTrainView.OnCancelBtnClick = OnCancelBtnClick
UIPlaceFlowerTrainView.RefreshBuildSelect = RefreshBuildSelect
UIPlaceFlowerTrainView.LoadBuildSelect = LoadBuildSelect
UIPlaceFlowerTrainView.UIPlaceFlowerTrainChangePosSignal = UIPlaceFlowerTrainChangePosSignal
UIPlaceFlowerTrainView.ChangeIndex = ChangeIndex
UIPlaceFlowerTrainView.RefreshNoReason = RefreshNoReason
UIPlaceFlowerTrainView.ChangeSelectMarch = ChangeSelectMarch
UIPlaceFlowerTrainView.RefreshCameraPoint = RefreshCameraPoint
return UIPlaceFlowerTrainView
