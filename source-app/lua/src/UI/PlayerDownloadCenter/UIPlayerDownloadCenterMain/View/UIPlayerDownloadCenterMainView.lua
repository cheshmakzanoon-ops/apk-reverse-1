local UIPlayerDownloadCenterMainView = BaseClass("UIPlayerDownloadCenterMainView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local NetworkReachability = CS.UnityEngine.NetworkReachability
local Const = require("DataCenter/PlayerDownloadCenter/PlayerDownloadCenterConstant")
local UIPlayerDownloadCenterMainTopShell = require("UI.PlayerDownloadCenter.UIPlayerDownloadCenterMain.Component.UIPlayerDownloadCenterMainTopShell")
local UIPlayerDownloadCenterMainRowShell = require("UI.PlayerDownloadCenter.UIPlayerDownloadCenterMain.Component.UIPlayerDownloadCenterMainRowShell")
local LWBuyDiamondResDownloadComponent = require("UI/LWGift/BuyDiamond/Component/LWBuyDiamondResDownloadComponent")
local downloadPrefabPath = "Assets/Main/Prefabs/UI/LWGift/LWBuyDiamondDownloadResMain.prefab"

function UIPlayerDownloadCenterMainView:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  self:RefreshView()
end

function UIPlayerDownloadCenterMainView:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPlayerDownloadCenterMainView:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTopPartTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.imgConnectionState = self.viewSkin:AddComponent(self, UIImage, 2)
  self.btnInfo = self.viewSkin:AddComponent(self, UIButton, 3)
  self.btnInfo:SetOnClick(function()
    self:OnBtnInfoClick()
  end)
  self.btnBack = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnBack:SetOnClick(function()
    self:OnBtnBackClick()
  end)
  self.btnDelete = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnDelete:SetOnClick(function()
    self:OnBtnDeleteClick()
  end)
  self.btnSetting = self.viewSkin:AddComponent(self, UIButton, 6)
  self.btnSetting:SetOnClick(function()
    self:OnBtnSettingClick()
  end)
  self.textDownloadedSize = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 7)
  self.scrollRectMiddlePart = self.viewSkin:AddComponent(self, UIScrollRect, 8)
  self.scrollMiddlePart = self.viewSkin:AddComponent(self, UILoopListView2, 9)
  self.scrollContent = self.viewSkin:AddComponent(self, UIBaseContainer, 10)
  self.compDownloadResContentContainer = self.viewSkin:AddComponent(self, UIBaseContainer, 11)
  self.compDownloadedSizeBg = self.viewSkin:AddComponent(self, UIBaseComponent, 12)
  self.btnPanel = self.viewSkin:AddComponent(self, UIButton, 13)
  self.btnPanel:SetOnClick(function()
    self:OnBtnBackClick()
  end)
end

function UIPlayerDownloadCenterMainView:ComponentDestroy()
  self.viewSkin = nil
  self.textTopPartTitle = nil
  self.imgConnectionState = nil
  self.btnInfo = nil
  self.btnBack = nil
  self.btnDelete = nil
  self.btnSetting = nil
  self.textDownloadedSize = nil
  self.scrollRectMiddlePart = nil
  self.scrollMiddlePart = nil
  self.scrollContent = nil
  self.compDownloadResContentContainer = nil
  self.compDownloadedSizeBg = nil
  self.btnPanel = nil
end

function UIPlayerDownloadCenterMainView:DataDefine()
  self.connectionState = -1
  self.downloadTabCfgList = {}
  local pageCfgList = DataCenter.PlayerDownloadCenterManager:GetDownloadTabCfgList()
  local index = 1
  if pageCfgList[1].position == 1 then
    self.downloadTabCfgList[1] = pageCfgList[1]
    index = 2
  end
  for i = index, #pageCfgList, 2 do
    self.downloadTabCfgList[index] = {
      pageCfgList[i],
      pageCfgList[i + 1]
    }
    index = index + 1
  end
  self.itemScriptDic = {}
  self.scrollMiddlePart:InitListViewParam2(0, function(listview, index)
    return self:OnGetItemByIndex(listview, index)
  end, nil, nil, function(loopListViewItem)
    self:OnRecycleItemFunc(loopListViewItem)
  end)
  self.isResourceDownloaded = false
  self.downloadResRequest = nil
end

function UIPlayerDownloadCenterMainView:DataDestroy()
  self.connectionState = -1
  self.downloadTabCfgList = nil
  self.itemScriptDic = {}
  self.scrollContent:RemoveComponents(UIPlayerDownloadCenterMainTopShell)
  self.scrollContent:RemoveComponents(UIPlayerDownloadCenterMainRowShell)
  self.scrollMiddlePart:ClearAllItems()
  self.isResourceDownloaded = false
  if self.downloadResRequest then
    self:GameObjectDestroy(self.downloadResRequest)
  end
end

function UIPlayerDownloadCenterMainView:OnAddListener()
  base.OnAddListener(self)
end

