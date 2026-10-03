local UIWorldLLCityPointView = BaseClass("UIWorldLLCityPointView", UIBaseView)
local base = UIBaseView
local UIWorldLLCityPointBtn = require("UI.LWWorld.UIWorldLLCityPoint.Component.UIWorldLLCityPointBtn")
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
local BUFF_POINT_PATH = "Assets/Main/Prefabs/UI/Landlord/World/LLWorldCityBuffPoint.prefab"
local UIWorldLLCityBuffPoint = "UI.LWWorld.UIWorldLLCityPoint.Component.UIWorldLLCityBuffPoint"
local BUILDING_POINT_PATH = "Assets/Main/Prefabs/UI/Landlord/World/LLWorldCityBuildingPoint.prefab"
local UIWorldLLCityPointInfo = "UI.LWWorld.UIWorldLLCityPoint.Component.UIWorldLLCityPointInfo"
local pos_go_path = "PosGo"
local build_btn_go_path = "PosGo/BuildBtnScale/BuildBtnGo"
local build_btn_obj_path = "PosGo/BuildBtnScale"
local this_path = ""
local layout_path = "PosGo/message/mask/bg/layout"
local bg_path = "PosGo/message/mask/bg"
local message_path = "PosGo/message"
local btn_return_path = "PosGo/message/mask/bg/Top/Title/btn_return"
local btn_detail_path = "PosGo/message/mask/bg/Top/Title/btn_detail"
local owner_name_text_path = "PosGo/message/mask/bg/Top/Title/NameText"
local lv_txt_path = "PosGo/message/mask/bg/Top/Title/LvTxt"
local ruin_points_txt_path = "PosGo/message/mask/bg/Top/Title/RuinPointsTxt"
local btn_zone_mark_path = "PosGo/message/mask/bg/Top/btns/Btn_zone_mark"
local btn_alliance_share_path = "PosGo/message/mask/bg/Top/btns/Btn_alliance_share"
local btn_share_path = "PosGo/message/mask/bg/Top/btns/Btn_share"
local btn_mark_path = "PosGo/message/mask/bg/Top/btns/Btn_mark"
local detail_title_path = "PosGo/message/mask/bg/layout/BuildDetails/ScrollView/Viewport/Content/detailTitle"
local detail_desc_path = "PosGo/message/mask/bg/layout/BuildDetails/ScrollView/Viewport/Content/detailDesc"
local build_info_path = "PosGo/message/mask/bg/layout/BuildInfo"
local detail_path = "PosGo/message/mask/bg/layout/BuildDetails"

function UIWorldLLCityPointView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  UIUtil.CheckEventTrigger(OpMode.ClickBtnOutpostCity, 0, 1)
  self.gmHappyKey = GMUtils.AddHappy(BindRet(self, self.DebugHappyInfo))
end

function UIWorldLLCityPointView:OnDestroy()
  if self.dCompBuffPoint then
    self.dCompBuffPoint:Delete()
    self.dCompBuffPoint = nil
  end
  if self.dCompBuildingPoint then
    self.dCompBuildingPoint:Delete()
    self.dCompBuildingPoint = nil
  end
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
  GMUtils.DelHappy(self.gmHappyKey)
  self.gmHappyKey = nil
end

function UIWorldLLCityPointView:ComponentDefine()
  self.bg = self:AddComponent(UIBaseComponent, bg_path)
  self.message = self:AddComponent(UIBaseComponent, message_path)
  self.pos_go = self:AddComponent(UIBaseContainer, pos_go_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, owner_name_text_path)
  self.lv_txt = self:AddComponent(UITextMeshProUGUIEx, lv_txt_path)
  self.ruin_points_txt = self:AddComponent(UITextMeshProUGUIEx, ruin_points_txt_path)
  self.layoutAnim = self:AddComponent(UIAnimator, layout_path)
  self.layoutAnim:Play("ShowBuild")
  self.build_detail = self:AddComponent(UILayoutElement, detail_path)
  self.build_info = self:AddComponent(UIBaseContainer, build_info_path)
  self.detail_title = self:AddComponent(UITextMeshProUGUIEx, detail_title_path)
  self.detail_desc = self:AddComponent(UITextMeshProUGUIEx, detail_desc_path)
  self.build_btn_go = self:AddComponent(UIBaseContainer, build_btn_go_path)
  self.build_btn_obj = self:AddComponent(UIBaseContainer, build_btn_obj_path)
  self.this_anim = self:AddComponent(UIAnimator, this_path)
  self.build_btn_anim = self:AddComponent(UIAnimator, build_btn_go_path)
  self.btn_mark = self:AddComponent(UIButton, btn_mark_path)
  self.btn_mark:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnMarkClick(MarkGroup.Personal)
  end)
  self.btn_share = self:AddComponent(UIButton, btn_share_path)
  self.btn_share:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnShareClick()
  end)
  self.btn_zone_mark = self:AddComponent(UIButton, btn_zone_mark_path)
  self.btn_zone_mark:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnMarkClick(MarkGroup.WarZone)
  end)
  self.btn_alliance_share = self:AddComponent(UIButton, btn_alliance_share_path)
  self.btn_alliance_share:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnMarkClick(MarkGroup.Alliance)
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
  self.btn_detail:SetActive(true)
  self.btn_return:SetActive(false)
  self.AutoAdjustScreenPos = self.transform:Find(pos_go_path):GetComponent(typeof(CS.AutoAdjustScreenPos))
