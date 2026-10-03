local panel_path = "Panel"
local p_text_title_path = "UICommonPopUpTitle/Common_bg_orange/Common_img_title/p_text_title"
local p_btn_close_path = "UICommonPopUpTitle/Common_bg_orange/p_btn_close"
local p_text_time_path = "Root/content_time/p_text_time"
local p_text_cur_stage_path = "Root/content_progress/p_text_cur_stage"
local slider_path = "Root/content_progress/content_reward/p_comp_slider/Slider"
local p_img_box_1_path = "Root/content_progress/content_reward/p_comp_slider/Slider/content_box/p_img_box_1"
local p_img_box_2_path = "Root/content_progress/content_reward/p_comp_slider/Slider/content_box/p_img_box_2"
local p_img_box_3_path = "Root/content_progress/content_reward/p_comp_slider/Slider/content_box/p_img_box_3"
local p_text_cur_score_path = "Root/content_progress/content_reward/p_comp_slider/Slider/slider_handle/p_text_cur_score"
local p_text_desc_path = "Root/p_text_desc"
local p_text_score_path = "Root/content_score/p_text_score"
local p_text_box_path = "Root/content_box/p_text_box"
local p_btn_cancel_path = "Root/p_btn_cancel"
local p_text_cancel_path = "Root/p_btn_cancel/img_cancel/p_text_cancel"
local p_btn_confirm_path = "Root/p_btn_confirm"
local p_text_confirm_path = "Root/p_btn_confirm/img_confirm/p_text_confirm"
local base = UIBaseView
local UIPersonalArmsCalendarExchangeConfirmView = BaseClass("UIPersonalArmsCalendarExchangeConfirmView", UIBaseView)

