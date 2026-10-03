local PerformUnit = BaseClass("PerformUnit")
local Resource = CS.GameEntry.Resource
local Const = require("Scene.LWCityPerformNpc.Const")

function PerformUnit:__init()
  self.data = nil
  self.isArrival = nil
  self.isFinish = nil
  self.simpleAnim = nil
  self.endPos = {}
  self.tipRoot = nil
  self.transform = nil
  self.gameObject = nil
  self.isCreate = nil
end

function PerformUnit:CreateModel(callBack)
  if self.data == nil then
    return
  end
  self.isCreate = true
  self.req = Resource:InstantiateAsync(self.data.modelPatch)
  self.req:completed("+", function(req)
    self.gameObject = req.gameObject
    self.transform = req.gameObject.transform
    
    function self.updateTimer()
      self:Update()
    end
    
    self.update = UpdateManager:GetInstance():AddUpdate(self.updateTimer)
    self.transform:Set_position(self.data.birthPos.x, self.data.birthPos.y, self.data.birthPos.z)
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.simpleAnim = self.transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
    self:SetTargetEndPos(self.data.posList)
    self:OnCreate()
    if callBack then
      callBack()
    end
  end)
end

function PerformUnit:SetData(data)
  self.data = data
end

function PerformUnit:SetTargetEndPos(endPos)
  if self.transform and 1 <= #endPos then
    self.endPos = endPos
    local ro = Vector3.Normalize(self.endPos[1] - self.transform.position)
    local lookRot = self.transform.rotation
    if ro ~= Vector3.zero then
      lookRot = Quaternion.LookRotation(ro, Vector3.up)
    end
    self.transform.rotation = lookRot
    self.curendPos = self.endPos[#self.endPos]
    self.simpleAnim:Play(Const.animNames.run)
    self.isArrival = true
  end
end

function PerformUnit:Update()
  if self.transform then
    if #self.endPos > 0 and Vector3.Distance(self.transform.position, self.endPos[1]) > 0.001 then
      self.isArrival = false
      self.transform.position = Vector3.MoveTowards(self.transform.position, self.endPos[1], Time.deltaTime * self.data.speed)
    elseif #self.endPos >= 1 then
      table.remove(self.endPos, 1)
      if #self.endPos >= 1 and self.endPos[1] ~= self.transform.position then
        local v3 = Vector3.Normalize(self.endPos[1] - self.transform.position)
        if v3 ~= Vector3.zero then
          self.transform.rotation = Quaternion.LookRotation(v3, Vector3.up)
          if self.tipRoot then
            self.tipRoot.transform.rotation = CS.SceneManager.World:GetRotation()
          end
        end
      end
    else
      if not self.isArrival then
        self.isArrival = true
        self.simpleAnim:Play(Const.animNames.idle)
        self:OnArrivalTerminal()
      end
      if self.isFinish then
        self:OnFinish()
      end
    end
  end
  self:OnUpdate()
end

function PerformUnit:OnFinish()
  if self.data.arriveCallBack then
    self.data.arriveCallBack()
    self.isCallBack = true
  end
  if self.data.isArriveDelete then
    self:Delete()
  end
end

function PerformUnit:OnArrivalTerminal()
  self.isFinish = true
end

function PerformUnit:__delete()
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
  if self.delay then
    self.delay:Stop()
    self.delay = nil
  end
  if not self.isCallBack and self.data.arriveCallBack then
    self.data.arriveCallBack()
  end
  self.isCallBack = false
end

function PerformUnit:OnCreate()
end

function PerformUnit:OnDelete()
end

function PerformUnit:OnUpdate()
end

return PerformUnit
