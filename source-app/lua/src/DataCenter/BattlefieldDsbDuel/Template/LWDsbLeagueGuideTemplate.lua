local LWDsbLeagueGuideTemplate = BaseClass("LWDsbLeagueGuideTemplate")

function LWDsbLeagueGuideTemplate:__init()
  self.id = 0
  self.type = 0
  self.sub_type = 0
  self.sequence = 0
  self.pic = ""
  self.tittle = ""
  self.desc = ""
  self.buttons = ""
  self.button_detail = ""
  self.jump_type = ""
  self.buttonsKeyList = {}
  self.buttonsDetailList = {}
  self.buttonsJumpTypeList = {}
end

function LWDsbLeagueGuideTemplate:__delete()
  self.id = nil
  self.type = nil
  self.sub_type = nil
  self.sequence = nil
  self.pic = nil
  self.tittle = nil
  self.desc = nil
  self.buttons = nil
  self.button_detail = nil
  self.jump_type = nil
  self.buttonsKeyList = nil
  self.buttonsDetailList = nil
  self.buttonsJumpTypeList = nil
end

function LWDsbLeagueGuideTemplate:UpdateData(rowData)
  if not rowData then
    return
  end
  self.id = rowData:getValue("id") or 0
  self.type = rowData:getValue("type") or 0
  self.sub_type = rowData:getValue("sub_type") or 0
  self.sequence = rowData:getValue("sequence") or 0
  self.pic = rowData:getValue("pic") or ""
  self.tittle = rowData:getValue("tittle") or ""
  self.desc = rowData:getValue("desc") or ""
  self.buttons = rowData:getValue("buttons") or ""
  self.button_detail = rowData:getValue("button_detail") or ""
  self.jump_type = rowData:getValue("jump_type") or ""
  if not string.IsNullOrEmpty(self.buttons) then
    self.buttonsKeyList = string.split(self.buttons, ",")
  end
  if not string.IsNullOrEmpty(self.button_detail) then
    self.buttonsDetailList = string.split(self.button_detail, ",")
  end
  if not string.IsNullOrEmpty(self.jump_type) then
    self.buttonsJumpTypeList = string.split(self.jump_type, ",")
  end
end

return LWDsbLeagueGuideTemplate
