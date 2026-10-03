local PveUnitViewUtil = {}
local UnitViewParamArray, UnitViewParamArrayAccess, UnitViewListParamArray, UnitViewListParamArrayAccess, HpBarParamArray, HpBarParamArrayAccess, HpBarListParamArray, HpBarListParamArrayAccess, UnitViewFacade
local loadedCount = 0
local VIEW_INVALID_HANDLE = -1

function PveUnitViewUtil.InitView()
  if UnitViewParamArray == nil then
    UnitViewParamArray = LuaCSharpArray.New(512)
    UnitViewParamArrayAccess = UnitViewParamArray:GetCSharpAccess()
    UnitViewListParamArray = LuaCSharpArray.New(4608)
    UnitViewListParamArrayAccess = UnitViewListParamArray:GetCSharpAccess()
    PveUnitViewUtil.createUnitViewReq = {}
    PveUnitViewUtil.createUnitPath = nil
    PveUnitViewUtil.createUnitParent = nil
    PveUnitViewUtil.createUnitViewCount = 0
    HpBarParamArray = LuaCSharpArray.New(8)
    HpBarParamArrayAccess = HpBarParamArray:GetCSharpAccess()
    HpBarListParamArray = LuaCSharpArray.New(4096)
    HpBarListParamArrayAccess = HpBarListParamArray:GetCSharpAccess()
    PveUnitViewUtil.createHpBarReq = {}
    PveUnitViewUtil.createHpBarCount = 0
    UnitViewFacade = CS.PVEBattleLogic.Unit.UnitViewFacade
    UnitViewFacade.InitUnitView(UnitViewParamArrayAccess, UnitViewListParamArrayAccess, HpBarParamArrayAccess, HpBarListParamArrayAccess)
  end
end

function PveUnitViewUtil.UnInitView()
  if UnitViewParamArray ~= nil then
    UnitViewParamArray:DestroyCSharpAccess()
    UnitViewParamArray = nil
    UnitViewParamArrayAccess = nil
    UnitViewListParamArray:DestroyCSharpAccess()
    UnitViewListParamArray = nil
    UnitViewListParamArrayAccess = nil
    PveUnitViewUtil.createUnitViewReq = nil
    PveUnitViewUtil.createUnitPath = nil
    PveUnitViewUtil.createUnitParent = nil
    HpBarParamArray:DestroyCSharpAccess()
    HpBarParamArray = nil
    HpBarParamArrayAccess = nil
    HpBarListParamArray:DestroyCSharpAccess()
    HpBarListParamArray = nil
    HpBarListParamArrayAccess = nil
    PveUnitViewUtil.createHpBarReq = nil
    UnitViewFacade.UnInitUnitView()
    UnitViewFacade.ClearAll()
    UnitViewFacade = nil
  end
end

function PveUnitViewUtil.CreateUnitView(guid, path, parent, scale, posX, posY, posZ, eulerX, eulerY, eulerZ, layer)
  UnitViewParamArray[1] = guid
  UnitViewParamArray[2] = scale
  UnitViewParamArray[3] = posX
  UnitViewParamArray[4] = posY
  UnitViewParamArray[5] = posZ
  UnitViewParamArray[6] = eulerX
  UnitViewParamArray[7] = eulerY
  UnitViewParamArray[8] = eulerZ
  UnitViewParamArray[9] = layer
  local handle, loaded = UnitViewFacade.CreateUnitView(path, parent)
  return handle, loaded
end

