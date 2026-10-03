local CityGarbageManager = BaseClass("CityGarbageManager", Singleton)

function CityGarbageManager:__init()
  self.m_garbageList = {}
  self.m_blockList = {}
end

function CityGarbageManager:__update()
  for _, v in ipairs(self.m_garbageList) do
    v:OnUpdate()
  end
end

function CityGarbageManager:Create()
  self:Destroy()
  
  function self.m_update()
    self:__update()
  end
  
  UpdateManager:GetInstance():AddUpdate(self.m_update)
end

function CityGarbageManager:Destroy()
  if self.m_update ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.m_update)
  end
  self.m_update = nil
end

function CityGarbageManager:AddGarbage(garbage)
  self.m_garbageList[#self.m_garbageList + 1] = garbage
end

function CityGarbageManager:RemoveGarbage(garbage)
  table.removebyvalue(self.m_garbageList, garbage)
end

function CityGarbageManager:RemoveAllGarbage()
  table.clear(self.m_garbageList)
end

return CityGarbageManager
