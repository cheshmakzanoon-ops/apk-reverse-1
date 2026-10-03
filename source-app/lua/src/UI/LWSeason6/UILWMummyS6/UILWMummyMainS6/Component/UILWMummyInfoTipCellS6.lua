local UILWMummyInfoTipCellS6 = BaseClass("UILWMummyInfoTipCellS6", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UILWMummyInfoTipCellS6:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWMummyInfoTipCellS6:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMummyInfoTipCellS6:ComponentDestroy()
  self.slider = nil
  self.sliderText = nil
  self.sliderTextAdd = nil
  self.icon = nil
  self.title = nil
  self.info = nil
  self.btn = nil
  self.tipId = nil
end

function UILWMummyInfoTipCellS6:ComponentDefine()
  self.slider = self:AddComponent(UISlider, "InfoSlider")
  self.sliderText = self:AddComponent(UIText, "InfoSlider/valueText")
  self.sliderTextAdd = self:AddComponent(UIText, "InfoSlider/valueTextAdd")
  self.icon = self:AddComponent(UIImage, "icon")
  self.title = self:AddComponent(UIText, "title")
  self.btn = self:TryAddComponent(UIButton, "ClickBtn")
  if self.btn then
    self.btn:SetOnClick(function()
      if self.tipId then
        UIUtil.ShowBubbleTips(Localization:GetString(self.tipId), self.btn.transform.position, 20, -40, -20)
      end
    end)
  end
end

function UILWMummyInfoTipCellS6:InitInfo(info)
  self.icon:LoadSprite(info.path)
  self.title:SetLocalText(info.text)
  self.tipId = info.tipId
end

function UILWMummyInfoTipCellS6:RefreshSlider(info, index, template)
  if info == nil or self.info == info then
    return
  end
  self.info = info
  local number = 0
  local numberMummy = 0
  local allNumber = info.allNumber or 1
  local allNumberMummy = info.allNumberMummy or allNumber
  if info.curNumber then
    number = info.curNumber
    numberMummy = info.curNumberMummy or number
    if index == 2 then
      local effect50080 = LuaEntry.Effect:GetGameEffect(50080)
      number = number * (1 + effect50080)
      allNumber = allNumber * (1 + effect50080)
      number = math.ceil(number * 10) / 10
      allNumber = math.ceil(allNumber * 10) / 10
      numberMummy = math.ceil(numberMummy)
      allNumberMummy = math.ceil(allNumberMummy)
    end
  end
  if info.effect then
    local name, value = WorkerUtil.GetEffectText(info.effect.effectId, info.effect.value, true)
    number = tonumber(value) or 0
    self.title:SetText(name)
    if info.effectMummy then
      name, value = WorkerUtil.GetEffectText(info.effectMummy.effectId, info.effectMummy.value, true)
      numberMummy = tonumber(value) or 0
    else
      numberMummy = number
    end
    local soldier_multiplier = 1
    if template and template.lv then
      local mummyMeta = DataCenter.SoldierDataManager:GetSoldierTemplateByLevel(template.lv, SoldierType.Mummy)
      if mummyMeta then
        soldier_multiplier = tonumber(mummyMeta.soldier_multiplier)
        if soldier_multiplier == nil or soldier_multiplier == 0 then
          soldier_multiplier = 1
        end
      end
    end
    if index == 4 then
      local effect50065 = LuaEntry.Effect:GetGameEffect(50065)
      local effect50076 = LuaEntry.Effect:GetGameEffect(50076)
      local effect94070 = LuaEntry.Effect:GetGameEffect(94070)
      local effect94071 = LuaEntry.Effect:GetGameEffect(94071)
      number = (number + effect50065) * (1 + effect50076)
      allNumber = (allNumber + effect50065) * (1 + effect50076)
      number = math.ceil(number * 10) / 10
      allNumber = math.ceil(allNumber * 10) / 10
      numberMummy = (numberMummy + effect50065 + effect94070) * (1 + effect50076 + effect94071) * soldier_multiplier
      allNumberMummy = (allNumberMummy + effect50065 + effect94070) * (1 + effect50076 + effect94071) * soldier_multiplier
      numberMummy = math.ceil(numberMummy * 10) / 10
      allNumberMummy = math.ceil(allNumberMummy * 10) / 10
    elseif index == 5 then
      local effect50067 = LuaEntry.Effect:GetGameEffect(50067)
      local effect50077 = LuaEntry.Effect:GetGameEffect(50077)
      local effect94073 = LuaEntry.Effect:GetGameEffect(94073)
      local effect94074 = LuaEntry.Effect:GetGameEffect(94074)
      number = (number + effect50067) * (1 + effect50077)
      allNumber = (allNumber + effect50067) * (1 + effect50077)
      number = math.ceil(number * 10) / 10
      allNumber = math.ceil(allNumber * 10) / 10
      numberMummy = (numberMummy + effect50067 + effect94073) * (1 + effect50077 + effect94074) * soldier_multiplier
      allNumberMummy = (allNumberMummy + effect50067 + effect94073) * (1 + effect50077 + effect94074) * soldier_multiplier
      numberMummy = math.ceil(numberMummy * 10) / 10
      allNumberMummy = math.ceil(allNumberMummy * 10) / 10
    elseif index == 6 then
      local effect50069 = LuaEntry.Effect:GetGameEffect(50069)
      local effect50078 = LuaEntry.Effect:GetGameEffect(50078)
      local effect94076 = LuaEntry.Effect:GetGameEffect(94076)
      local effect94077 = LuaEntry.Effect:GetGameEffect(94077)
      number = (number + effect50069) * (1 + effect50078)
      allNumber = (allNumber + effect50069) * (1 + effect50078)
      number = math.ceil(number * 10) / 10
      allNumber = math.ceil(allNumber * 10) / 10
      numberMummy = (numberMummy + effect50069 + effect94076) * (1 + effect50078 + effect94077) * soldier_multiplier
      allNumberMummy = (allNumberMummy + effect50069 + effect94076) * (1 + effect50078 + effect94077) * soldier_multiplier
      numberMummy = math.ceil(numberMummy * 10) / 10
      allNumberMummy = math.ceil(allNumberMummy * 10) / 10
    end
  end
  if number < numberMummy then
    local buffAddNum = "+" .. math.ceil((numberMummy - number) * 10) / 10
    self.sliderTextAdd:SetText(string.removeExtraDecimals(buffAddNum))
  else
    self.sliderTextAdd:SetText("")
  end
  self.sliderText:SetText(number)
  self.slider:SetValue(number / allNumber)
end

function UILWMummyInfoTipCellS6:RefreshMummy(info, index, template)
  if info == nil or self.info == info then
    return
  end
  self.info = info
  local number = 0
  local allNumber = info.allNumber or 1
  if info.curNumber then
    number = info.curNumber
    if index == 2 then
      number = math.ceil(number * 10) / 10
      allNumber = math.ceil(allNumber * 10) / 10
    end
  end
  if info.effect then
    local soldier_multiplier = 1
    if template and template.lv then
      local mummyMeta = DataCenter.SoldierDataManager:GetSoldierTemplateByLevel(template.lv, SoldierType.Mummy)
      if mummyMeta then
        soldier_multiplier = tonumber(mummyMeta.soldier_multiplier)
        if soldier_multiplier == nil or soldier_multiplier == 0 then
          soldier_multiplier = 1
        end
      end
    end
    local name, value = WorkerUtil.GetEffectText(info.effect.effectId, info.effect.value, true)
    number = tonumber(value) or 0
    self.title:SetText(name)
    if index == 4 then
      local effect50065 = LuaEntry.Effect:GetGameEffect(50065)
      local effect50076 = LuaEntry.Effect:GetGameEffect(50076)
      local effect94070 = LuaEntry.Effect:GetGameEffect(94070)
      local effect94071 = LuaEntry.Effect:GetGameEffect(94071)
      number = (number + effect50065 + effect94070) * (1 + effect50076 + effect94071) * soldier_multiplier
      allNumber = (allNumber + effect50065 + effect94070) * (1 + effect50076 + effect94071) * soldier_multiplier
      number = math.ceil(number * 10) / 10
      allNumber = math.ceil(allNumber * 10) / 10
    elseif index == 5 then
      local effect50067 = LuaEntry.Effect:GetGameEffect(50067)
      local effect50077 = LuaEntry.Effect:GetGameEffect(50077)
      local effect94073 = LuaEntry.Effect:GetGameEffect(94073)
      local effect94074 = LuaEntry.Effect:GetGameEffect(94074)
      number = (number + effect50067 + effect94073) * (1 + effect50077 + effect94074) * soldier_multiplier
      allNumber = (allNumber + effect50067 + effect94073) * (1 + effect50077 + effect94074) * soldier_multiplier
      number = math.ceil(number * 10) / 10
      allNumber = math.ceil(allNumber * 10) / 10
    elseif index == 6 then
      local effect50069 = LuaEntry.Effect:GetGameEffect(50069)
      local effect50078 = LuaEntry.Effect:GetGameEffect(50078)
      local effect94076 = LuaEntry.Effect:GetGameEffect(94076)
      local effect94077 = LuaEntry.Effect:GetGameEffect(94077)
      number = (number + effect50069 + effect94076) * (1 + effect50078 + effect94077) * soldier_multiplier
      allNumber = (allNumber + effect50069 + effect94076) * (1 + effect50078 + effect94077) * soldier_multiplier
      number = math.ceil(number * 10) / 10
      allNumber = math.ceil(allNumber * 10) / 10
    end
  end
  self.sliderTextAdd:SetText("")
  self.sliderText:SetText(number)
  self.slider:SetValue(number / allNumber)
end

return UILWMummyInfoTipCellS6
