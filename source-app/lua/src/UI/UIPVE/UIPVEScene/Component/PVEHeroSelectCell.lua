local PVEHeroSelectCell = BaseClass("PVEHeroSelectCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local hero_path = "UIHeroCellSmall"
local select_obj_path = "selectObj"
local in_march_obj_path = "inMarchObj"
local lock_obj_path = "lockObj"
local in_march_des_path = "inMarchObj/inMarchDes"
local form_obj_path = "inFormBg"
local form_index_num_path = "inFormBg/indexNum"
local champion_in_diff_formation_cover_path = "champion_in_diff_formation_cover"
local soldier_num_path = "funNum"
local rest_count_bg_path = "RestCountBg"
local rest_count_path = "RestCountBg/RestCount"
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local function OnCreate(self)
  base.OnCreate(self)
  self.heroBase = self:AddComponent(UIHeroCell, hero_path)
  self.select_obj = self:AddComponent(UIBaseContainer, select_obj_path)
  self.in_march_obj = self:AddComponent(UIBaseContainer, in_march_obj_path)
  self.lock_obj = self:AddComponent(UIBaseContainer, lock_obj_path)
  self.in_march_des = self:AddComponent(UIText, in_march_des_path)
  self.in_march_des:SetLocalText(300506)
  self.form_obj = self:AddComponent(UIBaseContainer, form_obj_path)
  self.form_index_num = self:AddComponent(UIText, form_index_num_path)
  self.soldier_num = self:AddComponent(UIText, soldier_num_path)
  self.rest_count_bg_go = self:AddComponent(UIBaseContainer, rest_count_bg_path)
  self.rest_count_text = self:AddComponent(UIText, rest_count_path)
  self.champion_in_diff_formation_cover = self:AddComponent(UIImage, champion_in_diff_formation_cover_path)
end

local function SetItemShow(self, data)
  self.uuid = data
  self.heroBase:SetData(self.uuid, function()
    self:OnSelectClick()
  end)
  self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
  self.heroId = self.data.heroId
  self.in_march_obj:SetActive(false)
  self.select_obj:SetActive(self.data.isSelect)
  self.lock_obj:SetActive(false)
  self.form_obj:SetActive(false)
  self.soldier_num:SetText(string.GetFormattedSeperatorNum(math.floor(self.data.power)))
  local entranceType = DataCenter.BattleLevel:GetEntranceType()
  self.isLocked = false
  if entranceType == PveEntrance.MineCave then
    local isLocked = DataCenter.MineCaveManager:CheckIfHeroIsBusy(self.data.heroId)
    self.isLocked = isLocked
    self.lock_obj:SetActive(isLocked)
  else
    self.lock_obj:SetActive(false)
  end
  self.champion_in_diff_formation_cover:SetActive(false)
  self.isMaxLevelExceeded = self.data.level > DataCenter.BattleLevel:GetMaxHeroLevel()
  if self.isMaxLevelExceeded then
    UIGray.SetGray(self.transform, true, true)
  else
    UIGray.SetGray(self.transform, false, true)
  end
  if self.data.restCount then
    self.rest_count_bg_go:SetActive(true)
    self.rest_count_text:SetText(self.data.restCount)
  else
    self.rest_count_bg_go:SetActive(false)
  end
end

local function OnSelectClick(self)
  if self.isLocked then
    return
  end
  if self.isMaxLevelExceeded then
    UIUtil.ShowTips(Localization:GetString("400071", DataCenter.BattleLevel:GetMaxHeroLevel()))
    return
  end
  self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
  if self.data.isSelect == false then
    self.view.ctrl:SelectHeroByUuid(self.uuid)
    self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
    if self.data.index > 0 then
      local pos = self.select_obj.transform.position
      self.view:OnSelectHeroFinish(self.data, true, pos)
    end
  elseif self.data.isSelect == true and self.data.index ~= nil then
    local index = self.data.index
    self.view.ctrl:OnDeleteHeroByIndex(index)
    self.select_obj:SetActive(false)
    self.view:OnSelectHeroFinish(self.data, false)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnSelectPVEHeroSelect, self.RefreshSelectState)
  self:AddUIListener(EventId.OnCancelPVEHeroSelect, self.RefreshState)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnSelectPVEHeroSelect, self.RefreshSelectState)
  self:RemoveUIListener(EventId.OnCancelPVEHeroSelect, self.RefreshState)
end

local function RefreshSelectState(self, data)
  if self.heroId == data then
    self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
    self.select_obj:SetActive(self.data.isSelect)
  end
end

local function RefreshState(self, data)
  if self.heroId == data then
    self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
    self.select_obj:SetActive(self.data.isSelect)
  end
end

local function GetAddObj(self)
  return self.heroBase.gameObject
end

PVEHeroSelectCell.OnCreate = OnCreate
PVEHeroSelectCell.SetItemShow = SetItemShow
PVEHeroSelectCell.OnSelectClick = OnSelectClick
PVEHeroSelectCell.OnAddListener = OnAddListener
PVEHeroSelectCell.OnRemoveListener = OnRemoveListener
PVEHeroSelectCell.RefreshSelectState = RefreshSelectState
PVEHeroSelectCell.RefreshState = RefreshState
PVEHeroSelectCell.GetAddObj = GetAddObj
return PVEHeroSelectCell
