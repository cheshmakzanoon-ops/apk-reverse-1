local CityDome = BaseClass("CityDome")
local Resource = CS.GameEntry.Resource

function CityDome:__init(param)
  self.req = nil
  self.gameObject = nil
  self.transform = nil
  self.param = param
  self:Create()
end

function CityDome:Destroy()
  if self.req ~= nil then
    self.req:Destroy()
    self.req = nil
  end
  self.transform = nil
  self.gameObject = nil
end

function CityDome:Create()
  if self.req == nil then
    self.req = Resource:InstantiateAsync(string.format(UIAssets.CityDome, self.param.range))
    self.req:completed("+", function()
      self.gameObject = self.req.gameObject
      self.transform = self.req.gameObject.transform
      self.transform.position = self.param.pos
      self:InitComponent()
      self.gameObject:SetActive(self.param.visible)
    end)
  end
end

function CityDome:InitComponent()
end

function CityDome:SetVisible(visible)
  if self.param.visible ~= visible then
    self.param.visible = visible
    if self.gameObject ~= nil then
      self.gameObject:SetActive(visible)
    end
  end
end

return CityDome
