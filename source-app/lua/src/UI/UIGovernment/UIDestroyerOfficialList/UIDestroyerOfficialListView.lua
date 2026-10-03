local UIDestroyerOfficialListView = BaseClass("UIDestroyerOfficialListView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local DestroyerKingCell = require("UI.UIGovernment.UIDestroyerOfficialList.DestroyerKingCell")
local SeasonOfficialCell = require("UI.UIGovernment.UISeasonOfficialList.SeasonOfficialCell")
local KingItem = require("UI.UIGovernment.Official.Component.KingItem")
local OfficialUser = require("UI.UIGovernment.OfficialUser")
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
local man_path = "Root/BgMask/Bg/man"
local woman_path = "Root/BgMask/Bg/woman"
local king_root_path = "Root/Scrollview/Viewport/Content/Native/KingRoot"
local destroyer_king_path = "Root/Scrollview/Viewport/Content/Destroyer/DestroyerKing"
local btn_set_path = "Root/BottomBar/BtnSet"
local btn_set_text_path = "Root/BottomBar/BtnSet/BtnSetText"
local time_mode_change_btn_path = "Root/TopBar/TimeGroup/TimeModeChangeBtn"
local timing_text_path = "Root/TopBar/TimeGroup/TimingText"
local time_tip_text_path = "Root/TopBar/TimeGroup/TimeTipText"
local refuse_text_path = "Root/BottomBar/refuseText"
local refuse_btn_path = "Root/BottomBar/refuseText/refuseBtn"
local refuse_toggle_path = "Root/BottomBar/refuseText/refuseToggle"
local checkmark_path = "Root/BottomBar/refuseText/refuseToggle/Checkmark"
local destroyer_path = "Root/Scrollview/Viewport/Content/Destroyer"
local btn_auto_path = "Root/BottomBar/BtnAuto"
local btn_auto_icon_path = "Root/BottomBar/BtnAuto/BtnAutoIcon"
local btn_auto_text_path = "Root/BottomBar/BtnAuto/BtnAutoText"
local dynamic_bg_path = "Root/BgMask/DynamicBg"

function UIDestroyerOfficialListView:OnCreate()
  base.OnCreate(self)
  self:DataDefine()
  self:ComponentDefine()
  self:Init()
end

function UIDestroyerOfficialListView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIDestroyerOfficialListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.KingdomBuildingPositionList, self.RefreshDestroyer)
  self:AddUIListener(EventId.BuildingOfficialAutoRejectRefresh, self.RefreshAutoRefuse)
  self:AddUIListener(EventId.CrossKingdomPositionsRefresh, self.RefreshNativeOfficials)
  self:AddUIListener(EventId.GovernmentPresidentRefresh, self.RefreshNativeKing)
  self:AddUIListener(EventId.KingdomPositionInfoUpdate, self.OnAppoint)
  self:AddUIListener(EventId.OfficialGetPositionCd, self.OnPositionCdDataUpdate)
  self:AddUIListener(EventId.OfficialGetAutoAgreeInfo, self.OnOfficialGetAutoAgreeInfo)
  self:AddUIListener(EventId.OnPassDay, self.SendKingdomPositionAutoAgreeGet)
  self:RefreshDestroyer()
end

function UIDestroyerOfficialListView:OnRemoveListener()
  self:RemoveUIListener(EventId.KingdomBuildingPositionList, self.RefreshDestroyer)
  self:RemoveUIListener(EventId.BuildingOfficialAutoRejectRefresh, self.RefreshAutoRefuse)
  self:RemoveUIListener(EventId.CrossKingdomPositionsRefresh, self.RefreshNativeOfficials)
  self:RemoveUIListener(EventId.GovernmentPresidentRefresh, self.RefreshNativeKing)
  self:RemoveUIListener(EventId.KingdomPositionInfoUpdate, self.OnAppoint)
  self:RemoveUIListener(EventId.OfficialGetPositionCd, self.OnPositionCdDataUpdate)
  self:RemoveUIListener(EventId.OfficialGetAutoAgreeInfo, self.OnOfficialGetAutoAgreeInfo)
  self:RemoveUIListener(EventId.OnPassDay, self.SendKingdomPositionAutoAgreeGet)
  base.OnRemoveListener(self)
end

