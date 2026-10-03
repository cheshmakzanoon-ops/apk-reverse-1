local base = UIAsyncContainer
local ParkourBossHpBarComponent = BaseClass("ParkourBossHpBarComponent", UIAsyncContainer)
local Localization = CS.GameEntry.Localization

function ParkourBossHpBarComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  if self.curHp then
    self:SetHp(self.curHp, self.maxHp)
  end
end

function ParkourBossHpBarComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function ParkourBossHpBarComponent:ComponentDefine()
  self.sliderFg1 = self:AddComponent(UISlider, "Content/fg1")
  self.sliderFg2 = self:AddComponent(UISlider, "Content/fg2")
  self.text = self:AddComponent(UITextMeshProUGUIEx, "Content/text")
  self.textTxtNum = self:AddComponent(UITextMeshProUGUIEx, "Content/txtNum")
  self.imgBossIcon = self:AddComponent(UIImage, "Content/bossIconFg/bossIcon")
  CS.UIGray.SetGray(self.imgBossIcon.transform, false, false)
end

function ParkourBossHpBarComponent:ComponentDestroy()
  self.sliderFg1 = nil
  self.sliderFg2 = nil
  self.text = nil
  self.textTxtNum = nil
  self.imgBossIcon = nil
end

function ParkourBossHpBarComponent:DataDefine()
end

function ParkourBossHpBarComponent:DataDestroy()
end

function ParkourBossHpBarComponent:OnAddListener()
  base.OnAddListener(self)
end

function ParkourBossHpBarComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function ParkourBossHpBarComponent:InitBarNum(barNum)
  self.barNum = barNum
end

function ParkourBossHpBarComponent:InitBossIcon(icon)
  if not string.IsNullOrEmpty(icon) then
    self.imgBossIcon:LoadSprite(icon)
  end
end

function ParkourBossHpBarComponent:SetHp(curHp, maxHp)
  if self.gameObject == nil then
    self.curHp = curHp
    self.maxHp = maxHp
    return
  end
  local percent = curHp / maxHp
  if percent == 0 then
    self.sliderFg1:SetValue(0)
    self.sliderFg2:SetValue(0)
    self.text:SetText("\195\1510")
    return
  end
  local step = 1 / self.barNum
  local result = {}
  for i = 1, self.barNum do
    local value = math.min(step, percent)
    percent = percent - value
    if 0 < value then
      table.insert(result, value)
    end
  end
  local v1 = result[#result]
  local v2 = result[#result - 1]
  if v1 then
    local bar1, bar2
    if #result % 2 == 0 then
      bar1 = self.sliderFg1
      bar2 = self.sliderFg2
    else
      bar1 = self.sliderFg2
      bar2 = self.sliderFg1
    end
    bar1.transform:SetAsLastSibling()
    bar1:SetValue(v1 / step)
    if v2 then
      bar2:SetValue(1)
    else
      bar2:SetValue(0)
    end
  end
  self.text:SetText("\195\151" .. #result)
  if curHp then
    self.textTxtNum:SetText(string.numbericFormationWithPrefix(curHp, 5, ","))
  else
    self.textTxtNum:SetText("")
  end
end

function ParkourBossHpBarComponent:SetDead()
  self.sliderFg1:SetValue(0)
  self.sliderFg2:SetValue(0)
  self.text:SetText("\195\1510")
  self.textTxtNum:SetText("0")
  CS.UIGray.SetGray(self.imgBossIcon.transform, true, true)
end

return ParkourBossHpBarComponent
