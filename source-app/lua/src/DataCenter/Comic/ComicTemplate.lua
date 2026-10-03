local ComicTemplate = BaseClass("ComicTemplate")

function ComicTemplate:__init()
  self.id = 0
  self.pic = ""
  self.dialogList = {}
  self.asideList = {}
  self.dialogLocalPos = {}
  self.spine = ""
  self.dialogSizeList = {}
  self.dialogInTimeList = {}
  self.picPos = nil
  self.video = ""
  self.audio = 0
  self.subtitles = {}
end

function ComicTemplate:__delete()
  self.id = nil
  self.pic = nil
  self.dialogList = nil
  self.asideList = nil
  self.dialogLocalPos = nil
  self.spine = nil
  self.dialogSizeList = nil
  self.dialogInTimeList = nil
  self.picPos = nil
  self.video = nil
  self.audio = nil
  self.subtitles = nil
end

function ComicTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.pic = row:getValue("pic") or ""
  self.spine = row:getValue("spine") or ""
  self.video = row:getValue("video") or ""
  self.audio = row:getValue("audio") or 0
  self.dialogList = {}
  local dialog = row:getValue("dialog") or ""
  if not string.IsNullOrEmpty(dialog) then
    local dialogStr = string.split(dialog, ";")
    table.walk(dialogStr, function(k, v)
      table.insert(self.dialogList, v)
    end)
  end
  self.asideList = {}
  local aside = row:getValue("aside") or ""
  if string.IsNullOrEmpty(self.video) then
    if not string.IsNullOrEmpty(aside) then
      local asideStr = string.split(aside, ";")
      table.walk(asideStr, function(k, v)
        table.insert(self.asideList, v)
      end)
    end
  else
    self.subtitles = self:ParseComicConfig(aside)
  end
  self.dialogLocalPos = {}
  local dialog_position = row:getValue("dialog_position") or ""
  if not string.IsNullOrEmpty(dialog_position) then
    local posStr = string.split(dialog_position, ";")
    table.walk(posStr, function(k, v)
      local pos = string.split(v, ",")
      table.insert(self.dialogLocalPos, {
        x = pos[1],
        y = pos[2]
      })
    end)
  end
  self.dialogSizeList = {}
  local dialog_size = row:getValue("dialog_size") or ""
  if not string.IsNullOrEmpty(dialog_size) then
    local size = string.split(dialog_size, ";")
    table.walk(size, function(k, v)
      local pos = string.split(v, ",")
      table.insert(self.dialogSizeList, Vector2.New(pos[1], pos[2]))
    end)
  end
  self.dialogInTimeList = {}
  local dialog_in_time = row:getValue("dialog_in_time") or ""
  if not string.IsNullOrEmpty(dialog_in_time) then
    local inTimeStar = string.split(dialog_in_time, ";")
    table.walk(inTimeStar, function(k, v)
      table.insert(self.dialogInTimeList, v)
    end)
  end
  local picPos = row:getValue("pic_position") or ""
  if not string.IsNullOrEmpty(picPos) then
    local pos = string.split(picPos, ",")
    self.picPos = Vector2.New(pos[1], pos[2])
  end
end

function ComicTemplate:ParseComicConfig(str)
  local result = {}
  for item in string.gmatch(str, "[^;]+") do
    local startTime, endTime, textId = item:match("([^,]+),([^,]+),([^,]+)")
    table.insert(result, {
      textId = textId,
      startTime = tonumber(startTime),
      endTime = tonumber(endTime)
    })
  end
  return result
end

return ComicTemplate
