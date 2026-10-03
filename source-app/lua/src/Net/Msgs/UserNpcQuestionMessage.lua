local UserNpcQuestionMessage = BaseClass("UserNpcQuestionMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, question, answer)
  base.OnCreate(self)
  self.sfsObj:PutLong("question", question)
  self.sfsObj:PutLong("answer", answer)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  DataCenter.NpcQAManager:DoWhenQAResultBack(t)
end

UserNpcQuestionMessage.OnCreate = OnCreate
UserNpcQuestionMessage.HandleMessage = HandleMessage
return UserNpcQuestionMessage