end

function UIWorldLLCityPointView:ComponentDestroy()
  self.build_detail = nil
  self.detail_title = nil
  self.detail_desc = nil
  self.pos_go = nil
  self.build_btn_go = nil
  self.this_anim = nil
  self.build_btn_anim = nil
  self.btn_mark = nil
  self.btn_share = nil
  self.btn_detail = nil
  self.btn_return = nil
  self.AutoAdjustScreenPos = nil
end

function UIWorldLLCityPointView:DataDefine()
  self.worldPos = nil
  self.buildBtnCells = {}
end

function UIWorldLLCityPointView:DataDestroy()
  self.worldPos = nil
  self.buildBtnCells = nil
end

function UIWorldLLCityPointView:OnEnable()
  base.OnEnable(self)
  self.ctrl:InitData(self:GetUserData())
  self:ReInit()
end

function UIWorldLLCityPointView:OnDisable()
  base.OnDisable(self)
end

function UIWorldLLCityPointView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorldAllianceCityDetail, self.SetData)
  self:AddUIListener(EventId.ChangeCameraLod, self.UpdateLod)
  self:AddUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
  self:AddUIListener(EventId.LandlordCityPointChangeClientState, self.OnLandlordCityPointChangeClientState)
  self:AddUIListener(EventId.LandlordOldCityPointStartBooming, self.OnLandlordOldCityPointStartBooming)
end

function UIWorldLLCityPointView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.WorldAllianceCityDetail, self.SetData)
  self:RemoveUIListener(EventId.ChangeCameraLod, self.UpdateLod)
  self:RemoveUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
  self:RemoveUIListener(EventId.LandlordCityPointChangeClientState, self.OnLandlordCityPointChangeClientState)
  self:RemoveUIListener(EventId.LandlordOldCityPointStartBooming, self.OnLandlordOldCityPointStartBooming)
end

