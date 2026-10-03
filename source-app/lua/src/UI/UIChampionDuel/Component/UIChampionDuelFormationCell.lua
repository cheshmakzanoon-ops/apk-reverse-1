local UIChampionDuelFormationCell = BaseClass("UIChampionDuelFormationCell", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require("UI.UIHero2.Common.UIHeroCellSmall")
local Localization = CS.GameEntry.Localization
local order_text_path = "Top/Order"
local name_text_path = "Top/NameObj/Name"
local edite_btn_path = "Top/NameObj/Edite"
local up_btn_path = "Top/UpBtn"
local down_btn_path = "Top/DownBtn"
local power_txt_path = "Middle/PowerText"
local content_path = "ScrollView/HeroContent"

function UIChampionDuelFormationCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UIChampionDuelFormationCell:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UIChampionDuelFormationCell:ComponentDefine()
  self.order_text = self:AddComponent(UIText, order_text_path)
  self.name_text = self:AddComponent(UIText, name_text_path)
  self.name_text:SetLocalText("champion_duel_tips1075")
  self.edite_btn = self:AddComponent(UIButton, edite_btn_path)
  self.up_btn = self:AddComponent(UIButton, up_btn_path)
  self.down_btn = self:AddComponent(UIButton, down_btn_path)
  self.power_txt = self:AddComponent(UIText, power_txt_path)
  self.content = self:AddComponent(UIBaseContainer, content_path)
  self.heroCells = {}
  self.edite_btn:SetOnClick(BindCallback(self, self.OnBtnEditeClick))
  self.up_btn:SetOnClick(BindCallback(self, self.OnBtnUpClick))
  self.down_btn:SetOnClick(BindCallback(self, self.OnBtnDownClick))
end

function UIChampionDuelFormationCell:ComponentDestroy()
  self.content:RemoveComponents(UIHeroCell)
  self.heroCells = {}
  self.order_text = nil
  self.name_text = nil
  self.edite_btn = nil
  self.up_btn = nil
  self.down_btn = nil
  self.power_txt = nil
  self.content = nil
end

function UIChampionDuelFormationCell:ShowUnLockTip()
  local str = Localization:GetString("champion_duel_tips1173", self.order)
  UIUtil.ShowTips(str)
end

function UIChampionDuelFormationCell:OnBtnEditeClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.info == nil then
    self:ShowUnLockTip()
    return
  end
  UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPVPFormation, {anim = true}, EnterHeroSquadPanelWay.ChampionDuel, self.order)
end

function UIChampionDuelFormationCell:OnBtnUpClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.info == nil then
    self:ShowUnLockTip()
    return
  end
  DataCenter.ChampionDuelManager:SendSaveTeamIndex(self.order, self.info.index, true)
end

function UIChampionDuelFormationCell:OnBtnDownClick()
  DataCenter.LWSoundManager:PlayEffect(SoundAssetId.SFX_UI_General_Click_1st)
  if self.info == nil then
    self:ShowUnLockTip()
    return
  end
  DataCenter.ChampionDuelManager:SendSaveTeamIndex(self.order, self.info.index, false)
end

function UIChampionDuelFormationCell:UpdateInfo(index)
  local mIdx = self.info ~= nil and self.info.index or nil
  if index == nil or index ~= mIdx then
    return
  end
  local teamInfo = DataCenter.ChampionDuelManager:GetMyTeamInfo()
  local teamData = teamInfo ~= nil and teamInfo:GetTeamDataByIndex(index) or nil
  if teamData == nil then
    return
  end
  self.info = teamData
  self:RefreshHeroes()
end

function UIChampionDuelFormationCell:RefreshData(order, maxOrder, heroCell, teamData)
  self.order = order
  self.info = teamData
  self.prefab = heroCell.gameObject
  local canUp = 1 < order and teamData ~= nil
  CS.UIGray.SetGray(self.up_btn.transform, not canUp, canUp)
  local canDown = order < maxOrder
  CS.UIGray.SetGray(self.down_btn.transform, not canDown, canDown)
  self.order_text:SetText(order)
  self:RefreshHeroes()
end

function UIChampionDuelFormationCell:RefreshHeroes()
  local teamData = self.info
  if teamData then
    local hero = teamData.heroes[6]
    self:UpdateHeroCell(6, hero)
    for i = 1, 5 do
      hero = teamData.heroes[i]
      self:UpdateHeroCell(i, hero, true)
    end
  end
  local power = teamData ~= nil and teamData.power or 0
  self.power_txt:SetText(string.GetFormattedSeperatorNum(math.floor(power)))
end

function UIChampionDuelFormationCell:UpdateHeroCell(i, hero, bHero)
  local obj = self.heroCells[i]
  if not obj then
    local item = self.prefab:GameObjectSpawn(self.content.transform)
    item.name = "item" .. i
    obj = self.content:AddComponent(UIHeroCell, item.name)
  end
  if hero then
    obj:SetActive(true)
    if bHero then
      obj:SetHeroData(hero.heroInfo)
    else
      obj:InitWithConfigId(hero.heroId, nil, nil, hero.rankLv)
    end
  else
    obj:SetActive(false)
  end
  self.heroCells[i] = obj
end

return UIChampionDuelFormationCell
