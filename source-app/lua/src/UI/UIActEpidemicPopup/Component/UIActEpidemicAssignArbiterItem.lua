local UIActEpidemicAssignArbiterItem = BaseClass("UIActEpidemicAssignArbiterItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIActEpidemicAssignArbiterItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIActEpidemicAssignArbiterItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function UIActEpidemicAssignArbiterItem:ComponentDefine()
  self.head = self:AddComponent(UICommonHead, "head")
  self.name = self:AddComponent(UIText, "Name")
  self.level = self:AddComponent(UIText, "Level")
  self.power = self:AddComponent(UIText, "Power")
  self.toggle = self:AddComponent(UIToggle, "Toggle")
  self.toggle:SetIsOn(false)
  self.toggle:SetOnValueChanged(function(bool)
    if bool then
      self.view:OnSelect(self.uid)
    end
  end)
  self.online = self:AddComponent(UITextMeshProUGUIEx, "Online")
  self.offline = self:AddComponent(UITextMeshProUGUIEx, "Offline")
  self.cantSelect = self:AddComponent(UITextMeshProUGUIEx, "CantSelect")
end

function UIActEpidemicAssignArbiterItem:ComponentDestroy()
  if self.toggle then
    self.toggle:SetGroup(nil)
  end
end

function UIActEpidemicAssignArbiterItem:DataDefine()
end

function UIActEpidemicAssignArbiterItem:DataDestroy()
end

function UIActEpidemicAssignArbiterItem:Refresh(data, toggleGroup, selected)
  self.uid = data.uid
  self.head:SetHeadAndFrame(data.uid, data.pic, data.picVer, false, data.headSkinId, data.headSkinET)
  self.head:SetEnableClickShowInfo(true, true)
  self.name:SetText(UIUtil.FormatAllianceAndName(data.abbr, data.name))
  self.level:SetLocalText(2010379, data.lv)
  self.power:SetText(string.GetFormattedSeparatorNum(data.power))
  self.toggle:SetGroup(toggleGroup)
  self.online:SetActive(data.online)
  self.offline:SetActive(not data.online)
  self.toggle:SetIsOn(selected)
end

return UIActEpidemicAssignArbiterItem
