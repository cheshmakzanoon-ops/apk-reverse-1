local UIHeroPowerChangeItem = BaseClass("UIHeroPowerChangeItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIHeroPowerChangeItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UIHeroPowerChangeItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  self:GameObjectDestroy(self.gameObject)
  base.OnDestroy(self)
end

function UIHeroPowerChangeItem:OnEnable()
  base.OnEnable(self)
end

function UIHeroPowerChangeItem:OnDisable()
  base.OnDisable(self)
end

function UIHeroPowerChangeItem:ComponentDefine()
  self.canvasGroup = self:AddComponent(UICanvasGroup, "")
  self.powerChange = self:AddComponent(UIText, "PowerChange")
end

function UIHeroPowerChangeItem:ComponentDestroy()
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.powerChange = nil
end

function UIHeroPowerChangeItem:DataDefine()
end

function UIHeroPowerChangeItem:DataDestroy()
end

function UIHeroPowerChangeItem:SetDataAndPlay(power, callBack)
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.transform:Set_localPosition(0, 0, 0)
  self.canvasGroup:SetAlpha(1)
  self.powerChange:SetText(Localization:GetString(393067) .. "+" .. power)
  self.sequence = CS.DG.Tweening.DOTween.Sequence()
  self.sequence:Append(self.transform:DOLocalMove(Vector3.New(0, 150, 0), 1))
  self.sequence:Insert(0.5, self.canvasGroup.unity_canvas_group:DOFade(0, 0.5))
  self.sequence:OnComplete(function()
    if callBack then
      callBack(self)
    end
    self.sequence = nil
  end)
end

return UIHeroPowerChangeItem
