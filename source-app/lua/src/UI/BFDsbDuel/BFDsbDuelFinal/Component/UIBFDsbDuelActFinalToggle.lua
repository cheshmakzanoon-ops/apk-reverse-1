local base = UIBaseContainer
local UIBFDsbDuelActFinalToggle = BaseClass("UIBFDsbDuelActFinalToggle", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UIBFDsbDuelActFinalToggle:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIBFDsbDuelActFinalToggle:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIBFDsbDuelActFinalToggle:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.toggleUIBFDsbDuelActFinal = self.viewSkin:AddComponent(self, UIToggle, 1)
  self.textSchedule1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textSchedule2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compIncludeFlag = self.viewSkin:AddComponent(self, UIBaseContainer, 4)
  self.textYou = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 5)
  self.toggleUIBFDsbDuelActFinal:SetOnValueChanged(function(isOn)
    if isOn and self.data and self.data.clickCallback then
      self.data.clickCallback(self.data.index)
    end
  end)
end

function UIBFDsbDuelActFinalToggle:ComponentDestroy()
  self.viewSkin = nil
  self.toggleUIBFDsbDuelActFinal = nil
  self.textSchedule1 = nil
  self.textSchedule2 = nil
  self.compIncludeFlag = nil
  self.textYou = nil
end

function UIBFDsbDuelActFinalToggle:DataDefine()
end

function UIBFDsbDuelActFinalToggle:DataDestroy()
end

function UIBFDsbDuelActFinalToggle:OnAddListener()
  base.OnAddListener(self)
  self:AddUIListener(EventId.DsbDuelActRankInfoUpdate, self.OnDsbDuelActRankInfoUpdate)
end

function UIBFDsbDuelActFinalToggle:OnRemoveListener()
  self:RemoveUIListener(EventId.DsbDuelActRankInfoUpdate, self.OnDsbDuelActRankInfoUpdate)
  base.OnRemoveListener(self)
end

function UIBFDsbDuelActFinalToggle:SetData(data)
  self.data = data
  self.textSchedule1:SetText(BattlefieldDsbDuelUtils.GetGroupLetter(data.index))
  self.textSchedule2:SetText(BattlefieldDsbDuelUtils.GetGroupLetter(data.index))
  self.compIncludeFlag:SetActive(data.index == BattlefieldDsbDuelUtils.ActInfo:GetSelfGroup())
end

function UIBFDsbDuelActFinalToggle:OnDsbDuelActRankInfoUpdate()
  self.compIncludeFlag:SetActive(self.data.index == BattlefieldDsbDuelUtils.ActInfo:GetSelfGroup())
end

return UIBFDsbDuelActFinalToggle