function UIDestroyerOfficialListView:DataDefine()
  self.serverId, self.buildingId = self:GetUserData()
  DataCenter.BuildingOfficialManager:FetchKingdomBuildingPositionList(self.serverId, self.buildingId)
  self.showServerTime = Setting:GetBool(SettingKeys.OFFICIAL_APPLY_TIME_SHOW_MODE, true)
  self.cdIndex = 0
  self.cdIndexUpdateTime = 0
  self.setBtnUnusable = false
  SFSNetwork.SendMessage(MsgDefines.GetKingInfo, self.serverId)
  SFSNetwork.SendMessage(MsgDefines.GetKingdomPositions, self.serverId)
end

function UIDestroyerOfficialListView:DataDestroy()
  self.showServerTime = nil
end

function UIDestroyerOfficialListView:ComponentDefine()
  self.badges_title = self:AddComponent(UIText, badges_title_path)
  self.text_title = self:AddComponent(UIText, text_title_path)
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.info_btn = self:AddComponent(UIButton, info_btn_path)
  self.info_btn:SetOnClick(function()
    local param = {}
    param.activityRulesStr = Localization:GetString("season_s6_zone_government_2")
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
  self.man = self:AddComponent(UIImage, man_path)
  self.woman = self:AddComponent(UIImage, woman_path)
  self.badges_icon = self:AddComponent(UIImage, badges_icon_path)
  self.kingNode = self:AddComponent(KingItem, king_root_path)
  self.destroyer_king = self:AddComponent(DestroyerKingCell, destroyer_king_path)
  self.content = self:AddComponent(UIBaseContainer, "Root/Scrollview/Viewport/Content/Destroyer/OfficialList/DestroyerList")
  self.items = {}
  self.scrollview = self:AddComponent(UIScrollRect, "Root/Scrollview")
  self.scrollview:SetVerticalNormalizedPosition(1)
  self.btn_set = self:AddComponent(UIButton, btn_set_path)
  self.btn_set:SetOnClick(BindCallback(self, self.OnSetBtnClick))
  self.btn_set_text = self:AddComponent(UITextMeshProUGUIEx, btn_set_text_path)
  self.btn_set:SetActive(false)
  self.time_mode_change_btn = self:AddComponent(UIButton, time_mode_change_btn_path)
  self.time_mode_change_btn:SetOnClick(BindCallback(self, self.OnTimeModeChangeBtnClick))
  self.timing_text = self:AddComponent(UITextMeshProUGUIEx, timing_text_path)
  self.time_tip_text = self:AddComponent(UITextMeshProUGUIEx, time_tip_text_path)
  self.bg = self:AddComponent(UIRawImage, bg_path)
  self.no_king_icon = self:AddComponent(UIImage, no_king_icon_path)
  self.king_icon = self:AddComponent(UIImage, king_icon_path)
  self.refuse_text = self:AddComponent(UITextMeshProUGUIEx, refuse_text_path)
  self.refuse_text:SetActive(false)
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
  self.destroyer = self:AddComponent(UIBaseContainer, destroyer_path)
  self.autoBtn = self:AddComponent(UIButton, btn_auto_path)
  self.autoBtnIcon = self:AddComponent(UIButton, btn_auto_icon_path)
  self.autoBtnText = self:AddComponent(UIText, btn_auto_text_path)
  self.autoBtn:SetActive(false)
  self.autoBtn:SetOnClick(BindCallback(self, self.OnClickAutoBtn))
  self.nativeOfficialList = {}
  for i = 3, 8 do
    local item = self:AddComponent(OfficialUser, "Root/Scrollview/Viewport/Content/Native/OfficialList/nativeList/cell" .. i)
    local configData = DataCenter.GovernmentTemplateManager:GetTemplateByGroupAndOrder(GovOfficialGroup.Common, i)
    self.nativeOfficialList[configData.id] = item
    item:Reset(configData.order, self.serverId)
  end
  self.dynamic_bg = self:AddComponent(UIBaseContainer, dynamic_bg_path)
end

function UIDestroyerOfficialListView:ComponentDestroy()
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
end

function UIDestroyerOfficialListView:Init()
  self.isPresident = LuaEntry.Player:IsPresident(self.serverId or LuaEntry.Player:GetSourceServerId())
  if self.isPresident then
    DataCenter.GovernmentManager:SendKingdomPositionAppointmentCd()
    self:SendKingdomPositionAutoAgreeGet()
  end
  self.text_title:SetActive(true)
  self.badges_icon:SetActive(false)
  self.text_title:SetLocalText("457006")
  local seasonSubType = SeasonUtil.GetSeasonSubdivisionType(false, self.serverId)
  local leaderConfig = DataCenter.GovernmentTemplateManager:GetLeaderByType(GovOfficialType.Native, seasonSubType)
  self.no_king_icon:LoadSpriteAsync(leaderConfig.icon)
  self.king_icon:LoadSpriteAsync(leaderConfig.icon)
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
  self:RefreshTimingGroup(self.showServerTime)
  self:RefreshAutoRefuse()
  self:RefreshDestroyer()
  self:RefreshNativeKing()
  self:RefreshNativeOfficials()
end

function UIDestroyerOfficialListView:SetKingGender(gender)
  if gender == 1 then
    self.man:SetActive(true)
    self.woman:SetActive(false)
  elseif gender == 2 then
    self.man:SetActive(false)
    self.woman:SetActive(true)
  else
    self.man:SetActive(false)
    self.woman:SetActive(false)
  end
end

function UIDestroyerOfficialListView:RefreshAutoRefuse()
  local building = DataCenter.BuildingOfficialManager:GetBuilding(self.serverId, self.buildingId)
  local autoReject = building and building.autoReject
  self.checkmark:SetActive(autoReject)
end

function UIDestroyerOfficialListView:RefreshDestroyer()
  self:ClearAllItems()
  do
    local seasonSubType = SeasonUtil.GetSeasonSubdivisionType(false, self.serverId)
    local destroyerKingConfig = DataCenter.GovernmentTemplateManager:GetDestroyerKingConfig(seasonSubType)
    local destroyerKingInfo = DataCenter.BuildingOfficialManager:GetOfficial(self.serverId, self.buildingId, destroyerKingConfig.id)
    self.destroyer_king:ReInit(self.serverId, self.buildingId, destroyerKingConfig, destroyerKingInfo)
    local templates = DataCenter.GovernmentTemplateManager:GetTemplatesByType(GovOfficialType.Destroyer, seasonSubType)
    local positionData = DataCenter.BuildingOfficialManager:GetOfficial(self.serverId, self.buildingId) or {}
    for _, template in ipairs(templates) do
      if template.order > 0 then
        local item = self.content:LoadComponentAsync(SeasonOfficialCell, "Assets/Main/SeasonRes/Shared/Prefabs/UI/Official/SeasonOfficialCellYellow.prefab")
        item:SetData(template, positionData[template.id], self.serverId, self.buildingId)
        table.insert(self.items, item)
      end
    end
    self.destroyer:SetActive(true)
  end
  goto lbl_78
  self.destroyer:SetActive(false)
  ::lbl_78::
end

function UIDestroyerOfficialListView:RefreshNativeKing()
  local presidentInfo = DataCenter.GovernmentManager:GetCurPresident(self.serverId)
  self.kingNode:ReInit(presidentInfo, self.serverId)
  if presidentInfo == nil or presidentInfo.uid == 0 or presidentInfo.uid == "" or presidentInfo.gender == nil then
    self:SetKingGender()
  else
    self:SetKingGender(presidentInfo.gender)
  end
end

function UIDestroyerOfficialListView:RefreshNativeOfficials()
  local thePositions = DataCenter.GovernmentManager:GetKingdomPositionByServerId(self.serverId)
  if thePositions then
    for governmentId, item in pairs(self.nativeOfficialList) do
      item:SetPositionsData(thePositions[governmentId], self.serverId)
    end
  end
end

function UIDestroyerOfficialListView:ClearAllItems()
  for _, v in pairs(self.items) do
    self.content:RemoveAsyncComponent(v)
  end
  self.items = {}
end

function UIDestroyerOfficialListView:OnAppoint(isAppoint)
  if isAppoint and toInt(self.serverId) > 0 then
    SFSNetwork.SendMessage(MsgDefines.GetKingdomPositions, self.serverId)
  end
end

local function Update1000MS(self)
  self:RefreshCurTime(self.showServerTime)
  if self.isPresident and self.cdIndexUpdateTime > 0 then
    local offset = self.cdIndexUpdateTime - UITimeManager:GetInstance():GetServerTime()
    if 0 <= offset then
      self.btn_set_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(offset))
    else
      self.cdIndexUpdateTime = 0
      self.btn_set_text:SetLocalText("officer_apply_btn_002")
      UIGray.SetGray(self.btn_set.transform, false, true)
      self.setBtnUnusable = false
    end
  end
  if self.autoAgreeTime then
    local now = UITimeManager:GetInstance():GetServerTime()
    local diff = self.autoAgreeTime - now
    if 0 <= diff then
      diff = math.modf(diff / 1000)
      self.autoBtnText:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutHour(diff))
    else
      self:RefreshAutoBtn()
    end
  end
