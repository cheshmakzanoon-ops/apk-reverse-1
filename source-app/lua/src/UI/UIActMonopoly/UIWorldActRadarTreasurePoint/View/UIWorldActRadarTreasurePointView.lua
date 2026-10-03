local UIWorldActRadarTreasurePointView = BaseClass("UIWorldActRadarTreasurePointView", UIBaseView)
local base = UIBaseView
local UIWorldPointBtn = require("UI.UIWorldPoint.Component.UIWorldPointBtn")
local WorldTreasureDetect = require("UI.UIActMonopoly.UIWorldActRadarTreasurePoint.Component.WorldTreasureDetect")
local Localization = CS.GameEntry.Localization
local BtnPosition = {}
BtnPosition[1] = {
  Vector3.New(0, -131.5, 0)
}
BtnPosition[2] = {
  Vector3.New(93.5, -124.5, 0),
  Vector3.New(-93.5, -124.5, 0)
}
BtnPosition[3] = {
  Vector3.New(178.5, -63.5, 0),
  Vector3.New(0, -131.5, 0),
  Vector3.New(-178.5, -63.5, 0)
}
BtnPosition[4] = {
  Vector3.New(241.5, -6.5, 0),
  Vector3.New(93.5, -124.5, 0),
  Vector3.New(-93.5, -124.5, 0),
  Vector3.New(-241.5, -6.5, 0)
}
BtnPosition[5] = {
  Vector3.New(297.5, 92.5, 0),
  Vector3.New(178.5, -63.5, 0),
  Vector3.New(0, -131.5, 0),
  Vector3.New(-178.5, -63.5, 0),
  Vector3.New(-297.5, 92.5, 0)
}
local BtnCellCircle = Vector3.New(0, 120, 0)
local AnimName = {
  Enter = "CommonPopup_movein",
  Exit = "CommonPopup_moveout"
}
local BtnAnim = {}
BtnAnim[1] = {"5Right3"}
BtnAnim[2] = {"4Right2", "4Right3"}
BtnAnim[3] = {
  "5Right2",
  "5Right3",
  "5Right4"
}
BtnAnim[4] = {
  "4Right1",
  "4Right2",
  "4Right3",
  "4Right4"
}
BtnAnim[5] = {
  "5Right1",
  "5Right2",
  "5Right3",
  "5Right4",
  "5Right5"
}
local BtnAnimArabic = {}
BtnAnimArabic[1] = {"5Left3"}
BtnAnimArabic[2] = {"4Left2", "4Left3"}
BtnAnimArabic[3] = {
  "5Left2",
  "5Left3",
  "5Left4"
}
BtnAnimArabic[4] = {
  "4Left1",
  "4Left2",
  "4Left3",
  "4Left4"
}
BtnAnimArabic[5] = {
  "5Left1",
  "5Left2",
  "5Left3",
  "5Left4",
  "5Left5"
}
local BuildAdjust = {
  left = 200,
  right = 200,
  top = 350,
  bottom = 150
}
local bg_arrow_path = "PosGo/message/bgArrow"
local bg_path = "PosGo/message/bg"
local pos_go_path = "PosGo"
local bg_go_path = "PosGo/message/bg"
local pos_go_info_path = "PosGo/message"
local name_text_path = "PosGo/message/bg/Top/nameContent/name/NameText"
local build_btn_obj_path = "PosGo/BuildBtnScale"
local build_btn_go_path = "PosGo/BuildBtnScale/BuildBtnGo"
local this_path = ""
local btn_mark_path = "PosGo/message/bg/Top/Btn_mark"
local btn_share_path = "PosGo/message/bg/Top/Btn_share"
local btn_alliance_share_path = "PosGo/message/bg/Top/Btn_alliance_share"
local btn_detail_path = "PosGo/message/bg/Top/nameContent/btn_detail"
local treasureDetectObj_path = "PosGo/message/bg/TreasureDetectObj"
local top_path = "PosGo/message/bg/Top"
local top_bg_path = "PosGo/message/bg/topBg"
local top_bg_img_path = "PosGo/message/bg/topBg/topBgImg"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  WorldDesertSelectEffectManager:GetInstance():HidePos()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bg_go = self:AddComponent(UIBaseContainer, bg_go_path)
  self.pos_go = self:AddComponent(UIBaseContainer, pos_go_path)
  self.pos_go_info = self:AddComponent(UIBaseContainer, pos_go_info_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
  self.build_btn_obj = self:AddComponent(UIBaseContainer, build_btn_obj_path)
  self.build_btn_go = self:AddComponent(UIBaseContainer, build_btn_go_path)
  self.this_anim = self:AddComponent(UIAnimator, this_path)
  self.build_btn_anim = self:AddComponent(UIAnimator, build_btn_go_path)
  self.treasureDetectObj = self:AddComponent(WorldTreasureDetect, treasureDetectObj_path)
  self.bg_arrow = self:AddComponent(UIImage, bg_arrow_path)
  self.bg = self:AddComponent(UIImage, bg_path)
  self.top = self:AddComponent(UIBaseContainer, top_path)
  self.btn_mark = self:AddComponent(UIButton, btn_mark_path)
  self.btn_mark:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnMarkClick()
  end)
  self.btn_alliance_mark = self:AddComponent(UIButton, btn_alliance_share_path)
  self.btn_alliance_mark:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnMarkClick(true)
  end)
  self.btnMarkImg = self:AddComponent(UIImage, btn_mark_path)
  self.btn_share = self:AddComponent(UIButton, btn_share_path)
  self.btn_share:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShareClick()
  end)
  self.btn_detail = self:AddComponent(UIButton, btn_detail_path)
  self.btn_detail:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnDetailClick()
  end)
  self.btn_detail:SetActive(true)
  self.AutoAdjustScreenPos = self.transform:Find(pos_go_path):GetComponent(typeof(CS.AutoAdjustScreenPos))
  self.posGoComponent = self:AddComponent(UIBaseComponent, pos_go_path)
  self.model = {}
  self.top_bg = self:AddComponent(UIRawImage, top_bg_path)
  self.top_bg_img = self:AddComponent(UIRawImage, top_bg_img_path)
