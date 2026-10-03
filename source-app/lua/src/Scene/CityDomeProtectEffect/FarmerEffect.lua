local FarmerEffect = BaseClass("FarmerEffect")
local nameLabel_path = "NameLabel"

function FarmerEffect:OnCreate(go)
  if go ~= nil then
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
    local nameObj = self.transform.parent:Find(nameLabel_path)
    local name_spr = nameObj and nameObj:GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    if name_spr then
      local s_x, s_y = name_spr:Get_size()
      self.transform:Set_localPosition(1.7 + s_x * 0.5, -0.17, 0)
    else
      self.transform:Set_localPosition(5, -0.17, 0)
    end
  end
end

function FarmerEffect:OnDestroy()
  self.gameObject = nil
  self.transform = nil
  self.bUuid = nil
end

function FarmerEffect:ReInit(seasonRole, uuid, mainIndex)
  self.seasonRole = seasonRole or 0
  self.bUuid = uuid
  self.mainIndex = toInt(mainIndex)
  self.gameObject:SetActive(self.seasonRole == 1)
end

return FarmerEffect
