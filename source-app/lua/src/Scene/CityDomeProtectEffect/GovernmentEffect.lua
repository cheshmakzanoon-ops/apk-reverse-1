local GovernmentEffect = BaseClass("GovernmentEffect")
local Official_Prefab = "Assets/Main/Prefabs/World/OfficialEffect.prefab"
local official_root_path = "Transform"
local icon_path = "Transform/icon"

function GovernmentEffect:OnCreate(go)
  if go ~= nil then
    self.request = go
    self.gameObject = go.gameObject
    self.transform = go.gameObject.transform
    self.official_root = self.transform:Find(official_root_path)
  end
  self.officials = {}
end

function GovernmentEffect:OnDestroy()
  for _, official in ipairs(self.officials) do
    official:Delete()
  end
  self.officials = {}
  self.timer_action = nil
  self.gameObject = nil
  self.transform = nil
  self.official_root = nil
end

function GovernmentEffect:ReInit(governmentId, lod, uuid)
  for _, official in ipairs(self.officials) do
    official:Delete()
  end
  self.officials = {}
  self.governmentId = governmentId
  self.bUuid = uuid
  self.hasOfficialPosition = false
  if self.official_root ~= nil and governmentId ~= nil and governmentId ~= "" and governmentId ~= 0 then
    self.hasOfficialPosition = true
    self.official_root.gameObject:SetActive(true)
    self.official_root.transform:Set_localScale(1, 1, 1)
    local templates = DataCenter.GovernmentTemplateManager:GetTemplatesSorted(string.split(governmentId, ";"))
    local count = #templates
    for i, config in ipairs(templates) do
      local icon = config.icon
      local id = config.id
      local official = UIAsyncNode.New("official", self.official_root.transform, Official_Prefab, function(go)
        if IsNotNull(go) then
          local trans = go.transform
          trans:Set_localPosition(0.8 * (2 * i - count - 1), 0, 0)
          trans:GetComponent(typeof(CS.UnityEngine.SpriteRenderer)):LoadSprite(icon)
          if id == 10001 then
            trans:Set_localScale(1.2, 1.2, 1.2)
          else
            trans:Set_localScale(1, 1, 1)
          end
        end
      end)
      table.insert(self.officials, official)
    end
  end
  self:OnCameraChangeLod(toInt(lod))
end

function GovernmentEffect:OnCameraChangeLod(lod)
  if self.gameObject == nil or IsNull(self.gameObject) then
    return
  end
  self.lod = lod
  if self.hasOfficialPosition and lod < 3 then
    self.official_root.gameObject:SetActive(true)
    self.official_root.transform:Set_localScale(1, 1, 1)
  else
    self.official_root.gameObject:SetActive(false)
    self.official_root.transform:Set_localScale(0, 0, 0)
  end
end

return GovernmentEffect