end

local function ComponentDestroy(self)
  self.pos_go = nil
  self.name_text = nil
  self.timer_action = nil
  self.timer_actionArrow = nil
  self.build_btn_obj = nil
  self.build_btn_go = nil
  self.this_anim = nil
  self.build_btn_anim = nil
  self.btn_mark = nil
  self.btn_share = nil
  self.btn_detail = nil
  self.AutoAdjustScreenPos = nil
  self.model = nil
  self.guide_garbage = nil
  self.posGoComponent = nil
  self.top = nil
  self.top_bg = nil
  self.top_bg_img = nil
  if self.allianceCollectReq ~= nil then
    self:GameObjectDestroy(self.allianceCollectReq)
    self.allianceCollectReq = nil
  end
  self.allianceCollectCom = nil
end

local function DataDefine(self)
  self.worldPos = nil
  
  function self.timer_action(temp)
    self:RefreshTime()
  end
  
  function self.timer_actionArrow(temp)
    self:RefreshArrowTime()
  end
  
  self.screenPos = nil
  self.buildBtnCells = {}
  self.animIndex = 0
  self.timer = nil
  self.timerArrow = nil
  self.closeTimer = nil
  self.showIndex = 1
  self.targetBtnPos = 0
  WorldArrowManager:GetInstance():RemoveEffect()
end

local function DataDestroy(self)
  self:DeleteTimer()
  self:DeleteArrowTimer()
  self.worldPos = nil
  self.screenPos = nil
  self.buildBtnCells = nil
  self.animIndex = nil
  self.timer = nil
  self.timerArrow = nil
  self.closeTimer = nil
  self.showIndex = nil
  self.targetBtnPos = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.ctrl:InitData(self:GetUserData())
  self:ReInit()
end

local function OnDisable(self)
  self.ctrl:ClearData()
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshUIWorldActRadarTreasurePointView, self.RefreshUIWorldActRadarTreasurePointViewSignal)
  self:AddUIListener(EventId.ChangeCameraLod, self.UpdateLod)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.RefreshUIWorldActRadarTreasurePointView, self.RefreshUIWorldActRadarTreasurePointViewSignal)
  self:RemoveUIListener(EventId.ChangeCameraLod, self.UpdateLod)
  base.OnRemoveListener(self)
end

