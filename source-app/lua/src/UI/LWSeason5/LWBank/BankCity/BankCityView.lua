local base = UIBaseView
local BankCityView = BaseClass("BankCityView", base)
local Localization = CS.GameEntry.Localization
local CommonSelectCom = require("UI.LWSeason.LWSeasonRank.Component.CommonSelectCom")
local BankCityItem = require("UI.LWSeason5.LWBank.Component.BankCityItem")
local UICommonTabGroup = require("UI.UICommonTabGroup.UICommonTabGroup")
local CommonTabGroupItemTemplate = require("DataCenter.CommonTabGroup.CommonTabGoupItemTemplate")
local btnBack_path = "Root/BottomBar/BtnBack"
local loopGridViewItemHolder_path = "Root/ItemHolder"
local compItemContent_path = "Root/ItemHolder/Viewport/ItemContent"
local selectCom_path = "Root/topArea/CommonSelectCom"
local tabGroup_path = "Root/topArea/UICommonTabGroup"
local topDes_path = "Root/topArea/topDes"
local emptyDes_path = "Root/emptyDes"
local btnHistory_path = "Root/BtnHistory"

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
  self.btnBack = self:AddComponent(UIButton, btnBack_path)
  self.loopGridViewItemHolder = self:AddComponent(UILoopGridView, loopGridViewItemHolder_path)
  self.compItemContent = self:AddComponent(UIBaseContainer, compItemContent_path)
  self.selectCom = self:AddComponent(CommonSelectCom, selectCom_path)
  self.tabGroup = self:AddComponent(UIBaseContainer, tabGroup_path)
  self.topDes = self:AddComponent(UIText, topDes_path)
  self.emptyDes = self:AddComponent(UIText, emptyDes_path)
  self.btnHistory = self:AddComponent(UIButton, btnHistory_path)
  self.btnBack:SetOnClick((BindCallback(self.ctrl, self.ctrl.CloseSelf)))
  self.btnHistory:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    UIManager:GetInstance():OpenWindow(UIWindowNames.BankHistory, {anim = true})
  end)
  self.loopGridViewItemHolder:InitGridView(0, function(loopScroll, index, item)
    return self:OnGetItemByRowColumn(loopScroll, index)
  end)
  self.tabGroup = self:AddComponent(UICommonTabGroup, tabGroup_path)
  self:Init()
end

local function ComponentDestroy(self)
  if self.compItemContent then
    self.compItemContent:RemoveComponents(BankCityItem)
  end
  if self.loopGridViewItemHolder then
    self.loopGridViewItemHolder:ClearAllItems()
  end
  self.btnBack = nil
  self.loopGridViewItemHolder = nil
  self.compItemContent = nil
  self.selectCom = nil
  self.tabGroup = nil
  self.topDes = nil
  self.emptyDes = nil
  self.btnHistory = nil
end

local function DataDefine(self)
  self.listDataDic = {}
  self.listData = nil
  self.selectServerId = 0
  self.defaultServerId = LuaEntry.Player.serverId
end

local function DataDestroy(self)
end

function BankCityView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UpdateAllServerBankInfoWithServer, self.UpdateAllServerInfoWithServer)
end

function BankCityView:OnRemoveListener()
  self:RemoveUIListener(EventId.UpdateAllServerBankInfoWithServer, self.UpdateAllServerInfoWithServer)
  base.OnRemoveListener(self)
end

function BankCityView:UpdateAllServerInfoWithServer(msg)
  if msg and msg.list then
    self.listDataDic[msg.serverId] = msg
    if self.selectServerId == msg.serverId then
      self:RefreshData(true)
    end
  end
end

function BankCityView:Init()
  local theData = {}
  theData.isTop = false
  theData.itemList = {}
  theData.itemList[1] = {
    type = 1,
    des = Localization:GetString("s5_bank_ui65")
  }
  theData.itemList[2] = {
    type = 2,
    des = Localization:GetString("s5_bank_ui66")
  }
  theData.itemList[3] = {
    type = 3,
    des = Localization:GetString("s5_bank_ui67")
  }
  theData.itemList[4] = {
    type = 4,
    des = Localization:GetString("s5_bank_ui81")
  }
  self.selectCom:Init(theData, function(d, i)
    return self:SelectTierChange(d, i)
  end)
  self.selectCom:SetIndex(1)
  self.curSelect = 1
  self:InitTabGroup()
end

function BankCityView:SelectTierChange(data, index)
  if self.curSelect == index then
    return true
  end
  self.curSelect = index
  self:OnClickTabServerId(self.selectServerId)
  return true
end

function BankCityView:RefreshData(isInit)
  self.depositBanksDic = self.listDataDic[self.selectServerId] and self.listDataDic[self.selectServerId].depositBanksDic or {}
  if isInit then
    local _, defaultTabIndex = self:GetUserData()
    defaultTabIndex = toInt(defaultTabIndex)
    if 1 <= defaultTabIndex and defaultTabIndex <= 4 then
      self.curSelect = defaultTabIndex
      self.listData = self:GetListData(self.curSelect, self.listData)
    else
      self.listData, self.curSelect = self:GetAvailableListData()
    end
    self.selectCom:SetIndex(self.curSelect)
  else
    self.listData = self:GetListData(self.curSelect, self.listData)
  end
  self.selfCount = 0
  for k, v in pairs(self.listData) do
    if v:IsOwner() then
      self.selfCount = self.selfCount + 1
    end
  end
  table.sort(self.listData, function(l, r)
    return l.priority > r.priority
  end)
  self:RefreshView()
