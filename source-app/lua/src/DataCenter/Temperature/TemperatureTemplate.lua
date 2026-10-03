local TemperatureTemplate = BaseClass("TemperatureTemplate")
local Localization = CS.GameEntry.Localization

function TemperatureTemplate:__init()
end

function TemperatureTemplate:__delete()
  self.effect = nil
end

function TemperatureTemplate:InitConfig(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.temperature = row:getValue("temperature")
  self.background_color = row:getValue("background_color")
  self.text_color = row:getValue("text_color")
  self.emoji_btn = row:getValue("emoji_btn")
  self.effect_value = {}
  self.effect_value_is_zero = {}
  for i = 1, 4 do
    local effect_value = row:getValue(string.format("effect%s_value", i))
    self.effect_value_is_zero[i] = true
    for k, v in pairs(effect_value) do
      self.effect_value[k] = v
      if v ~= 0 then
        self.effect_value_is_zero[i] = false
      end
    end
  end
  self.effect_value_show = {
    row:getValue("effect1_value_show"),
    row:getValue("effect2_value_show"),
    row:getValue("effect3_value_show"),
    row:getValue("effect4_value_show")
  }
end

function TemperatureTemplate:GetName(index)
  return Localization:GetString(self.effect_value_show[index][1])
end

function TemperatureTemplate:GetDesc(index)
  return Localization:GetString(self.effect_value_show[index][2], self.effect_value_show[index][3])
end

function TemperatureTemplate:GetValue(effectId)
  return self.effect_value[effectId] or 0
end

return TemperatureTemplate
