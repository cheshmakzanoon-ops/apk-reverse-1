local UIPlayerDownloadCenterMainRowShell = BaseClass("UIPlayerDownloadCenterMainRowShell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Const = require("DataCenter/PlayerDownloadCenter/PlayerDownloadCenterConstant")
local UIPlayerDownloadCenterMainRowItem = require("UI.PlayerDownloadCenter.UIPlayerDownloadCenterMain.Component.UIPlayerDownloadCenterMainRowItem")

function UIPlayerDownloadCenterMainRowShell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIPlayerDownloadCenterMainRowShell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIPlayerDownloadCenterMainRowShell:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compPos2 = self.viewSkin:AddComponent(self, UIBaseContainer, 1)
  self.compPos1 = self.viewSkin:AddComponent(self, UIBaseContainer, 2)
end

function UIPlayerDownloadCenterMainRowShell:ComponentDestroy()
  self.viewSkin = nil
  self.compPos2 = nil
  self.compPos1 = nil
end

function UIPlayerDownloadCenterMainRowShell:DataDefine()
  self.itemGoLoadReqList = {}
  self.itemScriptList = {}
end

function UIPlayerDownloadCenterMainRowShell:DataDestroy()
  self.compPos2:RemoveComponents(UIPlayerDownloadCenterMainRowItem)
  self.compPos1:RemoveComponents(UIPlayerDownloadCenterMainRowItem)
  if self.itemGoLoadReqList ~= nil then
    for _, req in ipairs(self.itemGoLoadReqList) do
      if req ~= nil then
        self:GameObjectDestroy(req)
      end
    end
  end
  self.itemScriptList = nil
end

function UIPlayerDownloadCenterMainRowShell:OnAddListener()
  base.OnAddListener(self)
end

function UIPlayerDownloadCenterMainRowShell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIPlayerDownloadCenterMainRowShell:SetData(centerPageCfgList)
  if centerPageCfgList == nil then
    return
  end
  self.centerPageCfgList = centerPageCfgList
  for i = 1, #centerPageCfgList do
    self:GenerateItem(i, centerPageCfgList[i])
  end
  if #centerPageCfgList < 2 then
    if self.itemScriptList[2] then
      self.itemScriptList[2]:SetActive(false)
    elseif self.itemGoLoadReqList[2] then
      self:GameObjectDestroy(self.itemGoLoadReqList[2])
    end
  end
end

function UIPlayerDownloadCenterMainRowShell:GenerateItem(i, downloadTabCfg)
  if self.itemScriptList[i] then
    self.itemScriptList[i]:SetData(downloadTabCfg)
    self.itemScriptList[i]:SetActive(true)
  else
    if self.itemGoLoadReqList[i] then
      self:GameObjectDestroy(self.itemGoLoadReqList[i])
    end
    self.itemGoLoadReqList[i] = self:GameObjectInstantiateAsync(Const.UIPlayerDownloadCenterMainRowItem, function(request)
      if request.isError then
        return
      end
      local go = request.gameObject
      NameCount = NameCount + 1
      go.name = "UIPlayerDownloadCenterMainRowItem" .. NameCount
      local compPos = self["compPos" .. i]
      go.transform:SetParent(compPos.transform)
      self.itemScriptList[i] = compPos:AddComponent(UIPlayerDownloadCenterMainRowItem, go.name)
      self.itemScriptList[i]:SetAnchoredPositionXY(0, 0)
      self.itemScriptList[i]:SetLocalScaleXYZ(1, 1, 1)
      self.itemScriptList[i]:SetActive(true)
      self.itemScriptList[i]:SetData(downloadTabCfg)
    end)
  end
end

return UIPlayerDownloadCenterMainRowShell
