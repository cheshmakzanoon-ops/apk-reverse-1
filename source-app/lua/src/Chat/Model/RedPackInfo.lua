local RedPackInfo = BaseClass("RedPackInfo")

function RedPackInfo:__init()
  self.rawData = nil
  self.uuid = ""
  self.server = 0
  self.status = 0
  self.uid = ""
  self.name = ""
  self.total = 0
  self.cost = 0
  self.curPeople = 0
  self.totalPeople = 0
  self.picV = 0
  self.pic = ""
  self.time = 0
  self.record = {}
  self.recordGold = 0
end

function RedPackInfo:setStatus(status)
  self.status = status
end

return RedPackInfo