function PveUnitViewUtil.CreateUnitViewListRequest(unit, guid, path, parent, scale, posX, posY, posZ, eulerX, eulerY, eulerZ, layer)
  if path ~= PveUnitViewUtil.createUnitPath or parent ~= PveUnitViewUtil.createUnitParent then
    PveUnitViewUtil.CreateUnitViewList()
  end
  PveUnitViewUtil.createUnitPath = path
  PveUnitViewUtil.createUnitParent = parent
  local indexFix = PveUnitViewUtil.createUnitViewCount * 9
  UnitViewListParamArray[indexFix + 1] = guid
  UnitViewListParamArray[indexFix + 2] = scale
  UnitViewListParamArray[indexFix + 3] = posX
  UnitViewListParamArray[indexFix + 4] = posY
  UnitViewListParamArray[indexFix + 5] = posZ
  UnitViewListParamArray[indexFix + 6] = eulerX
  UnitViewListParamArray[indexFix + 7] = eulerY
  UnitViewListParamArray[indexFix + 8] = eulerZ
  UnitViewListParamArray[indexFix + 9] = layer
  PveUnitViewUtil.createUnitViewCount = PveUnitViewUtil.createUnitViewCount + 1
  PveUnitViewUtil.createUnitViewReq[PveUnitViewUtil.createUnitViewCount] = unit
end

function PveUnitViewUtil.CreateUnitViewList()
  if PveUnitViewUtil.createUnitViewCount > 0 then
    local viewHandles, viewLoadedList = UnitViewFacade.CreateUnitViewList(PveUnitViewUtil.createUnitPath, PveUnitViewUtil.createUnitParent, PveUnitViewUtil.createUnitViewCount)
    local count = PveUnitViewUtil.createUnitViewCount
    for i = 1, count do
      local unit = PveUnitViewUtil.createUnitViewReq[i]
      unit:AfterCreateUnitViewList(viewHandles[i - 1], viewLoadedList[i - 1])
    end
    PveUnitViewUtil.createUnitViewCount = 0
  end
end

function PveUnitViewUtil.CheckLoadedCount()
  UnitViewFacade.CheckLoaded()
  loadedCount = UnitViewParamArray[1]
  return loadedCount
end

function PveUnitViewUtil.GetLoadedObjId(index)
  if index <= loadedCount then
    return UnitViewParamArray[index * 2], UnitViewParamArray[index * 2 + 1]
  end
  return 0, VIEW_INVALID_HANDLE
end

function PveUnitViewUtil.Preload(path, count)
  UnitViewFacade.PreloadUnitView(path, count)
end

function PveUnitViewUtil.InitTxtNumberText(handle, number)
  return UnitViewFacade.InitTxtNumberText(handle, number)
end

function PveUnitViewUtil.ShowHpTweenScale(handle)
  UnitViewFacade.ShowHpTweenScale(handle)
end

function PveUnitViewUtil.InitHpText(handle, number)
  return UnitViewFacade.InitHpText(handle, number)
end

function PveUnitViewUtil.SetNumberHpText(handle, number)
  UnitViewFacade.SetNumberHpText(handle, number)
end

function PveUnitViewUtil.SetNumberText(handle, number)
  UnitViewFacade.SetNumberText(handle, number)
end

function PveUnitViewUtil.NumberHpTextActive(handle, active)
  UnitViewFacade.NumberHpTextActive(handle, active)
end

function PveUnitViewUtil.AddAgent(rvoManager, viewHandle, speed, radius, externalControl)
  HpBarParamArray[1] = viewHandle
  HpBarParamArray[2] = speed
  HpBarParamArray[3] = radius
  HpBarParamArray[4] = externalControl and 1 or 0
  return UnitViewFacade.AddAgent(rvoManager)
end

function PveUnitViewUtil.CreateHpBarListWithHandleRequest(unit, parentViewHandle, height, offsetX, curHp, maxHp, shieldValue, hpBarType)
  height = height or 0.0
  offsetX = offsetX or 0.0
  curHp = curHp or 0
  maxHp = maxHp or 1
  shieldValue = shieldValue or 0
  hpBarType = hpBarType or ParkourHpBarType.Self
  local indexFix = PveUnitViewUtil.createHpBarCount * 8
  HpBarListParamArray[indexFix + 1] = height
  HpBarListParamArray[indexFix + 2] = offsetX
  HpBarListParamArray[indexFix + 3] = curHp
  HpBarListParamArray[indexFix + 4] = maxHp
  HpBarListParamArray[indexFix + 5] = shieldValue
  HpBarListParamArray[indexFix + 6] = parentViewHandle
  HpBarListParamArray[indexFix + 7] = hpBarType
  PveUnitViewUtil.createHpBarCount = PveUnitViewUtil.createHpBarCount + 1
  PveUnitViewUtil.createHpBarReq[PveUnitViewUtil.createHpBarCount] = unit
