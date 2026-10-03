local SurfingMonsterBornTemplate = BaseClass("SurfingMonsterBornTemplate")

function SurfingMonsterBornTemplate:__init()
  self.id = nil
  self.coord = nil
  self.type = nil
  self.para = nil
  self.monster = nil
end

function SurfingMonsterBornTemplate:__delete()
  self.id = nil
  self.coord = nil
  self.type = nil
  self.para = nil
  self.monster = nil
end

function SurfingMonsterBornTemplate:InitConfig(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.coord = row:getValue("coord")
  self.type = row:getValue("type")
  self.para = row:getValue("para")
  self.monster = row:getValue("monster")
end

function SurfingMonsterBornTemplate:GetOriMonsterId()
  if self.monster == nil then
    return
  end
  local r = math.random(1, 10000)
  if r <= self.monster[2] then
    return self.monster[1]
  end
end

return SurfingMonsterBornTemplate
