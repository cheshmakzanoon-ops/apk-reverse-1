local base = UIBaseView
local BankCityHistory = BaseClass("BankCityHistory", base)
local Localization = CS.GameEntry.Localization
local BankHelpHistoryItem = require("UI.LWSeason5.LWBank.Component.BankHelpHistoryItem")
local CommonSelectCom = require("UI.LWSeason.LWSeasonRank.Component.CommonSelectCom")
local lastRequestTime = 0
local panelBtn_path = "panel"
local closeBtn_path = "Root/Common_img_title/CloseBtn"
local scrollView_path = "Root/MiddleContent/ScrollView"
local content_path = "Root/MiddleContent/ScrollView/Viewport/Content"
local tipsText1_path = "Root/MiddleContent/tips1/TipsText1"
local tipsText2_path = "Root/MiddleContent/tips2/TipsText2"
local tipsText2Value_path = "Root/MiddleContent/tips2/TipsText2Value"
local iconServiceScope_path = "Root/MiddleContent/tips1/iconServiceScope"
local icon_path = "Root/MiddleContent/tips2/icon"
local iconBtn_path = "Root/MiddleContent/tips2/icon"
local noLogTxt_path = "Root/MiddleContent/noLogTxt"
local selectCom_path = "Root/MiddleContent/CommonSelectCom"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:InitView()
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
  self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.scrollView = self:AddComponent(UILoopListView2, scrollView_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.tipsText1 = self:AddComponent(UIText, tipsText1_path)
  self.tipsText2 = self:AddComponent(UIText, tipsText2_path)
  self.tipsText2Value = self:AddComponent(UIText, tipsText2Value_path)
  self.iconServiceScope = self:AddComponent(UIImage, iconServiceScope_path)
  self.icon = self:AddComponent(UIImage, icon_path)
  self.iconBtn = self:AddComponent(UIButton, iconBtn_path)
  self.noLogTxt = self:AddComponent(UIText, noLogTxt_path)
  self.selectCom = self:AddComponent(UIBaseContainer, selectCom_path)
  self.panelBtn:SetOnClick((BindCallback(self.ctrl, self.ctrl.CloseSelf)))
  self.closeBtn:SetOnClick((BindCallback(self.ctrl, self.ctrl.CloseSelf)))
  self.selectCom = self:AddComponent(CommonSelectCom, selectCom_path)
  self.scrollView:InitListView(0, function(listview, index)
    return self:TryGetScrollItem(listview, index)
  end)
  self.iconBtn:SetOnClick(function()
    DataCenter.SeasonBankManager:ShowItemTips(self.iconBtn, self.data.meta)
  end)
end

local function ComponentDestroy(self)
  self:ClearScroll()
  self.panelBtn = nil
  self.closeBtn = nil
  self.scrollView = nil
  self.content = nil
  self.tipsText1 = nil
  self.tipsText2 = nil
  self.tipsText2Value = nil
  self.iconServiceScope = nil
  self.icon = nil
  self.iconBtn = nil
  self.noLogTxt = nil
  self.selectCom = nil
end

local function DataDefine(self)
  self.items = {}
  self.listDataDic = {}
  self.listData = nil
  self.selectServerId = 0
end

local function DataDestroy(self)
end

function BankCityHistory:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.StrongholdBankLogAdd, self.BankHistoryAdd)
end

function BankCityHistory:OnRemoveListener()
  self:RemoveUIListener(EventId.StrongholdBankLogAdd, self.BankHistoryAdd)
  base.OnRemoveListener(self)
end

function BankCityHistory:ClearScroll()
  self.scrollView:ClearAllItems()
  self.content:RemoveComponents(BankHelpHistoryItem)
end

