local UIWorldSiegePointView = BaseClass("UIWorldSiegePointView", UIBaseView)
local base = UIBaseView
local ResourceManager = CS.GameEntry.Resource
local UIWorldSiegePointBtn = require("UI.LWWorld.UIWorldSiegePoint.Component.UIWorldSiegePointBtn")
local UIWorldSiegePointInfo = require("UI.LWWorld.UIWorldSiegePoint.Component.UIWorldSiegePointInfo")
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
local pos_go_path = "PosGo"
local bg_path = "PosGo/message/bg"
local message_path = "PosGo/message"
local owner_name_text_path = "PosGo/message/bg/Top/NameText"
local build_btn_go_path = "PosGo/BuildBtnScale/BuildBtnGo"
local build_btn_obj_path = "PosGo/BuildBtnScale"
local this_path = ""
local btn_mark_path = "PosGo/message/bg/Top/Btn_mark"
local btn_share_path = "PosGo/message/bg/Top/Btn_share"
local btn_alliance_share_path = "PosGo/message/bg/Top/Btn_alliance_share"
local btn_detail_path = "PosGo/message/bg/Top/btn_detail"
local btn_return_path = "PosGo/message/bg/Top/btn_return"
local point_obj_path = "PosGo/message/bg/layout"
local btn_king_path = "PosGo/message/bg/Top/Btn_King"
local deco_path = "PosGo/message/bg/Top/Deco"
local new_top_path = "PosGo/message/bg/Top/NewTop"
local lord_icon_path = "PosGo/message/bg/Top/NewTop/lordIcon"
local hero_spine_container_path = "PosGo/message/bg/Top/NewTop/lordIconMask/HeroSpineContainer"
local refresh_btn_path = "PosGo/BuildBtnScale/BuildBtnGo/RefreshBtn"
local six_build_btn_path = "PosGo/BuildBtnScale/BuildBtnGo/SixBuildBtn"
local btn_alliance_cityrally_path = "PosGo/message/bg/Top/Btn_alliance_cityrally"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.bg = self:AddComponent(UIBaseComponent, bg_path)
  self.message = self:AddComponent(UIBaseComponent, message_path)
  self.pos_go = self:AddComponent(UIBaseContainer, pos_go_path)
  self.owner_name_text = self:AddComponent(UIText, "PosGo/message/bg/Top/black/NameText")
  self.black_bg = self:AddComponent(UIBaseComponent, "PosGo/message/bg/Top/black")
  self.build_btn_go = self:AddComponent(UIBaseContainer, build_btn_go_path)
  self.build_btn_obj = self:AddComponent(UIBaseContainer, build_btn_obj_path)
  self.this_anim = self:AddComponent(UIAnimator, this_path)
  self.build_btn_anim = self:AddComponent(UIAnimator, build_btn_go_path)
  self.point_obj = self:AddComponent(UIWorldSiegePointInfo, point_obj_path)
  self.btn_king = self:AddComponent(UIButton, btn_king_path)
  self.btn_king:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnKingClick()
  end)
  self.btn_mark = self:AddComponent(UIButton, btn_mark_path)
  self.btn_mark:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnMarkClick()
  end)
  self.declare_mark = self:AddComponent(UIBaseComponent, "PosGo/message/bg/Top/declare_mark")
  self.declareState = self:AddComponent(UITextMeshProUGUIEx, "PosGo/message/bg/Top/declare_mark/declareState")
  self.btnMarkImg = self:AddComponent(UIImage, btn_mark_path)
  self.btn_share = self:AddComponent(UIButton, btn_share_path)
  self.btn_share:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShareClick()
  end)
  self.btn_alliance_share = self:AddComponent(UIButton, btn_alliance_share_path)
  self.btn_alliance_share:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnMarkClick(true)
  end)
  self.btn_alliance_cityrally = self:AddComponent(UIButton, btn_alliance_cityrally_path)
  self.btn_alliance_cityrally:SetActive(false)
  self.btn_alliance_cityrally:SetOnClick(function()
    DataCenter.AllianceBaseDataManager:TrySetRally(self.info.pointId)
  end)
  self.btn_detail = self:AddComponent(UIButton, btn_detail_path)
  self.btn_detail:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnDetailClick()
  end)
  self.btn_detail:SetActive(true)
  self.btn_return = self:AddComponent(UIButton, btn_return_path)
  self.btn_return:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnReturnClick()
  end)
  self.btn_return:SetActive(false)
  self.AutoAdjustScreenPos = self.transform:Find(pos_go_path):GetComponent(typeof(CS.AutoAdjustScreenPos))
  self.model = {}
  self.refreshSlider = false
  self.deco = self:AddComponent(UIBaseContainer, deco_path)
  self.new_top = self:AddComponent(UIBaseContainer, new_top_path)
  self.lord_icon = self:AddComponent(UIImage, lord_icon_path)
  self.hero_spine_container = self:AddComponent(UIBaseContainer, hero_spine_container_path)
  self.refresh_btn = self:AddComponent(UIButton, refresh_btn_path)
  self.refresh_btn:LoadSpriteAuto("Assets/Main/Sprites/UI/UIBuildBtns/mjc_zhujiemian_qiehuan.png")
  self.refresh_btn:SetActive(false)
  self.refresh_btn:SetOnClick(function()
    self.pos_go:SetActive(false)
    if self.buttonAroundPlane == nil then
      local luaPath = "UI.UIWorldPoint.Component.WorldButtonAroundPlane"
      local prefabPath = "Assets/Main/Prefabs/UI/World/UIWorldPointComponent/ButtonAroundPlane.prefab"
      self.buttonAroundPlane = self:LoadComponentAsync(luaPath, prefabPath, self)
      self.buttonAroundPlane:SetData(self.info, self.ctrl.pointId, UIWorldSiegePointBtn)
    else
      self.buttonAroundPlane:ShowMe(self.info, self.ctrl.pointId, UIWorldSiegePointBtn)
    end
  end)
  self.six_build_btn = self:AddComponent(UIWorldSiegePointBtn, six_build_btn_path)
  self.six_build_btn:SetActive(false)