function UIPlayerDownloadCenterMainView:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPlayerDownloadCenterMainView:RefreshView()
  self.textTopPartTitle:SetLocalText("download_center_title")
  self.scrollRectMiddlePart:StopMovement()
  self.scrollRectMiddlePart:SetVerticalNormalizedPosition(1)
  self.isResourceDownloaded = CS.ResourcePackageManager.IsPackageDownloaded(20243)
  self.btnSetting:SetActive(self.isResourceDownloaded)
  self.btnDelete:SetActive(self.isResourceDownloaded)
  self.scrollMiddlePart:SetActive(self.isResourceDownloaded)
  self.compDownloadedSizeBg:SetActive(self.isResourceDownloaded)
  self.imgConnectionState:SetActive(self.isResourceDownloaded)
  self.compDownloadResContentContainer:SetActive(not self.isResourceDownloaded)
  if self.isResourceDownloaded then
    self:RefreshConnectionState()
    self:RefreshTotalDownloadedSize()
    self.scrollMiddlePart:SetListItemCount(#self.downloadTabCfgList, false, false)
    self.scrollMiddlePart:RefreshAllShownItem()
  else
    self:ShowDownloadComponentState()
  end
end

function UIPlayerDownloadCenterMainView:RefreshConnectionState()
  local networkType = DataCenter.PlayerDownloadCenterManager:GetNetworkType()
  if self.connectionState == networkType then
    return
  end
  self.connectionState = networkType
  if not CS.GameEntry.Network.IsConnected or self.connectionState == NetworkReachability.ReachableViaCarrierDataNetwork or self.connectionState == NetworkReachability.NotReachable then
    self.imgConnectionState:LoadSpriteAsync(Const.ImgConnection4GPath)
  elseif self.connectionState == NetworkReachability.ReachableViaLocalAreaNetwork then
    self.imgConnectionState:LoadSpriteAsync(Const.ImgConnectionWifiPath)
  end
end

function UIPlayerDownloadCenterMainView:RefreshTotalDownloadedSize()
  local sumSize = DataCenter.PlayerDownloadCenterManager:GetAllTabDownloadedSumSize()
  self.textDownloadedSize:SetText(Localization:GetString("download_center_size_desc", sumSize))
end

function UIPlayerDownloadCenterMainView:ShowDownloadComponentState()
  if self.downloadResRequest == nil then
    self.downloadResRequest = self:GameObjectInstantiateAsync(downloadPrefabPath, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      go.transform:SetParent(self.compDownloadResContentContainer.transform)
      go.transform:Set_localScale(1, 1, 1)
      self.downloadResComp = self.compDownloadResContentContainer:AddComponent(LWBuyDiamondResDownloadComponent, go.name)
      self.downloadResComp:SetOffsetMinXY(0, 0)
      self.downloadResComp:SetOffsetMaxXY(0, 0)
      self.downloadResComp:SetPackageCfgIdListData({90001}, function()
        self:RefreshView()
      end)
    end)
  end
end

function UIPlayerDownloadCenterMainView:OnGetItemByIndex(listview, index)
  if index < 0 or index >= #self.downloadTabCfgList then
    return nil
  end
  index = index + 1
  local prefabName = self:GetItemPrefabName(self.downloadTabCfgList[index])
  if string.IsNullOrEmpty(prefabName) then
    Logger.LogError("UIPlayerDownloadCenterMainView \230\187\145\229\138\168\229\136\151\232\161\168\232\142\183\229\143\150\233\162\132\229\136\182\229\144\141\228\184\186\231\169\186 \239\188\154" .. tostring(index))
    return nil
  end
  local item = listview:NewListViewItem(prefabName)
  if item == nil then
    Logger.LogError("UIPlayerDownloadCenterMainView \230\187\145\229\138\168\229\136\151\232\161\168\232\142\183\229\143\150Item\228\184\186\231\169\186 \239\188\154" .. tostring(index))
    return nil
  end
  local temp = self.itemScriptDic[item]
  if temp == nil then
    local script = self:GetChatItemScriptName(self.downloadTabCfgList[index])
    NameCount = NameCount + 1
    item.gameObject.name = item.gameObject.name .. tostring(NameCount)
    temp = self.scrollContent:AddComponent(script, item.gameObject)
    temp:SetActive(true)
    self.itemScriptDic[item] = temp
  end
  temp:SetActive(true)
  temp:SetData(self.downloadTabCfgList[index])
  return item
end

function UIPlayerDownloadCenterMainView:OnRecycleItemFunc(loopListViewItem)
end

function UIPlayerDownloadCenterMainView:GetItemPrefabName(downloadTabCfg)
  if downloadTabCfg.position == 1 then
    return "UIPlayerDownloadCenterMainTopShell"
  else
    return "UIPlayerDownloadCenterMainRowShell"
  end
  return ""
end

function UIPlayerDownloadCenterMainView:GetChatItemScriptName(downloadTabCfg)
  if downloadTabCfg.position == 1 then
    return UIPlayerDownloadCenterMainTopShell
  else
    return UIPlayerDownloadCenterMainRowShell
  end
  return nil
end

function UIPlayerDownloadCenterMainView:Update1000MS()
  if not self.isResourceDownloaded then
    return
  end
  self:RefreshConnectionState()
  self:RefreshTotalDownloadedSize()
  EventManager:GetInstance():Broadcast(EventId.RefreshPlayerDownloadCenterProgress)
end

function UIPlayerDownloadCenterMainView:OnBtnInfoClick()
  local param = {}
  param.activityRulesStr = Localization:GetString("download_center_info")
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityDetailPopup, {anim = true}, param)
end

function UIPlayerDownloadCenterMainView:OnBtnBackClick()
  self.ctrl.CloseSelf()
end

function UIPlayerDownloadCenterMainView:OnBtnDeleteClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerDownloadCenterDeleteList)
end

function UIPlayerDownloadCenterMainView:OnBtnSettingClick()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerDownloadCenterSetting)
end

return UIPlayerDownloadCenterMainView
