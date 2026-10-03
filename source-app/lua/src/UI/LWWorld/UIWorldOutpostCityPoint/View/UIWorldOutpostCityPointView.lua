local UIWorldOutpostCityPointView = BaseClass("UIWorldOutpostCityPointView", UIBaseView)
local base = UIBaseView
local UIWorldOutpostCityPointBtn = require("UI.LWWorld.UIWorldOutpostCityPoint.Component.UIWorldOutpostCityPointBtn")
local UIWorldOutpostCityPointInfo = require("UI.LWWorld.UIWorldOutpostCityPoint.Component.UIWorldOutpostCityPointInfo")
local UIDynamicSkin = require("Framework.UI.Component.UIDynamicSkin")
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
local build_btn_go_path = "PosGo/BuildBtnScale/BuildBtnGo"
local build_btn_obj_path = "PosGo/BuildBtnScale"
local this_path = ""
local point_obj_path = "PosGo/message/bg/layout"
local bg_path = "PosGo/message/bg"
local message_path = "PosGo/message"
local btn_return_path = "PosGo/message/bg/Top/Title/btn_return"
local btn_detail_path = "PosGo/message/bg/Top/Title/btn_detail"
local owner_name_text_path = "PosGo/message/bg/Top/Title/NameText"
local btns_path = "PosGo/message/bg/Top/btns"
local btn_alliance_share_path = "PosGo/message/bg/Top/btns/Btn_alliance_share"
local btn_share_path = "PosGo/message/bg/Top/btns/Btn_share"
local btn_mark_path = "PosGo/message/bg/Top/btns/Btn_mark"
local detail_title_path = "PosGo/message/bg/layout/BuildDetails/ScrollView/Viewport/Content/detailTitle"
local detail_desc_path = "PosGo/message/bg/layout/BuildDetails/ScrollView/Viewport/Content/detailDesc"

function UIWorldOutpostCityPointView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  UIUtil.CheckEventTrigger(OpMode.ClickBtnOutpostCity, 0, 1)
end

function UIWorldOutpostCityPointView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIWorldOutpostCityPointView:ComponentDefine()
  self.bg = self:AddComponent(UIBaseComponent, bg_path)
  self.message = self:AddComponent(UIBaseComponent, message_path)
  self.pos_go = self:AddComponent(UIBaseContainer, pos_go_path)
  self.name_text = self:AddComponent(UITextMeshProUGUIEx, owner_name_text_path)
  self.detail_title = self:AddComponent(UITextMeshProUGUIEx, detail_title_path)
  self.detail_desc = self:AddComponent(UITextMeshProUGUIEx, detail_desc_path)
  self.build_btn_go = self:AddComponent(UIBaseContainer, build_btn_go_path)
  self.build_btn_obj = self:AddComponent(UIBaseContainer, build_btn_obj_path)
  self.this_anim = self:AddComponent(UIAnimator, this_path)
  self.build_btn_anim = self:AddComponent(UIAnimator, build_btn_go_path)
  self.point_obj = self:AddComponent(UIWorldOutpostCityPointInfo, point_obj_path)
  self.btn_mark = self:AddComponent(UIButton, btn_mark_path)
  self.btn_mark:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnMarkClick()
  end)
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
  self.skinMgr = self:AddComponent(UIDynamicSkin, "")
  self.btn_detail:SetActive(true)
  self.btn_return:SetActive(false)
  self.AutoAdjustScreenPos = self.transform:Find(pos_go_path):GetComponent(typeof(CS.AutoAdjustScreenPos))
end

function UIWorldOutpostCityPointView:ComponentDestroy()
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

function UIWorldOutpostCityPointView:DataDefine()
  self.worldPos = nil
  self.buildBtnCells = {}
end

function UIWorldOutpostCityPointView:DataDestroy()
  self.worldPos = nil
  self.buildBtnCells = nil
end

function UIWorldOutpostCityPointView:OnEnable()
  base.OnEnable(self)
  self.ctrl:InitData(self:GetUserData())
  self:ReInit()
end

function UIWorldOutpostCityPointView:OnDisable()
  base.OnDisable(self)
end

function UIWorldOutpostCityPointView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.WorldAllianceCityDetail, self.SetData)
  self:AddUIListener(EventId.OutpostRepairInfoUpdate, self.SetData)
  self:AddUIListener(EventId.OutpostDetailInfoUpdate, self.ReInit)
  self:AddUIListener(EventId.ChangeCameraLod, self.UpdateLod)
  self:AddUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
end

function UIWorldOutpostCityPointView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.WorldAllianceCityDetail, self.SetData)
  self:RemoveUIListener(EventId.OutpostRepairInfoUpdate, self.SetData)
  self:RemoveUIListener(EventId.OutpostDetailInfoUpdate, self.ReInit)
  self:RemoveUIListener(EventId.ChangeCameraLod, self.UpdateLod)
  self:RemoveUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
end

