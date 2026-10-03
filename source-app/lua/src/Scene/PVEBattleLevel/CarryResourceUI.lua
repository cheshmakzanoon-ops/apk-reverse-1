local Resource = CS.GameEntry.Resource
local CarryResourceUI = BaseClass("CarryResourceUI")
local ResTypeCount = 5
local Const = require("Scene.PVEBattleLevel.Const")
local UnityTextMeshPro = typeof(CS.TMPro.TextMeshPro)
local TypeOfSpriteRenderer = typeof(CS.UnityEngine.SpriteRenderer)

function CarryResourceUI:__init(battleLevel)
  self.battleLevel = battleLevel
  self.req = nil
  self.numItem = {}
  self.gameObject = nil
  self.transform = nil
  self.visible = nil
end

function CarryResourceUI:Destroy()
  if self.req ~= nil then
    self.req:Destroy()
  end
  self.transform = nil
  self.gameObject = nil
end

function CarryResourceUI:Create()
  if self.req == nil then
    self.req = Resource:InstantiateAsync("Assets/Main/Prefabs/CityScene/CarryResourceUI.prefab")
    self.req:completed("+", function()
      self.gameObject = self.req.gameObject
      self.transform = self.req.gameObject.transform
      self:InitComponent()
      self.gameObject:SetActive(self.visible)
      self:RefreshParent()
      self:RefreshText()
    end)
  end
end

function CarryResourceUI:InitComponent()
  local faceCameraNode = self.transform:Find("face_camera")
  faceCameraNode.localScale = Vector3.one
  faceCameraNode.localRotation = ResetEulerAngles
  for i = 1, ResTypeCount do
    local lineNode = self.transform:Find("face_camera/Line" .. i)
    self.numItem[#self.numItem + 1] = {
      node = lineNode.gameObject,
      numText = lineNode:GetComponentInChildren(UnityTextMeshPro, true),
      iconSpr = lineNode:GetComponentInChildren(TypeOfSpriteRenderer, true)
    }
  end
end

function CarryResourceUI:RefreshText()
  for i = 1, ResTypeCount do
    if self.numItem[i] then
      self.numItem[i].node:SetActive(false)
    end
  end
  local list = self.battleLevel:GetAllCarryResList()
  if list ~= nil then
    for k, v in ipairs(list) do
      if self.numItem[k] ~= nil then
        local item = self.numItem[k]
        item.node:SetActive(true)
        local text = string.format("%d", v.num)
        item.numText:SetText(text)
        local imagePic = Const.ResTypeIconPath[v.resourceType] or Const.ResTypeIconPath[Const.CityCutResType.Stone]
        item.iconSpr:LoadSprite(imagePic)
      end
    end
  end
end

function CarryResourceUI:RefreshParent()
  if self.transform ~= nil then
    local root = self.battleLevel:GetPlayer()
    if root ~= nil then
      self.transform:SetParent(root.transform)
      local y = root:GetModelHeight() and root:GetModelHeight() + 1 or 2.1
      self.transform.localPosition = Vector3.New(0, y, 0)
    else
      self.transform:SetParent(nil)
      self.transform.localPosition = Vector3.New(0, 2.1, 0)
    end
  end
end

function CarryResourceUI:SetVisible(visible)
  if self.visible ~= visible then
    self.visible = visible
    if self.gameObject ~= nil then
      self.gameObject:SetActive(visible)
    end
  end
end

function CarryResourceUI:RefreshRotation()
  if self.visible and self.transform ~= nil then
    self.transform.rotation = self.battleLevel:GetCameraRotation()
  end
end

return CarryResourceUI
