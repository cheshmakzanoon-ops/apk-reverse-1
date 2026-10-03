local UILWMailDetailAllOut = BaseClass("UILWMailDetailAllOut", UIBaseContainer)
local base = UIBaseContainer
local ArmyInfo = require("DataCenter.WorldMarchDataManager.ArmyInfo")
local MailHeroItem = require("UI.UILWMail.UILWMailMain.Component.MailHeroItem")
local Localization = CS.GameEntry.Localization
local detail_title_path = "DetailTitle"
local sub_title_path = "ScrollView/Viewport/Content/SubTitle"
local team_path = "ScrollView/Viewport/Content/train/team"
local power_path = "ScrollView/Viewport/Content/train/power"
local mail_hero_item_path = "ScrollView/Viewport/Content/train/heroList/MailHeroItem"
local slider_path = "ScrollView/Viewport/Content/train/Slider"
local soldier_num_path = "ScrollView/Viewport/Content/train/Slider/soldierNum"
local detail_time_path = "DetailTimeBg/DetailTime"
local soldier_title_path = "ScrollView/Viewport/Content/train/SoldierTitle"
local rapidjson = require("rapidjson")

function UILWMailDetailAllOut:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function UILWMailDetailAllOut:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWMailDetailAllOut:DataDefine()
  self.mailUid = {}
  self.mailData = {}
end

function UILWMailDetailAllOut:DataDestroy()
  self.mailUid = nil
  self.mailData = nil
end

function UILWMailDetailAllOut:OnEnable()
  base.OnEnable(self)
end

function UILWMailDetailAllOut:OnDisable()
  base.OnDisable(self)
end

function UILWMailDetailAllOut:OnAddListener()
  base.OnAddListener(self)
end

function UILWMailDetailAllOut:OnRemoveListener()
  base.OnRemoveListener(self)
end

function UILWMailDetailAllOut:ComponentDefine()
  self.detail_title = self:AddComponent(UITextMeshProUGUIEx, detail_title_path)
  self.sub_title = self:AddComponent(UITextMeshProUGUIEx, sub_title_path)
  self.team = self:AddComponent(UITextMeshProUGUIEx, team_path)
  self.power = self:AddComponent(UITextMeshProUGUIEx, power_path)
  self.slider = self:AddComponent(UISlider, slider_path)
  self.soldier_num = self:AddComponent(UITextMeshProUGUIEx, soldier_num_path)
  self.soldier_title = self:AddComponent(UITextMeshProUGUIEx, soldier_title_path)
  self.soldier_title:SetLocalText("135181")
  self.detail_time = self:AddComponent(UITextMeshProUGUIEx, detail_time_path)
  self.heroItems = {}
  for i = 1, 5 do
    self.heroItems[i] = self:AddComponent(MailHeroItem, mail_hero_item_path .. i)
  end
end

function UILWMailDetailAllOut:ComponentDestroy()
  if self.armyInfo then
    self.armyInfo:Delete()
    self.armyInfo = nil
  end
end

function UILWMailDetailAllOut:RefreshContent()
  self.mailUid = self.view.ctrl:GetCurrentMail()
  self.mailData = self.view.ctrl:GetCurrentMailData()
  local _strTime = MailShowHelper.GetAbstractCreateTime(self.mailData)
  self.detail_time:SetText(_strTime)
  local _strTitle = MailShowHelper.GetMainTitle(self.mailData)
  self.detail_title:SetText(_strTitle)
  local _strContents = self.mailData:GetMailMessage()
  self.sub_title:SetText(_strContents)
  local msg = rapidjson.decode(self.mailData.contents)
  if msg and msg.obj then
    for _, v in pairs(msg.obj.combatInfos) do
      local armyUnit = PBController.ParsePb1(v, "protobuf.ArmyCombatUnit")
      if armyUnit then
        local armyInfo = ArmyInfo.New()
        armyInfo.health = armyUnit.simpleCombatUnit.health
        armyInfo.initHealth = armyUnit.simpleCombatUnit.initHealth
        armyInfo.uid = armyUnit.simpleCombatUnit.uid
        armyInfo:UpdateArmyList(armyUnit.armyInfo)
        self.armyInfo = armyInfo
        break
      end
    end
    self.teamNo = msg.obj.index or 1
    self.armyPower = msg.obj.power or 0
    self:RefreshArmyView()
  end
end

function UILWMailDetailAllOut:RefreshArmyView()
  self.team:SetText(Localization:GetString("457590") .. self.teamNo)
  self.power:SetText(string.GetFormattedSeparatorNum(self.armyPower))
  self:RefreshHero()
end

function UILWMailDetailAllOut:RefreshHero()
  local heroInfo = self.armyInfo.HeroInfos
  local _, _, soldierInfo, _ = MarchUtil.GetSoldierData(self.armyInfo)
  local totalRealCount = 0
  local totalMaxCount = 0
  for i = 1, 5 do
    local heroData
    for _, v in pairs(heroInfo) do
      if v.index == i then
        heroData = v
        break
      end
    end
    if heroData then
      local hero = DataCenter.HeroDataManager:GetHeroByUuid(heroData.heroUuid)
      local maxCount = 1
      if hero then
        maxCount = hero:GetSoldierCapacity()
      end
      if not maxCount or maxCount == 0 then
        maxCount = 1
      end
      local realCount = soldierInfo[i]
      local percent = realCount / maxCount
      totalRealCount = totalRealCount + realCount
      totalMaxCount = totalMaxCount + maxCount
      self.heroItems[i]:SetData(heroData.heroId, heroData.heroLevel, heroData.rankLv, realCount, percent, heroData.weaponLevel, heroData.awakenLv, heroData.heroSkinId)
    else
      self.heroItems[i]:SetData(nil)
    end
  end
  self.slider:SetValue(totalRealCount / totalMaxCount)
  self.soldier_num:SetText(string.format("%s/%s", string.GetFormattedSeparatorNum(totalRealCount), string.GetFormattedSeparatorNum(totalMaxCount)))
end

return UILWMailDetailAllOut
