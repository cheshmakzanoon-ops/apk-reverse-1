local UIPlayerDownloadCenterMainRowItem = BaseClass("UIPlayerDownloadCenterMainRowItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ResGroupManager = CS.DownloadResGroupCommonManager.Instance
local UIPlayerDownloadCenterCircleProgressBar = require("UI.PlayerDownloadCenter.UIPlayerDownloadCenterMain.Component.UIPlayerDownloadCenterCircleProgressBar")
local Const = require("DataCenter/PlayerDownloadCenter/PlayerDownloadCenterConstant")

function UIPlayerDownloadCenterMainRowItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIPlayerDownloadCenterMainRowItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPlayerDownloadCenterMainRowItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgBg = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compProgressBar = self.viewSkin:AddComponent(self, UIPlayerDownloadCenterCircleProgressBar, 3)
  self.textProgressBarDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnClickItem = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnClickItem:SetOnClick(function()
    self:OnBtnClickItem()
  end)
end

function UIPlayerDownloadCenterMainRowItem:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgBg = nil
  self.textTitle = nil
  self.compProgressBar = nil
  self.textProgressBarDesc = nil
  self.btnClickItem = nil
end

function UIPlayerDownloadCenterMainRowItem:DataDefine()
end

function UIPlayerDownloadCenterMainRowItem:DataDestroy()
end

function UIPlayerDownloadCenterMainRowItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshPlayerDownloadCenterProgress, self.RefreshDownloadProgress)
end

function UIPlayerDownloadCenterMainRowItem:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshPlayerDownloadCenterProgress, self.RefreshDownloadProgress)
  base.OnRemoveListener(self)
end

function UIPlayerDownloadCenterMainRowItem:SetData(downloadTabCfg)
  if downloadTabCfg == nil then
    return
  end
  self.downloadTabCfg = downloadTabCfg
  self.tabCfgId = downloadTabCfg.id
  self.rawImgBg:LoadSpriteAsync(downloadTabCfg.icon)
  self.textTitle:SetLocalText(downloadTabCfg.name)
  
  local function btnProgressBarClickCallback()
    local isDeleting = ResGroupManager:IsAnyPackageDeleting()
    if isDeleting then
      UIUtil.ShowTipsId("download_center_tips_delecting")
      return
    end
    local tabDownloadState = DataCenter.PlayerDownloadCenterManager:GetTabDownloadState(self.tabCfgId)
    if tabDownloadState == Const.DownloadState.Completed then
    elseif tabDownloadState == Const.DownloadState.Paused then
      DataCenter.PlayerDownloadCenterManager:StartAllTabPackageDownload(self.tabCfgId)
    elseif tabDownloadState == Const.DownloadState.Downloading then
      DataCenter.PlayerDownloadCenterManager:PauseAllTabPackageDownload(self.tabCfgId)
    end
    tabDownloadState = DataCenter.PlayerDownloadCenterManager:GetTabDownloadState(self.tabCfgId)
    self.compProgressBar:SetBarState(tabDownloadState)
  end
  
  self.compProgressBar:SetBtnProgressBarClickCallback(btnProgressBarClickCallback)
  self:RefreshDownloadProgress()
end

function UIPlayerDownloadCenterMainRowItem:RefreshDownloadProgress()
  local tabDownloadState = DataCenter.PlayerDownloadCenterManager:GetTabDownloadState(self.tabCfgId)
  self.compProgressBar:SetBarState(tabDownloadState)
  local downloadedSizeDic, tabTotalSizeDic = DataCenter.PlayerDownloadCenterManager:GetAllTabProgressData()
  local downloadedSize = downloadedSizeDic[self.tabCfgId] or 0
  local tabTotalSize = tabTotalSizeDic[self.tabCfgId] or 0
  if tabTotalSize == 0 then
    self.compProgressBar:SetBarProgress(0)
  else
    self.compProgressBar:SetBarProgress(downloadedSize / tabTotalSize)
  end
  local downloadedSizeStr = DataCenter.PlayerDownloadCenterManager:ByteToMegaByte(downloadedSize)
  local tabTotalSizeStr = DataCenter.PlayerDownloadCenterManager:ByteToMegaByte(tabTotalSize)
  local processMbStr = string.format("%s/%s", downloadedSizeStr, tabTotalSizeStr)
  self.textProgressBarDesc:SetText(processMbStr)
end

function UIPlayerDownloadCenterMainRowItem:OnBtnClickItem()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerDownloadCenterProgressList, {anim = false}, self.downloadTabCfg)
end

return UIPlayerDownloadCenterMainRowItem
