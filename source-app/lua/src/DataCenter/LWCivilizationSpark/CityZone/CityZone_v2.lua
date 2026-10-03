local CityZone = BaseClass("CityZone")
local Resource = CS.GameEntry.Resource
local EdgeDirection = {
  TopLeft = 2,
  Top = 4,
  TopRight = 8,
  Right = 16,
  BottomRight = 32,
  Bottom = 64,
  BottomLeft = 128,
  Left = 256
}

function CityZone:__init(param)
  self.gameObject = nil
  self.transform = nil
  self.reqWall = nil
  self.root = param.root
  self.zoneId = param.zoneId
  self.curEdgeDirectionState = 0
  self.debugUnlockZoneIdDict = param.debugUnlockZoneIdDict
  self:Create()
end

function CityZone:Destroy()
  if self.reqWall ~= nil then
    self.reqWall:Destroy()
    self.reqWall = nil
  end
  self.transform = nil
  self.gameObject = nil
  self.root = nil
  self.zoneId = nil
  self.zoneState = nil
  self.pathType = nil
  self.curEdgeDirectionState = nil
end

function CityZone:Create()
  self.transform = self.root:Find("K" .. self.zoneId)
  self.gameObject = self.transform.gameObject
  self:CheckZoneState(true)
  self:AddListeners()
end

function CityZone:AddListeners()
end