function UIPersonalArmsCalendarExchangeConfirmView:ComponentDefine()
  self.panel = self:AddComponent(UIButton, panel_path)
  self.panel:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_text_title = self:AddComponent(UITextMeshProUGUIEx, p_text_title_path)
  self.p_btn_close = self:AddComponent(UIButton, p_btn_close_path)
  self.p_btn_close:SetOnClick(BindCallback(self, self.OnCloseClicked))
  self.p_text_time = self:AddComponent(UITextMeshProUGUIEx, p_text_time_path)
  self.p_text_cur_stage = self:AddComponent(UITextMeshProUGUIEx, p_text_cur_stage_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.p_img_box_1 = self:AddComponent(UIImage, p_img_box_1_path)
  self.p_img_box_2 = self:AddComponent(UIImage, p_img_box_2_path)
  self.p_img_box_3 = self:AddComponent(UIImage, p_img_box_3_path)
  self.p_text_cur_score = self:AddComponent(UITextMeshProUGUIEx, p_text_cur_score_path)
  self.p_text_desc = self:AddComponent(UITextMeshProUGUIEx, p_text_desc_path)
  self.p_text_score = self:AddComponent(UITextMeshProUGUIEx, p_text_score_path)
  self.p_text_box = self:AddComponent(UITextMeshProUGUIEx, p_text_box_path)
  self.p_btn_cancel = self:AddComponent(UIButton, p_btn_cancel_path)
  self.p_btn_cancel:SetOnClick(BindCallback(self, self.OnCancelClicked))
  self.p_text_cancel = self:AddComponent(UITextMeshProUGUIEx, p_text_cancel_path)
  self.p_btn_confirm = self:AddComponent(UIButton, p_btn_confirm_path)
  self.p_btn_confirm:SetOnClick(BindCallback(self, self.OnConfirmClicked))
  self.p_text_confirm = self:AddComponent(UITextMeshProUGUIEx, p_text_confirm_path)
end

function UIPersonalArmsCalendarExchangeConfirmView:ComponentDestroy()
  self.panel = nil
  self.p_text_title = nil
  self.p_btn_close = nil
  self.p_text_time = nil
  self.p_text_cur_stage = nil
  self.slider = nil
  self.p_img_box_1 = nil
  self.p_img_box_2 = nil
  self.p_img_box_3 = nil
  self.p_text_cur_score = nil
  self.p_text_desc = nil
  self.p_text_score = nil
  self.p_text_box = nil
  self.p_btn_cancel = nil
  self.p_text_cancel = nil
  self.p_btn_confirm = nil
  self.p_text_confirm = nil
end

function UIPersonalArmsCalendarExchangeConfirmView:DataDefine()
end

function UIPersonalArmsCalendarExchangeConfirmView:DataDestroy()
  self.Data = nil
end

function UIPersonalArmsCalendarExchangeConfirmView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:ReInit(self:GetUserData())
end

function UIPersonalArmsCalendarExchangeConfirmView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPersonalArmsCalendarExchangeConfirmView:OnAddListener()
  base.OnAddListener(self)
end

function UIPersonalArmsCalendarExchangeConfirmView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPersonalArmsCalendarExchangeConfirmView:ReInit(data)
  if self:InitData(data) then
    self:InitUi()
    self:Update1000MS()
  else
    self.ctrl:CloseSelf()
  end
end

function UIPersonalArmsCalendarExchangeConfirmView:InitData(data)
  if data ~= nil then
    self.Data = data
    self.ShowData = DataCenter.ActivityPersonalArmsDataManager:GetCurData(checknumber(self.Data.ItemData.activityId))
    self.ToEventCell = LocalController:instance():getLine(TableName.HERO_EVENT, self.Data.ItemData.eventId)
    if self.ShowData ~= nil then
      self.EndTime = self.ShowData.stage_end_time
      return self.ToEventCell ~= nil
    end
  end
  return false
end

function UIPersonalArmsCalendarExchangeConfirmView:InitUi()
  self.p_text_title:SetLocalText("arms_race_exchange_confirm_title")
  local curCell = LocalController:instance():getLine(TableName.HERO_EVENT, self.ShowData.event_id)
  if curCell ~= nil then
    self.p_text_cur_stage:SetLocalText("arms_race_exchange_confirm_stage", CS.GameEntry.Localization:GetString(curCell.name))
  end
  self.p_text_cur_score:SetText(string.GetFormattedSeparatorNum(self.ShowData.sc))
  local percent = checknumber(self.ShowData.sc) / self.ShowData.score_reward_max
  self.slider:SetValue(percent)
  for i = 1, 3 do
    local claimed = false
    local iconPathPatten = "Assets/Main/Sprites/UI/UIPersonalArms/UIactivities_icon_box%s.png"
    if not table.IsNullOrEmpty(self.ShowData.score_rewards) then
      local rewardData = self.ShowData.score_rewards[i]
      if rewardData ~= nil then
        claimed = claimed or checknumber(rewardData.receive) == 1
      end
    end
    if claimed then
      iconPathPatten = "Assets/Main/Sprites/UI/UIPersonalArms/UIactivities_icon_box%s_1.png"
    end
    local iconPath = string.format(iconPathPatten, i)
    self["p_img_box_" .. i]:LoadSpriteAsync(iconPath)
  end
  self.p_text_desc:SetLocalText("arms_race_exchange_confirm_text", CS.GameEntry.Localization:GetString(self.ToEventCell.name))
  self.p_text_score:SetLocalText("arms_race_exchange_confirm_tips1")
  self.p_text_box:SetLocalText("arms_race_exchange_confirm_tips2")
  self.p_text_cancel:SetLocalText(GameDialogDefine.CANCEL)
  self.p_text_confirm:SetLocalText(GameDialogDefine.CONFIRM)
end

function UIPersonalArmsCalendarExchangeConfirmView:Update1000MS()
  local leftTime = math.max(0, checknumber(self.EndTime) * 1000 - UITimeManager:GetInstance():GetServerTime())
  if 0 < leftTime then
    local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
    if leftTime <= 1800000 then
      leftTimeStr = string.format("<color=#f53c3d>%s</color>", leftTimeStr)
    end
    self.p_text_time:SetText(leftTimeStr)
  else
    self.ctrl:CloseSelf()
  end
end

function UIPersonalArmsCalendarExchangeConfirmView:OnCloseClicked()
  self.ctrl:CloseSelf()
end

function UIPersonalArmsCalendarExchangeConfirmView:OnCancelClicked()
  self.ctrl:CloseSelf()
end

function UIPersonalArmsCalendarExchangeConfirmView:OnConfirmClicked()
  if self.Data == nil or self.ShowData == nil then
    return
  end
  local calendarData = DataCenter.ActivityPersonalArmsDataManager:GetCalenderData(self.Data.ItemData.activityId)
  if calendarData == nil then
    return
  end
  local curIndex = 0
  curIndex = calendarData.curStage
  local realStageOrder = self.ShowData.exchangeList
  if table.count(realStageOrder) < 6 then
    realStageOrder = {
      0,
      1,
      2,
      3,
      4,
      5
    }
  end
  local realIndex = self.ShowData.curStage - 1
  for i = 1, #realStageOrder do
    if realStageOrder[i] == self.ShowData.curStage then
      realIndex = i - 1
    end
  end
  DataCenter.ActivityPersonalArmsDataManager:SendExchange(self.Data.ItemData.activityId, realIndex, self.ShowData.curStage, self.Data.ItemData.index, self.Data.ItemData.stageNum)
  self.ctrl:CloseSelf()
end

return UIPersonalArmsCalendarExchangeConfirmView
