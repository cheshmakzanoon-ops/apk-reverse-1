local BattleBehaviorData = BaseClass("BattleBehaviorData")

function BattleBehaviorData:__init()
  self.type = 0
  self.uid = ""
  self.pic = ""
  self.picVer = 0
  self.leftScore = 0
  self.cityId = 0
  self.score = 0
  self.rightPlayerArray = {}
end

function BattleBehaviorData:__delete()
  self.type = 0
  self.uid = ""
  self.leftPic = ""
  self.picVer = 0
  self.leftScore = 0
  self.cityId = 0
  self.score = 0
  self.rightPlayerArray = {}
end

function BattleBehaviorData:ParseData(message)
  if message == nil then
    return
  end
  if message.type ~= nil then
    self.type = message.type
  end
  if message.leftUid ~= nil then
    self.uid = message.leftUid
  end
  if message.leftPic ~= nil then
    self.leftPic = message.leftPic
  end
  if message.leftPicVer ~= nil then
    self.picVer = message.leftPicVer
  end
  if message.leftScore ~= nil then
    self.leftScore = message.leftScore
  end
  if message.cityId ~= nil then
    self.cityId = message.cityId
  end
  if message.score ~= nil then
    self.score = message.score
  end
  if message.overflowScore ~= nil then
    self.score = message.overflowScore
  end
  if message.pickUpScore ~= nil then
    self.score = message.pickUpScore
  end
  if message.collectScore ~= nil then
    self.score = message.collectScore
  end
  if message.firstOccupyAddScore ~= nil then
    self.score = message.firstOccupyAddScore
  end
  local rightPlayerArray = message.rightPlayerArray
  if rightPlayerArray ~= nil then
    self.rightPlayerArray = {}
    for _, v in pairs(rightPlayerArray) do
      table.insert(self.rightPlayerArray, {
        uid = v.uid,
        pic = v.pic,
        picVer = v.picVer,
        rank = v.rank
      })
    end
  end
end

return BattleBehaviorData
