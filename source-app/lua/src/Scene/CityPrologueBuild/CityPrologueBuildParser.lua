local CityPrologueBuildParser = BaseClass("CityPrologueBuildParser")
local Resource = CS.GameEntry.Resource
local typeSimpleAnimation = typeof(CS.SimpleAnimation)
local effect_xiufu2 = "Assets/_Art/Effect/prefab/scene/VFX_feiqu_xiufu_2.prefab"
local effect_xiufu3 = "Assets/_Art/Effect/prefab/scene/VFX_feiqu_xiufu_3.prefab"
local effect_db_lv05 = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshuo_tuohuang_dabenshengji05.prefab"
local effect_db_lv06_10 = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshuo_tuohuang_dabenshengji_06to10.prefab"
local effect_mj_lv02 = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshuo_tuohuang_minjushengji02.prefab"
local effect_mj_lv01 = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshuo_tuohuang_minjushengji01.prefab"

function CityPrologueBuildParser:__init(transform)
  self.m_transform = transform
end

function CityPrologueBuildParser:lv1_show()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state01",
      visible = true
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state01",
      e_path = effect_xiufu2
    }
  }
  local nodepath = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state01/A_build_th_zbdl_01_skin"
  tbl.anim = {
    {
      node = nodepath,
      name = "lv1_up",
      loop = true
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv2_show()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state01",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state02",
      visible = true
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state02",
      e_path = effect_xiufu2
    }
  }
  local nodepath = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state02/A_build_th_zbdl_0203_skin"
  tbl.anim = {
    {
      node = nodepath,
      name = "lv2_up",
      loop = true
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv2_car1()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj/state01",
      visible = true
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj/state01/Pos_effect",
      e_path = effect_xiufu2
    }
  }
  local nodepath = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj/state01/Transform/A_vehicle@th_wtj_skin"
  tbl.anim = {
    {
      node = nodepath,
      name = "car1_show",
      loop = true
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv2_car2()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj/state02",
      visible = true
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj/state02/Pos_effect",
      e_path = effect_xiufu2
    }
  }
  local nodepath = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj/state02/Transform02/A_vehicle@th_wtj_skin"
  tbl.anim = {
    {
      node = nodepath,
      name = "car2_show",
      loop = true
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv3_show()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_dm",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_dm/state01",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj/state02",
      visible = false
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_dm/state01",
      e_path = effect_xiufu3
    }
  }
  local nodepath1 = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj/state01/Transform/A_vehicle@th_wtj_skin"
  local nodepath2 = "NormalModel/WasteLand_MainBuilding02/A_build_th_dm/state01/A_build@th_dm_03AB_skin"
  local nodepath3 = "NormalModel/WasteLand_MainBuilding02/A_build_th_dm/state01/A_build@th_dm_03fandi_skin"
  local nodepath4 = "NormalModel/WasteLand_MainBuilding02/A_build_th_dm/state01/A_build@th_dm_03fandi_skin (1)"
  tbl.anim = {
    {
      node = nodepath1,
      name = "car_run",
      loop = true
    },
    {
      node = nodepath2,
      name = "dm_show",
      loop = true
    },
    {
      node = nodepath3,
      name = "fandi",
      loop = true
    },
    {
      node = nodepath4,
      name = "fandi",
      loop = true
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv4_show()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_dm",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_dm/state01",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_dm/state02",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj/state01",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj/state02",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj/state03",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state02",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state03",
      visible = true
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state03",
      e_path = effect_xiufu3
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj/state03/Pos_effect",
      e_path = effect_xiufu2
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj/state04/Pos_effect",
      e_path = effect_xiufu2
    }
  }
  local nodepath0 = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state03/A_build_th_zbdl_04_skin"
  local nodepath1 = "NormalModel/WasteLand_MainBuilding02/A_build_th_dm/state02/A_build@th_dm_03fandi_skin (1)"
  local nodepath2 = "NormalModel/WasteLand_MainBuilding02/A_build_th_dm/state02/A_build@th_dm_03fandi_skin (2)"
  local nodepath3 = "NormalModel/WasteLand_MainBuilding02/A_build_th_dm/state02/A_build@th_dm_03AB_skin (1)"
  local nodepath4 = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj/state03/Transform03/A_vehicle@th_wtj_skin"
  tbl.anim = {
    {
      node = nodepath0,
      name = "lv4_up",
      loop = true
    },
    {
      node = nodepath1,
      name = "fandi",
      loop = true
    },
    {
      node = nodepath2,
      name = "fandi",
      loop = true
    },
    {
      node = nodepath3,
      name = "dm_show",
      loop = true
    },
    {
      node = nodepath4,
      name = "car_run",
      loop = true
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv5_show()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state03",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state04",
      visible = true
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state04",
      e_path = effect_db_lv05
    }
  }
  local nodepath = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state04/A_build@th_zbdl_05_skin"
  tbl.anim = {
    {
      node = nodepath,
      name = "lv5_up",
      loop = true
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv6_show()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_cq",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_cq/state01",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_dm",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_dm/state02",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj/state03",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_vehicie_th_wtj/state04",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state04",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state05",
      visible = true
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state05",
      e_path = effect_db_lv06_10
    }
  }
  local nodepath = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state05/A_build@th_zbdl_06to10_skin"
  local n_shadow = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state05/A_build_th_zbdl_11to15_shadow_skin"
  local nodepath2 = "NormalModel/WasteLand_MainBuilding02/A_build_th_cq/state01/A_build@th_cq_6to11_skin"
  local nodepath3 = "NormalModel/WasteLand_MainBuilding02/A_build_th_cq/state01/A_build@cq_11_shadow_skin"
  tbl.anim = {
    {
      node = nodepath,
      name = "lv6_up",
      loop = true
    },
    {
      node = n_shadow,
      name = "lv6_up",
      loop = true
    },
    {
      node = nodepath2,
      name = "show",
      loop = true
    },
    {
      node = nodepath3,
      name = "show",
      loop = true
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv6_house_pre()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_wrjkzt",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_mj",
      visible = true
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv6_house1()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_mj",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_mj/state02",
      visible = true
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_mj/state02/Pos_effect",
      e_path = effect_mj_lv02
    }
  }
  local nodepath1 = "NormalModel/WasteLand_MainBuilding02/A_build_th_mj/state02/Transform02/A_build_th_mj2_skin"
  local nodepath2 = "NormalModel/WasteLand_MainBuilding02/A_build_th_mj/state02/Transform02/A_build_th_mj_shadow1"
  tbl.anim = {
    {
      node = nodepath1,
      name = "lv2_show",
      loop = true
    },
    {
      node = nodepath2,
      name = "lv2_show",
      loop = true
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv6_house2()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_wrjkzt",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_wrjkzt/state01",
      visible = true
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_wrjkzt/state01/Pos_effect",
      e_path = effect_mj_lv01
    }
  }
  local nodepath1 = "NormalModel/WasteLand_MainBuilding02/A_build_th_wrjkzt/state01/Transform01/A_build_th_mj1_skin"
  local nodepath2 = "NormalModel/WasteLand_MainBuilding02/A_build_th_wrjkzt/state01/Transform01/A_build_th_mj_shadow1"
  tbl.anim = {
    {
      node = nodepath1,
      name = "lv1_show",
      loop = true
    },
    {
      node = nodepath2,
      name = "lv1_show",
      loop = true
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv7_pre()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_flfdz",
      visible = true
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv7_show()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_flfdz",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_flfdz/A_build@fenglifadianji_skin",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_gd",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_gd/state01",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_gd/state02",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_gd/state03",
      visible = true
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_flfdz/A_build@fenglifadianji_skin",
      e_path = effect_xiufu2
    }
  }
  local nodepath = "NormalModel/WasteLand_MainBuilding02/A_build_th_flfdz/A_build@fenglifadianji_skin"
  tbl.anim = {
    {
      node = nodepath,
      name = "placed|idle",
      loop = true
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv8_pre()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_hxnc",
      visible = true
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv8_show()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_hxnc",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_hxnc/state01",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_hxnc/state02",
      visible = true
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_hxnc/state02/A_build@hxnc_skin",
      e_path = effect_xiufu2
    }
  }
  local nodepath = "NormalModel/WasteLand_MainBuilding02/A_build_th_hxnc/state02/A_build@hxnc_skin"
  tbl.anim = {
    {
      node = nodepath,
      name = "placed|idle",
      loop = true
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv9_show()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_gd",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_gd/state01",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_mj",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_mj/state01",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_mj/state02",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_mj/state03",
      visible = true
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_mj/state03/Pos_effect",
      e_path = effect_xiufu2
    }
  }
  local nodepath = "NormalModel/WasteLand_MainBuilding02/A_build_th_mj/state03/Transform03/A_build@mj_skin"
  tbl.anim = {
    {
      node = nodepath,
      name = "placed",
      loop = true
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv10_show()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_gd",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_gd/state02",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state05",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state06",
      visible = true
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state06",
      e_path = effect_xiufu2
    }
  }
  local nodepath1 = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state06/A_build@th_zbdl_11to15_skin"
  tbl.anim = {
    {
      node = nodepath1,
      name = "lv11_up",
      loop = true
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv11_show()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_cq",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_cq/state01",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_cq/state02",
      visible = true
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_cq/state02",
      e_path = effect_xiufu3
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv12_show()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_gd",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_gd/state03",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_wrjkzt",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_wrjkzt/state01",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_wrjkzt/state02",
      visible = true
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_wrjkzt/state02/Pos_effect",
      e_path = effect_xiufu2
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv13_show()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state06",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state07",
      visible = true
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_zbdl/state07",
      e_path = effect_xiufu3
    }
  }
  return tbl
