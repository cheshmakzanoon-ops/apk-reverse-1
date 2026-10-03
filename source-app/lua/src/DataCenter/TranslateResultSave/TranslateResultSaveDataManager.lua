local TranslateResultSaveDataManager = BaseClass("TranslateResultSaveDataManager")

function TranslateResultSaveDataManager:__init()
  self.saveData = {}
end

function TranslateResultSaveDataManager:__delete()
  self.saveData = nil
end

function TranslateResultSaveDataManager:SaveTranslateResult(funcType, uuid, resultTxt)
  if self.saveData[funcType] == nil then
    self.saveData[funcType] = {}
  end
  if self.saveData[funcType][uuid] == nil then
    self.saveData[funcType][uuid] = {}
  end
  self.saveData[funcType][uuid].state = TranslateStateType.TranslationCompleted
  self.saveData[funcType][uuid].txt = resultTxt
end

function TranslateResultSaveDataManager:GetTranslateResult(funcType, uuid)
  local state = TranslateStateType.NotTranslated
  local resultTxt
  if self.saveData[funcType] and self.saveData[funcType][uuid] then
    state = self.saveData[funcType][uuid].state
    resultTxt = self.saveData[funcType][uuid].txt
  end
  return state, resultTxt
end

function TranslateResultSaveDataManager:SetTranslateStateDoing(funcType, uuid)
  if self.saveData[funcType] == nil then
    self.saveData[funcType] = {}
  end
  if self.saveData[funcType][uuid] == nil then
    self.saveData[funcType][uuid] = {}
  end
  self.saveData[funcType][uuid].state = TranslateStateType.Translating
end

function TranslateResultSaveDataManager:ClearTranslateResult(funcType, uuid)
  if self.saveData[funcType] and self.saveData[funcType][uuid] then
    self.saveData[funcType][uuid] = nil
  end
end

function TranslateResultSaveDataManager:ClearAllDoingState(funcType)
  if self.saveData[funcType] then
    for k, v in pairs(self.saveData[funcType]) do
      if v.state == TranslateStateType.Translating and v.txt == nil then
        self.saveData[funcType][k] = nil
      end
    end
  end
end

return TranslateResultSaveDataManager
