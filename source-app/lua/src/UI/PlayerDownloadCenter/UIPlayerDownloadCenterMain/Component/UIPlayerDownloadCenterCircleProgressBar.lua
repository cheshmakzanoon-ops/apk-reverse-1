local base = UIBaseContainer
local UIPlayerDownloadCenterCircleProgressBar = BaseClass("UIPlayerDownloadCenterCircleProgressBar", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/PlayerDownloadCenter/PlayerDownloadCenterConstant")

function UIPlayerDownloadCenterCircleProgressBar:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIPlayerDownloadCenterCircleProgressBar:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPlayerDownloadCenterCircleProgressBar:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnProgressBar = self.viewSkin:AddComponent(self, UIButton, 1)
  self.btnProgressBar:SetOnClick(function()
    self:OnBtnProgressBarClick()
  end)
  self.imgProgressBar = self.viewSkin:AddComponent(self, UIImage, 2)
  self.textProgressDesc = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compStart = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compPause = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.compCompleted = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.compDeleting = self.viewSkin:AddComponent(self, UIBaseContainer, 7)
  self.compBg = self.viewSkin:AddComponent(self, UIBaseContainer, 8)
  self.imgRoot = self.viewSkin:AddComponent(self, UIImage, 9)
end

function UIPlayerDownloadCenterCircleProgressBar:ComponentDestroy()
  self.viewSkin = nil
  self.btnProgressBar = nil
  self.imgProgressBar = nil
  self.textProgressDesc = nil
  self.compStart = nil
  self.compPause = nil
  self.compCompleted = nil
  self.compDeleting = nil
  self.compBg = nil
  self.imgRoot = nil
end

function UIPlayerDownloadCenterCircleProgressBar:DataDefine()
  self.curBarState = Const.DownloadState.None
end

function UIPlayerDownloadCenterCircleProgressBar:DataDestroy()
  self.curBarState = nil
end

function UIPlayerDownloadCenterCircleProgressBar:OnAddListener()
  base.OnAddListener(self)
end

function UIPlayerDownloadCenterCircleProgressBar:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPlayerDownloadCenterCircleProgressBar:SetBarState(state)
  if self.curBarState == state then
    return
  end
  self.curBarState = state
  self.compStart:SetActive(self.curBarState == Const.DownloadState.Paused)
  self.textProgressDesc:SetActive(self.curBarState == Const.DownloadState.Downloading)
  self.compPause:SetActive(false)
  self.compCompleted:SetActive(self.curBarState == Const.DownloadState.Completed)
  self.imgProgressBar:SetActive(true)
  self.compDeleting:SetActive(false)
  self.compBg:SetActive(true)
  self.imgRoot:SetEnable(true)
end

function UIPlayerDownloadCenterCircleProgressBar:SetDeleteState()
  self.imgProgressBar:SetActive(self.curBarState ~= Const.DownloadState.Deleting)
  self.compDeleting:SetActive(self.curBarState == Const.DownloadState.Deleting)
  self.compBg:SetActive(self.curBarState ~= Const.DownloadState.Deleting)
  self.imgRoot:SetEnable(self.curBarState ~= Const.DownloadState.Deleting)
end

function UIPlayerDownloadCenterCircleProgressBar:SetBarProgress(progress)
  self.imgProgressBar:SetFillAmount(progress or 0)
  self.textProgressDesc:SetText(math.floor((progress or 0) * 100) .. "%")
end

function UIPlayerDownloadCenterCircleProgressBar:SetBtnProgressBarClickCallback(callback)
  self.btnProgressBarClickCallback = callback
end

function UIPlayerDownloadCenterCircleProgressBar:OnBtnProgressBarClick()
  if self.btnProgressBarClickCallback then
    self.btnProgressBarClickCallback()
  end
end

return UIPlayerDownloadCenterCircleProgressBar
