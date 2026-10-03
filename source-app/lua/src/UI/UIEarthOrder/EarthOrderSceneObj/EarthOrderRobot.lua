local EarthOrderRobot = BaseClass("EarthOrderRobot")
local robot_anim_path = "A_diqiudidan_WRJ/A_diqiudidan@WRJ_skin"
local box_anim_path = "A_diqiudidan_Box/A_diqiudidan@Box_skin"
local BoxAnim = {
  "Box_Fei_04",
  "Box_Fei_05",
  "Box_Fei_06",
  "Box_Fei_03",
  "Box_Fei_02",
  "Box_Fei_01",
  "Box_Fei_03",
  "Box_Fei_02",
  "Box_Fei_01"
}
local RobotAnim = {
  "WRJ_Fei_04",
  "WRJ_Fei_05",
  "WRJ_Fei_06",
  "WRJ_Fei_03",
  "WRJ_Fei_02",
  "WRJ_Fei_01",
  "WRJ_Fei_03",
  "WRJ_Fei_02",
  "WRJ_Fei_01"
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
  self.robot_anim = self.transform:Find(robot_anim_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.box_anim = self.transform:Find(box_anim_path):GetComponent(typeof(CS.UnityEngine.Animator))
end

local function ComponentDestroy(self)
  self.robot_anim = nil
  self.box_anim = nil
  self.gameObject = nil
  self.transform = nil
end

local function DataDefine(self)
  self.param = nil
  self.boxTimer = nil
  self.robotTimer = nil
end

local function DataDestroy(self)
  self.param = nil
  if self.boxTimer ~= nil then
    self.boxTimer:Stop()
    self.boxTimer = nil
  end
  if self.robotTimer ~= nil then
    self.robotTimer:Stop()
    self.robotTimer = nil
  end
end

local function ReInit(self, param)
  self.param = param
end

local function PlayEnterAnim(self, index)
  local ret, time = UIUtil.PlayAnimationReturnTime(self.box_anim, BoxAnim[index])
  if ret then
    self.boxTimer = TimerManager:GetInstance():GetTimer(time, function()
      if self.boxTimer ~= nil then
        self.boxTimer:Stop()
        self.boxTimer = nil
      end
      self.param.boxCallBack(index)
    end, self, true, false, false)
    self.boxTimer:Start()
  end
  local ret2, time2 = UIUtil.PlayAnimationReturnTime(self.robot_anim, RobotAnim[index])
  if ret2 then
    self.robotTimer = TimerManager:GetInstance():GetTimer(time2, function()
      if self.robotTimer ~= nil then
        self.robotTimer:Stop()
        self.robotTimer = nil
      end
      self.param.robotCallBack(index)
    end, self, true, false, false)
    self.robotTimer:Start()
  end
end

EarthOrderRobot.OnCreate = OnCreate
EarthOrderRobot.OnDestroy = OnDestroy
EarthOrderRobot.ComponentDefine = ComponentDefine
EarthOrderRobot.ComponentDestroy = ComponentDestroy
EarthOrderRobot.DataDefine = DataDefine
EarthOrderRobot.DataDestroy = DataDestroy
EarthOrderRobot.ReInit = ReInit
EarthOrderRobot.PlayEnterAnim = PlayEnterAnim
return EarthOrderRobot
