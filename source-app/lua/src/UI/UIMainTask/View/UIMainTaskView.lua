local UITaskDayView = require("UI.UIMainTask.Component.UITaskDayView")
local UITaskMain = require("UI.UIMainTask.Component.UITaskMain")
local UIMainTaskView = BaseClass("UIMainTaskView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIMainTaskView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIMainTaskView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIMainTaskView:ComponentDefine()
  self.txt_title = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.close_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.day_task = self:AddComponent(UITaskDayView, "MainPanel/DayTaskGo")
  self.main_task = self:AddComponent(UITaskMain, "MainPanel/MainTaskGo")
  self.return_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.close_btn:SetOnClick(function()
    self.ctrl:Close()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function UIMainTaskView:ComponentDestroy()
  self.txt_title = nil
  self.close_btn = nil
  self.back_btn = nil
  self.day_task = nil
  self.return_btn = nil
end

function UIMainTaskView:OnEnable()
  base.OnEnable(self)
  self:ToggleControlBorS(1)
end

function UIMainTaskView:OnDisable()
  base.OnDisable(self)
end

function UIMainTaskView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnTaskForceRefreshFinish, self.DoQuestShowAnimation)
end

function UIMainTaskView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnTaskForceRefreshFinish, self.DoQuestShowAnimation)
end

function UIMainTaskView:RefreshTitleName(dialog)
  self.txt_title:SetLocalText(dialog)
end

function UIMainTaskView:ToggleControlBorS(index)
  DataCenter.TaskManager:SetCurTaskViewIndex(index)
  self:OnRefresh(index)
end

function UIMainTaskView:OnRefresh(index)
  if index == 1 then
    self.main_task:SetActive(true)
    self.main_task:ReInit()
    self:RefreshTitleName(100179)
  end
end

function UIMainTaskView:IsTween()
  return self.day_task:IsTween()
end

function UIMainTaskView:IsNodeTween()
  return self.main_task:IsTween()
end

function UIMainTaskView:DoQuestShowAnimation()
  if self.curIndex == 1 then
    self.main_task:DoQuestShowAnimation()
  elseif self.curIndex == 2 then
    self.day_task:DoQuestShowAnimation()
  end
end

return UIMainTaskView
