local UILWKOFCampaignTeam = BaseClass("UILWKOFCampaignTeam", UIBaseContainer)
local base = UIBaseContainer
local UIHeroCellSmall = require("UI.UIHero2.Common.UIHeroCellSmall")
local UIGray = CS.UIGray
local TeamNoImagePath = {
  "Assets/Main/Sprites/UI/UILWKOFCampaign/zxl_huoche_duijue1.png",
  "Assets/Main/Sprites/UI/UILWKOFCampaign/zxl_huoche_duijue2.png",
  "Assets/Main/Sprites/UI/UILWKOFCampaign/zxl_huoche_duijue3.png"
}
local heroPos = {
  {-89, 88},
  {90, 88},
  {-89, 0},
  {1, 0},
  {90, 0},
  {1, 88}
}
local cellPath = "Assets/Main/Prefabs/UI/LWKOFCampaign/LWKOFCampaignHeroCell.prefab"

function UILWKOFCampaignTeam:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function UILWKOFCampaignTeam:OnDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function UILWKOFCampaignTeam:ComponentDefine()
  self.heroRoot = self:AddComponent(UIBaseContainer, "Bg/HeroRoot")
  self.power = self:AddComponent(UIBaseContainer, "Bg/Power")
  self.powerText = self:AddComponent(UIText, "Bg/Power/PowerText")
  self.numberText = self:AddComponent(UITextMeshProUGUIEx, "Bg/NumberText")
  self.reqs = {}
  self.heroItems = {}
  self.isGray = false
end

function UILWKOFCampaignTeam:ComponentDestroy()
  self:ClearItem()
  self.isGray = false
  self.heroRoot = nil
  self.numberText = nil
end

function UILWKOFCampaignTeam:SetGray(gray)
  self.isGray = gray
  UIGray.SetGray(self.transform, gray, false)
end

function UILWKOFCampaignTeam:RefreshHeroItem(heroItem, heroData)
  local isSelfHero = DataCenter.HeroDataManager:GetHeroByUuid(heroData.heroUuid) ~= nil
  if isSelfHero then
    heroItem:SetData(heroData.heroUuid)
  else
    local dominatorInfo = DataCenter.DominatorManager:GetInfoByUuid(heroData.heroUuid)
    local isSelfDominator = dominatorInfo ~= nil
    if isSelfDominator then
      heroItem:InitWithConfigId(dominatorInfo.dominatorId, nil, nil, dominatorInfo:GetCurRankLv())
    else
      heroItem:InitWithConfigId(heroData.heroId, nil, heroData.heroLevel, heroData.rankLv, heroData.weaponLevel, heroData.awakenLv, heroData.heroSkinId)
    end
  end
end

function UILWKOFCampaignTeam:SetData(heroes, powerStr, teamNo)
  self.heroes = heroes
  if not string.IsNullOrEmpty(powerStr) then
    self.power:SetActive(true)
    self.powerText:SetText(powerStr)
  else
    self.power:SetActive(false)
  end
  if teamNo then
    self.numberText:SetText(tostring(teamNo))
  end
  if self.heroes then
    for i = 1, ArmyFormationSlot.Dominator do
      if self.heroes[i] then
        if self.reqs[i] == nil then
          local request = self:GameObjectInstantiateAsync(cellPath, function(req)
            local cellObj = req.gameObject
            if cellObj == nil then
              return
            end
            cellObj.name = "heroCell" .. i
            local cellTrans = req.gameObject.transform
            cellTrans:SetParent(self.heroRoot.transform)
            cellTrans:Set_localEulerAngles(0, 0, 0)
            cellTrans:Set_localScale(0.75, 0.75, 0.75)
            UIGray.SetGray(cellTrans, self.isGray, false)
            local heroItem = self.heroRoot:AddComponent(UIHeroCellSmall, cellObj.name)
            heroItem:SetAnchoredPositionXY(heroPos[i][1], heroPos[i][2])
            if self.heroes and self.heroes[i] then
              self:RefreshHeroItem(heroItem, self.heroes[i])
              heroItem:SetActive(true)
            else
              heroItem:SetActive(false)
            end
            self.heroItems[i] = heroItem
          end)
          self.reqs[i] = request
        elseif self.heroItems[i] then
          self:RefreshHeroItem(self.heroItems[i], self.heroes[i])
          self.heroItems[i]:SetActive(true)
        end
      elseif self.heroItems[i] then
        self.heroItems[i]:SetActive(false)
      end
    end
  else
    for k, v in pairs(self.heroItems) do
      v:SetActive(false)
    end
  end
  self:SetGray(false)
end

function UILWKOFCampaignTeam:RefreshHp(heroes)
end

function UILWKOFCampaignTeam:ClearItem()
  self.heroRoot:RemoveComponents(UIHeroCellSmall)
  if self.reqs ~= nil then
    for _, v in pairs(self.reqs) do
      self:GameObjectDestroy(v)
    end
  end
  self.reqs = nil
  self.heroItems = nil
end

return UILWKOFCampaignTeam
