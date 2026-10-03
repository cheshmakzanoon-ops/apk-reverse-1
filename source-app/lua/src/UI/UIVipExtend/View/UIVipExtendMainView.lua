local UIVipExtendMainView = BaseClass("UIVipExtendMainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonTab = require("UI.UICommonTab.UICommonTab")
local btn_back_path = "Root/BottomBar/BtnBack"
local text_title_path = "Root/TopBar/TextTitle"
local tab_list_scroll_path = "Root/TabListScroll"
local tab_list_content_path = "Root/TabListScroll/Viewport/TabListContent"
local content_container_path = "Root/ContentContainer"
local btn_vip_service_path = "Root/BottomBar/BtnVipService"
local btn_facebook_path = "Root/BottomBar/BtnFacebook"
local facebook_icon_path = "Root/BottomBar/BtnFacebook/Icon"

function UIVipExtendMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:OnReInit()
end

function UIVipExtendMainView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIVipExtendMainView:OnEnable()
  base.OnEnable(self)
end

function UIVipExtendMainView:OnDisable()
  base.OnDisable(self)
end

function UIVipExtendMainView:ComponentDefine()
  self.content_container = self:AddComponent(UIBaseContainer, content_container_path)
  self.facebookIcon = self:AddComponent(UIImage, facebook_icon_path)
  self.text_title = self:AddComponent(UITextMeshProUGUIEx, text_title_path)
  self.text_title:SetLocalText("vip_base_skin_title1")
  self.btn_back = self:AddComponent(UIButton, btn_back_path)
  self.btn_back:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.tab_list_scroll = self:AddComponent(UILoopListView2, tab_list_scroll_path)
  self.tab_list_scroll:InitListView(0, function(loopView, index)
    return self:OnGetItemByIndex(loopView, index)
  end)
  self.tab_list_content = self:AddComponent(UIBaseContainer, tab_list_content_path)
  self.textCallAdminBtn = self:AddComponent(UIText, "Root/BottomBar/callAdminBtn/Btn/callAdminBtnText")
  self.textCallAdminBtn:SetLocalText("vip_base_skin_contact_btn")
  self.red_dot_without_num = self:AddComponent(UIBaseContainer, "Root/BottomBar/BtnVipService/RedDotWithoutNum")
  self.btn_vip_service = self:AddComponent(UIButton, btn_vip_service_path)
  self.btn_vip_service:SetOnClick(function()
    PostEventLog.Track(PostEventLog.Defines.Vip18ContactServiceClick, {contact_method = "vip_button"})
    DataCenter.LWCustomerServiceManager:OpenMessage("E018", "vip18_extend_design_aihelp_msg")
  end)
  self.btn_facebook = self:AddComponent(UIButton, btn_facebook_path)
  self.btn_facebook:SetOnClick(function()
    PostEventLog.Track(PostEventLog.Defines.Vip18ContactServiceClick, {
      contact_method = "other_button"
    })
    DataCenter.VipExtendManager:ContactUsByLanguage()
  end)
end

function UIVipExtendMainView:ComponentDestroy()
  self.tab_list_content:RemoveComponents(UICommonTab)
  self.tab_list_scroll:ClearAllItems()
  self.text_title = nil
  self.btn_back = nil
  self.tab_list_scroll = nil
  self.tab_list_content = nil
  self.btn_vip_service = nil
  self.btn_facebook = nil
  self.facebookIcon = nil
end

function UIVipExtendMainView:DataDefine()
  self.itemIndex = 0
  self.panelDic = {}
end

function UIVipExtendMainView:DataDestroy()
  self.itemIndex = nil
  self.curTabId = nil
  for i, v in pairs(self.panelDic) do
    CS.UnityEngine.GameObject.Destroy(v.root)
    v.req:Destroy()
    v.root = nil
    v.req = nil
    v.panelCpt = nil
  end
  self.panelDic = nil
end

function UIVipExtendMainView:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.VipExtendDesignRefresh, self.OnUpdateVipRedDot)
  self:AddUIListener(EventId.VipExtendDesignRedPoint, self.OnUpdateVipRedDot)
  self:AddUIListener(EventId.UpdateAIHelpRedPoint, self.OnUpdateVipRedDot)
end

function UIVipExtendMainView:OnRemoveListener()
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.VipExtendDesignRefresh, self.OnUpdateVipRedDot)
  self:RemoveUIListener(EventId.VipExtendDesignRedPoint, self.OnUpdateVipRedDot)
  self:RemoveUIListener(EventId.UpdateAIHelpRedPoint, self.OnUpdateVipRedDot)
end

function UIVipExtendMainView:OnUpdateVipRedDot()
  self:RefreshTabList()
  self:UpdateAIHelpRedPoint()
end

function UIVipExtendMainView:OnReInit()
  DataCenter.VipExtendManager:LoadInitialHistory()
  self.facebookIcon:LoadSpriteAuto(DataCenter.VipExtendManager:GetContactUsIcon())
  self.openParam = self:GetUserData()
  local defaultTabId
  if self.openParam then
    defaultTabId = self.openParam.defaultTabId
  end
  if DataCenter.VipExtendManager:IsVip18() then
    defaultTabId = self.curTabId or 1
  else
    defaultTabId = self.curTabId or 2
  end
  self:RefreshTabList()
  self:UpdateAIHelpRedPoint()
  self:CheckNewTabId(defaultTabId)
