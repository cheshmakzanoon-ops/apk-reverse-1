local PresentRecordInfo = BaseClass("PresentRecordInfo")
local PresentRecordInfoDetail = require("DataCenter.GovernmentManager.PresentRecordInfoDetail")

function PresentRecordInfo:__init()
  self.list = {}
  self.kingName = ""
  self.kingAbbr = ""
  self.kingUid = ""
end

function PresentRecordInfo:__delete()
  self.list = {}
  self.kingName = ""
  self.kingAbbr = ""
  self.kingUid = ""
end

function PresentRecordInfo:ParseData(message)
  if message == nil then
    return
  end
  if message.list then
    self.list = {}
    for _, v in ipairs(message.list) do
      local param = PresentRecordInfoDetail.New()
      param:ParseData(v)
      table.insert(self.list, param)
    end
  end
  if message.kingName then
    self.kingName = message.kingName
  end
  if message.kingAbbr then
    self.kingAbbr = message.kingAbbr
  end
  if message.kingUid then
    self.kingUid = message.kingUid
  end
end

function PresentRecordInfo:GetPresidentName()
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(self.kingUid, self.kingName)
  if self.kingAbbr ~= nil and self.kingAbbr ~= "" then
    return "[" .. self.kingAbbr .. "] " .. showName
  end
  return showName
end

function PresentRecordInfo:GetShowList()
  return self.list
end

return PresentRecordInfo
