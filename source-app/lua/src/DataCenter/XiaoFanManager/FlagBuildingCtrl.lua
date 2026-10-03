local ctrl = {}
ctrl.askingForBuildingObj = false
ctrl.flagBuildingObj = nil
ctrl.flagBuildingAnimComp = nil
ctrl.flagBuildingFlagMaterial = nil
ctrl.countFlag = nil

function ctrl.UpdateFlagTexture()
  if not IsNull(ctrl.flagBuildingFlagMaterial) then
    local flagChanged = ctrl.countFlag ~= LuaEntry.Player.countryFlag and ctrl.countFlag ~= nil
    ctrl.countFlag = LuaEntry.Player.countryFlag
    local nationTemp = DataCenter.NationTemplateManager:GetNationTemplate(ctrl.countFlag)
    if not nationTemp then
      return
    end
    local flagPath = nationTemp:GetNationFlagTexPath()
    if string.IsNullOrEmpty(flagPath) then
      return
    end
    local flagTex = CS.GameEntry.Resource:LoadAsset(flagPath, typeof(CS.UnityEngine.Texture2D)).asset
    if IsNull(flagTex) then
      Logger.LogError("flag texture not found:" .. flagPath)
      return
    end
    ctrl.flagBuildingFlagMaterial:SetTexture("_MainTex", flagTex)
    if flagChanged then
      ctrl.PlayRisingAnim()
    end
  end
end

function ctrl.PlayRisingAnim()
  if not IsNull(ctrl.flagBuildingAnimComp) then
    ctrl.flagBuildingAnimComp:Play("Default")
    ctrl.flagBuildingAnimComp:Play("rise")
  end
end

function ctrl.OnEnterCity()
  local buildingData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_FLAG)[1]
  if buildingData and 1 <= buildingData.level then
    ctrl.askingForBuildingObj = true
    ctrl.flagBuildingObj = nil
  end
end

function ctrl.OnBuildingUpgrade()
  local buildingData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_FLAG)[1]
  if buildingData and 1 <= buildingData.level then
    ctrl.askingForBuildingObj = true
    ctrl.flagBuildingObj = nil
  end
end

function ctrl.OnUpdate()
  if ctrl.askingForBuildingObj and IsNull(ctrl.flagBuildingObj) and CS.SceneManager.World then
    local buildingData = DataCenter.BuildManager:GetBuildingDatasByBuildingId(BuildingTypes.LW_BUILD_FLAG)[1]
    if not buildingData then
      return
    end
    local buildingObj = CS.SceneManager.World and CS.SceneManager.World:GetBuildingByPoint(buildingData.pointId) or nil
    if not IsNull(buildingObj) and buildingObj.name == "building_10212000(Clone)" then
      ctrl.flagBuildingObj = buildingObj
      ctrl.flagBuildingAnimComp = buildingObj:GetComponentInChildren(typeof(CS.SimpleAnimation))
      local flagChild = buildingObj.transform:Find("ModelGo/Normal/A_build_flags_01_new/qg01_new@skin/To_unity/root/room/up/qg/qz01_new@skin/To_unity/Geometry/A_build_flags_01_qz")
      if not IsNull(flagChild) then
        ctrl.flagBuildingFlagMaterial = flagChild.gameObject:GetComponent(typeof(CS.UnityEngine.Renderer)).material
        ctrl.UpdateFlagTexture()
      end
    end
  end
end

function ctrl.Clear()
  ctrl.flagBuildingObj = nil
  ctrl.flagBuildingAnimComp = nil
  ctrl.flagBuildingFlagMaterial = nil
  ctrl.askingForBuildingObj = false
end

return ctrl
