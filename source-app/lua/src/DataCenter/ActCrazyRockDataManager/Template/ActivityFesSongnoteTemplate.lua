local ActivityFesSongnoteTemplate = BaseClass("ActivityFesSongnoteTemplate")

function ActivityFesSongnoteTemplate:__init()
  self.id = 0
  self.song_id = 0
  self.timeline = ""
  self.meter = ""
  self.note_type = ""
  self.hit_max = ""
  self.note_sound = {}
end

function ActivityFesSongnoteTemplate:__delete()
  self.id = nil
  self.song_id = nil
  self.timeline = nil
  self.meter = nil
  self.note_type = nil
  self.hit_max = nil
  self.note_sound = nil
end

function ActivityFesSongnoteTemplate:UpdateData(rowData)
  if rowData == nil then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.song_id = rowData:getValue("song_id") or 0
  self.timeline = rowData:getValue("timeline") or ""
  self.meter = rowData:getValue("meter") or ""
  self.note_type = rowData:getValue("note_type") or ""
  self.hit_max = rowData:getValue("hit_max") or {}
  self.note_sound = rowData:getValue("note_sound") or {}
end

return ActivityFesSongnoteTemplate
