local UserNpcQuestionnaireMessage = BaseClass("UserNpcQuestionnaireMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, id, QuestionObj)
  base.OnCreate(self)
  local quest = SFSArray.New()
  for k, v in pairs(QuestionObj) do
    local obj = SFSObject.New()
    obj:PutInt("question", k)
    obj:PutInt("answer", v)
    quest:AddSFSObject(obj)
  end
  self.sfsObj:PutSFSArray("questionArr", quest)
  self.sfsObj:PutInt("id", id)
end

local function HandleMessage(self, t)
  base.HandleMessage(self, t)
  local errCode = t.errorCode
  if errCode ~= nil then
    UIUtil.ShowTipsId(errCode)
  else
    DataCenter.QNManager:InitQNData(t)
    if t.reward ~= nil then
      DataCenter.RewardManager:AddRewardsAndRes(t)
      DataCenter.RewardManager:ShowCommonReward(t)
    end
  end
end

UserNpcQuestionnaireMessage.OnCreate = OnCreate
UserNpcQuestionnaireMessage.HandleMessage = HandleMessage
return UserNpcQuestionnaireMessage