end

function BankCityView:RefreshView()
  local dataCount = #self.listData
  self.playAnim = true
  self.topDes:SetText(Localization:GetString("s5_bank_ui85") .. string.format("%s/%s", self.selfCount, dataCount))
  self.loopGridViewItemHolder:SetListItemCount(dataCount, true)
  self.loopGridViewItemHolder:RefreshAllShownItem()
  self.playAnim = false
  if dataCount <= 0 then
    self.emptyDes:SetText(Localization:GetString("season_alliance_trade_list_10"))
    self.emptyDes:SetActive(true)
    self.loopGridViewItemHolder:SetActive(false)
  else
    self.emptyDes:SetActive(false)
    self.loopGridViewItemHolder:SetActive(true)
  end
end

function BankCityView:GetListData(index, list)
  if list then
    table.clear(list)
  else
    list = {}
  end
  local tmpList = self.listDataDic[self.selectServerId] and self.listDataDic[self.selectServerId].list or {}
  if index == 1 then
    for k, v in pairs(tmpList) do
      if not self.depositBanksDic[v.id] and v:CanDeposit() then
        table.insert(list, v)
      end
    end
  elseif index == 2 then
    local selfCount = 0
    for k, v in pairs(tmpList) do
      if v.isConnect and not v:IsOwner() then
        table.insert(list, v)
      end
      if v:IsOwner() then
        selfCount = selfCount + 1
      end
    end
    if selfCount == 0 and not table.IsNullOrEmpty(list) then
      list = {}
    end
  elseif index == 3 then
    for k, v in pairs(tmpList) do
      if v.isConnect and not v:IsProtect() and not v:IsOwner() then
        table.insert(list, v)
      end
    end
  else
    for k, v in pairs(tmpList) do
      if self.depositBanksDic[v.id] then
        table.insert(list, v)
      end
    end
  end
  return list
end

function BankCityView:GetAvailableListData()
  local list = self.listData
  for i = 1, 4 do
    list = self:GetListData(i, list)
    if 0 < #list then
      return list, i
    end
  end
  return list, 1
end

function BankCityView:OnGetItemByRowColumn(loopScroll, index)
  if self.listData ~= nil then
    local count = #self.listData
    index = index + 1
    if index < 1 or count < index then
      return nil
    end
    local item = loopScroll:NewListViewItem("BankCityItem")
    local script = self.compItemContent:GetComponent(item.gameObject.name, BankCityItem)
    if script == nil then
      local name = "item_" .. UIUtil.GetLoopListItemIndex()
      item.gameObject.name = name
      script = self.compItemContent:AddComponent(BankCityItem, name)
    end
    script:SetActive(true)
    script:ReInit(index, self.listData[index], self.depositBanksDic, self.playAnim)
    return item
  end
end

function BankCityView:InitTabGroup()
  local serverListInt = DataCenter.SeasonDataManager:GetServerListInt()
  if serverListInt == nil then
    return
  end
  local groupList = {}
  for index, serverId in ipairs(serverListInt) do
    local temp = CommonTabGroupItemTemplate.New()
    temp.title = string.format("#%s", serverId)
    temp.unSelectBgPath = "Assets/Main/SeasonRes/S5/Sprites/CommonS5/zxl_s5_yeqian.png"
    temp.selectBgPath = "Assets/Main/SeasonRes/S5/Sprites/CommonS5/zxl_s5_yeqian_xuanzhong.png"
    temp.arrowPath = false
    groupList[index] = temp
  end
  local bindFunc1 = BindCallback(self, self.OnGroupLoadFinish)
  local bindFunc2 = BindCallback(self, self.OnClickTab)
  
  local function bindFunc3(index)
  end
  
  self.tabGroup:SetTabItemStyle(CommonTabGroupItemStyle.Style_S4)
  self.tabGroup:RefreshGroup(groupList, bindFunc1, bindFunc2, bindFunc3)
end

function BankCityView:OnGroupLoadFinish()
  local serverListInt = DataCenter.SeasonDataManager:GetServerListInt()
  if serverListInt == nil then
    return
  end
  local curIndex = 1
  for index, serverId in ipairs(serverListInt) do
    if serverId == self.defaultServerId then
      curIndex = index
      break
    end
  end
  self.tabGroup:SelectTab(curIndex, true)
end

function BankCityView:OnClickTab(index)
  local serverListInt = DataCenter.SeasonDataManager:GetServerListInt()
  if serverListInt then
    self:OnClickTabServerId(serverListInt[index], true)
  end
end

function BankCityView:OnClickTabServerId(serverId, isInit)
  if isInit and self.selectServerId == serverId then
    return
  end
  self.selectServerId = serverId or 0
  self:RefreshData(isInit)
  if not self.listDataDic[self.selectServerId] then
    SFSNetwork.SendMessage(MsgDefines.LwRqStrongholdBankList, self.selectServerId)
  end
end

BankCityView.OnCreate = OnCreate
BankCityView.OnDestroy = OnDestroy
BankCityView.OnEnable = OnEnable
BankCityView.OnDisable = OnDisable
BankCityView.ComponentDefine = ComponentDefine
BankCityView.ComponentDestroy = ComponentDestroy
BankCityView.DataDefine = DataDefine
BankCityView.DataDestroy = DataDestroy
return BankCityView
