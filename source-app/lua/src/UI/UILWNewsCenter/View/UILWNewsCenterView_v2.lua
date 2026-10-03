local UILWNewsCenterView_v2 = BaseClass("UILWNewsCenterView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UILWNewCenterLoopView = require("UI.UILWNewsCenter.Component.UINewCenterLoopView")
local UILWNewCenterTabList = require("UI.UILWNewsCenter.Component.UILWNewCenterTabList")
local NewCenterLikeItem = require("UI.UILWNewsCenter.Component.NewCenterLikeItem")
local off = 20
local childOff = 20
local compBook = {
  {
    path = "root/bg/txtTitle",
    name = "txtTitle",
    type = UIText
  },
  {
    path = "root/btnBack",
    name = "btnBack",
    type = UIButton
  },
  {
    path = "floatLike",
    name = "floatLike",
    type = nil
  },
  {
    path = "floatLike/UIPlayerHead",
    name = "headLike",
    type = UICommonHead
  },
  {
    path = "root/webView",
    name = "webView",
    type = UIBaseContainer
  }
}

function UILWNewsCenterView_v2:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self.currTab = nil
  self.ctrl.view = self
  self.floatInsts = {}
  self:ReInit()
end

function UILWNewsCenterView_v2:ReInit()
  PostEventLog.Track(PostEventLog.Defines.NewsCenterOpen, {})
  DataCenter.LWNewsCenterManager:ChangeMainBubbleState(false)
  self.redDotSettingCom:SetActive(false)
  self.webView:SetActive(false)
end

function UILWNewsCenterView_v2:SetRed()
  if not self.itemDatas then
    return
  end
  for _, itemData in ipairs(self.itemDatas) do
    if itemData.isRow then
      for i, listItem in pairs(itemData.list) do
        if listItem.isNew then
          listItem:SetRead()
        end
      end
    elseif itemData.isNew then
      itemData:SetRead()
    end
  end
end

function UILWNewsCenterView_v2:OnDestroy()
  self:RemoveComponents(NewCenterLikeItem)
  self.likeItem:GameObjectRecycleAll()
  self:SetRed()
  local saveType
  if self.tabType == ChatNewsCenterTabType.Announcement or self.tabType == ChatNewsCenterTabType.StrategyGuide then
    saveType = self.tabType
  end
  DataCenter.LWNewsCenterManager:SetCacheNewsType(saveType)
  DataCenter.LWNewsCenterManager:SetRedDotId(self.tabType)
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWNewsCenterView_v2:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_UPDATA, self.OnNewsUpdate)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_INIT, self.OnNewsInit)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_OPEN_URL, self.OnOpenNewsCenterURL)
  self:AddUIListener(EventId.CHAT_NEWSCENTER_SHARE, self.OnCloseNewsCenterURL)
end

function UILWNewsCenterView_v2:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_UPDATA, self.OnNewsUpdate)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_INIT, self.OnNewsInit)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_OPEN_URL, self.OnOpenNewsCenterURL)
  self:RemoveUIListener(EventId.CHAT_NEWSCENTER_SHARE, self.OnCloseNewsCenterURL)
end

function UILWNewsCenterView_v2:OnCloseNewsCenterURL()
  if self.webView:GetActive() then
    CS.ZendeskSupportView.Close()
    self.webView:SetActive(false)
    return
  end
end

function UILWNewsCenterView_v2:OnNewsInit()
  self:RefreshNews()
end

function UILWNewsCenterView_v2:OnNewsUpdate(tabType)
  if self.tabType == tabType and (self.tabType == ChatNewsCenterTabType.StrategyGuide or self.tabType == ChatNewsCenterTabType.Announcement) then
    self.itemDatas = DataCenter.LWNewsCenterManager:GetNewsCenterInfoListByType(self.tabType)
    self.itemDatas = self:GetRow(self.itemDatas)
    self.txtEmpty:SetActive(false)
    self._scrollView:RefreshList(self.itemDatas, self.tabType)
  end
end

function UILWNewsCenterView_v2:OnOpenNewsCenterURL(data)
  if CS.SDKManager.IS_UNITY_EDITOR() or Config.IsPC() then
    CS.SDKManager.OpenURL(data.openUrl)
  else
    self.webView:SetActive(true)
    DataCenter.LWNewsCenterManager:ShowWebViewURl({
      obj = self.webView.gameObject,
      url = data.openUrl,
      startJson = data.eventJson,
      openType = NewsCenterOpenType.News
    })
  end
end

function UILWNewsCenterView_v2:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function UILWNewsCenterView_v2:OnBackBtnClick()
  if self.webView:GetActive() then
    local isCanCloseView = not CS.ZendeskSupportView.WebViewBack()
    if isCanCloseView then
      CS.ZendeskSupportView.Close()
      self.webView:SetActive(false)
    end
    return
  end
  self.ctrl:CloseSelf()
