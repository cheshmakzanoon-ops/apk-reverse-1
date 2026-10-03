local MonsterEnergyBarCell = BaseClass("MonsterEnergyBarCell", UIBaseContainer)
local base = UIBaseContainer
local Resource = CS.GameEntry.Resource
local img_quality_path = "HeroIcon/imgQuality"
local img_icon_path = "HeroIcon/imgIcon"

function MonsterEnergyBarCell:__init()
end

function MonsterEnergyBarCell:__delete()
  self:OnDestroy()
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self.target = nil
end

function MonsterEnergyBarCell:Load(heroIcon, heroQuality, transform, height)
  self.heroIcon = heroIcon
  self.target = transform
  self.heroQuality = heroQuality
  self.camera = CS.UnityEngine.Camera.main
  self.height = height
  if height < 0 then
    self.height = 1
  end
  self.myWorldPos = Vector3.zero
  self.req = Resource:InstantiateAsync("Assets/Main/Prefabs/LWBattle/MonsterEnergyBar.prefab")
  self.req:completed("+", function(req)
    local go = req.gameObject
    local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.Scene.Name).gameObject
    go.transform:SetParent(CanvasNormal.transform)
    self.gameObject = go
    self.transform = go.transform
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.__var_arg = self.gameObject
    self:OnCreate()
    self:SetData()
  end)
end

function MonsterEnergyBarCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
  self:DataDefine()
end

function MonsterEnergyBarCell:OnDestroy()
  self:DataDestroy()
  self:ComponentDestroy()
  base.OnDestroy(self)
end

function MonsterEnergyBarCell:ComponentDefine()
  self.img_quality = self:AddComponent(UIImage, img_quality_path)
  self.img_icon = self:AddComponent(UIImage, img_icon_path)
end

function MonsterEnergyBarCell:ComponentDestroy()
  self.img_quality = nil
  self.img_icon = nil
end

function MonsterEnergyBarCell:DataDefine()
end

function MonsterEnergyBarCell:DataDestroy()
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function MonsterEnergyBarCell:OnUpdate()
  if self.transform then
    self:UpdatePos()
  end
end

function MonsterEnergyBarCell:UpdatePos()
  self.myWorldPos.x, self.myWorldPos.y, self.myWorldPos.z = self.target:Get_position()
  self.myWorldPos.y = self.myWorldPos.y + self.height
  self.transform.position = CS.CSUtils.WorldPositionToUISpacePosition(self.myWorldPos)
end

function MonsterEnergyBarCell:OnDisable()
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
end

function MonsterEnergyBarCell:SetData()
  if not string.IsNullOrEmpty(self.heroIcon) then
    self.img_icon:LoadSpriteAuto(self.heroIcon)
  end
  if not string.IsNullOrEmpty(self.heroQuality) then
    self.img_quality:LoadSpriteAuto(self.heroQuality)
  end
  if not self.updateTimer then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
end

return MonsterEnergyBarCell
