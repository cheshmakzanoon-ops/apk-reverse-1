local BuildHeroManager = BaseClass("BuildHeroManager")
local BuildHero = require("DataCenter.BuildManager.BuildHero")
local BuildHeroCarbarn = require("DataCenter.BuildManager.BuildHeroCarbarn")
local DropAnimCtrl = require("DataCenter.BuildManager.BuildHeroDropAnimCtrl")

function BuildHeroManager:__init()
  self.buildHeroDict = {}
  self.newHeroList = {}
  self:AddListener()
  self.dropAnimCtrl = DropAnimCtrl.New()
end

function BuildHeroManager:__delete()
  self:Destroy()
  self:RemoveListener()
  self.dropAnimCtrl:Delete()
end

function BuildHeroManager:Destroy()
  for _, v in pairs(self.buildHeroDict) do
    v:Destroy()
  end
  self.buildHeroDict = {}
end

function BuildHeroManager:Startup()
end

function BuildHeroManager:AddListener()
  if self.showBuildHero == nil then
    function self.showBuildHero()
      self:ShowBuildHero()
    end
    
    EventManager:GetInstance():AddListener(EventId.ShowCityDome, self.showBuildHero)
  end
  if self.hideBuildHero == nil then
    function self.hideBuildHero()
      self:HideBuildHero()
    end
    
    EventManager:GetInstance():AddListener(EventId.HideCityDome, self.hideBuildHero)
  end
  if self.armyFormatUpdate == nil then
    function self.armyFormatUpdate()
      self:ArmyFormatUpdate()
    end
    
    EventManager:GetInstance():AddListener(EventId.ArmyFormatUpdate, self.armyFormatUpdate)
  end
  if self.OnHeroModelChange == nil then
    function self.OnHeroModelChange(heroId)
      self:UpdateBuildHero(heroId)
    end
    
    EventManager:GetInstance():AddListener(EventId.HeroModelChange, self.OnHeroModelChange)
  end
end

function BuildHeroManager:RemoveListener()
  if self.showBuildHero ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.ShowCityDome, self.showBuildHero)
    self.showBuildHero = nil
  end
  if self.hideBuildHero ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.HideCityDome, self.hideBuildHero)
    self.hideBuildHero = nil
  end
  if self.armyFormatUpdate ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.ArmyFormatUpdate, self.armyFormatUpdate)
    self.armyFormatUpdate = nil
  end
  if self.OnHeroModelChange ~= nil then
    EventManager:GetInstance():RemoveListener(EventId.HeroModelChange, self.OnHeroModelChange)
    self.OnHeroModelChange = nil
  end
end

function BuildHeroManager:ShowBuildHero()
  self.buildHeroDict = {}
  local buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.LW_BUILD_HERO)
  for _, buildData in ipairs(buildDataList) do
    local build_info = {
      pId = buildData.pointId,
      bId = buildData.itemId,
      prodStatus = buildData.prodStatus,
      uuid = buildData.uuid
    }
    self:AddBuildHero(build_info, true)
  end
end

function BuildHeroManager:HideBuildHero()
  self:Destroy()
end

function BuildHeroManager:RemoveHeroFromDropList(hero_id)
  for i = 1, #self.newHeroList do
    if self.newHeroList[i] == hero_id then
      table.remove(self.newHeroList, i)
      EventManager:GetInstance():Broadcast(EventId.HeroDropListModified, hero_id)
      break
    end
  end
end

function BuildHeroManager:CreateBuildHero(hero_id)
  self:RemoveHeroFromDropList(hero_id)
  local info = DataCenter.CityCarbarnManager:GetVacancyPos()
  if info ~= nil then
    info.herorId = hero_id
    if info.teamIndex == nil or info.pos == nil then
      return
    end
    local hero_data = DataCenter.HeroDataManager:GetHeroByHeroId(hero_id)
    if hero_data == nil then
      return
    end
    BuildHeroCarbarn.New(info)
  else
    local point = BuildingUtils.GetPointByBuildCanPut(BuildingTypes.LW_BUILD_HERO, SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget))
    if point == nil then
      UIUtil.ShowTipsId(800356)
      local mainUIView = UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View
      print(mainUIView.bottom.heroBtn)
      local srcPos = mainUIView.bottom.heroBtn.transform.position
      local dstPos = UIUtil.GetFlyTargetByRewardType(RewardType.HERO)
      local heroIcon = HeroUtils.GetHeroIconPath(hero_id, HeroIconType.small_icon)
      UIUtil.DoFlyCustom(heroIcon, nil, 1, srcPos, dstPos)
      return
    end
    local param = {}
    param.buildingId = BuildingTypes.LW_BUILD_HERO
    param.pointId = point
    param.itemUuid = ""
    param.pathTime = 0
    param.robotUuid = 0
    param.heroId = hero_id
    param.targetServerId = LuaEntry.Player:GetCurServerId()
    SFSNetwork.SendMessage(MsgDefines.FreeBuildingPlaceNew, param)
  end
