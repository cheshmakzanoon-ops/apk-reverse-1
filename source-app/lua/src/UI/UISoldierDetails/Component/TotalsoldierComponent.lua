local TotalsoldierComponent = BaseClass("UIShowBlackCell", UIBaseContainer)
local base = UIBaseContainer

function TotalsoldierComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function TotalsoldierComponent:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function TotalsoldierComponent:ComponentDefine()
  self.slider = self:AddComponent(UISlider, "Slider")
  self.iconImg = self:AddComponent(UIImage, "Icon")
  self.capacityText = self:AddComponent(UIText, "capacity")
  self.soldierName = self:AddComponent(UIText, "soldierName")
end

function TotalsoldierComponent:ComponentDestroy()
  self.slider = nil
  self.iconImg = nil
  self.capacityText = nil
  self.soldierName = nil
end

function TotalsoldierComponent:ReInit(buildUuid)
  self.soldierName:SetLocalText(135181)
  local number = math.modf(LuaEntry.Effect:GetGameEffect(EffectDefine.LW_SOLDIER_MAX_STOCK))
  local playerNumber = DataCenter.SoldierDataManager:GetPlayerSoldiersTotalNum()
  self.capacityText:SetText(playerNumber .. "/" .. number)
  self.slider:SetValue(playerNumber / number)
end

return TotalsoldierComponent
