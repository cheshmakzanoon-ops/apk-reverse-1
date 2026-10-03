local base = UIBaseView
local BuyDiamondPackTipsView = BaseClass("BuyDiamondPackTipsView", base)
local BuyDiamondPackTipsItem = require("UI.LWGift.BuyDiamondPackTips.Component.BuyDiamondPackTipsItem")
local btnBlack_path = "black"
local tmpTitle_path = "mailBg/title"
local mainScroller_path = "mailBg/ScrollView"
local btnConfirm_path = "mailBg/ConfirmBtn"
local tmpConfirm_path = "mailBg/ConfirmBtn/tmpConfirm"
local mainLoop_path = "mailBg/ScrollView"
local mainContent_path = "mailBg/ScrollView/Content"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
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
  self.btnBlack = self:AddComponent(UIButton, btnBlack_path)
  self.tmpTitle = self:AddComponent(UIText, tmpTitle_path)
  self.mainScroller = self:AddComponent(UIScrollRect, mainScroller_path)
  self.btnConfirm = self:AddComponent(UIButton, btnConfirm_path)
  self.tmpConfirm = self:AddComponent(UIText, tmpConfirm_path)
  self.mainLoop = self:AddComponent(UILoopListView2, mainLoop_path)
  self.mainContent = self:AddComponent(UIBaseContainer, mainContent_path)
  self.btnConfirm:SetOnClick(Bind(self.ctrl, self.ctrl.CloseSelf))
  self.btnBlack:SetOnClick(Bind(self, self.OnClickedBlack))
  self.tmpConfirm:SetLocalText("110006")
  self.mainLoop:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
end

local function ComponentDestroy(self)
  self.mainContent:RemoveComponents(BuyDiamondPackTipsItem)
  self.mainLoop:ClearAllItems()
  self.items = nil
  self.btnBlack = nil
  self.tmpTitle = nil
  self.mainScroller = nil
  self.btnConfirm = nil
  self.tmpConfirm = nil
  self.mainLoop = nil
  self.mainContent = nil
end

local function DataDefine(self)
  self.items = {}
  self.showTipsCfgData = self:GetUserData() or {}
  self.logs = {}
  if self.showTipsCfgData then
    local logData = {}
    logData.dateString = self.showTipsCfgData:GetTipsTitle()
    logData.update_description = self.showTipsCfgData:GetTipsContent()
    table.insert(self.logs, logData)
  end
end

function BuyDiamondPackTipsView:RefreshView()
  local panelTitleStr = self.showTipsCfgData and self.showTipsCfgData.title or "update_history_1"
  self.tmpTitle:SetLocalText(panelTitleStr)
  self.mainLoop:SetListItemCount(#self.logs, false, false)
  self.mainLoop:RefreshAllShownItem()
end

local function DataDestroy(self)
end

function BuyDiamondPackTipsView:TryGetScrollItem(listview, index)
  local dataList = self.logs
  if dataList == nil or #dataList <= 0 then
    return nil
  end
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local csItem
  local data = dataList[index]
  local theScript
  csItem = listview:NewListViewItem("BuyDiamondPackTipsItem")
  theScript = BuyDiamondPackTipsItem
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = "Cell" .. NameCount
    csItem.gameObject.name = nameStr
    self.items[csItem] = self.mainContent:AddComponent(theScript, nameStr)
  end
  if self.items[csItem] ~= nil then
    self.items[csItem]:ReInit(self.mainLoop, index, data)
  end
  return csItem
end

function BuyDiamondPackTipsView:OnClickedBlack()
  self.ctrl:CloseSelf()
end

BuyDiamondPackTipsView.OnCreate = OnCreate
BuyDiamondPackTipsView.OnDestroy = OnDestroy
BuyDiamondPackTipsView.OnEnable = OnEnable
BuyDiamondPackTipsView.OnDisable = OnDisable
BuyDiamondPackTipsView.ComponentDefine = ComponentDefine
BuyDiamondPackTipsView.ComponentDestroy = ComponentDestroy
BuyDiamondPackTipsView.DataDefine = DataDefine
BuyDiamondPackTipsView.DataDestroy = DataDestroy
return BuyDiamondPackTipsView
