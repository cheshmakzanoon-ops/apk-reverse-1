local base = UIBaseView
local UIFlowerTrainLikeAndCheerListView = BaseClass("UIFlowerTrainLikeAndCheerListView", base)
local UIFlowerTrainLikeAndCheerItem = require("UI.FlowerTrain.UIFlowerTrainLikeAndCheerList.Component.UIFlowerTrainLikeAndCheerItem")
local UIFlowerTrainLikeAndCheerTopItem = require("UI.FlowerTrain.UIFlowerTrainLikeAndCheerList.Component.UIFlowerTrainLikeAndCheerTopItem")
local CommonActivityPopUpBgPart = require("UI.LWActivityCommonSecondPopUp.UIActivityDetailCommon.Component.CommonActivityPopUpBgPart")
local Localization = CS.GameEntry.Localization
local closeBtn_path = "Content/CloseBtn"
local commonActivityPopUpBgPart_path = "Content/CommonActivityPopUpBgPart"
local closePanelBtn_path = "panel"
local scrollView_path = "Content/NormalContent/Scroll View"
local tabLayout_path = "Content/TabLayout"
local earliestPlayer_path = "Content/NormalContent/TopThree/EarliestPlayer"
local regularlyPlayer_path = "Content/NormalContent/TopThree/RegularlyPlayer"
local oneKeyReplyBtn_path = "Content/NormalContent/OneKeyReplyBtn"
local emptyTxt_path = "Content/EmptyTxt"
local normalContent_path = "Content/NormalContent"
UIFlowerTrainLikeAndCheerListView.TabType = {Like = 1, Cheer = 2}
UIFlowerTrainLikeAndCheerListView.EmptyShowTxt = {
  [UIFlowerTrainLikeAndCheerListView.TabType.Like] = "2025halloween_rewardboard_empty_1",
  [UIFlowerTrainLikeAndCheerListView.TabType.Cheer] = "2025halloween_rewardboard_empty_2"
}
local MAX_REPLY_COUNT = 30
local TimeRequestDelta = 1000

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self.curSelectTab = self.TabType.Like
  self:RequestServerData()
  self:UpdateTab()
  self:UpdateContent()
  self:ModifyByConfig()
  self:RefreshSkin()
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
  self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
  self.commonActivityPopUpBgPart = self:AddComponent(UIBaseContainer, commonActivityPopUpBgPart_path)
  self.closePanelBtn = self:AddComponent(UIButton, closePanelBtn_path)
  self.scrollView = self:AddComponent(UIBaseContainer, scrollView_path)
  self.tabLayout = self:AddComponent(UIBaseContainer, tabLayout_path)
  self.earliestPlayer = self:AddComponent(UIBaseContainer, earliestPlayer_path)
  self.regularlyPlayer = self:AddComponent(UIBaseContainer, regularlyPlayer_path)
  self.oneKeyReplyBtn = self:AddComponent(UIButton, oneKeyReplyBtn_path)
  self.emptyTxt = self:AddComponent(UIText, emptyTxt_path)
  self.normalContent = self:AddComponent(UIBaseContainer, normalContent_path)
  self.topPlayers = {
    self:AddComponent(UIFlowerTrainLikeAndCheerTopItem, earliestPlayer_path),
    self:AddComponent(UIFlowerTrainLikeAndCheerTopItem, regularlyPlayer_path)
  }
  self.ScrollLoopListView = self:AddComponent(UILoopListView2, scrollView_path)
  self.ScrollContent = self:AddComponent(UIBaseContainer, scrollView_path .. "/Viewport/Content")
  self.ScrollLoopListView:InitListView(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end)
  
  function self.ScrollLoopListView.unity_looplistview2.mOnEndDragAction()
    self:OnDragEndAction()
  end
  
  self.commonActivityPopUpBgPartComponent = self:AddComponent(CommonActivityPopUpBgPart, commonActivityPopUpBgPart_path)
  self.commonActivityPopUpBgPartComponent:SetCloseCallback(BindCallback(self.ctrl, self.ctrl.CloseSelf))
  self.compTabList = {}
  for i, v in pairs(self.TabType) do
    local tab = {}
    tab.tabType = v
    local tabPath = tabLayout_path .. "/Tab" .. tostring(v)
    tab.objRoot = self:AddComponent(UIBaseContainer, tabPath)
    tab.objSelect = tab.objRoot:AddComponent(UIBaseContainer, "Select")
    tab.objUnSelect = tab.objRoot:AddComponent(UIBaseContainer, "UnSelect")
    tab.text = tab.objRoot:AddComponent(UIText, "Group/titleText")
    tab.btn = tab.objRoot:AddComponent(UIButton, "Btn")
    tab.unselectBg = tab.objRoot:AddComponent(UIImage, "UnSelect")
    tab.selectBg = tab.objRoot:AddComponent(UIImage, "Select")
    local index = v
    tab.btn:SetOnClick(function()
      self:OnSelectTab(index)
    end)
    self.compTabList[index] = tab
  end
  self.closeBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.closePanelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.oneKeyReplyBtn:SetOnClick(function()
    self:OnKeyReply()
  end)
