local base = UIBaseView
local SeasonAllianceWarTimeSetView = BaseClass("SeasonAllianceWarTimeSetView", UIBaseView)
local p_btn_blur_path = "p_btn_blur"
local p_text_title_path = "Root/bg/title/Common_img_title/p_text_title"
local p_text_zero_clock_path = "Root/bg/content/bottom/bg/content_state/content_zero_clock/p_text_zero_clock"
local p_btn_close_path = "Root/bg/title/p_btn_close"
local p_comp_state_path = "Root/bg/content/top/p_comp_state"
local p_text_rule_desc_path = "Root/bg/content/top/content_text/p_text_rule_desc"
local p_btn_info_path = "Root/bg/content/top/p_btn_info"
local p_text_btn_info_path = "Root/bg/content/top/p_btn_info/img_btn_info/p_text_btn_info"
local p_text_select_hint_path = "Root/bg/content/bottom/bg/img_bg_select_hint/p_text_select_hint"
local p_go_state_time_template_1_path = "Root/bg/content/bottom/bg/content_state/p_root_state_time_1/p_go_state_time_template_1"
local p_go_state_time_template_2_path = "Root/bg/content/bottom/bg/content_state/p_root_state_time_2/p_go_state_time_template_2"
local p_go_state_time_template_3_path = "Root/bg/content/bottom/bg/content_state/p_root_state_time_3/p_go_state_time_template_3"
local p_btn_state_time_info_path = "Root/bg/content/bottom/bg/content_state/p_btn_state_time_info"
local p_btn_state_time_set_path = "Root/bg/content/bottom/bg/content_state/p_btn_state_time_set"
local p_text_btn_state_time_set_path = "Root/bg/content/bottom/bg/content_state/p_btn_state_time_set/LW_Btn_Common_New_Base/p_text_btn_state_time_set"
local p_text_no_log_path = "Root/bg/content/bottom/bg/content_log/p_text_no_log"
local p_scroll_view_log_path = "Root/bg/content/bottom/bg/content_log/p_scroll_view_log"
local content_path = "Root/bg/content/bottom/bg/content_log/p_scroll_view_log/Viewport/Content"
local p_go_log_template_path = "Root/bg/content/bottom/bg/content_log/p_scroll_view_log/p_go_log_template"
local content_state_path = "Root/bg/content/bottom/bg/content_state"
local UILWSeasonAllianceWarTimeStateComp = require("UI/LWSeason5/UILWSeasonAllianceWarTime/Common/UILWSeasonAllianceWarTimeStateComp")
local SeasonAllianceWarTimeSetSelectionComp = require("UI/LWSeason5/UILWSeasonAllianceWarTime/Set/Comp/SeasonAllianceWarTimeSetSelectionComp")
local SeasonAllianceWarTimeSetLogComp = require("UI/LWSeason5/UILWSeasonAllianceWarTime/Set/Comp/SeasonAllianceWarTimeSetLogComp")

