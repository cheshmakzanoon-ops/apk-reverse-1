local PrepareScenePark = BaseClass("PrepareScenePark", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LWHeroRankStar = require("UI.UIHero2.Common.LWHeroRankStar")
local Resource = CS.GameEntry.Resource

function PrepareScenePark:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function PrepareScenePark:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function PrepareScenePark:ComponentDefine()
  self.powerContent = self:AddComponent(UIBaseContainer, "PowerContent")
  self.power = self:AddComponent(UIText, "PowerContent/Power")
  self.heroRankStar = {}
  self.heroLevel = {}
  for i = 1, 5 do
    local level = "Level" .. i
    self.heroLevel[i] = self:AddComponent(UIText, level)
    self.heroRankStar[i] = self:AddComponent(LWHeroRankStar, level .. "/HeroRankStar" .. i)
  end
  self.canvasGroup = self.gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
  self:CanvasShow()
end

function PrepareScenePark:DataDefine()
  self.tank = {}
  self.mainCamera = DataCenter.LWTrainPrepareSceneManager.controlCamera
end

function PrepareScenePark:ComponentDestroy()
  self:ClearFade()
  self.heroRankStar = nil
  self.heroLevel = nil
end

function PrepareScenePark:DataDestroy()
  self.slotList = nil
  self.park = nil
  self.mainCamera = nil
  self.index = 0
  self:ClearTank()
  if self.trigger then
    self.trigger.onPointerClick = nil
    self.trigger = nil
  end
end

function PrepareScenePark:Refresh(index, teamInfo)
  self:RefreshData(index, teamInfo)
  if self.slotList == nil then
    self.slotList = DataCenter.LWTrainPrepareSceneManager:GetParkSlotList(index)
  end
  if self.park == nil then
    self.park = DataCenter.LWTrainPrepareSceneManager:GetPark(index)
    if self.park then
      self.trigger = self.park:GetComponent(typeof(CS.TouchObjectEventTrigger))
      if self.trigger then
        function self.trigger.onPointerClick()
          self:OnTriggerClick()
        end
      end
    end
  end
  if self.slotList ~= nil then
    self:RefreshView()
  end
end

function PrepareScenePark:RefreshPage(curPage)
  self.curPage = curPage
  self:OnUpdate()
end

function PrepareScenePark:OnUpdate()
  if self.slotList == nil then
    self:SetActive(false)
    return
  end
  if self.curPage == TrainPreparePage.Driver then
    self:SetActive(true)
    for i = 1, 5 do
      local tr = self.slotList[i]
      local ca = self.heroLevel[i]
      if tr then
        CS.CSUtils.WorldPositionToUITransform(tr, self.mainCamera, ca.rectTransform, 0, -2)
      end
    end
    if self.park then
      CS.CSUtils.WorldPositionToUITransform(self.park, self.mainCamera, self.powerContent.rectTransform, 0, -6)
    end
  else
    self:SetActive(false)
  end
end

function PrepareScenePark:RefreshData(index, teamInfo)
  self.index = index
  self.teamInfo = teamInfo
end

function PrepareScenePark:RefreshView()
  self.powerContent:SetActive(false)
  local teamInfo = self.teamInfo
  local heroTable = {}
  local squadNo = 0
  if teamInfo then
    squadNo = teamInfo.squadNo
    if teamInfo.totalPower then
      self.powerContent:SetActive(true)
      local totalPower = teamInfo.totalPower
      self.power:SetText(string.GetFormattedStr2(totalPower))
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
  self:RefreshHeroView(squadNo, heroTable)
end

function PrepareScenePark:RefreshHeroView(squadNo, heroTable)
  if self.slotList == nil then
    return
  end
  for i = 1, ArmyFormationSlot.Dominator do
    if self.slotList[i] ~= nil then
      local heroData = heroTable[i]
      local oldReq = self.tank[i]
      if heroData == nil then
        if oldReq then
          oldReq:Destroy()
          self.tank[i] = nil
        end
      else
        local modelPath, appearanceId, modelSourceType = heroData:GetHeroModelData(HeroModelType.Battle)
        local path = modelPath
        local oldPath = oldReq ~= nil and oldReq.PrefabPath or ""
        if not string.IsNullOrEmpty(path) and path ~= oldPath then
          if oldReq ~= nil then
            oldReq:Destroy()
          end
          self.tank[i] = nil
          self.tank[i] = Resource:InstantiateAsync(path)
          self.tank[i]:completed("+", function(request)
            if self.slotList == nil then
              request:Destroy()
              return
            end
            local parent = self.slotList[i]
            if parent == nil then
              request:Destroy()
              return
            end
            local gameObject = request.gameObject
            local transform = gameObject.transform
            transform:SetParent(parent)
            transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            transform:Set_localEulerAngles(ResetPosition.x, ResetPosition.y, ResetPosition.z)
            transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
          end)
        end
      end
    end
  end
end

function PrepareScenePark:ClearTank()
  if self.tank then
    for _, v in pairs(self.tank) do
      v:Destroy()
    end
  end
  self.tank = nil
end

function PrepareScenePark:CanvasHide()
  if self.canvasGroup then
    self.canvasGroup.alpha = 0
  end
end

function PrepareScenePark:CanvasShow()
  if self.canvasGroup then
    self.canvasGroup.alpha = 1
  end
end

function PrepareScenePark:FadeShow()
  self:ClearFade()
  self.canvasTween = self.canvasGroup:DOFade(1, 0.2)
end

function PrepareScenePark:ClearFade()
  if self.canvasTween then
    self.canvasTween:Kill()
    self.canvasTween = nil
  end
end

function PrepareScenePark:OnTriggerClick()
  if self.index > 0 then
    RailwayUtil.OpenTrainDefenceChangeUI(self.index)
  end
end

return PrepareScenePark