end

local function ComponentDestroy(self)
  self.ScrollContent:RemoveComponents(UIFlowerTrainLikeAndCheerItem)
  self.ScrollLoopListView:ClearAllItems()
  self.ScrollLoopListView = nil
  self.closeBtn = nil
  self.commonActivityPopUpBgPart = nil
  self.closePanelBtn = nil
  self.scrollView = nil
  self.tabLayout = nil
  self.earliestPlayer = nil
  self.regularlyPlayer = nil
  self.oneKeyReplyBtn = nil
  self.emptyTxt = nil
  self.normalContent = nil
  self.commonActivityPopUpBgPartComponent = nil
end

local function DataDefine(self)
  local data = self:GetUserData()
  self.uuid = data.uuid
  self.itemMeta = DataCenter.ItemTemplateManager:GetItemTemplate(data.itemId)
  self.cacheData = {}
  self.showList = {}
  self.lastRequestTime = {}
  self.startIndex = 1
  self.lastRequestStartIndex = nil
  self.endIndex = 50
  self.itemIndex = 0
  self.topPlayerList = {}
  self.flowerTrainParaData = FlowerTrainUtils.GetFlowerTrainParaMetaByGoodsId(data.itemId)
end

local function DataDestroy(self)
  self.showList = {}
  self.cacheData = {}
  self.startIndex = 1
  self.lastRequestStartIndex = nil
  self.endIndex = 50
  self.lastRequestTime = {}
  self.itemIndex = 0
  self.topPlayerList = {}
end

function UIFlowerTrainLikeAndCheerListView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.UIFlowerTrain_RecordList, self.OnRecRecordData)
end

function UIFlowerTrainLikeAndCheerListView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.UIFlowerTrain_RecordList, self.OnRecRecordData)
end

function UIFlowerTrainLikeAndCheerListView:OnKeyReply()
  local uuids = {}
  local uuidMap = {}
  local uidMap = {}
  for i, v in ipairs(self.topPlayerList) do
    if v.uuid and v.reply ~= 1 then
      v.reply = 1
      if uuidMap[v.uuid] ~= true then
        table.insert(uuids, v.uuid)
        uuidMap[v.uuid] = true
        uidMap[v.uuid] = v.otherUid
      end
    end
  end
  for i, v in ipairs(self.showList) do
    if v.uuid and v.reply ~= 1 then
      v.reply = 1
      if uuidMap[v.uuid] ~= true then
        table.insert(uuids, v.uuid)
        uuidMap[v.uuid] = true
        uidMap[v.uuid] = v.otherUid
      end
      if #uuids >= MAX_REPLY_COUNT then
        break
      end
    end
  end
  if #uuids == 0 then
    return
  end
  local thumbsUpType
  if self.curSelectTab == self.TabType.Like then
    thumbsUpType = InteractiveUtil.ThumbsUpType.ThanksFlowerTrainLike
  else
    thumbsUpType = InteractiveUtil.ThumbsUpType.ThanksFlowerTrainCheer
  end
  for _, uuid in ipairs(table.keys(uidMap)) do
    InteractiveUtil.TryThumbsUp(uidMap[uuid], thumbsUpType, uuid, function()
    end)
  end
  UIUtil.ShowTipsId("YiBianJinQu_trivial_tips_21")
  SFSNetwork.SendMessage(MsgDefines.FlowerTrainReplyPraise, uuids)
  self.ScrollLoopListView:RefreshAllShownItem()
  self:UpdateTopPlayers()
end

function UIFlowerTrainLikeAndCheerListView:RequestServerData()
  local now = UITimeManager:GetInstance():GetServerTime()
  local lastTime = self.lastRequestTime[self.curSelectTab]
  if lastTime and now - lastTime < TimeRequestDelta then
    return
  end
  self.lastRequestTime[self.curSelectTab] = now
  SFSNetwork.SendMessage(MsgDefines.FlowerTrainRecord, {
    trainUuid = self.uuid,
    start = self.startIndex,
    ["end"] = self.endIndex,
    type = self.curSelectTab
  })
end

function UIFlowerTrainLikeAndCheerListView:OnRecRecordData(data)
  local lastCache = self.cacheData[data.type] or {}
  local lastIndex = lastCache.startIndex
  local lastRecord = lastCache.recordArr or {}
  if lastIndex == nil or lastIndex == self.startIndex then
    lastRecord = data.recordArr or {}
  else
    lastRecord = table.mergeArray(lastRecord, data.recordArr or {})
  end
  self.cacheData[data.type] = {
    startIndex = self.startIndex,
    recordArr = lastRecord,
    earliestPlayer = data.earliestPlayer or {},
    regularlyPlayer = data.mostPlayer or {}
  }
  self:UpdateContent()
end

function UIFlowerTrainLikeAndCheerListView:OnSelectTab(tabType)
  if tabType == self.curSelectTab then
    return
  end
  self.curSelectTab = tabType
  self:UpdateTab()
  self:UpdateContent()
  self:RequestServerData()
end

