local UIDispatchTaskHeroShowView = BaseClass("UIDispatchTaskHeroShowView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local HeroShowItem = require("UI.UIDispatchTask.HeroShow.Component.UIDispatchTaskHeroShowItem")
local hero_show_item_path = "Bg/node/HeroShowItem"
local node_path = "Bg/node"

function UIDispatchTaskHeroShowView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local data = self:GetUserData()
  self:ReInit(data)
end

function UIDispatchTaskHeroShowView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIDispatchTaskHeroShowView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DispatchTaskHeroShow, self.ReInit)
end

function UIDispatchTaskHeroShowView:OnRemoveListener()
  self:RemoveUIListener(EventId.DispatchTaskHeroShow, self.ReInit)
  base.OnRemoveListener(self)
end

function UIDispatchTaskHeroShowView:ComponentDefine()
  self.node = self:AddComponent(UIBaseContainer, node_path)
  self.items = {}
  for i = 1, 3 do
    local item = self:AddComponent(HeroShowItem, hero_show_item_path .. i)
    table.insert(self.items, item)
  end
end

function UIDispatchTaskHeroShowView:DataDefine()
end

function UIDispatchTaskHeroShowView:ComponentDestroy()
  self:ClearDelay()
  self.items = nil
  self.node = nil
end

function UIDispatchTaskHeroShowView:DataDestroy()
end

function UIDispatchTaskHeroShowView:ReInit(data)
  local heroList = {}
  if type(data) == "number" then
    local taskId = data
    local taskInfo = DataCenter.ActDispatchTaskDataManager:GetSingleTaskByUuid(taskId)
    if taskInfo then
      table.insertto(heroList, taskInfo.heroList)
    end
  elseif type(data) == "table" then
    for _, taskId in ipairs(data) do
      local taskInfo = DataCenter.ActDispatchTaskDataManager:GetSingleTaskByUuid(taskId)
      if taskInfo then
        local list = taskInfo.heroList
        for _, v in ipairs(list) do
          table.insert(heroList, v)
          if #heroList == 3 then
            break
          end
        end
      end
      if #heroList == 3 then
        break
      end
    end
  end
  self:RefreshShow(heroList)
  self.node:SetActive(false)
  self.node:SetActive(true)
  self:ClearDelay()
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    self.delay = nil
    self.ctrl:CloseSelf()
  end, 4)
end

function UIDispatchTaskHeroShowView:RefreshShow(heroList)
  local num = math.min(3, #heroList)
  local text1, text2, text3 = DataCenter.ActDispatchTaskDataManager:GetRandomHeroShowText()
  for i = 1, num do
    self.items[i]:SetData(heroList[i])
    if i == 1 then
      self.items[i]:SetText(text1)
    elseif i == 2 then
      self.items[i]:SetText(text2)
    elseif i == 3 then
      self.items[i]:SetText(text3)
    end
    self.items[i]:SetActive(true)
  end
  for i = num + 1, 3 do
    self.items[i]:SetActive(false)
  end
end

function UIDispatchTaskHeroShowView:ClearDelay()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

return UIDispatchTaskHeroShowView