function CityZone:CheckZoneState(is_init)
  local pathType = 1
  local name
  local edgeDirectionState = 0
  local isAlreadyMaxZone = DataCenter.CityZoneMgr.isZoneMax or false
  if not self:IsZoneUnlock(self.zoneId) then
    return
  end
  name = "Wall"
  if self.zoneId == 1 then
    if self:IsZoneUnlock(20) then
      pathType = 2
      edgeDirectionState = self:BottomEdgeDir()
    elseif self:IsZoneUnlock(4) then
      pathType = 1
    else
      pathType = 3
    end
  elseif self.zoneId == 2 then
    if self:IsZoneUnlock(3) then
      pathType = 3
    elseif self:IsZoneUnlock(1) then
      pathType = 2
    else
      pathType = 1
    end
  elseif self.zoneId == 3 then
    if self:IsZoneUnlock(10) then
      pathType = 2
      edgeDirectionState = self:BottomEdgeDir()
    else
      pathType = 1
    end
  elseif self.zoneId == 4 then
    if self:IsZoneUnlock(19) then
      name = nil
    elseif self:IsZoneUnlock(7) then
      pathType = 1
    else
      pathType = 2
    end
  elseif self.zoneId == 5 then
    if self:IsZoneUnlock(6) then
      name = nil
    elseif self:IsZoneUnlock(8) then
      pathType = 1
    elseif self:IsZoneUnlock(4) then
      pathType = 2
    else
      pathType = 3
    end
  elseif self.zoneId == 6 then
    if self:IsZoneUnlock(11) then
      name = nil
    elseif self:IsZoneUnlock(3) then
      pathType = 1
    else
      pathType = 2
    end
  elseif self.zoneId == 7 then
    if self:IsZoneUnlock(18) then
      name = nil
    elseif self:IsZoneUnlock(16) then
      pathType = 2
    elseif self:IsZoneUnlock(8) then
      pathType = 1
    else
      pathType = 3
    end
  elseif self.zoneId == 8 then
    if self:IsZoneUnlock(15) then
      name = nil
    elseif self:IsZoneUnlock(9) then
      pathType = 1
    else
      pathType = 2
    end
  elseif self.zoneId == 9 then
    if self:IsZoneUnlock(14) then
      name = nil
    elseif self:IsZoneUnlock(12) then
      pathType = 2
    elseif self:IsZoneUnlock(6) then
      pathType = 1
    else
      pathType = 3
    end
  elseif self.zoneId == 10 then
    if self:IsZoneUnlock(35) then
      pathType = 3
      edgeDirectionState = self:BottomEdgeDir()
    elseif self:IsZoneUnlock(11) then
      pathType = 2
      edgeDirectionState = self:Right_BR_BottomEdgeDir()
    else
      edgeDirectionState = self:Top_TR_Right_BR_BottomEdgeDir()
    end
  elseif self.zoneId == 11 then
    if self:IsZoneUnlock(34) then
      name = nil
    elseif self:IsZoneUnlock(12) then
      pathType = 2
      edgeDirectionState = self:RightEdgeDir()
    else
      edgeDirectionState = self:Top_TR_RightEdgeDir()
    end
  elseif self.zoneId == 12 then
    if self:IsZoneUnlock(33) then
      name = nil
    elseif self:IsZoneUnlock(13) then
      pathType = 2
      edgeDirectionState = self:RightEdgeDir()
    else
      edgeDirectionState = self:Top_TR_RightEdgeDir()
    end
  elseif self.zoneId == 13 then
    if self:IsZoneUnlock(32) then
      name = nil
    elseif self:IsZoneUnlock(30) then
      pathType = 3
      edgeDirectionState = self:RightEdgeDir()
    elseif self:IsZoneUnlock(14) then
      pathType = 2
      edgeDirectionState = self:Top_TR_RightEdgeDir()
    else
      edgeDirectionState = self:Left_TL_Top_TR_RightEdgeDir()
    end
  elseif self.zoneId == 14 then
    if self:IsZoneUnlock(29) then
      name = nil
    elseif self:IsZoneUnlock(15) then
      pathType = 2
      edgeDirectionState = self:TopEdgeDir()
    else
      edgeDirectionState = self:Top_TL_LeftEdgeDir()
    end
  elseif self.zoneId == 15 then
    if self:IsZoneUnlock(28) then
      name = nil
    elseif self:IsZoneUnlock(16) then
      pathType = 2
      edgeDirectionState = self:TopEdgeDir()
    else
      edgeDirectionState = self:Top_TL_LeftEdgeDir()
    end
  elseif self.zoneId == 16 then
    if self:IsZoneUnlock(27) then
      name = nil
    elseif self:IsZoneUnlock(17) then
      pathType = 2
      edgeDirectionState = self:TopEdgeDir()
    else
      edgeDirectionState = self:Top_TL_Left_BLEdgeDir()
    end
  elseif self.zoneId == 17 then
    if self:IsZoneUnlock(26) then
      name = nil
    elseif self:IsZoneUnlock(24) then
      pathType = 3
      edgeDirectionState = self:TopEdgeDir()
    elseif self:IsZoneUnlock(18) then
      pathType = 2
      edgeDirectionState = self:Top_TL_LeftEdgeDir()
    else
      edgeDirectionState = self:Top_TL_Left_BL_BottomEdgeDir()
    end
  elseif self.zoneId == 18 then
    if self:IsZoneUnlock(23) then
      name = nil
    elseif self:IsZoneUnlock(19) then
      pathType = 2
      edgeDirectionState = self:LeftEdgeDir()
    else
      edgeDirectionState = self:Left_BL_BottomEdgeDir()
    end
  elseif self.zoneId == 19 then
    if self:IsZoneUnlock(22) then
      name = nil
    elseif self:IsZoneUnlock(20) then
      pathType = 2
      edgeDirectionState = self:LeftEdgeDir()
    else
      edgeDirectionState = self:Left_BL_BottomEdgeDir()
    end
  elseif self.zoneId == 20 then
    if self:IsZoneUnlock(21) then
      pathType = 2
      edgeDirectionState = self:BottomEdgeDir()
    else
      edgeDirectionState = self:Left_BL_BottomEdgeDir()
    end
  elseif self.zoneId == 21 then
    if self:IsZoneUnlock(22) then
      pathType = 2
      edgeDirectionState = self:Left_BL_BottomEdgeDir()
    else
      edgeDirectionState = self:Top_TL_Left_BL_BottomEdgeDir()
    end
  elseif self.zoneId == 22 then
    if self:IsZoneUnlock(23) then
      pathType = 2
      edgeDirectionState = self:LeftEdgeDir()
    else
      edgeDirectionState = self:Top_TL_LeftEdgeDir()
    end
  elseif self.zoneId == 23 then
    if self:IsZoneUnlock(24) then
      pathType = 2
      edgeDirectionState = self:LeftEdgeDir()
    else
      edgeDirectionState = self:Top_TL_LeftEdgeDir()
    end
  elseif self.zoneId == 24 then
    if self:IsZoneUnlock(25) then
      pathType = 2
      edgeDirectionState = self:LeftEdgeDir()
    else
      edgeDirectionState = self:Top_TL_LeftEdgeDir()
    end
  elseif self.zoneId == 25 then
    if self:IsZoneUnlock(48) then
      pathType = 4
      edgeDirectionState = self:LeftEdgeDir()
    elseif self:IsZoneUnlock(26) then
      pathType = 2
      edgeDirectionState = self:Top_TL_LeftEdgeDir()
    else
      edgeDirectionState = self:Left_TL_Top_TR_RightEdgeDir()
    end
  elseif self.zoneId == 26 then
    if self:IsZoneUnlock(47) then
      name = nil
    elseif self:IsZoneUnlock(27) then
      pathType = 2
      edgeDirectionState = self:TopEdgeDir()
    else
      edgeDirectionState = self:Top_TR_RightEdgeDir()
    end
  elseif self.zoneId == 27 then
    if self:IsZoneUnlock(46) then
      name = nil
    elseif self:IsZoneUnlock(28) then
      pathType = 2
      edgeDirectionState = self:TopEdgeDir()
    else
      edgeDirectionState = self:Top_TR_RightEdgeDir()
    end
  elseif self.zoneId == 28 then
    if self:IsZoneUnlock(45) then
      name = nil
    elseif self:IsZoneUnlock(29) then
      pathType = 2
      edgeDirectionState = self:TopEdgeDir()
    else
      edgeDirectionState = self:Top_TR_RightEdgeDir()
    end
  elseif self.zoneId == 29 then
    if self:IsZoneUnlock(44) then
      name = nil
    elseif self:IsZoneUnlock(30) then
      pathType = 2
      edgeDirectionState = self:TopEdgeDir()
    else
      edgeDirectionState = self:Top_TR_RightEdgeDir()
    end
  elseif self.zoneId == 30 then
    if self:IsZoneUnlock(43) then
      name = nil
    elseif self:IsZoneUnlock(31) then
      pathType = 2
      edgeDirectionState = self:TopEdgeDir()
    else
      edgeDirectionState = self:Top_TR_RightEdgeDir()
    end
  elseif self.zoneId == 31 then
    if self:IsZoneUnlock(42) then
      name = nil
    elseif self:IsZoneUnlock(40) then
      pathType = 3
      edgeDirectionState = self:TopEdgeDir()
    elseif self:IsZoneUnlock(32) then
      pathType = 2
      edgeDirectionState = self:Top_TR_RightEdgeDir()
    else
      edgeDirectionState = self:Top_TR_Right_BR_BottomEdgeDir()
    end
  elseif self.zoneId == 32 then
    if self:IsZoneUnlock(39) then
      name = nil
    elseif self:IsZoneUnlock(33) then
      pathType = 2
      edgeDirectionState = self:RightEdgeDir()
    else
      edgeDirectionState = self:Right_BR_BottomEdgeDir()
    end
  elseif self.zoneId == 33 then
    if self:IsZoneUnlock(38) then
      name = nil
    elseif self:IsZoneUnlock(34) then
      pathType = 2
      edgeDirectionState = self:RightEdgeDir()
    else
      edgeDirectionState = self:Right_BR_BottomEdgeDir()
    end
  elseif self.zoneId == 34 then
    if self:IsZoneUnlock(37) then
      name = nil
    elseif self:IsZoneUnlock(35) then
      pathType = 2
      edgeDirectionState = self:RightEdgeDir()
    else
      edgeDirectionState = self:Right_BR_BottomEdgeDir()
    end
  elseif self.zoneId == 35 then
    if self:IsZoneUnlock(36) then
      pathType = 3
      edgeDirectionState = self:BottomEdgeDir()
    else
      pathType = 2
      edgeDirectionState = self:Right_BR_BottomEdgeDir()
    end
  elseif self.zoneId == 36 then
    if self:IsZoneUnlock(37) then
      pathType = 2
      edgeDirectionState = self:Right_BR_BottomEdgeDir()
    else
      edgeDirectionState = self:Top_TR_Right_BR_BottomEdgeDir()
    end
  elseif self.zoneId == 37 then
    if self:IsZoneUnlock(38) then
      pathType = 2
      edgeDirectionState = self:RightEdgeDir()
    else
      edgeDirectionState = self:Top_TR_RightEdgeDir()
    end
  elseif self.zoneId == 38 then
    if self:IsZoneUnlock(39) then
      pathType = 2
      edgeDirectionState = self:RightEdgeDir()
    else
      edgeDirectionState = self:Top_TR_RightEdgeDir()
    end
  elseif self.zoneId == 39 then
    if self:IsZoneUnlock(40) then
      pathType = 2
      edgeDirectionState = self:RightEdgeDir()
    else
      edgeDirectionState = self:Top_TR_RightEdgeDir()
    end
  elseif self.zoneId == 40 then
    if self:IsZoneUnlock(41) then
      pathType = 2
      edgeDirectionState = self:RightEdgeDir()
    else
      edgeDirectionState = self:Top_TR_RightEdgeDir()
    end
  elseif self.zoneId == 41 then
    if self:IsZoneUnlock(42) then
      pathType = 2
      edgeDirectionState = self:Top_TR_RightEdgeDir()
    else
      edgeDirectionState = self:Left_TL_Top_TR_RightEdgeDir()
    end
  elseif self.zoneId == 42 then
    if self:IsZoneUnlock(43) then
      pathType = 2
      edgeDirectionState = self:TopEdgeDir()
    else
      edgeDirectionState = self:Top_TL_LeftEdgeDir()
    end
  elseif self.zoneId == 43 then
    if self:IsZoneUnlock(44) then
      pathType = 2
      edgeDirectionState = self:TopEdgeDir()
    else
      edgeDirectionState = self:Top_TL_LeftEdgeDir()
    end
  elseif self.zoneId == 44 then
    if self:IsZoneUnlock(45) then
      pathType = 2
      edgeDirectionState = self:TopEdgeDir()
    else
      edgeDirectionState = self:Top_TL_LeftEdgeDir()
    end
  elseif self.zoneId == 45 then
    if self:IsZoneUnlock(46) then
      pathType = 2
      edgeDirectionState = self:TopEdgeDir()
    else
      edgeDirectionState = self:Top_TL_LeftEdgeDir()
    end
  elseif self.zoneId == 46 then
    if self:IsZoneUnlock(47) then
      pathType = 2
      edgeDirectionState = self:TopEdgeDir()
    else
      edgeDirectionState = self:Top_TL_LeftEdgeDir()
    end
  elseif self.zoneId == 47 then
    if self:IsZoneUnlock(48) then
      pathType = 2
      edgeDirectionState = self:TopEdgeDir()
    else
      edgeDirectionState = self:Top_TL_LeftEdgeDir()
    end
  elseif self.zoneId == 48 then
    if self:IsZoneUnlock(49) then
      name = nil
    else
      pathType = 2
      edgeDirectionState = self:Top_TL_LeftEdgeDir()
    end
  end
  if not isAlreadyMaxZone then
    if not name then
      local transform = self.root:Find("K" .. self.zoneId .. "/Wall")
      if not IsNull(transform) then
        transform.gameObject:Destroy()
      end
    elseif self.pathType ~= pathType then
      local transform = self.root:Find("K" .. self.zoneId .. "/Wall")
      if not IsNull(transform) then
        transform.gameObject:Destroy()
      end
      local prefab_path
      if self.zoneId < 10 then
        prefab_path = string.format("Assets/Main/Prefabs/LWCivilizationSpark/City_v2/Wall/K%sWall%s.prefab", self.zoneId, pathType)
      else
        if SeasonUtil.IsInSeasonSnowMode() then
          prefab_path = string.format("Assets/Main/Prefabs/City/Season2/Wall/K%sWall%s_swsj.prefab", self.zoneId, pathType)
          if not CS.GameEntry.Resource:HasAsset(prefab_path) then
            prefab_path = nil
          end
        end
        if prefab_path == nil then
          prefab_path = string.format("Assets/Main/Prefabs/City/Wall/K%sWall%s.prefab", self.zoneId, pathType)
        end
      end
      if self.debugUnlockZoneIdDict ~= nil then
        name = string.format("K%sWall%s", self.zoneId, pathType)
      end
      self:LoadWall(name, prefab_path, is_init)
      self.pathType = pathType
    end
  end
  local edgeChange = false
  if edgeDirectionState ~= self.curEdgeDirectionState then
    edgeChange = true
    self.curEdgeDirectionState = edgeDirectionState
  end
  return edgeChange
