local BuildTrainCompleteEffect = BaseClass("BuildTrainCompleteEffect")
local Resource = CS.GameEntry.Resource
local AutoCloseTime = 5

function BuildTrainCompleteEffect:__init()
  self:DataDefine()
  self:OnCreate()
end

function BuildTrainCompleteEffect:Destroy()
  self:ComponentDestroy()
  self:DataDestroy()
  self.transform = nil
  self.gameObject = nil
end

function BuildTrainCompleteEffect:OnCreate()
  if self.request == nil then
    self.request = Resource:InstantiateAsync(UIAssets.BuildTrainCompleteEffect)
    self.request:completed("+", function()
      if self.request.isError then
        return
      end
      self.gameObject = self.request.gameObject
      self.transform = self.gameObject.transform
      self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      self:ReInit(self.param)
    end)
  end
end

function BuildTrainCompleteEffect:ComponentDefine()
end

function BuildTrainCompleteEffect:ComponentDestroy()
end

function BuildTrainCompleteEffect:DataDefine()
  self.param = {}
  self.request = nil
  
  function self.time_call_back()
    self:OnTimerCallBack()
  end
end

function BuildTrainCompleteEffect:DataDestroy()
  self:DeleteTimer()
  self.time_call_back = nil
  self.param = {}
  if self.request ~= nil then
    self.request:Destroy()
    self.request = nil
  end
end

function BuildTrainCompleteEffect:ReInit(param)
  self.param = param
  self:ShowPanel()
end

function BuildTrainCompleteEffect:ShowPanel()
  if self.gameObject ~= nil then
    self.transform.position = self.param.position
    self.gameObject:SetActive(self.param.isShow)
    self:AddTimer()
  end
end

function BuildTrainCompleteEffect:AddTimer()
  self:DeleteTimer()
  if self.timer == nil then
    self.timer = TimerManager:GetInstance():GetTimer(AutoCloseTime, self.time_call_back, self, true, false, false)
  end
  self.timer:Start()
end

function BuildTrainCompleteEffect:DeleteTimer()
  if self.timer ~= nil then
    self.timer:Stop()
    self.timer = nil
  end
end

function BuildTrainCompleteEffect:OnTimerCallBack()
  self:DeleteTimer()
  DataCenter.BuildTrainEffectManager:RemoveOneEffect(self.param.uuid)
end

function BuildTrainCompleteEffect:SetVisible(isShow)
  self.param.isShow = isShow
  if not isShow then
    self:OnTimerCallBack()
  end
end

return BuildTrainCompleteEffect