end

function UILWNewsCenterView_v2:ComponentDefine()
  self:DefineCompsByBook(compBook)
  self.btnBack:SetOnClick(function()
    self:OnBackBtnClick()
  end)
  self.itemIncNo = 1
  self.newsItemMap = {}
  self.txtEmpty = self:AddComponent(UIText, "root/txtEmpty")
  self._scrollView = self:AddComponent(UILWNewCenterLoopView, "root/main/Scroll_View_mainView")
  self.tabList = self:AddComponent(UILWNewCenterTabList, "root/TopLayout")
  self.childTabGroup = self:AddComponent(UILWNewCenterTabList, "root/main/childTabGroup")
  self.mainRoot = self:AddComponent(UIBaseContainer, "root/main")
  self.txtTitle:SetText(Localization:GetString("800940"))
  self.redDotSettingCom = self:AddComponent(UIBaseContainer, "redDotSettingCom")
  self.selectBtn = self:AddComponent(UIButton, "redDotSettingCom/selectBtn")
  self.selectBtn:SetOnClick(function()
    self:UpdateRedDotSetting()
  end)
  self.selectImg = self:AddComponent(UIImage, "redDotSettingCom/selectBtn/selectImg")
  self.floatLike:SetActive(false)
  local playerInfo = ChatInterface.getUserData(LuaEntry.Player.uid)
  self.headLike:SetHeadAndFrame(playerInfo.uid, playerInfo.headPic, playerInfo.headPicVer, false, playerInfo.headSkinId, playerInfo.headSkinET)
  self:RefreshNews()
  self.likeItem = self.floatLike.gameObject
  self.likeItem:GameObjectCreatePool()
  DataCenter.LWNewsCenterManager:ResetData()
end

function UILWNewsCenterView_v2:HasParentAndChildTab(parentTabType, childTabType)
  if not self.dataList or not parentTabType then
    return false
  end
  for _, parent in ipairs(self.dataList) do
    if parent.tabType == parentTabType then
      if not childTabType then
        return true
      end
      local childTabs = parent.childTab
      if childTabs then
        for _, child in ipairs(childTabs) do
          if child.tabType == childTabType then
            return true
          end
        end
      end
    end
  end
  return false
end

function UILWNewsCenterView_v2:OpenType(newsTabType)
  if self.dataList and #self.dataList > 0 then
    local config = self.ctrl:GetConfigByType(newsTabType)
    if not config then
      return
    end
    if config.parent then
      local parentConfig = self.ctrl:GetConfigByType(config.parent)
      if parentConfig then
        local has = self:HasParentAndChildTab(parentConfig.tabType, config.tabType)
        if has then
          self.tabList:SwitchTab(parentConfig.tabType, config.tabType)
          return
        end
      end
    else
      local has = self:HasParentAndChildTab(config.tabType)
      if has then
        self.tabList:SwitchTab(config.tabType)
        return
      end
    end
    if self.dataList and #self.dataList > 0 then
      self.tabList:SwitchTab(self.dataList[1].tabType)
    end
  end
end

function UILWNewsCenterView_v2:RefreshNews()
  self.dataList = self.ctrl:GetTabConfig()
  self.tabList:Refresh(self.dataList, function(tabData, tabType)
    self:OnParentTabSwitch(tabData, tabType)
  end)
  local param = self:GetUserData()
  if param and param.tabType then
    self:OpenType(param.tabType)
  else
    local saveType = DataCenter.LWNewsCenterManager:GetCacheNewsType(self.tabType)
    if saveType then
      self:OpenType(saveType)
    elseif self.dataList and #self.dataList > 0 then
      self.tabList:SwitchTab(self.dataList[1].tabType)
    end
  end
end

function UILWNewsCenterView_v2:GetRow(list)
  local result = {}
  local i = 1
  if not list then
    return result
  end
  while i <= #list do
    local group = {}
    group.list = {}
    group.smallType = NewsSubType.NEWS_DETAILS
    group.isRow = true
    table.insert(group.list, list[i])
    if i + 1 <= #list then
      table.insert(group.list, list[i + 1])
    end
    table.insert(result, group)
    i = i + 2
  end
  return result
end

function UILWNewsCenterView_v2:OnTabLeave()
end

function UILWNewsCenterView_v2:OnChildTabSwitch(tabData)
  if self.tabType ~= tabData.tabType then
    self:SetRed()
    DataCenter.LWNewsCenterManager:SetRedDotId(self.tabType)
  end
  self.tabType = tabData.tabType
  local isOn = self.childTabGroup:GetTempRed()
  if tabData.parent then
    self.tabList:SetNewTipActive(tabData.parent, isOn)
  end
  self:RefreshLoopView()
end

