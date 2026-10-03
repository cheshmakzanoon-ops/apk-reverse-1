local UILWHeroHonorPropertyChangeItem = BaseClass("UILWHeroHonorPropertyChangeItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UILWHeroHonorPropertyChangeItem:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWHeroHonorPropertyChangeItem:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  self:GameObjectDestroy(self.gameObject)
  base.OnDestroy(self)
end

function UILWHeroHonorPropertyChangeItem:OnEnable()
  base.OnEnable(self)
end

function UILWHeroHonorPropertyChangeItem:OnDisable()
  base.OnDisable(self)
end

function UILWHeroHonorPropertyChangeItem:ComponentDefine()
  self.canvasGroup = self:AddComponent(UICanvasGroup, "")
  self.HpChange = self:AddComponent(UIText, "HpChange")
end

function UILWHeroHonorPropertyChangeItem:ComponentDestroy()
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  self.HpChange = nil
end

function UILWHeroHonorPropertyChangeItem:DataDefine()
end

function UILWHeroHonorPropertyChangeItem:DataDestroy()
end

function UILWHeroHonorPropertyChangeItem:SetDataAndPlay(hp, callBack)
  if not IsNull(self.sequence) then
    self.sequence:Kill()
    self.sequence = nil
  end
  hp = math.floor(hp)
  self.transform:Set_localPosition(0, 0, 0)
  self.canvasGroup:SetAlpha(1)
  if 0 < hp then
    self.HpChange:SetActive(true)
    self.HpChange:SetText(Localization:GetString("hero_honorlevel_title_01") .. "+" .. hp)
  else
    self.HpChange:SetActive(false)
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

return UILWHeroHonorPropertyChangeItem
