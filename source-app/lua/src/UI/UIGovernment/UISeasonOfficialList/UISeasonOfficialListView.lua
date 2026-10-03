local UISeasonOfficialListView = BaseClass("UISeasonOfficialListView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local SeasonOfficialCell = require("UI.UIGovernment.UISeasonOfficialList.SeasonOfficialCell")
local SeasonKingCell = require("UI.UIGovernment.UISeasonOfficialList.SeasonKingCell")
local UITimeManager = _ENV.UITimeManager
local UIGray = CS.UIGray
local Setting = CS.GameEntry.Setting
local SettingKeys = _ENV.SettingKeys
local no_king_icon_path = "Root/Scrollview/Viewport/Content/Native/KingRoot/no_king/no_king_icon"
local king_icon_path = "Root/Scrollview/Viewport/Content/Native/KingRoot/king/king_icon"
local btn_rank_path = "Root/BottomBar/BtnRank"
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local badges_icon_path = "Root/TopBar/badgesIcon"
local badges_title_path = "Root/TopBar/badgesIcon/TextTitle2"
local info_btn_path = "Root/TopBar/InfoBtn"
local bg_path = "Root/BgMask/Bg"
local king_root_path = "Root/Scrollview/Viewport/Content/Native/KingRoot"
local time_mode_change_btn_path = "Root/TopBar/TimeGroup/TimeModeChangeBtn"
local timing_text_path = "Root/TopBar/TimeGroup/TimingText"
local time_tip_text_path = "Root/TopBar/TimeGroup/TimeTipText"
local refuse_text_path = "Root/BottomBar/refuseText"
local refuse_btn_path = "Root/BottomBar/refuseText/refuseBtn"
local refuse_toggle_path = "Root/BottomBar/refuseText/refuseToggle"
local checkmark_path = "Root/BottomBar/refuseText/refuseToggle/Checkmark"
local dynamic_bg_path = "Root/BgMask/DynamicBg"
local INSTRUCTION = {
  [GovOfficialType.Outpost] = "outpost_commander_help_1",
  [GovOfficialType.Center] = "supreme_president_help_1"
}

function UISeasonOfficialListView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:Init()
end

function UISeasonOfficialListView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISeasonOfficialListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomBuildingPositionList, self.Refresh)
  self:AddUIListener(EventId.BuildingOfficialAutoRejectRefresh, self.RefreshAutoRefuse)
  self:Refresh()
end

function UISeasonOfficialListView:OnRemoveListener()
  self:RemoveUIListener(EventId.KingdomBuildingPositionList, self.Refresh)
  self:RemoveUIListener(EventId.BuildingOfficialAutoRejectRefresh, self.RefreshAutoRefuse)
  base.OnRemoveListener(self)
end

function UISeasonOfficialListView:DataDefine()
  self.govOfficialType, self.serverId, self.buildingId = self:GetUserData()
  DataCenter.BuildingOfficialManager:FetchKingdomBuildingPositionList(self.serverId, self.buildingId)
  self.showServerTime = Setting:GetBool(SettingKeys.OFFICIAL_APPLY_TIME_SHOW_MODE, true)
end

function UISeasonOfficialListView:DataDestroy()
  self.showServerTime = nil
end

