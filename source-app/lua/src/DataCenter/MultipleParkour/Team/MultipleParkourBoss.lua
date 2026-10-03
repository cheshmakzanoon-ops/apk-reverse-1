local MultipleParkourBoss = BaseClass("MultipleParkourBoss")
local Resource = CS.GameEntry.Resource
local resPath = "Assets/_Art_LastWar/Models/Characters/Zombies/A_Monster_Zombie_sangshiche/prefab/A_Monster@Zombie01_Dabache_new.prefab"
local MultipleParkourBossBarCell = require("DataCenter.MultipleParkour.Team.MultipleParkourBossBarCell")

function MultipleParkourBoss:__init(mgr, pos, speed, damage, layout)
  self.mgr = mgr
  self.curPos = pos
  self.damage = damage
  self.layout = layout
  self.req = Resource:InstantiateAsync(resPath)
  self.req:completed("+", function(request)
    self.gameObject = request.gameObject
    self.transform = request.gameObject.transform
    self.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    self.transform:Set_eulerAngles(ResetEulerAngles.x, 180, ResetEulerAngles.z)
    self.transform:Set_localPosition(self.curPos.x, self.curPos.y, self.curPos.z)
    if self.head == nil then
      self.head = MultipleParkourBossBarCell.New()
      self.head:Load(self, self.transform, 2)
    end
  end)
end

function MultipleParkourBoss:__delete()
  self:Destroy()
end

function MultipleParkourBoss:Destroy()
  if self.head then
    self.head:Delete()
    self.head = nil
  end
  if self.req then
    self.req:Destroy()
    self.req = nil
    self.gameObject = nil
    self.transform = nil
  end
end

function MultipleParkourBoss:UpdatePos(x, z)
  self.curPos.x = x
  self.curPos.z = z
  if self.transform then
    self.transform:Set_localPosition(self.curPos.x, self.curPos.y, self.curPos.z)
  end
end

function MultipleParkourBoss:GetPosition()
  return self.curPos
end

function MultipleParkourBoss:GetPositionZ()
  return self.curPos.z
end

return MultipleParkourBoss
