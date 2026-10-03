local ParkourHeroTemplate = BaseClass("ParkourHeroTemplate")

function ParkourHeroTemplate:__init()
  self.id = nil
  self.warm_animation = nil
  self.finish_animation = nil
  self.finishAnims = nil
  self.enemy_id = nil
end

function ParkourHeroTemplate:__delete()
  self.id = nil
  self.warm_animation = nil
  self.finish_animation = nil
  self.finishAnims = nil
  self.enemy_id = nil
end

function ParkourHeroTemplate:InitConfig(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.warm_animation = row:getValue("warm_animation")
  self.finish_animation = row:getValue("finish_animation")
  self.enemy_id = row:getValue("enemy_id")
end

function ParkourHeroTemplate:GetFinishAnim()
  if self.finishAnims == nil and self.finish_animation then
    self.finishAnims = {}
    local count = 0
    for i, v in ipairs(self.finish_animation) do
      local arr = string.split(v, ";")
      if arr then
        count = #arr
        self.finishAnims[i] = {count = count, anims = arr}
      end
    end
  end
  if self.finishAnims and #self.finishAnims == 2 then
    local animData1 = self.finishAnims[1]
    local count = animData1.count
    local random1 = Mathf.Random(1, count)
    local anim1 = animData1.anims[random1]
    local animData2 = self.finishAnims[2]
    count = animData2.count
    local random2 = Mathf.Random(1, count)
    local anim2 = animData2.anims[random2]
    return anim1, anim2
  end
end

function ParkourHeroTemplate:GetEntranceAnim()
  if self.warm_animation then
    local count = #self.warm_animation
    local random = Mathf.Random(1, count)
    local anim = self.warm_animation[random]
    return anim
  end
end

return ParkourHeroTemplate
