local CitySpaceManPlantCom = BaseClass("CitySpaceManPlantCom")

function CitySpaceManPlantCom:__init(spaceman)
  self.m_deltaT = 0
  self.m_citySpaceMan = spaceman
  self.m_curState = -1
end

function CitySpaceManPlantCom:GetCurFarmAreaType()
  local worldPos = self.m_citySpaceMan:GetPosition()
  local farmArea = WastelandFarmManager:GetInstance():IsInFarmArea(worldPos)
  if farmArea ~= nil then
    return farmArea:GetResType()
  end
  return -1
end

function CitySpaceManPlantCom:CheckPlant()
  local worldPos = self.m_citySpaceMan:GetPosition()
  local farmArea = WastelandFarmManager:GetInstance():IsInFarmArea(worldPos)
  if farmArea ~= nil then
    WastelandFarmManager:GetInstance():ToggleArrow(false)
    local state = farmArea:GetAreaPlantState()
    if self.m_curState ~= -1 and self.m_curState ~= state then
      self.m_citySpaceMan:LeaveFarmMode()
      WastelandFarmManager:GetInstance():ToggleArrowDetection(false)
    end
    if self.m_curState == Wasteland_PlantState.ToReap and state == Wasteland_PlantState.ToPlant then
      self.m_curState = state
      Setting:SetPrivateInt(SettingKeys.NEWBIE_FARM_SHOW_HEAD .. Wasteland_PlantState.ToReap, 1)
      local triggerId = DataCenter.CityTriggerPointDataManager:FindTriggerByTagType("3")
      if triggerId then
        local t = DataCenter.CityTriggerPointDataManager:GetTriggerPointDataFromId(triggerId)
        if t and t:GetTagPara() ~= nil then
          DataCenter.GuideManager:SetCurGuideId(t:GetTagPara())
          DataCenter.GuideManager:DoGuide()
        end
      end
      return
    end
    self:CheckHasToReap()
    if state == Wasteland_PlantState.ToPlant then
      self:ToPlant()
    elseif state == Wasteland_PlantState.ToWater then
      self:ToWater()
    elseif state == Wasteland_PlantState.ToReap then
      self:ToReap()
    end
  else
    self:LeaveFarmMode()
    WastelandFarmManager:GetInstance():ToggleArrow(true)
  end
end

function CitySpaceManPlantCom:ToPlant()
  if self.m_curState == Wasteland_PlantState.ToPlant then
    return
  end
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFarmAction) then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_show_to_plant, false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarmAction, {anim = false, playEffect = false}, Wasteland_PlantState.ToPlant)
  end
  self.m_curState = Wasteland_PlantState.ToPlant
end

function CitySpaceManPlantCom:ToWater()
  if self.m_curState == Wasteland_PlantState.ToWater then
    return
  end
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFarmAction) then
    DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_show_to_water, false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarmAction, {anim = false, playEffect = false}, Wasteland_PlantState.ToWater)
  end
  self.m_curState = Wasteland_PlantState.ToWater
  Setting:SetPrivateInt(SettingKeys.NEWBIE_FARM_SHOW_HEAD .. Wasteland_PlantState.ToPlant, 1)
end

function CitySpaceManPlantCom:ToReap()
  if self.m_curState == Wasteland_PlantState.ToReap then
    return
  end
  if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFarmAction) then
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIFarmAction, {anim = false, playEffect = false}, Wasteland_PlantState.ToReap)
  end
  self.m_curState = Wasteland_PlantState.ToReap
  Setting:SetPrivateInt(SettingKeys.NEWBIE_FARM_SHOW_HEAD .. Wasteland_PlantState.ToWater, 1)
end

function CitySpaceManPlantCom:LeaveFarmMode()
  self.m_curState = -1
  self.m_citySpaceMan:LeaveFarmMode()
  UIManager:GetInstance():DestroyWindow(UIWindowNames.UIFarmAction)
  self:SetCameraOut()
end

function CitySpaceManPlantCom:SetCameraIn()
  if self.curZoom ~= nil and self.curZoom ~= -1 then
    return
  end
  self.curZoom = CS.SceneManager.World.Zoom
  CS.SceneManager.World:AutoZoom(10, 0.2)
end

function CitySpaceManPlantCom:SetCameraOut()
  if self.curZoom ~= nil and self.curZoom ~= -1 then
    CS.SceneManager.World:AutoZoom(self.curZoom, 0.2)
  end
  self.curZoom = -1
end

function CitySpaceManPlantCom:CheckHasToReap()
  local _curActionState = self.m_citySpaceMan:GetCurActionState()
  if _curActionState ~= self.m_citySpaceMan.ActionState.ToReap and _curActionState ~= self.m_citySpaceMan.ActionState.ReapWait then
    return
  end
  local pos1 = self.m_citySpaceMan:GetPosition()
  local pos2 = pos1
  pos2.y = pos2.y + 1
  local ret = self.m_citySpaceMan:GetTriggerIds(pos1, pos2, 3.0, "Terrain")
  if table.count(ret) > 0 then
    for _, uuid in pairs(ret) do
      local tileInfo = WastelandFarmManager:GetInstance():GetTileByObjId(uuid)
      if tileInfo ~= nil and tileInfo:GetTilePlantState() == Wasteland_PlantState.ToReap then
        self.m_citySpaceMan:ToReap()
        return
      end
    end
  end
  self.m_citySpaceMan:ToReapWait()
end

return CitySpaceManPlantCom
