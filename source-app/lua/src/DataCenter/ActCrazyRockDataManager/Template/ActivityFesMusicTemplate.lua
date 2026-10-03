local ActivityFesMusicTemplate = BaseClass("ActivityFesMusicTemplate")

function ActivityFesMusicTemplate:__init()
  self.id = 0
  self.blank_time = 0
  self.song_list = ""
  self.guide = ""
  self.reward = ""
  self.hit_time = 0
  self.cost = ""
  self.share_cd = 0
  self.main_bgm = 0
  self.showId = 1
  self.calibration_song = 0
  self.adjust_note_show = {}
  self.hide_model_song_list = {}
end

function ActivityFesMusicTemplate:__delete()
  self.id = nil
  self.blank_time = nil
  self.song_list = nil
  self.guide = nil
  self.reward = nil
  self.hit_time = nil
  self.cost = nil
  self.share_cd = 0
  self.main_bgm = nil
  self.showId = nil
  self.calibration_song = 0
  self.adjust_note_show = nil
  self.hide_model_song_list = nil
end

function ActivityFesMusicTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.blank_time = rowData:getValue("blank_time") or 0
  self.song_list = rowData:getValue("song_list") or ""
  self.guide = rowData:getValue("guide") or ""
  self.reward = rowData:getValue("reward") or ""
  self.hit_time = rowData:getValue("hit_time") or 0
  self.cost = rowData:getValue("cost") or ""
  self.share_cd = rowData:getValue("share_cd") or 0
  self.main_bgm = rowData:getValue("main_bgm") or 0
  self.showId = rowData:getValue("showId") or 1
  self.calibration_song = rowData:getValue("calibration_song") or 1
  self.adjust_note_show = rowData:getValue("adjust_note_show") or {}
  self.hide_model_song_list = rowData:getValue("hide_model_song_list") or {}
end

return ActivityFesMusicTemplate
