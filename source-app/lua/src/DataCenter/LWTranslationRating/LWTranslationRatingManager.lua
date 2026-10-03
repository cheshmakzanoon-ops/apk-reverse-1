local LWTranslationRatingManager = BaseClass("LWTranslationRatingManager")

function LWTranslationRatingManager:__init()
  self.scoreDic = {}
end

function LWTranslationRatingManager:__delete()
  self.scoreDic = nil
end

function LWTranslationRatingManager:Startup()
end

function LWTranslationRatingManager:InitData(msg)
  if msg.translate_mark ~= nil then
    local translate_mark = msg.translate_mark
    for pair in string.gmatch(translate_mark, "[^|]+") do
      local mailUid, score = string.match(pair, "([^,]+),([^,]+)")
      if mailUid and score then
        self.scoreDic[mailUid] = tonumber(score)
      end
    end
  end
end

function LWTranslationRatingManager:UpdateData(mailUid, score)
  self.scoreDic[mailUid] = score
end

function LWTranslationRatingManager:AlreadyScore(mailUid)
  return self.scoreDic[mailUid] ~= nil
end

return LWTranslationRatingManager