end

function CityZone:ShowEffect()
  local isOn = LuaEntry.Effect:CheckCityFarmState()
  if IsNull(self.cityStateEffect) then
    return
  end
  local flameObj = self.cityStateEffect.transform:Find("fameEffecrRoot")
  if flameObj.gameObject.activeSelf and not isOn then
    local repairEffectObj = self.cityStateEffect.transform:Find("repairEffect")
    if not IsNull(repairEffectObj) then
      repairEffectObj.gameObject:SetActive(true)
    end
  end
  if not IsNull(flameObj) then
    flameObj.gameObject:SetActive(isOn)
  end
end

function CityZone:LoadWall(name, path, is_init)
  self.reqWall = Resource:InstantiateAsync(path, ObjectPoolTag.City)
  self.reqWall:completed("+", function()
    if self.reqWall == nil or self.reqWall.isError then
      self.reqWall:Destroy()
      self.reqWall = nil
      return
    end
    local gameObject = self.reqWall.gameObject
    gameObject:SetActive(true)
    gameObject.name = name
    gameObject.transform:SetParent(self.transform)
    gameObject.transform.localPosition = VecZero
    self.cityStateEffect = gameObject.transform:Find("cityStateEffect")
    self:ShowEffect()
    if is_init == nil then
      local ani = gameObject.transform:GetComponent(typeof(CS.UnityEngine.Animation))
      if not IsNull(ani) then
        ani:Play()
      end
    end
  end)
