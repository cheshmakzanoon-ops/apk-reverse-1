local base = UIBaseContainer
local LLGroupChoosePanelTopItem = BaseClass("LLGroupChoosePanelTopItem", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local LLServerItem = require("UI.Landlord.Main.Component.LLServerItem")

function LLGroupChoosePanelTopItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function LLGroupChoosePanelTopItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LLGroupChoosePanelTopItem:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.compLLServerItem = self.viewSkin:AddComponent(self, LLServerItem, 2)
end

function LLGroupChoosePanelTopItem:ComponentDestroy()
  self.viewSkin = nil
  self.textName = nil
  self.compLLServerItem = nil
end

function LLGroupChoosePanelTopItem:DataDefine()
end

function LLGroupChoosePanelTopItem:DataDestroy()
  self.sInfo = nil
end

function LLGroupChoosePanelTopItem:OnAddListener()
  base.OnAddListener(self)
end

function LLGroupChoosePanelTopItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

function LLGroupChoosePanelTopItem:SetServer(sInfo, showName)
  self.sInfo = sInfo
  self.textName:SetActive(showName)
  if showName then
    self.textName:SetText(sInfo ~= nil and sInfo.king.name or "")
  end
  local stage = sInfo ~= nil and LLConst.LandlordStage.PREPARE or LLConst.LandlordStage.GROUP
  self.compLLServerItem:SetServer(sInfo, sInfo ~= nil and sInfo.group or LLConst.LandLordGroup.NONE, stage)
end

return LLGroupChoosePanelTopItem
