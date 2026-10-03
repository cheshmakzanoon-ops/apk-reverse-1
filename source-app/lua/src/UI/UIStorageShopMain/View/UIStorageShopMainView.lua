local base = UIBaseView
local UIStorageShopView = BaseClass("UIStorageShopView", base)
local Localization = CS.GameEntry.Localization
local StorageShop = require("UI.UIStorageShopMain.Component.StorageShop")
local StorageList = require("UI.UIStorageShopMain.Component.StorageShopList")
local assetsPath = "Assets/Main/Prefabs/UI/UIStorageShop/%s.prefab"
local subPanelConf = {
  [1] = {
    Asset = "StorageShop",
    Script = StorageShop
  },
  [2] = {
    Asset = "StorageShopList",
    Script = StorageList
  },
  [3] = {
    Asset = "StorageShopList",
    Script = StorageList
  }
}
local titleTxt_path = "titleText"
local closeBtn_path = "CloseBtn"
local toggle_path = "Tab/Toggle"
local panelContainer_path = "offset"
local history_btn_path = "HistoryBtn"
local history_btn_name_path = "HistoryBtn/HistoryBtnName"
local infoBtn_path = "titleText/infoBtn"

local function OnCreate(self)
  base.OnCreate(self)
  Setting:SetBool("StorageShop_FirstOpen_" .. LuaEntry.Player.uid, false)
  self:ComponentDefine()
  self:DataDefine()
  local playerUid, targetTab, isArrow = self:GetUserData()
  targetTab = targetTab or DataCenter.StorageShopManager:GetLastTabIndex()
  targetTab = targetTab or 1
  self.playerUid = playerUid
  self.isArrow = isArrow
  self:InitUI(targetTab)
end

local function OnDestroy(self)
  DataCenter.StorageShopManager:SetLastTabIndex(self.curTab)
  DataCenter.StorageShopManager:SetLastGolloesBuyTime()
  EventManager:GetInstance():Broadcast(EventId.StorageShopBubbleStatusChange)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function ComponentDefine(self)
  self.titleN = self:AddComponent(UIText, titleTxt_path)
  self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
  self.closeBtnN:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.toggleNList = {}
  for i = 1, 3 do
    local tempToggle = self:AddComponent(UIToggle, toggle_path .. i)
    tempToggle.choose = tempToggle:AddComponent(UIBaseContainer, "Choose")
    tempToggle:SetOnValueChanged(function(tf)
      if tf then
        self:ChangeShowType(i)
      end
    end)
    self.toggleNList[i] = tempToggle
  end
  self.panelContainerN = self:AddComponent(UIBaseContainer, panelContainer_path)
  self.history_btn = self:AddComponent(UIButton, history_btn_path)
  self.history_btn:SetOnClick(function()
    self:OnHistoryBtnClick()
  end)
  self.history_btn_name = self:AddComponent(UIText, history_btn_name_path)
  self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
  self.infoBtnN:SetOnClick(function()
    self:OnClickInfoBtn()
  end)
end

local function ComponentDestroy(self)
  self.titleN = nil
  self.closeBtnN = nil
  self.bgBtnN = nil
  self.toggleNList = nil
  self.panelContainerN = nil
  self.history_btn = nil
  self.history_btn_name = nil
end

local function DataDefine(self)
  self.playerUid = nil
  self.curTab = nil
  self.panelList = {}
  self.reqList = {}
  self.guideTab = nil
end

local function DataDestroy(self)
  self.playerUid = nil
  self.curTab = nil
  self.panelList = nil
  self.reqList = nil
  self.guideTab = nil
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.StorageShopGetOtherShopInfo, self.SetTitleName)
end

local function OnRemoveListener(self)
  self:RemoveUIListener(EventId.StorageShopGetOtherShopInfo, self.SetTitleName)
  base.OnRemoveListener(self)
end

local function InitUI(self, targetTab)
  if self.playerUid and self.playerUid ~= LuaEntry.Player.uid then
    self.toggleNList[2]:SetActive(false)
    self.toggleNList[3]:SetActive(false)
    targetTab = 1
  else
    self.toggleNList[2]:SetActive(true)
    local isVisible = LuaEntry.DataConfig:CheckSwitch("tradingbank_world")
    self.toggleNList[3]:SetActive(isVisible)
    if not isVisible and targetTab == 3 then
      targetTab = 1
    end
  end
  self.guideTab = targetTab
  self:ChangeShowType(targetTab)
  TimerManager:GetInstance():DelayInvoke(function()
    self:SetArrow()
  end, 0.1)
  self.history_btn_name:SetText(Localization:GetString(GameDialogDefine.STORAGE_SHOP_HISTORY))
