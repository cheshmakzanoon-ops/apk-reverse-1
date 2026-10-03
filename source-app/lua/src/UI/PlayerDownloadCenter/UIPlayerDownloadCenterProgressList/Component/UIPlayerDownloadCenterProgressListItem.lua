local base = UIBaseContainer
local UIPlayerDownloadCenterProgressListItem = BaseClass("UIPlayerDownloadCenterProgressListItem", UIBaseContainer)
local UIPlayerDownloadCenterCircleProgressBar = require("UI.PlayerDownloadCenter.UIPlayerDownloadCenterMain.Component.UIPlayerDownloadCenterCircleProgressBar")
local Const = require("DataCenter/PlayerDownloadCenter/PlayerDownloadCenterConstant")
local Localization = CS.GameEntry.Localization
local ResGroupManager = CS.DownloadResGroupCommonManager.Instance

function UIPlayerDownloadCenterProgressListItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIPlayerDownloadCenterProgressListItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPlayerDownloadCenterProgressListItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compProgressBar = self.viewSkin:AddComponent(self, UIPlayerDownloadCenterCircleProgressBar, 1)
  self.textPackageDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textPackageProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compPackageNoIconBg = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compPackageIconBg = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.imgPackageIcon = self.viewSkin:AddComponent(self, UIImage, 6)
end

function UIPlayerDownloadCenterProgressListItem:ComponentDestroy()
  self.viewSkin = nil
  self.compProgressBar = nil
  self.textPackageDesc = nil
  self.textPackageProgress = nil
  self.compPackageNoIconBg = nil
  self.compPackageIconBg = nil
  self.imgPackageIcon = nil
end

function UIPlayerDownloadCenterProgressListItem:DataDefine()
end

function UIPlayerDownloadCenterProgressListItem:DataDestroy()
end

function UIPlayerDownloadCenterProgressListItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshPlayerDownloadProgressListItem, self.RefreshDownloadProgress)
end

function UIPlayerDownloadCenterProgressListItem:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshPlayerDownloadProgressListItem, self.RefreshDownloadProgress)
  base.OnRemoveListener(self)
end

function UIPlayerDownloadCenterProgressListItem:SetData(showItemData)
  local packageCfg = showItemData.packageCfg
  self.packageCfgId = packageCfg.id
  
  local function btnProgressBarClickCallback()
    local isDeleting = ResGroupManager:IsAnyPackageDeleting()
    if isDeleting then
      UIUtil.ShowTipsId("download_center_tips_delecting")
      return
    end
    local downloadPackageState = DataCenter.PlayerDownloadCenterManager:GetDownloadPackageState(self.packageCfgId)
    if downloadPackageState == Const.DownloadState.Completed then
    elseif downloadPackageState == Const.DownloadState.Paused then
      DataCenter.PlayerDownloadCenterManager:SetPackageManualOperateType(self.packageCfgId, Const.ManualOperateType.Downloading)
      DataCenter.PlayerDownloadCenterManager:TryStartDownloadPackage(self.packageCfgId)
    elseif downloadPackageState == Const.DownloadState.Downloading then
      DataCenter.PlayerDownloadCenterManager:SetPackageManualOperateType(self.packageCfgId, Const.ManualOperateType.Paused)
      DataCenter.PlayerDownloadCenterManager:TryStopDownloadPackage(self.packageCfgId)
    end
    downloadPackageState = DataCenter.PlayerDownloadCenterManager:GetDownloadPackageState(self.packageCfgId)
    self.compProgressBar:SetBarState(downloadPackageState)
    self.compProgressBar:SetDeleteState()
    self:RefreshDownloadProgress({
      packageCfgId = self.packageCfgId
    })
    self.view:RefreshBtnState()
  end
  
  self.compProgressBar:SetBtnProgressBarClickCallback(btnProgressBarClickCallback)
  self.textPackageDesc:SetLocalText(packageCfg.name)
  local hasIcon = not string.IsNullOrEmpty(packageCfg.icon)
  self.compPackageNoIconBg:SetActive(not hasIcon)
  self.compPackageIconBg:SetActive(hasIcon)
  self.imgPackageIcon:SetActive(hasIcon)
  if hasIcon then
    self.imgPackageIcon:LoadSpriteAsync(packageCfg.icon)
  end
  self.textPackageProgress:SetAlignment(CommonUtil.IsArabic() and CS.TMPro.TextAlignmentOptions.MidlineRight or CS.TMPro.TextAlignmentOptions.MidlineLeft)
  self:RefreshDownloadProgress({
    packageCfgId = self.packageCfgId
  })
end

function UIPlayerDownloadCenterProgressListItem:RefreshDownloadProgress(msg)
  if msg.packageCfgId == -1 or msg.packageCfgId == self.packageCfgId then
    local resGroupData = DataCenter.PlayerDownloadCenterManager:GetResGroupData(self.packageCfgId)
    local downloadPackageState = DataCenter.PlayerDownloadCenterManager:GetDownloadPackageState(self.packageCfgId)
    self.compProgressBar:SetBarState(downloadPackageState)
    self.compProgressBar:SetDeleteState()
    local curResGroupSize = DataCenter.PlayerDownloadCenterManager:GetShowDownloadProgress(resGroupData)
    if resGroupData.totalSize == 0 then
      self.compProgressBar:SetBarProgress(0)
    else
      self.compProgressBar:SetBarProgress(curResGroupSize / resGroupData.totalSize)
    end
    local processMbStr = DataCenter.PlayerDownloadCenterManager:GetPackageProcessMbStr(resGroupData)
    self.textPackageProgress:SetText(processMbStr)
  end
end

return UIPlayerDownloadCenterProgressListItem
