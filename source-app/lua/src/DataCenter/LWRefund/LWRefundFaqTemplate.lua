local LWRefundFaqTemplate = BaseClass("LWRefundFaqTemplate")

function LWRefundFaqTemplate:__init()
  self.id = 0
  self.question = ""
  self.answer = ""
  self.para1 = ""
end

function LWRefundFaqTemplate:__delete()
  self.id = nil
  self.question = nil
  self.answer = nil
  self.para1 = nil
end

function LWRefundFaqTemplate:InitData(row)
  if row == nil then
    return
  end
  self.id = tonumber(row:getValue("id")) or 0
  self.question = row:getValue("question") or ""
  self.answer = row:getValue("answer") or ""
  self.para1 = row:getValue("para1") or ""
end

return LWRefundFaqTemplate