end

function CityZone:IsZoneUnlock(id)
  if self.debugUnlockZoneIdDict then
    if self.debugUnlockZoneIdDict[id] then
      return true
    else
      return false
    end
  end
  local data = DataCenter.LandLockManager:GetLandLockDataByCityZoneId(id)
  if data == nil or data.state ~= LandLockState.Finished then
    return false
  end
  return true
end

function CityZone:GetWallGo()
  if self.reqWall then
    return self.reqWall.gameObject
  end
end

function CityZone:GetCityZonePos()
  if self.transform then
    return self.transform.localPosition
  end
  return VecZero
end

function CityZone:TopEdgeDir()
  local edgeDirectionState = 0
  edgeDirectionState = edgeDirectionState | EdgeDirection.Top
  return edgeDirectionState
end

function CityZone:BottomEdgeDir()
  local edgeDirectionState = 0
  edgeDirectionState = edgeDirectionState | EdgeDirection.Bottom
  return edgeDirectionState
end

function CityZone:LeftEdgeDir()
  local edgeDirectionState = 0
  edgeDirectionState = edgeDirectionState | EdgeDirection.Left
  return edgeDirectionState
end

function CityZone:RightEdgeDir()
  local edgeDirectionState = 0
  edgeDirectionState = edgeDirectionState | EdgeDirection.Right
  return edgeDirectionState