end

function UIVipExtendMainView:RefreshTabList()
  self.tabDataList = self.ctrl:GetTabDataList()
  self.tab_list_scroll:SetListItemCount(#self.tabDataList, false, false)
  self.tab_list_scroll:RefreshAllShownItem()
end

function UIVipExtendMainView:UpdateAIHelpRedPoint()
  local isVip18ContactRed = DataCenter.VipExtendManager:IsVip18ContactRed()
  if isVip18ContactRed then
    self.red_dot_without_num:SetActive(true)
  else
    self.red_dot_without_num:SetActive(false)
  end
end

function UIVipExtendMainView:OnGetItemByIndex(loopScroll, index)
  index = index + 1
  if index < 1 or index > #self.tabDataList then
    return nil
  end
  local tabData = self.tabDataList[index]
  local item = loopScroll:NewListViewItem("VipExtendTabItem")
  local script = self.tab_list_content:GetComponent(item.gameObject.name, UICommonTab)
  if script == nil then
    local objectName = tostring(self.itemIndex)
    self.itemIndex = self.itemIndex + 1
    item.gameObject.name = objectName
    if not item.IsInitHandlerCalled then
      item.IsInitHandlerCalled = true
    end
    script = self.tab_list_content:AddComponent(UICommonTab, objectName)
  end
  script:SetActive(true)
  local param = {}
  param.tabId = tabData.id
  param.title = Localization:GetString(tabData.name)
  param.clickHandler = self.OnTabClick
  param.customHolder = self
  script:ReInit(param)
  script:SetSelect(script.tabId == self.curTabId)
  script:SetRedDotVisible(DataCenter.VipExtendManager:CheckRedDotByType(script.tabId))
  return item
end

function UIVipExtendMainView:OnTabClick(tabItem)
  self:CheckNewTabId(tabItem.tabId)
end

function UIVipExtendMainView:CheckNewTabId(tabId)
  if self.curTabId ~= nil then
    if self.curTabId == tabId then
      return
    elseif self.panelDic[self.curTabId] then
      local panelData = self.panelDic[self.curTabId]
      if panelData.panelCpt ~= nil then
        panelData.panelCpt:HidePanel()
      end
      panelData.root:SetActive(false)
    end
  end
  self.curTabId = tabId
  self:RefreshTabList()
  if self.panelDic[self.curTabId] then
    local panelData = self.panelDic[self.curTabId]
    panelData.root:SetActive(true)
    if panelData.panelCpt ~= nil then
      panelData.panelCpt:ShowPanel()
    end
  else
    self:LoadPanel()
  end
  local isShowServiceBtn = self.curTabId == 1
  self.btn_vip_service:SetActive(isShowServiceBtn)
  self.btn_facebook:SetActive(isShowServiceBtn)
end

function UIVipExtendMainView:LoadPanel()
  local curTabId = self.curTabId
  local currentTabData = self.tabDataList[1]
  for i, v in pairs(self.tabDataList) do
    if v.id == curTabId then
      currentTabData = v
      break
    end
  end
  local panelData = {}
  panelData.root = CS.UnityEngine.GameObject("displayPage_" .. curTabId)
  panelData.root.transform:SetParent(self.content_container.transform)
  panelData.root.transform:Set_localScale(1, 1, 1)
  local rectTransform = panelData.root:AddComponent(typeof(CS.UnityEngine.RectTransform))
  rectTransform.pivot = Vector2.New(0.5, 0.5)
  rectTransform.anchorMin = Vector2.New(0, 0)
  rectTransform.anchorMax = Vector2.New(1, 1)
  rectTransform.offsetMin = Vector2.New(0, 0)
  rectTransform.offsetMax = Vector2.New(0, 0)
  self.panelDic[curTabId] = panelData
  self.panelDic[curTabId].req = CS.GameEntry.Resource:InstantiateAsync(currentTabData.assetPath)
  self.panelDic[curTabId].req:completed("+", function()
    local go = self.panelDic[curTabId].req.gameObject
    go.transform:SetParent(self.panelDic[curTabId].root.transform)
    go.transform:Set_localPosition(0, 0, 0)
    go.transform:Set_localScale(1, 1, 1)
    go:SetActive(true)
    local cptClass = require(currentTabData.cls)
    local nodePath = string.format("%s/%s/%s", content_container_path, self.panelDic[curTabId].root.name, go.name)
    self.panelDic[curTabId].panelCpt = self:AddComponent(cptClass, nodePath)
    self.panelDic[curTabId].panelCpt.rectTransform.offsetMin = Vector2.New(0, 0)
    self.panelDic[curTabId].panelCpt.rectTransform.offsetMax = Vector2.New(0, 0)
    self.panelDic[curTabId].panelCpt:InitPanel()
  end)
end

return UIVipExtendMainView
