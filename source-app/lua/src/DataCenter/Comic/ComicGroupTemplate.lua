local ComicGroupTemplate = BaseClass("ComicGroupTemplate")

function ComicGroupTemplate:__init()
  self.id = 0
  self.open_type = 0
  self.para = {}
  self.plot_id = 0
  self.comicListId = {}
end

function ComicGroupTemplate:__delete()
  self.id = nil
  self.open_type = nil
  self.para = nil
  self.plot_id = nil
  self.comicListId = nil
end

function ComicGroupTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.open_type = tonumber(row:getValue("open_type")) or 0
  self.plot_id = tonumber(row:getValue("plot_id")) or 0
  self.comicListId = {}
  local comicId = row:getValue("comic_id") or ""
  if not string.IsNullOrEmpty(comicId) then
    local list = string.split(comicId, ",")
    table.walk(list, function(k, v)
      table.insert(self.comicListId, tonumber(v))
    end)
  end
  self.para = {}
  local para = row:getValue("para") or ""
  if not string.IsNullOrEmpty(para) then
    local list = string.split(para, ",")
    table.walk(list, function(k, v)
      table.insert(self.para, tonumber(v))
    end)
  end
end

return ComicGroupTemplate
