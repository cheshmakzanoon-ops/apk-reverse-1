local FormationAddHero = BaseClass("FormationAddHero", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local btn_path = ""
local index_txt_path = "indexTxt"
local add_path = "add"
local lock_path = "lock"
local select_effect_path = "add/select"

local function OnCreate(self)
  base.OnCreate(self)
  self.index_text = self:AddComponent(UIText, index_txt_path)
  self.add = self:AddComponent(UIImage, add_path)
  self.lock = self:AddComponent(UIImage, lock_path)
  self.select_effect = self:AddComponent(UIBaseContainer, select_effect_path)
  self.click_btn = self:AddComponent(UIButton, btn_path)
  self.click_btn:SetOnClick(function()
    self:OnSelectClick()
  end)
end

local function OnDestroy(self)
  self.index_text = nil
  self.click_btn = nil
  base.OnDestroy(self)
end

local function InitData(self, index, garage)
  self.index = index
  self.index_text:SetText(self.index)
  local maxNum = self.view.ctrl:GetMaxHeroNum()
  self.isLock = index > maxNum
  self.scienceId = 0
  self.garage = garage
  self.add:SetActive(self.isLock == false)
  self.lock:SetActive(self.isLock)
  self.select_effect:SetActive(false)
  self:OnSelectHeroRefresh()
end

local function OnSelectClick(self)
  if self.isLock == false then
    if self.view.ctrl.isMarch > 0 then
      return
    end
    if self.view.normalState == true then
      self.view:OnHeroSelectClick()
    end
  elseif self.scienceId ~= 0 then
    GoToUtil.GotoScience(self.scienceId)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnSelectHeroSelect, self.OnSelectHeroRefresh)
  self:AddUIListener(EventId.OnCancelHeroSelect, self.OnSelectHeroRefresh)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnSelectHeroSelect, self.OnSelectHeroRefresh)
  self:RemoveUIListener(EventId.OnCancelHeroSelect, self.OnSelectHeroRefresh)
end

local function OnSelectHeroRefresh(self)
  if self.view.ctrl.isMarch > 0 then
    return
  end
  if self.isLock == false then
    local num = self.view.ctrl:GetCanAddHeroNum()
    self.select_effect:SetActive(0 < num)
  end
end

local function GetDeleteObj(self)
end

FormationAddHero.OnCreate = OnCreate
FormationAddHero.OnDestroy = OnDestroy
FormationAddHero.InitData = InitData
FormationAddHero.OnSelectClick = OnSelectClick
FormationAddHero.OnSelectHeroRefresh = OnSelectHeroRefresh
FormationAddHero.OnAddListener = OnAddListener
FormationAddHero.OnRemoveListener = OnRemoveListener
FormationAddHero.GetDeleteObj = GetDeleteObj
return FormationAddHero
