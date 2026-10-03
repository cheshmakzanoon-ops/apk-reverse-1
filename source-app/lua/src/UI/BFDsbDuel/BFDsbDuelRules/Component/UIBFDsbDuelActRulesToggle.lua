local base = UIBaseContainer
local UIBFDsbDuelActRulesToggle = BaseClass("UIBFDsbDuelActRulesToggle", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActRulesToggle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActRulesToggle:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActRulesToggle:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.toggle = self.viewSkin:AddComponent(self, UIToggle, 1)
  self.textTab1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.compChoose = self.viewSkin:AddComponent(self, UIBaseContainer, 3)
  self.textTab12 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.toggle:SetIsOn(false)
  self.toggle:SetOnValueChanged(function(bool)
    if bool and self.data then
      self.data.clickHandler(self.data.tabId)
    end
  end)
end

function UIBFDsbDuelActRulesToggle:ComponentDestroy()
  self.viewSkin = nil
  self.toggle = nil
  self.textTab1 = nil
  self.compChoose = nil
  self.textTab12 = nil
end

function UIBFDsbDuelActRulesToggle:DataDefine()
end

function UIBFDsbDuelActRulesToggle:DataDestroy()
end

function UIBFDsbDuelActRulesToggle:OnAddListener()
  base.OnAddListener(self)
end

function UIBFDsbDuelActRulesToggle:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActRulesToggle:ReInit(data)
  self.data = data
  if self.data.tabId == BattlefieldDsbConst.BF_DSB_GUIDE_TYPE.TimeDetail then
    self.textTab12:SetLocalText("dsb_duel_guide_tips_1001")
    self.textTab1:SetLocalText("dsb_duel_guide_tips_1001")
  elseif self.data.tabId == BattlefieldDsbConst.BF_DSB_GUIDE_TYPE.GroupRules then
    self.textTab12:SetLocalText("dsb_duel_guide_tips_1002")
    self.textTab1:SetLocalText("dsb_duel_guide_tips_1002")
  elseif self.data.tabId == BattlefieldDsbConst.BF_DSB_GUIDE_TYPE.Match then
    self.textTab12:SetLocalText("dsb_duel_guide_tips_1003")
    self.textTab1:SetLocalText("dsb_duel_guide_tips_1003")
  elseif self.data.tabId == BattlefieldDsbConst.BF_DSB_GUIDE_TYPE.Reward then
    self.textTab12:SetLocalText("dsb_duel_guide_tips_1004")
    self.textTab1:SetLocalText("dsb_duel_guide_tips_1004")
  end
end

return UIBFDsbDuelActRulesToggle
