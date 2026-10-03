local GuideNpcUnit = BaseClass("GuideNpcUnit")
local Resource = CS.GameEntry.Resource
local Const = require("DataCenter.LWGuideManager.Const")

function GuideNpcUnit:__init()
  self.data = nil
  self.isArrival = nil
  self.isFinish = nil
  self.simpleAnim = nil
  self.endPos = {}
  self.tipRoot = nil
  self.transform = nil
  self.gameObject = nil
  self.isCreate = nil
  self.speed = Const.soldierSpeed
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

function GuideNpcUnit:CreateModel(callBack, delay)
  if self.data == nil then
    return
  end
  self.isCreate = true
  if delay then
    self.delay = TimerManager:GetInstance():DelayInvoke(function()
      self:CreateUnitModel(callBack)
    end, delay)
  else
    self:CreateUnitModel(callBack)
  end
end

function GuideNpcUnit:CreateUnitModel(callBack)
  self.req = Resource:InstantiateAsync(self.data.path)
  self.req:completed("+", function(req)
    self.gameObject = req.gameObject
    self.transform = req.gameObject.transform
    
    function self.updateTimer()
      self:Update()
    end
    
    self.update = UpdateManager:GetInstance():AddUpdate(self.updateTimer)
    self.transform:Set_position(self.data.birthPos.x, self.data.birthPos.y, self.data.birthPos.z)
    self.simpleAnim = self.transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    self:SetTargetEndPos(self.data.posList)
    self:OnCreate()
    if callBack then
      callBack()
    end
  end)
end

function GuideNpcUnit:OnCreate()
end

function GuideNpcUnit:SetData(data)
  self.data = data
end

function GuideNpcUnit:SetTargetEndPos(endPos)
  if self.transform and 1 <= #endPos then
    self.endPos = endPos
    local lookRot = Quaternion.LookRotation(Vector3.Normalize(self.endPos[1] - self.transform.position), Vector3.up)
    self.transform.rotation = lookRot
    if self.tipRoot then
      self.tipRoot.transform.rotation = CS.SceneManager.World:GetRotation()
    end
    self.curendPos = self.endPos[#self.endPos]
    self.simpleAnim:Play(Const.soldierAnim.walk)
    self.isArrival = true
  end
end

function GuideNpcUnit:Update()
  if self.transform then
    if #self.endPos > 0 and Vector3.Distance(self.transform.position, self.endPos[1]) > 0.001 then
      self.isArrival = false
      self.transform.position = Vector3.MoveTowards(self.transform.position, self.endPos[1], Time.deltaTime * self.speed)
    elseif #self.endPos >= 1 then
      table.remove(self.endPos, 1)
      if #self.endPos >= 1 then
        local lookRot = Quaternion.LookRotation(Vector3.Normalize(self.endPos[1] - self.transform.position), Vector3.up)
        self.transform.rotation = lookRot
        if self.tipRoot then
          self.tipRoot.transform.rotation = CS.SceneManager.World:GetRotation()
        end
      end
    else
      if not self.isArrival then
        self.isArrival = true
        self.simpleAnim:Play(Const.soldierAnim.idle)
        self:OnArrivalTerminal()
      end
      if self.isFinish then
        self:OnFinish()
      end
    end
  end
  self:OnUpdate()
end

function GuideNpcUnit:OnUpdate()
end

function GuideNpcUnit:OnFinish()
end

function GuideNpcUnit:OnArrivalTerminal()
end

function GuideNpcUnit:__delete()
  self:OnDelete()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.update = nil
  end
  if self.req then
    self.req:Destroy()
  end
  self.isArrival = nil
  self.isFinish = nil
  self.simpleAnim = nil
  self.endPos = {}
  self.tipRoot = nil
  self.transform = nil
  self.gameObject = nil
  self.isCreate = nil
  self.speed = nil
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
end

function GuideNpcUnit:OnDelete()
end

return GuideNpcUnit
