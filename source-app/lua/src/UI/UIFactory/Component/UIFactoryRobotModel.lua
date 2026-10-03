local UIFactoryRobotModel = BaseClass("UIFactoryRobotModel")
local robot_anim_path = "JGC_@JXB_skin"
local RobotState = {
  None,
  Open,
  Work,
  Quit
}

local function OnCreate(self, go)
  self.request = go
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
  end
  self:ComponentDefine()
end

local function OnDestroy(self)
  self:ComponentDestroy()
end

local function ComponentDefine(self)
  self.robot_anim = self.transform:Find(robot_anim_path):GetComponent(typeof(CS.UnityEngine.Animator))
  self.curState = RobotState.None
end

local function ComponentDestroy(self)
  self.enterAnimTime = nil
  self.curState = nil
  self.robot_anim = nil
  self.gameObject = nil
  self.transform = nil
end

local function InitAdd(self)
  self.robot_anim:Play("JXB_Start", 0, 0)
  self.curState = RobotState.Open
end

local function InitWork(self, isRandomFirst)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Produce_Work, false)
  if isRandomFirst then
    self.robot_anim:Play("JXB_work_A", 0, 0)
  else
    self.robot_anim:Play("JXB_work_B", 0, 0)
  end
  self.curState = RobotState.Work
end

local function ChangeToWork(self, isRandomFirst)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Produce_Work, false)
  self.robot_anim:Play("JXB_StartOpen", 0, 0)
  if isRandomFirst then
    self.robot_anim:SetTrigger("work1")
  else
    self.robot_anim:SetTrigger("work2")
  end
  self.curState = RobotState.Work
end

local function ChangeToQuit(self)
  DataCenter.LWSoundManager:PlaySound(SoundAssetId.Music_Effect_Produce_Put, false)
  self.robot_anim:Play("JXB_End", 0, 0)
  self.curState = RobotState.Quit
end

local function DestroySelf(self)
  self.curState = RobotState.None
  self.request:Destroy()
end

local function UpdatePos(self, pos)
  self.transform.position = pos
end

local function SetActive(self, isShow)
  self.gameObject:SetActive(isShow)
end

UIFactoryRobotModel.OnCreate = OnCreate
UIFactoryRobotModel.OnDestroy = OnDestroy
UIFactoryRobotModel.ComponentDefine = ComponentDefine
UIFactoryRobotModel.ComponentDestroy = ComponentDestroy
UIFactoryRobotModel.InitAdd = InitAdd
UIFactoryRobotModel.InitWork = InitWork
UIFactoryRobotModel.ChangeToWork = ChangeToWork
UIFactoryRobotModel.ChangeToQuit = ChangeToQuit
UIFactoryRobotModel.DestroySelf = DestroySelf
UIFactoryRobotModel.UpdatePos = UpdatePos
UIFactoryRobotModel.SetActive = SetActive
return UIFactoryRobotModel
