local p_act_name_path = "Root/top/p_act_name"
local p_text_time_path = "Root/top/content_time/p_text_time"
local p_btn_help_path = "Root/top/p_btn_help"
local p_comp_select_path = "Root/mid/p_comp_select"
local p_comp_show_path = "Root/mid/p_comp_show"
local p_go_vfx_select_path = "VFX_node/p_go_vfx_select"
local p_go_vfx_show_path = "VFX_node/p_go_vfx_show"
local UILWSeasonSelectCampSelectComp = require("UI.LWSeason6.UILWSeasonSelectCamp.Comp.Select.UILWSeasonSelectCampSelectComp")
local UILWSeasonSelectCampEndShowComp = require("UI.LWSeason6.UILWSeasonSelectCamp.Comp.EndShow.UILWSeasonSelectCampEndShowComp")
local base = UIBaseContainer
local UILWSeasonSelectCampMain = BaseClass("UILWSeasonSelectCampMain", UIBaseContainer)

function UILWSeasonSelectCampMain:ComponentDefine()
  self.p_act_name = self:AddComponent(UITextMeshProUGUIEx, p_act_name_path)
  self.p_text_time = self:AddComponent(UITextMeshProUGUIEx, p_text_time_path)
  self.p_btn_help = self:AddComponent(UIButton, p_btn_help_path)
  self.p_btn_help:SetOnClick(BindCallback(self, self.OnHelpClicked))
  self.p_comp_select = self:AddComponent(UILWSeasonSelectCampSelectComp, p_comp_select_path)
  self.p_comp_end_show = self:AddComponent(UILWSeasonSelectCampEndShowComp, p_comp_show_path)
  self.p_go_vfx_select = self:AddComponent(UIBaseContainer, p_go_vfx_select_path)
  self.p_go_vfx_show = self:AddComponent(UIBaseContainer, p_go_vfx_show_path)
end

function UILWSeasonSelectCampMain:ComponentDestroy()
  self.p_act_name = nil
  self.p_text_time = nil
  self.p_btn_help = nil
  self.p_comp_select = nil
  self.p_comp_end_show = nil
  self.p_go_vfx_select = nil
  self.p_go_vfx_show = nil
end

function UILWSeasonSelectCampMain:DataDefine()
  self.CurStage = -1
  self.EndTime = -1
  self.TickAct = false
end

function UILWSeasonSelectCampMain:DataDestroy()
  self.CurStage = -1
  self.EndTime = -1
  self.TickAct = false
end

function UILWSeasonSelectCampMain:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWSeasonSelectCampMain:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWSeasonSelectCampMain:SetData(actId, actData)
  self.ActData = DataCenter.ActivityListDataManager:GetActivityDataById(actId)
  self:ReInit()
end

function UILWSeasonSelectCampMain:ReInit()
  if self:InitData() then
    self:InitUi()
    if self:UpdateData() then
      self:UpdateUi()
    end
    self:Update1000MS()
  end
end

function UILWSeasonSelectCampMain:InitData()
  return true
end

function UILWSeasonSelectCampMain:InitUi()
  if self.ActData ~= nil then
    self.p_act_name:SetLocalText(self.ActData.name)
  end
  self.p_comp_select:SetActive(false)
  self.p_comp_end_show:SetActive(true)
  self.p_go_vfx_select:SetActive(false)
  self.p_go_vfx_show:SetActive(false)
  DataCenter.SeasonSelectCampManager:SendGetInfo()
end

function UILWSeasonSelectCampMain:UpdateData()
  self.CurActStage, self.EndTime = DataCenter.SeasonSelectCampManager:GetCurActState()
  self.TickAct = true
  return true
end

function UILWSeasonSelectCampMain:UpdateUi()
  if self.CurStage == self.CurActStage then
    return
  end
  self.CurStage = self.CurActStage
  if self.CurStage == DataCenter.SeasonSelectCampManager.ActState.Select then
    self.p_act_name:SetLocalText("season_s6_activity_1200080_title01")
    self.p_comp_select:SetActive(true)
    self.p_comp_select:ReInit()
    self.p_comp_end_show:SetActive(false)
    self.p_go_vfx_select:SetActive(false)
    self.p_go_vfx_select:SetActive(true)
    self.p_go_vfx_show:SetActive(false)
  elseif self.CurStage == DataCenter.SeasonSelectCampManager.ActState.EndShow then
    self.p_act_name:SetLocalText("season_s6_activity_1200080_title02")
    self.p_comp_end_show:SetActive(true)
    self.p_comp_end_show:ReInit()
    self.p_comp_select:SetActive(false)
    self.p_go_vfx_select:SetActive(false)
    self.p_go_vfx_show:SetActive(false)
    self.p_go_vfx_show:SetActive(true)
  else
    self.p_comp_end_show:SetActive(false)
    self.p_comp_select:SetActive(false)
    self.p_go_vfx_select:SetActive(false)
    self.p_go_vfx_show:SetActive(false)
  end
end

function UILWSeasonSelectCampMain:OnHelpClicked()
  if self.ActData == nil then
    return
  end
  if table.IsNullOrEmpty(self.ActData.howtoplay) then
    if CS.CommonUtils.IsDebug() and CS.UnityEngine.Application.isEditor then
      local msg = string.format("activity \232\161\168\230\178\161\230\156\137\233\133\141\231\189\174 howtoplay\nactId = %d", self.ActData.id)
      CS.UnityEngine.GUIUtility.systemCopyBuffer = msg
      UIUtil.ShowTips(msg .. "\n\227\128\144DebugOnly\227\128\145[\229\183\178\229\164\141\229\136\182\229\136\176\229\137\170\229\136\135\230\157\191]", 3)
    end
    return
  end
  local param = {}
  param.howToPlayList = self.ActData.howtoplay
  param.story = self.ActData.story
  param.defaultTitle = self.ActData.name
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWHowToPlay, {anim = true}, param)
end

function UILWSeasonSelectCampMain:Update1000MS()
  local leftTime = math.max(0, self.EndTime - UITimeManager:GetInstance():GetServerTime())
  self.p_text_time:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
  if not self.TickAct then
    return
  end
  local curStage = DataCenter.SeasonSelectCampManager:GetCurActState()
  if self.CurStage ~= curStage then
    self.TickAct = false
    local isOpen = UIManager:GetInstance():IsWindowOpen(UIWindowNames.S6SelectCampSelectView)
    if isOpen then
      UIManager:GetInstance():CloseWindow(UIWindowNames.S6SelectCampSelectView)
    end
    DataCenter.SeasonSelectCampManager:ClearInfoData()
    DataCenter.SeasonSelectCampManager:SendGetInfo()
    if self:UpdateData() then
      self:UpdateUi()
    end
  end
end

return UILWSeasonSelectCampMain
