local UITaskDayView = require("UI.UIAlliance.UIAllianceEveryDayTask.Component.UITaskDayView")
local UIAllianceEveryDayTaskView = BaseClass("UIAllianceEveryDayTaskView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function UIAllianceEveryDayTaskView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:ReInit()
  self:SetPanelActive()
end

function UIAllianceEveryDayTaskView:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIAllianceEveryDayTaskView:ComponentDefine()
  self.txt_title = self:AddComponent(UIText, "UICommonPopUpTitle/Common_img_title/titleText")
  self.close_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/CloseBtn")
  self.back_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/BtnBack")
  self.day_task = self:AddComponent(UITaskDayView, "MainPanel/DayTaskGo")
  self.return_btn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.back_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.close_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.return_btn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
end

function UIAllianceEveryDayTaskView:ComponentDestroy()
  self.txt_title = nil
  self.close_btn = nil
  self.back_btn = nil
  self.day_task = nil
  self.return_btn = nil
end

function UIAllianceEveryDayTaskView:OnEnable()
  base.OnEnable(self)
end

function UIAllianceEveryDayTaskView:OnDisable()
  base.OnDisable(self)
end

function UIAllianceEveryDayTaskView:ReInit()
  SFSNetwork.SendMessage(MsgDefines.DailyQuestLs)
  self:RefreshTitleName()
end

function UIAllianceEveryDayTaskView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DailyQuestSuccess, self.DailyTaskSignal)
  self:AddUIListener(EventId.DailyQuestReward, self.RefreshBoxState)
  self:AddUIListener(EventId.OnTaskForceRefreshFinish, self.DoQuestShowAnimation)
end

function UIAllianceEveryDayTaskView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.DailyQuestSuccess, self.DailyTaskSignal)
  self:RemoveUIListener(EventId.DailyQuestReward, self.RefreshBoxState)
  self:RemoveUIListener(EventId.OnTaskForceRefreshFinish, self.DoQuestShowAnimation)
end

function UIAllianceEveryDayTaskView:SetPanelActive()
end

function UIAllianceEveryDayTaskView:RefreshBoxState()
  self.day_task:RefreshBoxState()
end

function UIAllianceEveryDayTaskView:RefreshTitleName()
  self.txt_title:SetLocalText(170015)
end

function UIAllianceEveryDayTaskView:DailyTaskSignal()
  self.day_task:RefreshPanel()
  self.day_task:ForceUpdate()
end

function UIAllianceEveryDayTaskView:IsTween()
  return self.day_task:IsTween()
end

function UIAllianceEveryDayTaskView:DoQuestShowAnimation()
  self.day_task:DoQuestShowAnimation()
end

return UIAllianceEveryDayTaskView
