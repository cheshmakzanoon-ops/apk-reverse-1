local base = UIBaseContainer
local UISearchFovServerItem = BaseClass("UISearchFovServerItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UISearchFovServerItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UISearchFovServerItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISearchFovServerItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compImgSelection = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.textTmpFront = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTmpBack = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.btnUISearchFovServerItem = self.viewSkin:AddComponent(self, UIButton, 4)
  self.btnUISearchFovServerItem:SetOnClick(function()
    self:OnBtnUISearchFovServerItemClick()
  end)
end

function UISearchFovServerItem:ComponentDestroy()
  self.viewSkin = nil
  self.compImgSelection = nil
  self.textTmpFront = nil
  self.textTmpBack = nil
  self.btnUISearchFovServerItem = nil
end

function UISearchFovServerItem:DataDefine()
end

function UISearchFovServerItem:DataDestroy()
end

function UISearchFovServerItem:OnAddListener()
  base.OnAddListener(self)
end

function UISearchFovServerItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UISearchFovServerItem:ReInit(host, index, serverId)
  self.host = host
  self.index = index
  self.serverId = serverId
  if serverId == -1 then
    self.textTmpFront:SetLocalText(151110)
    self.textTmpBack:SetLocalText(151110)
  else
    local _ = UIUtil.FormatServerName(serverId)
    self.textTmpFront:SetText(_)
    self.textTmpBack:SetText(_)
  end
end

function UISearchFovServerItem:UpdateCurrentSelected(currentSelectedServer)
  self.compImgSelection:SetActive(currentSelectedServer == self.serverId)
end

function UISearchFovServerItem:OnBtnUISearchFovServerItemClick()
  if self.host then
    self.host:OnClickedServer(self.serverId)
  end
end

return UISearchFovServerItem
