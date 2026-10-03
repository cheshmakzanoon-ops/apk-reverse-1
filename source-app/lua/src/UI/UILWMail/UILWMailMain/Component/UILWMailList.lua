local UILWMailList = BaseClass("UILWMailList", UIBaseContainer)
local base = UIBaseContainer
local TryGetMore = {}
local UILWMailListFilter = require("UI.UILWMail.UILWMailMain.Component.UILWMailListFilter")
local USE_DB_DIRECT_SEARCH = {
  [MailInternalGroup.MAIL_IN_hide] = false,
  [MailInternalGroup.MAIL_IN_report] = false,
  [MailInternalGroup.MAIL_IN_alliance] = true,
  [MailInternalGroup.MAIL_IN_activity] = true,
  [MailInternalGroup.MAIL_IN_system] = true,
  [MailInternalGroup.MAIL_IN_daily] = false,
  [MailInternalGroup.MAIL_IN_charge] = false,
  [MailInternalGroup.MAIL_IN_favor] = false,
  [MailInternalGroup.MAIL_IN_season] = false
}
local MailListItemType = {
  Common = 1,
  War = 2,
  Gather = 3,
  Charge = 4,
  BeFrozen = 5,
  SandWormKnockOff = 6
}
local MailListItemPrefabName = {
  [MailListItemType.Common] = "UILWMailListItemCommon",
  [MailListItemType.War] = "UILWMailListItemWar",
  [MailListItemType.Gather] = "UILWMailListItemGather",
  [MailListItemType.Charge] = "UILWMailListItemCharge",
  [MailListItemType.BeFrozen] = "UILWMailListItemFrozen",
  [MailListItemType.SandWormKnockOff] = "UILWMailListItemSandWormKnockOff"
}
local MailListItemScript = {
  [MailListItemType.Common] = require("UI.UILWMail.UILWMailMain.Component.UILWMailListItemCommon"),
  [MailListItemType.War] = require("UI.UILWMail.UILWMailMain.Component.UILWMailListItemWar"),
  [MailListItemType.Gather] = require("UI.UILWMail.UILWMailMain.Component.UILWMailListItemGather"),
  [MailListItemType.Charge] = require("UI.UILWMail.UILWMailMain.Component.UILWMailListItemCharge"),
  [MailListItemType.BeFrozen] = require("UI.UILWMail.UILWMailMain.Component.UILWMailListItemFrozen"),
  [MailListItemType.SandWormKnockOff] = require("UI.UILWMail.UILWMailMain.Component.UILWMailListItemSandWormKnockOff")
}

function UILWMailList:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailList:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailList:ComponentDefine()
  self.content = self:AddComponent(UIBaseContainer, "MScroll/MViewport/MContent")
  self.bgGather = self:AddComponent(UIBaseComponent, "Bg_Gather")
  self.bgGather:SetActive(false)
  self.scroll = self:AddComponent(UIBaseComponent, "MScroll")
  self.items = {}
  self.loopListView = self:AddComponent(UILoopListView2, "MScroll")
  self.loopListView:InitListView(0, function(listview, index)
    return self:GetScrollItem(listview, index)
  end)
  self.loopListView:SetOnDragingAction(function()
    self:OnDraggingAction()
  end)
  self.loopListView:SetOnEndDragAction(function(...)
    self:OnEndDragAction()
  end)
  self.getMore = self:AddComponent(UIButton, "GetMore")
  self.getMore:SetOnClick(function()
    self:OnClickGetMoreMail()
  end)
  self.getMore:SetActive(false)
  self.canvasGroup = self:AddComponent(UICanvasGroup, "")
  self.mailFilter = self:AddComponent(UILWMailListFilter, "FilterHolder")
  self.mailFilter:SetFilterListener(function(filterType, param)
    self:OnMailFilter(filterType, param)
  end)
end

function UILWMailList:ComponentDestroy()
  self:ClearContent()
  self.content = nil
  self.bgGather = nil
  self.scroll = nil
  self.loopListView = nil
end

function UILWMailList:InitFilterParams()
  DataCenter.MailDataManager:ClearTempMailList()
  self.filterMailList = {}
  self.startIndex = 0
  self.filterType = MailFilterType.None
  self.filterParam = nil
  self.querying = false
  self.totalCnt = nil
  self.queryIndex = 0
  if DataCenter.MailDataManager.Filter:IsFilterOpen() then
    self.mailFilter:SetActive(true)
    self.mailFilter:ResetView()
  else
    self.mailFilter:SetActive(false)
  end
  if self.view and self.view.ctrl then
    local current_view = self.view.ctrl:GetCurrentView()
    if current_view == MailContentType.MailList then
      if DataCenter.MailDataManager.Filter:IsFilterOpen() then
        local list = self.view.ctrl:GetMailGroupFilters()
        if #list <= 1 then
          self.scroll:SetOffsetMaxXY(0, -90)
        else
          self.scroll:SetOffsetMaxXY(0, -160)
        end
      else
        self.scroll:SetOffsetMaxXY(0, -24)
      end
    end
  end