end

function PveUnitViewUtil.CreateHpBarList()
  if PveUnitViewUtil.createHpBarCount > 0 then
    local hpBarHandles = UnitViewFacade.CreateHpBarListWithHandle(PveUnitViewUtil.createHpBarCount)
    local count = PveUnitViewUtil.createHpBarCount
    for i = 1, count do
      local unit = PveUnitViewUtil.createHpBarReq[i]
      unit:AfterCreateHpBarList(hpBarHandles[i - 1])
    end
    PveUnitViewUtil.createHpBarCount = 0
  end
end

function PveUnitViewUtil.CreateSelfHpBarWithHandle(parentViewHandle, height, offsetX, curHp, maxHp, shieldValue)
  height = height or 0.0
  offsetX = offsetX or 0.0
  curHp = curHp or 0
  maxHp = maxHp or 1
  shieldValue = shieldValue or 0
  HpBarParamArray[1] = height
  HpBarParamArray[2] = offsetX
  HpBarParamArray[3] = curHp
  HpBarParamArray[4] = maxHp
  HpBarParamArray[5] = shieldValue
  HpBarParamArray[6] = parentViewHandle
  HpBarParamArray[7] = 0
  return UnitViewFacade.CreateSelfHpBarWithHandle()
end

function PveUnitViewUtil.CreateEnemyHpBarWithHandle(parentViewHandle, height, offsetX, curHp, maxHp, shieldValue, useUIPoint, hpBarType)
  height = height or 0.0
  offsetX = offsetX or 0.0
  curHp = curHp or 0
  maxHp = maxHp or 1
  shieldValue = shieldValue or 0
  HpBarParamArray[1] = height
  HpBarParamArray[2] = offsetX
  HpBarParamArray[3] = curHp
  HpBarParamArray[4] = maxHp
  HpBarParamArray[5] = shieldValue
  HpBarParamArray[6] = parentViewHandle
  HpBarParamArray[7] = useUIPoint and 1 or 0
  HpBarParamArray[8] = hpBarType or ParkourHpBarType.Enemy
  return UnitViewFacade.CreateEnemyHpBarWithHandle()
end

function PveUnitViewUtil.CreatePetShieldHpBarWithHandle(parentViewHandle, height, offsetX, curHp, maxHp, shieldValue, useUIPoint)
  height = height or 0.0
  offsetX = offsetX or 0.0
  curHp = curHp or 0
  maxHp = maxHp or 1
  shieldValue = shieldValue or 0
  HpBarParamArray[1] = height
  HpBarParamArray[2] = offsetX
  HpBarParamArray[3] = curHp
  HpBarParamArray[4] = maxHp
  HpBarParamArray[5] = shieldValue
  HpBarParamArray[6] = parentViewHandle
  HpBarParamArray[7] = useUIPoint and 1 or 0
  return UnitViewFacade.CreatePetShieldHpBarWithHandle()
end

function PveUnitViewUtil.CreateSoldierSmallHpBarWithHandle(parentViewHandle, height, offsetX, curHp, maxHp, shieldValue, useUIPoint)
  height = height or 0.0
  offsetX = offsetX or 0.0
  curHp = curHp or 0
  maxHp = maxHp or 1
  shieldValue = shieldValue or 0
  HpBarParamArray[1] = height
  HpBarParamArray[2] = offsetX
  HpBarParamArray[3] = curHp
  HpBarParamArray[4] = maxHp
  HpBarParamArray[5] = shieldValue
  HpBarParamArray[6] = parentViewHandle
  HpBarParamArray[7] = useUIPoint and 1 or 0
  return UnitViewFacade.CreateSoldierSmallHpBarWithHandle()