end

function CityZone:Top_TR_RightEdgeDir()
  local edgeDirectionState = 0
  edgeDirectionState = edgeDirectionState | EdgeDirection.Top
  edgeDirectionState = edgeDirectionState | EdgeDirection.TopRight
  edgeDirectionState = edgeDirectionState | EdgeDirection.Right
  return edgeDirectionState
end

function CityZone:Top_TR_Right_BR_BottomEdgeDir()
  local edgeDirectionState = 0
  edgeDirectionState = edgeDirectionState | EdgeDirection.Top
  edgeDirectionState = edgeDirectionState | EdgeDirection.TopRight
  edgeDirectionState = edgeDirectionState | EdgeDirection.Right
  edgeDirectionState = edgeDirectionState | EdgeDirection.BottomRight
  edgeDirectionState = edgeDirectionState | EdgeDirection.Bottom
  return edgeDirectionState
end

function CityZone:Right_BR_BottomEdgeDir()
  local edgeDirectionState = 0
  edgeDirectionState = edgeDirectionState | EdgeDirection.Right
  edgeDirectionState = edgeDirectionState | EdgeDirection.BottomRight
  edgeDirectionState = edgeDirectionState | EdgeDirection.Bottom
  return edgeDirectionState
end

function CityZone:Left_TL_Top_TR_RightEdgeDir()
  local edgeDirectionState = 0
  edgeDirectionState = edgeDirectionState | EdgeDirection.Left
  edgeDirectionState = edgeDirectionState | EdgeDirection.TopLeft
  edgeDirectionState = edgeDirectionState | EdgeDirection.Top
  edgeDirectionState = edgeDirectionState | EdgeDirection.TopRight
  edgeDirectionState = edgeDirectionState | EdgeDirection.Right
  return edgeDirectionState
