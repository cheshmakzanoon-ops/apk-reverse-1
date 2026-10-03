local CitySpaceManFlyBloodText = BaseClass("CitySpaceManFlyBloodText")
local Resource = CS.GameEntry.Resource
local DeltaTime = 800
local num_text_path = "num"

function CitySpaceManFlyBloodText:__init(param)
  self.req = nil
  self.gameObject = nil
  self.transform = nil
  self.param = param
  self.endTime = nil
  self:Create()
end

function CitySpaceManFlyBloodText:Destroy()
  if self.req ~= nil then
    self.req:Destroy()
  end
  self.transform = nil
  self.gameObject = nil
end

function CitySpaceManFlyBloodText:Create()
  if self.req == nil then
    self.req = Resource:InstantiateAsync(UIAssets.CitySpaceManFlyBloodText)
    self.req:completed("+", function()
      self.gameObject = self.req.gameObject
      self.transform = self.req.gameObject.transform
      self:InitComponent()
      self:ReInit(self.param)
    end)
  end
end

function CitySpaceManFlyBloodText:InitComponent()
  self.num_text = self.transform:Find(num_text_path):GetComponent(typeof(CS.SuperTextMesh))
end

function CitySpaceManFlyBloodText:SetVisible(visible)
  if self.gameObject ~= nil then
    self.gameObject:SetActive(visible)
  end
end

function CitySpaceManFlyBloodText:RefreshCameraRotation(rotation)
  if self.param.visible and self.transform ~= nil then
    self.transform.rotation = rotation
  else
    self.param.rotation = rotation
  end
end

function CitySpaceManFlyBloodText:ReInit(param)
  self.param = param
  if self.transform ~= nil then
    self:SetVisible(true)
    self.transform.position = self.param.pos
    self:RefreshCameraRotation(DataCenter.BattleLevel:GetCameraRotation())
    self.num_text.text = "-" .. param.attack
    self.endTime = UITimeManager:GetInstance():GetServerTime() + DeltaTime
  end
end

function CitySpaceManFlyBloodText:OnUpdate(curTime)
  if self.endTime ~= nil and curTime > self.endTime then
    self.endTime = nil
    DataCenter.BattleLevel:RemoveOneFlyBlood(self.param.id)
  end
end

return CitySpaceManFlyBloodText