end

function PveUnitViewUtil.CreateHpBarWithHandleByType(hpBarType, parentViewHandle, height, offsetX, curHp, maxHp, shieldValue, useUIPoint)
  if hpBarType == ParkourHpBarType.Self then
    return PveUnitViewUtil.CreateSelfHpBarWithHandle(parentViewHandle, height, offsetX, curHp, maxHp, shieldValue, useUIPoint)
  elseif hpBarType == ParkourHpBarType.Enemy or hpBarType == ParkourHpBarType.EnemySmall then
    return PveUnitViewUtil.CreateEnemyHpBarWithHandle(parentViewHandle, height, offsetX, curHp, maxHp, shieldValue, useUIPoint, hpBarType)
  elseif hpBarType == ParkourHpBarType.PetShield then
    return PveUnitViewUtil.CreatePetShieldHpBarWithHandle(parentViewHandle, height, offsetX, curHp, maxHp, shieldValue, useUIPoint)
  elseif hpBarType == ParkourHpBarType.SoldierSmall then
    return PveUnitViewUtil.CreateSoldierSmallHpBarWithHandle(parentViewHandle, height, offsetX, curHp, maxHp, shieldValue, useUIPoint)
  end
  Logger.LogError("\231\188\186\229\176\145hpbarType\231\155\184\229\133\179\233\128\187\232\190\145 " .. hpBarType)
  return nil
end

function PveUnitViewUtil.SetHpBar(viewHandle, curHp, maxHp, shieldValue)
  curHp = curHp or 0
  maxHp = maxHp or 1
  shieldValue = shieldValue or 0
  HpBarParamArray[1] = viewHandle
  HpBarParamArray[2] = curHp
  HpBarParamArray[3] = maxHp
  HpBarParamArray[4] = shieldValue
  UnitViewFacade.SetHpBar()
end

function PveUnitViewUtil.SetHpBarType(viewHandle, hpBarType)
  HpBarParamArray[1] = viewHandle
  HpBarParamArray[2] = hpBarType
  UnitViewFacade.SetHpBarType(viewHandle, hpBarType)
end

function PveUnitViewUtil.SetHpBarOffsetX(viewHandle, offsetX)
  HpBarParamArray[1] = viewHandle
  HpBarParamArray[2] = offsetX
  UnitViewFacade.SetHpBarOffsetX(viewHandle, offsetX)
end

function PveUnitViewUtil.EnableHpBar(viewHandle, enable)
  HpBarParamArray[1] = viewHandle
  HpBarParamArray[2] = enable and 1 or 0
  UnitViewFacade.EnableHpBar()
end

function PveUnitViewUtil.ReplaceHpBarTargetWithHandle(viewHandle, targetViewHandle)
  HpBarParamArray[1] = viewHandle
  HpBarParamArray[2] = targetViewHandle
  UnitViewFacade.ReplaceHpBarTargetWithHandle()
end

function PveUnitViewUtil.PreloadHpBar(count)
  UnitViewFacade.PreloadHpBar(count)
end

function PveUnitViewUtil.UpdateHpBar()
  UnitViewFacade.UpdateHpBar()
end

function PveUnitViewUtil.DestroyHpBar(viewHandle)
  return UnitViewFacade.DestroyHpBar(viewHandle)
end

function PveUnitViewUtil.InitGlassAndWaterRender(viewHandle, glassRenderName, waterRenderName)
  UnitViewFacade.InitGlassAndWaterRender(viewHandle, glassRenderName, waterRenderName)
end

function PveUnitViewUtil.SetGlassCrackEffect(viewHandle, crackValue)
  UnitViewFacade.SetGlassCrackEffect(viewHandle, crackValue)
end

function PveUnitViewUtil.SetWaveIntensityEffect(viewHandle, heightValue)
  UnitViewFacade.SetWaveIntensityEffect(viewHandle, heightValue)
end

return ConstClass("PveUnitViewUtil", PveUnitViewUtil)
