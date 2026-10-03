local UIWorldPointAssistanceHeadItem = BaseClass("UIWorldPointAssistanceHeadItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local player_head_path = "PlayerHead"
local empty_node_path = "EmptyNode"
local on_the_way_path = "OnTheWay"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.head = self:AddComponent(UICommonHead, player_head_path)
  self.emptyNode = self.transform:Find(empty_node_path).gameObject
  self.onTheWayNode = self.transform:Find(on_the_way_path).gameObject
end

local function ComponentDestroy(self)
  self.head = nil
  self.emptyNode = nil
  self.onTheWayNode = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function SetHead(self, uid, pic, picVer)
  self.head:SetHead(uid, pic, picVer)
end

function UIWorldPointAssistanceHeadItem:Setup(head)
  if not head then
    self.emptyNode:SetActive(true)
    self.onTheWayNode:SetActive(false)
    self.head:SetActive(false)
  else
    self.emptyNode:SetActive(false)
    self.onTheWayNode:SetActive(UITimeManager:GetInstance():GetServerTime() < (head.marchEndTime or 0))
    self.head:SetActive(true)
    self.head:SetHead(head.uid, head.pic, head.picVer, head.useBig, head.headFramePath)
    self.head:SetEnableClickShowInfo(true, true)
  end
end

UIWorldPointAssistanceHeadItem.OnCreate = OnCreate
UIWorldPointAssistanceHeadItem.OnDestroy = OnDestroy
UIWorldPointAssistanceHeadItem.OnEnable = OnEnable
UIWorldPointAssistanceHeadItem.OnDisable = OnDisable
UIWorldPointAssistanceHeadItem.ComponentDefine = ComponentDefine
UIWorldPointAssistanceHeadItem.ComponentDestroy = ComponentDestroy
UIWorldPointAssistanceHeadItem.DataDefine = DataDefine
UIWorldPointAssistanceHeadItem.DataDestroy = DataDestroy
UIWorldPointAssistanceHeadItem.SetHead = SetHead
return UIWorldPointAssistanceHeadItem
