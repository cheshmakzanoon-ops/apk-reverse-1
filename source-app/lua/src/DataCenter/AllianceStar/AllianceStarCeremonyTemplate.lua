local AllianceStarCeremonyTemplate = BaseClass("AllianceStarCeremonyTemplate")

local function __init(self)
  self.id = 0
  self.stateId = 0
  self.innerStateId = 0
  self.duration = 0
  self.dialogMode = nil
  self.dialogParam = nil
  self.dialogGroup = nil
  self.bgmId = nil
  self.sfxId = nil
  self.allyRandomAnim = nil
  self.param1 = nil
  self.param2 = nil
end

local function __delete(self)
  self.id = nil
  self.stateId = nil
  self.innerStateId = nil
  self.duration = nil
  self.dialogMode = nil
  self.dialogGroup = nil
  self.bgmId = nil
  self.sfxId = nil
  self.allyRandomAnim = nil
  self.param1 = nil
  self.param2 = nil
end

local function ParseData(self, cfg)
  self.id = cfg:getValue("id")
  self.stateId = cfg:getValue("stateId")
  self.innerStateId = cfg:getValue("InnerStateId")
  self.duration = tonumber(cfg:getValue("duration")) * 1000
  self.dialogMode = cfg:getValue("dialog_mode")
  self.dialogGroup = cfg:getValue("playscript")
  self.bgmId = cfg:getValue("bgm")
  self.sfxId = cfg:getValue("sfx")
  self.param1 = cfg:getValue("param1")
  self.param2 = cfg:getValue("param2")
  local allyRandomAnim = cfg:getValue("allyRandomAnim")
  if not string.IsNullOrEmpty(allyRandomAnim) then
    local split1 = string.split(allyRandomAnim, "|")
    self.allyRandomAnim = {}
    for _, v in ipairs(split1) do
      local split2 = string.split(v, ";")
      local info = {}
      info.cd = tonumber(split2[1])
      info.animList = {}
      for i = 2, #split2 do
        table.insert(info.animList, split2[i])
      end
      table.insert(self.allyRandomAnim, info)
    end
  end
end

AllianceStarCeremonyTemplate.__init = __init
AllianceStarCeremonyTemplate.__delete = __delete
AllianceStarCeremonyTemplate.ParseData = ParseData
return AllianceStarCeremonyTemplate
