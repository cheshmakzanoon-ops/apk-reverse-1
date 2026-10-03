local UISandWormRewardView = BaseClass("UISandWormRewardView", UIBaseView)
local base = UIBaseView
local SandWormTaskPage = require("UI.UISandWormHunt.UISandWormReward.Component.SandWormTaskPage")
local check_text1_path = "safeArea/tabSv/Viewport/Content/Toggle1/CheckText1"
local check_text2_path = "safeArea/tabSv/Viewport/Content/Toggle2/CheckText2"
local red_point1_path = "safeArea/tabSv/Viewport/Content/Toggle1/RedPoint1"
local red_point2_path = "safeArea/tabSv/Viewport/Content/Toggle2/RedPoint2"

function UISandWormRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UISandWormRewardView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UISandWormRewardView:ComponentDefine()
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
  self.pages[SandWormTaskType.DailyTask] = self:AddComponent(SandWormTaskPage, "safeArea/DailyTaskPage")
  self.pages[SandWormTaskType.DailyTask]:Init(SandWormTaskType.DailyTask)
  self.pages[SandWormTaskType.Achievement] = self:AddComponent(SandWormTaskPage, "safeArea/AchievementPage")
  self.pages[SandWormTaskType.Achievement]:Init(SandWormTaskType.Achievement)
  self.toggle = {}
  local tabCount = table.count(SandWormTaskType)
  for i = 1, tabCount do
    self.toggle[i] = self:AddComponent(UIToggle, "safeArea/tabSv/Viewport/Content/Toggle" .. i)
  end
  self.toggle[SandWormTaskType.DailyTask]:SetIsOn(true)
  for i = 1, tabCount do
    self.toggle[i]:SetOnValueChanged(function(t)
      if t then
        self:ShowPage(i)
      end
    end)
  end
  local check_text1 = self:AddComponent(UITextMeshProUGUIEx, check_text1_path)
  check_text1:SetLocalText("season_activity_1000069_desc17")
  local check_text2 = self:AddComponent(UITextMeshProUGUIEx, check_text2_path)
  check_text2:SetLocalText("season_activity_1000069_desc18")
  self.red_point1 = self:AddComponent(UIImage, red_point1_path)
  self.red_point2 = self:AddComponent(UIImage, red_point2_path)
end

function UISandWormRewardView:ComponentDestroy()
  self.pages = nil
  self.toggle = nil
  self.red_point1 = nil
  self.red_point2 = nil
end

function UISandWormRewardView:DataDefine()
  self.curTabType = SandWormTaskType.DailyTask
end

function UISandWormRewardView:DataDestroy()
  self.curTabType = nil
end

function UISandWormRewardView:OnEnable()
  base.OnEnable(self)
end

function UISandWormRewardView:OnDisable()
  base.OnDisable(self)
end

function UISandWormRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnSandWormHuntRewardRefresh, self.RefreshAwardRedPoint)
end

function UISandWormRewardView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnSandWormHuntRewardRefresh, self.RefreshAwardRedPoint)
  base.OnRemoveListener(self)
end

function UISandWormRewardView:Init()
  DataCenter.SandWormHuntDataManager:FetchTaskData()
  self:ShowPage(SandWormTaskType.DailyTask)
  self:RefreshAwardRedPoint()
end

function UISandWormRewardView:RefreshAwardRedPoint()
  self.red_point1:SetActive(DataCenter.SandWormHuntDataManager:GetCanReceive(SandWormTaskType.DailyTask))
  self.red_point2:SetActive(DataCenter.SandWormHuntDataManager:GetCanReceive(SandWormTaskType.Achievement))
end

function UISandWormRewardView:ShowPage(tabType)
  if tabType == SandWormTaskType.DailyTask then
    self.curTabType = SandWormTaskType.DailyTask
    self.pages[SandWormTaskType.Achievement]:SetActive(false)
    self.pages[SandWormTaskType.DailyTask]:SetActive(true)
    self.pages[SandWormTaskType.DailyTask]:Refresh()
  elseif tabType == SandWormTaskType.Achievement then
    self.curTabType = SandWormTaskType.Achievement
    self.pages[SandWormTaskType.DailyTask]:SetActive(false)
    self.pages[SandWormTaskType.Achievement]:SetActive(true)
    self.pages[SandWormTaskType.Achievement]:Refresh()
  end
end

return UISandWormRewardView
