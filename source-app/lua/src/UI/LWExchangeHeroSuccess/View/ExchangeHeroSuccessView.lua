local ExchangeHeroSuccessView = BaseClass("ExchangeHeroSuccessView", UIBaseView)
local UIHeroCellBig = require("UI.UIHero2.Common.UIHeroCellBig")
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local panel_path = "UICommonRewardPopUp/Panel"
local source_hero_card_path = "layout/heroList/SourceHeroCard"
local dest_hero_card_path = "layout/heroList/DestHeroCard"
local return_mat_tip_text_path = "layout/ReturnMatTipText"
local confirm_btn_path = "layout/ConfirmBtn"
local u_i_common_res_item_path = "layout/CellList/UICommonResItem"
local cell_list_path = "layout/CellList"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
  local param = self:GetUserData()
  self.sourceHeroUuid = param.srcHeroUuid
  self.destHeroUuid = param.dstHeroUuid
  self.returnMatInfo = param.skillPoint
  self.srcReturnSkillMat = param.srcSkill or 0
  self.dstReturnSkillMat = param.dstSkill or 0
  self:RefreshView()
end

local function OnDestroy(self)
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.closePanelBtn = self:AddComponent(UIButton, panel_path)
  self.closePanelBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.sourceHeroCard = self:AddComponent(UIHeroCellBig, source_hero_card_path)
  self.destHeroCard = self:AddComponent(UIHeroCellBig, dest_hero_card_path)
  self.returnMatTipText = self:AddComponent(UIText, return_mat_tip_text_path)
  self.confirmBtn = self:AddComponent(UIButton, confirm_btn_path)
  self.confirmBtn:SetOnClick(function()
    self.ctrl:CloseSelf()
  end)
  self.commonResObj = self:AddComponent(UIBaseContainer, u_i_common_res_item_path)
  self.commonResObj.gameObject:GameObjectCreatePool()
  self.cellListObj = self:AddComponent(UIBaseContainer, cell_list_path)
end

local function ComponentDestroy(self)
end

local function DataDefine(self)
  self.allRewardList = {}
end

local function DataDestroy(self)
end

local function OnAddListener(self)
  base.OnAddListener(self)
end

local function OnRemoveListener(self)
  base.OnRemoveListener(self)
end

function ExchangeHeroSuccessView:RefreshView()
  if self.sourceHeroUuid then
    self.sourceHeroCard:SetData(self.sourceHeroUuid)
    self.sourceHeroCard:DisableRedPoint()
  end
  if self.destHeroUuid then
    self.destHeroCard:SetData(self.destHeroUuid)
    self.destHeroCard:DisableRedPoint()
  end
  self:RefreshReturnUpgradeMat()
end

function ExchangeHeroSuccessView:RefreshReturnUpgradeMat()
  self.commonResObj.gameObject:GameObjectRecycleAll()
  self.allRewardList = {}
  if not self.returnMatInfo or table.count(self.returnMatInfo) <= 0 then
    self.cellListObj:SetActive(false)
    self.returnMatTipText:SetActive(false)
    return
  end
  self.cellListObj:SetActive(true)
  self.returnMatTipText:SetActive(true)
  local heroData
  if 0 < self.srcReturnSkillMat then
    heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.sourceHeroUuid)
  elseif 0 < self.dstReturnSkillMat then
    heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.destHeroUuid)
  else
    self.returnMatTipText:SetActive(false)
  end
  if heroData then
    local returnSkillMatHeroName = Localization:GetString(heroData.meta.name)
    self.returnMatTipText:SetLocalText("activity_hero_change_complete_tips_1", returnSkillMatHeroName)
  else
    self.returnMatTipText:SetActive(false)
  end
  local index = 1
  for _, v in pairs(self.returnMatInfo) do
    if v.addNum and not (0 >= v.addNum) then
      local obj = self.commonResObj.gameObject:GameObjectSpawn(self.cellListObj.transform)
      local name = "item" .. index
      index = index + 1
      obj.name = name
      local cell = self.cellListObj:AddComponent(UICommonResItem, name)
      v.type = 27
      v.count = v.addNum
      cell:ParseInfo(v)
      table.insert(self.allRewardList, cell)
    end
  end
end

ExchangeHeroSuccessView.OnCreate = OnCreate
ExchangeHeroSuccessView.OnDestroy = OnDestroy
ExchangeHeroSuccessView.OnEnable = OnEnable
ExchangeHeroSuccessView.OnDisable = OnDisable
ExchangeHeroSuccessView.ComponentDefine = ComponentDefine
ExchangeHeroSuccessView.ComponentDestroy = ComponentDestroy
ExchangeHeroSuccessView.DataDefine = DataDefine
ExchangeHeroSuccessView.DataDestroy = DataDestroy
ExchangeHeroSuccessView.OnAddListener = OnAddListener
ExchangeHeroSuccessView.OnRemoveListener = OnRemoveListener
return ExchangeHeroSuccessView
