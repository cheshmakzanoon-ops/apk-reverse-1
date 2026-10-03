local base = UIBaseContainer
local UILWDominatorMainSelectItemComponent = BaseClass("UILWDominatorMainSelectItemComponent", UIBaseContainer)
local Localization = CS.GameEntry.Localization

function UILWDominatorMainSelectItemComponent:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWDominatorMainSelectItemComponent:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWDominatorMainSelectItemComponent:ComponentDefine()
  self.btnUILWDominatorMainSelectItem = self:AddComponent(UIButton, "")
  self.btnUILWDominatorMainSelectItem:SetOnClick(function()
    self:OnBtnUILWDominatorMainSelectItemClick()
  end)
  self.imgIcon = self:AddComponent(UIImage, "Icon")
  self.compIndex = self:AddComponent(UIBaseContainer, "IndexBg")
  self.textIndex = self:AddComponent(UIText, "IndexBg/IndexText")
  self.compHighlight = self:AddComponent(UIBaseContainer, "highlight")
  self.compRed = self:AddComponent(UIBaseComponent, "RedDot")
end

function UILWDominatorMainSelectItemComponent:ComponentDestroy()
  self.btnUILWDominatorMainSelectItem = nil
  self.imgIcon = nil
  self.textIndex = nil
  self.compHighlight = nil
  self.compIndex = nil
end

function UILWDominatorMainSelectItemComponent:DataDefine()
end

function UILWDominatorMainSelectItemComponent:DataDestroy()
end

function UILWDominatorMainSelectItemComponent:ReInit(mainId, index)
  self.id = mainId
  local info = DataCenter.DominatorManager:GetInfoById(self.id)
  if info then
    local rankTemplate = info:GetCurRankTemplate()
    if rankTemplate then
      local rankShowTemplate = rankTemplate:GetRankShowTemplate()
      if rankShowTemplate and not string.IsNullOrEmpty(rankShowTemplate.pic_path) then
        self.imgIcon:LoadSprite(rankShowTemplate.pic_path)
      end
    end
    local squadIndex = info:GetSquadIndex()
    self.compIndex:SetActive(squadIndex ~= nil)
    if squadIndex ~= nil then
      self.textIndex:SetText(tostring(squadIndex))
    end
  end
end

function UILWDominatorMainSelectItemComponent:UpdateSelect()
  local curShowId = self.view:GetCurShowMainId()
  self.compHighlight:SetActive(curShowId == self.id)
end

function UILWDominatorMainSelectItemComponent:UpdateRed()
  local curShowId = self.view:GetCurShowMainId()
  local isSelect = curShowId == self.id
  local isShowRed = false
  if not isSelect then
    local info = DataCenter.DominatorManager:GetInfoById(self.id)
    if info and DataCenter.DominatorManager:IsUpgradeRankAndSkillUnlock() and (info:IsCanUpgradeRank() or info:GetCanUpgradeSkillCount() > 0) then
      isShowRed = true
    end
  end
  self.compRed:SetActive(isShowRed)
end

function UILWDominatorMainSelectItemComponent:OnAddListener()
  base.OnAddListener(self)
end

function UILWDominatorMainSelectItemComponent:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWDominatorMainSelectItemComponent:OnBtnUILWDominatorMainSelectItemClick()
  if self.id and self.view then
    self.view:SetCurShowMainId(self.id)
  end
end

return UILWDominatorMainSelectItemComponent