end

local function SetArrow(self)
  if self.isArrow then
    local param = {}
    param.position = self.panelList.StorageShop:GetCellEmptyPos()
    param.position.x = param.position.x + 15
    param.position.y = param.position.y + 20
    param.arrowType = ArrowType.Capacity
    param.positionType = PositionType.Screen
    DataCenter.ArrowManager:ShowArrow(param)
    self.isArrow = nil
  end
end

local function ChangeShowType(self, tabIndex)
  for i = 1, 3 do
    self.toggleNList[i].choose:SetActive(i == tabIndex)
  end
  local prefabName = subPanelConf[tabIndex].Asset
  if self.curTab and prefabName == subPanelConf[self.curTab].Asset then
    self.curTab = tabIndex
    self:RefreshOnShowPanel()
  elseif not self.panelList[prefabName] then
    local assetFullPath = string.format(assetsPath, prefabName)
    self.reqList[prefabName] = self:GameObjectInstantiateAsync(assetFullPath, function(request)
      if request.isError then
        return
      end
      if self.curTab then
        self.panelList[subPanelConf[self.curTab].Asset]:SetActive(false)
      end
      self.curTab = tabIndex
      local go = request.gameObject
      go.transform:SetParent(self.panelContainerN.transform)
      go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local v3 = go.transform.position
      v3.x = 0
      v3.y = 0
      go.transform.position = v3
      local cell = self.panelContainerN:AddComponent(subPanelConf[tabIndex].Script, go)
      self.panelList[prefabName] = cell
      self.panelList[prefabName]:SetActive(true)
      self:RefreshOnShowPanel()
    end)
  else
    if self.curTab then
      self.panelList[subPanelConf[self.curTab].Asset]:SetActive(false)
    end
    self.curTab = tabIndex
    self.panelList[prefabName]:SetActive(true)
    self:RefreshOnShowPanel()
  end
end

local function RefreshOnShowPanel(self)
  local tempPanel = subPanelConf[self.curTab].Asset
  if self.curTab == 1 then
    self:SetTitleName()
    self.panelList[tempPanel]:ShowPanel(self.playerUid)
    if self.playerUid and self.playerUid ~= LuaEntry.Player.uid then
      self.history_btn:SetActive(false)
    else
      self.history_btn:SetActive(true)
    end
  elseif self.curTab == 2 then
    self.titleN:SetLocalText(372140)
    self.panelList[tempPanel]:ShowPanel(StorageShopListType.Alliance)
    self.history_btn:SetActive(false)
  elseif self.curTab == 3 then
    self.titleN:SetLocalText(372141)
    self.panelList[tempPanel]:ShowPanel(StorageShopListType.World)
    self.history_btn:SetActive(false)
  end
end

local function SetTitleName(self)
  local strName = LuaEntry.Player.name
  if self.playerUid and self.playerUid ~= LuaEntry.Player.uid then
    local otherShopInfo = DataCenter.StorageShopManager:GetCurOtherShopInfo()
    if otherShopInfo then
      strName = otherShopInfo.name
    end
  end
  self.titleN:SetLocalText(141046, strName)
end

local function GetCurTab(self)
  if self.playerUid ~= nil and self.playerUid ~= LuaEntry.Player.uid then
    return nil
  end
  if self.curTab == nil then
    return self.guideTab
  end
  return self.curTab
end

local function OnHistoryBtnClick(self)
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIStorageShopHistory)
end

local function OnClickInfoBtn(self)
  UIUtil.ShowIntro(Localization:GetString("372132"), Localization:GetString("302027"), Localization:GetString("143597"))
end

UIStorageShopView.OnCreate = OnCreate
UIStorageShopView.OnDestroy = OnDestroy
UIStorageShopView.OnAddListener = OnAddListener
UIStorageShopView.OnRemoveListener = OnRemoveListener
UIStorageShopView.ComponentDefine = ComponentDefine
UIStorageShopView.ComponentDestroy = ComponentDestroy
UIStorageShopView.DataDefine = DataDefine
UIStorageShopView.DataDestroy = DataDestroy
UIStorageShopView.InitUI = InitUI
UIStorageShopView.ChangeShowType = ChangeShowType
UIStorageShopView.SetArrow = SetArrow
UIStorageShopView.RefreshOnShowPanel = RefreshOnShowPanel
UIStorageShopView.GetCurTab = GetCurTab
UIStorageShopView.SetTitleName = SetTitleName
UIStorageShopView.OnHistoryBtnClick = OnHistoryBtnClick
UIStorageShopView.OnClickInfoBtn = OnClickInfoBtn
return UIStorageShopView
