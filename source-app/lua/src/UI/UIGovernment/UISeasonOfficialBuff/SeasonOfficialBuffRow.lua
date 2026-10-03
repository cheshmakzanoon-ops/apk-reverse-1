local SeasonOfficialBuffRow = BaseClass("SeasonOfficialBuffRow", UIAsyncContainer)
local base = UIAsyncContainer
local eff_path = "Content/eff"
local value_path = "Content/value"
local line_path = "line"

function SeasonOfficialBuffRow:OnCreate()
  base.OnCreate(self)
  self.eff = self:AddComponent(UIText, eff_path)
  self.value = self:AddComponent(UIText, value_path)
  self.line = self:AddComponent(UIImage, line_path)
end

function SeasonOfficialBuffRow:OnDestroy()
  self.eff = nil
  self.value = nil
  self.line = nil
  self.effectName = nil
  self.buffAddNum = nil
  self.lineActive = nil
  base.OnDestroy(self)
end

function SeasonOfficialBuffRow:SetData(effectName, buffAddNum)
  self.effectName = effectName
  self.buffAddNum = buffAddNum
  self.lineActive = true
end

function SeasonOfficialBuffRow:HideLine()
  self.lineActive = false
end

function SeasonOfficialBuffRow:UpdateData()
  self.eff:SetLocalText(self.effectName)
  self.value:SetText(self.buffAddNum)
  self.line:SetActive(self.lineActive)
end

return SeasonOfficialBuffRow
