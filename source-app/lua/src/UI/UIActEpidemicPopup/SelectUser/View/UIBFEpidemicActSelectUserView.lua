local base = require("UI.BattleFieldBase.SelectUser.View.UIBFBaseSelectUserView")
local UIBFEpidemicActSelectUserView = BaseClass("UIBFEpidemicActSelectUserView", base)
local Localization = CS.GameEntry.Localization
local TIME_INTERVAL_TIME = 3
local base_node_path = "PopUpTitle/Common_bg_orange2"
local title_text_path = "PopUpTitle/Common_img_title/titleText"
local top_desc_title_path = "PopUpTitle/Common_bg_orange2/Top/TopDescTitle"
local top_desc_path = "PopUpTitle/Common_bg_orange2/Top/TopDesc"
local banner_path = "PopUpTitle/Common_bg_orange2/Top/banner"
local btn_change_team_path = "PopUpTitle/Common_bg_orange2/BottomBtns/BtnChangeTeam"
local change_team_text_path = "PopUpTitle/Common_bg_orange2/BottomBtns/BtnChangeTeam/ChangeTeamText"
local btn_ok_path = "PopUpTitle/Common_bg_orange2/BottomBtns/BtnOK"
local go_text_path = "PopUpTitle/Common_bg_orange2/BottomBtns/BtnOK/GoText"
local top_corner_team_path = "PopUpTitle/Common_bg_orange/Corner/TopCornerTeam"
local lordPicPath = "zyf_xgfb_zhixuxianfengzhenying_banner"
local farmPicName = "zyf_xgfb_poxiaolianmingzhenying_banner"

function UIBFEpidemicActSelectUserView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  local infos = string.string2array_i_oneSep(LuaEntry.DataConfig:TryGetStr("YiBianJinQu", "k6", "3,20,10"), ",")
  self.maxNumMain = infos[2] or 20
  self.maxNumSub = infos[3] or 10
  self.maxNumCom = infos[1] or 3
  self.isRefreshMemberShowBattleTime = true
  self.refreshMemberShowBattleTimeInterval = TIME_INTERVAL_TIME
  DataCenter.ActEpidemicZoneManager:MarkRed(LittleRedConst.NameActEpidemicOther, LittleRedConst.NameActEpidemicMainCommanderNotSet, self.curTabIdx)
  self:ReopenWithoutCreate()
end

function UIBFEpidemicActSelectUserView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFEpidemicActSelectUserView:ComponentDefine()
  self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
  self.top_desc_title = self:AddComponent(UITextMeshProUGUIEx, top_desc_title_path)
  self.top_desc = self:AddComponent(UITextMeshProUGUIEx, top_desc_path)
  self.banner = self:AddComponent(UIRawImage, banner_path)
  self.top_corner_team = self:AddComponent(UITextMeshProUGUIEx, top_corner_team_path)
  self.top_corner_team:SetLocalText("YiBianJinQu_event_name_2")
  self.change_text = self:AddComponent(UITextMeshProUGUIEx, change_team_text_path)
  self.change_text:SetLocalText("YiBianJinQu_reward_tips_11")
  self.btn_Change = self:AddComponent(UIButton, btn_change_team_path)
  self.btn_Change:SetOnClick(BindCallback(self.OnClickChangeTeam, self))
end

function UIBFEpidemicActSelectUserView:OKBtnComponentDefine()
  self.btn_ok = self:AddComponent(UIButton, btn_ok_path)
  self.go_text = self:AddComponent(UITextMeshProUGUIEx, go_text_path)
  self.btn_ok:SetActive(not self.isPrepTime)
  if not self.isPrepTime then
    self.btn_ok:SetOnClick(function()
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattleFieldChangeTime, {anim = true}, nil, self.ctrl:GetBattlefieldType())
    end)
    self:ShowBattleTime()
  end
end

function UIBFEpidemicActSelectUserView:TopBarComponentDefine()
  local prefabTopBarPath = self.ctrl:GetTopBarPrefabPath()
  self.topBar = self:LoadComponentAsync(self.UIBFBaseSelectUserTopBar, prefabTopBarPath, self.transform:Find(base_node_path), function()
    self.topBar.gameObject.name = "TopBar"
    self.topBar:SetAnchoredPositionXY(0, -180)
    self.find:SetAnchoredPositionXY(0, -330)
    self:UpdateData()
  end)
end

function UIBFEpidemicActSelectUserView:ComponentDestroy()
  self.title_text = nil
  self.top_desc_title = nil
  self.top_desc = nil
  self.banner = nil
  self.btn_Change = nil
end

function UIBFEpidemicActSelectUserView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.EpidemicActPlayerListRefresh, self.UpdateData)
  self:AddUIListener(EventId.EpidemicActChangeRoleSuccess, self.OnChangeRoleSuccess)
  self:AddUIListener(EventId.EpidemicActPlayerApplyRefresh, self.RefreshButtonState)
  self:AddUIListener(EventId.ActEpidemicOnActInfoStageChanged, self.OnActStageChanged)
end

