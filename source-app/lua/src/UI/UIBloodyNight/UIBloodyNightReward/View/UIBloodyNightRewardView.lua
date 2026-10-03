local UIBloodyNightRewardView = BaseClass("UIBloodyNightRewardView", UIBaseView)
local base = UIBaseView
local BloodyNightTaskPage = require("UI.UIBloodyNight.UIBloodyNightReward.Component.BloodyNightTaskPage")
local check_text1_path = "safeArea/tabSv/Viewport/Content/Toggle1/CheckText1"
local check_text2_path = "safeArea/tabSv/Viewport/Content/Toggle2/CheckText2"
local red_point1_path = "safeArea/tabSv/Viewport/Content/Toggle1/RedPoint1"
local red_point2_path = "safeArea/tabSv/Viewport/Content/Toggle2/RedPoint2"

function UIBloodyNightRewardView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UIBloodyNightRewardView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIBloodyNightRewardView:ComponentDefine()
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
  self.pages[BloodyNightTaskType.DailyTask] = self:AddComponent(BloodyNightTaskPage, "safeArea/DailyTaskPage")
  self.pages[BloodyNightTaskType.DailyTask]:Init(BloodyNightTaskType.DailyTask)
  self.pages[BloodyNightTaskType.Achievement] = self:AddComponent(BloodyNightTaskPage, "safeArea/AchievementPage")
  self.pages[BloodyNightTaskType.Achievement]:Init(BloodyNightTaskType.Achievement)
  self.toggle = {}
  local tabCount = table.count(BloodyNightTaskType)
  for i = 1, tabCount do
    self.toggle[i] = self:AddComponent(UIToggle, "safeArea/tabSv/Viewport/Content/Toggle" .. i)
  end
  self.toggle[BloodyNightTaskType.DailyTask]:SetIsOn(true)
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

function UIBloodyNightRewardView:ComponentDestroy()
  self.pages = nil
  self.toggle = nil
  self.red_point1 = nil
  self.red_point2 = nil
end

function UIBloodyNightRewardView:DataDefine()
  self.curTabType = BloodyNightTaskType.DailyTask
end

function UIBloodyNightRewardView:DataDestroy()
  self.curTabType = nil
end

function UIBloodyNightRewardView:OnEnable()
  base.OnEnable(self)
end

function UIBloodyNightRewardView:OnDisable()
  base.OnDisable(self)
end

function UIBloodyNightRewardView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnBloodyNightTaskRedRefresh, self.RefreshAwardRedPoint)
end

function UIBloodyNightRewardView:OnRemoveListener()
  self:RemoveUIListener(EventId.OnBloodyNightTaskRedRefresh, self.RefreshAwardRedPoint)
  base.OnRemoveListener(self)
end

function UIBloodyNightRewardView:Init()
  DataCenter.BloodyNightDataManager:FetchTaskList()
  self:ShowPage(BloodyNightTaskType.DailyTask)
  self:RefreshAwardRedPoint()
end

function UIBloodyNightRewardView:RefreshAwardRedPoint()
  self.red_point1:SetActive(DataCenter.BloodyNightDataManager:GetCanReceive(BloodyNightTaskType.DailyTask))
  self.red_point2:SetActive(DataCenter.BloodyNightDataManager:GetCanReceive(BloodyNightTaskType.Achievement))
end

function UIBloodyNightRewardView:ShowPage(tabType)
  if tabType == BloodyNightTaskType.DailyTask then
    self.curTabType = BloodyNightTaskType.DailyTask
    self.pages[BloodyNightTaskType.Achievement]:SetActive(false)
    self.pages[BloodyNightTaskType.DailyTask]:SetActive(true)
    self.pages[BloodyNightTaskType.DailyTask]:Refresh()
  elseif tabType == BloodyNightTaskType.Achievement then
    self.curTabType = BloodyNightTaskType.Achievement
    self.pages[BloodyNightTaskType.DailyTask]:SetActive(false)
    self.pages[BloodyNightTaskType.Achievement]:SetActive(true)
    self.pages[BloodyNightTaskType.Achievement]:Refresh()
  end
end

return UIBloodyNightRewardView
