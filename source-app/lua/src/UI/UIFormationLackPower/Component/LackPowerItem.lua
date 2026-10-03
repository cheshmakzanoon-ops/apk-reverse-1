local LackPowerItem = BaseClass("LackPowerItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local recommend_path = "AddBtn/Recommend"
local item_icon_path = "AddBtn/icon"
local item_path = "AddBtn/Item"
local name_text_path = "AddBtn/Rect_Desc/Name_Txt"
local add_btn_path = "AddBtn"
local desc_text_path = "AddBtn/Rect_Desc/Desc_Txt"
local gift_rect_path = "AddBtn/Rect_Gift"
local go_btn_path = "Btn_Go"
local go_txt_path = "Btn_Go/Txt_Go"
local price_rect_path = "Btn_Go/Rect_Price"
local gift_btn_path = "Btn_Gift"
local buy_text_path = "AddBtn/Txt_BuyNum"
local consume_rect_path = "AddBtn/Rect_Consume"

local function OnCreate(self)
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

local function OnEnable(self)
  base.OnEnable(self)
end

local function OnDisable(self)
  base.OnDisable(self)
end

local function ComponentDefine(self)
  self.recommend_rect = self:AddComponent(UIBaseContainer, recommend_path)
  self.item_icon = self:AddComponent(UIImage, item_icon_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self._add_btn = self:AddComponent(UIButton, add_btn_path)
  self.gift_rect = self:AddComponent(UIBaseContainer, gift_rect_path)
  self._add_btn:SetOnClick(function()
  end)
  self.go_btn = self:AddComponent(UIButton, go_btn_path)
  self.go_btn:SetOnClick(function()
    DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
    self:OnBtnClick()
  end)
  self.go_txt = self:AddComponent(UIText, go_txt_path)
  self.price_rect = self:AddComponent(UIBaseContainer, price_rect_path)
  self._buy_text = self:AddComponent(UIText, buy_text_path)
  self.desc_text = self:AddComponent(UIText, desc_text_path)
  self.item = self:AddComponent(UIBaseContainer, item_path)
  self.gift_btn = self:AddComponent(UIButton, gift_btn_path)
  self.consume_rect = self:AddComponent(UIBaseContainer, consume_rect_path)
end

local function ComponentDestroy(self)
  self.recommend_rect = nil
  self.item_icon = nil
  self.name_text = nil
  self._add_btn = nil
end

local function DataDefine(self)
  self.param = {}
end

local function DataDestroy(self)
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  self._add_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_bg_item2"))
  self:ShowRecommend(false)
  self.item_icon:SetActive(true)
  self.item_icon:LoadSprite(string.format(LoadPath.ResLackIcons, self.param.pic))
  self.name_text:SetText(Localization:GetString(self.param.name))
  self.go_txt:SetActive(true)
  self.gift_rect:SetActive(false)
  self.gift_btn:SetActive(false)
  self.desc_text:SetActive(false)
  self.price_rect:SetActive(false)
  self.consume_rect:SetActive(false)
  self._buy_text:SetActive(false)
  self.item:SetActive(false)
  self.go_btn:SetActive(true)
  self.go_txt:SetText(param.btnName)
end

local function ShowRecommend(self, isRecommend)
  self.recommend_rect:SetActive(isRecommend)
end

local function OnBtnClick(self)
  if self.param ~= nil then
    if self.param.selectType == FormationAddSoldierType.KillMonster then
      local level = self.view.curMonsterLevel - 1
      if level <= 0 then
        level = 1
      end
      GoToUtil.CloseAllWindows()
      SceneUtils.ChangeToWorld(function()
        GoToUtil.GotoOpenView(UIWindowNames.UISearch, UISearchType.Monster, level)
      end)
      return
    elseif self.param.selectType == FormationAddSoldierType.TrainSoldier then
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_INFANTRY_BARRACK, WorldTileBtnType.City_TrainingInfantry)
      return
    elseif self.param.selectType == FormationAddSoldierType.RadarMonster then
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_RADAR_CENTER, WorldTileBtnType.RadarCenter_Detective)
      return
    elseif self.param.selectType == FormationAddSoldierType.ThirdHeroBuild then
      GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_TRAINFIELD_1, WorldTileBtnType.GarageRefit)
      return
    elseif self.param.selectType == FormationAddSoldierType.FormationScience then
      if self.param.para1 ~= nil then
        local scienceTab = tonumber(self.param.para1)
        GoToUtil.GotoScience(nil, scienceTab)
        self.view.ctrl:CloseSelf()
        return
      end
    elseif self.param.selectType == FormationAddSoldierType.HeroUpgrade then
      if self.param.para1 ~= nil then
        local buildId = tonumber(self.param.para1)
        GoToUtil.GotoCityByBuildId(buildId, WorldTileBtnType.LevelExplore)
      end
      return
    elseif self.param.selectType == FormationAddSoldierType.HeroExchange then
      local heroUuid = self.param.heroUuid
      local targetHeroUuid = self.param.targetHeroUuid
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationTableNew, self.view.ctrl.uuid, -1, -1, 0, -1, 1, 0, nil, 0, heroUuid, targetHeroUuid)
      self.view.ctrl:CloseSelf()
      return
    end
  end
  self.view.ctrl:CloseSelf()
end

LackPowerItem.OnCreate = OnCreate
LackPowerItem.OnDestroy = OnDestroy
LackPowerItem.OnBtnClick = OnBtnClick
LackPowerItem.OnEnable = OnEnable
LackPowerItem.OnDisable = OnDisable
LackPowerItem.ComponentDefine = ComponentDefine
LackPowerItem.ComponentDestroy = ComponentDestroy
LackPowerItem.DataDefine = DataDefine
LackPowerItem.DataDestroy = DataDestroy
LackPowerItem.ReInit = ReInit
LackPowerItem.ShowRecommend = ShowRecommend
return LackPowerItem
