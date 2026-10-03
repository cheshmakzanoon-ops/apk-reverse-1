local p_comp_camp_left_path = "p_comp_camp_left"
local p_comp_camp_right_path = "p_comp_camp_right"
local p_text_select_desc_path = "p_text_select_desc"
local p_text_select_time_path = "p_text_select_time"
local p_btn_ppt_path = "btns/p_btn_ppt"
local p_btn_select_path = "btns/p_btn_select"
local UILWSeasonSelectCampCampComp = require("UI.LWSeason6.UILWSeasonSelectCamp.Comp.Select.UILWSeasonSelectCampCampComp")
local base = UIBaseContainer
local UILWSeasonSelectCampSelectComp = BaseClass("UILWSeasonSelectCampSelectComp", UIBaseContainer)

function UILWSeasonSelectCampSelectComp:ComponentDefine()
  self.p_comp_camp_left = self:AddComponent(UILWSeasonSelectCampCampComp, p_comp_camp_left_path)
  self.p_comp_camp_right = self:AddComponent(UILWSeasonSelectCampCampComp, p_comp_camp_right_path)
  self.p_text_select_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_select_desc_path)
  self.p_text_select_time = self:AddComponent(UITextMeshProUGUIEx, p_text_select_time_path)
  self.p_btn_ppt = self:AddComponent(UIButton, p_btn_ppt_path)
  self.p_btn_ppt:SetOnClick(BindCallback(self, self.OnPptClicked))
  self.p_btn_select = self:AddComponent(UIButton, p_btn_select_path)
  self.p_btn_select:SetOnClick(BindCallback(self, self.OnSelectClicked))
end

function UILWSeasonSelectCampSelectComp:ComponentDestroy()
  self.p_comp_camp_left = nil
  self.p_comp_camp_right = nil
  self.p_text_select_desc = nil
  self.p_text_select_time = nil
  self.p_btn_ppt = nil
  self.p_btn_select = nil
end

function UILWSeasonSelectCampSelectComp:DataDefine()
  self.CurStage = -1
  self.EndTime = -1
  self.TickAct = false
end

function UILWSeasonSelectCampSelectComp:DataDestroy()
  self.CurStage = -1
  self.EndTime = -1
  self.TickAct = false
end

function UILWSeasonSelectCampSelectComp:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonSelectCampSelectComp:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonSelectCampSelectComp:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonSelectCampInfoUpdate, self.OnGetInfoEvt)
end

function UILWSeasonSelectCampSelectComp:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonSelectCampInfoUpdate, self.OnGetInfoEvt)
  base.OnRemoveListener(self)
end

function UILWSeasonSelectCampSelectComp:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
    self:Update1000MS()
  end
end

function UILWSeasonSelectCampSelectComp:InitData(data)
  self.CurStage, self.EndTime = DataCenter.SeasonSelectCampManager:GetCurActState()
  if self.CurStage == DataCenter.SeasonSelectCampManager.ActState.Select then
    self.TickAct = true
    return true
  end
  return false
end

function UILWSeasonSelectCampSelectComp:InitUi()
  local actData = DataCenter.SeasonSelectCampManager:GetActData()
  self.p_btn_ppt:SetActive(actData ~= nil and checknumber(actData.para) > 0)
  self.p_btn_select:SetActive(false)
end

function UILWSeasonSelectCampSelectComp:UpdateData()
  self.Info = DataCenter.SeasonSelectCampManager.InfoData
  return self.Info ~= nil
end

function UILWSeasonSelectCampSelectComp:UpdateUi()
  self.p_text_select_desc:SetText(self:GetDesc())
  self.p_btn_select:SetActive(self.Info:ImLeaderServerKing())
  local leftData = {}
  leftData.CampData = self.Info.LeftCamp
  self.p_comp_camp_left:ReInit(leftData)
  local rightData = {}
  rightData.CampData = self.Info.RightCamp
  self.p_comp_camp_right:ReInit(rightData)
end

function UILWSeasonSelectCampSelectComp:GetDesc()
  if self.Info:ImLeaderServerKing() then
    return CS.GameEntry.Localization:GetString("season_s6_activity_1200080_desc16")
  else
    return CS.GameEntry.Localization:GetString("season_s6_activity_1200080_desc17")
  end
end

function UILWSeasonSelectCampSelectComp:OnGetInfoEvt(evt)
  if self:UpdateData() then
    self:UpdateUi()
  end
end

function UILWSeasonSelectCampSelectComp:OnPptClicked()
  local actData = DataCenter.SeasonSelectCampManager:GetActData()
  if actData ~= nil and checknumber(actData.para) > 0 then
    local data = DataCenter.LWWorldTipManager:GetDataBySeason(checknumber(actData.para))
    if data ~= nil and 0 < table.count(data) then
      local param = {}
      param.dataTabGroup = data
      UIManager:GetInstance():OpenWindow(UIWindowNames.S6SelectCampIntroView, {anim = false}, param)
    end
  end
end

function UILWSeasonSelectCampSelectComp:OnSelectClicked()
  if not DataCenter.SeasonSelectCampManager:IsSelectState() then
    return
  end
  if self.Info ~= nil then
    local param = {}
    param.Title = CS.GameEntry.Localization:GetString("season_s6_activity_1200080_btn_02")
    param.ViewMode = false
    UIManager:GetInstance():OpenWindow(UIWindowNames.S6SelectCampSelectView, {anim = true}, param)
  end
end

function UILWSeasonSelectCampSelectComp:Update1000MS()
  if not self.TickAct then
    return
  end
  local leftTime = math.max(0, self.EndTime - UITimeManager:GetInstance():GetServerTime())
  local timeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
  self.p_text_select_time:SetLocalText("season_s6_activity_1200080_desc01", timeStr)
end

return UILWSeasonSelectCampSelectComp
