local ActGhostreconStealInfo = BaseClass("ActGhostreconStealInfo")

local function __init(self)
  self:AddListener()
  self.uid = ""
  self.time = 0
  self.name = ""
  self.abbr = ""
  self.headPic = ""
  self.headPicVer = 0
  self.msgId = 0
  self.reward = {}
  self.headSkinId = 0
  self.headSkinET = 0
end

local function __delete(self)
  self.uid = nil
  self.time = nil
  self.name = nil
  self.abbr = nil
  self.headPic = nil
  self.headPicVer = nil
  self.msgId = nil
  self.reward = nil
  self.headSkinId = nil
  self.headSkinET = nil
  self:RemoveListener()
end

local function AddListener(self)
end

local function RemoveListener(self)
end

local function ParseData(self, msg)
  if msg == nil then
    return
  end
  self.uid = msg.uid
  self.time = msg.time
  self.name = msg.name
  self.abbr = msg.abbr
  self.headPic = msg.headPic
  self.headPicVer = msg.headPicVer
  self.msgId = msg.msgId
  self.reward = msg.reward
  self.headSkinId = msg.headSkinId
  self.headSkinET = msg.headSkinET
end

ActGhostreconStealInfo.__init = __init
ActGhostreconStealInfo.__delete = __delete
ActGhostreconStealInfo.AddListener = AddListener
ActGhostreconStealInfo.RemoveListener = RemoveListener
ActGhostreconStealInfo.ParseData = ParseData
return ActGhostreconStealInfo
