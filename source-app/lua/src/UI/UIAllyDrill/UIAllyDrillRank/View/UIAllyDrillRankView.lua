local UIAllyDrillRankView = BaseClass("UIAllyDrillRankView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AllyDrillRewardPage = require("UI.UIAllyDrill.UIAllyDrillReward.Component.AllyDrillRewardPage")
local AllyDrillRankPage = require("UI.UIAllyDrill.UIAllyDrillRank.Component.AllyDrillRankPage")
local TabType = {AllyRank = 1, SelfReward = 2}

function UIAllyDrillRankView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:Init()
end

function UIAllyDrillRankView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIAllyDrillRankView:ComponentDefine()
  self.returnBtn = self:AddComponent(UIButton, "UICommonPopUpTitle/panel")
  self.closeBtn = self:AddComponent(UIButton, "safeArea/CloseBtn")
  self.returnBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.pages = {}
  self.pages[1] = self:AddComponent(AllyDrillRankPage, "safeArea/AllyRankPage")
  self.pages[2] = self:AddComponent(AllyDrillRewardPage, "safeArea/SelfRewardPage")
  self.toggle = {}
  local tabCount = table.count(TabType)
  for i = 1, tabCount do
    self.toggle[i] = self:AddComponent(UIToggle, "safeArea/tabSv/Viewport/Content/Toggle" .. i)
    self.toggle[i]:SetOnValueChanged(function(t)
      if t then
        self:ShowPage(i)
      end
    end)
  end
end

function UIAllyDrillRankView:ComponentDestroy()
  self.pages = nil
  self.toggle = nil
end

function UIAllyDrillRankView:DataDefine()
  self.curTabType = TabType.AllyRank
  self.lastRefreshTime = 0
end

function UIAllyDrillRankView:DataDestroy()
  self.curTabType = nil
end

function UIAllyDrillRankView:OnEnable()
  base.OnEnable(self)
end

function UIAllyDrillRankView:OnDisable()
  base.OnDisable(self)
end

function UIAllyDrillRankView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnAllyDrillRankRefresh, self.Refresh)
  self:AddUIListener(EventId.OnAllyDrillInfoRefresh, self.Refresh)
end

function UIAllyDrillRankView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnAllyDrillRankRefresh, self.Refresh)
  self:RemoveUIListener(EventId.OnAllyDrillInfoRefresh, self.Refresh)
end

function UIAllyDrillRankView:Init()
  self.stage = DataCenter.AllyDrillDataManager:GetCurStageAndCountDown()
  self:Update1000MS()
  self.toggle[TabType.AllyRank]:SetIsOn(true)
  self:ShowPage(TabType.AllyRank)
end

function UIAllyDrillRankView:Update1000MS()
  local now = UITimeManager:GetInstance():GetServerSeconds()
  if now > self.lastRefreshTime + 60 then
    self.lastRefreshTime = now
    self.stage = DataCenter.AllyDrillDataManager:GetCurStageAndCountDown()
    DataCenter.AllyDrillDataManager:SendMsgAllianceBossTopList()
  end
end

function UIAllyDrillRankView:Refresh()
  self:ShowPage(self.curTabType)
end

function UIAllyDrillRankView:ShowPage(tabType)
  if tabType == TabType.AllyRank then
    self.curTabType = TabType.AllyRank
    self.pages[TabType.SelfReward]:SetActive(false)
    self.pages[TabType.AllyRank]:SetActive(true)
    self.pages[TabType.AllyRank]:Refresh()
  elseif tabType == TabType.SelfReward then
    self.curTabType = TabType.SelfReward
    self.pages[TabType.AllyRank]:SetActive(false)
    self.pages[TabType.SelfReward]:SetActive(true)
    self.pages[TabType.SelfReward]:Refresh(true)
  end
end

return UIAllyDrillRankView
