local ActivitySurvivorListTemplate = BaseClass("ActivitySurvivorListTemplate")

function ActivitySurvivorListTemplate:__init(info)
  self.id = 0
  self.group = ""
  self.free = ""
  self.exchange = ""
  self.day = ""
  self.visitor_id = ""
  self.job = ""
  self.quality = ""
  self.subtitle = ""
  self.title = ""
  self.worker_id = ""
  self.title_free = ""
  self.title_pay = ""
  self:InitData(info)
end

function ActivitySurvivorListTemplate:__delete()
  self.id = nil
  self.group = nil
  self.free = nil
  self.exchange = nil
  self.day = nil
  self.visitor_id = nil
  self.job = nil
  self.quality = nil
  self.subtitle = nil
  self.title = nil
  self.worker_id = nil
  self.title_free = nil
  self.title_pay = nil
end

function ActivitySurvivorListTemplate:InitData(lineData)
  if lineData == nil then
    return
  end
  self.id = lineData:getValue("id") or 0
  self.group = lineData:getValue("group") or ""
  self.free = lineData:getValue("free") or ""
  self.exchange = lineData:getValue("exchange") or ""
  self.day = lineData:getValue("day") or ""
  self.visitor_id = lineData:getValue("visitor_id") or ""
  self.job = lineData:getValue("job") or ""
  self.quality = lineData:getValue("quality") or ""
  self.subtitle = lineData:getValue("subtitle") or ""
  self.title = lineData:getValue("title") or ""
  self.worker_id = lineData:getValue("worker_id") or ""
  self.title_free = lineData:getValue("title_free") or ""
  self.title_pay = lineData:getValue("title_pay") or ""
end

return ActivitySurvivorListTemplate
