local CityRebuildCar = BaseClass("CityRebuildCar")
local ResourceManager = CS.GameEntry.Resource
local TroopNameLabel = require("Scene.TroopNameLabel.TroopNameLabel")
local carPath = "Assets/Main/Prefabs/RebuildNurseNpc/RebuildCar.prefab"
local goodPath = "Assets/Main/Prefabs/LWGateDefence/TruckGoodsGroup.prefab"
local TRUCK_GOODS_GROUP_DUMMY = "Model/A_vehicle_ybc_prefab/A_vehicle_jidongduikache_01/A_build@yinmijidongduihuoche_01_skin/To_unity/DeformationSystem/Root/Root_M/huowu"
local CAR_PREFAB_PATH = "Model/A_vehicle_ybc_prefab"
local CAR_SPEED = 7
local END_POSITION_Z = 75
local CAR_SCALE = 0.5
local TRUCK_GOODS_GROUP_SETTING = {
  maxStealTime = 0,
  groupNum = 3,
  groupPath = UIAssets.Truckgoodsgroup_01_02,
  space = 1
}

function CityRebuildCar:__init()
end

function CityRebuildCar:__delete()
  self:ClearGoods()
  if not IsNull(self.effectTrigger) then
    self.effectTrigger.onPointerClick = nil
    self.effectTrigger = nil
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  if self.requestTroopName then
    self.requestTroopName:Destroy()
    self.requestTroopName = nil
  end
  self:ClearTween()
  self.transform = nil
  self.localPos = nil
  self.active = false
  self.anim = nil
  self.carTransform = nil
  self.Data = nil
  self.labelTips = nil
end

function CityRebuildCar:ShowInRebuild(pos, data, tween, index)
  self.active = true
  self.localPos = Vector3.New(pos.x, 0, pos.z)
  self.playTween = tween
  self.index = index
  self.Data = data
  if self.transform then
    self:Refresh()
    self:RefreshGoods()
    self.transform.gameObject:SetActive(self.active)
    return
  end
  if self.request then
    return
  end
  self.request = ResourceManager:InstantiateAsync(carPath)
  self.request:completed("+", function(req)
    if req.isError then
      return
    end
    local go = req.gameObject
    local transform = go.transform
    self.transform = transform
    self.transform:SetParent(nil)
    self.transform:Set_localScale(1, 1, 1)
    go:SetActive(self.active)
    self.dummyObj = self.transform:Find(TRUCK_GOODS_GROUP_DUMMY)
    self.carTransform = self.transform:Find(CAR_PREFAB_PATH)
    self.anim = go:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    self.carTransform.transform:Set_localScale(CAR_SCALE, CAR_SCALE, CAR_SCALE)
    self:RefreshGoods()
    self.effectTrigger = go:GetComponent(typeof(CS.TouchObjectEventTrigger))
    if self.effectTrigger then
      function self.effectTrigger.onPointerClick()
        self:OnTriggerClick()
      end
    end
    self.transform:Set_localScale(1.2, 1.2, 1.2)
    self:Refresh()
    if data then
      self:SetTroopObjectAndInfo(data, transform)
    end
  end)
end

function CityRebuildCar:OnlyShowInRebuild()
  self.active = true
  if self.transform then
    self.transform.gameObject:SetActive(true)
  end
end

function CityRebuildCar:Hide()
  self.active = false
  self.playTween = false
  if self.transform then
    self.transform.gameObject:SetActive(false)
    self.transform:Set_localEulerAngles(0, 0, 0)
  end
  self:PlaySimpleAnim("Default")
end

function CityRebuildCar:GetCarActive()
  return self.active
end

function CityRebuildCar:ClearTween()
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
end