end

local function OnSetBtnClick(self)
  if self.isPresident then
    if self.setBtnUnusable then
      UIUtil.ShowTipsId("officer_apply_037")
      return
    end
    UIManager:GetInstance():OpenWindow(UIWindowNames.OfficialCDSetting, {anim = true}, self.cdIndex)
  end
end

local function OnPositionCdDataUpdate(self, msg)
  if self.isPresident and msg then
    self.btn_set:SetActive(true)
    self.cdIndex = msg.cdIndex
    self.cdIndexUpdateTime = msg.cdIndexUpdateTime
    local offset = self.cdIndexUpdateTime - UITimeManager:GetInstance():GetServerTime()
    if 0 <= offset then
      self.setBtnUnusable = true
      UIGray.SetGray(self.btn_set.transform, true, true)
    else
      self.cdIndexUpdateTime = 0
      self.btn_set_text:SetLocalText("officer_apply_btn_002")
      UIGray.SetGray(self.btn_set.transform, false, true)
      self.setBtnUnusable = false
    end
  else
    self.btn_set:SetActive(false)
  end
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

function UIDestroyerOfficialListView:SendKingdomPositionAutoAgreeGet()
  self.autoAgreeShow = DataCenter.GovernmentManager:GetAutoAgreeShow()
  DataCenter.GovernmentManager:SendKingdomPositionAutoAgreeGet()