end

local function ComponentDestroy(self)
  if self.delayAutoFitUI then
    self.delayAutoFitUI:Stop()
    self.delayAutoFitUI = nil
  end
  self.refresh_btn = nil
  self.pos_go = nil
  self.name_text = nil
  self.build_btn_go = nil
  self.this_anim = nil
  self.build_btn_anim = nil
  self.btn_mark = nil
  self.btn_share = nil
  self.btn_detail = nil
  self.btn_return = nil
  self.AutoAdjustScreenPos = nil
  self.model = nil
  self.refreshSlider = nil
  self.btn_alliance_cityrally = nil
  self.deco = nil
  self.new_top = nil
  self.lord_icon = nil
  self.hero_spine_container = nil
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
end

local function DataDefine(self)
  self.worldPos = nil
  self.buildBtnCells = {}
end

local function DataDestroy(self)
  self.worldPos = nil
  self.buildBtnCells = nil
end

local function OnEnable(self)
  base.OnEnable(self)
  self.ctrl:InitData(self:GetUserData())
  self:ReInit()
end

local function OnDisable(self)
  AllianceBuildBloodManager:GetInstance():OnCloseAllianceCity(self.info.uuid)
  base.OnDisable(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorldAllianceCityDetail, self.SetData)
  self:AddUIListener(EventId.ChangeCameraLod, self.UpdateLod)
  self:AddUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.WorldAllianceCityDetail, self.SetData)
  self:RemoveUIListener(EventId.ChangeCameraLod, self.UpdateLod)
  self:RemoveUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
end

local function ReInit(self)
  if DataCenter.AllianceDeclareWarManager:IsSelfDeclare(self.ctrl.cityId) then
    self.declare_mark:SetActive(true)
    local state, info = DataCenter.AllianceDeclareWarManager:GetDeclareState()
    if state == DeclareWarState.Formal then
      self.declareState:SetLocalText("new_city_activity_tips1014")
    elseif state == DeclareWarState.PreDeclare then
      self.declareState:SetLocalText("new_city_activity_battle_tips1056")
    end
  else
    self.declare_mark:SetActive(false)
  end
  if self.buttonAroundPlane ~= nil then
    self.buttonAroundPlane:SetActive(false)
  end
  self.pos_go:SetActive(true)
  self.info = self.ctrl:GetAllianceCityData(self.ctrl.cityId)
  if self.info ~= nil then
    local mainCamera = CS.SceneManager.World.Camera
    local worldPos1 = mainCamera:GetRaycastGroundPoint(Vector3.New(Screen.width * 0.5, Screen.height * 0.5, 0))
    local worldPos2 = mainCamera:GetRaycastGroundPoint(Vector3.New(Screen.width * 0.5, Screen.height * 0.25, 0))
    local worldPos = SceneUtils.TileIndexToWorld(self.ctrl.pointId)
    local offset = worldPos1.z - worldPos2.z
    if self.info.type == WorldAllianceCityType.Canon or self.info.type == WorldAllianceCityType.MissileFactory or self.info.type == WorldAllianceCityType.King then
      offset = offset - 3 * TileSize
    end
    worldPos.z = worldPos.z + offset
    GoToUtil.GotoPos(worldPos, CS.SceneManager.World.Zoom, LookAtFocusTime, function()
    end, self.info.serverId)
    self.worldPos = worldPos
    self.AutoAdjustScreenPos:Init(worldPos + Vector3.New(0, 0, TileSize - offset))
    self.point_obj:InitData(self.info)
    if self.info.type == 2 then
      if string.IsNullOrEmpty(self.info.userName) then
        self.owner_name_text:SetText(Localization:GetString(self.info.name))
      else
        self.owner_name_text:SetText(self.info.userName)
      end
    elseif string.IsNullOrEmpty(self.info.userName) then
      self.owner_name_text:SetText(Localization:GetString("140205", self.info.level, Localization:GetString(self.info.name)))
    else
      self.owner_name_text:SetText(Localization:GetString("140205", self.info.level, self.info.userName))
    end
    self.btn_king:SetActive(false)
    self:RefreshMarkBtnImg()
    self:ShowBtn()
  end
