local CellEffect = BaseClass("CellEffect", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function CellEffect:OnCreate()
  base.OnCreate(self)
  self._new_img = self:AddComponent(UIImage, "Layout/NewTag")
  self._new_txt = self:AddComponent(UITextMeshProUGUIEx, "Layout/NewTag/TagText")
  self._new_txt:SetLocalText("vip_new_tip")
  self._info_btn = self:AddComponent(UIButton, "Layout/InfoBtn")
  self._info_btn:SetOnClick(BindCallback(self.OnClickInfoBtn, self))
  self._effect_txt = self:AddComponent(UITextMeshProUGUIEx, "Layout/Content/BuffNameText")
  self._addition_txt = self:AddComponent(UITextMeshProUGUIEx, "Layout/Content/BuffValueText")
end

function CellEffect:OnDestroy()
  self._new_img = nil
  self._effect_txt = nil
  self._addition_txt = nil
  self.param = nil
  base.OnDestroy(self)
end

function CellEffect:OnEnable()
  base.OnEnable(self)
end

function CellEffect:OnDisable()
  base.OnDisable(self)
end

function CellEffect:RefreshData(data, index)
  self.param = data
  local valueStr = ""
  if data.id == "custom" then
    valueStr = tostring(data.value)
  else
    valueStr = HeroUtils.GetFormattedPropertyValue(tonumber(self.param.id), self.param.value, false)
  end
  self._effect_txt:SetLocalText(self.param.descID)
  self._addition_txt:SetText(valueStr)
  self._new_img:SetActive(self.param.isNew)
  if tonumber(self.param.id) == EffectDefine.LW_SHAKE_COLLECT_RES then
    self._info_btn:SetActive(true)
    if Config.IsPC() then
      self._effect_txt:SetLocalText("pc_shake_tips_01_new")
    end
  else
    self._info_btn:SetActive(false)
  end
end

function CellEffect:OnClickInfoBtn()
  if tonumber(self.param.id) == EffectDefine.LW_SHAKE_COLLECT_RES then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVIPEffectTip, {anim = true}, tonumber(self.param.id), self._info_btn:GetPosition())
  end
end

return CellEffect
