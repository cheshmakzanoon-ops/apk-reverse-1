local base = UIBaseContainer
local UIPlayerDownloadCenterMainTopShell = BaseClass("UIPlayerDownloadCenterMainTopShell", UIBaseContainer)
local UIPlayerDownloadCenterMainTopItem = require("UI.PlayerDownloadCenter.UIPlayerDownloadCenterMain.Component.UIPlayerDownloadCenterMainTopItem")
local Const = require("DataCenter/PlayerDownloadCenter/PlayerDownloadCenterConstant")

function UIPlayerDownloadCenterMainTopShell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIPlayerDownloadCenterMainTopShell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPlayerDownloadCenterMainTopShell:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compRoot = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
end

function UIPlayerDownloadCenterMainTopShell:ComponentDestroy()
  self.viewSkin = nil
  self.compRoot = nil
end

function UIPlayerDownloadCenterMainTopShell:DataDefine()
  self.itemGo = nil
  self.itemScript = nil
end

function UIPlayerDownloadCenterMainTopShell:DataDestroy()
  self.compRoot:RemoveComponents(UIPlayerDownloadCenterMainTopItem)
  if self.itemGo ~= nil then
    self:GameObjectDestroy(self.itemGo)
    self.itemGo = nil
  end
  self.itemScript = nil
end

function UIPlayerDownloadCenterMainTopShell:OnAddListener()
  base.OnAddListener(self)
end

function UIPlayerDownloadCenterMainTopShell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPlayerDownloadCenterMainTopShell:SetData(downloadTabCfg)
  if self.itemScript then
    self.itemScript:SetData(downloadTabCfg)
    self.itemScript:SetActive(true)
  else
    if self.itemGo then
      self:GameObjectDestroy(self.itemGo)
    end
    self.itemGo = self:GameObjectInstantiateAsync(Const.UIPlayerDownloadCenterMainTopItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      NameCount = NameCount + 1
      go.name = "UIPlayerDownloadCenterMainTopItem" .. NameCount
      go.transform:SetParent(self.compRoot.transform)
      self.itemScript = self.compRoot:AddComponent(UIPlayerDownloadCenterMainTopItem, go.name)
      self.itemScript:SetAnchoredPositionXY(0, 0)
      self.itemScript:SetLocalScaleXYZ(1, 1, 1)
      self.itemScript:SetActive(true)
      self.itemScript:SetData(downloadTabCfg)
    end)
  end
end

return UIPlayerDownloadCenterMainTopShell
