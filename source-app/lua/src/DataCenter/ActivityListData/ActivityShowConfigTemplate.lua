local ActivityShowConfigTemplate = BaseClass("ActivityShowConfigTemplate")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.id = 0
  self.title_color = nil
  self.title_stroke_color = nil
  self.title_shadow_color = nil
  self.desc_color = nil
  self.desc_stroke_color = nil
  self.desc_shadow_color = nil
  self.time_color = nil
  self.time_stroke_color = nil
  self.time_shadow_color = nil
  self.extra_para_color = nil
  self.free_banner = nil
  self.title_color_tab = nil
  self.title_stroke_color_tab = nil
  self.title_shadow_color_tab = nil
  self.desc_color_tab = nil
  self.desc_stroke_color_tab = nil
  self.desc_shadow_color_tab = nil
  self.time_color_tab = nil
  self.time_stroke_color_tab = nil
  self.time_shadow_color_tab = nil
  self.extra_para_color_tab = nil
  self.bp_pic_scale = 1
  self.monopoly_shop = nil
  self.monopoly_gridbox = nil
  self.banner_act = nil
  self.banner_effect = nil
  self.pic_guide = nil
  self.title_size = 0
  self.banner_sticker = ""
  self.newbanner_sticker = ""
  self.bg_mask = {}
  self.usebox_desc = {}
  self.usebox_list = {}
  self.usebox_item = 0
  self.usebox_btn = ""
  self._showEffect = 0
  self.banner_effect_front = ""
end

local function __delete(self)
  self.id = nil
  self.title_color = nil
  self.title_stroke_color = nil
  self.title_shadow_color = nil
  self.desc_color = nil
  self.desc_stroke_color = nil
  self.desc_shadow_color = nil
  self.time_color = nil
  self.time_stroke_color = nil
  self.time_shadow_color = nil
  self.extra_para_color = nil
  self.free_banner = nil
  self.title_color_tab = nil
  self.title_stroke_color_tab = nil
  self.title_shadow_color_tab = nil
  self.desc_color_tab = nil
  self.desc_stroke_color_tab = nil
  self.desc_shadow_color_tab = nil
  self.time_color_tab = nil
  self.time_stroke_color_tab = nil
  self.time_shadow_color_tab = nil
  self.extra_para_color_tab = nil
  self.bp_pic_scale = nil
  self.monopoly_shop = nil
  self.monopoly_gridbox = nil
  self.banner_act = nil
  self.banner_effect = nil
  self.pic_guide = nil
  self.title_size = nil
  self.banner_sticker = nil
  self.newbanner_sticker = nil
  self.bg_mask = nil
  self.usebox_desc = nil
  self.usebox_list = nil
  self.usebox_item = nil
  self.usebox_btn = nil
  self._showEffect = nil
  self.banner_effect_front = nil
end

local function InitData(self, row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.title_color = row:getValue("title_color") or ""
  self.title_stroke_color = row:getValue("title_stroke_color") or ""
  self.title_shadow_color = row:getValue("title_shadow_color") or ""
  self.title_material = row:getValue("title_material") or ""
  self.desc_color = row:getValue("desc_color") or ""
  self.desc_stroke_color = row:getValue("desc_stroke_color") or ""
  self.desc_shadow_color = row:getValue("desc_shadow_color") or ""
  self.time_color = row:getValue("time_color") or ""
  self.time_stroke_color = row:getValue("time_stroke_color") or ""
  self.time_shadow_color = row:getValue("time_shadow_color") or ""
  self.extra_para_color = row:getValue("extra_para_color") or ""
  self.free_banner = row:getValue("free_banner") or ""
  self.pic_spec1 = row:getValue("pic_spec1") or ""
  self.pic_spec2 = row:getValue("pic_spec2") or ""
  self.pic_spec3 = row:getValue("pic_spec3") or ""
  self.pic_spec4 = row:getValue("pic_spec4") or ""
  self.pic_spec5 = row:getValue("pic_spec5") or ""
  self.bp_pic_scale = tonumber(row:getValue("bp_pic_scale")) or 1
  self.monopoly_shop = row:getValue("monopoly_shop") or ""
  self.monopoly_gridbox = row:getValue("monopoly_gridbox") or ""
  self.banner_act = row:getValue("banner_act") or ""
  self.banner_effect = row:getValue("banner_effect") or ""
  self.banner_effect_bottom = row:getValue("banner_effect_bottom") or ""
  self.banner_effect2 = row:getValue("banner_effect2") or ""
  self.pic_guide = row:getValue("pic_guide") or ""
  self.title_size = tonumber(row:getValue("title_size")) or 0
  self.banner_sticker = row:getValue("banner_sticker") or ""
  local bg_mask_str = row:getValue("bg_mask") or ""
  if not string.IsNullOrEmpty(bg_mask_str) then
    self.bg_mask = string.split(bg_mask_str, "|")
  end
  local usebox_desc_str = row:getValue("usebox_desc") or ""
  if not string.IsNullOrEmpty(usebox_desc_str) then
    self.usebox_desc = string.split(usebox_desc_str, "|")
  end
  local usebox_list_str = row:getValue("usebox_list") or ""
  if not string.IsNullOrEmpty(usebox_list_str) then
    self.usebox_list = string.string2array_num_oneSep(usebox_list_str, "|")
  end
  self.usebox_item = tonumber(row:getValue("usebox_item")) or 0
  self.usebox_btn = row:getValue("usebox_btn") or ""
  self._showEffect = tonumber(row:getValue("is_effect")) or 0
  self.banner_effect_front = row:getValue("banner_effect_front") or ""
  self.newbanner_sticker = row:getValue("newbanner_sticker") or ""
  self:DealData()
end

local function DealData(self)
  local sep1 = ";"
  local sep2 = "|"
  self.title_color_tab = string.string2array_i_oneSep(self.title_color, sep1)
  self.title_stroke_color_tab = string.string2array_i_oneSep(self.title_stroke_color, sep1)
  self.title_shadow_color_tab = string.string2array_i_oneSep(self.title_shadow_color, sep1)
  self.desc_color_tab = string.string2array_i_oneSep(self.desc_color, sep1)
  self.desc_stroke_color_tab = string.string2array_i_oneSep(self.desc_stroke_color, sep1)
  self.desc_shadow_color_tab = string.string2array_i_oneSep(self.desc_shadow_color, sep1)
  self.time_color_tab = string.string2array_i_oneSep(self.time_color, sep1)
  self.time_stroke_color_tab = string.string2array_i_oneSep(self.time_stroke_color, sep1)
  self.time_shadow_color_tab = string.string2array_i_oneSep(self.time_shadow_color, sep1)
  self.extra_para_color_tab = string.string2array_i(self.extra_para_color, sep1, sep2)
end

ActivityShowConfigTemplate.__init = __init
ActivityShowConfigTemplate.__delete = __delete
ActivityShowConfigTemplate.InitData = InitData
ActivityShowConfigTemplate.DealData = DealData
return ActivityShowConfigTemplate
