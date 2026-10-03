local RedPoint = BaseClass("SeasonMastery", RedPointNode)
local SeasonRedPointUtils = require("UI.LWSeason.LWSeasonMain.Utils.SeasonRedPointUtils")

function RedPoint:__init(nodeName)
  self:AddListener(EventId.LWMasterySkillUp, self.Update)
  self:AddListener(EventId.MasteryUseSkill, self.Update)
  self:AddListener(EventId.LWMasteryChangeMsgGet, self.Update)
  self:AddListener(EventId.SeasonMasteryView, self.Update)
end

function RedPoint:SetData()
  self:Update()
end

function RedPoint:Update()
  self:SetCountBoolean(SeasonRedPointUtils.IsShowMasteryRedPoint())
end

return RedPoint
