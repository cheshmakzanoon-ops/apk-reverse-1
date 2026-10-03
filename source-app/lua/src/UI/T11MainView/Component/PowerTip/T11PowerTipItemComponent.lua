local base = UIBaseContainer
local T11PowerTipItemComponent = BaseClass("T11PowerTipItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function T11PowerTipItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function T11PowerTipItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function T11PowerTipItemComponent:ComponentDefine()
  self.viewSkin = self:AddComponent(UIViewSkinBridge, "")
  self.textTitle = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 1)
  self.textNormalValue = self.viewSkin:AddComponent(self, UITextMeshProUGUIEx, 2)
end

function T11PowerTipItemComponent:ComponentDestroy()
  self.viewSkin = nil
  self.textTitle = nil
  self.textNormalValue = nil
end

function T11PowerTipItemComponent:DataDefine()
end

function T11PowerTipItemComponent:DataDestroy()
  if self.rollTween then
    self.rollTween:Kill()
    self.rollTween = nil
  end
end

function T11PowerTipItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function T11PowerTipItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function T11PowerTipItemComponent:RefreshView(data, params)
  if not data then
    return
  end
  self.textTitle:SetLocalText(data.title)
  if self.rollTween then
    self.rollTween:Kill()
    self.rollTween = nil
  end
  local withAni = false
  local isDecimalShow = false
  if params then
    withAni = params.withAni
    isDecimalShow = params.isDecimalShow
  end
  if withAni and self.oldVal then
    local fromVal = self.oldVal
    local toVal = data.numVal
    
    local function Getter()
      return fromVal
    end
    
    local function Setter(value)
      fromVal = value
      self.oldVal = value
      self.textNormalValue:SetText(toInt(value))
    end
    
    self.rollTween = DOTween.To(Getter, Setter, toVal, 1):OnComplete(function()
      self.rollTween = nil
      if isDecimalShow then
        self.textNormalValue:SetText(math.ceil((data.numVal or 0) * 100) / 100)
      else
        self.textNormalValue:SetText(string.GetFormattedStr(data.numVal or 0))
      end
    end)
  elseif isDecimalShow then
    self.textNormalValue:SetText(math.ceil((data.numVal or 0) * 100) / 100)
  else
    self.textNormalValue:SetText(string.GetFormattedStr(data.numVal or 0))
  end
  self.oldVal = data.numVal
end

return T11PowerTipItemComponent
