local ActGhostreconMemberHeroInfo = BaseClass("ActGhostreconMemberHeroInfo")

local function __init(self)
  self.heroId = 0
  self.level = 0
  self.rank = 0
  self.uuid = nil
  self:AddListener()
end

local function __delete(self)
  self.heroId = nil
  self.level = nil
  self.rank = nil
  self.uuid = nil
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
  self.heroId = msg.heroId
  self.level = msg.level
  self.rank = msg.rank
  self.uuid = msg.uuid
end

ActGhostreconMemberHeroInfo.__init = __init
ActGhostreconMemberHeroInfo.__delete = __delete
ActGhostreconMemberHeroInfo.AddListener = AddListener
ActGhostreconMemberHeroInfo.RemoveListener = RemoveListener
ActGhostreconMemberHeroInfo.ParseData = ParseData
return ActGhostreconMemberHeroInfo
