local StringBuilder = BaseClass("StringBuilder")

function StringBuilder:__init()
  self.buffer = {}
end

function StringBuilder:__delete()
  self.list = nil
end

function StringBuilder:Append(str)
  table.insert(self.buffer, str)
  return self
end

function StringBuilder:AppendLine(str)
  table.insert(self.buffer, str)
  table.insert(self.buffer, "\n")
  return self
end

function StringBuilder:AppendFormat(format, ...)
  table.insert(self.buffer, string.format(format, ...))
  return self
end

function StringBuilder:AppendFormatLine(format, ...)
  table.insert(self.buffer, string.format(format, ...))
  table.insert(self.buffer, "\n")
  return self
end

function StringBuilder:AppendLineFormat(format, ...)
  return self:AppendFormatLine(format, ...)
end

function StringBuilder:ToString()
  return table.concat(self.buffer)
end

function StringBuilder:Clear()
  self.buffer = {}
  return self
end

return StringBuilder
