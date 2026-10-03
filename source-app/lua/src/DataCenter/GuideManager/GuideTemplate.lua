local GuideTemplate = BaseClass("GuideTemplate")

function GuideTemplate:__init()
  self.id = 0
  self.triggertype = GuideTriggerType.None
  self.triggerpara = ""
  self.gotype = GuideGoType.None
  self.gobuild = 0
  self.type = GuideType.None
  self.para1 = ""
  self.forcetype = GuideForceType.Soft
  self.nextid = -1
  self.returnstepid = -1
  self.arrowtype = GuideArrowStyle.Finger
  self.para2 = ""
  self.arrowdirection = 0
  self.showcircletype = ShowCircleType.Show
  self.waittime = 0
  self.para3 = ""
  self.para4 = ""
  self.tipspic = ""
  self.tipsdirection = ""
  self.tipsposition = ""
  self.tipsdialog = ""
  self.dub = ""
  self.tipswaittime = 0
  self.savedoneid = 0
  self.gototime = ""
  self.para5 = ""
  self.jumptype = nil
  self.jumppara = nil
  self.jumpid = 0
  self.showquestinfo = GuideEndShowQuestType.Show
  self.bubblecontrol = 0
end

function GuideTemplate:__delete()
  self.id = nil
  self.triggertype = nil
  self.triggerpara = nil
  self.gotype = nil
  self.gobuild = nil
  self.type = nil
  self.para1 = nil
  self.forcetype = nil
  self.nextid = nil
  self.returnstepid = nil
  self.arrowtype = nil
  self.para2 = nil
  self.jumpid = nil
  self.arrowdirection = nil
  self.showcircletype = nil
  self.waittime = nil
  self.para3 = nil
  self.para4 = nil
  self.tipspic = nil
  self.tipsdirection = nil
  self.tipsposition = nil
  self.tipsdialog = nil
  self.dub = nil
  self.tipswaittime = nil
  self.savedoneid = nil
  self.gototime = nil
  self.para5 = nil
  self.jumptype = nil
  self.jumppara = nil
  self.showquestinfo = GuideEndShowQuestType.Show
  self.bubblecontrol = nil
end

function GuideTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = row:getValue("id")
  self.triggertype = row:getValue("triggertype")
  self.triggerpara = row:getValue("triggerpara")
  self.gotype = row:getValue("gotype")
  self.type = row:getValue("type")
  self.para1 = row:getValue("para1")
  self.forcetype = row:getValue("forcetype")
  self.nextid = row:getValue("nextid")
  self.returnstepid = row:getValue("returnstepid")
  self.arrowtype = row:getValue("arrowtype")
  self.para2 = row:getValue("para2")
  self.jumpid = row:getValue("jumpid")
  self.arrowdirection = row:getValue("arrowdirection")
  self.showcircletype = row:getValue("showcircletype")
  self.waittime = row:getValue("waittime")
  self.para3 = row:getValue("para3")
  self.para4 = row:getValue("para4")
  self.tipspic = row:getValue("tipspic")
  self.tipsdirection = row:getValue("tipsdirection")
  self.tipsposition = row:getValue("tipsposition")
  self.tipsdialog = row:getValue("tipsdialog")
  self.dub = row:getValue("dub")
  self.tipswaittime = row:getValue("tipswaittime")
  self.savedoneid = row:getValue("savedoneid")
  self.gototime = row:getValue("gototime")
  self.para5 = row:getValue("para5")
  self.jumptype = row:getValue("jumptype")
  self.jumppara = row:getValue("jumppara")
  self.showquestinfo = row:getValue("showquestinfo")
  self.bubblecontrol = row:getValue("showquestinfo")
end

function GuideTemplate:GetAutoDoNextTime()
  local time = 0
  if (self.type == GuideType.ShowTalk or self.type == GuideType.ShowGuideTip or self.type == GuideType.ShowCommunicationTalk) and self.para1 ~= nil and self.para1 ~= "" then
    time = tonumber(self.para1)
  end
  return time
end

function GuideTemplate:CanShowQuest()
  local isNewOpen = DataCenter.ChapterTaskCellManager:CheckNewSwitch()
  if isNewOpen then
    return self.bubblecontrol == GuideEndShowQuestType.Show
  else
    return self.showquestinfo == GuideEndShowQuestType.Show
  end
end

return GuideTemplate