end

function CityZone:Top_TL_LeftEdgeDir()
  local edgeDirectionState = 0
  edgeDirectionState = edgeDirectionState | EdgeDirection.Top
  edgeDirectionState = edgeDirectionState | EdgeDirection.TopLeft
  edgeDirectionState = edgeDirectionState | EdgeDirection.Left
  return edgeDirectionState
end

function CityZone:Top_TL_Left_BLEdgeDir()
  local edgeDirectionState = 0
  edgeDirectionState = edgeDirectionState | EdgeDirection.Top
  edgeDirectionState = edgeDirectionState | EdgeDirection.TopLeft
  edgeDirectionState = edgeDirectionState | EdgeDirection.Left
  edgeDirectionState = edgeDirectionState | EdgeDirection.BottomLeft
  return edgeDirectionState
end

function CityZone:Top_TL_Left_BL_BottomEdgeDir()
  local edgeDirectionState = 0
  edgeDirectionState = edgeDirectionState | EdgeDirection.Top
  edgeDirectionState = edgeDirectionState | EdgeDirection.TopLeft
  edgeDirectionState = edgeDirectionState | EdgeDirection.Left
  edgeDirectionState = edgeDirectionState | EdgeDirection.BottomLeft
  edgeDirectionState = edgeDirectionState | EdgeDirection.Bottom
  return edgeDirectionState
end

function CityZone:Left_BL_BottomEdgeDir()
  local edgeDirectionState = 0
  edgeDirectionState = edgeDirectionState | EdgeDirection.Left
  edgeDirectionState = edgeDirectionState | EdgeDirection.BottomLeft
  edgeDirectionState = edgeDirectionState | EdgeDirection.Bottom
  return edgeDirectionState
end

function CityZone:Left_BL_Bottom_BR_RightEdgeDir()
  local edgeDirectionState = 0
  edgeDirectionState = edgeDirectionState | EdgeDirection.Left
  edgeDirectionState = edgeDirectionState | EdgeDirection.BottomLeft
  edgeDirectionState = edgeDirectionState | EdgeDirection.Top
  edgeDirectionState = edgeDirectionState | EdgeDirection.BottomRight
  edgeDirectionState = edgeDirectionState | EdgeDirection.Right
  return edgeDirectionState
end

return CityZone
