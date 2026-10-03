local base = UIBaseContainer
local UILWAlMemberOfficialTopPanel = BaseClass("UILWAlMemberOfficialTopPanel", UIBaseContainer)
local Localization = CS.GameEntry.Localization
local UILWAlMemberOfficialTopItem = require("UI.UILWAlliance.UILWAlMemberOfficial.Component.UILWAlMemberOfficialTopItem")

function UILWAlMemberOfficialTopPanel:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWAlMemberOfficialTopPanel:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWAlMemberOfficialTopPanel:ComponentDefine()
  self.compRightOfficialItem = self:AddComponent(UILWAlMemberOfficialTopItem, "RightOfficialItem")
  self.compArrowImg = self:AddComponent(UIBaseComponent, "ArrowImg")
  self.compLeftOfficialItem = self:AddComponent(UILWAlMemberOfficialTopItem, "LeftOfficialItem")
end

function UILWAlMemberOfficialTopPanel:ComponentDestroy()
  self.viewSkin = nil
  self.compRightOfficialItem = nil
  self.compArrowImg = nil
  self.compLeftOfficialItem = nil
end

function UILWAlMemberOfficialTopPanel:DataDefine()
end

function UILWAlMemberOfficialTopPanel:DataDestroy()
end

function UILWAlMemberOfficialTopPanel:OnAddListener()
  base.OnAddListener(self)
end

function UILWAlMemberOfficialTopPanel:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWAlMemberOfficialTopPanel:Refresh()
  self.type = self.view.type
  local nowPlayerInfo = DataCenter.AllianceMemberDataManager:GetMemberInfoByOfficialPos(self.type)
  self.compLeftOfficialItem:SetData(self.type, nowPlayerInfo)
  local selectInfo = self.view:GetSelectInfo()
  if selectInfo then
    self.compArrowImg:SetActive(true)
    self.compRightOfficialItem:SetActive(true)
    self.compRightOfficialItem:SetData(self.type, selectInfo)
  else
    self.compArrowImg:SetActive(false)
    self.compRightOfficialItem:SetActive(false)
  end
end

return UILWAlMemberOfficialTopPanel
