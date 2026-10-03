local UILWRemarkNameData = BaseClass("UILWRemarkNameData")

function UILWRemarkNameData:__init()
  self.targetUid = 0
  self.remark = 0
  self.lastUpdateTime = 0
end

function UILWRemarkNameData:__delete()
  self.targetUid = nil
  self.remark = nil
  self.lastUpdateTime = nil
end

function UILWRemarkNameData:ParseData(msg)
  if msg == nil then
    return
  end
  if msg.targetUid ~= nil then
    self.targetUid = msg.targetUid
  end
  if msg.remark ~= nil then
    self.remark = msg.remark
  end
  if msg.lastUpdateTime ~= nil then
    self.lastUpdateTime = msg.lastUpdateTime
  end
end

function UILWRemarkNameData:GetPlayerUid()
  return self.targetUid
end

function UILWRemarkNameData:GetRemarkName()
  return self.remark
end

function UILWRemarkNameData:GetLastUpdateTime()
  return self.lastUpdateTime
end

function UILWRemarkNameData:SetPlayerUid(targetUid)
  self.targetUid = targetUid
end

function UILWRemarkNameData:SetRemarkName(remark)
  self.remark = remark
end

function UILWRemarkNameData:SetLastUpdateTime(lastUpdateTime)
  self.lastUpdateTime = lastUpdateTime
end

return UILWRemarkNameData
