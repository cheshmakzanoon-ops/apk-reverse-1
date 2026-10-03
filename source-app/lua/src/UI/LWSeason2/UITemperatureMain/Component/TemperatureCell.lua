local TemperatureCell = BaseClass("TemperatureCell", UIBaseContainer)
local base = UIBaseContainer
local bg_path = "Bg"
local temp_path = "temp"

function TemperatureCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function TemperatureCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TemperatureCell:OnAddListener()
  base.OnAddListener(self)
end

function TemperatureCell:OnRemoveListener()
  base.OnRemoveListener(self)
end

function TemperatureCell:ComponentDefine()
  self.bg = self:AddComponent(UIImage, bg_path)
  self.temp = self:AddComponent(UITextMeshProUGUIEx, temp_path)
  self.value = {}
  for i = 1, 4 do
    self.value[i] = self:AddComponent(UITextMeshProUGUIEx, "value" .. i)
  end
end

function TemperatureCell:ComponentDestroy()
end

function TemperatureCell:SetData(tempMeta, isCur, temp)
  self.bg:SetActive(isCur)
  self.temp:SetLocalText("season_s2_common_temperature", isCur and temp or tempMeta.temperature)
  for i = 1, 4 do
    self.value[i]:SetText(tempMeta.effect_value_show[i][3])
  end
  if isCur then
    self.bg:SetColor(UIUtil.HexToColor(tempMeta.background_color))
  end
end

return TemperatureCell