function UILWNewsCenterView_v2:GetLoopViewHeight()
  local rootY = self.mainRoot.rectTransform.rect.height
  local groupY = 0
  if self.childTabGroup.activeSelf then
    groupY = self.childTabGroup.rectTransform.rect.height
  end
  return rootY - groupY - off
end

function UILWNewsCenterView_v2:OnParentTabSwitch(tabData, childTabType)
  if (tabData.tabType == ChatNewsCenterTabType.World or tabData.tabType == ChatNewsCenterTabType.Alliance) and ChatInterface.IsDuringSeason() then
    self.redDotSettingCom:SetActive(true)
    self.redDotSetting = DataCenter.LWNewsCenterManager:GetNotRedSetting(ChatNewsCenterTabType.World)
    self.selectImg:SetActive(self.redDotSetting)
  else
    self.redDotSetting = false
    self.redDotSettingCom:SetActive(self.redDotSetting)
  end
  if tabData.childTab and #tabData.childTab > 0 then
    self.tabType = childTabType and childTabType or tabData.childTab[1].tabType
    self.childTabGroup:SetActive(true)
    self.childTabGroup:Refresh(tabData.childTab, function(data)
      self:OnChildTabSwitch(data)
    end)
    self.childTabGroup:SwitchTab(self.tabType)
    self._scrollView.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, self:GetLoopViewHeight())
    return
  else
    self.childTabGroup:SetActive(false)
    self._scrollView.rectTransform:SetSizeWithCurrentAnchors(CS.UnityEngine.RectTransform.Axis.Vertical, self:GetLoopViewHeight())
  end
  if self.tabType ~= tabData.tabType then
    self:SetRed()
    DataCenter.LWNewsCenterManager:SetRedDotId(self.tabType)
  end
  self.tabType = tabData.tabType
  self:RefreshLoopView()
end

function UILWNewsCenterView_v2:UpdateRedDotSetting()
  self.redDotSetting = not self.redDotSetting
  self.selectImg:SetActive(self.redDotSetting)
  DataCenter.LWNewsCenterManager:SetNotRedSetting(ChatNewsCenterTabType.World, self.redDotSetting)
end

function UILWNewsCenterView_v2:RefreshLoopView()
  if self.tabType == ChatNewsCenterTabType.World or self.tabType == ChatNewsCenterTabType.Alliance then
    self.itemDatas = DataCenter.LWNewsCenterManager:FilterNews(self.tabType)
    if not self.itemDatas or #self.itemDatas == 0 then
      if self.tabType == ChatNewsCenterTabType.World then
        self.txtEmpty:SetText(Localization:GetString(800933))
      else
        self.txtEmpty:SetText(Localization:GetString(800934))
      end
      self.txtEmpty:SetActive(true)
    else
      self.txtEmpty:SetActive(false)
    end
  elseif self.tabType == ChatNewsCenterTabType.StrategyGuide or self.tabType == ChatNewsCenterTabType.Announcement then
    self.itemDatas = DataCenter.LWNewsCenterManager:GetNewsCenterInfoListByType(self.tabType)
    self.itemDatas = self:GetRow(self.itemDatas)
    self.txtEmpty:SetActive(false)
  end
  self._scrollView:RefreshList(self.itemDatas, self.tabType)
end

function UILWNewsCenterView_v2:ShowFloatLike(startY, startX)
  local floatInst = CS.UnityEngine.GameObject.Instantiate(self.floatLike, self.floatLike.transform.parent)
  floatInst:SetActive(true)
  table.insert(self.floatInsts, floatInst)
  floatInst.transform.anchoredPosition = Vector2.New(startX or 0, startY - 200)
  floatInst.transform:DOAnchorPosY(startY - 100, 2)
  floatInst:GetComponent(typeof(CS.UnityEngine.CanvasGroup)):DOFade(0, 2):OnComplete(function()
    CS.UnityEngine.GameObject.Destroy(floatInst)
  end)
end

function UILWNewsCenterView_v2:ShowFloatLikeByPos(pos, isOnY)
  local floatInst = self.likeItem:GameObjectSpawn(self.floatLike.transform.parent)
  floatInst:SetActive(true)
  local group = floatInst:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  group.alpha = 1
  NameCount = NameCount + 1
  floatInst.name = "like" .. NameCount
  self:AddComponent(NewCenterLikeItem, floatInst.name)
  local parent = self.floatLike.transform.parent
  local localPoint = parent:InverseTransformPoint(pos)
  if isOnY then
    localPoint.x = 0
  end
  floatInst.transform.localPosition = localPoint
  local endPos = localPoint + Vector3.New(0, 100, 0)
  floatInst.transform:DOLocalMoveY(endPos.y, 2)
  group:DOFade(0, 2):OnComplete(function()
  end)
end

return UILWNewsCenterView_v2
