local base = UIBaseContainer
local UIPlayerDownloadCenterDeleteListItem = BaseClass("UIPlayerDownloadCenterDeleteListItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/PlayerDownloadCenter/PlayerDownloadCenterConstant")

function UIPlayerDownloadCenterDeleteListItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIPlayerDownloadCenterDeleteListItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPlayerDownloadCenterDeleteListItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textPackageDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textPackageProgress = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.toggleIsCheck = self.viewSkin:AddComponent(self, UIToggle, 3)
  self.compDeleting = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
end

function UIPlayerDownloadCenterDeleteListItem:ComponentDestroy()
  self.viewSkin = nil
  self.textPackageDesc = nil
  self.textPackageProgress = nil
  self.toggleIsCheck = nil
  self.compDeleting = nil
end

function UIPlayerDownloadCenterDeleteListItem:DataDefine()
end

function UIPlayerDownloadCenterDeleteListItem:DataDestroy()
end

function UIPlayerDownloadCenterDeleteListItem:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.RefreshPlayerDownloadDeletePackage, self.SetToggleState)
end

function UIPlayerDownloadCenterDeleteListItem:OnRemoveListener()
  self:RemoveUIListener(EventId.RefreshPlayerDownloadDeletePackage, self.SetToggleState)
  base.OnRemoveListener(self)
end

function UIPlayerDownloadCenterDeleteListItem:SetData(showItemData)
  self.packageCfg = showItemData.packageCfg
  self.curTabIndex = showItemData.curTabIndex
  self.textPackageDesc:SetLocalText(self.packageCfg.name)
  self.toggleIsCheck:SetOnValueChanged(function(isOn)
    self:SetToggleState({
      setWithNotify = true,
      isOn = isOn,
      curTabIndex = self.curTabIndex
    })
    DataCenter.PlayerDownloadCenterManager:SetToggleDeletePackageDic(self.packageCfg.id, isOn)
  end)
  self:RefreshDeleteState()
end

function UIPlayerDownloadCenterDeleteListItem:RefreshDeleteState()
  local resGroupData = DataCenter.PlayerDownloadCenterManager:GetResGroupData(self.packageCfg.id)
  local processMbStr = DataCenter.PlayerDownloadCenterManager:GetPackageProcessMbStr(resGroupData)
  self.textPackageProgress:SetText(processMbStr)
  local downloadPackageState = DataCenter.PlayerDownloadCenterManager:GetDownloadPackageState(self.packageCfg.id)
  self.compDeleting:SetActive(downloadPackageState == Const.DownloadState.Deleting)
  self.toggleIsCheck:SetActive(downloadPackageState ~= Const.DownloadState.Deleting)
end

function UIPlayerDownloadCenterDeleteListItem:SetToggleState(data)
  if self.curTabIndex ~= data.curTabIndex then
    return
  end
  if data.setWithNotify then
    self.toggleIsCheck:SetIsOn(data.isOn)
  else
    self.toggleIsCheck:SetIsOnWithoutNotify(data.isOn)
  end
end

function UIPlayerDownloadCenterDeleteListItem:OnRecycleItem()
  if self.toggleIsCheck then
    self.toggleIsCheck:SetIsOnWithoutNotify(false)
    self.compDeleting:SetActive(false)
    self.toggleIsCheck:SetActive(false)
  end
end

return UIPlayerDownloadCenterDeleteListItem
