local MultipleParkourBossBarCell = BaseClass("MultipleParkourBossBarCell", UIBaseContainer)
local base = UIBaseContainer
local resPath = "Assets/Main/Prefabs/UI/MultipleParkour/MultipleParkourBossHead.prefab"
local Resource = CS.GameEntry.Resource
local score_path = "score"

function MultipleParkourBossBarCell:__init()
end

function MultipleParkourBossBarCell:__delete()
  self:OnDestroy()
  if self.req then
    self.req:Destroy()
    self.req = nil
  end
  self.target = nil
end

function MultipleParkourBossBarCell:Load(member, transform, height)
  self.member = member
  self.target = transform
  self.camera = CS.UnityEngine.Camera.main
  if not height or height < 0 then
    self.height = 1
  else
    self.height = height
  end
  self.myWorldPos = Vector3.zero
  self.req = Resource:InstantiateAsync(resPath)
  self.req:completed("+", function(req)
    local go = req.gameObject
    local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer.Scene.Name).gameObject
    go.transform:SetParent(CanvasNormal.transform)
    self.gameObject = go
    self.transform = go.transform
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.__var_arg = self.gameObject
    self:OnCreate()
    self:SetData(self.member)
  end)
end

function MultipleParkourBossBarCell:OnCreate()
  base.OnCreate(self)
  self:ComponentDefine()
end

function MultipleParkourBossBarCell:OnDestroy()
  self:ComponentDestroy()
  self:DataDestroy()
  base.OnDestroy(self)
end

function MultipleParkourBossBarCell:ComponentDefine()
  self.score = self:AddComponent(UITextMeshProUGUIEx, score_path)
end

function MultipleParkourBossBarCell:ComponentDestroy()
  self.score = nil
end

function MultipleParkourBossBarCell:DataDestroy()
  if self.updateTimer ~= nil then
    UpdateManager:GetInstance():RemoveUpdate(self.updateTimer)
    self.updateTimer = nil
  end
  self.member = nil
  self.target = nil
end

function MultipleParkourBossBarCell:SetData(member)
  if not self.updateTimer then
    function self.updateTimer()
      self:OnUpdate()
    end
    
    UpdateManager:GetInstance():AddUpdate(self.updateTimer)
  end
  self.score:SetText("x" .. member.damage)
end

function MultipleParkourBossBarCell:OnUpdate()
  if self.transform then
    self:UpdatePos()
  end
end

function MultipleParkourBossBarCell:UpdatePos()
  self.myWorldPos.x, self.myWorldPos.y, self.myWorldPos.z = self.target:Get_position()
  self.myWorldPos.y = self.myWorldPos.y + self.height
  self.transform.position = CS.CSUtils.WorldPositionToUISpacePosition(self.myWorldPos)
end

return MultipleParkourBossBarCell
