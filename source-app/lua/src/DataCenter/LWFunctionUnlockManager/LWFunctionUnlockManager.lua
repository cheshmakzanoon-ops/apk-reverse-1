local LWFunctionUnlockManager = BaseClass("LWFunctionUnlockManager")
local COMMON_FLY_OBJ_BG_VFX_PATH = "Assets/_Art_LastWar/Effect/Prefab/UI/Eff_ui_icon_beijing.prefab"

function LWFunctionUnlockManager:__init()
  self.templates = {}
  self.functionState = {}
  self.flyObjTasks = {}
end

function LWFunctionUnlockManager:GetTemplate(id)
  local template = self.templates[id]
  if not template then
    local meta = LocalController:instance():getLine(LuaEntry.Player:GetABTestTableName(TableName.LW_FUNCTION_UNLOCK), id)
    if not meta then
      Logger.LogError("table:lw_function_unlock not found id:" .. id)
      return nil
    end
    template = {}
    local unlockBuilding = meta.unlock_building
    template.needBuildingType = DataCenter.BuildManager:GetBuildId(unlockBuilding)
    template.needBuildingLevel = DataCenter.BuildManager:GetBuildLevel(unlockBuilding)
    template.tips = meta.lock_tips
    template.lockType = meta.unlock_type
    template.mainUIAnim = meta.main_ui_anim
    template.flyObjRes = meta.fly_obj_res
    template.flyDstPos = Vector2(meta.fly_dst_pos_x, meta.fly_dst_pos_y)
    self.templates[id] = template
  end
  return template
end

function LWFunctionUnlockManager:CheckCanShow(id, onlyConsiderLevel)
  local template = self:GetTemplate(id)
  if not template then
    return true, false
  end
  local oldState = self.functionState[id]
  local newState = false
  for _, data in pairs(DataCenter.BuildManager.allBuilding) do
    if data.itemId == template.needBuildingType and data.level >= template.needBuildingLevel then
      newState = true
      break
    end
  end
  self.functionState[id] = newState
  local justUnlocked = oldState == false and newState == true
  if justUnlocked then
    self:DoJustUnlock(template)
  end
  if newState then
    return true, justUnlocked
  else
    return false, template.tips
  end
end

function LWFunctionUnlockManager:DoJustUnlock(template)
  if not string.IsNullOrEmpty(template.mainUIAnim) and not CS.SceneManager.IsInPVE() then
    local animType = UIMainAnimType[template.mainUIAnim]
    UIManager:GetInstance():GetWindow(UIWindowNames.UIMain).View:PlayAnim(animType)
  end
  if not string.IsNullOrEmpty(template.flyObjRes) then
    for _, buildingData in pairs(DataCenter.BuildManager.allBuilding) do
      if buildingData.itemId == template.needBuildingType and buildingData.level == template.needBuildingLevel and CS.SceneManager.World ~= nil then
        local building = CS.SceneManager.World:GetBuildingByPoint(buildingData.pointId)
        if not IsNull(building) then
          local screenRatio = math.max(DefaultScreenHeight / Screen.height, DefaultScreenWidth / Screen.width)
          local buildingScreenPos = CS.SceneManager.World:WorldToScreenPoint(building.transform.position) * screenRatio - Vector2(80, 0)
          self:CreateFlyObjTask(buildingScreenPos, template.flyDstPos, template.flyObjRes)
          DataCenter.LWSoundManager:PlaySound(62243, false)
        end
        break
      end
    end
  end
end

function LWFunctionUnlockManager:CreateFlyObjTask(srcPos, dstPos, flyObjRes)
  if #self.flyObjTasks == 0 then
    UpdateManager:GetInstance():AddUpdate(self.OnUpdate)
  end
  local task = {
    src = srcPos,
    dst = dstPos,
    state = 0,
    delay = 1.5
  }
  task.bg = CS.GameEntry.Resource:InstantiateAsync(COMMON_FLY_OBJ_BG_VFX_PATH)
  task.obj = CS.GameEntry.Resource:InstantiateAsync(flyObjRes)
  table.insert(self.flyObjTasks, task)
end

local function Bezier(src, dst, ctrl, t)
  local x = (1 - t) * (1 - t) * src.x + 2 * (1 - t) * t * ctrl.x + t * t * dst.x
  local y = (1 - t) * (1 - t) * src.y + 2 * (1 - t) * t * ctrl.y + t * t * dst.y
  return Vector2(x, y)
end

function LWFunctionUnlockManager.OnUpdate()
  local self = DataCenter.LWFunctionUnlockManager
  for i = #self.flyObjTasks, 1, -1 do
    local task = self.flyObjTasks[i]
    if task.state == 3 then
      if not IsNull(task.bg) then
        task.bg:Destroy()
      end
      if not IsNull(task.obj) then
        task.obj:RealDestroy()
      end
      table.remove(self.flyObjTasks, i)
    elseif task.bg.isError or task.obj.isError then
      printError("function unlock fly effect loading error!")
      task.state = 3
    elseif task.state == 2 then
      local t = task.time / task.duration
      task.time = task.time + Time.deltaTime
      if 1 <= t then
        local pos = Bezier(task.src, task.dst, task.ctrl, 1)
        task.obj.gameObject.transform:Set_anchoredPosition(pos.x, pos.y)
        task.state = 3
      else
        local pos = Bezier(task.src, task.dst, task.ctrl, t)
        task.obj.gameObject.transform:Set_anchoredPosition(pos.x, pos.y)
      end
    elseif task.state == 1 then
      task.delay = task.delay - Time.deltaTime
      if task.delay <= 0 then
        task.bg:Destroy()
        task.time = 0
        task.duration = 0.5
        task.ctrl = Vector2((task.src.x + task.dst.x) * 0.5, task.src.y + 100)
        task.state = 2
      end
    else
      if task.bg.isDone and not task.bgReady then
        task.bg.gameObject.transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.TopMost.Name).transform, false)
        task.bg.gameObject.transform:Set_anchoredPosition(task.src.x, task.src.y)
        task.bg.gameObject:SetActive(false)
        task.bgReady = true
      end
      if task.obj.isDone and not task.objReady then
        task.obj.gameObject.transform:SetParent(UIManager:GetInstance():GetLayer(UILayer.TopMost.Name).transform, false)
        task.obj.gameObject.transform:Set_anchoredPosition(task.src.x, task.src.y)
        task.obj.gameObject:SetActive(false)
        task.objReady = true
      end
      if task.bgReady and task.objReady then
        task.bg.gameObject:SetActive(true)
        task.obj.gameObject:SetActive(true)
        task.state = 1
      end
    end
  end
  if #self.flyObjTasks == 0 then
    UpdateManager:GetInstance():RemoveUpdate(self.OnUpdate)
  end
end

function LWFunctionUnlockManager:TestUnlockEffect(id)
  if not CS.CommonUtils.IsDebug() then
    return
  end
  local template = self:GetTemplate(id)
  if template then
    self:DoJustUnlock(template, template.flyDstPos)
  end
end

return LWFunctionUnlockManager
