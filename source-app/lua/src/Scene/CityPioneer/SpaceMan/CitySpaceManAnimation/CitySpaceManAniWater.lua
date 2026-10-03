local base = require("Scene.CityPioneer.SpaceMan.CitySpaceManAnimation.CitySpaceManAniBase")
local CitySpaceManAniWater = BaseClass("CitySpaceManAniWater", base)
local _cp_objWater = "A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/guadian/A_soldie_ben_watering"
local _cp_objCollider = "A_soldie_ben/A_soldie@ben_skin/To_unity/DeformationSystem/Root/Root_M/Spine1_M/Chest_M/Scapula_R/Shoulder_R/Elbow_R/objCollider"
local Localization = CS.GameEntry.Localization
local Collider_Oritation = Quaternion.Euler(133, 309, 11)

function CitySpaceManAniWater:__init(spaceman)
  base.__init(self, spaceman)
  local objTransform = self.m_citySpaceMan:GetTransform()
  self.m_objWater = objTransform:Find(_cp_objWater)
  self.m_objWater.gameObject:SetActive(false)
  local objCollider = objTransform:Find(_cp_objCollider)
  self.m_objCollider = objCollider
  if objCollider ~= nil then
    self.m_objBoxCollider = objCollider:GetComponent(typeof(CS.UnityEngine.CapsuleCollider))
  end
  self.showHead = false
end

function CitySpaceManAniWater:OnEnter()
  base.OnEnter(self)
  self:SetActionListen()
  self:SetTriggerListen()
  self.m_objWater.gameObject:SetActive(true)
  self.m_objCollider.gameObject:SetActive(true)
  self.m_objBoxCollider.enabled = true
  self.m_objCollider.transform.localRotation = Collider_Oritation
  self:ShowHead()
end

function CitySpaceManAniWater:OnExit()
  WastelandFarmManager:GetInstance():StopAllWaterSoundEffect()
  self:ClearActionListen()
  self:ClearTriggerListen()
  self.m_objWater.gameObject:SetActive(false)
  self.m_objCollider.gameObject:SetActive(false)
  self:RemoveHead()
  base.OnExit(self)
end

function CitySpaceManAniWater:OnTriggerEnter_Weapon(uuid, resType)
  base.OnTriggerEnter_Weapon(self, uuid, resType)
  local farmTile = WastelandFarmManager:GetInstance():GetTileByObjId(uuid)
  if farmTile ~= nil then
    farmTile:RecvWater()
  end
end

function CitySpaceManAniWater:OnUpdate()
end

function CitySpaceManAniWater:ShowHead()
  local hasShow = Setting:GetPrivateInt(SettingKeys.NEWBIE_FARM_SHOW_HEAD .. Wasteland_PlantState.ToWater, 0) == 1 and true or false
  if not hasShow then
    self.showHead = true
    local headParam = {}
    headParam.dialog = Localization:GetString(GameDialogDefine.START_WATER)
    headParam.modelName = "HeadSpine_ben"
    headParam.modelPosition = 1
    headParam.isRecommend = true
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIGuideHeadTalk) then
      EventManager:GetInstance():Broadcast(EventId.RefreshUIGuideHeadTalk, headParam)
    else
      UIManager:GetInstance():OpenWindow(UIWindowNames.UIGuideHeadTalk, {anim = true, playEffect = false}, headParam)
    end
  end
end

function CitySpaceManAniWater:RemoveHead()
  if self.showHead then
    self.showHead = false
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIGuideHeadTalk, {anim = true, playEffect = false})
  end
end

return CitySpaceManAniWater
