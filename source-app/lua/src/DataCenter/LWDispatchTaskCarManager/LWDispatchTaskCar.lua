local LWDispatchTaskCar = BaseClass("LWDispatchTaskCar")
local ResourceManager = CS.GameEntry.Resource
local carPath = "Assets/_Art_LastWar/Models/Characters/Object/A_vehicle_jidongduikache_01/prefab/A_vehicle_jidongduikache_01.prefab"
local goodPath = "Assets/Main/Prefabs/LWGateDefence/TruckGoodsGroup.prefab"
local TRUCK_GOODS_GROUP_DUMMY = "A_build@yinmijidongduihuoche_01_skin/To_unity/DeformationSystem/Root/Root_M/huowu"
local TRUCK_GOODS_GROUP_MAX_STACK = 16
local OFFSET_Y_PER_TRUCK_GOODS_GROUP = 0.2
local TRUCK_GOODS_GROUP_SETTING = {
  [1] = {
    maxStealTime = 0,
    groupNum = 3,
    groupPath = UIAssets.Truckgoodsgroup_01_02,
    space = 1
  },
  [2] = {
    maxStealTime = 1,
    groupNum = 2,
    groupPath = UIAssets.Truckgoodsgroup_01_02,
    space = 1
  },
  [3] = {
    maxStealTime = 2,
    groupNum = 1,
    groupPath = UIAssets.Truckgoodsgroup_01_02,
    space = 1
  },
  [4] = {
    maxStealTime = math.maxinteger,
    groupNum = 1,
    groupPath = UIAssets.Truckgoodsgroup_01_01,
    space = 0.2
  }
}

function LWDispatchTaskCar:__init()
end

function LWDispatchTaskCar:__delete()
  self:ClearGoods()
  if not IsNull(self.effectTrigger) then
    self.effectTrigger.onPointerClick = nil
    self.effectTrigger = nil
  end
  if self.request then
    self.request:Destroy()
    self.request = nil
  end
  self:ClearTween()
  self.transform = nil
  self.taskInfo = nil
  self.localPos = nil
  self.active = false
  self.anim = nil
end

function LWDispatchTaskCar:Show(pos, taskInfo, tween, index)
  self.active = true
  self.localPos = Vector3.New(pos.x, 0, pos.z)
  self.taskInfo = taskInfo
  self.playTween = tween
  self.index = index
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
    self.anim = go:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    self:RefreshGoods()
    self.effectTrigger = go:GetComponent(typeof(CS.TouchObjectEventTrigger))
    if self.effectTrigger then
      function self.effectTrigger.onPointerClick()
        self:OnTriggerClick()
      end
    end
    self.transform:Set_localScale(0.6, 0.6, 0.6)
    self:Refresh()
  end)
end

function LWDispatchTaskCar:OnlyShow()
  self.active = true
  if self.transform then
    self.transform.gameObject:SetActive(true)
  end
end

function LWDispatchTaskCar:Hide()
  self.active = false
  self.playTween = false
  if self.transform then
    self.transform.gameObject:SetActive(false)
  end
  self:PlaySimpleAnim("Default")
end

function LWDispatchTaskCar:ClearTween()
  if self.sequence then
    self.sequence:Kill()
    self.sequence = nil
  end
end

function LWDispatchTaskCar:RefreshGoods()
  if self.transform == nil then
    return
  end
  if self.progressGroups == nil then
    self.progressGroups = {}
  end
  if self.taskInfo == nil then
    return
  end
  local setting = TRUCK_GOODS_GROUP_SETTING[1]
  local stealInfoList = self.taskInfo.stealInfoList
  if stealInfoList and 0 < #stealInfoList then
    for i, v in ipairs(TRUCK_GOODS_GROUP_SETTING) do
      if #stealInfoList <= v.maxStealTime then
        setting = v
        break
      end
    end
  end
  self.curSetting = setting
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
    if not IsNull(goodsGroup) then
      if not IsNull(goodsGroup.gameObject) then
        goodsGroup.gameObject:SetActive(i <= setting.groupNum)
      end
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
        handle.gameObject:SetActive(self.curSetting.groupPath == setting.groupPath and idx <= setting.groupNum)
      end)
      curGroups[i] = handle
    end
  end
end

function LWDispatchTaskCar:ClearGoods()
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

function LWDispatchTaskCar:Refresh()
  self.transform:Set_localPosition(self.localPos.x, self.localPos.y, self.localPos.z)
  if self.playTween then
    self:ClearTween()
    self.transform:Set_localEulerAngles(0, 0, 0)
    local animIndex = math.random(1, 2)
    local anim = "Show" .. animIndex
    self:PlaySimpleAnim(anim)
    self:PlayQueued("Default")
  else
    self:PlaySimpleAnim("Default")
  end
end

function LWDispatchTaskCar:OnTriggerClick()
  if not LuaEntry.Player:AtHomeNow() then
    UIUtil.ShowTips(Localization:GetString("500021"))
    return
  end
  DataCenter.ActDispatchTaskDataManager:TryRewardAll()
end

function LWDispatchTaskCar:PlaySimpleAnim(name, speed)
  if self.anim then
    local theAnimName = name
    self.anim:Play(theAnimName)
    if speed then
      self.anim:SetStateSpeed(theAnimName, speed)
    end
  end
end

function LWDispatchTaskCar:PlayQueued(name)
  if self.anim then
    local theAnimName = name
    self.anim:PlayQueued(theAnimName)
  end
end

return LWDispatchTaskCar