function SeasonAllianceWarTimeSetView:ComponentDefine()
  self.p_btn_blur = self:AddComponent(UIButton, p_btn_blur_path)
  self.p_text_title = self:AddComponent(UITextMeshProUGUIEx, p_text_title_path)
  self.p_btn_blur:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_text_zero_clock = self:AddComponent(UITextMeshProUGUIEx, p_text_zero_clock_path)
  self.p_btn_close = self:AddComponent(UIButton, p_btn_close_path)
  self.p_btn_close:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_comp_state = self:AddComponent(UILWSeasonAllianceWarTimeStateComp, p_comp_state_path)
  self.p_text_rule_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_rule_desc_path)
  self.p_btn_info = self:AddComponent(UIButton, p_btn_info_path)
  self.p_btn_info:SetOnClick(BindCallback(self, self.OnInfoClicked))
  self.p_text_btn_info = self:AddComponent(UITextMeshProUGUIEx, p_text_btn_info_path)
  self.p_text_select_hint = self:AddComponent(UITextMeshProUGUIEx, p_text_select_hint_path)
  self.p_go_state_time_template_1 = self:AddComponent(SeasonAllianceWarTimeSetSelectionComp, p_go_state_time_template_1_path)
  self.p_go_state_time_template_2 = self:AddComponent(SeasonAllianceWarTimeSetSelectionComp, p_go_state_time_template_2_path)
  self.p_go_state_time_template_3 = self:AddComponent(SeasonAllianceWarTimeSetSelectionComp, p_go_state_time_template_3_path)
  self.p_animator_1 = self:AddComponent(UIAnimator, p_go_state_time_template_1_path)
  self.p_animator_2 = self:AddComponent(UIAnimator, p_go_state_time_template_2_path)
  self.p_animator_3 = self:AddComponent(UIAnimator, p_go_state_time_template_3_path)
  self.p_btn_state_time_info = self:AddComponent(UIButton, p_btn_state_time_info_path)
  self.p_btn_state_time_info:SetOnClick(BindCallback(self, self.OnStateTimeInfoClicked))
  self.p_btn_state_time_set = self:AddComponent(UIButton, p_btn_state_time_set_path)
  self.p_btn_state_time_set:SetOnClick(BindCallback(self, self.OnSetClicked))
  self.p_text_btn_state_time_set = self:AddComponent(UITextMeshProUGUIEx, p_text_btn_state_time_set_path)
  self.p_text_no_log = self:AddComponent(UITextMeshProUGUIEx, p_text_no_log_path)
  self.p_scroll_view_log = self:AddComponent(UIScrollView, p_scroll_view_log_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.p_go_log_template = self:AddComponent(UIBaseContainer, p_go_log_template_path)
  self.content_state = self:AddComponent(UIAnimator, content_state_path)
  self.ItemIndex = 0
  self.compScroll = self.p_scroll_view_log
  self.compScroll:SetFixedItemSize(810, 100)
  self.compScroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnScrollItemMoveIn(itemObj, index)
  end)
  self.compScroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnScrollItemMoveOut(itemObj, index)
  end)
end

function SeasonAllianceWarTimeSetView:ComponentDestroy()
  self.compScroll:ClearCells()
  self.compScroll = nil
  self.p_btn_blur = nil
  self.p_text_title = nil
  self.p_text_zero_clock = nil
  self.p_btn_close = nil
  self.p_comp_state = nil
  self.p_text_rule_desc = nil
  self.p_btn_info = nil
  self.p_text_btn_info = nil
  self.p_text_select_hint = nil
  self.p_go_state_time_template_1 = nil
  self.p_go_state_time_template_2 = nil
  self.p_go_state_time_template_3 = nil
  self.p_animator_1 = nil
  self.p_animator_2 = nil
  self.p_animator_3 = nil
  self.p_btn_state_time_info = nil
  self.p_btn_state_time_set = nil
  self.p_text_btn_state_time_set = nil
  self.p_text_no_log = nil
  self.p_scroll_view_log = nil
  self.content = nil
  self.p_go_log_template = nil
  self.content_state = nil
end

function SeasonAllianceWarTimeSetView:DataDefine()
  self.AnimIn = "V_ui_S5_AllianceWarTimeSet_in"
  self.AnimConfirm = "V_ui_S5_AllianceWarTimeSet_confirm"
end

function SeasonAllianceWarTimeSetView:DataDestroy()
  DataCenter.UILWSeasonAllianceWarTimeManager:ClearWaitingGetInfo()
end

function SeasonAllianceWarTimeSetView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function SeasonAllianceWarTimeSetView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonAllianceWarTimeSetView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonAllianceWarTimeGetInfoUpdate, self.OnGetInfoUpdate)
  self:AddUIListener(EventId.SeasonAllianceWarTimePush, self.OnSetTimeUpdate)
  self:AddUIListener(EventId.SeasonAllianceWarTimeSelectEsc, self.OnEscClicked)
  self:AddUIListener(EventId.SeasonAllianceWarTimeSwitchServerLocal, self.OnSwitchServerLocal)
end

function SeasonAllianceWarTimeSetView:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonAllianceWarTimeGetInfoUpdate, self.OnGetInfoUpdate)
  self:RemoveUIListener(EventId.SeasonAllianceWarTimePush, self.OnSetTimeUpdate)
  self:RemoveUIListener(EventId.SeasonAllianceWarTimeSelectEsc, self.OnEscClicked)
  self:RemoveUIListener(EventId.SeasonAllianceWarTimeSwitchServerLocal, self.OnSwitchServerLocal)
  base.OnRemoveListener(self)
end

function SeasonAllianceWarTimeSetView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

