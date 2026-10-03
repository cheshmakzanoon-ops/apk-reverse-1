local UICounterAttackRewardView = BaseClass("UICounterAttackRewardView", UIBaseView)
local base = UIBaseView
local CounterAttackRewardPage = require("UI.UICounterAttack.UICounterAttackReward.Component.CounterAttackRewardPage")
local CounterAttackTaskPage = require("UI.UICounterAttack.UICounterAttackReward.Component.CounterAttackTaskPage")
local check_text1_path = "safeArea/tabSv/Viewport/Content/Toggle1/CheckText1"
local check_text2_path = "safeArea/tabSv/Viewport/Content/Toggle2/CheckText2"
local TabType = {Task = 1, Reward = 2}

function UICounterAttackRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UICounterAttackRewardView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UICounterAttackRewardView:ComponentDefine()
  self.titleText = self:AddComponent(UITextMeshProUGUIEx, "safeArea/titleText")
  self.titleText:SetLocalText("2010321")
  self.returnBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.closeBtn = self:AddComponent(UIButton, "safeArea/CloseBtn")
  self.returnBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.pages = {}
  self.pages[TabType.Task] = self:AddComponent(CounterAttackTaskPage, "safeArea/TaskPage")
  self.pages[TabType.Reward] = self:AddComponent(CounterAttackRewardPage, "safeArea/RewardPage")
  self.pages[TabType.Reward]:Refresh()
  self.toggle = {}
  local tabCount = table.count(TabType)
  for i = 1, tabCount do
    self.toggle[i] = self:AddComponent(UIToggle, "safeArea/tabSv/Viewport/Content/Toggle" .. i)
  end
  self.toggle[TabType.Task]:SetIsOn(true)
  for i = 1, tabCount do
    self.toggle[i]:SetOnValueChanged(function(t)
      if t then
        self:ShowPage(i)
      end
    end)
  end
  local check_text1 = self:AddComponent(UITextMeshProUGUIEx, check_text1_path)
  check_text1:SetLocalText("2010310")
  local check_text2 = self:AddComponent(UITextMeshProUGUIEx, check_text2_path)
  check_text2:SetLocalText("2010311")
end

function UICounterAttackRewardView:ComponentDestroy()
  self.pages = nil
  self.toggle = nil
end

function UICounterAttackRewardView:DataDefine()
  self.curTabType = TabType.Task
end

function UICounterAttackRewardView:DataDestroy()
  self.curTabType = nil
end

function UICounterAttackRewardView:OnEnable()
  base.OnEnable(self)
end

function UICounterAttackRewardView:OnDisable()
  base.OnDisable(self)
end

function UICounterAttackRewardView:OnAddListener()
  base.OnAddListener(self)
end

function UICounterAttackRewardView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UICounterAttackRewardView:Init()
  DataCenter.CounterAttackDataManager:SendMsgLookRoundAward()
  self:ShowPage(TabType.Task)
end

function UICounterAttackRewardView:ShowPage(tabType)
  if tabType == TabType.Task then
    self.curTabType = TabType.Task
    self.pages[TabType.Reward]:SetActive(false)
    self.pages[TabType.Task]:SetActive(true)
    self.pages[TabType.Task]:Refresh()
  elseif tabType == TabType.Reward then
    self.curTabType = TabType.Reward
    self.pages[TabType.Task]:SetActive(false)
    self.pages[TabType.Reward]:SetActive(true)
  end
end

return UICounterAttackRewardView