end

function UIWorldSiegePointView:ReAutoFitUI()
end

local function RefreshMarkList(self)
  self:RefreshMarkBtnImg()
end

local function RefreshMarkBtnImg(self)
  local realPoint = self.ctrl.pointId * 10 + 1
  local favorData = DataCenter.WorldFavoDataManager:GetBookmark(realPoint, LuaEntry.Player:GetCurServerId(), true)
  if favorData then
    self.btnMarkImg:LoadSprite("Assets/Main/Sprites/UI/UILWBuild/dl_daditu_yishoucang.png")
  else
    self.btnMarkImg:LoadSprite("Assets/Main/Sprites/UI/UILWBuild/dl_daditu_shoucang.png")
  end
end

local function SetData(self)
  local serverData = self.ctrl:GetAllianceCityDetail(self.ctrl.cityId)
  local flag = false
  local occupy = false
  if self.heroSpineLoadRequest ~= nil then
    self.heroSpineLoadRequest:Destroy()
    self.heroSpineLoadRequest = nil
  end
  local showDeco = true
  if serverData ~= nil then
    self.point_obj:RefreshData(serverData)
    if self.info.state == AllianceCityState.OCCUPIED or self.info.state == AllianceCityState.SERVER_OCCUPIED then
      occupy = true
    end
    if self.info.state == AllianceCityState.NEUTRAL or self.info.state == AllianceCityState.SERVER_NEUTRAL then
      local appearanceId = self.info.avatar_big
      if not string.IsNullOrEmpty(appearanceId) then
        local newAppearanceId = DataCenter.LWSaveGirlManager:GetJPAppearanceId(appearanceId)
        local spinePath = GetTableData(LuaEntry.Player:GetABTestTableName(TableName.HeroAppearance), newAppearanceId, "show_model_path")
        if spinePath then
          flag = true
          local request = ResourceManager:InstantiateAsync(spinePath)
          self.heroSpineLoadRequest = request
          request:completed("+", function()
            if request.isError or request.gameObject == nil then
              self.heroSpineLoadRequest = nil
              return
            end
            local obj = request.gameObject
            local rectTransform = obj:GetComponent(typeof(CS.UnityEngine.RectTransform))
            if rectTransform ~= nil then
              rectTransform:SetParent(self.hero_spine_container.transform)
              rectTransform:Set_localScale(1, 1, 1)
              rectTransform:Set_anchoredPosition(0, 0, 0)
            end
          end)
        end
      end
    end
    if self.info.type == 2 then
      showDeco = false
    else
      showDeco = not flag and not occupy
    end
  end
  self.new_top:SetActive(flag)
  self.deco:SetActive(showDeco)
end

local function SetAllCellDestroy(self)
  self.build_btn_go:RemoveComponents(UIWorldSiegePointBtn)
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
  if self.buttonAroundPlane ~= nil then
    self.buttonAroundPlane:SetActive(false)
  end
  self.buildBtnCells = {}
  self:SetAllCellDestroy()
  self.btnList = self.info.btnList
  self.btnCount = self.btnList and #self.btnList or 0
  self.btn_alliance_cityrally:SetActive(DataCenter.AllianceBaseDataManager:CanSetAllianceCityRallyBySiegePoint(self.info))
  if self.btnCount > 0 then
    table.sort(self.btnList, function(a, b)
      return b < a
    end)
    self.refresh_btn:SetActive(self.btnCount > 5)
    self.build_btn_obj:SetActive(true)
    local fiveBtnList = UIUtil.GetBtnShown(self.btnList, 5)
    local theBtnCount = #fiveBtnList
    if not self.info.skipBtnSort then
      table.sort(fiveBtnList, function(a, b)
        return b < a
      end)
    end
    for k, v in ipairs(fiveBtnList) do
      local param = {}
      param.btnType = v
      param.info = self.info
      local index = CommonUtil.IsArabicAutoMirrorOpen() and theBtnCount - k + 1 or k
      param.position = BtnPosition[theBtnCount][index] - BtnCellCircle
      self.model[k] = self:GameObjectInstantiateAsync(UIAssets.UIWorldTileBuildBtn, function(request)
        if request.isError then
          return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.build_btn_go.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform.localPosition = BtnCellCircle
        local nameStr = tostring(v)
        go.name = nameStr
        self.buildBtnCells[v] = self.build_btn_go:AddComponent(UIWorldSiegePointBtn, nameStr)
        self.buildBtnCells[v]:ReInit(param)
      end)
    end
  else
    self.refresh_btn:SetActive(false)
    self.build_btn_obj:SetActive(false)
  end
