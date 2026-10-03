local ActivityFesSongTemplate = BaseClass("ActivityFesSongTemplate")

function ActivityFesSongTemplate:__init()
  self.id = 0
  self.sound_id = 0
  self.name_key = ""
  self.bpm = 0
  self.time = 0
  self.space = 0
  self.combo_max = 0
  self.score_max = 0
  self.offset = ""
  self.success_area = nil
  self.perfect_area = nil
  self.verify = nil
  self.drop_time = 0
  self.beats = 1
  self.note_group = {}
  self.combo_score = {}
  self.bpm_act = 1
  self.finished_point = 0
  self.disappear_time = 0
  self.blank_time = 0
end

function ActivityFesSongTemplate:__delete()
  self.id = nil
  self.sound_id = nil
  self.name_key = nil
  self.bpm = nil
  self.time = nil
  self.space = nil
  self.combo_max = nil
  self.score_max = nil
  self.offset = nil
  self.success_area = nil
  self.perfect_area = nil
  self.verify = nil
  self.drop_time = nil
  self.beats = nil
  self.note_group = nil
  self.combo_score = nil
  self.bpm_act = nil
  self.finished_point = nil
  self.disappear_time = nil
  self.blank_time = nil
end

function ActivityFesSongTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.sound_id = rowData:getValue("sound_id") or 0
  self.name_key = rowData:getValue("name_key") or ""
  self.bpm = rowData:getValue("bpm") or 0
  self.time = rowData:getValue("time") or 0
  self.space = rowData:getValue("space") or 0
  self.combo_max = rowData:getValue("combo_max") or 0
  self.score_max = rowData:getValue("score_max") or 0
  self.offset = rowData:getValue("offset") or ""
  self.success_area = rowData:getValue("success_area") or {}
  self.perfect_area = rowData:getValue("perfect_area") or {}
  self.verify = rowData:getValue("verify") or {}
  self.drop_time = rowData:getValue("drop_time") or 0
  self.beats = rowData:getValue("beats") or 1
  self.note_group = rowData:getValue("note_group") or {}
  self.score = rowData:getValue("score") or {}
  self.combo_score = rowData:getValue("combo_score") or {}
  self.bpm_act = rowData:getValue("bpm_act") or 1
  self.finished_point = rowData:getValue("finished_point") or 0
  self.disappear_time = rowData:getValue("disappear_time") or 0
  self.blank_time = rowData:getValue("blank_time") or 0
end

return ActivityFesSongTemplate