end

function BuildHeroManager:DeleteBuildHero(hero_id)
  if self.buildHeroDict[hero_id] == nil then
    self:RemoveHeroFromDropList(hero_id)
    return
  end
  local uuid = self.buildHeroDict[hero_id]:GetBuildUuid()
  SFSNetwork.SendMessage(MsgDefines.FreeBuildingFoldUpNew, {buildUuid = uuid})
end

function BuildHeroManager:AddBuildHero(build_info, is_init)
  if build_info.prodStatus then
    self.buildHeroDict[build_info.prodStatus] = BuildHero.New(build_info, is_init)
  end
end

function BuildHeroManager:RemoveBuildHero(hero_id)
  if hero_id and self.buildHeroDict[hero_id] then
    self.buildHeroDict[hero_id]:Destroy()
    self.buildHeroDict[hero_id] = nil
  end
end

function BuildHeroManager:MoveBuildHero(build_info)
  if build_info and self.buildHeroDict[build_info.prodStatus] then
    TimerManager:GetInstance():DelayInvoke(function()
      self.buildHeroDict[build_info.prodStatus]:Reset(build_info)
    end, 0.2)
  end
end

function BuildHeroManager:ShowHeroInfo(pointId)
  local build_data = DataCenter.BuildManager:GetBuildingDataByPointId(pointId)
  local hero_data = DataCenter.HeroDataManager:GetHeroByHeroId(build_data.prodStatus)
  if hero_data ~= nil then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroDetailPanel, {anim = false}, hero_data.uuid, {
      hero_data.uuid
    })
  end
end

function BuildHeroManager:AddFormationHero(data)
end

function BuildHeroManager:AddNewHero(hero_id)
  if self.buildHeroDict[hero_id] ~= nil then
    return
  end
  self.newHeroList = self.newHeroList or {}
  for _, v in ipairs(self.newHeroList) do
    if v == hero_id then
      return
    end
  end
  table.insert(self.newHeroList, hero_id)
  EventManager:GetInstance():Broadcast(EventId.HeroDropListModified, hero_id)
end

function BuildHeroManager:CheckNewHero()
  local hero_id = self.newHeroList[1] or nil
  if hero_id ~= nil then
    self:CreateBuildHero(hero_id)
  end
end

function BuildHeroManager:GetNewHeroNum()
  return table.count(self.newHeroList)
end

function BuildHeroManager:HasBuildHero(hero_id)
  if self.buildHeroDict[hero_id] then
    return true
  end
  return false
end

function BuildHeroManager:CheckHeroSquad(hero_uuid, squadIdx)
  local squad_data = DataCenter.ArmyFormationDataManager:GetFormationByType(1, squadIdx)
  if squad_data == nil then
    return false
  end
  local local_heros = squad_data:GetLocalAllHeroes()
  for _, uuid in pairs(local_heros) do
    if hero_uuid == uuid then
      return true
    end
  end
  return false
end

function BuildHeroManager:ArmyFormatUpdate()
  local squad_data = DataCenter.ArmyFormationDataManager:GetFormationByType(1, 1)
  if squad_data == nil then
    return
  end
  local local_heros = squad_data:GetLocalAllHeroes()
  for _, uuid in pairs(local_heros) do
    local hero_data = DataCenter.HeroDataManager:GetHeroByUuid(uuid)
    if hero_data then
      self:RemoveHeroFromDropList(hero_data.heroId)
    end
  end
end

function BuildHeroManager:UpdateBuildHero(heroId)
  if self.buildHeroDict and self.buildHeroDict[heroId] then
    self.buildHeroDict[heroId]:ReloadHero()
  end
end

return BuildHeroManager