end

local function OnMarkClick(self, isAlliance)
  local panelType = MarkGroup.Personal
  if isAlliance then
    panelType = MarkGroup.Alliance
  end
  if self.info ~= nil then
    local name = ""
    if self.info.userName ~= nil and self.info.userName ~= "" then
      name = self.info.userName
    else
      name = self.info.name
    end
    if not string.IsNullOrEmpty(self.info.alAbbr) then
      name = "[" .. self.info.alAbbr .. "]" .. Localization:GetString(name)
    end
    local realPoint = self.ctrl.pointId * 10 + 1
    self.ctrl:OnMarkClick(LuaEntry.Player:GetCurServerId(), realPoint, name, self.info.level, panelType)
  end
end

local function OnShareClick(self, isAlliance)
  if CoppaUtil.IsCoppaLimitWithTips() then
    return
  end
  if self.info ~= nil then
    local name = ""
    if self.info.userName ~= nil and self.info.userName ~= "" then
      name = self.info.userName
    else
      name = self.info.name
    end
    if not string.IsNullOrEmpty(self.info.alAbbr) then
      name = "[" .. self.info.alAbbr .. "]" .. Localization:GetString(name)
    end
    if name ~= nil then
      self.ctrl:OnShareClick(LuaEntry.Player:GetCurServerId(), self.ctrl.pointId, name, "", self.info.level)
    end
  end
end

local function OnDetailClick(self)
  if self.info ~= nil and self.info.type ~= 1 then
    self.point_obj:OnInfoClick()
    self.btn_detail:SetActive(false)
    self.btn_return:SetActive(true)
  else
    UIManager:GetInstance():OpenWindow(UIWindowNames.UILWWorldTip, {anim = false}, 3)
  end
end

local function OnReturnClick(self)
  if self.info ~= nil then
    self.point_obj:OnReturnClick()
    self.btn_detail:SetActive(true)
    self.btn_return:SetActive(false)
  end
end

local function OnKingClick(self)
  if self.info ~= nil and LuaEntry.Player:IsPresident() then
    UIUtil.DestroyWorldSiegePoint()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGovernmentMain, {anim = true}, self.ctrl.serverId, self.ctrl.cityId)
  end
end

local function UpdateLod(self, lod)
  if 2 < lod then
    self.ctrl:CloseSelf(false)
  end
end

UIWorldSiegePointView.OnCreate = OnCreate
UIWorldSiegePointView.OnDestroy = OnDestroy
UIWorldSiegePointView.OnEnable = OnEnable
UIWorldSiegePointView.OnDisable = OnDisable
UIWorldSiegePointView.ComponentDefine = ComponentDefine
UIWorldSiegePointView.ComponentDestroy = ComponentDestroy
UIWorldSiegePointView.DataDefine = DataDefine
UIWorldSiegePointView.DataDestroy = DataDestroy
UIWorldSiegePointView.OnAddListener = OnAddListener
UIWorldSiegePointView.OnRemoveListener = OnRemoveListener
UIWorldSiegePointView.ReInit = ReInit
UIWorldSiegePointView.ShowBtn = ShowBtn
UIWorldSiegePointView.SetAllCellDestroy = SetAllCellDestroy
UIWorldSiegePointView.SetData = SetData
UIWorldSiegePointView.OnMarkClick = OnMarkClick
UIWorldSiegePointView.OnShareClick = OnShareClick
UIWorldSiegePointView.OnDetailClick = OnDetailClick
UIWorldSiegePointView.OnReturnClick = OnReturnClick
UIWorldSiegePointView.OnKingClick = OnKingClick
UIWorldSiegePointView.UpdateLod = UpdateLod
UIWorldSiegePointView.RefreshMarkBtnImg = RefreshMarkBtnImg
UIWorldSiegePointView.RefreshMarkList = RefreshMarkList
return UIWorldSiegePointView