function BankCityHistory:InitView()
  self.data, self.bankDetail = self:GetUserData()
  local setting = self.bankDetail and self.bankDetail.setting
  local theData = {}
  theData.isTop = false
  theData.itemList = {}
  theData.itemList[1] = {
    type = 1,
    des = Localization:GetString("s5_bank_ui78")
  }
  theData.itemList[2] = {
    type = 2,
    des = Localization:GetString("s5_bank_ui79")
  }
  theData.itemList[3] = {
    type = 3,
    des = Localization:GetString("s5_bank_ui80")
  }
  theData.itemList[4] = {
    type = 4,
    des = Localization:GetString("season_5_bank_ui001_limit_4")
  }
  self.selectCom:Init(theData, function(d, i)
    return self:SelectTierChange(d, i)
  end)
  self.selectCom:SetIndex(3)
  self:SelectTierChange(nil, 3)
  local serviceScope, stateStr = setting and setting.serviceScope
  if serviceScope == 1 then
    stateStr = "s5_bank_ui75"
  elseif serviceScope == 2 then
    stateStr = "s5_bank_ui76"
  else
    stateStr = "s5_bank_ui74"
  end
  DataCenter.SeasonBankManager:LoadServiceScopeIcon(self.iconServiceScope, serviceScope)
  DataCenter.SeasonBankManager:LoadItemIcon(self.icon, self.data.meta)
  self.tipsText1:SetLocalText(stateStr)
  self.tipsText2:SetLocalText("s5_bank_ui77", "")
  self.tipsText2Value:SetText(setting and setting.minDepositAmount or 0)
end

function BankCityHistory:SelectTierChange(data, index)
  if self.curSelect == index then
    return true
  end
  self.curSelect = index
  self:RefreshView()
  return true
end

function BankCityHistory:RefreshView()
  self.page = -1
  self.pageEnd = false
  self.showDatalist = {}
  self.dataCount = 0
  self:ClearScroll()
  self.scrollView:SetListItemCount(self.dataCount, true, true)
  self.scrollView:RefreshAllShownItem()
  self.noLogTxt:SetActive(true)
  self:RequestNextPage()
end

local __nameCount = 0

function BankCityHistory:TryGetScrollItem(listview, index)
  index = index + 1
  local data = self.showDatalist[index]
  if not data then
    return nil
  end
  local csItem = listview:NewListViewItem("BankHelpHistoryItem")
  local theItem = self.items[csItem]
  if not theItem then
    __nameCount = __nameCount + 1
    csItem.name = string.format("%s_%d", "BankHelpHistoryItem", __nameCount)
    theItem = self.content:AddComponent(BankHelpHistoryItem, csItem.name)
    self.items[csItem] = theItem
  end
  theItem:ReInit(data, index)
  if index >= self.dataCount - 5 then
    self:RequestNextPage()
  end
  return csItem
end

function BankCityHistory:RequestNextPage()
  if not (not self.pageEnd and self.page) or Time.time - lastRequestTime < 0.5 then
    return
  end
  lastRequestTime = Time.time
  SFSNetwork.SendMessage(MsgDefines.LwRqStrongholdBankLog, self.page + 1, self.curSelect, nil, self.data.cityId, self.data.serverId)
end

function BankCityHistory:BankHistoryAdd(t)
  if not (t and t.pageId and t.pageSize) or not t.list then
    return
  end
  if t.logTypeCode and t.logTypeCode ~= self.curSelect then
    return
  end
  if t.pageId == self.page then
    return
  end
  self.page = t.pageId
  if #t.list < t.pageSize then
    self.pageEnd = true
  end
  local index = self.dataCount
  for i, v in ipairs(t.list) do
    index = index + 1
    self.showDatalist[index] = v
  end
  self.dataCount = index
  self.scrollView:SetListItemCount(self.dataCount, false, false)
  self.scrollView:RefreshAllShownItem()
  if self.dataCount > 0 then
    self.noLogTxt:SetActive(false)
  elseif self.pageEnd then
    self.noLogTxt:SetActive(true)
  end
end

BankCityHistory.OnCreate = OnCreate
BankCityHistory.OnDestroy = OnDestroy
BankCityHistory.OnEnable = OnEnable
BankCityHistory.OnDisable = OnDisable
BankCityHistory.ComponentDefine = ComponentDefine
BankCityHistory.ComponentDestroy = ComponentDestroy
BankCityHistory.DataDefine = DataDefine
BankCityHistory.DataDestroy = DataDestroy
return BankCityHistory