end

function CityPrologueBuildParser:lv14_show()
  local tbl = {}
  tbl.shownode = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_cq",
      visible = true
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_cq/state02",
      visible = false
    },
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_cq/state03",
      visible = true
    }
  }
  tbl.effect = {
    {
      node = "NormalModel/WasteLand_MainBuilding02/A_build_th_cq/state03",
      e_path = effect_xiufu3
    }
  }
  return tbl
end

function CityPrologueBuildParser:doAction(tbl)
  local shownode = tbl.shownode or {}
  for _, v in pairs(shownode) do
    local node = v.node
    local visible = v.visible
    local obj = self.m_transform:Find(node)
    if obj ~= nil then
      obj.gameObject:SetActive(visible)
    end
  end
  local effect = tbl.effect or {}
  for _, v in pairs(effect) do
    local node = v.node
    local e_path = v.e_path
    local obj = self.m_transform:Find(node)
    if obj ~= nil then
      self:AddParticle(obj, e_path)
    end
  end
  local anim = tbl.anim or {}
  for _, v in pairs(anim) do
    local node = v.node
    local name = v.name
    local obj = self.m_transform:Find(node)
    if obj ~= nil then
      local simpleAni = obj:GetComponent(typeSimpleAnimation)
      if simpleAni ~= nil then
        local tab = string.split(name, "|")
        for k, v in pairs(tab) do
          if k == 1 then
            simpleAni:Play(v)
          else
            simpleAni:PlayQueued(v)
          end
        end
      end
    end
  end
end

function CityPrologueBuildParser:AddParticle(obj, particle_path)
  local particle = Resource:InstantiateAsync(particle_path)
  particle:completed("+", function(req)
    local obj_particle = req.gameObject
    obj_particle.transform.position = obj.transform.position
    CS.UnityEngine.GameObject.Destroy(obj_particle, 10.0)
  end)
end

function CityPrologueBuildParser:PlayAnimation()
end

return CityPrologueBuildParser
