local BuildTrainTimeFinishEffect = BaseClass("BuildTrainTimeFinishEffect")
local Resource = CS.GameEntry.Resource

function BuildTrainTimeFinishEffect:__init()
  self:DataDefine()
  self:OnCreate()
end

function BuildTrainTimeFinishEffect:Destroy()
  self:ComponentDestroy()
  self:DataDestroy()
  self.transform = nil
  self.gameObject = nil
end

function BuildTrainTimeFinishEffect:OnCreate()
  if self.request == nil then
    self.request = Resource:InstantiateAsync(UIAssets.BuildTrainTimeFinishEffect)
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

function BuildTrainTimeFinishEffect:ComponentDefine()
end

function BuildTrainTimeFinishEffect:ComponentDestroy()
end

function BuildTrainTimeFinishEffect:DataDefine()
  self.param = {}
  self.request = nil
end

function BuildTrainTimeFinishEffect:DataDestroy()
  self.param = {}
  if self.request ~= nil then
    self.request:Destroy()
    self.request = nil
  end
end

function BuildTrainTimeFinishEffect:ReInit(param)
  self.param = param
  self:ShowPanel()
end

function BuildTrainTimeFinishEffect:ShowPanel()
  if self.gameObject ~= nil then
    self.transform.position = self.param.position
    self.gameObject:SetActive(self.param.isShow)
  end
end

function BuildTrainTimeFinishEffect:SetVisible(isShow)
  self.param.isShow = isShow
  if self.gameObject ~= nil then
    self.gameObject:SetActive(self.param.isShow)
  end
end

return BuildTrainTimeFinishEffect
