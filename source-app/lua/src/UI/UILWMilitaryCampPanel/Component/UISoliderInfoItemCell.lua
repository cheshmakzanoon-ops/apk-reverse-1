local UISoliderInfoItemCell = BaseClass("UISoliderInfoItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UISoliderInfoItemCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UISoliderInfoItemCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UISoliderInfoItemCell:ComponentDestroy()
  self.slider = nil
  self.sliderText = nil
  self.icon = nil
  self.title = nil
  self.info = nil
  self.btn = nil
  self.tipId = nil
end

function UISoliderInfoItemCell:ComponentDefine()
  self.slider = self:AddComponent(UISlider, "InfoSlider")
  self.sliderText = self:AddComponent(UIText, "InfoSlider/valueText")
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

function UISoliderInfoItemCell:InitInfo(info)
  self.icon:LoadSprite(info.path)
  self.title:SetLocalText(info.text)
  self.tipId = info.tipId
end

function UISoliderInfoItemCell:RefreshSlider(info, index)
  if info == nil or self.info == info then
    return
  end
  self.info = info
  local number = 0
  local allNumber = info.allNumber
  if info.curNumber then
    number = info.curNumber
    if index == 2 then
      number = (number + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_Effect_Id_50160)) * (1 + LuaEntry.Effect:GetGameEffect(50080))
      allNumber = (allNumber + LuaEntry.Effect:GetGameEffect(EffectDefine.LW_Effect_Id_50160)) * (1 + LuaEntry.Effect:GetGameEffect(50080))
      number = math.ceil(number * 100) / 100
      allNumber = math.ceil(allNumber * 100) / 100
    end
    self.sliderText:SetText(number)
  end
  if info.effect then
    local name, value = WorkerUtil.GetEffectText(info.effect.effectId, info.effect.value, true)
    number = tonumber(value)
    if index == 4 then
      number = (number + LuaEntry.Effect:GetGameEffect(50065)) * (1 + LuaEntry.Effect:GetGameEffect(50076))
      allNumber = (allNumber + LuaEntry.Effect:GetGameEffect(50065)) * (1 + LuaEntry.Effect:GetGameEffect(50076))
      number = math.ceil(number * 100) / 100
      allNumber = math.ceil(allNumber * 100) / 100
    elseif index == 5 then
      number = (number + LuaEntry.Effect:GetGameEffect(50067)) * (1 + LuaEntry.Effect:GetGameEffect(50077))
      allNumber = (allNumber + LuaEntry.Effect:GetGameEffect(50067)) * (1 + LuaEntry.Effect:GetGameEffect(50077))
      number = math.ceil(number * 100) / 100
      allNumber = math.ceil(allNumber * 100) / 100
    elseif index == 6 then
      number = (number + LuaEntry.Effect:GetGameEffect(50069)) * (1 + LuaEntry.Effect:GetGameEffect(50078))
      allNumber = (allNumber + LuaEntry.Effect:GetGameEffect(50069)) * (1 + LuaEntry.Effect:GetGameEffect(50078))
      number = math.ceil(number * 100) / 100
      allNumber = math.ceil(allNumber * 100) / 100
    end
    self.sliderText:SetText(number)
    self.title:SetText(name)
  end
  local value = number / allNumber
  self.slider:SetValue(value)
end

return UISoliderInfoItemCell
