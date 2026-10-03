local LWSceneTemplate = BaseClass("LWSceneTemplate")

function LWSceneTemplate:__init()
  self.id = nil
  self.name = nil
  self.desc = nil
  self.type = nil
  self.asset = nil
  self.scene_size = nil
  self.path_point = nil
  self.local_monster_group = nil
  self.block_monster = nil
  self.normal_monster = nil
  self.normal_boss = nil
  self.auto_monster_group = nil
  self.start_monster_group = nil
  self.final_monster_group = nil
  self.trigger_monster_group = nil
  self.animation = nil
end

function LWSceneTemplate:__delete()
  self.id = nil
  self.name = nil
  self.desc = nil
  self.type = nil
  self.asset = nil
  self.scene_size = nil
  self.path_point = nil
  self.local_monster_group = nil
  self.block_monster = nil
  self.normal_monster = nil
  self.normal_boss = nil
  self.auto_monster_group = nil
  self.start_monster_group = nil
  self.final_monster_group = nil
  self.trigger_monster_group = nil
  self.animation = nil
end

function LWSceneTemplate:InitConfig(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("name")
  self.desc = row:getValue("desc")
  self.type = row:getValue("type")
  self.asset = row:getValue("asset")
  self.scene_size = row:getValue("scene_size")
  self.path_point = row:getValue("path_point")
  self.local_monster_group = row:getValue("local_monster_group")
  self.block_monster = row:getValue("block_monster")
  self.normal_monster = row:getValue("normal_monster")
  self.normal_boss = row:getValue("normal_boss")
  self.auto_monster_group = row:getValue("auto_monster_group")
  self.start_monster_group = row:getValue("start_monster_group")
  self.final_monster_group = row:getValue("final_monster_group")
  self.trigger_monster_group = row:getValue("trigger_monster_group")
  self.animation = row:getValue("animation")
end

return LWSceneTemplate
