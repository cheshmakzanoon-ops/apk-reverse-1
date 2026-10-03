local BuildHeroCarbarn = BaseClass("BuildHeroCarbarn")
local Resource = CS.GameEntry.Resource
local PlayableDirector = CS.UnityEngine.Playables.PlayableDirector
local AirDropTimeLine1 = "Assets/Main/Prefabs/BuildingHero/zhishengjikongtou_Timeline.prefab"
local AirDropTimeLine2 = "Assets/Main/Prefabs/BuildingHero/zhishengjikongtou_Timeline02.prefab"
local AirDropEffectPrefabPath = "Assets/_Art_LastWar/Effect/Prefab/Arms/APS/VFX_tudou_somke.prefab"
local HeroBoxPrefabPath = "Assets/_Art_LastWar/Models/Characters/Object/A_pror_container_01/prefab/A_pror_container_01_1.prefab"
local HeroBoxOpenPrefabPath = "Assets/_Art_LastWar/Effect/Prefab/Arms/APS/VFX_xinshou_xiangzi_open.prefab"

function BuildHeroCarbarn:__init(param)
  self.param = param
  self.pos = param.pos
  self.squadIndex = param.teamIndex
  self.slotIndex = param.index
  self.buildData = param.buildData
  self.herorId = param.herorId
  self.timelineSyncHandle = nil
  self:Create()
end

function BuildHeroCarbarn:Destroy()
  self.param = nil
  self.pos = nil
  self.index = nil
  self.buildData = nil
  self.herorId = nil
  self.timelineSyncHandle = nil
end

function BuildHeroCarbarn:Create()
  DataCenter.BuildHeroManager.dropAnimCtrl:CreateQuest(self.herorId, self.pos, Vector3(1, 0, 0), Vector3(0, 0, 0), Vector3(0, 0, 0), self.SaveSquad, self)
end

function BuildHeroCarbarn:SaveSquad()
  local hero_uuid = DataCenter.HeroDataManager:GetHeroUuidByHeroId(self.herorId)
  if hero_uuid == nil then
    return
  end
  local squad_data = DataCenter.ArmyFormationDataManager:GetFormationByType(EnterHeroSquadPanelWay.ParkingLotBuilding, self.squadIndex)
  if squad_data == nil then
    return
  end
  squad_data:SetLocalHero(self.slotIndex, hero_uuid)
  SFSNetwork.SendMessage(MsgDefines.NormalFormationInfoSave, squad_data.uuid, squad_data:GenerateServerHeroArray(), 0)
end

return BuildHeroCarbarn
