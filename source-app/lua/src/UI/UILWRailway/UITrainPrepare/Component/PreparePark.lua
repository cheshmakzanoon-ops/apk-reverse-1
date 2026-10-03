local PreparePark = BaseClass("PreparePark", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ParkScene = require("Scene.ParkScene.ParkScene")
local RenderTextureFormat = CS.UnityEngine.RenderTextureFormat
local RenderTexture = CS.UnityEngine.RenderTexture
local LWHeroRankStar = require("UI.UIHero2.Common.LWHeroRankStar")
local Resource = CS.GameEntry.Resource
local SquadNumAsset = {
  [1] = "Assets/Main/Sprites/UI/UILWRailwayTrain/lrb_tongmenghuoche_budui5.png",
  [2] = "Assets/Main/Sprites/UI/UILWRailwayTrain/lrb_tongmenghuoche_budui6.png",
  [3] = "Assets/Main/Sprites/UI/UILWRailwayTrain/lrb_tongmenghuoche_budui7.png",
  [4] = "Assets/Main/Sprites/UI/UILWRailwayTrain/lrb_tongmenghuoche_budui8.png"
}

function PreparePark:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function PreparePark:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function PreparePark:ComponentDefine()
  self.btn = self:AddComponent(UIButton, "")
  self.btn:SetOnClick(function()
    self:OnClickChange()
  end)
  self.power = self:AddComponent(UIText, "Power")
  self.heroRankStar = {}
  self.heroLevel = {}
  for i = 1, 5 do
    self.heroRankStar[i] = self:AddComponent(LWHeroRankStar, "HeroRankStar" .. i)
    self.heroLevel[i] = self:AddComponent(UIText, "Level" .. i)
  end
  self.squadNumImg = self:AddComponent(UIImage, "bg/num")
  self.sceneRawImg = self:AddComponent(UIRawImage, "ParkScene")
  if self.renderTexture == nil then
    local rtFormat = RenderTextureFormat.ARGB32
    self.renderTexture = RenderTexture.GetTemporary(436, 400, 24, rtFormat)
    self.renderTexture.name = "park"
    self.sceneRawImg:SetTexture(self.renderTexture)
    self.sceneRawImg:SetEnable(true)
    self.sceneRawImg:SetColor(Color.white)
  end
  self.scene = ParkScene.New(self.renderTexture)
  self.pos = {}
  for i = 1, ArmyFormationSlot.Dominator do
    self.pos[i] = self:AddComponent(UIBaseComponent, "Pos" .. i)
  end
end

function PreparePark:ComponentDestroy()
  self:RemoveHeroEffect()
  if self.timer then
    self.timer:Stop()
    self.timer = nil
  end
  if self.scene then
    self.scene:Destroy()
    self.scene = nil
  end
  if self.renderTexture ~= nil then
    RenderTexture.ReleaseTemporary(self.renderTexture)
    self.renderTexture = nil
  end
  self.pos = {}
end

function PreparePark:DataDefine()
end

function PreparePark:DataDestroy()
end

function PreparePark:OnEnable()
  base.OnEnable(self)
end

function PreparePark:OnDisable()
  base.OnDisable(self)
end

function PreparePark:OnAddListener()
  base.OnAddListener(self)
end

function PreparePark:OnRemoveListener()
  base.OnRemoveListener(self)
end

function PreparePark:Refresh(index, teamInfo, openType, showTeleportEffect)
  self:RefreshData(index, teamInfo, openType)
  if self.timer then
    return
  end
  if showTeleportEffect then
    self:ResetView()
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
      self:RefreshView(true)
    end, 2.7)
  else
    self:RefreshView(false)
  end
end

function PreparePark:RefreshData(index, teamInfo, openType)
  self.index = index
  self.teamInfo = teamInfo
  self.openType = openType
end

function PreparePark:ResetView()
  self.power:SetActive(false)
  for i = 1, 5 do
    self.heroLevel[i]:SetText("")
    self.heroRankStar[i]:ShowRank(1, 0)
  end
  self.scene:SetHero(0, {})
  self.squadNumImg:SetActive(false)
  self:RemoveHeroEffect()
end

function PreparePark:RefreshView(showTeleportEffect)
  self.power:SetActive(false)
  self.timer = nil
  local teamInfo = self.teamInfo
  local heroTable = {}
  local squadNo = 0
  if teamInfo then
    squadNo = teamInfo.squadNo
    if teamInfo.totalPower then
      self.power:SetActive(true)
      self.power:SetText(string.GetFormattedStr2(teamInfo.totalPower))
    end
    if teamInfo.heros then
      for i = 1, ArmyFormationSlot.Dominator do
        local hero = teamInfo.heros[i]
        if hero then
          local heroInfo = HeroInfo.New()
          local result = heroInfo:UpdateFromTemplate(hero.heroId, hero.heroLevel, hero.rankLv, nil, hero.weaponLevel)
          if result then
            heroTable[hero.index] = heroInfo
          end
        end
      end
    end
  end
  for i = 1, 5 do
    local hero = heroTable[i]
    if hero then
      self.heroLevel[i]:SetLocalText(2000275, hero.level)
      self.heroRankStar[i]:ShowRank(hero.rank, hero.maxRank)
    else
      self.heroLevel[i]:SetText("")
      self.heroRankStar[i]:ShowRank(1, 0)
    end
  end
  self.scene:SetHero(squadNo, heroTable)
  if squadNo == 0 then
    self.squadNumImg:SetActive(false)
  else
    self.squadNumImg:SetActive(true)
    self.squadNumImg:LoadSpriteAuto(SquadNumAsset[squadNo])
  end
  if showTeleportEffect then
    self:ShowHeroEffect(heroTable)
  end
end

function PreparePark:ShowHeroEffect(heroTable)
  self:RemoveHeroEffect()
  for i, v in pairs(heroTable) do
    self.effReq[i] = Resource:InstantiateAsync("Assets/_Art_LastWar/Effect/Prefab/UI/Tongmenghuoche/Eff_ui_Tongmenghuoche_chuansong.prefab")
    self.effReq[i]:completed("+", function(req)
      CommonUtil.CallAutoArabicMirrorManually(req)
      local go = req.gameObject
      if IsNull(go) then
        return
      end
      go:SetActive(true)
      local transform = go.transform
      transform:SetParent(self.pos[i].transform)
      transform:Set_localPosition(0, 0, 0)
    end)
  end
end

function PreparePark:RemoveHeroEffect()
  if self.effReq then
    for _, req in pairs(self.effReq) do
      req:Destroy()
    end
  end
  self.effReq = {}
end

function PreparePark:OnClickChange()
  if self.openType == TrainUIOpenType.Prepare then
    RailwayUtil.OpenTrainDefenceChangeUI(self.index)
  end
end

return PreparePark
