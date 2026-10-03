local base = UIBaseContainer
local SeasonCampDestroyBuffDetailIR = BaseClass("SeasonCampDestroyBuffDetailIR", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function SeasonCampDestroyBuffDetailIR:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SeasonCampDestroyBuffDetailIR:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SeasonCampDestroyBuffDetailIR:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTmpStr1 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textTmpStr2 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
  self.textTmpStr0 = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 3)
  self.compBg0 = self.viewSkin:AddComponent(self, UIBaseComponent, 4)
  self.compBg1 = self.viewSkin:AddComponent(self, UIBaseComponent, 5)
  self.compBg2 = self.viewSkin:AddComponent(self, UIBaseComponent, 6)
  self.compSeasonCampDestroyBuffDetailIR = self.viewSkin:AddComponent(self, UIBaseComponent, 7)
end

function SeasonCampDestroyBuffDetailIR:ComponentDestroy()
  self.viewSkin = nil
  self.textTmpStr1 = nil
  self.textTmpStr2 = nil
  self.textTmpStr0 = nil
  self.compBg0 = nil
  self.compBg1 = nil
  self.compBg2 = nil
  self.compSeasonCampDestroyBuffDetailIR = nil
end

function SeasonCampDestroyBuffDetailIR:DataDefine()
end

function SeasonCampDestroyBuffDetailIR:DataDestroy()
end

function SeasonCampDestroyBuffDetailIR:OnAddListener()
  base.OnAddListener(self)
end

function SeasonCampDestroyBuffDetailIR:OnRemoveListener()
  base.OnRemoveListener(self)
end

function SeasonCampDestroyBuffDetailIR:SetData(data)
  if not data or #data < 3 then
    return
  end
  self.textTmpStr0:SetText(data[1])
  self.textTmpStr1:SetText(data[2])
  self.textTmpStr2:SetText(data[3])
  local height0 = self.textTmpStr0:GetHeight()
  local height1 = self.textTmpStr1:GetHeight()
  local height2 = self.textTmpStr2:GetHeight()
  local maxHeight = math.max(height0, height1, height2)
  self.compSeasonCampDestroyBuffDetailIR:SetSizeDeltaY(maxHeight)
  self.compBg0:SetSizeDeltaY(maxHeight)
  self.compBg1:SetSizeDeltaY(maxHeight)
  self.compBg2:SetSizeDeltaY(maxHeight)
end

return SeasonCampDestroyBuffDetailIR
