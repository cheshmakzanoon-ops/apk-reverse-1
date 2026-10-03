local base = UIBaseContainer
local UIPlayerDownloadCenterMainTopItem = BaseClass("UIPlayerDownloadCenterMainTopItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local ResGroupManager = CS.DownloadResGroupCommonManager.Instance
local UIPlayerDownloadCenterCircleProgressBar = require("UI.PlayerDownloadCenter.UIPlayerDownloadCenterMain.Component.UIPlayerDownloadCenterCircleProgressBar")
local Const = require("DataCenter/PlayerDownloadCenter/PlayerDownloadCenterConstant")

function UIPlayerDownloadCenterMainTopItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIPlayerDownloadCenterMainTopItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPlayerDownloadCenterMainTopItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.rawImgTopPackageItemBg = self.viewSkin:AddComponent(self, UIRawImage, 1)
  self.textTopPackageTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTopPackageDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.sliderTopLinearProgressBar = self.viewSkin:AddComponent(self, UISlider, 4)
  self.textLinearProgressBarDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.compProgressBar = self.viewSkin:AddComponent(self, UIPlayerDownloadCenterCircleProgressBar, 6)
  self.btnClickItem = self.viewSkin:AddComponent(self, UIButton, 7)
  self.btnClickItem:SetOnClick(function()
    self:OnBtnClickItem()
  end)
end

function UIPlayerDownloadCenterMainTopItem:ComponentDestroy()
  self.viewSkin = nil
  self.rawImgTopPackageItemBg = nil
  self.textTopPackageTitle = nil
  self.textTopPackageDesc = nil
  self.sliderTopLinearProgressBar = nil
  self.textLinearProgressBarDesc = nil
  self.compProgressBar = nil
  self.btnClickItem = nil
end

function UIPlayerDownloadCenterMainTopItem:DataDefine()
end

function UIPlayerDownloadCenterMainTopItem:DataDestroy()
end

function UIPlayerDownloadCenterMainTopItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshPlayerDownloadCenterProgress, self.RefreshDownloadProgress)
end

function UIPlayerDownloadCenterMainTopItem:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshPlayerDownloadCenterProgress, self.RefreshDownloadProgress)
  base.OnRemoveListener(self)
end

function UIPlayerDownloadCenterMainTopItem:SetData(downloadTabCfg)
  if downloadTabCfg == nil then
    return
  end
  self.downloadTabCfg = downloadTabCfg
  self.tabCfgId = downloadTabCfg.id
  self.rawImgTopPackageItemBg:LoadSpriteAsync(downloadTabCfg.icon)
  self.textTopPackageTitle:SetLocalText(downloadTabCfg.name)
  self.textTopPackageDesc:SetLocalText(downloadTabCfg.desc)
  
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

function UIPlayerDownloadCenterMainTopItem:RefreshDownloadProgress()
  local tabDownloadState = DataCenter.PlayerDownloadCenterManager:GetTabDownloadState(self.tabCfgId)
  self.compProgressBar:SetBarState(tabDownloadState)
  local downloadedSizeDic, tabTotalSizeDic = DataCenter.PlayerDownloadCenterManager:GetAllTabProgressData()
  local downloadedSize = downloadedSizeDic[self.tabCfgId] or 0
  local tabTotalSize = tabTotalSizeDic[self.tabCfgId] or 0
  if tabTotalSize == 0 then
    self.compProgressBar:SetBarProgress(0)
    self.sliderTopLinearProgressBar:SetValue(0)
  else
    self.compProgressBar:SetBarProgress(downloadedSize / tabTotalSize)
    self.sliderTopLinearProgressBar:SetValue(downloadedSize / tabTotalSize)
  end
  local downloadedSizeStr = DataCenter.PlayerDownloadCenterManager:ByteToMegaByte(downloadedSize)
  local tabTotalSizeStr = DataCenter.PlayerDownloadCenterManager:ByteToMegaByte(tabTotalSize)
  local processMbStr = string.format("%s/%s", downloadedSizeStr, tabTotalSizeStr)
  self.textLinearProgressBarDesc:SetText(processMbStr)
end

function UIPlayerDownloadCenterMainTopItem:OnBtnClickItem()
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIPlayerDownloadCenterProgressList, {anim = false}, self.downloadTabCfg)
end

return UIPlayerDownloadCenterMainTopItem