end

function UILWMailList:DataDefine()
  self:InitFilterParams()
  self.lastView = nil
end

function UILWMailList:DataDestroy()
  self:InitFilterParams()
  self.lastView = nil
end

function UILWMailList:OnEnable()
  base.OnEnable(self)
end

function UILWMailList:OnDisable()
  base.OnDisable(self)
end

function UILWMailList:OnAddListener()
  if not self.listener then
    self.listener = true
    base.OnAddListener(self)
    self:AddUIListener(EventId.Mail_DeleteBatchMailDone, self.RefreshContent)
    self:AddUIListener(EventId.MailPush, self.RefreshContent)
  end
end

function UILWMailList:OnRemoveListener()
  if self.listener then
    self.listener = false
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.Mail_DeleteBatchMailDone, self.RefreshContent)
    self:RemoveUIListener(EventId.MailPush, self.RefreshContent)
  end
end

function UILWMailList:ClearContent()
  self.items = {}
  for i = 1, #MailListItemScript do
    self.content:RemoveComponents(MailListItemScript[i])
  end
  self.loopListView:ClearAllItems()
end

function UILWMailList:RefreshContent()
  if self.view == nil then
    return
  end
  if self.curTab ~= self.view.ctrl:GetCurrentTab() then
    self:InitFilterParams()
    self.view.ctrl:ClearGroupShowIndex()
  end
  self.view.ctrl:CleanCurrentMailListByType()
  local mailList = self:GetMailShowList()
  self.curTab = self.view.ctrl:GetCurrentTab()
  self.loopListView:SetListItemCount(#mailList, false, false)
  self.loopListView:RefreshAllShownItem()
  local current_view = self.view.ctrl:GetCurrentView()
  if current_view == MailContentType.MailList then
    if #mailList == 0 then
      self.view.allReadBtn:SetActive(false)
      self.view.allDeleteBtn:SetActive(false)
      self.view.noMailTxt:SetActive(true)
      self.getMore:SetActive(true)
      local un_reward_cnt = self.view.ctrl:GetUnRewardMailCountByGroup(self.curTab)
      if 0 < un_reward_cnt then
        Logger.Log(string.format("\227\128\144\233\130\174\228\187\182\227\128\145\230\156\170\233\162\134\229\165\150\230\149\176 = %s,curTab = %s", un_reward_cnt, self.curTab))
      end
    else
      self.view.allReadBtn:SetActive(true)
      self.view.allDeleteBtn:SetActive(true)
      self.view.noMailTxt:SetActive(false)
      self.getMore:SetActive(false)
    end
  else
    self.view.allReadBtn:SetActive(false)
    self.view.allDeleteBtn:SetActive(false)
    self.getMore:SetActive(false)
  end
end

local NameCount = 0

function UILWMailList:GetScrollItem(listview, index)
  local dataList = self:GetMailShowList()
  index = index + 1
  if index < 1 or index > #dataList then
    return nil
  end
  local prefabType = self:GetPrefabType(dataList[index])
  local csItem = listview:NewListViewItem(MailListItemPrefabName[prefabType])
  if self.items[csItem] == nil then
    NameCount = NameCount + 1
    local nameStr = MailListItemPrefabName[prefabType] .. NameCount
    csItem.gameObject.name = nameStr
    local mailItem = self.content:AddComponent(MailListItemScript[prefabType], nameStr)
    self.items[csItem] = mailItem
  end
  self.items[csItem]:SetData({
    mail_data = dataList[index],
    filter = self.filterParam and self.filterParam.keywords
  })
  return csItem
end

function UILWMailList:GetPrefabType(mailData)
  if self.curTab == MailInternalGroup.MAIL_IN_report then
    return MailListItemType.War
  elseif mailData.type == MailType.NEW_FIGHT then
    return MailListItemType.War
  elseif mailData.type == MailType.NEW_COLLECT_MAIL then
    return MailListItemType.Gather
  elseif mailData.type == MailType.SANDWORM_KNOCK_OFF then
    return MailListItemType.SandWormKnockOff
  elseif mailData.type == MailType.FIGHT_MONSTER then
    return MailListItemType.War
  elseif mailData.type == MailType.GIFT_BUY_EXCHANGE or mailData.type == MailType.LW_NEW_GOLDBRICK then
    return MailListItemType.Charge
  elseif mailData.type == MailType.MONSTER_INVASION_ATTACK_PLAYER or mailData.type == MailType.ALLIANCE_MONSTER_CHALLENGE_ATTACK then
    return MailListItemType.BeFrozen
  elseif self.curTab == MailInternalGroup.MAIL_IN_season then
    return MailListItemType.War
  elseif mailData.type == MailType.LW_METEORITE_COLLECT then
    return MailListItemType.Gather
  end
  return MailListItemType.Common
end

function UILWMailList:OnDraggingAction()
  local _totalCnt = #self:GetMailShowList()
  if self._loadingMail == true then
    return
  end
  local _lastItem = self.loopListView:GetShownItemByItemIndex(_totalCnt - 1)
  if _lastItem == nil then
    return
  end
  local _lastItemY = self.loopListView:GetItemCornerPosInViewPort(_lastItem).y
  local _viewPortSize = self.loopListView.unity_looplistview2.ViewPortSize
  if 50 <= _lastItemY + _viewPortSize then
    self._toLoadMore = true
  end
end

function UILWMailList:OnEndDragAction()
  if self._toLoadMore == true then
    self._loadingMail = false
    self._toLoadMore = false
    self:OnDragGetMoreMail()
  end
end

function UILWMailList:OnDragGetMoreMail()
  local curTab = self.curTab
  DataCenter.MailDataManager:ReqMore(curTab, function()
    self:PullMoreMailList(curTab)
  end)
end

function UILWMailList:OnClickGetMoreMail()
  local curTab = self.curTab
  DataCenter.MailDataManager:ReqMore(curTab, function()
    self:PullMoreMailList(curTab)
  end)
  if self.curTab == MailInternalGroup.MAIL_IN_report then
    local now = UITimeManager:GetInstance():GetServerTime()
    local lastTime = CommonUtil.PlayerPrefsGetLong("PULL_ALL_BATTLE_MAIL", 0)
    if 86400000 < now - lastTime then
      CommonUtil.PlayerPrefsSetLong("PULL_ALL_BATTLE_MAIL", now)
      Logger.LogInfo("PULL_ALL_MAIL")
      DataCenter.MailDataManager:PullAll()
    end
  end
end

function UILWMailList:SetShow(bool)
  self:SetActive(bool)
  if not bool then
    self.mailFilter:OnHideFilter()
  elseif self.lastView == MailContentType.ChannelList then
    self:InitFilterParams()
  end
  self.lastView = self.view and self.view.ctrl and self.view.ctrl:GetCurrentView()
end

function UILWMailList:GetMailShowList()
  if self.filterType == MailFilterType.None then
    return self.view.ctrl:GetCurrentUIMailListByType()
  else
    return self.filterMailList
  end
end

function UILWMailList:PullMoreMailList(curTab)
  if not self.view then
    return
  end
  if self.filterType == MailFilterType.None then
    self.view.ctrl:PullMoreGroupUIData(curTab)
    self:RefreshContent()
  else
    self:QueryMailsByFilter()
  end
end

function UILWMailList:OnMailFilter(filterType, param)
  self.filterType = filterType
  self.filterParam = param
  self.startIndex = 0
  self.queryIndex = 0
  DataCenter.MailDataManager:ClearTempMailList()
  self.filterMailList = {}
  self:QueryMailsByFilter()
  local types = {}
  if self.curTab ~= MailInternalGroup.MAIL_IN_favor then
    types = self.filterParam.mailTypes
  end
  self.totalCnt = nil
  self:QueryMailCount(types)
end

function UILWMailList:QueryMailsByFilter()
  if self.querying then
    return
  end
  self.querying = true
  local types = {}
  if self.curTab ~= MailInternalGroup.MAIL_IN_favor then
    types = self.filterParam.mailTypes
  end
  self:OnQueryStart()
  if USE_DB_DIRECT_SEARCH[self.curTab] then
  end
  if string.IsNullOrEmpty(self.filterParam.keywords) then
    self:QueryMailsDirect(types)
  else
    self.startIndex = self.startIndex + 20
    self:QueryMailsOnce(types)
    goto lbl_41
    self:QueryMailsDirect(types)
  end
  ::lbl_41::
end

function UILWMailList:QueryMailCount(types)
  local function GetTotalCnt(list)
    if list and list[1] and list[1].count then
      self.totalCnt = list[1] and list[1].count
    end
    self.mailFilter:UpdateProgress(self.queryIndex, self.totalCnt)
  end
  
  DataCenter.MailDataManager.DB:QueryMailsByTypesAndMailIds(self.curTab, types, self.filterParam.mailIds, self.filterParam.excludeMailIds, self.queryIndex, 20, GetTotalCnt, true)
end

function UILWMailList:OnQueryStart()
  self.mailFilter:OnStartQuery()
end

function UILWMailList:OnQueryFinish()
  self.mailFilter:OnFinishQuery()
  self:RefreshContent()
end

local function IsMailContainKeywords(mailData, keywords)
  if string.IsNullOrEmpty(keywords) then
    return true
  end
  keywords = string.lower(keywords)
  keywords = keywords:gsub("%s+", "")
  local title = string.lower(MailShowHelper.GetMainTitle(mailData))
  local s1, _ = string.find(title:gsub("%s+", ""):gsub("<[^>]+>", ""), keywords, 1, true)
  if s1 then
    return true
  end
  local subTitle = string.lower(MailShowHelper.GetMailSubTitle(mailData))
  local s2, _ = string.find(subTitle:gsub("%s+", ""):gsub("<[^>]+>", ""), keywords, 1, true)
  if s2 then
    return true
  end
  local message = string.lower(mailData:GetMailMessage())
  local s3, _ = string.find(message:gsub("%s+", ""):gsub("<[^>]+>", ""), keywords, 1, true)
  if s3 then
    return true
  end
  return false
end

function UILWMailList:QueryMailsOnce(types)
  if not self.querying then
    return
  end
  
  local function callback(mailDatas)
    if table.IsNullOrEmpty(mailDatas) then
      self.querying = false
      self:OnQueryFinish()
      return
    end
    self.queryIndex = self.queryIndex + 20
    local count = #mailDatas
    for _, v in ipairs(mailDatas) do
      DataCenter.MailDataManager:AddTempMailData(v)
      local mail = DataCenter.MailDataManager:GetTempMailById(v.uid)
      mail:DownloadBattleReport()
      mail:OnMailIntegrityExecute(function(mailInfo)
        if self.view == nil or self.filterParam == nil then
          return
        end
        if IsMailContainKeywords(mail, self.filterParam.keywords) then
          table.insert(self.filterMailList, mail)
        else
          DataCenter.MailDataManager:RemoveTempMailById(mail.uid)
        end
        count = count - 1
        if count == 0 then
          self:OnMailOnceQueryFinish(types, #mailDatas == 20)
        end
      end)
    end
    self.mailFilter:UpdateProgress(self.queryIndex, self.totalCnt)
    self:RefreshContent()
  end
  
  DataCenter.MailDataManager.DB:QueryMailsByTypesAndMailIds(self.curTab, types, self.filterParam.mailIds, self.filterParam.excludeMailIds, self.queryIndex, 20, callback)
end

function UILWMailList:OnMailOnceQueryFinish(types, fetchEnoughMails)
  self.mailFilter:UpdateProgress(self.queryIndex, self.totalCnt)
  if not string.IsNullOrEmpty(self.filterParam.keywords) and #self.filterMailList < self.startIndex and fetchEnoughMails then
    self:QueryMailsOnce(types)
  else
    self.querying = false
    self:OnQueryFinish()
  end
end

function UILWMailList:QueryMailsDirect(types)
  local function callback(mailDatas)
    for k, v in ipairs(mailDatas) do
      DataCenter.MailDataManager:AddTempMailData(v)
      
      local mail = DataCenter.MailDataManager:GetTempMailById(v.uid)
      mail:DownloadBattleReport(true)
      table.insert(self.filterMailList, mail)
    end
    self.querying = false
    self:OnQueryFinish()
  end
  
  self.curTab = self.view.ctrl:GetCurrentTab()
  if string.IsNullOrEmpty(self.filterParam.keywords) then
    DataCenter.MailDataManager.DB:QueryMailsByTypesAndMailIds(self.curTab, types, self.filterParam.mailIds, self.filterParam.excludeMailIds, self.startIndex, 20, callback)
  else
    DataCenter.MailDataManager:GetMailListByKeywords(self.curTab, types, self.filterParam.mailIds, self.filterParam.excludeMailIds, self.filterParam.keywords, self.startIndex, callback)
  end
  self.startIndex = self.startIndex + 20
end

function UILWMailList:OnMailDeleteDone(uid)
  if self.filterType ~= MailFilterType.None then
    for i, v in ipairs(self.filterMailList) do
      if tostring(v.uid) == tostring(uid) then
        table.remove(self.filterMailList, i)
        DataCenter.MailDataManager:RemoveTempMailById(v.uid)
        break
      end
    end
  end
end

return UILWMailList
