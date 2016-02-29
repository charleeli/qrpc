class.Chat()

function Chat:_init(obj)
    self.type = obj.type or 0
    self.uuid = obj.uuid or 0
    self.name = obj.name or ""
    self.time = obj.time or 0
    self.msg = obj.msg or ""
    self.info = obj.info or {}
end

return Chat
