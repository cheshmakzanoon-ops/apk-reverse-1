local base = UIAsyncContainer
local SaleItemComponent = BaseClass("SaleItemComponent", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function SaleItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SaleItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SaleItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.btnUIPlayerHead = self.viewSkin:AddComponent(self, UICommonHead, 1)
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textPrice = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textCount = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnUIPlayerHead:SetEnableClickShowInfo(true, true)
end

function SaleItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.btnUIPlayerHead = nil
  self.textName = nil
  self.textPrice = nil
  self.textCount = nil
end

function SaleItemComponent:DataDefine()
end

function SaleItemComponent:DataDestroy()
  self.data = nil
end

function SaleItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function SaleItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SaleItemComponent:SetData(data)
  self.data = data
end

function SaleItemComponent:UpdateData()
  self.btnUIPlayerHead:ParseHeadInfo(self.data)
  self.textPrice:SetText(string.GetFormattedSeparatorNum(self.data.price))
  self.textCount:SetText(string.GetFormattedSeparatorNum(self.data.num))
  local serverStr = self.data.serverId and self.data.serverId > 0 and string.format("#%s", self.data.serverId) or ""
  local abbrStr = self.data.abbr and self.data.abbr ~= "" and string.format("[%s]", self.data.abbr) or ""
  local nameStr = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.data.uid, self.data.name)
  self.textName:SetText(string.format([[
%s %s
%s]], serverStr, abbrStr, nameStr))
end

return SaleItemComponent