function UIWorldOutpostCityPointView:ReInit()
  self.pos_go:SetActive(true)
  self.info = self.ctrl:GetAllianceCityData()
  if self.info ~= nil then
    local meta = self.info.meta
    local isRuin = self.info.state == 0
    local lowPos = isRuin and 0.3 or 0.25
    local loginServerId = LuaEntry.Player:GetSelfServerId()
    local serverId = self.info.serverId
    local mainCamera = CS.SceneManager.World.Camera
    if self.info.inProtectMode then
      lowPos = 0.4
    end
    local worldPos1 = mainCamera:GetRaycastGroundPoint(Vector3.New(Screen.width * 0.5, Screen.height * 0.5, 0))
    local worldPos2 = mainCamera:GetRaycastGroundPoint(Vector3.New(Screen.width * 0.5, Screen.height * lowPos, 0))
    local worldPos = SceneUtils.TileIndexToWorld(self.ctrl.pointId)
    local offset = worldPos1.z - worldPos2.z
    worldPos.z = worldPos.z + offset
    GoToUtil.GotoPos(worldPos, CS.SceneManager.World.Zoom, LookAtFocusTime, function()
    end, serverId)
    self.worldPos = worldPos
    self.AutoAdjustScreenPos:Init(worldPos + Vector3.New(0, 0, TileSize - offset))
    self.point_obj:InitData(self.info)
    self.btn_alliance_share:SetActive(self.info.isInAlliance)
    if self.info.state == 0 then
      self.name_text:SetLocalText("war_zone_outpost_2")
    else
      self.name_text:SetLocalText("war_zone_outpost_1")
    end
    self.skinMgr:ActiveSkin(self.info.seasonType)
    self:RefreshMarkBtnImg()
    self:ShowBtn()
    self:SetData()
  end
end

function UIWorldOutpostCityPointView:RefreshMarkList()
  self:RefreshMarkBtnImg()
end

function UIWorldOutpostCityPointView:RefreshMarkBtnImg()
  local realPoint = self.ctrl.pointId * 10 + 1
  local favorData = DataCenter.WorldFavoDataManager:GetBookmark(realPoint, self.ctrl.serverId, true)
  if favorData then
    self.btnMarkImg:LoadSprite("Assets/Main/Sprites/UI/UILWBuild/dl_daditu_yishoucang.png")
  else
    self.btnMarkImg:LoadSprite("Assets/Main/Sprites/UI/UILWBuild/dl_daditu_shoucang.png")
  end
end

function UIWorldOutpostCityPointView:SetData()
  local serverData = self.ctrl:GetAllianceCityDetail()
  self.serverData = serverData
  self.point_obj:RefreshData(serverData)
  self:RefreshOutpostInfo(serverData.outpostRepairInfo)
  CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.bg.transform)
end

function UIWorldOutpostCityPointView:RefreshOutpostInfo(outpostRepairInfo)
end

function UIWorldOutpostCityPointView:SetAllCellDestroy()
  self.build_btn_go:RemoveComponents(UIWorldOutpostCityPointBtn)
  if self.model ~= nil then
    for k, v in pairs(self.model) do
      if v ~= nil then
        self:GameObjectDestroy(v)
      end
    end
  end
  self.model = {}
end

function UIWorldOutpostCityPointView:ShowBtn()
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
        self.buildBtnCells[v] = self.build_btn_go:AddComponent(UIWorldOutpostCityPointBtn, nameStr)
        self.buildBtnCells[v]:ReInit(param)
      end)
    end
  end
end

function UIWorldOutpostCityPointView:OnMarkClick(isAlliance)
  local panelType = MarkGroup.Personal
  if isAlliance then
    panelType = MarkGroup.Alliance
  end
  if self.info ~= nil then
    local level
    local name = ""
    if self.info.state == 0 then
      name = "war_zone_outpost_2"
    else
      name = "war_zone_outpost_1"
    end
    local realPoint = self.ctrl.pointId * 10 + 1
    self.ctrl:OnMarkClick(self.ctrl.serverId, realPoint, name, level, panelType)
  end
end

function UIWorldOutpostCityPointView:OnShareClick(isAlliance)
  if self.info ~= nil then
    local level
    local name = ""
    if self.info.state == 0 then
      name = "war_zone_outpost_2"
    else
      name = "war_zone_outpost_1"
    end
    self.ctrl:OnShareClick(self.ctrl.serverId, self.ctrl.pointId, name, "", level, self.info.alAbbr)
  end
end

function UIWorldOutpostCityPointView:OnDetailClick()
  if self.info ~= nil then
    local detailKey = "war_zone_outpost_90"
    if self.ctrl.seasonType == SeasonMapType.NineNationRainforest then
      detailKey = "activity_1200107_rule"
    end
    local title = "war_zone_outpost_1"
    local desc = CS.GameEntry.Localization:GetString(detailKey)
    UIUtil.ShowDetail(desc, title, false, true, true)
  end
end

function UIWorldOutpostCityPointView:OnReturnClick()
  if self.info ~= nil then
    self.point_obj:OnReturnClick()
    self.btn_detail:SetActive(true)
    self.btn_return:SetActive(false)
  end
end

function UIWorldOutpostCityPointView:UpdateLod(lod)
  if 2 < lod then
    self.ctrl:CloseSelf(false)
  end
end

return UIWorldOutpostCityPointView