function UIWorldLLCityPointView:ReInit()
  self.pos_go:SetActive(true)
  self.info = self.ctrl:GetAllianceCityData()
  if self.info ~= nil then
    if self.info.isOldCity then
      local actStartTime = DataCenter.LandlordMgr:GetActStartTime() or 0
      local key = SettingKeys.LANDLORD_CITY_DETAIL_FIRST_SWITCH .. actStartTime
      if not CommonUtil.PlayerPrefsGetBool(key) then
        self.this_anim:Play("V_ui_LLWorldCityPointView_change")
        CommonUtil.PlayerPrefsSetBool(key, true)
      end
    end
    if self.info.worldCityType == WorldAllianceCityType.LLBuffCity then
      self:LoadBuffBuildingPoint()
    elseif self.info.worldCityType == WorldAllianceCityType.LLNormalCity or self.info.worldCityType == WorldAllianceCityType.City or self.info.worldCityType == WorldAllianceCityType.King or self.info.worldCityType == WorldAllianceCityType.Stronghold or self.info.worldCityType == WorldAllianceCityType.CrossZoneOutpost or self.info.worldCityType == WorldAllianceCityType.LLThroneCity then
      self:LoadBuildingPoint()
    end
    local meta = self.info.meta
    local lowPos = 0.25
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    local serverId = self.info.serverId
    local mainCamera = CS.SceneManager.World.Camera
    local worldPos1 = mainCamera:GetRaycastGroundPoint(Vector3.New(Screen.width * 0.5, Screen.height * 0.5, 0))
    local worldPos2 = mainCamera:GetRaycastGroundPoint(Vector3.New(Screen.width * 0.5, Screen.height * lowPos, 0))
    local worldPos = SceneUtils.TileIndexToWorld(self.ctrl.pointId)
    local offset = worldPos1.z - worldPos2.z
    worldPos.z = worldPos.z + offset
    worldPos.z = Mathf.Clamp(worldPos.z, 0, 1999)
    GoToUtil.GotoPos(worldPos, CS.SceneManager.World.Zoom, LookAtFocusTime, function()
    end, serverId)
    self.worldPos = worldPos
    self.AutoAdjustScreenPos:Init(worldPos + Vector3.New(0, 0, TileSize - offset))
    local flag = DataCenter.LandlordMgr:CanShowWarZoneMark()
    local myServer = LuaEntry.Player:GetSourceServerId()
    self.btn_zone_mark:SetActive(flag and (LuaEntry.Player:IsPresident(myServer) or LuaEntry.Player:IsFirstLady(myServer)))
    self.btn_alliance_share:SetActive(self.info.isInAlliance)
    self.ruin_points_txt:SetActive(not DataCenter.LandlordMgr:IsOldCityWithBoom(self.info.cityId))
    if self.info.landlordCityTemplate ~= nil then
      if self.info.worldCityType == WorldAllianceCityType.LLNormalCity or self.info.worldCityType == WorldAllianceCityType.LLBuffCity then
        self.name_text:SetText(self.info.landlordCityTemplate.name)
      else
        self.name_text:SetLocalText(self.info.landlordCityTemplate.name)
      end
      self.lv_txt:SetText(string.format("Lv.%d", self.info.landlordCityTemplate.level))
      self.ruin_points_txt:SetText(self.info.landlordCityTemplate.ruins_points or 0)
    end
    self:RefreshMarkBtnImg()
    self:RefreshMarkZoneBtnImg()
    self:ShowBtn()
    self:SetData()
  end
end

function UIWorldLLCityPointView:LoadBuffBuildingPoint()
  if not self.dCompBuffPoint then
    self.dCompBuffPoint = UIAsyncLoaderBridge.New(self, "dCompBuffPoint", self.transform:Find(build_info_path), BUFF_POINT_PATH, UIWorldLLCityBuffPoint, false, BindCallback(self, self.OnLoadBuffPoint))
    self.dCompBuffPoint:SetActive(true)
  end
end

function UIWorldLLCityPointView:OnLoadBuffPoint()
  if self.dCompBuffPoint then
    self.dCompBuffPoint:RefreshData(self.info)
  end
end

function UIWorldLLCityPointView:LoadBuildingPoint()
  if not self.dCompBuildingPoint then
    self.dCompBuildingPoint = UIAsyncLoaderBridge.New(self, "dCompBuildingPoint", self.transform:Find(build_info_path), BUILDING_POINT_PATH, UIWorldLLCityPointInfo, false, BindCallback(self, self.OnLoadBuildingPoint))
    self.dCompBuildingPoint:SetActive(true)
  end
end

function UIWorldLLCityPointView:OnLoadBuildingPoint()
  if self.dCompBuildingPoint then
    self.dCompBuildingPoint:Refresh(self.info)
  end
end

function UIWorldLLCityPointView:RefreshMarkList()
  self:RefreshMarkBtnImg()
end

function UIWorldLLCityPointView:RefreshMarkBtnImg()
  local realPoint = self.ctrl.pointId * 10 + 1
  local favorData = DataCenter.WorldFavoDataManager:GetBookmark(realPoint, self.ctrl.serverId, true)
  if favorData then
    self.btn_mark:LoadSpriteAuto("Assets/Main/Sprites/UI/UILWBuild/dl_daditu_yishoucang.png")
  else
    self.btn_mark:LoadSpriteAuto("Assets/Main/Sprites/UI/UILWBuild/dl_daditu_shoucang.png")
  end
end

function UIWorldLLCityPointView:RefreshMarkZoneBtnImg()
  if not self.btn_zone_mark:GetActive() then
    return
  end
  local bLord = LLConst.LandLordGroup.LORD == DataCenter.LandlordMgr:GetMyGroup()
  self.btn_zone_mark:LoadSpriteAuto(string.format(LoadPath.LandlordPath, bLord and "zyf_jinmai_fangshou_icon.png" or "zyf_jinmai_jingong_icon.png"))