local function ReInit(self)
  self.serverData = nil
  self.info = self.ctrl:GetPointData()
  if self.info ~= nil then
    local tileX = BuildTilesSize.One
    local tileY = BuildTilesSize.One
    self.worldPos = BuildingUtils.GetBuildModelCenterVec(self.ctrl.pointId, tileX, tileY, ForceChangeScene.World, self.ctrl.serverId)
    local x, y = self.transform:Get_lossyScale()
    local lossyScale = y
    if lossyScale <= 0 then
      lossyScale = 1
    end
    self.bg_arrow:SetActive(self.ctrl.type ~= WorldPointUIType.DragonBuild and self.ctrl.type ~= WorldPointUIType.WinterEntity and self.ctrl.type ~= WorldPointUIType.EpidemicBuild)
    self.bg:SetLocalPositionXYZ(0, 0, 0)
    local isMarch = self.info.pointData and self.info.pointData.marchType ~= nil
    if self.ctrl.type ~= WorldPointUIType.SingleMapGarbage and self.ctrl.type ~= WorldPointUIType.Train and self.ctrl.type ~= WorldPointUIType.HSR and isMarch and self.info.pointData.marchType ~= NewMarchType.RUNNING_BOSS then
      UIUtil.ClickBuildAdjustCameraView(self.worldPos, BuildAdjust, lossyScale)
    end
    self.AutoAdjustScreenPos:Init(self.worldPos)
    self.AutoAdjustScreenPos.enabled = true
    local pos = DeepCopy(self.worldPos)
    local zoom = CS.SceneManager.World.Zoom
    pos.z = pos.z + 15 * zoom / 180
    local CameraHeight = -1
    CS.SceneManager.World:AutoLookat(pos, CameraHeight, LookAtFocusTime, function()
    end)
    if isMarch and self.info.pointData.marchType == NewMarchType.RUNNING_BOSS then
      self.posGoComponent:SetAnchoredPositionXY(0, 0)
      self.AutoAdjustScreenPos.enabled = false
    end
    if self.ctrl.type == WorldPointUIType.Treasure then
      self.name_text:SetText(self.info.pointData.name)
    end
    self:ShowTopBtn()
    self:RefreshMarkBtnImg()
    self:ShowBtn()
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bg.rectTransform)
  end
end

local function RefreshMarkBtnImg(self)
  local point = self:GetRealPoint()
  local serverId = self.ctrl.serverId or LuaEntry.Player:GetCurServerId()
  local favorData = DataCenter.WorldFavoDataManager:GetBookmark(point, serverId, true)
  if favorData then
    self.btnMarkImg:LoadSpriteAsync("Assets/Main/Sprites/UI/UILWBuild/dl_daditu_yishoucang.png")
  else
    self.btnMarkImg:LoadSpriteAsync("Assets/Main/Sprites/UI/UILWBuild/dl_daditu_shoucang.png")
  end
end

local function ShowTopBtn(self)
  if self.ctrl.type == WorldPointUIType.Treasure then
    self.btn_alliance_mark:SetActive(false)
    self.treasureDetectObj:SetActive(true)
    self.treasureDetectObj:RefreshData(self.info.pointData)
    local detectEventTemplate = DataCenter.DetectEventTemplateManager:GetDetectEventTemplate(self.info.pointData.pointData.eventId)
    if detectEventTemplate and not string.IsNullOrEmpty(detectEventTemplate.banner_image_2) then
      local bgPara = string.split(detectEventTemplate.banner_image_2, "|")
      if detectEventTemplate.type == DetectEventType.OFF_SEASON_TREASURE then
        self.top_bg:LoadSpriteAsync(string.format(UIAssets.UIActMonopolyTexturePath, bgPara[1]))
        self.top_bg:SetAnchoredPositionXY(0, 132)
        self.top_bg:SetSizeDeltaY(348)
        self.top_bg_img:SetActive(false)
      else
        if #bgPara == 2 then
          self.top_bg:LoadSpriteAsync(string.format(UIAssets.UIActMonopolyTexturePath, bgPara[2]))
          self.top_bg_img:LoadSpriteAsyncWithCallback(string.format(UIAssets.UIActMonopolyTexturePath, bgPara[1]), function()
            if self.top_bg_img ~= nil then
              self.top_bg_img:SetNativeSize()
            end
          end)
        end
        self.top_bg:SetAnchoredPositionXY(0, 0)
        self.top_bg:SetSizeDeltaY(214)
        self.top_bg_img:SetActive(true)
      end
    end
  end
end

local function SetAllCellDestroy(self)
  self.build_btn_go:RemoveComponents(UIWorldPointBtn)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

