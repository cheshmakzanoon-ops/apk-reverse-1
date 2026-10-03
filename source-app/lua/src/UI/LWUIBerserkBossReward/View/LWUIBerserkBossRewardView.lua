local base = UIBaseView
local LWUIBerserkBossRewardView = BaseClass("LWUIBerserkBossRewardView", base)
local LWUIBerserkBossRewardItemRender = require("UI.LWUIBerserkBossReward.Component.LWUIBerserkBossRewardItemRender")
local panelBtn_path = "panel"
local titleText_path = "PopUpContent/TitleText"
local closeBtn_path = "PopUpContent/CloseBtn"
local tipsText_path = "PopUpContent/TipsText"
local rewardScrollView_path = "PopUpContent/RewardScrollView"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.activityId, self.bossUuid = self:GetUserData()
  self:ReInit()
end

local function OnDestroy(self)
  self:ClearRewardScroll()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.titleText = self:AddComponent(UIText, titleText_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.tipsText = self:AddComponent(UIText, tipsText_path)
  self.rewardScrollView = self:AddComponent(UIScrollView, rewardScrollView_path)
  self.titleText:SetLocalText("302181")
  self.tipsText:SetLocalText("activity_berserkboss_desc_06")
  self.panelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.rewardScrollView:SetOnItemMoveIn(function(itemObj, index)
    self:OnRewardItemMoveIn(itemObj, index)
  end)
  self.rewardScrollView:SetOnItemMoveOut(function(itemObj, index)
    self:OnRewardItemMoveOut(itemObj, index)
  end)
end

local function ComponentDestroy(self)
  self.panelBtn = nil
  self.titleText = nil
  self.closeBtn = nil
  self.tipsText = nil
  self.rewardScrollView = nil
end

local function DataDefine(self)
  self.curHpPercent = 0
  self.curTargetId = 0
  self.berserkBossTemplate = nil
end

local function DataDestroy(self)
  self.curHpPercent = nil
  self.curTargetId = nil
  self.berserkBossTemplate = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.GetBerserkBossAchievementRewardData, self.OnGetBerserkBossAchievementRewardData)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.GetBerserkBossAchievementRewardData, self.OnGetBerserkBossAchievementRewardData)
  base.OnRemoveListener(self)
end

local function OnGetBerserkBossAchievementRewardData(self, bossUuid)
  if self.bossUuid == bossUuid then
    self:RefreshShowReward()
  end
end

local function ReInit(self)
  DataCenter.LWBerserkBossManager:RequestBerserkBossAchievementRewardInfo(self.activityId, self.bossUuid)
  self:RefreshShowReward()
end

local function RefreshShowReward(self)
  self:ClearRewardScroll()
  local berserkBossInfo = DataCenter.LWBerserkBossManager:GetBerserkBossInfoByUuid(self.bossUuid)
  if berserkBossInfo then
    local bossId = berserkBossInfo.bossId
    local progressValue = 0
    if 0 < berserkBossInfo.maxHp then
      progressValue = berserkBossInfo.curHp / berserkBossInfo.maxHp
    end
    progressValue = Mathf.Clamp(progressValue, 0, 1)
    self.curHpPercent = (1 - progressValue) * 100
    self.berserkBossTemplate = DataCenter.LWActivityBerserkBossTemplateManager:GetTemplate(bossId)
    if self.berserkBossTemplate then
      local totalPercentDict = self.berserkBossTemplate:GetRewardAllTotalPercentInfo()
      for id, percent in pairs(totalPercentDict) do
        if percent <= self.curHpPercent then
          self.curTargetId = id
        end
      end
    end
  end
  self.rewardList = DataCenter.LWBerserkBossManager:GetBerserkBossAchievementRewardInfoByUuid(self.bossUuid)
  local count = table.count(self.rewardList)
  if 0 < count then
    self.rewardScrollView:SetTotalCount(count)
    self.rewardScrollView:RefillCells()
  end
end

local function OnRewardItemMoveIn(self, itemObj, index)
  itemObj.name = tostring(index)
  local itemRender = self.rewardScrollView:AddComponent(LWUIBerserkBossRewardItemRender, itemObj)
  if itemRender ~= nil then
    local rewardInfo = self.rewardList[index]
    local totalPercent, quality = 0, 0
    if self.berserkBossTemplate then
      totalPercent, quality = self.berserkBossTemplate:GetRewardInfoById(rewardInfo.id)
    end
    itemRender:InitData(rewardInfo, self.curTargetId, self.curHpPercent, totalPercent, quality)
  end
end

local function OnRewardItemMoveOut(self, itemObj, index)
  self.rewardScrollView:RemoveComponent(itemObj.name, LWUIBerserkBossRewardItemRender)
end

local function ClearRewardScroll(self)
  self.rewardScrollView:ClearCells()
  self.rewardScrollView:RemoveComponents(LWUIBerserkBossRewardItemRender)
end

LWUIBerserkBossRewardView.OnCreate = OnCreate
LWUIBerserkBossRewardView.OnDestroy = OnDestroy
LWUIBerserkBossRewardView.OnEnable = OnEnable
LWUIBerserkBossRewardView.OnDisable = OnDisable
LWUIBerserkBossRewardView.ComponentDefine = ComponentDefine
LWUIBerserkBossRewardView.ComponentDestroy = ComponentDestroy
LWUIBerserkBossRewardView.DataDefine = DataDefine
LWUIBerserkBossRewardView.DataDestroy = DataDestroy
LWUIBerserkBossRewardView.OnAddListener = OnAddListener
LWUIBerserkBossRewardView.OnRemoveListener = OnRemoveListener
LWUIBerserkBossRewardView.OnGetBerserkBossAchievementRewardData = OnGetBerserkBossAchievementRewardData
LWUIBerserkBossRewardView.ReInit = ReInit
LWUIBerserkBossRewardView.RefreshShowReward = RefreshShowReward
LWUIBerserkBossRewardView.OnRewardItemMoveIn = OnRewardItemMoveIn
LWUIBerserkBossRewardView.OnRewardItemMoveOut = OnRewardItemMoveOut
LWUIBerserkBossRewardView.ClearRewardScroll = ClearRewardScroll
return LWUIBerserkBossRewardView
