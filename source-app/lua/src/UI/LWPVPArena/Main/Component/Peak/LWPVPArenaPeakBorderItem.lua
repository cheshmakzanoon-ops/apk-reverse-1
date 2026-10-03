local LWPVPArenaPeakBorderItem = BaseClass("LWPVPArenaPeakBorderItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local compBook = {
  {
    path = "imgHead",
    name = "imgHead",
    type = UIImage
  },
  {
    path = "txtRank",
    name = "txtRank",
    type = UIText
  },
  {
    path = "txtName",
    name = "txtName",
    type = UIText
  },
  {
    path = "txtEffect",
    name = "txtEffect",
    type = UIText
  }
}

function LWPVPArenaPeakBorderItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function LWPVPArenaPeakBorderItem:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function LWPVPArenaPeakBorderItem:ComponentDefine()
  self:DefineCompsByBook(compBook)
end

function LWPVPArenaPeakBorderItem:ComponentDestroy()
  self:ClearCompsByBook(compBook)
end

function LWPVPArenaPeakBorderItem:Refresh(decoId, nameId, rankId)
  self.decoId = decoId
  local effect_gain = string.split(LocalController:instance():getValue("lw_decoration", decoId, "effect_gain"), ";")
  local effectId = tonumber(effect_gain[1])
  local effectValue = effect_gain[2]
  local displayName = Localization:GetString(LocalController:instance():getValue("lw_effect_number", effectId, "name"))
  local displayType = LocalController:instance():getValue("lw_effect_number", effectId, "type")
  if 1 <= displayType and displayType <= 3 then
    effectValue = tostring(tonumber(effectValue) * 100) .. "%"
    if displayType == 2 then
      effectValue = "+" .. effectValue
    elseif displayType == 3 then
      effectValue = "-" .. effectValue
    end
  end
  self.txtName:SetText(Localization:GetString(nameId))
  local strEffect = Localization:GetString("801139", displayName, effectValue)
  self.txtEffect:SetText(strEffect)
end

return LWPVPArenaPeakBorderItem
