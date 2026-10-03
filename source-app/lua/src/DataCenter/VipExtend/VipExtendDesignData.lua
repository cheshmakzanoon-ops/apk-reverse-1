local VipExtendDesignData = BaseClass("VipExtendDesignData")

function VipExtendDesignData:__init()
  self.stage = 0
  self.subStage = 0
  self.picVerList = {}
  self.keywords = ""
  self.minWeek = 0
  self.maxWeek = 0
  self.anonymity = 0
end

function VipExtendDesignData:__delete()
  self.stage = nil
  self.subStage = nil
  self.picVerList = nil
  self.minWeek = nil
  self.maxWeek = nil
  self.keywords = nil
  self.anonymity = nil
end

function VipExtendDesignData:UpdateData(message)
  self.stage = message.stage or self.stage
  self.subStage = message.subStage or self.subStage
  self.picVerList = message.picVerList or self.picVerList
  self.minWeek = message.minWeek
  self.maxWeek = message.maxWeek
  self.keywords = message.keywords or self.keywords
  self.anonymity = message.anonymity or self.anonymity
end

return VipExtendDesignData
