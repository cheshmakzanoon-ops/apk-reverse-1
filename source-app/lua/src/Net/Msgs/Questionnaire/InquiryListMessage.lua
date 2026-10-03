local InquiryListMessage = BaseClass("InquiryListMessage", SFSBaseMessage)
local base = SFSBaseMessage

function InquiryListMessage:OnCreate()
  base.OnCreate(self)
end

function InquiryListMessage:HandleMessage(message)
  base.HandleMessage(self, message)
  DataCenter.LWQuestionnaireManager:UpdateQuestionnaireInfo(message)
end

return InquiryListMessage
