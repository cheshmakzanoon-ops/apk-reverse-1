local HeroBountySelectHeroItem = BaseClass("HeroBountySelectHeroItem", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local hero_path = "UIHeroCellSmall"
local select_obj_path = "selectObj"
local in_march_obj_path = "inMarchObj"
local lock_obj_path = "lockObj"
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
  base.OnCreate(self)
  self.heroBase = self:AddComponent(UIHeroCell, hero_path)
  self.select_obj = self:AddComponent(UIBaseContainer, select_obj_path)
  self.in_march_obj = self:AddComponent(UIBaseContainer, in_march_obj_path)
  self.lock_obj = self:AddComponent(UIBaseContainer, lock_obj_path)
end

local function SetItemShow(self, data)
  self.uuid = data
  self.heroBase:SetData(self.uuid, function()
    self:OnSelectClick()
  end)
  self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
  self.heroId = self.data.heroId
  self.select_obj:SetActive(self.data.isSelect)
  self.lock_obj:SetActive(self.data.isLock)
end

local function OnSelectClick(self)
  self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
  if self.view.taskData == nil then
    return
  end
  if self.data.isSelect == false and self.data.isLock == false then
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.uuid)
    if heroData ~= nil then
      if heroData:CanBeyond() == true then
        local str = "<color=#ff0000>" .. heroData:GetName() .. "</color>"
        local content = Localization:GetString("161022", str)
        UIUtil.ShowMessage(content, 2, "161030", "161023", function()
          self.view.ctrl:SelectHeroByUuid(self.uuid, self.view.taskData.needHeroNum)
          self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
          if self.data.index > 0 then
            self.view:OnSelectHeroFinish(self.data.index)
          end
        end, function()
          local heroList = {}
          table.insert(heroList, self.uuid)
          UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroInfo, 1, self.uuid, heroList)
        end)
      else
        self.view.ctrl:SelectHeroByUuid(self.uuid, self.view.taskData.needHeroNum)
        self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
        if self.data.index > 0 then
          self.view:OnSelectHeroFinish(self.data.index)
        end
      end
    end
  elseif self.data.isLock == true then
    UIUtil.ShowTipsId(132224)
  elseif self.data.isSelect == true and self.data.index ~= nil then
    local index = self.data.index
    self.view.ctrl:OnDeleteHeroByIndex(index)
    self.select_obj:SetActive(false)
    self.view:OnSelectHeroFinish(index)
  end
end

local function OnAddListener(self)
  base.OnAddListener(self)
  self:AddUIListener(EventId.OnCancelHeroSelectForBounty, self.RefreshState)
  self:AddUIListener(EventId.OnSelectHeroSelectForBounty, self.RefreshSelectState)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
  self:RemoveUIListener(EventId.OnSelectHeroSelectForBounty, self.RefreshSelectState)
  self:RemoveUIListener(EventId.OnCancelHeroSelectForBounty, self.RefreshState)
end

local function RefreshState(self, data)
  if self.heroId == data then
    self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
    self.select_obj:SetActive(self.data.isSelect)
    self.lock_obj:SetActive(self.data.isLock)
  end
end

local function RefreshSelectState(self, data)
  if self.heroId == data then
    self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
    self.select_obj:SetActive(self.data.isSelect)
    self.lock_obj:SetActive(self.data.isLock)
  end
end

HeroBountySelectHeroItem.OnCreate = OnCreate
HeroBountySelectHeroItem.SetItemShow = SetItemShow
HeroBountySelectHeroItem.OnSelectClick = OnSelectClick
HeroBountySelectHeroItem.RefreshState = RefreshState
HeroBountySelectHeroItem.OnAddListener = OnAddListener
HeroBountySelectHeroItem.OnRemoveListener = OnRemoveListener
HeroBountySelectHeroItem.RefreshSelectState = RefreshSelectState
HeroBountySelectHeroItem.GetAddObj = GetAddObj
return HeroBountySelectHeroItem
