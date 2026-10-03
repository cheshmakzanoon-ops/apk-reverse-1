local OfficialAppointItemTemplate = BaseClass("OfficialAppointItemTemplate")

local function __init(self)
  self.uid = ""
  self.name = ""
  self.pic = ""
  self.picver = 0
  self.headSkinId = 0
  self.headSkinET = 0
  self.abbr = ""
  self.appointTime = 0
  self.fireTime = 0
  self.allianceId = ""
  self:AddListener()
end

local function __delete(self)
  self.uid = nil
  self.name = nil
  self.pic = nil
  self.picver = nil
  self.headSkinId = nil
  self.headSkinET = nil
  self.abbr = nil
  self.appointTime = nil
  self.fireTime = nil
  self.allianceId = nil
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
  self.name = msg.name
  self.pic = msg.pic
  self.picver = msg.picver
  self.headSkinId = msg.headSkinId
  self.headSkinET = msg.headSkinET
  self.abbr = msg.abbr
  self.appointTime = msg.appointTime
  self.fireTime = msg.fireTime
  self.allianceId = msg.allianceId
end

local function GetFullName(self, uid)
  local showName = DataCenter.PlayerInfoDataManager:GetRemarkOrRealName(uid, self.name)
  if string.IsNullOrEmpty(self.abbr) then
    return showName
  else
    return "[" .. self.abbr .. "] " .. showName
  end
end

OfficialAppointItemTemplate.__init = __init
OfficialAppointItemTemplate.__delete = __delete
OfficialAppointItemTemplate.AddListener = AddListener
OfficialAppointItemTemplate.RemoveListener = RemoveListener
OfficialAppointItemTemplate.ParseData = ParseData
OfficialAppointItemTemplate.GetFullName = GetFullName
return OfficialAppointItemTemplate
