local UICommonSideTipView = BaseClass("UICommonSideTipView", UIBaseView)
local base = UIBaseView
local HeroShowItem = require("UI.UICommonSideTip.Component.UICommonSideItem")
local hero_show_item_path = "Bg/node/HeroShowItem"
local node_path = "Bg/node"

function UICommonSideTipView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local data = self:GetUserData()
  self:ReInit(data)
end

function UICommonSideTipView:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UICommonSideTipView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UICommonSideTipShow, self.ReInit)
end

function UICommonSideTipView:OnRemoveListener()
  self:RemoveUIListener(EventId.UICommonSideTipShow, self.ReInit)
  base.OnRemoveListener(self)
end

function UICommonSideTipView:ComponentDefine()
  self.node = self:AddComponent(UIBaseContainer, node_path)
  self.items = {}
  for i = 1, 3 do
    local item = self:AddComponent(HeroShowItem, hero_show_item_path .. i)
    table.insert(self.items, item)
  end
end

function UICommonSideTipView:DataDefine()
end

function UICommonSideTipView:ComponentDestroy()
  self:ClearDelay()
  self.items = nil
  self.node = nil
end

function UICommonSideTipView:DataDestroy()
end

function UICommonSideTipView:ReInit(data)
  local dataList = {}
  if type(data) == "string" then
    local array = string.split(data, "|")
    for _, v in ipairs(array) do
      local v2 = string.split(v, ";")
      for _, d in ipairs(v2) do
        table.insert(dataList, d)
      end
    end
  end
  self:RefreshShow(dataList)
  self.node:SetActive(false)
  self.node:SetActive(true)
  self:ClearDelay()
  self.delay = TimerManager:GetInstance():DelayInvoke(function()
    self.delay = nil
    self.ctrl:CloseSelf()
  end, 4)
end

function UICommonSideTipView:RefreshShow(dataList)
  local count = math.floor(#dataList / 2)
  local num = math.min(3, count)
  for i = 1, num do
    self.items[i]:SetData(dataList[i * 2 - 1])
    local text = dataList[i * 2]
    self.items[i]:SetText(text)
  end
  for i = num + 1, 3 do
    self.items[i]:SetActive(false)
  end
end

function UICommonSideTipView:ClearDelay()
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

return UICommonSideTipView
