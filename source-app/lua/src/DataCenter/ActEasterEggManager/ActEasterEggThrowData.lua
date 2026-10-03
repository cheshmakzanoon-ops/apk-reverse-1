local ActEasterEggThrowData = BaseClass("ActEasterEggThrowData")

function ActEasterEggThrowData:__init()
  self.type = 0
  self.context = ""
  self.contentCheck = false
  self.optionA = ""
  self.optionACheck = false
  self.optionB = ""
  self.optionBCheck = false
end

function ActEasterEggThrowData:__delete()
  self.type = nil
  self.context = nil
  self.contentCheck = nil
  self.optionA = nil
  self.optionACheck = nil
  self.optionB = nil
  self.optionBCheck = nil
end

function ActEasterEggThrowData:ParseThrowInfo(eggInfo)
  self.type = eggInfo.type
  self.context = eggInfo.context
  self.contentCheck = eggInfo.contentCheck
  self.optionA = eggInfo.optionA
  self.optionACheck = eggInfo.optionACheck
  self.optionB = eggInfo.optionB
  self.optionBCheck = eggInfo.optionBCheck
end

function ActEasterEggThrowData:CheckContent()
  return self.contentCheck, self.context
end

function ActEasterEggThrowData:CheckOptionA()
  return self.optionACheck, self.optionA
end

function ActEasterEggThrowData:CheckOptionB()
  return self.optionBCheck, self.optionB
end

return ActEasterEggThrowData
