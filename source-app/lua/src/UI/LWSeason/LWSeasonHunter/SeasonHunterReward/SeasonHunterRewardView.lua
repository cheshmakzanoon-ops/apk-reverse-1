local base = UIBaseView
local SeasonHunterReward = BaseClass("SeasonHunterReward", base)
local SeasonHunterRewardItem = require("UI.LWSeason.LWSeasonHunter.Component.SeasonHunterRewardItem")
local SeasonHunterRewardSelfItem = require("UI.LWSeason.LWSeasonHunter.Component.SeasonHunterRewardSelfItem")
local btnClose_path = "safearea/BtnClose"
local btnBack_path = "Panel"
local txtTitle_path = "safearea/TopBar/TextTitle"
local toggle1_path = "mainObj/Tab/Toggle1"
local toggle2_path = "mainObj/Tab/Toggle2"
local scroll_path = "mainObj/MiddleBg/rankScrollView"
local scroll_reward_path = "mainObj/MiddleBg/SelfRewardPage"
local content_path = "mainObj/MiddleBg/SelfRewardPage/ScrollView/Viewport/Content"
local cur_path = "mainObj/MiddleBg/SelfRewardPage/Bot/Cur"
local curRewardValueTxt_path = "mainObj/MiddleBg/SelfRewardPage/Bot/Cur/damageTxt"
local NoneTxt_path = "mainObj/MiddleBg/SelfRewardPage/Bot/Cur/NoneTxt"
local curContent_path = "mainObj/MiddleBg/SelfRewardPage/Bot/Cur/ScrollRect/ViewPort/curContent"
local bot_path = "mainObj/MiddleBg/SelfRewardPage/Bot"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
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
  self.btnClose = self:AddComponent(UIButton, btnClose_path)
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
  self.txtTitle = self:AddComponent(UIText, txtTitle_path)
  self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
  self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
  self.scroll = self:AddComponent(UIScrollView, scroll_path)
  self.scroll_reward = self:AddComponent(UIBaseContainer, scroll_reward_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.cur = self:AddComponent(UIBaseContainer, cur_path)
  self.curRewardValueTxt = self:AddComponent(UIText, curRewardValueTxt_path)
  self.NoneTxt = self:AddComponent(UIText, NoneTxt_path)
  self.curContent = self:AddComponent(UIBaseContainer, curContent_path)
  self.bot = self:AddComponent(UIBaseContainer, bot_path)
  self.btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.btnBack:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.toggle1:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggleChange(1)
    end
  end)
  self.toggle2:SetOnValueChanged(function(isOn)
    if isOn then
      self:OnToggleChange(2)
    end
  end)
  self.scroll:SetOnItemMoveIn(function(itemObj, index)
    self:OnItemMoveIn(itemObj, index)
  end)
  self.scroll:SetOnItemMoveOut(function(itemObj, index)
    self:OnItemMoveOut(itemObj, index)
  end)
  self.toggle1:SetIsOn(true)
  self:OnToggleChange(1)
  UIUtil.GetActiveCount(DataCenter.SeasonDataManager:GetSeasonStartTime(), "HunterRewardView", true)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self:RemoveCurItems()
  self:RemoveRewards()
  self.btnClose = nil
  self.btnBack = nil
  self.txtTitle = nil
  self.toggle1 = nil
  self.toggle2 = nil
  self.scroll = nil
  self.scroll_reward = nil
  self.content = nil
  self.cur = nil
  self.curRewardValueTxt = nil
  self.NoneTxt = nil
  self.curContent = nil
  self.bot = nil
end

local function DataDefine(self)
  self.itemReqs = {}
  self.rewardReqs = {}
end

local function DataDestroy(self)
  self.curType = nil
  self.itemReqs = nil
  self.rewardReqs = nil
end

function SeasonHunterReward:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.SeasonHunterRewardInfo, self.RefreshView)
end

function SeasonHunterReward:OnRemoveListener()
  self:RemoveUIListener(EventId.SeasonHunterRewardInfo, self.RefreshView)
  base.OnRemoveListener(self)
end

function SeasonHunterReward:OnToggleChange(type)
  if self.curType == type then
    return
  end
  self.curType = type
  self:RefreshView()
end