function UISeasonOfficialListView:ComponentDefine()
  self.badges_title = self:AddComponent(UIText, badges_title_path)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    local param = {}
    param.activityRulesStr = Localization:GetString(INSTRUCTION[self.govOfficialType])
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
  end)
  self.btn_rank = self:AddComponent(UIButton, btn_rank_path)
  self.btn_rank:SetOnClick(function()
    if DataCenter.BuildManager.MainLv >= 10 then
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIRankTable, {anim = true, hideTop = true}, self.serverId)
    else
      UIUtil.ShowTipsId(451038)
    end
  end)
  self.badges_icon = self:AddComponent(UIImage, badges_icon_path)
  self.kingNode = self:AddComponent(SeasonKingCell, king_root_path)
  self.content = self:AddComponent(UIBaseContainer, "Root/Scrollview/Viewport/Content/Native/OfficialList/nativeList")
  self.items = {}
  self.scrollview = self:AddComponent(UIScrollRect, "Root/Scrollview")
  self.scrollview:SetVerticalNormalizedPosition(1)
  self.time_mode_change_btn = self:AddComponent(UIButton, time_mode_change_btn_path)
  self.time_mode_change_btn:SetOnClick(BindCallback(self, self.OnTimeModeChangeBtnClick))
  self.timing_text = self:AddComponent(UITextMeshProUGUIEx, timing_text_path)
  self.time_tip_text = self:AddComponent(UITextMeshProUGUIEx, time_tip_text_path)
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.no_king_icon = self:AddComponent(UIImage, no_king_icon_path)
  self.king_icon = self:AddComponent(UIImage, king_icon_path)
  self.refuse_text = self:AddComponent(UITextMeshProUGUIEx, refuse_text_path)
  self.refuse_text:SetActive(self.govOfficialType == GovOfficialType.Outpost)
  self.refuse_text:SetLocalText("outpost_commander_ui_limit_26")
  self.refuse_btn = self:AddComponent(UIButton, refuse_btn_path)
  self.refuse_btn:SetOnClick(function()
    local content = Localization:GetString("outpost_commander_info_30")
    UIUtil.ShowBubbleTips(content, self.refuse_btn.transform.position, -30, 30, -10, nil, nil, {reversal = true})
  end)
  self.refuse_toggle = self:AddComponent(UIButton, refuse_toggle_path)
  self.refuse_toggle:SetSafeClickMode(true)
  self.refuse_toggle:SetSafeClickModeTime(1)
  self.refuse_toggle:SetOnClick(function()
    local building = DataCenter.BuildingOfficialManager:GetBuilding(self.serverId, self.buildingId)
    local autoReject = building and building.autoReject
    SFSNetwork.SendMessage(MsgDefines.KingdomBuildingSetAutoReject, self.serverId, self.buildingId, not autoReject)
  end)
  self.checkmark = self:AddComponent(UIImage, checkmark_path)
  self.dynamic_bg = self:AddComponent(UIBaseContainer, dynamic_bg_path)
end

function UISeasonOfficialListView:ComponentDestroy()
  self.governorList = {}
  self.nativeOfficialList = {}
  self.nativeGovernorList = {}
  self.btn_set_text = nil
  self.time_mode_change_btn = nil
  self.timing_text = nil
  self.time_tip_text = nil
  self.refuse_text = nil
  self.refuse_btn = nil
  self.refuse_toggle = nil
  self.checkmark = nil
  if self.dynamicBgComp then
    self:GameObjectDestroy(self.dynamicBgComp)
    self.dynamicBgComp = nil
  end
end

function UISeasonOfficialListView:Init()
  self.text_title:SetActive(true)
  self.badges_icon:SetActive(false)
  if self.govOfficialType == GovOfficialType.Outpost then
    self.text_title:SetLocalText("outpost_commander_ui_8")
    self.bg:LoadSpriteAsync("Assets/Main/SeasonRes/Shared/Textures/Official/zxl_s5_guanzhi_di.png")
  elseif self.govOfficialType == GovOfficialType.Center then
    self.text_title:SetLocalText("supreme_president_ui_22")
    self.bg:LoadSpriteAsync("Assets/Main/SeasonRes/Shared/Textures/Official/zxl_s5_guanzhi_gao.png")
  end
  local seasonSubType = SeasonUtil.GetSeasonSubdivisionType(false, self.serverId)
  local leaderConfig = DataCenter.GovernmentTemplateManager:GetLeaderByType(self.govOfficialType, seasonSubType)
  if string.IsNullOrEmpty(leaderConfig.background) then
    self.dynamic_bg:SetActive(false)
    self.bg:SetActive(true)
  else
    self.dynamic_bg:SetActive(true)
    self.bg:SetActive(false)
    self.dynamicBgComp = self:GameObjectInstantiateAsync(leaderConfig.background, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      local trans = go.transform
      trans:SetParent(self.dynamic_bg.transform)
      trans:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      trans:Set_offsetMin(0, 0)
      trans:Set_offsetMax(0, 0)
    end)
  end
  self.no_king_icon:LoadSpriteAsync(leaderConfig.icon)
  self.king_icon:LoadSpriteAsync(leaderConfig.icon)
  self:RefreshTimingGroup(self.showServerTime)
  self:RefreshAutoRefuse()