end

function UIWorldLLCityPointView:SetData()
  local serverData = self.ctrl:GetAllianceCityDetail()
  self.serverData = serverData
  if self.dCompBuffPoint then
    self.dCompBuffPoint:RefreshAssistance(serverData)
  end
  if self.dCompBuildingPoint then
    self.dCompBuildingPoint:RefreshAssistance(serverData)
  end
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bg.transform)
end

function UIWorldLLCityPointView:SetAllCellDestroy()
  self.build_btn_go:RemoveComponents(UIWorldLLCityPointBtn)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function UIWorldLLCityPointView:ShowBtn()
  if self.buttonAroundPlane ~= nil then
    self.buttonAroundPlane:SetActive(false)
  end
  self.buildBtnCells = {}
  self:SetAllCellDestroy()
  self.btnList = self.info.btnList
  self.btnCount = self.btnList and #self.btnList or 0
  self.build_btn_obj:SetActive(self.btnCount > 0)
  if self.btnCount > 0 then
    local theBtnCount = self.btnCount
    for k, v in ipairs(self.btnList) do
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
        self.buildBtnCells[v] = self.build_btn_go:AddComponent(UIWorldLLCityPointBtn, nameStr)
        self.buildBtnCells[v]:ReInit(param)
      end)
    end
  end
end

function UIWorldLLCityPointView:OnMarkClick(markGroup)
  if self.info ~= nil then
    local name = self.info.landlordCityTemplate and self.info.landlordCityTemplate.name or ""
    local realPoint = self.ctrl.pointId * 10 + 1
    self.ctrl:OnMarkClick(LuaEntry.Player:GetCurServerId(), realPoint, name, nil, markGroup)
  end
end

function UIWorldLLCityPointView:OnShareClick(isAlliance)
  if self.info ~= nil then
    local name = self.info.landlordCityTemplate and self.info.landlordCityTemplate.name or ""
    self.ctrl:OnShareClick(self.ctrl.serverId, self.ctrl.pointId, name, "", nil, self.info.alAbbr)
  end
end

function UIWorldLLCityPointView:OnDetailClick()
  if self.info ~= nil then
    self.btn_detail:SetActive(false)
    self.btn_return:SetActive(true)
    self.layoutAnim:Play("ShowDetail")
    local _, y = self.build_info.transform:Get_sizeDelta()
    self.build_detail:SetMinHeight(y)
    if self.info.landlordCityTemplate then
      self.detail_title:SetActive(false)
      self.detail_desc:SetActive(true)
      self.detail_desc:SetLocalText(self.info.landlordCityTemplate.desc)
    end
  end
end

function UIWorldLLCityPointView:OnReturnClick()
  if self.info ~= nil then
    self.btn_detail:SetActive(true)
    self.btn_return:SetActive(false)
    self.layoutAnim:Play("ShowBuild")
  end
end

function UIWorldLLCityPointView:OnCityTitleDetailClick()
  if self.info.landlordCityTemplate then
    local param = {}
    param.type = "desc"
    param.desc = self.info.landlordCityTemplate.desc
    param.alignObject = self.city_title_detail_btn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips, {anim = true}, param)
  end
end

function UIWorldLLCityPointView:UpdateLod(lod)
  if 2 < lod then
    self.ctrl:CloseSelf()
  end
end

function UIWorldLLCityPointView:OnLandlordCityPointChangeClientState(pointIndex)
  if self.info and self.info.pointId == pointIndex then
    local info = CS.SceneManager.World:GetPointInfo(self.info.pointId)
    if info and info.curClientState == LLConst.LLBuildingState.Exploding then
      self.ctrl:CloseSelf()
    end
  end
end

function UIWorldLLCityPointView:OnLandlordOldCityPointStartBooming()
  self.ctrl:CloseSelf()
end

function UIWorldLLCityPointView:DebugHappyInfo()
  local sb = StringBuilder.New()
  if self.ctrl then
    local info = CS.SceneManager.World:GetPointInfo(self.ctrl.pointId)
    if info and info.Description then
      sb:AppendFormat(info:Description())
    else
      return nil
    end
  end
  return sb:ToString()
end

return UIWorldLLCityPointView