local function ShowBtn(self)
  self.buildBtnCells = {}
  self:SetAllCellDestroy()
  local k1 = LuaEntry.DataConfig:TryGetNum("monster_level_show", "k1")
  local currentMainLv = DataCenter.BuildManager.MainLv
  self.btnList = self.info.btnList
  self.btnCount = #self.btnList
  if self.btnCount > 0 then
    self.build_btn_obj:SetActive(true)
    if self.info.skipBtnSort ~= true then
      table.sort(self.btnList, function(a, b)
        return b < a
      end)
    end
    for k, v in ipairs(self.btnList) do
      local param = {}
      param.btnType = v
      param.pointId = self.ctrl.pointId
      param.info = self.info.pointData
      local index = CommonUtil.IsArabicAutoMirrorOpen() and self.btnCount - k + 1 or k
      param.position = BtnPosition[self.btnCount][index] - BtnCellCircle
      self.model[k] = self:GameObjectInstantiateAsync(UIAssets.UIWorldTileBuildBtn, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.build_btn_go.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_localPosition(BtnCellCircle.x, BtnCellCircle.y, BtnCellCircle.z)
        local nameStr = self.view.ctrl:GetPointBtnEnumName(v)
        go.name = nameStr
        self.buildBtnCells[v] = self.build_btn_go:AddComponent(UIWorldPointBtn, nameStr)
        self.buildBtnCells[v]:ReInit(param)
        self:CheckPlay()
      end)
    end
    self:CheckPlay()
  else
    self.build_btn_obj:SetActive(false)
  end
end

local function RefreshUIWorldActRadarTreasurePointViewSignal(self, data)
  if data ~= nil then
    local strArr = string.split(data, ";")
    if 5 < #strArr then
      if self.ctrl.type ~= WorldPointUIType.SingleMapGarbage then
        local ret, time = self.this_anim:PlayAnimationReturnTime(AnimName.Exit)
        if ret then
          self.closeTimer = TimerManager:GetInstance():GetTimer(time, function()
            if self.closeTimer ~= nil then
              self.closeTimer:Stop()
              self.closeTimer = nil
            end
            if self.ctrl ~= nil then
              self.ctrl:InitData(strArr[1], strArr[2], strArr[3], strArr[4], strArr[5], strArr[6])
              self.this_anim:Play(AnimName.Enter, 0, 0)
              self:ReInit()
            end
          end, self, true, false, false)
          self.closeTimer:Start()
        end
      else
        if 7 < #strArr then
          self.ctrl:InitData(strArr[1], strArr[2], strArr[3], strArr[4], strArr[5], strArr[6], strArr[7], strArr[8])
        else
          self.ctrl:InitData(strArr[1], strArr[2], strArr[3], strArr[4], strArr[5], strArr[6])
        end
        self:ReInit()
      end
    end
  end
end

local function CheckPlay(self)
  if self.btnCount <= table.count(self.buildBtnCells) then
    self.animIndex = 1
    self:AddTimer()
  end
end

local function OnUpdate(self)
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
  self:AddArrowTimer()
end

local function AddTimer(self)
  if self.timer == nil then
    local time = self.build_btn_anim:GetFloat("DuringTime")
    self.timer = TimerManager:GetInstance():GetTimer(time / 10, self.timer_action, self, false, false, false)
  end
  self.timer:Start()
end

local function RefreshTime(self)
  if self.animIndex > 0 then
    if self.btnCount >= self.animIndex then
      local temp = self.buildBtnCells[self.btnList[self.animIndex]]
      if temp ~= nil then
        if CommonUtil.IsArabicAutoMirrorOpen() then
          Logger.Log(BtnAnimArabic[self.btnCount][self.animIndex])
          temp:PlayAnim(BtnAnimArabic[self.btnCount][self.animIndex])
        else
          Logger.Log(BtnAnim[self.btnCount][self.animIndex])
          temp:PlayAnim(BtnAnim[self.btnCount][self.animIndex])
        end
      end
      self.animIndex = self.animIndex + 1
    else
      self.animIndex = 0
      self:DeleteTimer()
    end
  end
end

local function DeleteArrowTimer(self)
  if self.timerArrow ~= nil then
    self.timerArrow:Stop()
    self.timerArrow = nil
  end
  self.ctrl:SetIsArrow()
end

local function AddArrowTimer(self)
  if self.timerArrow == nil then
    self.timerArrow = TimerManager:GetInstance():GetTimer(0.3, self.timer_actionArrow, self, false, false, false)
  end
  self.timerArrow:Start()
end

local function RefreshArrowTime(self)
  local arrow = self.ctrl:GetIsArrow()
  if arrow then
    for i, v in pairs(self.buildBtnCells) do
      if type(arrow) == "boolean" then
        self:ShowArrow(v)
        break
      elseif i == arrow then
        self:ShowArrow(v)
      end
    end
  end
