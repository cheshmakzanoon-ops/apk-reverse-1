local UIJungleTrialTaskView = BaseClass("UIJungleTrialTaskView", UIBaseView)
local base = UIBaseView
local JungleTrialTaskPage = require("UI.UIJungleTrial.UIJungleTrialTask.JungleTrialTaskPage")

function UIJungleTrialTaskView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UIJungleTrialTaskView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIJungleTrialTaskView:ComponentDefine()
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "safeArea/titleText")
  self.titleText:SetLocalText("100179")
  self.returnBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.closeBtn = self:AddComponent(UIButton, "safeArea/CloseBtn")
  self.returnBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.page = self:AddComponent(JungleTrialTaskPage, "safeArea/DailyTaskPage")
end

function UIJungleTrialTaskView:ComponentDestroy()
  self.page = nil
end

function UIJungleTrialTaskView:DataDefine()
end

function UIJungleTrialTaskView:DataDestroy()
end

function UIJungleTrialTaskView:Init()
  DataCenter.JungleTrialDataManager:FetchTaskData()
  self.page:SetActive(true)
  self.page:Refresh()
end

return UIJungleTrialTaskView
