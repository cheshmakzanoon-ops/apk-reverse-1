local UIHeroPropertyChangeItem = BaseClass("UIHeroPropertyChangeItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIHeroPropertyChangeItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIHeroPropertyChangeItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  self:GameObjectDestroy(self.gameObject)
  base.OnDestroy(self)
end

function UIHeroPropertyChangeItem:OnEnable()
  base.OnEnable(self)
end

function UIHeroPropertyChangeItem:OnDisable()
  base.OnDisable(self)
end

function UIHeroPropertyChangeItem:ComponentDefine()
  self.canvasGroup = self:AddComponent(UICanvasGroup, "")
  self.HpChange = self:AddComponent(UIText, "HpChange")
  self.AtkChange = self:AddComponent(UIText, "AtkChange")
  self.DefChange = self:AddComponent(UIText, "DefChange")
end

function UIHeroPropertyChangeItem:ComponentDestroy()
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.HpChange = nil
  self.AtkChange = nil
  self.DefChange = nil
  self.HpItem = nil
  self.AtkItem = nil
  self.DefItem = nil
end

function UIHeroPropertyChangeItem:DataDefine()
end

function UIHeroPropertyChangeItem:DataDestroy()
end

function UIHeroPropertyChangeItem:SetDataAndPlay(hp, atk, def, callBack)
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  hp = math.floor(hp)
  atk = math.floor(atk)
  def = math.floor(def)
  self.transform:Set_localPosition(0, 0, 0)
  self.canvasGroup:SetAlpha(1)
  if 0 < hp then
    self.HpChange:SetActive(true)
    self.HpChange:SetText(Localization:GetString(154286) .. "+" .. hp)
  else
    self.HpChange:SetActive(false)
  end
  if 0 < atk then
    self.AtkChange:SetActive(true)
    self.AtkChange:SetText(Localization:GetString(154284) .. "+" .. atk)
  else
    self.AtkChange:SetActive(false)
  end
  if 0 < def then
    self.DefChange:SetActive(true)
    self.DefChange:SetText(Localization:GetString(154285) .. "+" .. def)
  else
    self.DefChange:SetActive(false)
  end
  self.sequence = CS.DG.Tweening.DOTween.Sequence()
  self.sequence:Append(self.transform:DOLocalMove(Vector3.New(0, 50, 0), 1))
  self.sequence:Insert(0.5, self.canvasGroup.unity_canvas_group:DOFade(0, 0.5))
  self.sequence:OnComplete(function()
    if callBack then
      callBack(self)
    end
    self.sequence = nil
  end)
end

return UIHeroPropertyChangeItem
