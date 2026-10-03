local LastStandSoliderUnit = BaseClass("LastStandSoliderUnit")
local Resource = CS.GameEntry.Resource

function LastStandSoliderUnit:__init()
  self.data = nil
  self.isArrival = nil
  self.isFinish = nil
  self.simpleAnim = nil
  self.endPos = {}
  self.transform = nil
  self.gameObject = nil
  self.isCreate = nil
end

function LastStandSoliderUnit:CreateModel(callBack)
  if self.data == nil then
    return
  end
  self.isCreate = true
  self.req = Resource:InstantiateAsync(self.data.modelPath)
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
    self:SetTargetEndPos(self.data.endPos)
    if callBack then
      callBack()
    end
  end)
end

function LastStandSoliderUnit:SetData(data)
  self.data = data
end

function LastStandSoliderUnit:SetTargetEndPos(endPos)
  if self.transform and 1 <= #endPos then
    self.endPos = endPos
    self:SetRotation(self.endPos[1])
    self.simpleAnim:Play(AnimName.Run)
    self.isArrival = true
  end
end

function LastStandSoliderUnit:SetRotation(targetPos)
  local ro = Vector3.Normalize(targetPos - self.transform.position)
  local lookRot = self.transform.rotation
  if ro ~= Vector3.zero then
    lookRot = Quaternion.LookRotation(ro, Vector3.up)
  end
  self.transform.rotation = lookRot
end

function LastStandSoliderUnit:Update()
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
        end
      end
    else
      if not self.isArrival then
        self.isArrival = true
        self.simpleAnim:Play(AnimName.Idle)
        self:OnArrivalTerminal()
      end
      if self.isFinish then
        self:OnFinish()
      end
    end
  end
  if not (self.isArrival and self.teamEndPos) or self.isArrivalTeamPos then
    return
  end
  if 0.001 < Vector3.Distance(self.transform.position, self.teamEndPos) then
    self.isArrivalTeamPos = false
    self.transform.position = Vector3.MoveTowards(self.transform.position, self.teamEndPos, Time.deltaTime * 13)
  else
    self.isArrivalTeamPos = true
    if self.data.arriveTeamCallBack then
      self.data.arriveTeamCallBack()
    end
    self:Delete()
  end
end

function LastStandSoliderUnit:SetTeamEndPos(endPos)
  self:SetRotation(endPos)
  self.simpleAnim:Play(AnimName.Run)
  self.teamEndPos = endPos
end

function LastStandSoliderUnit:OnFinish()
  if not self.isCallBack and self.data.arriveCallBack then
    self.data.arriveCallBack()
    self.isCallBack = true
  end
end

function LastStandSoliderUnit:OnArrivalTerminal()
  self.isFinish = true
  if self.data.slotTrans and self.data.slotPos then
    self.transform.localRotation = Quaternion.Euler(0, 0, 0)
    self.simpleAnim:Play(AnimName.Idle)
  end
end

function LastStandSoliderUnit:__delete()
  if self.updateTimer then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.update = nil
  end
  if self.req then
    self.req:Destroy()
  end
  self.teamEndPos = nil
  self.isArrival = nil
  self.isFinish = nil
  self.simpleAnim = nil
  self.endPos = {}
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

return LastStandSoliderUnit
