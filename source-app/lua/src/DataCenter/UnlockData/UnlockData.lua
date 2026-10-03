local UnlockData = BaseClass("UnlockData")
local Localization = CS.GameEntry.Localization

local function __init(self)
  self.title = ""
  self.icon = ""
  self.intro = ""
  self.type = ""
  self.flyEndPos = nil
  self.btnType = 0
end

local function __delete(self)
  self.title = nil
  self.icon = nil
  self.intro = nil
  self.type = nil
  self.flyEndPos = nil
  self.btnType = nil
end

local function UpdateData(self, title, icon, intro, type, flyEndPos)
  self.title = title or Localization:GetString("115634")
  self.icon = icon or ""
  self.intro = Localization:GetString("115635", intro)
  self.type = type or ""
  self.flyEndPos = flyEndPos
end

local function UpdateGuideBtnData(self, title, intro, btnType)
  self.title = title
  self.intro = intro
  self.btnType = btnType
  self.type = UnlockWindowType.GuideBtn
end

UnlockData.__init = __init
UnlockData.__delete = __delete
UnlockData.UpdateData = UpdateData
UnlockData.UpdateGuideBtnData = UpdateGuideBtnData
return UnlockData
