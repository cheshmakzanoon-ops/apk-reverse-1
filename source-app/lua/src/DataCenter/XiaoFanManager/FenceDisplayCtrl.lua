local ctrl = {}
local BadOneResPath = "Assets/_Art_LastWar/Models/Environment/Build/Posunweilan/prefab/A_build_posunweilan.prefab"
ctrl.badOneHandle = nil
ctrl.goodOne = nil
ctrl.badOneDoor1 = nil
ctrl.badOneDoor2 = nil
ctrl.badOneWall = nil
ctrl.showBadOneDoor = true
ctrl.showBadOneWall = true

function ctrl.Update()
  if not SceneUtils:GetIsInCity() then
    return
  end
  local fenceBuilding = DataCenter.BuildManager:GetBuildingDataByPointId(3951)
  if fenceBuilding == nil then
    return
  end
  ctrl.goodOne = DataCenter.CityZoneMgr.gameObject
  if fenceBuilding.level < 1 then
    ctrl.ShowTheBadOne()
  else
    ctrl.ShowTheGoodOne()
  end
end

function ctrl.HideTheBadOne()
  if not IsNull(ctrl.badOneHandle) and not IsNull(ctrl.badOneHandle.gameObject) then
    ctrl.badOneHandle.gameObject:SetActive(false)
  end
end

function ctrl.ShowTheBadOne()
  if not IsNull(ctrl.goodOne) then
    ctrl.goodOne:SetActive(false)
  end
  if IsNull(ctrl.badOneHandle) then
    BadOneResPath = DataCenter.LWCivilizationSparkExtend:FenceDisplayCtrl_getBadOneResPath()
    ctrl.badOneHandle = CS.GameEntry.Resource:InstantiateAsync(BadOneResPath)
    ctrl.badOneHandle:completed("+", function(handle)
      local door1Trans = handle.gameObject.transform:Find("A_Build_posunchengmen_01")
      if door1Trans then
        ctrl.badOneDoor1 = door1Trans.gameObject
        ctrl.badOneDoor1:SetActive(ctrl.showBadOneDoor)
      end
      local door2Trans = handle.gameObject.transform:Find("A_Build_posunchengmen_03")
      if door2Trans then
        ctrl.badOneDoor2 = door2Trans.gameObject
        ctrl.badOneDoor2:SetActive(not ctrl.showBadOneDoor)
      end
      local wallTrans = handle.gameObject.transform:Find("A_Build_posunlangan_03")
      if wallTrans then
        ctrl.badOneWall = wallTrans.gameObject
        ctrl.badOneWall:SetActive(ctrl.showBadOneWall)
      end
    end)
  elseif not IsNull(ctrl.badOneHandle.gameObject) then
    ctrl.badOneHandle.gameObject:SetActive(true)
  end
end

function ctrl.ShowTheGoodOne()
  if not IsNull(ctrl.goodOne) then
    ctrl.goodOne:SetActive(true)
  end
  if not IsNull(ctrl.badOneHandle) then
    ctrl.badOneHandle:RealDestroy()
    ctrl.badOneHandle = nil
  end
end

function ctrl.Clear()
  if not IsNull(ctrl.badOneHandle) then
    ctrl.badOneHandle:RealDestroy()
    ctrl.badOneHandle = nil
  end
end

function ctrl.HideBadOneDoor()
  ctrl.showBadOneDoor = false
  if not IsNull(ctrl.badOneDoor1) and not IsNull(ctrl.badOneDoor2) then
    ctrl.badOneDoor1:SetActive(false)
    ctrl.badOneDoor2:SetActive(true)
  end
end

function ctrl.ShowBadOneDoor()
  ctrl.showBadOneDoor = true
  if not IsNull(ctrl.badOneDoor1) and not IsNull(ctrl.badOneDoor2) then
    ctrl.badOneDoor1:SetActive(true)
    ctrl.badOneDoor2:SetActive(false)
  end
end

function ctrl.HideBadOneWall()
  ctrl.showBadOneWall = false
  if not IsNull(ctrl.badOneWall) then
    ctrl.badOneWall:SetActive(false)
  end
end

return ctrl
