local HSRHead = BaseClass("HSRHead")
local Resource = CS.GameEntry.Resource
local PrefabPath = "Assets/Main/SeasonRes/S5/Prefabs/World/HSRHead.prefab"
local BaseOrder = 50

function HSRHead:__init()
end

function HSRHead:__delete()
  self:Destroy()
end

function HSRHead:Destroy()
  self.data = nil
  self.index = nil
  self.carriage = nil
  if self.req then
    self.req:Destroy()
    self.req = nil
    self.transform = nil
  end
end

function HSRHead:Init(index, data, carriage)
  self.data = data
  self.index = index
  self.carriage = carriage
  self:Instantiate()
end

function HSRHead:Instantiate()
  if self.req then
    self.req:Destroy()
    self.req = nil
    self.transform = nil
  end
  self.req = Resource:InstantiateAsync(PrefabPath)
  if self.req then
    self.req:completed("+", function(request)
      local go = request.gameObject
      if IsNull(go) then
        return
      end
      local transform = go.transform
      self.transform = transform
      local parent = self.carriage:GetHeadRoot(self.index)
      transform:SetParent(parent)
      transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
      local pic = transform:Find("Pic")
      local uiPlayerHead = pic:GetComponent(typeof(CS.UIPlayerHead))
      uiPlayerHead:SetData(self.data.uid, self.data.headPic, self.data.headPicVer)
      local maxPassengerPerCarriage = DataCenter.HSRDataManager:GetMaxPassengerPerCarriage()
      local childIndex = self.index > maxPassengerPerCarriage / 2 and self.index - maxPassengerPerCarriage / 2 or self.index
      local renderer = transform:Find("Frame"):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
      if renderer then
        renderer.sortingOrder = BaseOrder + childIndex * 2
      end
      renderer = pic:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
      if renderer then
        renderer.sortingOrder = BaseOrder + childIndex * 2 - 1
      end
    end)
  end
end

return HSRHead