end

function UIDestroyerOfficialListView:OnOfficialGetAutoAgreeInfo()
  self.autoAgreeInfo = DataCenter.GovernmentManager:GetKingdomPositionAutoAgreeInfo()
  self:RefreshAutoBtn()
end

function UIDestroyerOfficialListView:RefreshAutoBtn()
  self.autoAgreeTime = nil
  if self.autoAgreeShow and self.isPresident and self.autoAgreeInfo then
    self.autoBtn:SetActive(true)
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.autoAgreeInfo.autoAgreeTime and self.autoAgreeInfo.autoAgreeTime - now >= 0 then
      self.autoBtnIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_1.png")
      local diff = math.modf((self.autoAgreeInfo.autoAgreeTime - now) / 1000)
      self.autoBtnText:SetText(UITimeManager:GetInstance():SecondToFmtStringWithoutHour(diff))
      self.autoAgreeTime = self.autoAgreeInfo.autoAgreeTime
    elseif self.autoAgreeInfo.autoAgree then
      self.autoBtnIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_5.png")
      self.autoBtnText:SetLocalText("officer_apply_btn_004")
    else
      self.autoBtnIcon:LoadSprite("Assets/Main/Sprites/UI/LWCommon/Sprite/cfm_tongyong_anniu_3.png")
      self.autoBtnText:SetLocalText("officer_apply_btn_003")
    end
  else
    self.autoBtn:SetActive(false)
  end
end

function UIDestroyerOfficialListView:OnClickAutoBtn()
  if self.autoAgreeShow and self.isPresident and self.autoAgreeInfo then
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.autoAgreeInfo.autoAgreeTime and self.autoAgreeInfo.autoAgreeTime - now >= 0 then
      local diff = math.modf((self.autoAgreeInfo.autoAgreeTime - now) / 1000)
      UIUtil.ShowTips(Localization:GetString("officer_apply_054", UITimeManager:GetInstance():SecondToFmtStringWithoutHour(diff)))
    elseif self.autoAgreeInfo.autoAgree then
      UIUtil.ShowConfirmNew({
        contentText = Localization:GetString("officer_apply_055"),
        btnNum = 2,
        showToggle = false,
        confirmBtnParam = {
          action = function()
            SFSNetwork.SendMessage(MsgDefines.KingdomPositionAutoAgree, 0)
          end
        }
      })
    else
      UIUtil.ShowConfirmNew({
        contentText = Localization:GetString("officer_apply_052"),
        btnNum = 2,
        showToggle = false,
        confirmBtnParam = {
          action = function()
            SFSNetwork.SendMessage(MsgDefines.KingdomPositionAutoAgree, 1)
          end
        }
      })
    end
  end
end

UIDestroyerOfficialListView.Update1000MS = Update1000MS
UIDestroyerOfficialListView.OnSetBtnClick = OnSetBtnClick
UIDestroyerOfficialListView.OnPositionCdDataUpdate = OnPositionCdDataUpdate
UIDestroyerOfficialListView.OnTimeModeChangeBtnClick = OnTimeModeChangeBtnClick
UIDestroyerOfficialListView.RefreshTimingGroup = RefreshTimingGroup
UIDestroyerOfficialListView.RefreshCurTime = RefreshCurTime
return UIDestroyerOfficialListView
