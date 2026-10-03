local SavePeopleScene = BaseClass("SavePeopleScene")
local work_go_anim_path1 = "A_build_xiaoren01_xs_mov/A_build@xiaoren01_xs_mov_skin"
local work_go_anim_path2 = "A_build_xiaoren01_xs_mov (1)/A_build@xiaoren01_xs_mov_skin"
local work_go_anim_path3 = "A_build_xiaoren01_xs_mov (2)/A_build@xiaoren01_xs_mov_skin"
local work_go_anim_path4 = "A_build_xiaoren01_xs_mov (3)/A_build@xiaoren01_xs_mov_skin"
local work_go_anim_path5 = "A_build_xiaoren01_xs_mov (4)/A_build@xiaoren01_xs_mov_skin"
local camera_anim_path = "CameraGo/A_build@xiaoren01_xs_mov_camera"
local AnimState = {
  "xiaoren01_xs_mov_01",
  "xiaoren01_xs_mov_02",
  "xiaoren01_xs_mov_03",
  "xiaoren01_xs_mov_04",
  "xiaoren01_xs_mov_05"
}

local function OnCreate(self, go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
  self:DataDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
  self:DataDestroy()
end

local function ComponentDefine(self)
  self.work_anim = {}
  table.insert(self.work_anim, self.transform:Find(work_go_anim_path1):GetComponent(typeof(CS.SimpleAnimation)))
  table.insert(self.work_anim, self.transform:Find(work_go_anim_path2):GetComponent(typeof(CS.SimpleAnimation)))
  table.insert(self.work_anim, self.transform:Find(work_go_anim_path3):GetComponent(typeof(CS.SimpleAnimation)))
  table.insert(self.work_anim, self.transform:Find(work_go_anim_path4):GetComponent(typeof(CS.SimpleAnimation)))
  table.insert(self.work_anim, self.transform:Find(work_go_anim_path5):GetComponent(typeof(CS.SimpleAnimation)))
  self.camera_anim = self.transform:Find(camera_anim_path):GetComponent(typeof(CS.SimpleAnimation))
end

local function ComponentDestroy(self)
  self.work_anim = nil
  self.camera_anim = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.timer = nil
  
  function self.timer_action(temp)
    self:TimeCallBack()
  end
  
  self.param = nil
end

local function DataDestroy(self)
  self:DeleteTimer()
  self.param = nil
end

local function ReInit(self, param)
  self.param = param
  local originalPos = self:GetOriginalPos()
  self.transform.position = originalPos
  CS.SceneManager.World:RemoveObjectByPoint(param.pointId)
  local troop = CS.SceneManager.World:GetCityTroop()
  if troop ~= nil then
    troop.gameObject:SetActive(false)
  end
  self:PlayAnim()
end

local function GetOriginalPos(self)
  return SceneUtils.TileIndexToWorld(self.param.pointId)
end

local function PlayAnim(self)
  local time = 0
  for k, v in ipairs(self.work_anim) do
    v:Play(AnimState[k])
    local tempTime = v:GetClipLength(AnimState[k])
    if time < tempTime then
      time = tempTime
    end
  end
  self.camera_anim:Play("xiaoren01_xs_mov_camera")
  self:AddTimer(time)
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function AddTimer(self, time)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(time, self.timer_action, self, true, false, false)
  end
  self.timer:Start()
end

local function TimeCallBack(self)
  self:DeleteTimer()
  local troop = CS.SceneManager.World:GetCityTroop()
  if troop ~= nil then
    troop.gameObject:SetActive(true)
    troop.transform.position = self:GetOriginalPos()
  end
  self:CheckDoNext()
  local data = DataCenter.CityPointDataManager:GetPointDataByPointId(self.param.pointId)
  if data ~= nil then
    DataCenter.GuideCityManager:SendCityPickGarbageFinish(data.uuid)
  end
  DataCenter.GuideCityAnimManager:RemoveSavePeopleScene()
  CS.SceneManager.World:SetTouchInputControllerEnable(true)
end

local function CheckDoNext(self)
  local template = DataCenter.GuideManager:GetCurTemplate()
  if template ~= nil and template.type == GuideType.PlayMovie then
    DataCenter.GuideManager:DoNext()
  end
end

SavePeopleScene.OnCreate = OnCreate
SavePeopleScene.OnDestroy = OnDestroy
SavePeopleScene.ComponentDefine = ComponentDefine
SavePeopleScene.ComponentDestroy = ComponentDestroy
SavePeopleScene.DataDefine = DataDefine
SavePeopleScene.DataDestroy = DataDestroy
SavePeopleScene.ReInit = ReInit
SavePeopleScene.GetOriginalPos = GetOriginalPos
SavePeopleScene.PlayAnim = PlayAnim
SavePeopleScene.DeleteTimer = DeleteTimer
SavePeopleScene.AddTimer = AddTimer
SavePeopleScene.TimeCallBack = TimeCallBack
SavePeopleScene.CheckDoNext = CheckDoNext
return SavePeopleScene