function UIBFEpidemicActSelectUserView:OnRemoveListener()
  self:RemoveUIListener(EventId.EpidemicActPlayerListRefresh, self.UpdateData)
  self:RemoveUIListener(EventId.EpidemicActChangeRoleSuccess, self.OnChangeRoleSuccess)
  self:RemoveUIListener(EventId.EpidemicActPlayerApplyRefresh, self.RefreshButtonState)
  self:RemoveUIListener(EventId.ActEpidemicOnActInfoStageChanged, self.OnActStageChanged)
  base.OnRemoveListener(self)
end

function UIBFEpidemicActSelectUserView:ReopenWithoutCreate()
  DataCenter.ActEpidemicZoneManager:RequestActivityPlayerList()
  local stage = DataCenter.ActEpidemicZoneManager:FixStage(self.curTabIdx)
  if stage == EpidemicZoneStage.None or stage == EpidemicZoneStage.Show or stage == EpidemicZoneStage.End then
    self.ctrl:CloseSelf()
    return
  end
  self.isPrepTime = self.ctrl:IsInPrepTime()
  self:RefreshTeamSprite()
  self:RefreshButtonState()
  self:RefreshRoleDetail()
  self:RefreshMemberList()
  self:RefreshTitleTxt()
  self:ForceMyApply()
end

function UIBFEpidemicActSelectUserView:OnActStageChanged()
  self:ReopenWithoutCreate()
end

function UIBFEpidemicActSelectUserView:RefreshRoleDetail()
  local roleName = ActEpidemicUtils.GetRoleNameByRoleId(self.role)
  self.top_desc_title:SetText(Localization:GetString("YiBianJinQu_participants_tips_2", roleName))
  self.top_desc:SetLocalText(self.role == EpidemicZoneRole.Lord and "YiBianJinQu_participants_tips_3" or "YiBianJinQu_participants_tips_4")
  self.banner:LoadSprite(string.format(LoadPath.LWBattleFieldEpidemicTexture1Path, self.role == EpidemicZoneRole.Lord and lordPicPath or farmPicName))
end

function UIBFEpidemicActSelectUserView:OnChangeRoleSuccess(data)
  local group = data.group
  local role = data.role
  if group == self.curTabIdx then
    local roleName = ActEpidemicUtils.GetRoleNameByRoleId(role)
    UIUtil.ShowTips(Localization:GetString("YiBianJinQu_trivial_tips_20", roleName))
    self.role = role
    self:RefreshRoleDetail()
  end
end

function UIBFEpidemicActSelectUserView:OnClickChangeTeam()
  local canChangeRole = ActEpidemicUtils.IsInSignInStage(self.curTabIdx) and ActEpidemicUtils.CanChangeBattlePlayer()
  if not canChangeRole then
    return
  end
  local newRole = EpidemicZoneRole.Default
  if self.role == EpidemicZoneRole.Farmer then
    newRole = EpidemicZoneRole.Lord
  elseif self.role == EpidemicZoneRole.Lord then
    newRole = EpidemicZoneRole.Farmer
  end
  if newRole ~= EpidemicZoneRole.Default then
    local groupInfo = ActEpidemicUtils.GetGroup(self.curTabIdx)
    if groupInfo then
      EventManager:GetInstance():Broadcast(EventId.EpidemicActTryChangeRole, {
        role = newRole,
        group = self.curTabIdx,
        battlePeriod = groupInfo.battlePeriod
      })
    end
  end
end

function UIBFEpidemicActSelectUserView:RefreshTitleTxt()
  local showFlag = self.ctrl:IsHadTeam2() and not self.isPrepTime
  local _, y, z = self.title_text:GetLocalPositionXYZ()
  self.title_text:SetLocalPositionXYZ(showFlag and 69 or 0, y, z)
  self.title_text:SetLocalText(self.isPrepTime and "YiBianJinQu_trivial_tips_7" or "YiBianJinQu_participants_tips_1")
end

function UIBFEpidemicActSelectUserView:ForceMyApply()
  self:FocusTo(LuaEntry.Player:GetUid())
end

function UIBFEpidemicActSelectUserView:RefreshButtonState()
  if not ActEpidemicUtils.IsInSignInStage(self.curTabIdx) then
    self.btn_ok:SetActive(false)
    self.btn_Change:SetActive(false)
    self:SetScrollViewPosAndSize(true)
  else
    local canChangePlayer = ActEpidemicUtils.CanChangeBattlePlayer()
    self.btn_ok:SetActive(true)
    self.btn_Change:SetActive(canChangePlayer)
    self.go_text:SetLocalText("458004")
    self:SetScrollViewPosAndSize(false)
  end
end

function UIBFEpidemicActSelectUserView:SetScrollViewPosAndSize(changeBig)
  if changeBig then
    self.scroll_view:SetAnchoredPositionXY(375, -405)
    self.scroll_view:SetSizeDelta(Vector2.New(750, 600))
  else
    self.scroll_view:SetAnchoredPositionXY(375, -405)
    self.scroll_view:SetSizeDelta(Vector2.New(750, 480))
  end
end

return UIBFEpidemicActSelectUserView
