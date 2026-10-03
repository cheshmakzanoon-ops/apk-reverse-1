local UIWorldTrendRankItem = BaseClass("UIWorldTrendRankItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

function UIWorldTrendRankItem:OnCreate()
  base.OnCreate(self)
  self._allianceName_txt = self:AddComponent(UIText, "Txt_AllianceName")
  self._progress_txt = self:AddComponent(UIText, "Txt_Progress")
  self._first_img = self:AddComponent(UIImage, "Img_First")
  self._second_img = self:AddComponent(UIImage, "Img_Second")
  self._third_img = self:AddComponent(UIImage, "Img_Third")
  self._rankNum_txt = self:AddComponent(UIText, "Txt_RankNum")
  self._allianceIcon_img = self:AddComponent(UIImage, "Rect_AllianceBg/Img_AllianceIcon")
end

function UIWorldTrendRankItem:OnDestroy()
  self._allianceName_txt = nil
  self._progress_txt = nil
  self._first_img = nil
  self._second_img = nil
  self._third_img = nil
  self._rankNum_txt = nil
  self._allianceIcon_img = nil
  base.OnDestroy(self)
end

function UIWorldTrendRankItem:OnEnable()
  base.OnEnable(self)
end

function UIWorldTrendRankItem:OnDisable()
  base.OnDisable(self)
end

function UIWorldTrendRankItem:RefreshData(data, index)
  self._allianceName_txt:SetText(data:GetAllianceName())
  self._progress_txt:SetText(data.num)
  self:SetImg(index)
end

function UIWorldTrendRankItem:SetImg(index)
  if index == 1 then
    self._first_img:SetActive(true)
    self._second_img:SetActive(false)
    self._third_img:SetActive(false)
  elseif index == 2 then
    self._first_img:SetActive(false)
    self._second_img:SetActive(true)
    self._third_img:SetActive(false)
  elseif index == 3 then
    self._first_img:SetActive(false)
    self._second_img:SetActive(false)
    self._third_img:SetActive(true)
  else
    self._first_img:SetActive(false)
    self._second_img:SetActive(false)
    self._third_img:SetActive(false)
    self._rankNum_txt:SetText(index)
  end
end

return UIWorldTrendRankItem
