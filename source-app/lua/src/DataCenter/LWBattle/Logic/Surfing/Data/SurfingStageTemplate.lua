local SurfingStageTemplate = BaseClass("SurfingStageTemplate")
local SurfingMiddleSceneInfo = require("DataCenter.LWBattle.Logic.Surfing.Data.SurfingMiddleSceneInfo")

function SurfingStageTemplate:__init()
  self.id = nil
  self.name = nil
  self.desc = nil
  self.if_title = nil
  self.default_hero = nil
  self.default_monster = nil
  self.birth_point = nil
  self.start_scene = nil
  self.surfing_scene = nil
  self.surfingScene = nil
  self.infinite_scene = nil
  self.end_scene = nil
  self.end_line = nil
  self.switch_item = nil
  self.ally_numer = nil
  self.bgm = nil
  self.bgm_1 = nil
  self.bgm_2 = nil
  self.sceneFlag = nil
  self.camera_params = nil
  self.sceneExt = nil
  self.stage_loading = nil
  self.goods = nil
  self.gm_ids = nil
  self.sky_score = nil
  self.loading_bg = nil
  self.loading_tips = nil
  self.loading_pic = nil
  self.pre_scene = nil
  self.version = nil
  self.gm_ids_guide = nil
end

function SurfingStageTemplate:__delete()
  self.id = nil
  self.name = nil
  self.desc = nil
  self.if_title = nil
  self.default_hero = nil
  self.default_monster = nil
  self.birth_point = nil
  self.start_scene = nil
  self.surfing_scene = nil
  self.surfingScene = nil
  self.infinite_scene = nil
  self.end_scene = nil
  self.end_line = nil
  self.switch_item = nil
  self.ally_numer = nil
  self.bgm = nil
  self.bgm_1 = nil
  self.bgm_2 = nil
  self.sceneFlag = nil
  self.camera_params = nil
  self.sceneExt = nil
  self.stage_loading = nil
  self.goods = nil
  self.gm_ids = nil
  self.sky_score = nil
  self.pre_scene = nil
  self.version = nil
  self.gm_ids_guide = nil
end

function SurfingStageTemplate:InitConfig(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.name = row:getValue("name")
  self.desc = row:getValue("desc")
  self.if_title = row:getValue("if_title")
  self.default_hero = row:getValue("default_hero")
  self.default_monster = row:getValue("default_monster")
  self.birth_point = row:getValue("birth_point")
  self.start_scene = row:getValue("start_scene")
  self.surfing_scene = row:getValue("surfing_scene")
  self.infinite_scene = row:getValue("infinite_scene")
  self.end_scene = row:getValue("end_scene")
  self.end_line = row:getValue("end_line")
  self.switch_item = row:getValue("switch_item")
  self.ally_numer = row:getValue("ally_numer")
  self.bgm = row:getValue("bgm")
  self.bgm_1 = row:getValue("bgm_1")
  self.bgm_2 = row:getValue("bgm_2")
  self.sceneFlag = row:getValue("scene_num")
  self.camera_params = row:getValue("camera_params")
  self.sceneExt = row:getValue("sceneExt")
  self.stage_loading = row:getValue("stage_loading")
  self.goods = row:getValue("goods")
  self.gm_ids = row:getValue("gm_ids")
  self.sky_score = row:getValue("sky_score")
  self.loading_bg = row:getValue("loading_bg")
  self.loading_tips = row:getValue("loading_tips")
  self.loading_pic = row:getValue("loading_pic")
  self.pre_scene = row:getValue("pre_scene")
  self.version = row:getValue("version")
  self.gm_ids_guide = row:getValue("gm_ids_guide")
end

function SurfingStageTemplate:GetSurfingScene()
  if self.surfingScene == nil and self.surfing_scene then
    self.surfingScene = {}
    for _, v in ipairs(self.surfing_scene) do
      local arr = string.split(v, ";")
      if arr and 2 <= #arr then
        local num = tonumber(arr[1])
        local id_arr = string.split(arr[2], ",")
        local info = {}
        if id_arr then
          for i, info_v in ipairs(id_arr) do
            table.insert(info, tonumber(info_v))
          end
        end
        table.insert(self.surfingScene, {num, info})
      end
    end
  end
  return self.surfingScene
end

function SurfingStageTemplate:GetRandomTipId()
  if self.loading_tips then
    local random = Mathf.Random(1, #self.loading_tips)
    return self.loading_tips[random] or ""
  end
end

return SurfingStageTemplate