end

function UISeasonOfficialListView:RefreshAutoRefuse()
  local building = DataCenter.BuildingOfficialManager:GetBuilding(self.serverId, self.buildingId)
  local autoReject = building and building.autoReject
  self.checkmark:SetActive(autoReject)
end

function UISeasonOfficialListView:Refresh()
  local presidentInfo = DataCenter.BuildingOfficialManager:GetSurfaceLeader(self.serverId, self.buildingId)
  local seasonSubType = SeasonUtil.GetSeasonSubdivisionType(false, self.serverId)
  local leaderConfig = DataCenter.GovernmentTemplateManager:GetLeaderByType(self.govOfficialType, seasonSubType)
  self.kingNode:ReInit(self.serverId, self.buildingId, leaderConfig, presidentInfo)
  self:ClearAllItems()
  local templates = DataCenter.GovernmentTemplateManager:GetTemplatesByType(self.govOfficialType, seasonSubType)
  local positionData = DataCenter.BuildingOfficialManager:GetOfficial(self.serverId, self.buildingId) or {}
  for _, template in ipairs(templates) do
    if template.order > 0 then
      local item = self.content:LoadComponentAsync(SeasonOfficialCell, "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/SeasonOfficialCellYellow.prefab")
      item:SetData(template, positionData[template.id], self.serverId, self.buildingId)
      table.insert(self.items, item)
    end
  end
end

function UISeasonOfficialListView:ClearAllItems()
  for _, v in pairs(self.items) do
    self.content:RemoveAsyncComponent(v)
  end
  self.items = {}
end

local function Update1000MS(self)
  self:RefreshCurTime(self.showServerTime)
end

local function OnTimeModeChangeBtnClick(self)
  local showServerTime = not self.showServerTime
  self.showServerTime = showServerTime
  self:RefreshTimingGroup(showServerTime)
  Setting:SetBool(SettingKeys.OFFICIAL_APPLY_TIME_SHOW_MODE, showServerTime)
end

local function RefreshTimingGroup(self, showServerTime)
  if showServerTime then
    self.time_tip_text:SetLocalText("officer_apply_047")
  else
    self.time_tip_text:SetLocalText("officer_apply_046")
  end
  self:RefreshCurTime(showServerTime)
end

local function RefreshCurTime(self, showServerTime)
  if self.timing_text ~= nil then
    local timeText = ""
    if showServerTime then
      timeText = UITimeManager:GetInstance():TimeStampToTimeForServer(UITimeManager:GetInstance():GetServerTime(), true)
    else
      timeText = UITimeManager:GetInstance():TimeStampToTimeForLocalSimple(UITimeManager:GetInstance():GetServerTime(), true)
    end
    self.timing_text:SetText(timeText)
  end
end

UISeasonOfficialListView.Update1000MS = Update1000MS
UISeasonOfficialListView.OnTimeModeChangeBtnClick = OnTimeModeChangeBtnClick
UISeasonOfficialListView.RefreshTimingGroup = RefreshTimingGroup
UISeasonOfficialListView.RefreshCurTime = RefreshCurTime
return UISeasonOfficialListView
