local ActGhostreconAnimObj = BaseClass("ActGhostreconAnimObj")
local ResourceManager = CS.GameEntry.Resource
local WorldPlayerHead = require("Scene.WorldPlayer.WorldPlayerHead")
local prefabPath = "Assets/Main/Prefabs/Ghostrecon/WorldGhostreconAir.prefab"
local timerDelay = 0.01
local totalTime = 3.3
local yingjiuQipaoShowTime = 1.85
local yingjiuQipaoHideTime = 2.85
local cheliQipaoShowTime = 1.85
local cheliQipaoHideTime = 2.85

local function __init(self)
  self.pointUUid = nil
  self.memberInfo = nil
  self.isStart = nil
  self.angle = nil
  self.startPos = nil
  self.anim = nil
  self.qipao1 = nil
  self.qipao2 = nil
  self.nowTime = nil
  self.gameObject = nil
  self.pointUUid = nil
  
  function self.timer_action()
    self:Update()
  end
end

local function __delete(self)
  self:OnDestory()
  self.pointUUid = nil
  self.memberInfo = nil
  self.isStart = nil
  self.angle = nil
  self.startPos = nil
  self.anim = nil
  self.qipao1 = nil
  self.qipao2 = nil
  self.nowTime = nil
  self.gameObject = nil
  self.timer_action = nil
  self.pointUUid = nil
end

local function ShowAnim(self, pointUUid, isStart, memberInfo, angle, startPos, serverId)
  self.pointUUid = pointUUid
  self.memberInfo = memberInfo
  self.isStart = isStart
  self.angle = angle
  self.startPos = startPos
  self.serverId = serverId
  local airInst = ResourceManager:InstantiateAsync(prefabPath)
  airInst:completed("+", function()
    self.gameObject = airInst.gameObject
    airInst.gameObject.transform:Set_position(startPos.x, startPos.y, startPos.z)
    local eulerAngles = airInst.gameObject.transform.eulerAngles
    airInst.gameObject.transform.eulerAngles = Vector3(eulerAngles.x, angle, eulerAngles.z)
    self.anim = airInst.gameObject:GetComponentInChildren(typeof(CS.SimpleAnimation))
    local skin = self.gameObject.transform:Find("Model/A_build_huangseyunshuji_01_yingjiu/A_build_huangseyunshuji_01_guadian_skin")
    if self.isStart then
      self.anim:Play("yingjiu")
    else
      self.anim:Play("cheli")
    end
    self.qipao1 = skin:Find("To_unity/Root/biaoqing_01/Qipao").gameObject
    self.qipao2 = skin:Find("To_unity/Root/biaoqing_02/Qipao").gameObject
    self.qipao1:SetActive(false)
    self.qipao2:SetActive(false)
    local playerHeadObj = skin:Find("To_unity/Root/feijiguadian/WorldPlayerHead").gameObject
    local playerHead = WorldPlayerHead.New()
    playerHead:OnCreate(playerHeadObj)
    playerHead:SetData(memberInfo, serverId)
    self.nowTime = 0
    self:AddTimer()
    self:Update()
  end)
  self.airInst = airInst
end

local function OnDestory(self)
  DataCenter.ActGhostreconAnimManager:RemovePointOneAnimObj(self)
  if self.airInst then
    self.airInst:Destroy()
    self.airInst = nil
  end
  self:DeleteTimer()
end

local function AddTimer(self)
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(timerDelay, self.timer_action, self, false, true, false)
  end
  self.timer:Start()
end

local function DeleteTimer(self)
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

local function Update(self)
  if self.nowTime >= totalTime then
    self:OnDestory()
  else
    if self.isStart then
      if self.nowTime > yingjiuQipaoHideTime then
        self.qipao1:SetActive(false)
        self.qipao2:SetActive(false)
      elseif self.nowTime > yingjiuQipaoShowTime then
        self.qipao1:SetActive(true)
        self.qipao2:SetActive(true)
      end
    elseif self.nowTime > cheliQipaoHideTime then
      self.qipao1:SetActive(false)
      self.qipao2:SetActive(false)
    elseif self.nowTime > cheliQipaoShowTime then
      self.qipao1:SetActive(true)
      self.qipao2:SetActive(true)
    end
    self.nowTime = self.nowTime + Time.deltaTime
  end
end

ActGhostreconAnimObj.__init = __init
ActGhostreconAnimObj.__delete = __delete
ActGhostreconAnimObj.OnDestory = OnDestory
ActGhostreconAnimObj.ShowAnim = ShowAnim
ActGhostreconAnimObj.AddTimer = AddTimer
ActGhostreconAnimObj.DeleteTimer = DeleteTimer
ActGhostreconAnimObj.Update = Update
return ActGhostreconAnimObj