function SeasonAllianceWarTimeSetView:InitData(data)
  self.CompSelections = {}
  self.AnimSelections = {}
  DataCenter.UILWSeasonAllianceWarTimeManager:ClearMyAllianceWarTimeData()
  self.CurActComp = nil
  self.IsLocalTime = false
  return true
end

function SeasonAllianceWarTimeSetView:InitUi()
  self.p_text_btn_state_time_set:SetLocalText("110006")
  self.p_text_btn_info:SetLocalText("170001")
  self.p_text_title:SetLocalText("s5_alliance_battle_time_ui36")
  self.p_text_select_hint:SetLocalText("s5_alliance_battle_time_ui09")
  self.p_text_rule_desc:SetLocalText("s5_alliance_battle_time_ui08")
  self.p_text_no_log:SetLocalText("s5_alliance_battle_time_ui06")
  CS.UIGray.SetGray(self.p_btn_state_time_set.transform, true, true)
  self:CreateSelection()
  self.content_state:Play(self.AnimIn)
  DataCenter.UILWSeasonAllianceWarTimeManager:SendGetInfo()
end

function SeasonAllianceWarTimeSetView:CreateSelection()
  self.CompSelections[0] = self.p_go_state_time_template_1
  self.CompSelections[1] = self.p_go_state_time_template_2
  self.CompSelections[2] = self.p_go_state_time_template_3
  self.AnimSelections[0] = self.p_animator_1
  self.AnimSelections[1] = self.p_animator_2
  self.AnimSelections[2] = self.p_animator_3
  local _, time = self.p_animator_1:GetAnimationReturnTime("V_ui_S5_AllianceWarTimeSet_time_cancel")
  self.p_animator_1:Play("V_ui_S5_AllianceWarTimeSet_time_cancel", 0, time)
  self.p_animator_2:Play("V_ui_S5_AllianceWarTimeSet_time_cancel", 0, time)
  self.p_animator_3:Play("V_ui_S5_AllianceWarTimeSet_time_cancel", 0, time)
end

function SeasonAllianceWarTimeSetView:UpdateData()
  self.CurIndex = -1
  self.SetTime = 0
  self.MyAllianceWarTimeData = DataCenter.UILWSeasonAllianceWarTimeManager:GetMyAllianceWarTimeData()
  if self.MyAllianceWarTimeData ~= nil then
    self.SetTime = checknumber(self.MyAllianceWarTimeData.SetTime)
    self.CurIndex = DataCenter.UILWSeasonAllianceWarTimeManager:GetRealTimeIndex(self.MyAllianceWarTimeData.TimeIndex, self.SetTime)
  end
  self.ServerIndex = self.CurIndex
  return true
end

function SeasonAllianceWarTimeSetView:UpdateUi(playAnim)
  self:UpdateTimeState()
  self:UpdateSelections(playAnim)
  self:UpdateLogs()
end

function SeasonAllianceWarTimeSetView:UpdateTimeState()
  local stateData = {}
  stateData.TimeIndex = self.ServerIndex
  stateData.SetTime = self.SetTime
  stateData.IsLocalTime = self.IsLocalTime
  stateData.ClockClickEnable = true
  self.p_comp_state:ReInit(stateData)
end

function SeasonAllianceWarTimeSetView:UpdateSelections(playAnim)
  for i = 0, 2 do
    local comp = self.CompSelections[i]
    local data = {}
    data.TimeIndex = i
    data.IsLocalTime = self.IsLocalTime
    data.IsSelect = i == self.CurIndex
    comp:ReInit(data)
    comp:PlayConfirm(data.IsSelect and playAnim)
    if data.IsSelect and self.AnimSelections[i] ~= self.CurActComp then
      if self.CurActComp ~= nil then
        self.CurActComp:Play("V_ui_S5_AllianceWarTimeSet_time_cancel")
        self.CurActComp = nil
      end
      self.CurActComp = self.AnimSelections[i]
      self.CurActComp:Play("V_ui_S5_AllianceWarTimeSet_time_select")
    end
  end
  local zeroTime = UITimeManager:GetInstance():GetTodayZero()
  local zeroTimeStr = UITimeManager:GetInstance():TimeStampToTimeForServer(zeroTime, true)
  if self.IsLocalTime then
    zeroTimeStr = UITimeManager:GetInstance():ConvertServerTimeToLocalTime(zeroTime, true)
  end
  self.p_text_zero_clock:SetText(zeroTimeStr)
  CS.UIGray.SetGray(self.p_btn_state_time_set.transform, self.CurIndex == self.ServerIndex, true)
