local base = UIBaseContainer
local UIActValentineMatchHeadItem = BaseClass("UIActValentineMatchHeadItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UIPlayerHead = require("Framework.UI.Component.UIPlayerHead")

function UIActValentineMatchHeadItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActValentineMatchHeadItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIActValentineMatchHeadItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compHeadIcon = self.viewSkin:AddComponent(self, UIPlayerHead, 1)
end

function UIActValentineMatchHeadItem:ComponentDestroy()
  self.compHeadIcon = nil
end

function UIActValentineMatchHeadItem:DataDefine()
end

function UIActValentineMatchHeadItem:DataDestroy()
end

function UIActValentineMatchHeadItem:OnAddListener()
  base.OnAddListener(self)
end

function UIActValentineMatchHeadItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIActValentineMatchHeadItem:SetData(playerInfo)
  self:SetHead(playerInfo)
end

function UIActValentineMatchHeadItem:SetHead(playerInfo)
  if not playerInfo then
    return
  end
  local uid = playerInfo.uid or 0
  local pic = playerInfo.pic or ""
  local picVer = playerInfo.picVer or 0
  self.compHeadIcon:SetData(uid, pic or "", picVer or 0, false)
end

return UIActValentineMatchHeadItem
