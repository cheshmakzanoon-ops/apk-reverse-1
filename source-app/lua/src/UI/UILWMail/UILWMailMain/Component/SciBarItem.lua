local SciBarItem = BaseClass("SciBarItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function SciBarItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function SciBarItem:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function SciBarItem:ComponentDefine()
  self.slider1 = self:AddComponent(UISlider, "slider1")
  self.slider2 = self:AddComponent(UISlider, "slider2")
  self.desc = self:AddComponent(UIText, "desc")
  self.sliderText1 = self:AddComponent(UIText, "slider1/sliderText1")
  self.sliderText2 = self:AddComponent(UIText, "slider2/sliderText2")
  self.up1 = self:AddComponent(UIBaseComponent, "up1")
  self.up2 = self:AddComponent(UIBaseComponent, "up2")
  self.down1 = self:AddComponent(UIBaseComponent, "down1")
  self.down2 = self:AddComponent(UIBaseComponent, "down2")
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnClickBtn()
  end)
end

function SciBarItem:ComponentDestroy()
end

function SciBarItem:SetData(meta, effectsDic1, effectsDic2, value1, value2, myCamp, effectId)
  self.meta = meta
  self.effectsDic1 = effectsDic1
  self.effectsDic2 = effectsDic2
  self.desc:SetLocalText(meta.desc)
  self.sliderText1:SetText(string.GetFormattedPercentStr(value1))
  self.sliderText2:SetText(string.GetFormattedPercentStr(value2))
  local max = math.max(value1, value2)
  max = max <= 0 and 1 or max
  self.slider1:SetValue(value1 / max)
  self.slider2:SetValue(value2 / max)
  local up1State, down1State, up2State, down2State = false, false, false, false
  if not HeroUtils.HeroEffectEqual(effectId, value1, value2) then
    if myCamp == BattleReportCamp.Attacker then
      up1State = value2 < value1
      down1State = value1 < value2
    elseif myCamp == BattleReportCamp.Defender then
      up2State = value1 < value2
      down2State = value2 < value1
    end
  end
  self.up1:SetActive(up1State)
  self.down1:SetActive(down1State)
  self.up2:SetActive(up2State)
  self.down2:SetActive(down2State)
end

function SciBarItem:OnClickBtn()
  local metaData = {}
  metaData.effectName = self.meta.effectName
  metaData.effectId = self.meta.effectId
  local gotoType = {}
  if metaData.effectName then
    for i = 0, #metaData.effectName do
      gotoType[i] = QuestGoType.Science
    end
  end
  metaData.gotoType = gotoType
  metaData.gotoParam = self.meta.scienceId
  UIManager:GetInstance():OpenWindow(UIWindowNames.UILWMailEffectTip, {anim = true}, self.btn:GetPosition(), metaData, self.effectsDic1, self.effectsDic2)
end

function SciBarItem:DataDefine()
end

function SciBarItem:DataDestroy()
  self.meta = nil
  self.effectsDic1 = nil
  self.effectsDic2 = nil
end

function SciBarItem:OnEnable()
  base.OnEnable(self)
end

function SciBarItem:OnDisable()
  base.OnDisable(self)
end

function SciBarItem:OnAddListener()
  base.OnAddListener(self)
end

function SciBarItem:OnRemoveListener()
  base.OnRemoveListener(self)
end

return SciBarItem
