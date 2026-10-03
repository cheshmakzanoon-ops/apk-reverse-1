local AnnounceInfo = BaseClass("AnnounceInfo")

function AnnounceInfo:__init(msg)
  self:RefreshData(msg)
end

function AnnounceInfo:__delete()
  self.combinationId = nil
  self.userArr = nil
end

local function __SortAnnounceUser(a, b)
  return a.recordTime < b.recordTime
end

function AnnounceInfo:RefreshData(msg)
  self.combinationId = msg.combinationId
  self.userArr = {}
  if msg.userArr then
    for _, userInfo in ipairs(msg.userArr) do
      table.insert(self.userArr, userInfo)
    end
    table.sort(self.userArr, __SortAnnounceUser)
  end
end

function AnnounceInfo:IsEmpty()
  return table.IsNullOrEmpty(self.userArr)
end

return AnnounceInfo