end

function SeasonAllianceWarTimeSetView:UpdateLogs()
  self.p_text_no_log:SetActive(true)
  self.compScroll:SetActive(false)
  self.compScroll:ClearCells()
  self.compScroll:RemoveComponents(SeasonAllianceWarTimeSetLogComp)
  if self.MyAllianceWarTimeData == nil then
    return
  end
  self.Logs = self.MyAllianceWarTimeData.Logs
  local logsCount = table.count(self.Logs)
  if 0 < logsCount then
    table.sort(self.Logs, function(a, b)
      return a.t > b.t
    end)
    self.p_text_no_log:SetActive(false)
    self.compScroll:SetActive(true)
    if 0 < logsCount then
      self.compScroll:SetTotalCount(logsCount)
      self.compScroll:RefillCells()
    end
  end
end

function SeasonAllianceWarTimeSetView:OnScrollItemMoveIn(go, index)
  go.name = tostring(self.ItemIndex)
  self.ItemIndex = self.ItemIndex + 1
  if index <= table.count(self.Logs) then
    local data = {}
    data.Log = self.Logs[index]
    data.IsLocalTime = self.IsLocalTime
    local comp = self.compScroll:AddComponent(SeasonAllianceWarTimeSetLogComp, go)
    comp:ReInit(data)
  end
end

function SeasonAllianceWarTimeSetView:OnScrollItemMoveOut(go, index)
  self.compScroll:RemoveComponent(go.name, SeasonAllianceWarTimeSetLogComp)
end

function SeasonAllianceWarTimeSetView:ClearScroll()
  self.compScroll:ClearCells()
  self.compScroll:RemoveComponents(SeasonAllianceWarTimeSetLogComp)
end

function SeasonAllianceWarTimeSetView:TryClickSelection(index)
  if self.CurIndex == index then
    return
  end
  self.CurIndex = index
  self:UpdateSelections()
end

function SeasonAllianceWarTimeSetView:TryClose()
  self.ctrl:CloseSelf()
end

function SeasonAllianceWarTimeSetView:OnCloseClicked()
  self:TryClose()
end

function SeasonAllianceWarTimeSetView:OnInfoClicked()
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonAllianceWarTimeSetInfoView, {anim = true})
end

function SeasonAllianceWarTimeSetView:OnSetClicked()
  if self.MyAllianceWarTimeData == nil then
    return
  end
  if self.CurIndex < 0 then
    UIUtil.ShowTips(CS.GameEntry.Localization:GetString("s5_alliance_battle_time_ui54"))
    return
  end
  if self.ServerIndex == self.CurIndex then
    UIUtil.ShowTips(CS.GameEntry.Localization:GetString("s5_alliance_battle_time_ui55"))
    return
  end
  if not DataCenter.UILWSeasonAllianceWarTimeManager:IsSetValid(true) then
    return
  end
  local param = {}
  param.TimeIndex = self.CurIndex
  UIManager:GetInstance():OpenWindow(UIWindowNames.SeasonAllianceWarTimeSetConfirmView, {anim = true}, param)
end

function SeasonAllianceWarTimeSetView:OnStateTimeInfoClicked()
  local tips = CS.GameEntry.Localization:GetString("s5_alliance_battle_time_ui13")
  UIUtil.ShowBubbleTips(tips, self.p_btn_state_time_info.transform.position, 0, -20, -86)
end

function SeasonAllianceWarTimeSetView:OnGetInfoUpdate(evtData)
  if evtData == nil then
    return
  end
  if evtData.AllianceId == LuaEntry.Player.allianceId and self:UpdateData() then
    self:UpdateUi()
  end
end

function SeasonAllianceWarTimeSetView:OnSetTimeUpdate(evtData)
  if evtData == nil then
    return
  end
  if evtData.AllianceId == LuaEntry.Player.allianceId then
    if self:UpdateData() then
      self:UpdateUi(true)
    end
    self.content_state:Play(self.AnimConfirm)
  end
end

function SeasonAllianceWarTimeSetView:OnEscClicked()
  self:TryClose()
end

function SeasonAllianceWarTimeSetView:OnSwitchServerLocal(evtData)
  self.IsLocalTime = evtData
  self:UpdateSelections()
end

return SeasonAllianceWarTimeSetView