function CityRebuildCar:RefreshGoods()
  if self.transform == nil then
    return
  end
  if self.progressGroups == nil then
    self.progressGroups = {}
  end
  local setting = TRUCK_GOODS_GROUP_SETTING
  if self.progressGroups[setting.groupPath] == nil then
    self.progressGroups[setting.groupPath] = {}
  end
  local curGroups = self.progressGroups[setting.groupPath]
  for k, groups in pairs(self.progressGroups) do
    if k ~= setting.groupPath then
      for _, group in pairs(groups) do
        if not IsNull(group) and not IsNull(group.gameObject) then
          group.gameObject:SetActive(false)
        end
      end
    end
  end
  for i = 1, math.max(setting.groupNum, #curGroups) do
    local goodsGroup = curGroups[i]
    if not IsNull(goodsGroup) and not IsNull(goodsGroup.gameObject) then
      goodsGroup.gameObject:SetActive(i <= setting.groupNum)
    else
      local idx = i
      local handle = ResourceManager:InstantiateAsync(setting.groupPath, ObjectPoolTag.Normal, LoadPriority.Low)
      local space = setting.space
      handle:completed("+", function()
        if IsNull(self.dummyObj) then
          return
        end
        local transform = handle.gameObject.transform
        transform:SetParent(self.dummyObj.transform)
        transform:Set_localPosition(0, 0.6 + space * (idx - 1), -1.45)
        transform:Set_localEulerAngles(0, 180, 0)
        transform:Set_localScale(0.8, 0.8, 0.8)
      end)
      curGroups[i] = handle
    end
  end
end

function CityRebuildCar:ClearGoods()
  if self.progressGroups then
    for _, groups in pairs(self.progressGroups) do
      for _, group in pairs(groups) do
        if not IsNull(group) then
          group:Destroy()
        end
      end
    end
    self.progressGroups = nil
  end
end

function CityRebuildCar:Refresh()
  self.transform:Set_localPosition(self.localPos.x, self.localPos.y, self.localPos.z)
  if self.playTween then
    self:ClearTween()
    self.transform:Set_localEulerAngles(0, 0, 0)
    local animIndex = math.random(1, 2)
    local anim = "Show" .. animIndex
    self:PlaySimpleAnim(anim)
    self:PlayQueued("Default")
  else
    self.transform:Set_localEulerAngles(0, 180, 0)
    self:MoveToZ()
    self:PlaySimpleAnim("Default")
  end
end

function CityRebuildCar:OnTriggerClick()
  if not LuaEntry.Player:AtHomeNow() then
    UIUtil.ShowTips(Localization:GetString("500021"))
    return
  end
  DataCenter.ActDispatchTaskDataManager:TryRewardAll()
end

function CityRebuildCar:PlaySimpleAnim(name, speed)
  if self.anim then
    local theAnimName = name
    self.anim:Play(theAnimName)
    if speed then
      self.anim:SetStateSpeed(theAnimName, speed)
    end
  end
end

function CityRebuildCar:PlayQueued(name)
  if self.anim then
    local theAnimName = name
    self.anim:PlayQueued(theAnimName)
  end
end

function CityRebuildCar:MoveToZ()
  local speed = CAR_SPEED
  local distance = END_POSITION_Z - self.localPos.z
  local time = distance / speed
  self.sequence = CS.DG.Tweening.DOTween.Sequence()
  self.sequence:Append(self.transform:DOLocalMoveZ(END_POSITION_Z, time))
  self.sequence:OnComplete(function()
    self:Hide()
    self.sequence = nil
  end)
end

function CityRebuildCar:SetTroopObjectAndInfo(data, transform)
  local request = ResourceManager:InstantiateAsync(UIAssets.WorldTroopName, ObjectPoolTag.Normal, LoadPriority.Low)
  request:completed("+", function()
    if CS.SceneManager.World == nil then
      return
    end
    if request.isError then
      return
    end
    if transform == nil then
      request:Destroy()
      return
    end
    request.gameObject:SetActive(true)
    request.gameObject.transform:SetParent(transform)
    request.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    request.gameObject.transform:Set_localPosition(0, 1, 2.5)
    local labelUI = TroopNameLabel.New()
    labelUI:OnCreate(request)
    labelUI:SetNameAndShowIconByData(data)
    self.labelTips = labelUI
  end)
  self.requestTroopName = request
end

return CityRebuildCar