function UIFlowerTrainLikeAndCheerListView:UpdateTab()
  if self.compTabList == nil then
    return
  end
  for i, v in pairs(self.compTabList) do
    local isSelect = self.curSelectTab == v.tabType
    v.objSelect:SetActive(isSelect)
    v.objUnSelect:SetActive(not isSelect)
    v.text:SetText(self:GetTabLocalText(v.tabType))
  end
end

function UIFlowerTrainLikeAndCheerListView:GetTabLocalText(tab)
  if tab == self.TabType.Like then
    return Localization:GetString("treasure_world_record_tab1")
  end
  if tab == self.TabType.Cheer then
    return Localization:GetString("treasure_world_record_tab2")
  end
  return ""
end

function UIFlowerTrainLikeAndCheerListView:UpdateContent()
  if self.curSelectTab == nil then
    return
  end
  local data = self.cacheData[self.curSelectTab]
  if data == nil then
    return
  end
  self.showList = data.recordArr or {}
  self.topPlayerList = {
    data.earliestPlayer or {},
    data.regularlyPlayer or {}
  }
  self:UpdateTopPlayers()
  self.normalContent:SetActive(#self.showList > 0)
  self.emptyTxt:SetActive(#self.showList == 0)
  self.emptyTxt:SetLocalText(self.EmptyShowTxt[self.curSelectTab])
  for i, v in ipairs(self.showList) do
    v.index = i
  end
  self.ScrollLoopListView:SetListItemCount(#self.showList, false, false)
  self.ScrollLoopListView:RefreshAllShownItem()
end

function UIFlowerTrainLikeAndCheerListView:UpdateTopPlayers()
  for i, v in ipairs(self.topPlayers) do
    local itemData = self.topPlayerList[i]
    if next(itemData) then
      v:SetActive(true)
      v:ReInit(itemData, i)
    else
      v:SetActive(false)
    end
  end
end

function UIFlowerTrainLikeAndCheerListView:ModifyByConfig()
  local configId = self.itemMeta.serverPara3
  if string.IsNullOrEmpty(configId) then
    configId = 3
  end
  local lineData = LocalController:instance():getLine(TableName.Festival_Interface_Config, configId)
  if lineData == nil then
    Logger.LogError("Festival_Interface_Config GetTemplate lineData is nil id:" .. configId)
    return
  end
  self.commonActivityPopUpBgPartComponent:ModifyPanelPacking(lineData)
  self.commonActivityPopUpBgPartComponent:SetTitle("treasure_world_record_title")
  if not string.IsNullOrEmpty(lineData.board_page) then
    local pageList = string.split(lineData.board_page, "|")
    for _, v in pairs(self.compTabList) do
      v.selectBg:LoadSpriteAsync(string.format(LoadPath.ActivityThemPath, pageList[1]))
      v.unselectBg:LoadSpriteAsync(string.format(LoadPath.ActivityThemPath, pageList[2]))
    end
  end
end

function UIFlowerTrainLikeAndCheerListView:OnGetItemByIndex(listview, index)
  if self.showList == nil or index < 0 or index >= #self.showList then
    return nil
  end
  index = index + 1
  local item = listview:NewListViewItem("UIFlowerTrainLikeAndCheerItem")
  if item == nil then
    return
  end
  local script = self.ScrollContent:GetComponent(item.gameObject.name, UIFlowerTrainLikeAndCheerItem)
  if script == nil then
    local objectName = item.gameObject.name .. tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.ScrollContent:AddComponent(UIFlowerTrainLikeAndCheerItem, objectName)
  end
  script:SetActive(true)
  script:ReInit(self.showList[index], index)
  return item
end

function UIFlowerTrainLikeAndCheerListView:OnDragEndAction()
  if #self.showList < self.endIndex then
    return
  end
  local containerTrans = self.ScrollLoopListView.unity_looplistview2.ContainerTrans
  if containerTrans.localPosition.y > containerTrans.rect.size.y - self.ScrollLoopListView.rectTransform.rect.size.y then
    self.startIndex = self.endIndex + 1
    self.endIndex = self.endIndex + 50
    self:RequestServerData()
  end
end

function UIFlowerTrainLikeAndCheerListView:RefreshSkin()
  if not self.flowerTrainParaData or not self.flowerTrainParaData.cheer_and_like_panel_cfg then
    return
  end
  FlowerTrainUtils.GeneratePanelDeco(self, self.flowerTrainParaData.cheer_and_like_panel_cfg)
end

UIFlowerTrainLikeAndCheerListView.OnCreate = OnCreate
UIFlowerTrainLikeAndCheerListView.OnDestroy = OnDestroy
UIFlowerTrainLikeAndCheerListView.OnEnable = OnEnable
UIFlowerTrainLikeAndCheerListView.OnDisable = OnDisable
UIFlowerTrainLikeAndCheerListView.ComponentDefine = ComponentDefine
UIFlowerTrainLikeAndCheerListView.ComponentDestroy = ComponentDestroy
UIFlowerTrainLikeAndCheerListView.DataDefine = DataDefine
UIFlowerTrainLikeAndCheerListView.DataDestroy = DataDestroy
return UIFlowerTrainLikeAndCheerListView
