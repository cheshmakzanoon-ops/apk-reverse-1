local base = UIBaseView
local UIFireworkGiftGotShowView = BaseClass("UIFireworkGiftGotShowView", base)
local UIFireworkGiftGotShowItemRender = require("UI.Firework.UIFireworkGiftGotShow.Component.UIFireworkGiftGotShowItemRender")
local node_path = "Node"
local showItems_path = {
  "Node/Item1",
  "Node/Item2",
  "Node/Item3"
}

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local data = self:GetUserData()
  self:ReInit(data)
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
  self.node = self:AddComponent(UIBaseContainer, node_path)
  self.showItems = {
    self:AddComponent(UIFireworkGiftGotShowItemRender, showItems_path[1]),
    self:AddComponent(UIFireworkGiftGotShowItemRender, showItems_path[2]),
    self:AddComponent(UIFireworkGiftGotShowItemRender, showItems_path[3])
  }
end

local function ComponentDestroy(self)
  self.node = nil
  self.showItems = nil
end

local function DataDefine(self)
  self.playerList = {}
  self.uuid2BeginTime = {}
end

local function DataDestroy(self)
  self.playerList = nil
  self.uuid2BeginTime = nil
end

function UIFireworkGiftGotShowView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.FireworkGiftGotUpdate, self.ReInit)
end

function UIFireworkGiftGotShowView:OnRemoveListener()
  self:RemoveUIListener(EventId.FireworkGiftGotUpdate, self.ReInit)
  base.OnRemoveListener(self)
end

function UIFireworkGiftGotShowView:ReInit(data)
  local curTime = UITimeManager:GetInstance():GetServerTime()
  if #self.playerList < 3 then
    table.insert(self.playerList, data)
    self.uuid2BeginTime[data.uuid] = curTime
  else
    local oldestBeginTime = curTime
    local oldestIndex = 1
    for i = #self.playerList, 1, -1 do
      if oldestBeginTime > self.uuid2BeginTime[self.playerList[i].uuid] then
        oldestBeginTime = self.uuid2BeginTime[self.playerList[i].uuid]
        oldestIndex = i
      end
    end
    if curTime > oldestBeginTime then
      self.playerList[oldestIndex] = data
      self.uuid2BeginTime[data.uuid] = curTime
    end
  end
  self:RefreshShow()
  self:ClearDelay()
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    if self.ctrl then
      self.delay = nil
      self.ctrl:CloseSelf()
    end
  end, 3)
end

function UIFireworkGiftGotShowView:RefreshShow()
  local num = #self.playerList
  for i = 1, num do
    self.showItems[i]:SetData(self.playerList[i])
  end
  for i = 1, 3 do
    self.showItems[i]:SetActive(i <= num)
  end
end

function UIFireworkGiftGotShowView:ClearDelay()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

UIFireworkGiftGotShowView.OnCreate = OnCreate
UIFireworkGiftGotShowView.OnDestroy = OnDestroy
UIFireworkGiftGotShowView.OnEnable = OnEnable
UIFireworkGiftGotShowView.OnDisable = OnDisable
UIFireworkGiftGotShowView.ComponentDefine = ComponentDefine
UIFireworkGiftGotShowView.ComponentDestroy = ComponentDestroy
UIFireworkGiftGotShowView.DataDefine = DataDefine
UIFireworkGiftGotShowView.DataDestroy = DataDestroy
return UIFireworkGiftGotShowView
