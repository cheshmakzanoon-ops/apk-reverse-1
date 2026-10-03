local BarItemAsync = BaseClass("BarItemAsync", UIAsyncDataContainer)
local base = UIAsyncDataContainer
local Localization = CS.GameEntry.Localization
BarItemAsync.DataSchema = {
  "name",
  "type",
  "value1",
  "value2",
  "myCamp"
}
BarItemAsync.PrefabPath = "Assets/Main/Prefabs/UI/LWMail/MailBattle/BarItemAsync.prefab"

function BarItemAsync:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function BarItemAsync:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function BarItemAsync:ComponentDefine()
  self.slider1 = self:AddComponent(UISlider, "slider1")
  self.slider2 = self:AddComponent(UISlider, "slider2")
  self.desc = self:AddComponent(UIText, "desc")
  self.sliderText1 = self:AddComponent(UIText, "slider1/sliderText1")
  self.sliderText2 = self:AddComponent(UIText, "slider2/sliderText2")
  self.up1 = self:AddComponent(UIBaseComponent, "up1")
  self.up2 = self:AddComponent(UIBaseComponent, "up2")
  self.down1 = self:AddComponent(UIBaseComponent, "down1")
  self.down2 = self:AddComponent(UIBaseComponent, "down2")
end

function BarItemAsync:ComponentDestroy()
end

function BarItemAsync:UpdateData()
  local name = self.viewData.name
  local type = self.viewData.type
  local value1 = self.viewData.value1
  local value2 = self.viewData.value2
  local myCamp = self.viewData.myCamp
  self.desc:SetText(name)
  self.sliderText1:SetText(HeroUtils.GetFormattedValue(type, value1))
  self.sliderText2:SetText(HeroUtils.GetFormattedValue(type, value2))
  local max = math.max(value1, value2)
  max = max <= 0 and 1 or max
  self.slider1:SetValue(value1 / max)
  self.slider2:SetValue(value2 / max)
  local up1State, down1State, up2State, down2State = false, false, false, false
  if not HeroUtils.HeroEffectEqualType(type, value1, value2) then
    if myCamp == BattleReportCamp.Attacker then
      up1State = value1 > value2
      down1State = value1 < value2
    elseif myCamp == BattleReportCamp.Defender then
      up2State = value1 < value2
      down2State = value1 > value2
    end
  end
  self.up1:SetActive(up1State)
  self.down1:SetActive(down1State)
  self.up2:SetActive(up2State)
  self.down2:SetActive(down2State)
end

return BarItemAsync