function SeasonHunterReward:RefreshView()
  self:ClearScroll()
  self.scroll_reward:SetActive(self.curType == 2)
  self.scroll:SetActive(self.curType == 1)
  if self.curType == 2 then
    self.showDatalist = DataCenter.SeasonHunterManager:GetTimeReward()
    if #self.showDatalist > 0 then
      self:RefreshReward()
    end
  else
    local activityData = DataCenter.SeasonHunterManager:GetActivityData()
    local rankId = activityData and activityData.rankReward
    self.showDatalist = rankId and DataCenter.SeasonHunterManager:GetRankReward(rankId)
    if self.showDatalist and #self.showDatalist > 0 then
      self.scroll:SetTotalCount(#self.showDatalist)
      self.scroll:RefillCells()
    end
  end
end

function SeasonHunterReward:ClearScroll()
  self.scroll:RemoveComponents(SeasonHunterRewardItem)
  self.scroll:ClearCells()
  self.showDatalist = {}
end

function SeasonHunterReward:OnItemMoveIn(itemObj, index)
  itemObj.name = tostring(index)
  local cellItem = self.scroll:AddComponent(SeasonHunterRewardItem, itemObj)
  if self.curType == 2 then
    cellItem:SetDataTime(self.showDatalist[index])
  else
    cellItem:SetData(self.showDatalist[index])
  end
end

function SeasonHunterReward:OnItemMoveOut(itemObj, index)
  self.scroll:RemoveComponent(itemObj.name, SeasonHunterRewardItem)
end

function SeasonHunterReward:RefreshReward()
  local inBattle, liftTime = DataCenter.SeasonHunterManager:GetLiftTime()
  self.cur:SetActive(false)
  self.bot:SetActive(inBattle)
  self.NoneTxt:SetActive(false)
  if inBattle then
    self.cur:SetActive(true)
    self.curRewardValueTxt:SetText(string.GetFormattedStr2(liftTime))
    self:RemoveCurItems()
    local curRewards = DataCenter.SeasonHunterManager:GetCurRewards()
    for i = 1, #curRewards do
      self.itemReqs[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonResItem, function(req)
        if IsNull(req.gameObject) then
          return
        end
        local go = req.gameObject
        local transform = go.transform
        go:SetActive(true)
        transform:SetParent(self.curContent.transform)
        transform:Set_localScale(0.75, 0.75, 1)
        transform:Set_sizeDelta(150, 150)
        transform:Set_pivot(0, 1)
        local nameStr = "item" .. i
        go.name = nameStr
        local cell = self.curContent:AddComponent(UICommonResItem, nameStr)
        cell:ReInit(curRewards[i])
      end)
    end
  end
  self:RemoveRewards()
  for i = 1, #self.showDatalist do
    self.rewardReqs[i] = self:GameObjectInstantiateAsync("Assets/Main/SeasonRes/S4/Prefabs/UI/Hunter/Component/SeasonHunterRewardSelfItem.prefab", function(req)
      if IsNull(req.gameObject) then
        return
      end
      local go = req.gameObject
      go.gameObject:SetActive(true)
      go.transform:SetParent(self.content.transform)
      go.transform:Set_localScale(1, 1, 1)
      local nameStr = "SeasonHunterRewardSelfItem" .. i
      go.name = nameStr
      local cell = self.content:AddComponent(SeasonHunterRewardSelfItem, nameStr)
      cell:Refresh(self.showDatalist[i], liftTime)
    end)
  end
end

function SeasonHunterReward:RemoveCurItems()
  self.curContent:RemoveComponents(UICommonResItem)
  if self.itemReqs then
    for _, v in pairs(self.itemReqs) do
      v:Destroy()
    end
    self.itemReqs = {}
  end
end

function SeasonHunterReward:RemoveRewards()
  self.content:RemoveComponents(SeasonHunterRewardSelfItem)
  if self.rewardReqs then
    for _, v in pairs(self.rewardReqs) do
      v:Destroy()
    end
    self.rewardReqs = {}
  end
end

SeasonHunterReward.OnCreate = OnCreate
SeasonHunterReward.OnDestroy = OnDestroy
SeasonHunterReward.OnEnable = OnEnable
SeasonHunterReward.OnDisable = OnDisable
SeasonHunterReward.ComponentDefine = ComponentDefine
SeasonHunterReward.ComponentDestroy = ComponentDestroy
SeasonHunterReward.DataDefine = DataDefine
SeasonHunterReward.DataDestroy = DataDestroy
return SeasonHunterReward
