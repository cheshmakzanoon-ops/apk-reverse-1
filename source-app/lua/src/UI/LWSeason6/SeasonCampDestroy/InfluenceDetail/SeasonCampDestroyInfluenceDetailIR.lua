local base = UIBaseContainer
local SeasonCampDestroyInfluenceDetailIR = BaseClass("SeasonCampDestroyInfluenceDetailIR", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function SeasonCampDestroyInfluenceDetailIR:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCampDestroyInfluenceDetailIR:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyInfluenceDetailIR:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.compBg = self.viewSkin:AddComponent(self, UIBaseComponent, 1)
  self.textTmpTitleName = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTmpTitleLocation = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.textTmpTitleInfluence = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 4)
  self.btnJumpToPos = self.viewSkin:AddComponent(self, UIButton, 5)
  self.btnJumpToPos:SetOnClick(function()
    self:OnBtnJumpToPosClick()
  end)
end

function SeasonCampDestroyInfluenceDetailIR:ComponentDestroy()
  self.viewSkin = nil
  self.compBg = nil
  self.textTmpTitleName = nil
  self.textTmpTitleLocation = nil
  self.textTmpTitleInfluence = nil
  self.btnJumpToPos = nil
end

function SeasonCampDestroyInfluenceDetailIR:DataDefine()
  self.data = nil
end

function SeasonCampDestroyInfluenceDetailIR:DataDestroy()
  self.data = nil
end

function SeasonCampDestroyInfluenceDetailIR:SetData(idx, data)
  self.data = data
  if not data then
    return
  end
  if data.isDestroyed then
    self.textTmpTitleName:SetText(Localization:GetString("104202"))
  else
    self.textTmpTitleName:SetText(CS.GameEntry.Localization:GetString(310161, data.name, data.cityLevel))
  end
  self.textTmpTitleLocation:SetText(data.location)
  self.textTmpTitleInfluence:SetText(string.GetFormattedSeparatorNum(data.influence))
end

function SeasonCampDestroyInfluenceDetailIR:OnAddListener()
  base.OnAddListener(self)
end

function SeasonCampDestroyInfluenceDetailIR:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonCampDestroyInfluenceDetailIR:OnBtnJumpToPosClick()
  if self.data then
    SeasonUtil.JumpToCityById(self.data.cityId)
  end
end

return SeasonCampDestroyInfluenceDetailIR