end

local function ShowArrow(self, v)
  self:DeleteArrowTimer()
  local param = {}
  param.position = v:GetPosition()
  param.arrowType = ArrowType.Capacity
  param.positionType = PositionType.Screen
  param.isPanel = false
  if param.position ~= nil then
    DataCenter.ArrowManager:ShowArrow(param)
  end
end

local function OnMarkClick(self, isAlliance)
  local panelType = MarkGroup.Personal
  if isAlliance then
    panelType = MarkGroup.Alliance
  end
  if self.info ~= nil then
    local name = self.info.pointData.shareName
    if name ~= nil then
      local realPoint = self:GetRealPoint()
      local serverId = self.ctrl.serverId or LuaEntry.Player:GetCurServerId()
      self.ctrl:OnMarkClick(serverId, realPoint, name, self.info.pointData.level, panelType)
    end
  end
end

local function GetRealPoint(self)
  local tileX = BuildTilesSize.One
  local buildTemplate
  buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.ctrl.buildId)
  if buildTemplate ~= nil then
    tileX = buildTemplate.tileX or BuildTilesSize.One
  end
  local realPoint = self.ctrl.pointId * 10 + tileX
  return realPoint
end

local function OnShareClick(self)
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  if self.ctrl.type == WorldPointUIType.Treasure then
    local name = self.info.pointData.shareName
    if name ~= nil then
      self.ctrl:ShareTreasure(self.info)
    end
  end
end

local function OnDetailClick(self)
  if self.info ~= nil and self.ctrl.type == WorldPointUIType.Treasure then
    UIUtil.ShowTipsId("activity_wajueji_27000_tips16")
  end
end

local function OnReturnClick(self)
end

local function UpdateLod(self, lod)
  if 2 <= lod then
    self.ctrl:CloseSelf(false)
  end
end

UIWorldActRadarTreasurePointView.OnCreate = OnCreate
UIWorldActRadarTreasurePointView.OnDestroy = OnDestroy
UIWorldActRadarTreasurePointView.OnEnable = OnEnable
UIWorldActRadarTreasurePointView.OnDisable = OnDisable
UIWorldActRadarTreasurePointView.ComponentDefine = ComponentDefine
UIWorldActRadarTreasurePointView.ComponentDestroy = ComponentDestroy
UIWorldActRadarTreasurePointView.DataDefine = DataDefine
UIWorldActRadarTreasurePointView.DataDestroy = DataDestroy
UIWorldActRadarTreasurePointView.OnAddListener = OnAddListener
UIWorldActRadarTreasurePointView.OnRemoveListener = OnRemoveListener
UIWorldActRadarTreasurePointView.ReInit = ReInit
UIWorldActRadarTreasurePointView.ShowTopBtn = ShowTopBtn
UIWorldActRadarTreasurePointView.ShowBtn = ShowBtn
UIWorldActRadarTreasurePointView.RefreshUIWorldActRadarTreasurePointViewSignal = RefreshUIWorldActRadarTreasurePointViewSignal
UIWorldActRadarTreasurePointView.CheckPlay = CheckPlay
UIWorldActRadarTreasurePointView.DeleteTimer = DeleteTimer
UIWorldActRadarTreasurePointView.AddTimer = AddTimer
UIWorldActRadarTreasurePointView.RefreshTime = RefreshTime
UIWorldActRadarTreasurePointView.SetAllCellDestroy = SetAllCellDestroy
UIWorldActRadarTreasurePointView.OnReturnClick = OnReturnClick
UIWorldActRadarTreasurePointView.OnDetailClick = OnDetailClick
UIWorldActRadarTreasurePointView.OnMarkClick = OnMarkClick
UIWorldActRadarTreasurePointView.OnShareClick = OnShareClick
UIWorldActRadarTreasurePointView.UpdateLod = UpdateLod
UIWorldActRadarTreasurePointView.DeleteArrowTimer = DeleteArrowTimer
UIWorldActRadarTreasurePointView.AddArrowTimer = AddArrowTimer
UIWorldActRadarTreasurePointView.RefreshArrowTime = RefreshArrowTime
UIWorldActRadarTreasurePointView.ShowArrow = ShowArrow
UIWorldActRadarTreasurePointView.RefreshMarkBtnImg = RefreshMarkBtnImg
UIWorldActRadarTreasurePointView.GetRealPoint = GetRealPoint
UIWorldActRadarTreasurePointView.OnUpdate = OnUpdate
return UIWorldActRadarTreasurePointView
